' Controller extensions for the catalog, local library and language choices.
sub ensureLibraryState()
    if type(m.library) <> "roAssociativeArray" then m.library = rpUserLibraryNormalize(invalid)
    m.watchlistItems = m.library.watchlist
    m.continueItems = m.library.history
    if GetInterface(m.catalogCategory,"ifString") = invalid then m.catalogCategory = "all"
    if GetInterface(m.liveCategory,"ifString") = invalid then m.liveCategory = "all"
    if type(m.catalogItems) <> "roArray" then m.catalogItems = []
    if type(m.detailSources) <> "roArray" then m.detailSources = []
    for each key in ["catalogCategoryCursor","liveCategoryCursor","browseSearchCursor","watchlistCursor","continueCursor","mediaPrefsCursor"]
        if GetInterface(m[key],"ifInt") = invalid then m[key] = 0
    end for
end sub

sub openWatchlist(preserve = false as boolean)
    cancelRequest()
    stopLivePreview()
    ensureLibraryState()
    if not preserve then m.watchlistCursor = 0
    if m.watchlistCursor >= m.watchlistItems.count() then m.watchlistCursor = m.watchlistItems.count()-1
    if m.watchlistCursor < 0 then m.watchlistCursor = 0
    m.nav = 4
    m.view = "watchlist"
    m.zone = "watchlist"
    if m.watchlistItems.count() = 0 then m.zone = "nav"
    m.note = ""
    drawScreen()
end sub

sub toggleMovieWatchlist()
    ensureLibraryState()
    result = rpUserToggleWatchlist(m.library,m.detail)
    if result.ok
        if rpUserSaveLibrary(result.library)
            m.library = result.library
            m.note = "Título quitado de Mi lista."
            if result.added then m.note = "Título guardado en Mi lista."
        else
            m.note = "No se pudo guardar Mi lista en esta Roku."
        end if
    else
        m.note = result.message
    end if
    ensureLibraryState()
    if m.noteTimer <> invalid then m.noteTimer.control = "start"
    drawScreen()
end sub

sub saveVodProgress(force as boolean)
    if type(m.playingItem) <> "roAssociativeArray" then return
    if m.playingItem.kind = "live" then return
    position = orbitInteger(m.lastPlaybackPosition,86400)
    if position < 5 then return
    previous = orbitInteger(m.lastProgressWrite,86400,-1)
    previousAttempt = orbitInteger(m.lastProgressAttempt,86400,-1)
    duration = orbitInteger(m.lastPlaybackDuration,86400)
    itemKey = rpUserItemKey(m.playingItem)
    if force and m.lastProgressSaved = true and m.lastProgressItemKey = itemKey and previous = position and m.lastProgressDuration = duration then return
    if not force and previousAttempt >= 0
        if abs(position-previousAttempt) < 30 then return
    end if
    ensureLibraryState()
    nextLibrary = rpUserWithProgress(m.library,m.playingItem,position,duration)
    m.lastProgressSaved = rpUserSaveLibrary(nextLibrary)
    if m.lastProgressSaved
        m.library = nextLibrary
        m.lastProgressWrite = position
        m.lastProgressDuration = duration
        m.lastProgressItemKey = itemKey
    end if
    m.lastProgressAttempt = position
    ensureLibraryState()
end sub

function restoreSavedItem(saved as object) as object
    if orbitText(saved.library,32) = "hd-online" or orbitText(saved.catalogProfile,16) <> "hd" then return saved
    for each items in [m.hdLibrary.movies,m.hdLibrary.series]
        for each item in items
            if item.id = saved.id
                copy = rpCatalogCopyItem(item)
                copy.catalogProfile = "hd"
                return copy
            end if
            if type(item.seasons) = "roArray"
                for each season in item.seasons
                    if type(season.episodes) = "roArray"
                        for each episode in season.episodes
                            if episode.id = saved.id
                                copy = rpCatalogCopyItem(episode)
                                copy.catalogProfile = "hd"
                                return copy
                            end if
                        end for
                    end if
                end for
            end if
        end for
    end for
    return saved
end function

function detailUsesOnlineHd() as boolean
    if type(m.detail) = "roAssociativeArray"
        if m.detail.library = "hd-online" then return true
        if m.detail.catalogProfile = "hd" then return false
        if m.detail.catalogProfile = "hevc" then return false
    end if
    return usesOnlineHd()
end function

function detailActionLabels() as object
    result = []
    if type(m.detail) <> "roAssociativeArray" then return result
    primary = "Reproducir"
    if rpUserResumePosition(m.library,m.detail) > 0 then primary = "Reanudar"
    if m.detail.kind = "series" then primary = "Ver episodios"
    result.push({id:"play",label:primary})
    saved = "Añadir a Mi lista"
    if rpUserHasWatchlist(m.library,m.detail) then saved = "Quitar de Mi lista"
    result.push({id:"watch",label:saved})
    if m.detail.kind <> "series" or m.detailSources.count() > 1 then result.push({id:"sources",label:"Opciones de reproducción"})
    result.push({id:"back",label:"Volver"})
    return result
end function

