sub init()
    m.jglVStopped = false
    m.rail        = m.top.FindNode("rail")
    m.content     = m.top.FindNode("content")
    m.navRows     = [m.top.FindNode("navRow0"), m.top.FindNode("navRow1"), m.top.FindNode("navRow2"), m.top.FindNode("navRow3"), m.top.FindNode("navRow4"), m.top.FindNode("navRow5"), m.top.FindNode("navRow6"), m.top.FindNode("navRow7"), m.top.FindNode("navRow8")]
    m.navBgs      = [m.top.FindNode("navBg0"),  m.top.FindNode("navBg1"),  m.top.FindNode("navBg2"),  m.top.FindNode("navBg3"),  m.top.FindNode("navBg4"),  m.top.FindNode("navBg5"),  m.top.FindNode("navBg6"),  m.top.FindNode("navBg7"),  m.top.FindNode("navBg8")]
    m.navFocus    = [m.top.FindNode("navFocus0"), m.top.FindNode("navFocus1"), m.top.FindNode("navFocus2"), m.top.FindNode("navFocus3"), m.top.FindNode("navFocus4"), m.top.FindNode("navFocus5"), m.top.FindNode("navFocus6"), m.top.FindNode("navFocus7"), m.top.FindNode("navFocus8")]
    m.navIcons    = [m.top.FindNode("navIcon0"),m.top.FindNode("navIcon1"),m.top.FindNode("navIcon2"),m.top.FindNode("navIcon3"),m.top.FindNode("navIcon4"),m.top.FindNode("navIcon5"),m.top.FindNode("navIcon6"),m.top.FindNode("navIcon7"),m.top.FindNode("navIcon8")]
    m.navLabels   = [m.top.FindNode("navLabel0"),m.top.FindNode("navLabel1"),m.top.FindNode("navLabel2"),m.top.FindNode("navLabel3"),m.top.FindNode("navLabel4"),m.top.FindNode("navLabel5"),m.top.FindNode("navLabel6"),m.top.FindNode("navLabel7"),m.top.FindNode("navLabel8")]
    m.brandGroup  = m.top.FindNode("brandGroup")
    m.eyebrow      = m.top.FindNode("eyebrow")
    m.sectionTitle = m.top.FindNode("sectionTitle")
    m.sectionSub   = m.top.FindNode("sectionSub")
    m.clockLabel   = m.top.FindNode("clockLabel")
    m.titleAccent  = m.top.FindNode("titleAccent")
    m.hardwareLabel = m.top.FindNode("hardwareLabel")
    m.hardwareSummary = m.top.FindNode("hardwareSummary")
    m.hardwareModel = m.top.FindNode("hardwareModel")
    m.hardwareResolution = m.top.FindNode("hardwareResolution")
    m.hardwareCompat1 = m.top.FindNode("hardwareCompat1")
    m.hardwareCompat2 = m.top.FindNode("hardwareCompat2")
    m.catRow    = m.top.FindNode("catRow")
    m.liveCatOverlay = m.top.FindNode("liveCatOverlay")
    m.fullPanelSlide = m.top.FindNode("fullPanelSlide")
    m.vodDetailOverlay = m.top.FindNode("vodDetailOverlay")
    m.gridArea  = m.top.FindNode("gridArea")
    m.player    = m.top.FindNode("player")
    m.NAV = [
        { id: "home",   label: "Inicio",     rootCol: 0,     vodCol: 76177 }
        { id: "vivo",   label: "TV en vivo", rootCol: 76175, vodCol: 0 }
        { id: "vod",    label: "Peliculas",  rootCol: 0,     vodCol: 76177 }
        { id: "vod",    label: "Series",     rootCol: 0,     vodCol: 76178 }
        { id: "vod",    label: "Infantil",   rootCol: 0,     vodCol: 76180 }
        { id: "anime",  label: "Anime",      rootCol: 0,     vodCol: 76178 }
        { id: "search", label: "Buscar",     rootCol: 0,     vodCol: 0 }
        { id: "history",label: "Historial",   rootCol: 0,     vodCol: 0 }
        { id: "settings",label:"Ajustes",     rootCol: 0,     vodCol: 0 }
    ]
    m.navRows.push(m.top.FindNode("navRow9"))
    m.navBgs.push(m.top.FindNode("navBg9"))
    m.navFocus.push(m.top.FindNode("navFocus9"))
    m.navIcons.push(m.top.FindNode("navIcon9"))
    m.navLabels.push(m.top.FindNode("navLabel9"))
    m.NAV.push({id:"return",label:"Volver a Roku Plus",rootCol:0,vodCol:0})
    m.VOD_GENRES = [
        { name: "Todas",     tag: "" }
        { name: "Accion",    tag: "Acción" }
        { name: "Drama",     tag: "Drama" }
        { name: "Aventuras", tag: "Aventuras" }
        { name: "Crimen",    tag: "Crimen" }
        { name: "Sci-Fi",    tag: "Ciencia ficción" }
        { name: "Comedia",   tag: "Comedia" }
        { name: "Romance",   tag: "Romántico" }
        { name: "Animacion", tag: "Animación" }
        { name: "Familia",   tag: "Familia" }
        { name: "Fantasia",  tag: "Fantastico" }
        { name: "Suspenso",  tag: "Suspenso" }
        { name: "Horror",    tag: "Horror" }
        { name: "Misterio",  tag: "Misterio" }
    ]
    m.section     = "vivo"
    m.navIdx      = 1
    m.navCursor   = 1
    m.pendingEnter = false
    m.region      = "nav"
    m.categories  = []
    m.catIdx      = 0
    m.liveCatCursor = 0
    m.savedLiveCatIdx = 0
    m.items       = []
    m.gridIdx     = 0
    m.rowOffset   = 0
    m.gridState   = "ready"
    m.favs        = {}
    m.catCache    = {}
    m.itemCache   = {}
    m.vodCodecCache = {}
    m.vodAudioCache = {}
    m.activeVodCodecKey = ""
    m.codecWarningDlg = invalid
    m.codecPendingIdx = -1
    m.codecPendingKey = ""
    m.codecWarningAcceptedKey = ""
    m.errorDetail = ""
    m.catTask     = invalid
    m.itemTask    = invalid
    m.started = false
    m.startupActive = false
    m.startupRecord = LastLiveLoad()
    m.startupTriedCats = {}
    m.startupFallbackUsed = false
    m.startupPlayback = false
    m.pendingLiveSave = invalid
    m.lastSavedSignature = ""
    m.liveSessionChannelId = ""
    m.liveSessionCatId = ""
    m.resumeLiveOnLoad = false
    m.adultPin        = PinLoad()
    m.adultUnlocked   = false
    m.adultPendingIdx = -1
    m.adultPendingCat = -1
    m.pinDlg          = invalid
    m.pinMode         = ""
    m.pinEntry1       = ""
    m.pinEntry2       = ""
    m.pinVerifyEntry  = ""
    m.pinResetTimer   = invalid
    m.pinResetDlg     = invalid
    m.pinResetMessage = ""
    m.seriesMode      = false
    m.seriesContentId = ""
    m.seriesPoster    = ""
    m.savedGrid       = invalid
    m.player.ObserveField("state", "OnPlayerState")
    m.player.ObserveField("detectedVideoCodec", "OnDetectedVideoCodec")
    m.player.ObserveField("detectedAudioFormat", "OnDetectedAudioFormat")
    m.closingPlayer = false
    m.liveFullscreen = false
    m.fullPanelMode = ""
    m.fullPanelCursor = 0
    m.fullPanelWaiting = false
    m.fullPanelPositions = {}
    m.fullPanelWidth = 500
    m.fullPanelWidthKey = ""
    m.vodDetailMode = ""
    m.vodDetailItem = invalid
    m.vodDetailData = invalid
    m.vodDetailSeries = invalid
    m.vodDetailSeriesData = invalid
    m.vodDetailEpisodes = []
    m.vodDetailSeasons = []
    m.vodDetailSeasonIdx = 0
    m.vodDetailEpisodeIdx = 0
    m.vodDetailRegion = "play"
    m.vodDetailLoading = false
    m.detailTask = invalid
    m.vodErrorActive = false
    m.vodErrorFormat = false
    m.vodErrorChoice = 0
    m.vodErrorCode = "VOD-002"
    m.lastVodPlaybackItem = invalid
    m.lastVodPlaybackSeriesMode = false
    m.lastVodPlaybackSeriesId = ""
    m.pinContext = ""
    m.switchingLive = false
    m.recoveryState = "IDLE"
    m.recoveryGeneration = 0
    m.recoveryTried = {}
    m.recoveryInternal = false
    m.recoveryWasPlaying = false
    m.recoveryRetryUsed = false
    m.recoveryTimer = invalid
    m.watchTimer = invalid
    m.top.hardwareInfo = Hardware_Detect()
    RenderHardwareSummary()
    m.top.ObserveField("start", "OnStart")
    m.top.ObserveField("halt",  "OnHalt")
    m.clockTimer = CreateObject("roSGNode", "Timer")
    m.clockTimer.duration = 15
    m.clockTimer.repeat   = true
    m.clockTimer.ObserveField("fire", "OnClockTick")
    m.clockTimer.control  = "start"
    UpdateClock()
    RenderRail()
    RenderHeader()
end sub
function CountStarPress() as Boolean
    now = CreateObject("roDateTime").AsSeconds()
    if m.lastStar = invalid or (now - m.lastStar) > 3
        m.starCount = 1
    else
        m.starCount = m.starCount + 1
    end if
    m.lastStar = now
    if m.starCount < 5 then return false
    m.starCount = 0
    sc = JglVRoot()
    if sc = invalid then return false
    sc.showDebug = true
    return true
end function
sub OnClockTick(event as Object)
    if m.jglVStopped = true then return
    UpdateClock()
end sub
sub UpdateClock()
    if m.jglVStopped = true then return
    t = CreateObject("roDateTime")
    t.ToLocalTime()
    m.clockLabel.text = Right("0" + t.GetHours().ToStr(), 2) + ":" + Right("0" + t.GetMinutes().ToStr(), 2)