sub openSourceOptions()
    if m.detail = invalid then return
    ensureLibraryState()
    choices = []
    buttons = []
    if m.detailSources.count() > 1
        for each source in m.detailSources
            label = hdProviderName(source.provider)
            if source.provider = invalid then label = "Versión disponible"
            if buttons.count() < 5
                choices.push({action:"source",item:source})
                buttons.push("Usar "+label)
            end if
        end for
    end if
    if m.detail.kind <> "series"
        choices.push({action:"retry"})
        buttons.push("Probar otra opción")
    end if
    choices.push({action:"cancel"})
    buttons.push("Cancelar")
    m.sourceDialogEntries = choices
    dialog = CreateObject("roSGNode","StandardMessageDialog")
    dialog.title = "Opciones de reproducción"
    dialog.message = ["Conservamos las fuentes disponibles para este título. Algunas opciones pueden no responder."]
    dialog.buttons = buttons
    dialog.observeField("buttonSelected","sourceOptionChosen")
    dialog.observeField("wasClosed","libraryDialogDismissed")
    m.dialogBox = dialog
    m.top.dialog = dialog
end sub

sub sourceOptionChosen(event as object)
    if m.dialogBox = invalid then return
    if not m.dialogBox.isSameNode(event.getRoSGNode()) then return
    index = event.getData()
    if index < 0 or index >= m.sourceDialogEntries.count() then return
    choice = m.sourceDialogEntries[index]
    releaseDialog()
    if choice.action = "source"
        item = rpCatalogCopyItem(choice.item)
        item.sourceOptions = m.detailSources
        item.catalogProfile = "hd"
        openDetails(item,m.detailOrigin,item.kind <> "series")
    else if choice.action = "retry"
        m.detail.languageConfirmed = false
        if detailUsesOnlineHd() then m.detail.hdAttempt = orbitInteger(m.detail.hdAttempt,99)+1 else m.detail.streamAttempt = orbitInteger(m.detail.streamAttempt,999)+1
        playDetail()
    else if choice.action = "pc"
        prepareCompatible()
    else
        drawScreen()
        m.top.setFocus(true)
    end if
end sub

sub libraryDialogDismissed(event as object)
    if event.getData() <> true or m.dialogBox = invalid then return
    if not m.dialogBox.isSameNode(event.getRoSGNode()) then return
    releaseDialog()
    m.pendingResolved = invalid
    drawScreen()
    m.top.setFocus(true)
end sub

sub openResolvedLanguageWarning(answer as object)
    m.pendingResolved = answer
    dialog = CreateObject("roSGNode","StandardMessageDialog")
    dialog.title = "Comprueba el idioma"
    dialog.message = [orbitText(answer.languageWarning,500)]
    dialog.buttons = ["Reproducir esta versión","Otras opciones","Cancelar"]
    dialog.observeField("buttonSelected","resolvedLanguageChosen")
    dialog.observeField("wasClosed","libraryDialogDismissed")
    m.dialogBox = dialog
    m.top.dialog = dialog
end sub

sub resolvedLanguageChosen(event as object)
    if m.dialogBox = invalid then return
    if not m.dialogBox.isSameNode(event.getRoSGNode()) then return
    choice = event.getData()
    answer = m.pendingResolved
    releaseDialog()
    m.pendingResolved = invalid
    if choice = 0 and type(answer) = "roAssociativeArray"
        m.detail.languageConfirmed = true
        launchVideo(m.detail,answer.url,answer.streamFormat)
    else if choice = 1
        openSourceOptions()
    else
        drawScreen()
        m.top.setFocus(true)
    end if
end sub

sub openLanguageChoices(answer as object)
    buttons = []
    m.languageDialogEntries = []
    seen = {}
    if type(answer.availableLanguages) = "roArray"
        for each language in answer.availableLanguages
            code = orbitText(language.code,20)
            if code <> "" and not seen.doesExist(code) and buttons.count() < 6
                seen[code] = true
                buttons.push("Usar "+orbitText(language.label,70))
                m.languageDialogEntries.push(code)
            end if
        end for
    end if
    buttons.push("Otras opciones")
    m.languageDialogEntries.push("sources")
    buttons.push("Cancelar")
    m.languageDialogEntries.push("cancel")
    dialog = CreateObject("roSGNode","StandardMessageDialog")
    dialog.title = "El idioma preferido no está disponible"
    dialog.message = [orbitText(answer.message,500)]
    dialog.buttons = buttons
    dialog.observeField("buttonSelected","languageVersionChosen")
    dialog.observeField("wasClosed","libraryDialogDismissed")
    m.dialogBox = dialog
    m.top.dialog = dialog
end sub

sub languageVersionChosen(event as object)
    if m.dialogBox = invalid then return
    if not m.dialogBox.isSameNode(event.getRoSGNode()) then return
    index = event.getData()
    if index < 0 or index >= m.languageDialogEntries.count() then return
    choice = m.languageDialogEntries[index]
    releaseDialog()
    if choice = "sources"
        openSourceOptions()
    else if choice = "cancel"
        drawScreen()
        m.top.setFocus(true)
    else
        m.detail.audioOverride = choice
        m.detail.streamAttempt = 0
        m.detail.hdAttempt = 0
        m.detail.languageConfirmed = false
        playDetail()
    end if