end sub
sub OnStart(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() <> true then return
    if m.started then return
    m.started = true
    m.top.SetFocus(true)
    m.region = "grid"
    m.startupActive = true
    m.startupTriedCats = {}
    LoadCategoriesForSection()
end sub
sub OnHalt(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() <> true then return
    ClosePlayer()
end sub
function IsVodSection(id as String) as Boolean
    return id = "home" or id = "vod" or id = "anime"
end function
sub SetGridError(context as String, detail as Dynamic)
    if m.jglVStopped = true then return
    m.errorDetail = context + ": " + SafeStr(detail)
    if m.errorDetail = context + ": " then m.errorDetail = context + ": error desconocido"
    m.gridState = "error"
    RenderGrid()
end sub
sub LoadCategoriesForSection()
    if m.jglVStopped = true then return
    m.seriesMode      = false
    m.seriesContentId = ""
    m.savedGrid       = invalid
    nav = m.NAV[m.navIdx]
    if nav.id = "history"
        m.categories = []
        m.items      = HistoryItems()
        m.gridState  = Tern(m.items.Count() > 0, "ready", "empty")
        RenderHeader() : RenderCategories() : RenderGrid()
        MaybeEnterPending()
        return
    end if
    if nav.id = "settings"
        m.categories = []
        m.items = []
        m.gridState = "empty"
        RenderHeader() : RenderCategories() : RenderGrid()
        return
    end if
    if IsVodSection(nav.id)
        if not CanPlayVod()
            m.categories = []
            m.items = []
            m.gridState = "nohevc"
            RenderHeader() : RenderCategories() : RenderGrid()
            return
        end if
        m.categories = m.VOD_GENRES
        m.catIdx = Tern(nav.id = "anime", 8, 0)
        RenderHeader() : RenderCategories()
        LoadItemsForCurrentCategory()
        return
    end if
    if m.catCache[nav.id] <> invalid
        m.categories = m.catCache[nav.id]
        if nav.id = "vivo" and m.startupActive
            BeginLiveStartup()
            return
        end if
        if nav.id = "vivo"
            m.catIdx = m.savedLiveCatIdx
            if m.catIdx >= m.categories.Count() then m.catIdx = 0
        else
            m.catIdx = 0
        end if
        m.liveCatCursor = m.catIdx
        RenderHeader() : RenderCategories()
        LoadItemsForCurrentCategory()
        return
    end if
    m.gridState = "loading"
    RenderHeader() : RenderCategories() : RenderGrid()
    if m.catTask <> invalid then m.catTask.control = "STOP"
    m.catTask = Api_OpTask("columns", { columnId: nav.rootCol })
    if m.catTask = invalid
        SetGridError("columns", "operación ausente en kit") : return
    end if
    m.catTask.ObserveField("rawResp", "OnCategoriesResp")
    m.catTask.ObserveField("error",   "OnCategoriesError")
    m.catTask.control = "RUN"
end sub
sub OnCategoriesResp(event as Object)
    if m.jglVStopped = true then return
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        SetGridError("columns", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    cats = []
    if data <> invalid
        if data.childColumnList <> invalid then cats = data.childColumnList
        if data.list <> invalid and cats.Count() = 0 then cats = data.list
    end if
    nav = m.NAV[m.navIdx]
    m.catCache[nav.id] = cats
    m.categories = cats
    if nav.id = "vivo" and m.startupActive
        BeginLiveStartup()
        return
    end if
    m.catIdx = Tern(nav.id = "vivo", m.savedLiveCatIdx, 0)
    if m.catIdx >= cats.Count() then m.catIdx = 0
    m.liveCatCursor = m.catIdx
    RenderHeader() : RenderCategories()
    LoadItemsForCurrentCategory()
end sub
sub OnCategoriesError(event as Object)
    if m.jglVStopped = true then return
    if Api_LicenseGone(event.GetData()) then return
    SetGridError("columns", event.GetData())
end sub
sub LoadVodPage(page as Integer)
    if m.jglVStopped = true then return
    nav = m.NAV[m.navIdx]
    cat = m.categories[m.catIdx]
    if m.itemTask <> invalid then m.itemTask.control = "STOP"
    m.itemTask = Api_OpTask("filter", { columnId: nav.vodCol, tag: SafeStr(cat.tag), page: page })
    if m.itemTask = invalid
        m.vodLoadingMore = false
        if m.items.Count() = 0 then m.gridState = "error" : RenderGrid()
        return
    end if
    m.itemTask.ObserveField("rawResp", "OnVodPageResp")
    m.itemTask.ObserveField("error",   "OnVodPageError")
    m.itemTask.control = "RUN"
end sub
sub OnVodPageResp(event as Object)
    if m.jglVStopped = true then return
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        m.vodLoadingMore = false
        if m.items.Count() = 0 then SetGridError("filter", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    newItems = []
    if data <> invalid and data.assetList <> invalid then newItems = data.assetList
    if data <> invalid and data.totalSize <> invalid then m.vodTotal = data.totalSize
    for each a in newItems
        m.items.Push(a)
    end for
    m.vodLoadingMore = false
    m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
    MaybeEnterPending()
end sub
sub OnVodPageError(event as Object)
    if m.jglVStopped = true then return
    if Api_LicenseGone(event.GetData()) then return
    m.vodLoadingMore = false
    if m.items.Count() = 0
        SetGridError("filter página " + m.vodPage.ToStr(), event.GetData())
    end if
end sub
sub MaybeLoadMoreVod()
    if m.jglVStopped = true then return
    if not IsVodSection(m.NAV[m.navIdx].id) then return
    if m.seriesMode then return   ' los episodios vienen todos de una (getItemData)
    if m.vodLoadingMore = true then return
    if m.items.Count() >= m.vodTotal then return
    if m.gridIdx >= m.items.Count() - (GRID_COLS() * 2)
        m.vodLoadingMore = true
        m.vodPage = m.vodPage + 1
        LoadVodPage(m.vodPage)
    end if
end sub
sub LoadItemsForCurrentCategory()
    if m.jglVStopped = true then return
    nav = m.NAV[m.navIdx]
    if m.categories.Count() = 0
        m.items     = []
        m.gridState = "empty"
        RenderGrid()
        return
    end if
    cat = m.categories[m.catIdx]
    nav = m.NAV[m.navIdx]
    if IsVodSection(nav.id)
        m.items = []
        m.gridIdx = 0
        m.rowOffset = 0
        m.vodPage = 1
        m.vodTotal = 0
        m.vodLoadingMore = false
        m.gridState = "loading"
        RenderGrid()
        LoadVodPage(1)
        return
    end if
    cacheKey = nav.id + ":" + GetCatId(cat).ToStr()
    if m.itemCache[cacheKey] <> invalid
        m.items = m.itemCache[cacheKey]
        m.gridIdx = 0
        m.rowOffset = 0
        m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
        RenderHeader() : RenderGrid()
        MaybeEnterPending()
        FullCategoryLoaded()
        ContinueLiveStartup()
        ContinueLiveResume()
        return
    end if
    m.gridState = "loading"
    RenderGrid()
    if m.itemTask <> invalid then m.itemTask.control = "STOP"
    m.activeItemCacheKey = cacheKey
    m.itemTask = Api_OpTask("channels", { columnId: GetCatId(cat) })
    if m.itemTask = invalid
        SetGridError("channelList", "operación ausente en kit") : return
    end if
    m.itemTask.ObserveField("rawResp", "OnItemsResp")
    m.itemTask.ObserveField("error",   "OnItemsError")
    m.itemTask.control = "RUN"
end sub
sub OnItemsResp(event as Object)
    if m.jglVStopped = true then return
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        SetGridError("channelList", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    items = []
    if data <> invalid
        if data.channelList <> invalid then items = data.channelList
        if data.liveList <> invalid and items.Count() = 0 then items = data.liveList
        if data.list <> invalid and items.Count() = 0 then items = data.list
    end if
    m.items     = items
    if m.activeItemCacheKey <> invalid and m.activeItemCacheKey <> ""
        m.itemCache[m.activeItemCacheKey] = items
    end if
    m.gridIdx   = 0
    m.rowOffset = 0
    m.gridState = Tern(items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
    MaybeEnterPending()
    FullCategoryLoaded()
    ContinueLiveStartup()
    ContinueLiveResume()
end sub
sub OnVodItemsResp(event as Object)
    if m.jglVStopped = true then return
    data = Api_ParseOp(event.GetData())
    items = []
    seen = {}
    if data <> invalid and data.recommendList <> invalid
        for each row in data.recommendList
            if row.assetList <> invalid
                for each a in row.assetList
                    code = SafeStr(a.contentId)
                    if code <> "" and seen[code] = invalid
                        seen[code] = true
                        items.Push(a)
                    end if
                end for
            end if
        end for
    end if
    m.items     = items
    m.gridIdx   = 0
    m.rowOffset = 0
    m.gridState = Tern(items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
end sub
sub OnItemsError(event as Object)
    if m.jglVStopped = true then return
    if Api_LicenseGone(event.GetData()) then return
    if m.startupActive
        if TryNextStartupCategory() then return
        m.startupActive = false
    end if
    if m.fullPanelWaiting
        m.fullPanelWaiting = false
        m.fullPanelMode = "categories"
        RenderFullLivePanel()
    end if
    SetGridError("channelList", event.GetData())
end sub
function VisRows() as Integer
    id = m.NAV[m.navIdx].id
    if IsVodSection(id) or id = "search" or id = "history" then return 2
    return VISIBLE_ROWS()
end function
sub EnsureRowVisible()
    if m.jglVStopped = true then return
    row = Int(m.gridIdx / GRID_COLS())
    if row < m.rowOffset
        m.rowOffset = row
    else if row > m.rowOffset + VisRows() - 1
        m.rowOffset = row - VisRows() + 1
    end if
    MaybeLoadMoreVod()   ' paginación infinita del catálogo VOD
end sub
function GetCatId(cat as Object) as Integer
    if cat.id <> invalid then return cat.id
    if cat.columnId <> invalid then return cat.columnId
    return 0
end function
function LastLiveLoad() as Dynamic
    reg = CreateObject("roRegistrySection", "RokuPlusJglVHistory")
    if not reg.Exists("lastLive") then return invalid
    data = ParseJSON(reg.Read("lastLive"))
    if data = invalid or Type(data) <> "roAssociativeArray" then return invalid
    return data
end function
function LiveProviderId() as String
    s = v4a25()
    return SafeStr(s.portalCode)
end function
function LiveStableId(it as Object) as String
    if it = invalid then return ""
    if IsValidStr(SafeStr(it.id)) then return SafeStr(it.id)
    if IsValidStr(SafeStr(it.channelCode)) then return SafeStr(it.channelCode)
    return ""
end function
function FindLiveCategory(catId as String, catName as String) as Integer
    for i = 0 to m.categories.Count() - 1
        cat = m.categories[i]
        if not IsCatAdult(cat)
            if catId <> "" and GetCatId(cat).ToStr() = catId then return i
            if catName <> "" and LCase(SafeStr(cat.name)) = LCase(catName) then return i
        end if
    end for
    return -1
end function
sub StartLiveCategory(idx as Integer)
    if m.jglVStopped = true then return
    if idx < 0 or idx >= m.categories.Count() then return
    m.startupTriedCats["c" + idx.ToStr()] = true
    m.catIdx = idx
    m.savedLiveCatIdx = idx
    m.liveCatCursor = idx
    m.gridIdx = 0 : m.rowOffset = 0
    RenderHeader() : RenderCategories()
    LoadItemsForCurrentCategory()
end sub
sub BeginLiveStartup()
    if m.jglVStopped = true then return
    if not m.startupActive then return
    idx = -1
    rec = m.startupRecord
    if rec <> invalid
        if SafeStr(rec.provider) = "" or SafeStr(rec.provider) = LiveProviderId()
            idx = FindLiveCategory(SafeStr(rec.categoryId), SafeStr(rec.categoryName))
        end if
    end if
    if idx < 0
        for i = 0 to m.categories.Count() - 1
            if not IsCatAdult(m.categories[i])
                idx = i
                exit for
            end if
        end for
    end if
    if idx < 0
        m.startupActive = false
        m.gridState = "empty"
        RenderGrid()
        return
    end if
    StartLiveCategory(idx)
end sub
function TryNextStartupCategory() as Boolean
    for i = 0 to m.categories.Count() - 1
        if m.startupTriedCats["c" + i.ToStr()] = invalid and not IsCatAdult(m.categories[i])
            StartLiveCategory(i)
            return true
        end if
    end for
    m.startupActive = false
    return false
end function
function FindStartupChannel() as Integer
    wanted = ""
    rec = m.startupRecord
    if rec <> invalid
        if SafeStr(rec.categoryId) = GetCatId(m.categories[m.catIdx]).ToStr() or LCase(SafeStr(rec.categoryName)) = LCase(SafeStr(m.categories[m.catIdx].name))
            wanted = SafeStr(rec.channelId)
        end if
    end if
    if wanted <> ""
        for i = 0 to m.items.Count() - 1
            same = (LiveStableId(m.items[i]) = wanted)
            if not same and SafeStr(rec.apiId) <> "" then same = (SafeStr(m.items[i].id) = SafeStr(rec.apiId))
            if not same and SafeStr(rec.channelCode) <> "" then same = (SafeStr(m.items[i].channelCode) = SafeStr(rec.channelCode))
            if same and not IsLocked(m.items[i]) then return i
        end for
    end if
    for i = 0 to m.items.Count() - 1
        if not IsLocked(m.items[i]) then return i
    end for
    return -1
end function
sub ContinueLiveStartup()
    if m.jglVStopped = true then return
    if not m.startupActive then return
    if m.items.Count() = 0
        if not TryNextStartupCategory()
            m.gridState = "empty" : RenderGrid()
        end if
        return
    end if
    idx = FindStartupChannel()
    if idx < 0
        if not TryNextStartupCategory()
            m.gridState = "empty" : RenderGrid()
        end if
        return
    end if
    m.startupActive = false
    m.startupPlayback = true
    m.startupFallbackUsed = false
    m.region = "grid"
    m.gridIdx = idx : m.rowOffset = 0
    EnsureLiveChannelVisible()
    RenderRail() : RenderCategories() : RenderGrid()
    PlayLiveItem(idx, false)
end sub
function TryStartupFallback() as Boolean
    if m.startupFallbackUsed or m.items.Count() < 2 then return false
    m.startupFallbackUsed = true
    startIdx = m.gridIdx
    for offset = 1 to m.items.Count() - 1
        idx = (startIdx + offset) mod m.items.Count()
        if not IsLocked(m.items[idx])
            PlayLiveItem(idx, false)
            return true
        end if
    end for
    return false
end function
sub SavePendingLive()
    if m.jglVStopped = true then return
    data = m.pendingLiveSave
    m.pendingLiveSave = invalid
    if data = invalid or data.protected = true then return
    sig = SafeStr(data.provider) + "|" + SafeStr(data.categoryId) + "|" + SafeStr(data.channelId)
    m.liveSessionChannelId = SafeStr(data.channelId)
    m.liveSessionCatId = SafeStr(data.categoryId)
    m.savedLiveCatIdx = m.catIdx
    if sig = m.lastSavedSignature then return
    reg = CreateObject("roRegistrySection", "RokuPlusJglVHistory")
    existing = ""
    if reg.Exists("lastLive") then existing = reg.Read("lastLive")
    encoded = FormatJson(data)
    if existing <> encoded
        reg.Write("lastLive", encoded)
        reg.Flush()
    end if
    m.lastSavedSignature = sig
    m.startupRecord = data
end sub
sub ContinueLiveResume()
    if m.jglVStopped = true then return
    if not m.resumeLiveOnLoad then return
    m.resumeLiveOnLoad = false
    if m.liveSessionChannelId = "" then return
    for i = 0 to m.items.Count() - 1
        if LiveStableId(m.items[i]) = m.liveSessionChannelId and not IsLocked(m.items[i])
            m.region = "grid" : m.gridIdx = i : m.rowOffset = 0
            EnsureLiveChannelVisible()
            RenderRail() : RenderCategories() : RenderGrid()
            PlayLiveItem(i, false)
            return
        end if
    end for
end sub
function FavItems() as Object
    out = []
    for each code in m.favs
        out.Push(m.favs[code])
    end for
    return out
end function
function HistoryItems() as Object
    reg = CreateObject("roRegistrySection", "RokuPlusJglVHistory")
    if not reg.Exists("history") then return []
    items = ParseJSON(reg.Read("history"))
    if items = invalid or Type(items) <> "roArray" then return []
    safe = []
    for each item in items
        if not IsLocked(item) then safe.Push(item)
    end for
    return safe
end function
sub HistoryAdd(it as Object, kind as String)
    if m.jglVStopped = true then return
    if IsLocked(it) then return
    if kind = "live" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) then return
    end if
    copy = ParseJSON(FormatJson(it))
    if copy = invalid then return
    copy["_historyKind"] = kind
    key = ItemCode(copy)
    if key = "" then key = SafeStr(copy.contentId)
    out = [copy]
    history = HistoryItems()
    for each old in history
        oldKey = ItemCode(old)
        if oldKey = "" then oldKey = SafeStr(old.contentId)
        if oldKey <> key and out.Count() < 10 then out.Push(old)
    end for
    reg = CreateObject("roRegistrySection", "RokuPlusJglVHistory")
    reg.Write("history", FormatJson(out))
    reg.Flush()
end sub
sub RenderRail()
    if m.jglVStopped = true then return
    railOn = (m.region = "nav")
    w = RAIL_W_EXPANDED()
    m.top.FindNode("railBg").width  = w
    m.top.FindNode("railLine").translation = [w - 2, 0]
    shadow = m.top.FindNode("railShadow")
    shadow.translation = [w, 0]
    shadow.visible = true
    m.brandGroup.visible = false
    m.top.FindNode("brandMini").visible = false
    for i = 0 to m.NAV.Count() - 1
        active  = (i = m.navIdx)
        focused = railOn and (i = m.navCursor)
        bg = m.navBgs[i]
        focus = m.navFocus[i]
        icon = m.navIcons[i]
        lbl = m.navLabels[i]
        if focused
            focus.color = THEME_ACCENT()
            bg.color = "0x4A2630FF"
            icon.opacity = 1.0
            lbl.color = "0xFFFFFFFF"
        else if active
            focus.color = THEME_ACCENT()
            bg.color = "0x252633FF"
            icon.opacity = 1.0
            lbl.color = THEME_TEXT()
        else
            focus.color = "0x00000000"
            bg.color = "0x00000000"
            icon.opacity = 0.78
            lbl.color = "0xF0F0F2FF"
        end if
        lbl.visible = true
        bg.width = 268
    end for
end sub
sub RenderHeader()
    if m.jglVStopped = true then return
    nav = m.NAV[m.navIdx]
    m.hardwareLabel.visible = false
    m.hardwareSummary.visible = (nav.id = "vivo")
    m.eyebrow.text = nav.label
    m.sectionTitle.visible = true
    m.titleAccent.visible = false
    m.catRow.translation = [40, 160]
    m.gridArea.translation = [40, 250]
    if nav.id = "home"
        m.eyebrow.text = "Recomendados"
        m.sectionTitle.visible = false
        m.gridArea.translation = [40, 110]
    else if nav.id = "vivo"
        m.sectionTitle.visible = false
        m.catRow.translation = [20, 110]
        m.gridArea.translation = [0, 0]
    else if nav.id = "history"
        m.sectionTitle.text = "Vistos recientemente"
    else if nav.id = "settings"
        m.sectionTitle.text = "Configuración"
    else if m.categories.Count() > 0
        m.sectionTitle.text = SafeStr(m.categories[m.catIdx].name)
    else
        m.sectionTitle.text = nav.label
    end if
    count = m.items.Count()
    if m.gridState = "loading"
        m.sectionSub.text = "Cargando..."
    else if m.gridState = "error"
        m.sectionSub.text = "Error de senal"
    else if count = 0
        m.sectionSub.text = "Sin contenido"
    else
        unidad = Tern(IsVodSection(nav.id) or nav.id = "search" or nav.id = "history", " titulos", " canales")
        totalRows = Int((count - 1) / GRID_COLS()) + 1
        rowTxt = ""
        if totalRows > VisRows()
            curRow = m.rowOffset + 1
            rowTxt = "  .  fila " + curRow.ToStr() + " de " + totalRows.ToStr()
        end if
        m.sectionSub.text = count.ToStr() + unidad + rowTxt
    end if
end sub
sub SetHardwareIndicator(prefix as String, value as Dynamic)
    if m.jglVStopped = true then return
    isYes = (value = true)
    isNo = (value = false)
    m.top.FindNode(prefix + "CheckShort").visible = isYes
    m.top.FindNode(prefix + "CheckLong").visible = isYes
    m.top.FindNode(prefix + "X1").visible = isNo
    m.top.FindNode(prefix + "X2").visible = isNo
    m.top.FindNode(prefix + "Unknown").visible = (value = invalid)
end sub
sub RenderHardwareSummary()
    if m.jglVStopped = true then return
    info = m.top.hardwareInfo
    if info = invalid then return
    name = SafeStr(info.modelName)
    if name = "" then name = "Roku " + SafeStr(info.model)
    resolution = SafeStr(info.videoMode)
    if resolution = "" then resolution = "No determinado"
    m.hardwareModel.text = name
    m.hardwareResolution.text = resolution
    SetHardwareIndicator("avc", info.avc)
    SetHardwareIndicator("hevc", info.hevc)
    m.hardwareCompat2.text = ""
    if info.avc = true and info.hevc = true
        m.hardwareCompat1.color = "0x5BD68AFF"
        m.hardwareCompat1.text = "Esta TV puede reproducir películas y series H.264/H.265 compatibles."
    else if info.avc = true and info.hevc = false
        m.hardwareCompat1.color = "0x5BD68AFF"
        m.hardwareCompat1.text = "Esta TV admite películas y series H.264 compatibles."
        m.hardwareCompat2.color = "0xE96A72FF"
        m.hardwareCompat2.text = "HEVC no compatible. Para contenido H.265, utiliza un Roku 4K compatible."
    else if info.avc = invalid or info.hevc = invalid
        m.hardwareCompat1.color = "0x999DA8FF"
        m.hardwareCompat1.text = "No se pudo determinar la compatibilidad de video."
    else
        m.hardwareCompat1.color = "0xE96A72FF"
        m.hardwareCompat1.text = "Los perfiles H.264 y HEVC probados no son compatibles con este Roku."
    end if
end sub
sub RenderCategories()
    if m.jglVStopped = true then return
    m.catRow.RemoveChildren(m.catRow.GetChildren(-1, 0))
    m.liveCatOverlay.RemoveChildren(m.liveCatOverlay.GetChildren(-1, 0))
    m.liveCatOverlay.visible = false
    nav = m.NAV[m.navIdx]
    m.catRow.visible = true
    if nav.id = "vivo"
        m.catRow.visible = false
        if m.region = "cats" then RenderLiveCategories()
        return
    end if
    if nav.id = "home" or nav.id = "history" or nav.id = "settings" or nav.id = "search"
        m.catRow.visible = false
        return
    end if
    CHIP_H  = 58
    FS      = 17
    AVAIL_W = 1682
    widths = []
    for i = 0 to m.categories.Count() - 1
        label = SafeStr(m.categories[i].name)
        widths.Push(52 + TextW(label, FS) + 22)
    end for
    shift = 0
    if m.catIdx > 0
        endX = 0
        for i = 0 to m.catIdx
            endX = endX + widths[i] + 12
        end for
        if endX > AVAIL_W - 40 then shift = AVAIL_W - endX - 40
    end if
    x = shift
    for i = 0 to m.categories.Count() - 1
        label = SafeStr(m.categories[i].name)
        w = widths[i]
        if x + w > -50 and x < AVAIL_W + 50
            chip = m.catRow.CreateChild("Group")
            chip.translation = [x, 0]
            focused  = (m.region = "cats") and (i = m.catIdx)
            selected = (i = m.catIdx)
            bg = chip.CreateChild("Rectangle")
            bg.width  = w
            bg.height = CHIP_H
            if focused
                bg.color = "0xFFFFFFFF"
            else if selected
                bg.color = THEME_SURFACE2()
            else
                bg.color = THEME_SURFACE()
            end if
            badge = chip.CreateChild("Rectangle")
            badge.width = 36
            badge.height = 36
            badge.translation = [11, 11]
            badge.color = Tern(focused, THEME_ACCENT(), "0x3B3C49FF")
            badgeLbl = chip.CreateChild("Label")
            badgeLbl.text = UCase(Left(label, 2))
            badgeLbl.font = ThemeFont(15, true)
            badgeLbl.color = "0xFFFFFFFF"
            badgeLbl.translation = [11, 11]
            badgeLbl.width = 36
            badgeLbl.height = 36
            badgeLbl.horizAlign = "center"
            badgeLbl.vertAlign  = "center"
            txt = chip.CreateChild("Label")
            txt.text = label
            txt.font = ThemeFont(FS, true)
            txt.color = Tern(focused, "0x1B1B27FF", "0xC9CCD3FF")
            txt.translation = [52, 0]
            txt.height = CHIP_H
            txt.vertAlign = "center"
        end if
        x = x + w + 12
    end for
end sub
sub RenderLiveCategories()
    if m.jglVStopped = true then return
    m.liveCatOverlay.visible = true
    VISIBLE = 12
    ROW_H = 68
    startI = m.liveCatCursor - Int(VISIBLE / 2)
    if startI < 0 then startI = 0
    maxStart = m.categories.Count() - VISIBLE
    if maxStart < 0 then maxStart = 0
    if startI > maxStart then startI = maxStart
    lastI = startI + VISIBLE - 1
    if lastI > m.categories.Count() - 1 then lastI = m.categories.Count() - 1
    overlayShade = m.liveCatOverlay.CreateChild("Rectangle")
    overlayShade.width = 1620
    overlayShade.height = 1080
    overlayShade.translation = [300, 0]
    overlayShade.color = "0x00000099"
    panel = m.liveCatOverlay.CreateChild("Rectangle")
    panel.width = 470
    panel.height = 1080
    panel.translation = [300, 0]
    panel.color = "0x111219FF"
    accent = m.liveCatOverlay.CreateChild("Rectangle")
    accent.width = 6
    accent.height = 54
    accent.translation = [330, 54]
    accent.color = THEME_ACCENT()
    heading = m.liveCatOverlay.CreateChild("Label")
    heading.text = "CATEGORÍAS DE TV"
    heading.font = ThemeFont(28, true)
    heading.color = THEME_TEXT()
    heading.translation = [354, 54]
    heading.width = 370
    heading.height = 54
    help = m.liveCatOverlay.CreateChild("Label")
    help.text = "Selecciona una carpeta de ChannelList"
    help.font = ThemeFont(16, false)
    help.color = THEME_MUTED()
    help.translation = [330, 112]
    help.width = 400
    help.height = 32
    if lastI < startI then return
    for i = startI to lastI
        cat = m.categories[i]
        y = 174 + (i - startI) * ROW_H
        selected = (i = m.catIdx)
        focused = (i = m.liveCatCursor) and m.region = "cats"
        row = m.liveCatOverlay.CreateChild("Group")
        row.translation = [322, y]
        bg = row.CreateChild("Rectangle")
        bg.width = 426
        bg.height = 60
        bg.color = Tern(focused, "0xE51522FF", Tern(selected, "0x292A35FF", "0x00000000"))
        bar = row.CreateChild("Rectangle")
        bar.width = 5
        bar.height = 60
        bar.color = Tern(selected and not focused, THEME_ACCENT(), "0x00000000")
        label = row.CreateChild("Label")
        label.text = SafeStr(cat.name)
        label.font = ThemeFont(19, selected)
        label.color = Tern(selected, "0xFFFFFFFF", "0xB8BBC5FF")
        label.translation = [18, 0]
        label.width = Tern(IsCatAdult(cat), 342, 388)
        label.height = 60
        label.vertAlign = "center"
        label.ellipsisText = "..."
        if IsCatAdult(cat)
            badge = row.CreateChild("Label")
            badge.text = "+18"
            badge.font = ThemeFont(15, true)
            badge.color = THEME_ACCENT_LT()
            badge.translation = [370, 0]
            badge.width = 46
            badge.height = 60
            badge.horizAlign = "center"
            badge.vertAlign = "center"
        end if
    end for
end sub
sub CalculateFullPanelWidth(mode as String)
    if m.jglVStopped = true then return
    widthKey = "sections"
    if mode = "channels" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        widthKey = "channels:" + GetCatId(m.categories[m.catIdx]).ToStr()
    end if
    if widthKey = m.fullPanelWidthKey then return
    widest = 0
    if mode = "channels"
        for each entry in m.items
            w = TextW(SafeStr(entry.name), 17)
            if w > widest then widest = w
        end for
        m.fullPanelWidth = widest + 138
        if m.catIdx >= 0 and m.catIdx < m.categories.Count()
            headingWidth = TextW(UCase(SafeStr(m.categories[m.catIdx].name)), 25) + 40
            if headingWidth > m.fullPanelWidth then m.fullPanelWidth = headingWidth
        end if
        if m.fullPanelWidth < 410 then m.fullPanelWidth = 410
        if m.fullPanelWidth > 620 then m.fullPanelWidth = 620
    else
        for each entry in m.categories
            w = TextW(SafeStr(entry.name), 17)
            if w > widest then widest = w
        end for
        m.fullPanelWidth = widest + 112
        if m.fullPanelWidth < 390 then m.fullPanelWidth = 390
        if m.fullPanelWidth > 540 then m.fullPanelWidth = 540
    end if
    m.fullPanelWidthKey = widthKey
end sub
sub RenderFullLivePanel()
    if m.jglVStopped = true then return
    m.liveCatOverlay.RemoveChildren(m.liveCatOverlay.GetChildren(-1, 0))
    if m.fullPanelMode = ""
        m.liveCatOverlay.visible = false
        return
    end if
    m.liveCatOverlay.visible = true
    PANEL_X = 0
    PANEL_Y = 90
    PANEL_W = m.fullPanelWidth
    PANEL_H = 900
    ROW_X = 20
    ROW_W = PANEL_W - 40
    shade = m.liveCatOverlay.CreateChild("Rectangle")
    shade.width = 1920 : shade.height = 1080 : shade.color = "0x00000052"
    panel = m.liveCatOverlay.CreateChild("Rectangle")
    panel.translation = [PANEL_X, PANEL_Y] : panel.width = PANEL_W : panel.height = PANEL_H : panel.color = "0x080B14EB"
    accent = m.liveCatOverlay.CreateChild("Rectangle")
    accent.translation = [PANEL_X, PANEL_Y] : accent.width = 6 : accent.height = PANEL_H : accent.color = THEME_ACCENT()
    eyebrow = m.liveCatOverlay.CreateChild("Label")
    eyebrow.translation = [ROW_X, 114] : eyebrow.width = ROW_W : eyebrow.height = 26
    eyebrow.font = ThemeFont(14, true) : eyebrow.color = THEME_ACCENT_LT()
    eyebrow.text = "JGLCUSTOMS  ·  TV EN VIVO"
    title = m.liveCatOverlay.CreateChild("Label")
    title.translation = [ROW_X, 143] : title.width = ROW_W : title.height = 46
    title.font = ThemeFont(25, true) : title.color = THEME_TEXT()
    title.ellipsisText = "..."
    if m.fullPanelMode = "channels" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        title.text = UCase(SafeStr(m.categories[m.catIdx].name))
    else
        title.text = "SECCIONES"
    end if
    if m.fullPanelMode = "loading"
        title.text = "CARGANDO CANALES..."
        return
    end if
    source = m.categories
    if m.fullPanelMode = "channels" then source = m.items
    VISIBLE = 9
    startI = m.fullPanelCursor - Int(VISIBLE / 2)
    if startI < 0 then startI = 0
    maxStart = source.Count() - VISIBLE
    if maxStart < 0 then maxStart = 0
    if startI > maxStart then startI = maxStart
    lastI = startI + VISIBLE - 1
    if lastI > source.Count() - 1 then lastI = source.Count() - 1
    if lastI < startI then return
    for i = startI to lastI
        entry = source[i]
        row = m.liveCatOverlay.CreateChild("Group")
        row.translation = [ROW_X, 210 + (i - startI) * 72]
        bg = row.CreateChild("Rectangle")
        bg.width = ROW_W : bg.height = 62
        active = (m.fullPanelMode = "channels" and i = m.gridIdx)
        bg.color = Tern(i = m.fullPanelCursor, THEME_ACCENT(), Tern(active, "0x48141DEB", "0x151A27DE"))
        marker = row.CreateChild("Rectangle")
        marker.width = 5 : marker.height = 62
        marker.color = Tern(active and i <> m.fullPanelCursor, THEME_ACCENT(), "0x00000000")
        xText = 22
        if m.fullPanelMode = "channels"
            logo = row.CreateChild("Poster")
            logo.uri = FirstImageUrl(entry) : logo.translation = [14, 8]
            logo.width = 56 : logo.height = 46 : logo.loadDisplayMode = "scaleToFit"
            xText = 82
        else
            dot = row.CreateChild("Rectangle")
            dot.translation = [18, 26] : dot.width = 9 : dot.height = 9
            dot.color = Tern(i = m.fullPanelCursor, "0xFFFFFFFF", THEME_ACCENT())
            xText = 48
        end if
        textWidth = ROW_W - xText - 14
        if m.fullPanelMode = "categories" then textWidth = textWidth - 42
        focused = (i = m.fullPanelCursor)
        needsScroll = (m.fullPanelMode = "channels" and focused and TextW(SafeStr(entry.name), 17) > textWidth)
        if needsScroll
            label = row.CreateChild("ScrollingLabel")
            label.text = SafeStr(entry.name) : label.translation = [xText, 0]
            label.maxWidth = textWidth : label.height = 62 : label.vertAlign = "center"
            label.scrollSpeed = 48 : label.repeatCount = -1
            label.font = ThemeFont(17, true) : label.color = "0xFFFFFFFF"
        else
            label = row.CreateChild("Label")
            label.text = SafeStr(entry.name) : label.translation = [xText, 0]
            label.width = textWidth : label.height = 62 : label.vertAlign = "center"
            label.ellipsisText = "..." : label.font = ThemeFont(17, focused)
            label.color = "0xFFFFFFFF"
        end if
        if m.fullPanelMode = "categories" and IsCatAdult(entry)
            lockBadge = row.CreateChild("Label")
            lockBadge.text = "+18" : lockBadge.translation = [ROW_W - 54, 0] : lockBadge.width = 48 : lockBadge.height = 62
            lockBadge.vertAlign = "center" : lockBadge.horizAlign = "center"
            lockBadge.font = ThemeFont(15, true) : lockBadge.color = "0xFFFFFFFF"
        else if m.fullPanelMode = "categories"
            arrow = row.CreateChild("Label")
            arrow.text = ">" : arrow.translation = [ROW_W - 36, 0] : arrow.width = 28 : arrow.height = 62
            arrow.vertAlign = "center" : arrow.horizAlign = "center"
            arrow.font = ThemeFont(18, true) : arrow.color = Tern(i = m.fullPanelCursor, "0xFFFFFFFF", THEME_MUTED())
        end if
    end for
    help = m.liveCatOverlay.CreateChild("Label")
    help.translation = [ROW_X, 948] : help.width = ROW_W : help.height = 26
    help.font = ThemeFont(14, false) : help.color = THEME_MUTED()
    help.text = Tern(m.fullPanelMode = "channels", "OK Reproducir  ·  Atrás Secciones", "OK Abrir  ·  Atrás Cerrar")
end sub
sub OpenFullLivePanel()
    if m.jglVStopped = true then return
    RecoveryCancel()
    if m.items.Count() > 0
        m.fullPanelMode = "channels"
        CalculateFullPanelWidth("channels")
        m.fullPanelCursor = m.gridIdx
        if m.fullPanelCursor < 0 or m.fullPanelCursor >= m.items.Count() then m.fullPanelCursor = 0
    else
        m.fullPanelMode = "categories"
        CalculateFullPanelWidth("categories")
        m.fullPanelCursor = m.catIdx
    end if
    m.fullPanelWaiting = false
    RenderFullLivePanel()
    if m.fullPanelSlide <> invalid then m.fullPanelSlide.control = "start"
end sub
sub CloseFullLivePanel()
    if m.jglVStopped = true then return
    m.fullPanelMode = ""
    m.fullPanelWaiting = false
    RenderFullLivePanel()
end sub
sub FullCategoryLoaded()
    if m.jglVStopped = true then return
    if not m.fullPanelWaiting then return
    m.fullPanelWaiting = false
    m.fullPanelMode = "channels"
    CalculateFullPanelWidth("channels")
    m.fullPanelCursor = 0
    key = GetCatId(m.categories[m.catIdx]).ToStr()
    if m.fullPanelPositions[key] <> invalid then m.fullPanelCursor = m.fullPanelPositions[key]
    if m.fullPanelCursor < 0 or m.fullPanelCursor >= m.items.Count() then m.fullPanelCursor = 0
    RenderFullLivePanel()
end sub
sub RenderGrid()
    if m.jglVStopped = true then return
    m.gridArea.RemoveChildren(m.gridArea.GetChildren(-1, 0))
    RenderHeader()
    if m.gridState = "loading"
        MakeStatusLabel("Cargando...")
        return
    else if m.gridState = "locked"
        MakeLockedState()
        return
    else if m.gridState = "error"
        MakeErrorState()
        return
    else if m.gridState = "empty"
        MakeEmptyState()
        return
    else if m.gridState = "nohevc"
        MakeNoHevcState()
        return
    end if
    nav = m.NAV[m.navIdx]
    if nav.id = "vivo"
        MakeLiveBrowser()
        return
    end if
    if IsVodSection(nav.id) or nav.id = "search" or nav.id = "history"
        MakeTileGrid(true)
    else
        MakeTileGrid(false)
    end if
end sub
sub MakeLiveBrowser()
    if m.jglVStopped = true then return
    if m.items.Count() = 0 then return
    if m.gridIdx < 0 then m.gridIdx = 0
    if m.gridIdx > m.items.Count() - 1 then m.gridIdx = m.items.Count() - 1
    it = m.items[m.gridIdx]
    preview = m.gridArea.CreateChild("Group")
    preview.translation = [40, 150]
    previewFocus = preview.CreateChild("Rectangle")
    previewFocus.width = 1092
    previewFocus.height = 620
    previewFocus.translation = [-6, -6]
    previewFocus.color = Tern(m.region = "preview", THEME_ACCENT(), "0x242631FF")
    previewBg = preview.CreateChild("Rectangle")
    previewBg.width = 1080
    previewBg.height = 790
    previewBg.color = "0x12131AFF"
    frame = preview.CreateChild("Rectangle")
    frame.width = 1080
    frame.height = 608
    frame.color = "0x07080CFF"
    art = preview.CreateChild("Poster")
    art.uri = FirstImageUrl(it)
    art.width = 500
    art.height = 340
    art.translation = [290, 134]
    art.loadDisplayMode = "scaleToFit"
    shade = preview.CreateChild("Rectangle")
    shade.width = 1080
    shade.height = 182
    shade.translation = [0, 608]
    shade.color = "0x171820FF"
    name = preview.CreateChild("Label")
    name.text = SafeStr(it.name)
    name.font = ThemeFont(28, true)
    name.color = THEME_TEXT()
    name.translation = [32, 635]
    name.width = 1016
    name.height = 48
    name.ellipsisText = "..."
    hint = preview.CreateChild("Label")
    hint.text = "OK  REPRODUCIR        ←  REPRODUCTOR        ↑↓  CANALES"
    hint.font = ThemeFont(16, true)
    hint.color = THEME_MUTED()
    hint.translation = [32, 714]
    hint.width = 1016
    list = m.gridArea.CreateChild("Group")
    list.translation = [1160, 128]
    title = list.CreateChild("Label")
    catName = "TV"
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() then catName = SafeStr(m.categories[m.catIdx].name)
    title.text = UCase(catName) + "  •  " + m.items.Count().ToStr() + " CANALES"
    title.font = ThemeFont(18, true)
    title.color = THEME_MUTED()
    title.width = 400
    title.height = 38
    VISIBLE = 11
    startI = m.rowOffset
    if startI < 0 then startI = 0
    maxStart = m.items.Count() - VISIBLE
    if maxStart < 0 then maxStart = 0
    if startI > maxStart then startI = maxStart
    lastI = startI + VISIBLE - 1
    if lastI > m.items.Count() - 1 then lastI = m.items.Count() - 1
    for i = startI to lastI
        channel = m.items[i]
        y = 48 + (i - startI) * 72
        focused = (m.region = "grid") and (i = m.gridIdx)
        row = list.CreateChild("Group")
        row.translation = [0, y]
        bg = row.CreateChild("Rectangle")
        bg.width = 422
        bg.height = 64
        bg.color = Tern(focused, "0xE51522FF", "0x181921FF")
        bar = row.CreateChild("Rectangle")
        bar.width = 5
        bar.height = 64
        bar.color = Tern(focused, "0xFFFFFFFF", "0x00000000")
        logo = row.CreateChild("Poster")
        logo.uri = FirstImageUrl(channel)
        logo.width = 58
        logo.height = 48
        logo.translation = [18, 8]
        logo.loadDisplayMode = "scaleToFit"
        label = row.CreateChild("Label")
        label.text = SafeStr(channel.name)
        label.font = ThemeFont(18, focused)
        label.color = THEME_TEXT()
        label.translation = [92, 0]
        label.width = 312
        label.height = 64
        label.vertAlign = "center"
        label.ellipsisText = "..."
    end for
end sub
sub EnsureLiveChannelVisible()
    if m.jglVStopped = true then return
    VISIBLE = 11
    if m.gridIdx < m.rowOffset
        m.rowOffset = m.gridIdx
    else if m.gridIdx > m.rowOffset + VISIBLE - 1
        m.rowOffset = m.gridIdx - VISIBLE + 1
    end if
end sub
sub MakeStatusLabel(msg as String)
    if m.jglVStopped = true then return
    id = m.NAV[m.navIdx].id
    tileH = Tern(IsVodSection(id) or id = "search" or id = "history", POSTER_TILE_H(), CH_TILE_H())
    stepX = TILE_W() + GRID_GAP()
    stepY = tileH + TILE_LABEL_H() + GRID_GAP()
    for row = 0 to VisRows() - 1
        for col = 0 to GRID_COLS() - 1
            sk = m.gridArea.CreateChild("Rectangle")
            sk.width  = TILE_W()
            sk.height = tileH + TILE_LABEL_H()
            sk.translation = [col * stepX, row * stepY]
            sk.color = "0x161920FF"
        end for
    end for
    lbl = m.gridArea.CreateChild("Label")
    lbl.text = msg
    lbl.font = ThemeFont(19, true)
    lbl.color = THEME_MUTED()
    lbl.translation = [0, 640]
    lbl.width = 1682
    lbl.horizAlign = "center"
end sub
sub MakeLockedState()
    if m.jglVStopped = true then return
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 120]
    lockBg = g.CreateChild("Rectangle")
    lockBg.width  = 110
    lockBg.height = 110
    lockBg.translation = [786, 0]
    lockBg.color = "0x1A1D26FF"
    lockIcon = g.CreateChild("Label")
    lockIcon.text = "[+18]"
    lockIcon.font = ThemeFont(30, true)
    lockIcon.color = THEME_GOLD()
    lockIcon.translation = [786, 0]
    lockIcon.width  = 110
    lockIcon.height = 110
    lockIcon.horizAlign = "center"
    lockIcon.vertAlign  = "center"
    title = g.CreateChild("Label")
    title.text = "Este canal no se puede ver, nino cachondo."
    title.font = ThemeFont(32, true)
    title.color = THEME_TEXT()
    title.translation = [0, 130]
    title.width = 1682
    title.horizAlign = "center"
    sub1 = g.CreateChild("Label")
    sub1.text = "Aqui solo entran los mayores de edad."
    sub1.font = ThemeFont(20, false)
    sub1.color = THEME_MUTED()
    sub1.translation = [341, 182]
    sub1.width = 1000
    sub1.horizAlign = "center"
    sub1.wrap = true
    sub2 = g.CreateChild("Label")
    sub2.text = "Pon tu PIN de 4 digitos si eres adulto  —  OK"
    sub2.font = ThemeFont(20, false)
    sub2.color = THEME_MUTED()
    sub2.translation = [341, 220]
    sub2.width = 1000
    sub2.horizAlign = "center"
    sub2.wrap = true
    btn = g.CreateChild("Rectangle")
    btn.width  = 300
    btn.height = 58
    btn.translation = [691, 278]
    btn.color = THEME_ACCENT()
    btnLbl = g.CreateChild("Label")
    btnLbl.text = "Desbloquear  —  OK"
    btnLbl.font = ThemeFont(19, true)
    btnLbl.color = "0x0D0E12FF"
    btnLbl.translation = [691, 278]
    btnLbl.width  = 300
    btnLbl.height = 58
    btnLbl.horizAlign = "center"
    btnLbl.vertAlign  = "center"
end sub
sub MakeNoHevcState()
    if m.jglVStopped = true then return
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 150]
    title = g.CreateChild("Label")
    title.text = "Este equipo no puede reproducir peliculas"
    title.font = ThemeFont(30, true)
    title.color = THEME_TEXT()
    title.translation = [0, 110]
    title.width = 1682
    title.horizAlign = "center"
    sub_ = g.CreateChild("Label")
    sub_.text = "El Roku no pudo decodificar el formato de este título. Esto no significa que todas las películas o series utilicen el mismo códec."
    sub_.font = ThemeFont(18, false)
    sub_.color = THEME_MUTED()
    sub_.translation = [431, 158]
    sub_.width = 820
    sub_.horizAlign = "center"
    sub_.wrap = true
end sub
sub MakeErrorState()
    if m.jglVStopped = true then return
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 150]
    badge = g.CreateChild("Rectangle")
    badge.width = 84
    badge.height = 84
    badge.translation = [799, 0]
    badge.color = THEME_ERR_BG()
    icon = g.CreateChild("Label")
    icon.text = "!"
    icon.font = ThemeFont(46, true)
    icon.color = THEME_ERR_ICON()
    icon.translation = [799, 0]
    icon.width = 84
    icon.height = 84
    icon.horizAlign = "center"
    icon.vertAlign  = "center"
    title = g.CreateChild("Label")
    nav = m.NAV[m.navIdx]
    title.text = Tern(nav.id = "vivo", "No pudimos cargar esta sección", "No pudimos cargar el contenido")
    title.font = ThemeFont(30, true)
    title.color = THEME_TEXT()
    title.translation = [0, 110]
    title.width = 1682
    title.horizAlign = "center"
    sub_ = g.CreateChild("Label")
    sub_.text = "Revisa la red o vuelve a intentar. Debajo está el detalle técnico para diagnosticarlo."
    sub_.font = ThemeFont(18, false)
    sub_.color = THEME_MUTED()
    sub_.translation = [431, 158]
    sub_.width = 820
    sub_.horizAlign = "center"
    sub_.wrap = true
    detailBg = g.CreateChild("Rectangle")
    detailBg.width = 1000
    detailBg.height = 96
    detailBg.translation = [341, 210]
    detailBg.color = "0x101119FF"
    detail = g.CreateChild("Label")
    detail.text = m.errorDetail
    detail.font = ThemeFont(16, false)
    detail.color = "0xFF8B92FF"
    detail.translation = [365, 224]
    detail.width = 952
    detail.height = 70
    detail.wrap = true
    detail.maxLines = 3
    btn = g.CreateChild("Rectangle")
    btn.width = 240
    btn.height = 54
    btn.translation = [721, 334]
    btn.color = THEME_ACCENT()
    btnLbl = g.CreateChild("Label")
    btnLbl.text = "Reintentar  .  OK"
    btnLbl.font = ThemeFont(18, true)
    btnLbl.color = "0x0D0E12FF"
    btnLbl.translation = [721, 334]
    btnLbl.width = 240
    btnLbl.height = 54
    btnLbl.horizAlign = "center"
    btnLbl.vertAlign  = "center"
end sub
sub MakeEmptyState()
    if m.jglVStopped = true then return
    nav = m.NAV[m.navIdx]
    g = m.gridArea.CreateChild("Group")
    g.translation = [0, 170]
    badge = g.CreateChild("Rectangle")
    badge.width = 84
    badge.height = 84
    badge.translation = [799, 0]
    badge.color = THEME_SURFACE()
    icon = g.CreateChild("Label")
    icon.text = "*"
    icon.font = ThemeFont(46, true)
    icon.color = THEME_MUTED2()
    icon.translation = [799, 0]
    icon.width = 84
    icon.height = 84
    icon.horizAlign = "center"
    icon.vertAlign  = "center"
    title = g.CreateChild("Label")
    title.font = ThemeFont(30, true)
    title.color = THEME_TEXT()
    title.translation = [0, 110]
    title.width = 1682
    title.horizAlign = "center"
    title.text = Tern(nav.id = "history", "Aún no has reproducido contenido", "Sin contenido por aquí")
    sub_ = g.CreateChild("Label")
    sub_.font = ThemeFont(18, false)
    sub_.color = THEME_MUTED()
    sub_.translation = [431, 158]
    sub_.width = 820
    sub_.horizAlign = "center"
    sub_.wrap = true
    sub_.text = Tern(nav.id = "history", "Lo que veas en Roku aparecerá aquí para retomarlo rápidamente.", "No encontramos contenido en esta categoría. Prueba con otra.")
end sub
sub MakeTileGrid(isPoster as Boolean)
    if m.jglVStopped = true then return
    tileH   = Tern(isPoster, POSTER_TILE_H(), CH_TILE_H())
    labelH  = TILE_LABEL_H()
    stepX   = TILE_W() + GRID_GAP()
    stepY   = tileH + labelH + GRID_GAP()
    cols    = GRID_COLS()
    firstIdx = m.rowOffset * cols
    lastIdx  = firstIdx + (VisRows() * cols) - 1
    if lastIdx > m.items.Count() - 1 then lastIdx = m.items.Count() - 1
    for i = firstIdx to lastIdx
        it = m.items[i]
        col = i mod cols
        row = Int(i / cols) - m.rowOffset
        focused = (m.region = "grid") and (i = m.gridIdx)
        tile = m.gridArea.CreateChild("Group")
        tile.translation = [col * stepX, row * stepY]
        if focused
            ring = tile.CreateChild("Rectangle")
            ring.width  = TILE_W() + 12
            ring.height = tileH + labelH + 12
            ring.translation = [-6, -6]
            ring.color = THEME_ACCENT()
        end if
        wrap = tile.CreateChild("Rectangle")
        wrap.width = TILE_W()
        wrap.height = tileH + labelH
        wrap.color = Tern(focused, THEME_SURFACE2(), THEME_SURFACE())
        img = tile.CreateChild("Poster")
        img.uri = FirstImageUrl(it)
        img.width = TILE_W()
        img.height = tileH
        img.loadDisplayMode = Tern(isPoster, "scaleToFill", "scaleToFit")
        if isPoster
            codecText = VodCodecForItem(it)
            if codecText <> ""
                codecBg = tile.CreateChild("Rectangle")
                codecBg.width = 108
                codecBg.height = 24
                codecBg.translation = [TILE_W() - 116, 8]
                codecBg.color = "0x090B11E8"
                codecLbl = tile.CreateChild("Label")
                codecLbl.text = codecText.Replace("H.264/", "").Replace("H.265/", "")
                codecLbl.font = ThemeFont(12, true)
                codecLbl.color = "0xE4E7EDFF"
                codecLbl.translation = [TILE_W() - 116, 8]
                codecLbl.width = 108
                codecLbl.height = 24
                codecLbl.horizAlign = "center"
                codecLbl.vertAlign = "center"
            end if
        end if
        if not isPoster
            liveBg = tile.CreateChild("Rectangle")
            liveBg.width = 58
            liveBg.height = 17
            liveBg.translation = [8, 8]
            liveBg.color = THEME_LIVE()
            liveLbl = tile.CreateChild("Label")
            liveLbl.text = "EN VIVO"
            liveLbl.font = ThemeFont(10, true)
            liveLbl.color = "0xFFFFFFFF"
            liveLbl.translation = [8, 8]
            liveLbl.width = 58
            liveLbl.height = 17
            liveLbl.horizAlign = "center"
            liveLbl.vertAlign  = "center"
            if IsLocked(it)
                lockBg = tile.CreateChild("Rectangle")
                lockBg.width = 26
                lockBg.height = 17
                lockBg.translation = [TILE_W() - 34, 8]
                lockBg.color = "0x08090CCC"
                lockLbl = tile.CreateChild("Label")
                lockLbl.text = "+18"
                lockLbl.font = ThemeFont(10, true)
                lockLbl.color = THEME_GOLD()
                lockLbl.translation = [TILE_W() - 34, 8]
                lockLbl.width = 26
                lockLbl.height = 17
                lockLbl.horizAlign = "center"
                lockLbl.vertAlign  = "center"
            end if
        end if
        code = ItemCode(it)
        isFav = (code <> "" and m.favs[code] <> invalid)
        name = tile.CreateChild("Label")
        name.text = SafeStr(it.name)
        name.font = ThemeFont(22, true)
        name.color = THEME_TEXT()
        name.translation = [11, tileH]
        name.width  = TILE_W() - Tern(isFav, 40, 22)
        name.height = labelH
        name.vertAlign = "center"
        name.ellipsisText = "..."
        if isFav
            favLbl = tile.CreateChild("Label")
            favLbl.text = "*"
            favLbl.font = ThemeFont(18, true)
            favLbl.color = THEME_GOLD()
            favLbl.translation = [TILE_W() - 26, tileH]
            favLbl.height = labelH
            favLbl.vertAlign = "center"
        end if
    end for
end sub
function FirstImageUrl(it as Object) as String
    for each field in ["showIconUrl", "posterUrl", "showPosterUrl", "poster", "image"]
        v = it[field]
        if v <> invalid and Type(v) = "String" and v <> "" then return v
    end for
    if it.posterList <> invalid and it.posterList.Count() > 0
        icon = ""
        first = ""
        for each p in it.posterList
            u = SafeStr(p.fileUrl)
            if first = "" then first = u
            if p.fileType = "icon" then icon = u
        end for
        if icon <> "" then return icon
        return first
    end if
    return ""
end function
function IsLocked(it as Object) as Boolean
    if it.isLock = true then return true
    if SafeStr(it.restricted) = "1" then return true
    return false
end function
function ItemCode(it as Object) as String
    if it.channelCode <> invalid then return SafeStr(it.channelCode)
    if it.contentId <> invalid then return SafeStr(it.contentId)
    if it.id <> invalid then return SafeStr(it.id)
    return ""
end function
function VodContentVersion(it as Object) as String
    for each key in ["contentVersion", "mediaVersion", "assetVersion", "updateTime", "modifyTime", "version"]
        value = SafeStr(it[key])
        if value <> "" then return value
    end for
    return ""
end function
function VodCodecKey(it as Object) as String
    id = ItemCode(it)
    if id = "" then return ""
    return id + "|" + VodContentVersion(it)
end function
function VodCodecForItem(it as Object) as String
    fromApi = Hardware_CodecFromMetadata(it)
    if fromApi <> "" then return fromApi
    key = VodCodecKey(it)
    if key <> "" and m.vodCodecCache[key] <> invalid then return SafeStr(m.vodCodecCache[key])
    return ""
end function
sub OnDetectedVideoCodec(event as Object)
    if m.jglVStopped = true then return
    codec = Hardware_CodecLabel(event.GetData())
    if codec = "" or m.activeVodCodecKey = "" then return
    m.vodCodecCache[m.activeVodCodecKey] = codec
end sub
sub OnDetectedAudioFormat(event as Object)
    if m.jglVStopped = true then return
    audio = SafeStr(event.GetData())
    if audio = "" or m.activeVodCodecKey = "" then return
    m.vodAudioCache[m.activeVodCodecKey] = audio
end sub
function VodAudioForItem(it as Object, data as Dynamic) as String
    fromApi = VodTextValue(data, it, ["audioCodec", "audioFormat", "audio_codec", "soundFormat"])
    if fromApi <> "" then return fromApi
    key = VodCodecKey(it)
    if key <> "" and m.vodAudioCache[key] <> invalid then return SafeStr(m.vodAudioCache[key])
    return ""
end function
function VodRawValue(primary as Dynamic, secondary as Dynamic, keys as Object) as Dynamic
    for each source in [primary, secondary]
        if source <> invalid
            for each key in keys
                value = source[key]
                if value <> invalid
                    if GetInterface(value, "ifArray") <> invalid then return value
                    if SafeStr(value) <> "" then return value
                end if
            end for
        end if
    end for
    return invalid
end function
function VodTextValue(primary as Dynamic, secondary as Dynamic, keys as Object) as String
    value = VodRawValue(primary, secondary, keys)
    if value = invalid then return ""
    if GetInterface(value, "ifArray") <> invalid
        out = ""
        for each part in value
            text = SafeStr(part)
            if text <> ""
                if out <> "" then out = out + " · "
                out = out + text
            end if
        end for
        return out
    end if
    return SafeStr(value)
end function
function VodSynopsis(item as Object, data as Dynamic) as String
    return VodTextValue(data, item, ["synopsis", "summary", "description", "introduce", "introduction", "plot", "programDesc"])
end function
function VodSecondaryLine(item as Object, data as Dynamic) as String
    out = ""
    year = VodTextValue(data, item, ["releaseYear", "year", "premiereYear", "publishYear"])
    genre = VodTextValue(data, item, ["genres", "genre", "genreName", "categoryName"])
    duration = VodTextValue(data, item, ["duration", "timeLen", "totalTime", "playTime", "length"])
    for each value in [year, genre, duration]
        if value <> ""
            if out <> "" then out = out + "  ·  "
            out = out + value
        end if
    end for
    return out
end function
function AddVodTag(root as Object, text as String, x as Integer, y as Integer) as Integer
    if text = "" then return x
    width = TextW(text, 15) + 34
    if width < 92 then width = 92
    bg = root.CreateChild("Rectangle")
    bg.translation = [x, y] : bg.width = width : bg.height = 38 : bg.color = "0x252936FF"
    label = root.CreateChild("Label")
    label.translation = [x, y] : label.width = width : label.height = 38
    label.text = text : label.font = ThemeFont(15, true) : label.color = "0xE8EAF0FF"
    label.horizAlign = "center" : label.vertAlign = "center"
    return x + width + 12
end function
sub AddVodTechnicalTags(root as Object, item as Object, data as Dynamic, x as Integer, y as Integer)
    if m.jglVStopped = true then return
    codec = Hardware_CodecFromMetadata(data)
    if codec = "" then codec = VodCodecForItem(item)
    resolution = VodTextValue(data, item, ["resolution", "videoResolution", "definition", "quality"])
    audio = VodAudioForItem(item, data)
    duration = VodTextValue(data, item, ["duration", "timeLen", "totalTime", "playTime", "length"])
    x = AddVodTag(root, codec, x, y)
    x = AddVodTag(root, resolution, x, y)
    x = AddVodTag(root, audio, x, y)
    x = AddVodTag(root, duration, x, y)
end sub
function EpisodeSeasonKey(ep as Object) as String
    return VodTextValue(ep, invalid, ["seasonNumber", "season", "seasonNum", "seasonNo", "seriesNo"])
end function
function EpisodeNumberText(ep as Object) as String
    return VodTextValue(ep, invalid, ["episodeNumber", "episode", "episodeNum", "episodeNo", "seriesEpisode"])
end function
sub BuildVodSeasons(episodes as Object)
    if m.jglVStopped = true then return
    groups = []
    positions = {}
    for each ep in episodes
        key = EpisodeSeasonKey(ep)
        mapKey = key
        if mapKey = "" then mapKey = "__episodes"
        idxValue = positions[mapKey]
        if idxValue = invalid
            label = "Episodios"
            if key <> "" then label = "Temporada " + key
            groups.Push({ key: key, name: label, episodes: [] })
            idxValue = groups.Count() - 1
            positions[mapKey] = idxValue
        end if
        groups[idxValue].episodes.Push(ep)
    end for
    m.vodDetailSeasons = groups
    if m.vodDetailSeasonIdx >= groups.Count() then m.vodDetailSeasonIdx = 0
    m.vodDetailEpisodeIdx = 0
end sub
sub OpenVodDetail(item as Object)
    if m.jglVStopped = true then return
    m.vodDetailItem = item
    m.vodDetailData = invalid
    m.vodDetailSeries = invalid
    m.vodDetailSeriesData = invalid
    m.vodDetailEpisodes = []
    m.vodDetailSeasons = []
    m.vodDetailSeasonIdx = 0
    m.vodDetailEpisodeIdx = 0
    m.vodDetailMode = Tern(IsSeries(item), "series", "movie")
    if m.vodDetailMode = "series" then m.vodDetailSeries = item
    m.vodDetailRegion = Tern(m.vodDetailMode = "series", "seasons", "play")
    m.vodDetailLoading = true
    m.content.visible = false
    m.rail.visible = false
    m.vodDetailOverlay.visible = true
    RenderVodDetail()
    if m.detailTask <> invalid then m.detailTask.control = "STOP"
    m.detailTask = Api_OpTask("itemData", { contentId: SafeStr(item.contentId) })
    if m.detailTask = invalid
        m.vodDetailLoading = false
        RenderVodDetail()
        return
    end if
    m.detailTask.ObserveField("rawResp", "OnVodDetailResp")
    m.detailTask.ObserveField("error", "OnVodDetailError")
    m.detailTask.control = "RUN"
end sub
sub OnVodDetailResp(event as Object)
    if m.jglVStopped = true then return
    data = Api_ParseOp(event.GetData())
    if data <> invalid
        ad = data.assetData
        if ad = invalid then ad = data
        m.vodDetailData = ad
        if m.vodDetailMode = "series" and ad.simpleProgramList <> invalid
            m.vodDetailSeriesData = ad
            m.vodDetailEpisodes = ad.simpleProgramList
            for each ep in m.vodDetailEpisodes
                if FirstImageUrl(ep) = "" then ep.posterUrl = FirstImageUrl(m.vodDetailSeries)
            end for
            BuildVodSeasons(m.vodDetailEpisodes)
        end if
    end if
    m.vodDetailLoading = false
    RenderVodDetail()
end sub
sub OnVodDetailError(event as Object)
    if m.jglVStopped = true then return
    m.vodDetailLoading = false
    RenderVodDetail()
end sub
sub CloseVodDetail()
    if m.jglVStopped = true then return
    if m.detailTask <> invalid then m.detailTask.control = "STOP"
    m.detailTask = invalid
    m.vodDetailMode = ""
    m.vodDetailOverlay.visible = false
    m.vodDetailOverlay.RemoveChildren(m.vodDetailOverlay.GetChildren(-1, 0))
    m.seriesMode = false
    m.seriesContentId = ""
    m.content.visible = true
    m.rail.visible = true
    m.top.SetFocus(true)
end sub
sub RenderVodDetail()
    if m.jglVStopped = true then return
    g = m.vodDetailOverlay
    g.RemoveChildren(g.GetChildren(-1, 0))
    if m.vodDetailMode = "" then g.visible = false : return
    g.visible = true
    bg = g.CreateChild("Rectangle")
    bg.width = 1920 : bg.height = 1080 : bg.color = "0x080A11FF"
    card = g.CreateChild("Rectangle")
    card.translation = [64, 54] : card.width = 1792 : card.height = 972 : card.color = "0x111521FF"
    if m.vodDetailMode = "series"
        RenderVodSeriesDetail(g)
    else
        RenderVodPlayableDetail(g)
    end if
    if m.vodErrorActive then RenderVodErrorPanel(g)
end sub
sub RenderVodErrorPanel(g as Object)
    if m.jglVStopped = true then return
    help = Help_Get(m.vodErrorCode)
    shade = g.CreateChild("Rectangle")
    shade.width = 1920 : shade.height = 1080 : shade.color = "0x00000099"
    panel = g.CreateChild("Rectangle")
    panel.translation = [350, 220] : panel.width = 1220 : panel.height = 680
    panel.color = "0x121722FF"
    accent = g.CreateChild("Rectangle")
    accent.translation = [350, 220] : accent.width = 8 : accent.height = 680
    accent.color = THEME_ACCENT()
    warningBg = g.CreateChild("Rectangle")
    warningBg.translation = [410, 252] : warningBg.width = 46 : warningBg.height = 46
    warningBg.color = THEME_ACCENT()
    warning = g.CreateChild("Label")
    warning.translation = [410, 252] : warning.width = 46 : warning.height = 46
    warning.text = "!" : warning.font = ThemeFont(29, true) : warning.color = "0xFFFFFFFF"
    warning.horizAlign = "center" : warning.vertAlign = "center"
    brandIcon = g.CreateChild("Poster")
    brandIcon.translation = [1408, 240]
    brandIcon.width = 128 : brandIcon.height = 80
    brandIcon.uri = "pkg:/images/jglv/icon_focus_hd.png"
    brandIcon.loadDisplayMode = "scaleToFit"
    title = g.CreateChild("Label")
    title.translation = [480, 248] : title.width = 920 : title.height = 58
    title.text = "Error de reproducción"
    title.font = ThemeFont(31, true) : title.color = THEME_TEXT()
    errorName = g.CreateChild("Label")
    errorName.translation = [430, 326] : errorName.width = 1060 : errorName.height = 42
    errorName.text = SafeStr(help.title)
    errorName.font = ThemeFont(24, true) : errorName.color = THEME_TEXT()
    message = g.CreateChild("Label")
    message.translation = [430, 374] : message.width = 1060 : message.height = 70
    message.text = SafeStr(help.description)
    message.font = ThemeFont(18, false) : message.color = THEME_MUTED()
    message.wrap = true : message.maxLines = 2
    codeBg = g.CreateChild("Rectangle")
    codeBg.translation = [430, 454] : codeBg.width = 148 : codeBg.height = 36
    codeBg.color = "0x2A2E39FF"
    codeLabel = g.CreateChild("Label")
    codeLabel.translation = [430, 454] : codeLabel.width = 148 : codeLabel.height = 36
    codeLabel.text = SafeStr(help.code) : codeLabel.font = ThemeFont(16, true)
    codeLabel.color = "0xFFFFFFFF" : codeLabel.horizAlign = "center" : codeLabel.vertAlign = "center"
    localHelpBg = g.CreateChild("Rectangle")
    localHelpBg.translation = [430, 510] : localHelpBg.width = 1060 : localHelpBg.height = 190
    localHelpBg.color = "0x1A1F2AFF"
    causeTitle = g.CreateChild("Label")
    causeTitle.translation = [458, 524] : causeTitle.width = 1004 : causeTitle.height = 30
    causeTitle.text = "POSIBLE CAUSA"
    causeTitle.font = ThemeFont(16, true) : causeTitle.color = THEME_ACCENT()
    causeText = g.CreateChild("Label")
    causeText.translation = [458, 554] : causeText.width = 1004 : causeText.height = 48
    causeText.text = SafeStr(help.cause)
    causeText.font = ThemeFont(17, false) : causeText.color = "0xCDD1DAFF"
    causeText.wrap = true : causeText.maxLines = 2
    actionTitle = g.CreateChild("Label")
    actionTitle.translation = [458, 610] : actionTitle.width = 1004 : actionTitle.height = 30
    actionTitle.text = "QUÉ HACER"
    actionTitle.font = ThemeFont(16, true) : actionTitle.color = THEME_ACCENT()
    actionText = g.CreateChild("Label")
    actionText.translation = [458, 640] : actionText.width = 1004 : actionText.height = 48
    actionText.text = SafeStr(help.action)
    actionText.font = ThemeFont(17, false) : actionText.color = "0xCDD1DAFF"
    actionText.wrap = true : actionText.maxLines = 2
    retryBg = g.CreateChild("Rectangle")
    retryBg.translation = [430, 754] : retryBg.width = 350 : retryBg.height = 68
    retryBg.color = Tern(m.vodErrorChoice = 0, THEME_ACCENT(), "0x303442FF")
    retry = g.CreateChild("Label")
    retry.translation = [430, 754] : retry.width = 350 : retry.height = 68
    retry.text = "Reintentar" : retry.font = ThemeFont(22, true) : retry.color = "0xFFFFFFFF"
    retry.horizAlign = "center" : retry.vertAlign = "center"
    backBg = g.CreateChild("Rectangle")
    backBg.translation = [810, 754] : backBg.width = 470 : backBg.height = 68
    backBg.color = Tern(m.vodErrorChoice = 1, THEME_ACCENT(), "0x303442FF")
    back = g.CreateChild("Label")
    back.translation = [810, 754] : back.width = 470 : back.height = 68
    back.text = "Volver a detalles" : back.font = ThemeFont(22, true) : back.color = "0xFFFFFFFF"
    back.horizAlign = "center" : back.vertAlign = "center"
    hint = g.CreateChild("Label")
    hint.translation = [430, 844] : hint.width = 1060 : hint.height = 30
    hint.text = "◀ ▶ Elegir  ·  OK Confirmar  ·  Atrás Volver a detalles"
    hint.font = ThemeFont(16, false) : hint.color = THEME_MUTED()
end sub
sub RenderVodPlayableDetail(g as Object)
    if m.jglVStopped = true then return
    item = m.vodDetailItem
    data = m.vodDetailData
    poster = g.CreateChild("Poster")
    poster.translation = [104, 92] : poster.width = 400 : poster.height = 600
    poster.uri = FirstImageUrl(item) : poster.loadDisplayMode = "scaleToFill"
    title = g.CreateChild("Label")
    title.translation = [560, 104] : title.width = 1190 : title.height = 76
    title.text = SafeStr(item.name) : title.font = ThemeFont(42, true) : title.color = THEME_TEXT()
    title.ellipsisText = "..."
    meta = g.CreateChild("Label")
    meta.translation = [560, 180] : meta.width = 1190 : meta.height = 38
    meta.text = VodSecondaryLine(item, data) : meta.font = ThemeFont(19, false) : meta.color = THEME_MUTED()
    synopsis = g.CreateChild("Label")
    synopsis.translation = [560, 238] : synopsis.width = 1190 : synopsis.height = 300
    synopsis.text = VodSynopsis(item, data)
    if synopsis.text = "" then synopsis.text = "Sin sinopsis disponible."
    synopsis.font = ThemeFont(20, false) : synopsis.color = "0xD5D8E0FF"
    synopsis.wrap = true : synopsis.maxLines = 10
    AddVodTechnicalTags(g, item, data, 560, 570)
    if m.vodDetailMode = "episode"
        ep = EpisodeNumberText(item) : season = EpisodeSeasonKey(item)
        episodeLine = ""
        if season <> "" then episodeLine = "Temporada " + season
        if ep <> ""
            if episodeLine <> "" then episodeLine = episodeLine + "  ·  "
            episodeLine = episodeLine + "Episodio " + ep
        end if
        info = g.CreateChild("Label")
        info.translation = [560, 650] : info.width = 1000 : info.height = 42
        info.text = episodeLine : info.font = ThemeFont(20, true) : info.color = THEME_MUTED()
    end if
    playBg = g.CreateChild("Rectangle")
    playBg.translation = [560, 820] : playBg.width = 360 : playBg.height = 76
    playBg.color = Tern(m.vodDetailRegion = "play", THEME_ACCENT(), "0x303442FF")
    play = g.CreateChild("Label")
    play.translation = [560, 820] : play.width = 360 : play.height = 76
    play.text = ">  Reproducir" : play.font = ThemeFont(24, true) : play.color = "0xFFFFFFFF"
    play.horizAlign = "center" : play.vertAlign = "center"
    hint = g.CreateChild("Label")
    hint.translation = [560, 928] : hint.width = 900 : hint.height = 34
    hint.text = "OK Reproducir  ·  Atrás Regresar" : hint.font = ThemeFont(16, false) : hint.color = THEME_MUTED()
end sub
sub RenderVodSeriesDetail(g as Object)
    if m.jglVStopped = true then return
    item = m.vodDetailSeries
    data = m.vodDetailData
    poster = g.CreateChild("Poster")
    poster.translation = [104, 92] : poster.width = 260 : poster.height = 390
    poster.uri = FirstImageUrl(item) : poster.loadDisplayMode = "scaleToFill"
    title = g.CreateChild("Label")
    title.translation = [410, 96] : title.width = 1340 : title.height = 68
    title.text = SafeStr(item.name) : title.font = ThemeFont(38, true) : title.color = THEME_TEXT()
    meta = g.CreateChild("Label")
    meta.translation = [410, 164] : meta.width = 1340 : meta.height = 34
    meta.text = VodSecondaryLine(item, data) : meta.font = ThemeFont(18, false) : meta.color = THEME_MUTED()
    synopsis = g.CreateChild("Label")
    synopsis.translation = [410, 212] : synopsis.width = 1340 : synopsis.height = 190
    synopsis.text = VodSynopsis(item, data)
    if synopsis.text = "" then synopsis.text = "Sin sinopsis disponible."
    synopsis.font = ThemeFont(19, false) : synopsis.color = "0xD5D8E0FF"
    synopsis.wrap = true : synopsis.maxLines = 6
    AddVodTechnicalTags(g, item, data, 410, 420)
    seasonsTitle = g.CreateChild("Label")
    seasonsTitle.translation = [104, 520] : seasonsTitle.width = 330 : seasonsTitle.height = 40
    seasonsTitle.text = "TEMPORADAS" : seasonsTitle.font = ThemeFont(20, true) : seasonsTitle.color = THEME_TEXT()
    episodesTitle = g.CreateChild("Label")
    episodesTitle.translation = [470, 520] : episodesTitle.width = 1240 : episodesTitle.height = 40
    episodesTitle.text = "EPISODIOS" : episodesTitle.font = ThemeFont(20, true) : episodesTitle.color = THEME_TEXT()
    if m.vodDetailLoading
        loading = g.CreateChild("Label")
        loading.translation = [104, 590] : loading.width = 900 : loading.height = 48
        loading.text = "Cargando información..." : loading.font = ThemeFont(20, false) : loading.color = THEME_MUTED()
        return
    end if
    if m.vodDetailSeasons.Count() = 0
        empty = g.CreateChild("Label")
        empty.translation = [104, 590] : empty.width = 1100 : empty.height = 48
        empty.text = "No se recibieron episodios para esta serie." : empty.font = ThemeFont(20, false) : empty.color = THEME_MUTED()
        return
    end if
    firstSeason = m.vodDetailSeasonIdx - 3
    if firstSeason < 0 then firstSeason = 0
    lastSeason = firstSeason + 6
    if lastSeason >= m.vodDetailSeasons.Count() then lastSeason = m.vodDetailSeasons.Count() - 1
    for i = firstSeason to lastSeason
        row = g.CreateChild("Rectangle")
        row.translation = [104, 570 + (i - firstSeason) * 58] : row.width = 320 : row.height = 50
        focused = (m.vodDetailRegion = "seasons" and i = m.vodDetailSeasonIdx)
        row.color = Tern(focused, THEME_ACCENT(), Tern(i = m.vodDetailSeasonIdx, "0x3A2028FF", "0x202431FF"))
        label = g.CreateChild("Label")
        label.translation = [122, 570 + (i - firstSeason) * 58] : label.width = 282 : label.height = 50
        label.text = SafeStr(m.vodDetailSeasons[i].name) : label.font = ThemeFont(17, focused) : label.color = "0xFFFFFFFF"
        label.vertAlign = "center" : label.ellipsisText = "..."
    end for
    eps = m.vodDetailSeasons[m.vodDetailSeasonIdx].episodes
    if m.vodDetailEpisodeIdx >= eps.Count() then m.vodDetailEpisodeIdx = 0
    firstEp = m.vodDetailEpisodeIdx - 3
    if firstEp < 0 then firstEp = 0
    lastEp = firstEp + 5
    if lastEp >= eps.Count() then lastEp = eps.Count() - 1
    for i = firstEp to lastEp
        ep = eps[i]
        y = 570 + (i - firstEp) * 70
        row = g.CreateChild("Rectangle")
        row.translation = [470, y] : row.width = 1240 : row.height = 62
        focused = (m.vodDetailRegion = "episodes" and i = m.vodDetailEpisodeIdx)
        row.color = Tern(focused, THEME_ACCENT(), "0x202431FF")
        thumb = g.CreateChild("Poster")
        thumb.translation = [482, y + 6] : thumb.width = 86 : thumb.height = 50
        thumb.uri = FirstImageUrl(ep) : thumb.loadDisplayMode = "scaleToFill"
        epNo = EpisodeNumberText(ep)
        epName = SafeStr(ep.name)
        if epNo <> "" then epName = "E" + epNo + "  ·  " + epName
        label = g.CreateChild("Label")
        label.translation = [586, y] : label.width = 820 : label.height = 62
        label.text = epName : label.font = ThemeFont(17, focused) : label.color = "0xFFFFFFFF"
        label.vertAlign = "center" : label.ellipsisText = "..."
        codec = VodCodecForItem(ep)
        if codec <> ""
            tag = g.CreateChild("Label")
            tag.translation = [1430, y] : tag.width = 250 : tag.height = 62
            tag.text = codec : tag.font = ThemeFont(14, true) : tag.color = "0xD8DBE4FF"
            tag.horizAlign = "right" : tag.vertAlign = "center"
        end if
    end for
end sub
sub OpenVodEpisodeDetail(ep as Object)
    if m.jglVStopped = true then return
    m.vodDetailSeriesData = m.vodDetailData
    m.vodDetailItem = ep
    m.vodDetailData = ep
    m.vodDetailMode = "episode"
    m.vodDetailRegion = "play"
    RenderVodDetail()
end sub
sub ReturnToVodSeriesDetail()
    if m.jglVStopped = true then return
    m.vodDetailMode = "series"
    m.vodDetailItem = m.vodDetailSeries
    m.vodDetailData = m.vodDetailSeriesData
    m.vodDetailRegion = "episodes"
    RenderVodDetail()
end sub
sub StartVodDetailPlayback()
    if m.jglVStopped = true then return
    it = m.vodDetailItem
    seriesPlayback = (m.vodDetailMode = "episode")
    seriesId = ""
    if seriesPlayback and m.vodDetailSeries <> invalid then seriesId = SafeStr(m.vodDetailSeries.contentId)
    m.vodDetailOverlay.visible = false
    StartVodPlayback(it, seriesPlayback, seriesId)
end sub
sub PlayVodDetail()
    if m.jglVStopped = true then return
    codec = VodCodecForItem(m.vodDetailItem)
    supported = Hardware_CodecSupported(m.top.hardwareInfo, codec)
    if codec <> "" and supported = false
        dlg = CreateObject("roSGNode", "StandardMessageDialog")
        dlg.title = "Compatibilidad de video"
        dlg.message = codec + " está confirmado para este contenido, pero este Roku informó que no puede decodificarlo."
        dlg.buttons = ["Intentar reproducir", "Cancelar"]
        m.vodDetailWarning = dlg
        dlg.ObserveField("buttonSelected", "OnVodDetailWarning")
        JglVRoot().dialog = dlg
        return
    end if
    StartVodDetailPlayback()
end sub
sub OnVodDetailWarning(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() = 0 then StartVodDetailPlayback()
    if m.vodDetailWarning <> invalid then m.vodDetailWarning.UnobserveField("buttonSelected")
    m.vodDetailWarning = invalid
end sub
function HandleVodDetailKey(key as String) as Boolean
    if m.vodErrorActive then return HandleVodErrorKey(key)
    if m.vodDetailMode = "movie" or m.vodDetailMode = "episode"
        if key = "OK" or key = "play"
            PlayVodDetail()
        else if key = "back"
            if m.vodDetailMode = "episode" then ReturnToVodSeriesDetail() else CloseVodDetail()
        end if
        return true
    end if
    if m.vodDetailMode <> "series" then return false
    if key = "back"
        CloseVodDetail()
        return true
    end if
    if m.vodDetailSeasons.Count() = 0 then return true
    if key = "left"
        m.vodDetailRegion = "seasons"
    else if key = "right"
        m.vodDetailRegion = "episodes"
    else if key = "up"
        if m.vodDetailRegion = "seasons" and m.vodDetailSeasonIdx > 0
            m.vodDetailSeasonIdx = m.vodDetailSeasonIdx - 1 : m.vodDetailEpisodeIdx = 0
        else if m.vodDetailRegion = "episodes" and m.vodDetailEpisodeIdx > 0
            m.vodDetailEpisodeIdx = m.vodDetailEpisodeIdx - 1
        end if
    else if key = "down"
        if m.vodDetailRegion = "seasons" and m.vodDetailSeasonIdx < m.vodDetailSeasons.Count() - 1
            m.vodDetailSeasonIdx = m.vodDetailSeasonIdx + 1 : m.vodDetailEpisodeIdx = 0
        else if m.vodDetailRegion = "episodes"
            eps = m.vodDetailSeasons[m.vodDetailSeasonIdx].episodes
            if m.vodDetailEpisodeIdx < eps.Count() - 1 then m.vodDetailEpisodeIdx = m.vodDetailEpisodeIdx + 1
        end if
    else if key = "OK"
        if m.vodDetailRegion = "seasons"
            m.vodDetailRegion = "episodes"
            m.vodDetailEpisodeIdx = 0
        else
            eps = m.vodDetailSeasons[m.vodDetailSeasonIdx].episodes
            if m.vodDetailEpisodeIdx >= 0 and m.vodDetailEpisodeIdx < eps.Count()
                OpenVodEpisodeDetail(eps[m.vodDetailEpisodeIdx])
                return true
            end if
        end if
    end if
    RenderVodDetail()
    return true
end function
function HandleVodErrorKey(key as String) as Boolean
    if key = "left" or key = "right" or key = "up" or key = "down"
        m.vodErrorChoice = 1 - m.vodErrorChoice
        RenderVodDetail()
    else if key = "OK" or key = "play"
        if m.vodErrorChoice = 0
            m.vodErrorActive = false
            StartVodPlayback(m.lastVodPlaybackItem, m.lastVodPlaybackSeriesMode, m.lastVodPlaybackSeriesId)
        else
            m.vodErrorActive = false
            CloseVodDetail()
        end if
    else if key = "back"
        m.vodErrorActive = false
        RenderVodDetail()
        m.top.SetFocus(true)
    end if
    return true
end function
function IsSeries(it as Object) as Boolean
    return LCase(SafeStr(it.programType)) = "teleplay"
end function
sub OpenSeries(it as Object)
    if m.jglVStopped = true then return
    m.savedGrid = { items: m.items, gridIdx: m.gridIdx, rowOffset: m.rowOffset, title: m.sectionTitle.text }
    m.seriesContentId = SafeStr(it.contentId)
    m.seriesPoster    = FirstImageUrl(it)
    m.seriesMode      = true
    m.gridIdx   = 0
    m.rowOffset = 0
    m.gridState = "loading"
    m.sectionTitle.text = SafeStr(it.name)
    RenderHeader() : RenderGrid()
    if m.itemTask <> invalid then m.itemTask.control = "STOP"
    m.itemTask = Api_OpTask("itemData", { contentId: m.seriesContentId })
    if m.itemTask = invalid
        SetGridError("itemData", "operación ausente en kit") : return
    end if
    m.itemTask.ObserveField("rawResp", "OnEpisodesResp")
    m.itemTask.ObserveField("error",   "OnItemsError")
    m.itemTask.control = "RUN"
end sub
sub OnEpisodesResp(event as Object)
    if m.jglVStopped = true then return
    data = Api_ParseOp(event.GetData())
    eps = []
    if data <> invalid
        ad = data.assetData
        if ad = invalid then ad = data
        if ad.simpleProgramList <> invalid then eps = ad.simpleProgramList
    end if
    for each e in eps
        if FirstImageUrl(e) = "" then e.posterUrl = m.seriesPoster
    end for
    m.items     = eps
    m.gridIdx   = 0
    m.rowOffset = 0
    m.gridState = Tern(eps.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
end sub
sub ExitSeries()
    if m.jglVStopped = true then return
    m.seriesMode      = false
    m.seriesContentId = ""
    if m.savedGrid <> invalid
        m.items     = m.savedGrid.items
        m.gridIdx   = m.savedGrid.gridIdx
        m.rowOffset = m.savedGrid.rowOffset
        m.sectionTitle.text = m.savedGrid.title
        m.savedGrid = invalid
    end if
    m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
end sub
sub OpenItem(idx as Integer)
    if m.jglVStopped = true then return
    if idx < 0 or idx >= m.items.Count() then return
    it = m.items[idx]
    nav = m.NAV[m.navIdx]
    vodContext = IsVodSection(nav.id) or nav.id = "search"
    if nav.id = "history" then vodContext = SafeStr(it._historyKind) = "vod"
    if vodContext and not CanPlayVod()
        m.gridState = "nohevc"
        RenderGrid()
        return
    end if
    if vodContext and not m.seriesMode
        OpenVodDetail(it)
        return
    end if
    if vodContext
        codec = VodCodecForItem(it)
        codecKey = VodCodecKey(it)
        supported = Hardware_CodecSupported(m.top.hardwareInfo, codec)
        if codec <> "" and supported = false and m.codecWarningAcceptedKey <> codecKey
            ShowCodecWarning(idx, codec, codecKey)
            return
        end if
    end if
    if IsLocked(it) and not m.adultUnlocked
        m.adultPendingIdx = idx
        if not v4a10()
            PinShowCreate()   ' primera vez: crear PIN
        else
            PinShowVerify()   ' ya tiene PIN: verificar
        end if
        return
    end if
    DoOpenItem(idx)
end sub
sub DoOpenItem(idx as Integer)
    if m.jglVStopped = true then return
    if idx < 0 or idx >= m.items.Count() then return
    it = m.items[idx]
    nav = m.NAV[m.navIdx]
    vodContext = IsVodSection(nav.id) or nav.id = "search"
    if nav.id = "history" then vodContext = SafeStr(it._historyKind) = "vod"
    if not vodContext
        PlayLiveItem(idx, false)
        return
    end if
    seriesMode = m.seriesMode
    seriesId = m.seriesContentId
    if nav.id = "history"
        seriesMode = (it._historySeriesMode = true)
        seriesId = SafeStr(it._historySeriesContentId)
    end if
    StartVodPlayback(it, seriesMode, seriesId)
end sub
sub StartVodPlayback(it as Object, seriesMode as Boolean, seriesId as String)
    if m.jglVStopped = true then return
    m.lastVodPlaybackItem = it
    m.lastVodPlaybackSeriesMode = seriesMode
    m.lastVodPlaybackSeriesId = seriesId
    m.vodErrorActive = false
    m.seriesMode = seriesMode
    m.seriesContentId = seriesId
    m.activeVodCodecKey = VodCodecKey(it)
    m.player.displayMode = "fullscreen"
    m.liveFullscreen = false
    m.content.visible = false
    m.rail.visible = false
    m.liveCatOverlay.visible = false
    m.vodDetailOverlay.visible = false
    m.player.visible = true
    m.player.channelName = SafeStr(it.name)
    m.player.channelLogo = FirstImageUrl(it)
    m.player.channelCategory = m.sectionTitle.text
    m.player.channelNumber = ""
    m.player.columnId = Tern(seriesMode, 0, 87026)
    m.player.vodSeriesContentId = Tern(seriesMode, seriesId, "")
    m.player.vodContentId = SafeStr(it.contentId)
    it["_historySeriesMode"] = seriesMode
    it["_historySeriesContentId"] = seriesId
    HistoryAdd(it, "vod")
end sub
sub ShowCodecWarning(idx as Integer, codec as String, codecKey as String)
    if m.jglVStopped = true then return
    dlg = CreateObject("roSGNode", "StandardMessageDialog")
    dlg.title = "Compatibilidad de video"
    dlg.message = codec + " fue identificado para este contenido, pero este Roku informó que no puede decodificarlo."
    dlg.buttons = ["Intentar reproducir", "Cancelar"]
    m.codecPendingIdx = idx
    m.codecPendingKey = codecKey
    m.codecWarningDlg = dlg
    dlg.ObserveField("buttonSelected", "OnCodecWarningButton")
    dlg.ObserveField("wasClosed", "OnCodecWarningClosed")
    JglVRoot().dialog = dlg
end sub
sub OnCodecWarningButton(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.codecWarningDlg = invalid then return
    if not dlg.isSameNode(m.codecWarningDlg) then return
    idx = m.codecPendingIdx
    accepted = (event.GetData() = 0)
    dlg.UnobserveField("buttonSelected")
    dlg.UnobserveField("wasClosed")
    dlg.close = true
    m.codecWarningDlg = invalid
    m.codecPendingIdx = -1
    if accepted
        m.codecWarningAcceptedKey = m.codecPendingKey
        DoOpenItem(idx)
    else
        m.top.SetFocus(true)
    end if
end sub
sub OnCodecWarningClosed(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.codecWarningDlg = invalid then return
    if not dlg.isSameNode(m.codecWarningDlg) then return
    dlg.UnobserveField("buttonSelected")
    dlg.UnobserveField("wasClosed")
    m.codecWarningDlg = invalid
    m.codecPendingIdx = -1
    m.top.SetFocus(true)
end sub
sub PlayLiveItem(idx as Integer, fullscreen as Boolean)
    if m.jglVStopped = true then return
    if idx < 0 or idx >= m.items.Count() then return
    if not m.recoveryInternal
        RecoveryCancel()
        m.recoveryTried = {}
        m.recoveryRetryUsed = false
    end if
    it = m.items[idx]
    m.gridIdx = idx
    m.player.displayMode = Tern(fullscreen, "fullscreen", "embedded")
    m.liveFullscreen = fullscreen
    m.content.visible = not fullscreen
    m.rail.visible = not fullscreen
    m.player.visible = true
    m.player.channelName = SafeStr(it.name)
    m.player.channelLogo = FirstImageUrl(it)
    catName = "TV en vivo"
    columnId = 76182
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        catName = SafeStr(m.categories[m.catIdx].name)
        columnId = GetCatId(m.categories[m.catIdx])
    end if
    protected = IsLocked(it)
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) then protected = true
    end if
    m.pendingLiveSave = invalid
    if not protected
        m.pendingLiveSave = {
            channelId: LiveStableId(it), channelCode: SafeStr(it.channelCode), apiId: SafeStr(it.id),
            categoryId: columnId.ToStr(), categoryName: catName, provider: LiveProviderId(), protected: false
        }
    end if
    m.player.channelCategory = catName
    m.player.channelNumber = (idx + 1).ToStr()
    m.player.columnId = columnId
    m.recoveryGeneration = m.recoveryGeneration + 1
    m.player.requestGeneration = m.recoveryGeneration
    m.recoveryState = "LOADING"
    m.recoveryWasPlaying = false
    m.switchingLive = true
    RecoveryWatch("startup", 15)
    m.player.channelCode = it.channelCode
    it["_historyColumnId"] = columnId
    HistoryAdd(it, "live")
    if fullscreen then m.player.poke = true
end sub
sub StopRecoveryTimers()
    if m.jglVStopped = true then return
    if m.watchTimer <> invalid then m.watchTimer.control = "stop"
    if m.recoveryTimer <> invalid then m.recoveryTimer.control = "stop"
    m.watchTimer = invalid
    m.recoveryTimer = invalid
end sub
sub RecoveryCancel()
    if m.jglVStopped = true then return
    StopRecoveryTimers()
    m.recoveryGeneration = m.recoveryGeneration + 1
    m.recoveryState = "IDLE"
    m.player.statusMessage = ""
end sub
sub RecoveryWatch(kind as String, seconds as Integer)
    if m.jglVStopped = true then return
    if m.watchTimer <> invalid then m.watchTimer.control = "stop"
    t = CreateObject("roSGNode", "Timer")
    t.AddField("generation", "integer", false)
    t.AddField("kind", "string", false)
    t.generation = m.recoveryGeneration
    t.kind = kind
    t.duration = seconds
    t.repeat = false
    t.ObserveField("fire", "OnRecoveryWatch")
    m.watchTimer = t
    t.control = "start"
end sub
sub OnRecoveryWatch(event as Object)
    if m.jglVStopped = true then return
    t = event.GetRoSGNode()
    if t = invalid then return
    if t.generation <> m.recoveryGeneration then return
    if m.recoveryState <> "LOADING" and m.recoveryState <> "PLAYING" then return
    RecoveryQueue("timeout_" + SafeStr(t.kind))
end sub
function RecoveryKey(idx as Integer) as String
    if idx < 0 or idx >= m.items.Count() then return ""
    k = LiveStableId(m.items[idx])
    if k = "" then k = "i" + idx.ToStr()
    return k
end function
function RecoveryEligible(idx as Integer) as Boolean
    if idx < 0 or idx >= m.items.Count() then return false
    it = m.items[idx]
    if SafeStr(it.channelCode) = "" then return false
    if m.recoveryTried[RecoveryKey(idx)] <> invalid then return false
    locked = IsLocked(it)
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx]) then locked = true
    return not locked or m.adultUnlocked
end function
sub RecoveryQueue(reason as String)
    if m.jglVStopped = true then return
    if not m.liveFullscreen or not m.player.visible then return
    if m.recoveryState = "RECOVERING" or m.recoveryState = "FAILED" then return
    if m.watchTimer <> invalid then m.watchTimer.control = "stop"
    m.watchTimer = invalid
    m.pendingLiveSave = invalid
    m.recoveryTried[RecoveryKey(m.gridIdx)] = true
    m.recoveryState = "RECOVERING"
    m.player.statusMessage = "Canal no disponible · Probando siguiente"
    t = CreateObject("roSGNode", "Timer")
    t.AddField("generation", "integer", false)
    t.AddField("reason", "string", false)
    t.generation = m.recoveryGeneration
    t.reason = reason
    t.duration = 0.05
    t.repeat = false
    t.ObserveField("fire", "OnRecoveryTransition")
    m.recoveryTimer = t
    t.control = "start"
end sub
sub OnRecoveryTransition(event as Object)
    if m.jglVStopped = true then return
    t = event.GetRoSGNode()
    if t = invalid then return
    if t.generation <> m.recoveryGeneration or m.recoveryState <> "RECOVERING" then return
    current = m.gridIdx
    if m.recoveryWasPlaying and not m.recoveryRetryUsed
        m.recoveryRetryUsed = true
        m.recoveryInternal = true
        PlayLiveItem(current, true)
        m.recoveryInternal = false
        return
    end if
    for offset = 1 to m.items.Count()
        idx = (current + offset) mod m.items.Count()
        if RecoveryEligible(idx)
            m.recoveryRetryUsed = false
            m.recoveryInternal = true
            PlayLiveItem(idx, true)
            m.recoveryInternal = false
            return
        end if
    end for
    m.recoveryState = "FAILED"
    m.switchingLive = false
    m.player.control = "stop"
    m.player.statusMessage = "LIVE-003 · No hay canales disponibles · OK Opciones · Atrás Regresar"
end sub
sub OnPlayerState(event as Object)
    if m.jglVStopped = true then return
    state = event.GetData()
    liveFull = (m.NAV[m.navIdx].id = "vivo" and m.liveFullscreen and m.player.visible)
    if liveFull and m.player.stateGeneration <> m.recoveryGeneration then return
    if state = "playing"
        if m.watchTimer <> invalid then m.watchTimer.control = "stop"
        m.watchTimer = invalid
        m.recoveryState = "PLAYING"
        m.recoveryWasPlaying = true
        m.recoveryTried = {}
        m.player.statusMessage = ""
        m.switchingLive = false
        if m.pendingLiveSave <> invalid then SavePendingLive()
        m.startupPlayback = false
    else if state = "buffering" and liveFull
        if m.recoveryWasPlaying then RecoveryWatch("buffering", 20)
    else if state = "nocodec"
        m.switchingLive = false
        if liveFull then RecoveryQueue("codec") : return
        if m.NAV[m.navIdx].id = "vivo"
            ClosePlayer()
            m.gridState = "nohevc"
            RenderGrid()
            return
        end if
        if m.vodErrorActive then return
        m.vodErrorActive = true
        ClosePlayer()
        ShowVodPlaybackError(true)
    else if state = "error"
        m.switchingLive = false
        m.pendingLiveSave = invalid
        if liveFull then RecoveryQueue("error") : return
        if m.startupPlayback and TryStartupFallback() then return
        m.startupPlayback = false
        if m.NAV[m.navIdx].id = "vivo"
            ClosePlayer()
            return
        end if
        if m.vodErrorActive then return
        m.vodErrorActive = true
        ClosePlayer()
        ShowVodPlaybackError(false)
    else if (state = "stopped" or state = "closed" or state = "finished") and m.player.visible
        if liveFull and not m.switchingLive and m.recoveryState <> "FAILED"
            RecoveryQueue("interrupted")
            return
        end if
        if not m.switchingLive then ClosePlayer()
    end if
end sub
sub ShowVodPlaybackError(formatError as Boolean)
    if m.jglVStopped = true then return
    m.vodErrorFormat = formatError
    m.vodErrorCode = Tern(formatError, "VOD-005", "VOD-002")
    m.vodErrorChoice = 0
    if m.vodDetailMode <> ""
        m.vodDetailOverlay.visible = true
        m.content.visible = false
        m.rail.visible = false
        RenderVodDetail()
    else
        m.content.visible = true
        m.rail.visible = true
        RenderGrid()
    end if
    m.top.SetFocus(true)
end sub
sub ClosePlayer()
    if m.jglVStopped = true then return
    if not m.player.visible or m.closingPlayer then return
    m.closingPlayer = true
    RecoveryCancel()
    m.player.visible = false
    m.switchingLive = false
    m.pendingLiveSave = invalid
    m.startupPlayback = false
    m.player.control = "stop"
    m.player.detectedVideoFormat = ""
    m.player.detectedVideoCodec = ""
    m.player.detectedAudioFormat = ""
    m.activeVodCodecKey = ""
    m.player.displayMode = "fullscreen"
    m.liveFullscreen = false
    m.fullPanelMode = ""
    m.fullPanelWaiting = false
    m.liveCatOverlay.visible = false
    if m.vodDetailMode <> ""
        m.vodDetailOverlay.visible = true
        m.content.visible = false
        m.rail.visible = false
    else
        m.content.visible = true
        m.rail.visible = true
    end if
    m.adultUnlocked = false   ' al cerrar el player se vuelve a pedir el PIN
    if m.catIdx >= 0 and m.catIdx < m.categories.Count() and IsCatAdult(m.categories[m.catIdx])
        m.gridState = "locked"
    end if
    m.top.SetFocus(true)
    if m.vodDetailMode <> "" then RenderVodDetail() else RenderGrid()
    m.closingPlayer = false
end sub
function PinLoad() as String
    if v4a10() then return "configured"
    return ""
end function
sub PinSave(pin as String)
    if m.jglVStopped = true then return
    if v4a11(pin) then m.adultPin = "configured"
end sub
sub PinShowCreate()
    if m.jglVStopped = true then return
    dlg = CreateObject("roSGNode", "PinDialog")
    dlg.title     = "Contenido +18 — Crear PIN"
    dlg.message   = "Escribe un PIN de 4 digitos para proteger este canal."
    dlg.buttons   = ["Aceptar", "Cancelar"]
    m.pinDlg      = dlg
    if m.pinMode <> "create_confirm" then m.pinMode = "create"
    dlg.ObserveField("buttonSelected", "OnPinCreateButton")
    dlg.ObserveField("wasClosed", "OnPinCreateClosed")
    JglVRoot().dialog = dlg
end sub
sub OnPinCreateChange(event as Object)
    if m.jglVStopped = true then return
end sub
sub OnPinCreateButton(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    btn = event.GetData()
    if btn = 0 ' Aceptar
        pin = SafeStr(dlg.pin)
        if Len(pin) = 4
            if m.pinMode = "create"
                dlg.UnobserveField("buttonSelected")
                dlg.UnobserveField("wasClosed")
                dlg.close = true
                m.pinDlg = invalid
                m.pinEntry1 = pin
                m.pinMode = "create_confirm"
                PinShowCreate()
                if m.pinDlg <> invalid
                    m.pinDlg.title = "Contenido +18 — Confirmar PIN"
                    m.pinDlg.message = "Repite el PIN de 4 dígitos."
                end if
            else if pin = m.pinEntry1 and v4a11(pin)
                dlg.UnobserveField("buttonSelected")
                dlg.UnobserveField("wasClosed")
                dlg.close = true
                m.pinDlg = invalid
                m.adultPin = "configured"
                m.pinEntry1 = ""
                v4a15()
                UnlockAndOpenPending()
            else
                PinScheduleReset(dlg, "Los PIN no coinciden. Repite el PIN de confirmación.")
            end if
        else
            PinScheduleReset(dlg, "El PIN debe tener 4 dígitos.")
        end if
    else ' Cancelar
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
        dlg.close = true
        m.pinDlg = invalid
        PinCancel()
    end if
end sub
sub OnPinCreateClosed(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg <> invalid and m.pinDlg <> invalid and dlg.isSameNode(m.pinDlg)
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
    else
        return
    end if
    m.pinDlg = invalid
    PinCancel()
end sub
sub PinShowVerify()
    if m.jglVStopped = true then return
    remain = v4a13()
    if remain > 0
        PinShowError("Demasiados intentos. Espera " + remain.ToStr() + " segundos.")
        return
    end if
    dlg = CreateObject("roSGNode", "PinDialog")
    dlg.title     = "Contenido +18"
    dlg.message   = "Ingresa tu PIN de 4 digitos."
    dlg.buttons   = ["Aceptar", "Cancelar"]
    m.pinDlg      = dlg
    m.pinMode     = "verify"
    dlg.ObserveField("buttonSelected", "OnPinVerifyButton")
    dlg.ObserveField("wasClosed", "OnPinVerifyClosed")
    JglVRoot().dialog = dlg
end sub
sub OnPinVerifyChange(event as Object)
    if m.jglVStopped = true then return
end sub
sub OnPinVerifyButton(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    btn = event.GetData()
    if btn = 0 ' Aceptar
        pin = SafeStr(dlg.pin)
        if Len(pin) = 4
            remain = v4a13()
            if remain > 0
                PinScheduleReset(dlg, "Demasiados intentos. Espera " + remain.ToStr() + " segundos.")
            else if v4a12(pin)
                dlg.UnobserveField("buttonSelected")
                dlg.UnobserveField("wasClosed")
                dlg.close = true
                m.pinDlg = invalid
                v4a15()
                UnlockAndOpenPending()
            else
                remain = v4a14()
                if remain > 0
                    PinScheduleReset(dlg, "Demasiados intentos. Espera " + remain.ToStr() + " segundos.")
                else
                    PinScheduleReset(dlg, "PIN incorrecto. Inténtalo nuevamente.")
                end if
            end if
        else
            PinScheduleReset(dlg, "El PIN debe tener 4 dígitos.")
        end if
    else ' Cancelar
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
        dlg.close = true
        m.pinDlg = invalid
        PinCancel()
    end if
end sub
sub OnPinVerifyClosed(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg <> invalid and m.pinDlg <> invalid and dlg.isSameNode(m.pinDlg)
        dlg.UnobserveField("pin")
        dlg.UnobserveField("buttonSelected")
        dlg.UnobserveField("wasClosed")
    else
        return
    end if
    m.pinDlg = invalid
    PinCancel()
end sub
sub PinScheduleReset(dlg as Object, message as String)
    if m.jglVStopped = true then return
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetDlg = dlg
    m.pinResetMessage = message
    timer = CreateObject("roSGNode", "Timer")
    timer.duration = 0.05
    timer.repeat = false
    timer.ObserveField("fire", "OnPinResetFire")
    m.pinResetTimer = timer
    timer.control = "start"
end sub
sub OnPinResetFire(event as Object)
    if m.jglVStopped = true then return
    timer = event.GetRoSGNode()
    if timer <> invalid then timer.UnobserveField("fire")
    m.pinResetTimer = invalid
    dlg = m.pinResetDlg
    m.pinResetDlg = invalid
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    dlg.message = m.pinResetMessage
    dlg.messageColor = "0xE96A72FF"
    dlg.pin = ""
    dlg.pinPadFocused = true
    if dlg.pinPad <> invalid then dlg.pinPad.SetFocus(true)
end sub
sub UnlockAndOpenPending()
    if m.jglVStopped = true then return
    m.adultUnlocked = true
    idx = m.adultPendingIdx
    cat = m.adultPendingCat
    context = m.pinContext
    m.pinContext = ""
    m.adultPendingIdx = -1
    m.adultPendingCat = -1
    m.pinMode = ""
    m.top.SetFocus(true)
    if context = "fullchannel"
        PlayLiveItem(idx, true)
        return
    else if context = "fullcategory"
        if cat >= 0 and cat < m.categories.Count()
            m.catIdx = cat
            m.savedLiveCatIdx = cat
            m.fullPanelMode = "loading"
            m.fullPanelWaiting = true
            RenderFullLivePanel()
            LoadItemsForCurrentCategory()
        end if
        return
    end if
    if idx >= 0
        DoOpenItem(idx)
    else
        targetCat = cat
        if targetCat < 0 then targetCat = m.catIdx
        if targetCat >= 0 and targetCat < m.categories.Count()
            m.catIdx = targetCat
            m.savedLiveCatIdx = targetCat
        end if
        m.gridState = "loading"
        m.region    = "grid"
        m.gridIdx   = 0
        m.rowOffset = 0
        RenderRail()
        RenderCategories()
        RenderGrid()
        LoadItemsForCurrentCategory()
    end if
end sub
sub PinCancel()
    if m.jglVStopped = true then return
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetTimer = invalid
    m.pinResetDlg = invalid
    m.adultPendingIdx = -1
    m.adultPendingCat = -1
    m.pinMode         = ""
    pinWasFullscreen = (m.pinContext = "fullchannel" or m.pinContext = "fullcategory")
    m.pinContext = ""
    if m.NAV[m.navIdx].id = "vivo" and m.gridState = "locked"
        m.catIdx = m.savedLiveCatIdx
        m.liveCatCursor = m.catIdx
        m.gridState = Tern(m.items.Count() > 0, "ready", "empty")
    end if
    m.top.SetFocus(true)
    if pinWasFullscreen
        RenderFullLivePanel()
    else
        RenderCategories() : RenderGrid()
    end if
end sub
sub PinShowError(msg as String)
    if m.jglVStopped = true then return
    dlg = CreateObject("roSGNode", "StandardMessageDialog")
    dlg.title   = "PIN incorrecto"
    dlg.message = msg
    dlg.buttons = ["OK"]
    dlg.ObserveField("wasClosed", "OnErrorDlgClosed")
    dlg.ObserveField("buttonSelected", "OnErrorDlgClosed")
    JglVRoot().dialog = dlg
end sub
sub OnErrorDlgClosed(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg <> invalid
        dlg.UnobserveField("wasClosed")
        dlg.UnobserveField("buttonSelected")
        dlg.close = true
    end if
    PinCancel()
end sub
sub ClearHistoryMemory()
    if m.jglVStopped = true then return
    if m.NAV[m.navIdx].id = "history"
        m.items = []
        m.gridIdx = 0 : m.rowOffset = 0 : m.gridState = "empty"
        RenderHeader() : RenderGrid()
    end if
    m.lastSearch = invalid
end sub
sub ToggleFav()
    if m.jglVStopped = true then return
    if m.region <> "grid" or IsVodSection(m.NAV[m.navIdx].id) then return
    if m.gridIdx < 0 or m.gridIdx >= m.items.Count() then return
    it = m.items[m.gridIdx]
    if IsLocked(it) then return
    code = ItemCode(it)
    if code = "" then return
    if m.favs[code] <> invalid
        m.favs.Delete(code)
    else
        m.favs[code] = it
    end if
    RenderGrid()
end sub
sub SetSection(i as Integer)
    if m.jglVStopped = true then return
    if m.NAV[i].id = "return"
        JglVReturnHome()
        return
    end if
    leavingLive = (m.NAV[m.navIdx].id = "vivo" and m.NAV[i].id <> "vivo")
    if m.NAV[m.navIdx].id = "vivo" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if not IsCatAdult(m.categories[m.catIdx]) then m.savedLiveCatIdx = m.catIdx
    end if
    if leavingLive and m.player.visible then ClosePlayer()
    m.navIdx     = i
    m.navCursor  = i
    m.section    = m.NAV[i].id
    m.catIdx     = Tern(m.NAV[i].id = "vivo", m.savedLiveCatIdx, 0)
    m.liveCatCursor = m.catIdx
    if m.NAV[i].id = "vivo" and m.liveSessionChannelId <> "" then m.resumeLiveOnLoad = true
    m.gridIdx    = 0
    m.region     = "nav"
    m.adultUnlocked   = false   ' al cambiar de sección se resetea el desbloqueo
    m.adultPendingCat = -1
    RenderRail()
    LoadCategoriesForSection()
end sub
sub EnterContent()
    if m.jglVStopped = true then return
    if m.region = "nav"
        if m.NAV[m.navCursor].id = "return"
            JglVReturnHome()
            return
        end if
    end if
    if m.region = "nav" and m.navCursor <> m.navIdx
        target = m.NAV[m.navCursor]
        if target.id = "search"
            m.navIdx = m.navCursor
            m.section = target.id
            RenderRail() : RenderHeader()
            ShowSearchDialog()
            return
        else if target.id = "settings"
            m.navIdx = m.navCursor
            m.section = target.id
            RenderRail() : RenderHeader()
            scene = JglVRoot()
            if scene <> invalid then scene.showSettings = true
            return
        end if
        m.pendingEnter = true
        SetSection(m.navCursor)
        return
    end if
    id = m.NAV[m.navIdx].id
    if id = "search"
        ShowSearchDialog()
        return
    else if id = "settings"
        scene = JglVRoot()
        if scene <> invalid then scene.showSettings = true
        return
    else if id = "home" or id = "history"
        if m.gridState <> "ready" or m.items.Count() = 0 then return
        m.region  = "grid"
        m.gridIdx = 0
        m.rowOffset = 0
    else if id = "vivo"
        if m.gridState <> "ready" or m.items.Count() = 0 then return
        m.region = "grid"
        if m.gridIdx < 0 or m.gridIdx >= m.items.Count() then m.gridIdx = 0
        EnsureLiveChannelVisible()
    else
        if m.categories.Count() = 0 then return
        m.region = "cats"
    end if
    RenderRail()
    RenderCategories()
    RenderGrid()
end sub
sub MaybeEnterPending()
    if m.jglVStopped = true then return
    if not m.pendingEnter then return
    if m.gridState = "loading" then return
    m.pendingEnter = false
    if m.gridState = "ready" then EnterContent()
end sub
sub ShowSearchDialog()
    if m.jglVStopped = true then return
    dlg = CreateObject("roSGNode", "KeyboardDialog")
    dlg.title = "Buscar pelicula o serie (escribe y pulsa Buscar o Back)"
    dlg.buttons = ["Buscar", "Cancelar"]
    m.searchText = ""
    if m.lastSearch <> invalid
        dlg.text = m.lastSearch
        m.searchText = m.lastSearch
    end if
    m.searchCancel = false
    m.searchDlg = dlg
    dlg.ObserveField("text",           "OnSearchText")
    dlg.ObserveField("buttonSelected", "OnSearchButton")
    dlg.ObserveField("wasClosed",      "OnSearchClosed")
    JglVRoot().dialog = dlg
end sub
sub OnSearchText(event as Object)
    if m.jglVStopped = true then return
    m.searchText = SafeStr(event.GetData())
end sub
sub OnSearchButton(event as Object)
    if m.jglVStopped = true then return
    idx = event.GetData()
    if idx = 1 then m.searchCancel = true   ' "Cancelar"
    if m.searchDlg <> invalid then m.searchDlg.close = true
end sub
sub OnSearchClosed(event as Object)
    if m.jglVStopped = true then return
    term = m.searchText
    cancel = m.searchCancel
    m.searchDlg = invalid
    m.top.SetFocus(true)   ' devolver el foco a JglVHomeScreen tras cerrar el teclado
    if not cancel and term <> invalid and Len(term) > 0 then RunSearch(term)
end sub
sub RunSearch(term as String)
    if m.jglVStopped = true then return
    m.lastSearch = term
    m.region = "grid"
    m.gridIdx = 0
    m.rowOffset = 0
    m.items = []
    m.gridState = "loading"
    m.sectionTitle.text = "Buscar: " + term
    RenderHeader() : RenderRail() : RenderGrid()
    if m.searchTask <> invalid then m.searchTask.control = "STOP"
    m.searchTask = Api_OpTask("search", { value: term, page: 1 })
    if m.searchTask = invalid
        SetGridError("search", "operación ausente en kit") : return
    end if
    m.searchTask.ObserveField("rawResp", "OnSearchResp")
    m.searchTask.ObserveField("error",   "OnSearchErr")
    m.searchTask.control = "RUN"
end sub
sub OnSearchResp(event as Object)
    if m.jglVStopped = true then return
    raw = event.GetData()
    data = Api_ParseOp(raw)
    if data = invalid
        SetGridError("search", "respuesta inválida: " + Left(SafeStr(raw), 220))
        return
    end if
    items = []
    if data <> invalid and data.resourceResult <> invalid and data.resourceResult.resourceList <> invalid
        items = data.resourceResult.resourceList
    end if
    if data <> invalid and data.seriesResult <> invalid and data.seriesResult.seriesList <> invalid
        for each s in data.seriesResult.seriesList
            items.Push(s)
        end for
    end if
    safeItems = []
    for each result in items
        if not IsLocked(result) then safeItems.Push(result)
    end for
    items = safeItems
    m.items = items
    m.gridIdx = 0
    m.rowOffset = 0
    m.gridState = Tern(items.Count() > 0, "ready", "empty")
    RenderHeader() : RenderGrid()
end sub
sub OnSearchErr(event as Object)
    if m.jglVStopped = true then return
    if Api_LicenseGone(event.GetData()) then return
    SetGridError("search", event.GetData())
end sub
function IsCatAdult(cat as Object) as Boolean
    name = LCase(SafeStr(cat.name))
    if InStr(name, "18") > 0 then return true
    if InStr(name, "adult") > 0 then return true
    if InStr(name, "xxx") > 0 then return true
    return false
end function
sub ChooseCat(i as Integer)
    if m.jglVStopped = true then return
    if i < 0 or i >= m.categories.Count() then return
    cat = m.categories[i]
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) and i <> m.catIdx then m.adultUnlocked = false
    end if
    if IsCatAdult(cat) and not m.adultUnlocked
        m.catIdx = i
        m.adultPendingCat = i
        m.adultPendingIdx = -1
        m.gridState = "locked"
        RenderCategories()
        RenderGrid()
        return
    end if
    m.catIdx = i
    RenderCategories()
    LoadItemsForCurrentCategory()
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
    if m.jglVStopped = true then return false
    if not press then return false
    return HandleRemoteKey(key)
end function
sub RequestFullLiveChannel(idx as Integer)
    if m.jglVStopped = true then return
    RecoveryCancel()
    if m.items.Count() = 0 then return
    if idx < 0 then idx = m.items.Count() - 1
    if idx >= m.items.Count() then idx = 0
    protected = false
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        protected = IsCatAdult(m.categories[m.catIdx])
    end if
    if IsLocked(m.items[idx]) then protected = true
    if protected and not m.adultUnlocked
        m.pinContext = "fullchannel"
        m.adultPendingIdx = idx
        PinDispatch()
        return
    end if
    PlayLiveItem(idx, true)
end sub
sub SelectFullLiveCategory()
    if m.jglVStopped = true then return
    RecoveryCancel()
    idx = m.fullPanelCursor
    if idx < 0 or idx >= m.categories.Count() then return
    if m.catIdx >= 0 and m.catIdx < m.categories.Count()
        if IsCatAdult(m.categories[m.catIdx]) and idx <> m.catIdx then m.adultUnlocked = false
    end if
    if IsCatAdult(m.categories[idx]) and not m.adultUnlocked
        m.pinContext = "fullcategory"
        m.adultPendingCat = idx
        m.adultPendingIdx = -1
        PinDispatch()
        return
    end if
    if idx = m.catIdx and m.items.Count() > 0
        m.fullPanelMode = "channels"
        CalculateFullPanelWidth("channels")
        m.fullPanelWaiting = false
        m.fullPanelCursor = m.gridIdx
        key = GetCatId(m.categories[idx]).ToStr()
        if m.fullPanelPositions[key] <> invalid then m.fullPanelCursor = m.fullPanelPositions[key]
        if m.fullPanelCursor < 0 or m.fullPanelCursor >= m.items.Count() then m.fullPanelCursor = 0
        RenderFullLivePanel()
        return
    end if
    m.catIdx = idx
    m.savedLiveCatIdx = idx
    m.fullPanelMode = "loading"
    m.fullPanelWaiting = true
    RenderFullLivePanel()
    LoadItemsForCurrentCategory()
end sub
sub ExitLiveFullscreen()
    if m.jglVStopped = true then return
    RecoveryCancel()
    CloseFullLivePanel()
    m.liveFullscreen = false
    m.player.displayMode = "embedded"
    m.content.visible = true
    m.rail.visible = true
    m.top.SetFocus(true)
end sub
function HandleFullLiveKey(key as String) as Boolean
    if m.fullPanelMode = ""
        if key = "up"
            RequestFullLiveChannel(m.gridIdx - 1)
        else if key = "down"
            RequestFullLiveChannel(m.gridIdx + 1)
        else if key = "OK"
            OpenFullLivePanel()
        else if key = "back"
            ExitLiveFullscreen()
        else
            m.player.poke = true
        end if
        return true
    end if
    if key = "back"
        if m.fullPanelMode = "channels" or m.fullPanelMode = "loading"
            if m.fullPanelMode = "channels" and m.catIdx >= 0 and m.catIdx < m.categories.Count()
                m.fullPanelPositions[GetCatId(m.categories[m.catIdx]).ToStr()] = m.fullPanelCursor
            end if
            m.fullPanelMode = "categories"
            CalculateFullPanelWidth("categories")
            m.fullPanelWaiting = false
            m.fullPanelCursor = m.catIdx
            RenderFullLivePanel()
        else
            CloseFullLivePanel()
        end if
        return true
    end if
    if m.fullPanelMode = "loading" then return true
    count = m.categories.Count()
    if m.fullPanelMode = "channels" then count = m.items.Count()
    if key = "up" and m.fullPanelCursor > 0
        m.fullPanelCursor = m.fullPanelCursor - 1
        RenderFullLivePanel()
    else if key = "down" and m.fullPanelCursor < count - 1
        m.fullPanelCursor = m.fullPanelCursor + 1
        RenderFullLivePanel()
    else if key = "OK"
        if m.fullPanelMode = "categories"
            SelectFullLiveCategory()
        else if m.fullPanelMode = "channels"
            idx = m.fullPanelCursor
            if m.catIdx >= 0 and m.catIdx < m.categories.Count()
                m.fullPanelPositions[GetCatId(m.categories[m.catIdx]).ToStr()] = idx
            end if
            CloseFullLivePanel()
            RequestFullLiveChannel(idx)
        end if
    end if
    return true
end function
function HandleRemoteKey(key as String) as Boolean
    if key = "back"
    end if
    if m.player.visible
        navId = m.NAV[m.navIdx].id
        isVod = IsVodSection(navId) or navId = "search"
        if navId = "history" and m.gridIdx >= 0 and m.gridIdx < m.items.Count()
            isVod = SafeStr(m.items[m.gridIdx]._historyKind) = "vod"
        end if
        if navId = "vivo" and m.liveFullscreen
            return HandleFullLiveKey(key)
        end if
        embeddedLive = (navId = "vivo" and not m.liveFullscreen)
        if embeddedLive
            keepNavigating = true
        else if key = "back"
            ClosePlayer()
        else if isVod and (key = "OK" or key = "play")
            m.player.transport = "playpause"
        else if isVod and key = "right"
            m.player.transport = "seekfwd"
        else if isVod and key = "left"
            m.player.transport = "seekback"
        else if isVod and (key = "up" or key = "down")
            m.player.transport = "cyclesub"
        else if isVod and key = "rewind"
            m.player.transport = "subearlier"
        else if isVod and key = "fastforward"
            m.player.transport = "sublater"
        else if key = "OK" or key = "play"
            m.player.poke = true
        end if
        if not embeddedLive then return true
    end if
    if m.vodDetailMode <> "" then return HandleVodDetailKey(key)
    if key = "options"
        if m.region = "nav"
            if CountStarPress() then return true
        else
            ToggleFav()
        end if
        return true
    else if key = "back"
        return MoveBack()
    else if key = "OK"
        Select_()
        return true
    else if key = "up"
        Move("up")
        return true
    else if key = "down"
        Move("down")
        return true
    else if key = "left"
        Move("left")
        return true
    else if key = "right"
        Move("right")
        return true
    end if
    return false
end function
sub Select_()
    if m.jglVStopped = true then return
    if m.region = "nav"
        if m.NAV[m.navIdx].id = "vivo" and m.navCursor = m.navIdx and m.categories.Count() > 0
            m.liveCatCursor = m.catIdx
            m.region = "cats"
            RenderRail() : RenderCategories() : RenderGrid()
        else
            EnterContent()
        end if
    else if m.region = "cats"
        if m.NAV[m.navIdx].id = "vivo"
            target = m.liveCatCursor
            ChooseCat(target)
            if m.gridState = "locked"
                m.adultPendingCat = target
                PinDispatch()
            else
                m.savedLiveCatIdx = target
                m.region = "grid"
                m.gridIdx = 0
                m.rowOffset = 0
                RenderRail() : RenderCategories() : RenderGrid()
            end if
            return
        end if
        if m.gridState = "locked"
            if m.adultUnlocked
                m.region    = "grid"
                m.gridState = "loading"
                RenderGrid()
                LoadItemsForCurrentCategory()
            else
                m.adultPendingCat = m.catIdx
                PinDispatch()
            end if
        else if m.gridState = "ready" and m.items.Count() > 0
            m.region  = "grid"
            m.gridIdx = 0
            m.rowOffset = 0
            RenderRail()
            RenderCategories()
            RenderGrid()
        end if
    else if m.region = "preview"
        if m.NAV[m.navIdx].id = "vivo"
            if m.player.visible
                m.liveFullscreen = true
                m.fullPanelMode = ""
                m.fullPanelWaiting = false
                m.content.visible = false
                m.rail.visible = false
                m.liveCatOverlay.visible = false
                m.player.displayMode = "fullscreen"
                m.player.poke = true
            else if m.gridState = "ready"
                OpenItem(m.gridIdx)
            end if
        end if
    else if m.region = "grid"
        if m.gridState = "locked"
            if m.adultUnlocked
                m.gridState = "loading"
                RenderGrid()
                LoadItemsForCurrentCategory()
            else
                m.adultPendingCat = m.catIdx
                PinDispatch()
            end if
        else if m.gridState = "error"
            LoadItemsForCurrentCategory()
        else if m.gridState = "ready"
            OpenItem(m.gridIdx)
        end if
    end if
end sub
sub PinDispatch()
    if m.jglVStopped = true then return
    if m.adultPendingCat < 0
        m.adultPendingCat = m.catIdx
    end if
    if not v4a10()
        PinShowCreate()
    else
        PinShowVerify()
    end if
end sub
function MoveBack() as Boolean
    if m.region = "grid"
        if m.seriesMode
            ExitSeries()
            return true
        end if
        if m.NAV[m.navIdx].id = "vivo"
            m.region = "nav"
        else if m.NAV[m.navIdx].id = "home" or m.NAV[m.navIdx].id = "history" or m.NAV[m.navIdx].id = "search"
            m.region = "nav"
        else
            m.region = "cats"
        end if
    else if m.region = "cats"
        if m.NAV[m.navIdx].id = "vivo"
            m.liveCatCursor = m.catIdx
            m.region = "grid"
        else
            m.region = "nav"
        end if
    else if m.region = "preview"
        m.region = "nav"
    else
        return false ' ya estamos en "nav": dejar que suba (salir de la app)
    end if
    RenderRail()
    RenderCategories()
    RenderGrid()
    return true
end function
sub Move(d as String)
    if m.jglVStopped = true then return
    r = m.region
    if r = "nav"
        if d = "up"
            if m.navCursor > 0
                m.navCursor = m.navCursor - 1
                RenderRail()
            end if
        else if d = "down"
            if m.navCursor < m.NAV.Count() - 1
                m.navCursor = m.navCursor + 1
                RenderRail()
            end if
        else if d = "right"
            if m.NAV[m.navIdx].id = "vivo" and m.navCursor = m.navIdx and m.gridState = "ready"
                m.region = "grid"
                RenderRail() : RenderCategories() : RenderGrid()
            else
                EnterContent()
            end if
        end if
        return
    end if
    if r = "cats"
        maxI = m.categories.Count() - 1
        if m.NAV[m.navIdx].id = "vivo"
            if d = "up" and m.liveCatCursor > 0
                m.liveCatCursor = m.liveCatCursor - 1
                RenderCategories()
            else if d = "down" and m.liveCatCursor < maxI
                m.liveCatCursor = m.liveCatCursor + 1
                RenderCategories()
            else if d = "right"
                Select_()
            end if
            return
        else if d = "left"
            if m.catIdx > 0
                ChooseCat(m.catIdx - 1)
            else
                MoveBack()
            end if
        else if d = "right"
            if m.catIdx < maxI then ChooseCat(m.catIdx + 1)
        else if d = "down"
            if m.gridState = "locked"
                PinDispatch()
            else if m.gridState = "ready"
                m.region  = "grid"
                m.gridIdx = 0
                m.rowOffset = 0
                RenderRail()
                RenderCategories()
                RenderGrid()
            end if
        end if
        return
    end if
    if r = "grid"
        if m.gridState <> "ready"
            if d = "left"
                m.region = "nav"
                RenderRail()
                RenderCategories()
                RenderGrid()
            end if
            return
        end if
        n = m.items.Count()
        if m.NAV[m.navIdx].id = "vivo"
            if d = "left"
                m.region = "preview"
                RenderRail() : RenderCategories() : RenderGrid()
            else if d = "up" and m.gridIdx > 0
                m.gridIdx = m.gridIdx - 1
                EnsureLiveChannelVisible()
                RenderGrid()
            else if d = "down" and m.gridIdx < n - 1
                m.gridIdx = m.gridIdx + 1
                EnsureLiveChannelVisible()
                RenderGrid()
            end if
            return
        end if
        cols = GRID_COLS()
        i = m.gridIdx
        col = i mod cols
        if d = "left"
            if col > 0
                m.gridIdx = i - 1
                EnsureRowVisible()
                RenderGrid()
            else
                MoveBack()
            end if
        else if d = "right"
            if col < cols - 1 and i + 1 < n
                m.gridIdx = i + 1
                EnsureRowVisible()
                RenderGrid()
            end if
        else if d = "up"
            if i - cols >= 0
                m.gridIdx = i - cols
                EnsureRowVisible()
                RenderGrid()
            end if
        else if d = "down"
            if i + cols < n
                m.gridIdx = i + cols
                EnsureRowVisible()
                RenderGrid()
            end if
        end if
        return
    end if
    if r = "preview"
        if d = "left"
            m.region = "nav"
        else if d = "right"
            m.region = "grid"
        end if
        RenderRail() : RenderCategories() : RenderGrid()
        return
    end if
end sub
function Max(a as Integer, b as Integer) as Integer
    if a > b then return a
    return b
end function
function Min(a as Integer, b as Integer) as Integer
    if a < b then return a
    return b
end function