end sub

sub clearCatalogSearch()
    m.query = ""
    m.browseSearchCursor = 0
    m.zone = "browse-search"
    loadBrowsePage(0)
end sub

sub selectCatalogCategory(index as integer)
    choices = rpCatalogCategories(m.kind)
    if index < 0 or index >= choices.count() then return
    if m.catalogCategory = choices[index].id then return
    cancelRequest()
    m.browseFill = invalid
    m.catalogCategoryCursor = index
    m.catalogCategory = choices[index].id
    m.cursor = 0
    m.zone = "catalog-categories"
    if m.catalogMode <> "hd"
        ' The 4K catalog supports server-side genre filtering, including Family
        ' series. A category is a fresh query, not twenty generic top results.
        loadBrowsePage(0)
        if type(m.browseFill) = "roAssociativeArray" then m.browseFill.zone = "catalog-categories"
        return
    end if
    m.catalogProviderFiltered = false
    m.titles = rpCatalogCategoryItems(m.catalogItems,m.catalogCategory)
    if usesOnlineHd() and m.more and m.titles.count() < 12
        startBrowseFill(m.nextOffset,12,0,"catalog-categories")
        return
    end if
    drawScreen()
end sub

sub openMediaPreferences()
    m.mediaPrefs = rpMediaLoadPreferences()
    m.mediaPrefsCursor = 0
    m.view = "media-prefs"
    m.zone = "media-prefs"
    drawScreen()
end sub

sub chooseMediaPreference()
    buttons = ["Español latino","Español (cualquier región)","Preferencia del sistema","Cancelar"]
    m.mediaPreferenceValues = ["latino","spanish","system","cancel"]
    title = "Audio preferido"
    if m.mediaPrefsCursor = 1
        title = "Subtítulos preferidos"
        buttons = ["Desactivados","Español latino","Español (cualquier región)","Preferencia del sistema","Cancelar"]
        m.mediaPreferenceValues = ["off","latino","spanish","system","cancel"]
    end if
    dialog = CreateObject("roSGNode","StandardMessageDialog")
    dialog.title = title
    dialog.message = ["La elección solo se aplica cuando el video ofrece una pista compatible. Los idiomas no especificados se mostrarán como tales."]
    dialog.buttons = buttons
    dialog.observeField("buttonSelected","mediaPreferenceChosen")
    dialog.observeField("wasClosed","libraryDialogDismissed")
    m.dialogBox = dialog
    m.top.dialog = dialog
end sub

sub mediaPreferenceChosen(event as object)
    if m.dialogBox = invalid then return
    if not m.dialogBox.isSameNode(event.getRoSGNode()) then return
    index = event.getData()
    if index < 0 or index >= m.mediaPreferenceValues.count() then return
    value = m.mediaPreferenceValues[index]
    releaseDialog()
    if value <> "cancel"
        audio = m.mediaPrefs.audio
        subtitles = m.mediaPrefs.subtitles
        if m.mediaPrefsCursor = 0 then audio = value else subtitles = value
        if rpMediaSavePreferences(audio,subtitles)
            m.mediaPrefs = rpMediaLoadPreferences()
            m.note = "Preferencia guardada en esta Roku."
        else
            m.note = "No se pudo guardar la preferencia."
        end if
    end if
    drawScreen()
    m.top.setFocus(true)
end sub

sub openGlobalSearch()
    dialog = CreateObject("roSGNode","StandardMessageDialog")
    dialog.title = "Buscar en Roku Plus"
    dialog.message = ["Elige qué quieres encontrar."]
    dialog.buttons = ["Películas","Series","Canales","Cancelar"]
    dialog.observeField("buttonSelected","globalSearchChosen")
    dialog.observeField("wasClosed","libraryDialogDismissed")
    m.dialogBox = dialog
    m.top.dialog = dialog
end sub

sub globalSearchChosen(event as object)
    if m.dialogBox = invalid then return
    if not m.dialogBox.isSameNode(event.getRoSGNode()) then return
    index = event.getData()
    releaseDialog()
    if index = 0 or index = 1
        m.kind = "movie"
        if index = 1 then m.kind = "series"
        m.query = ""
        m.titles = []
        m.catalogItems = []
        m.offset = 0
        m.more = false
        m.catalogCategory = "all"
        m.catalogCategoryCursor = 0
        openSearch()
    else if index = 2
        m.view = "live"
        m.nav = 3
        selectLiveFilter(m.liveFilter)
        openLiveSearch()
    else
        drawScreen()
        m.top.setFocus(true)
    end if
end sub

sub focusSectionContent()
    if m.view = "home" then m.zone = "hero"
    if m.view = "browse" then m.zone = "browse-search"
    if m.view = "live" then m.zone = "live-filters"
    if m.view = "detail" then m.zone = "action"
    if m.view = "episodes" then m.zone = "episodes"
    if m.view = "settings" then m.zone = "settings"
    if m.view = "watchlist" then m.zone = "watchlist"
    if m.view = "media-prefs" then m.zone = "media-prefs"
end sub
