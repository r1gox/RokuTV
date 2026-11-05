' Original Liquid Glass-inspired Roku Plus chrome. All coordinates use FHD units.
' The glass is a static translucent treatment; it does not blur video at runtime.
function panel(x as float, y as float, w as float, h as float, color as string) as object
    node = m.canvas.createChild("Rectangle")
    node.translation = [x,y]
    node.width = w
    node.height = h
    node.color = color
    return node
end function

function words(text as string, x as float, y as float, w as float, h as float, size as integer, color = "0xF5F5F7FF" as string) as object
    node = m.canvas.createChild("Label")
    node.translation = [x,y]
    node.width = w
    node.height = h
    node.color = color
    node.text = text
    font = node.font
    font.size = size
    node.font = font
    return node
end function

function art(uri as string, x as float, y as float, w as float, h as float, mode = "scaleToFill" as string) as object
    poster = m.canvas.createChild("Poster")
    poster.translation = [x,y]
    poster.width = w
    poster.height = h
    poster.loadWidth = int(w)
    poster.loadHeight = int(h)
    poster.loadDisplayMode = mode
    poster.uri = themeAsset(uri)
    m.images.push(poster)
    return poster
end function

function themeAsset(uri as string) as string
    if m.theme <> "classic" then return uri
    prefix = "pkg:/images/ui/"
    if left(uri,len(prefix)) <> prefix then return uri
    if type(m.uiClassicAssetMap) <> "roAssociativeArray"
        m.uiClassicAssetMap = {}
        for each stem in ["app-background","rail-glass","button-white","button-dark","nav-active","nav-focus","setup-card","pill","glass-row","glass-reality","glass-section","glass-chip","glass-tile","glass-badge","glass-notice","live-preview-frame","live-preview-mask","live-channel-row","live-channel-selected","live-logo-badge","live-empty"]
            m.uiClassicAssetMap[stem+".png"] = stem+"-classic.png"
        end for
    end if
    name = mid(uri,len(prefix)+1)
    if m.uiClassicAssetMap.doesExist(name) then return prefix+m.uiClassicAssetMap[name]
    return uri
end function

function glassSurface(name as string, x as float, y as float, w as float, h as float) as object
    return art("pkg:/images/ui/"+name+".png",x,y,w,h)
end function

sub thumbnail(uri as string, x as float, y as float, w as float, h as float, shape = "landscape" as string)
    base = "0x1B221EFF"
    if m.theme = "classic" then base = "0x101D2DFF"
    panel(x,y,w,h,base)
    if uri <> ""
        if shape = "poster" then art(uri,x,y,w,h,"scaleToFit") else art(uri,x,y,w,h,"scaleToZoom")
    end if
    mask = "card-landscape-mask"
    if shape = "poster" then mask = "card-poster-mask"
    glassSurface(mask,x,y,w,h)
end sub

sub eraseScreen()
    ' Disconnect before clearing URIs: a cached or failed request from the old
    ' render must never change a badge belonging to the new channel page.
    if type(m.liveLogoFallbacks) = "roArray"
        for each entry in m.liveLogoFallbacks
            entry.poster.unobserveField("loadStatus")
        end for
    end if
    m.liveLogoFallbacks = []
    for each image in m.images
        image.uri = ""
    end for
    m.images = []
    m.focusItems = []
    m.canvas.removeChildrenIndex(m.canvas.getChildCount(),0)
    m.canvas.visible = true
    art("pkg:/images/ui/app-background.png",0,0,1920,1080)
end sub

sub focusTarget(zone as string, index as integer, x as integer, y as integer, w as integer, h as integer, shape = "wide" as string)
    uri = "pkg:/images/ui/focus-button.png"
    if shape = "card" then uri = "pkg:/images/ui/focus-card.png"
    if shape = "landscape" then uri = "pkg:/images/ui/focus-landscape.png"
    if shape = "setup" then uri = "pkg:/images/ui/setup-focus.png"
    if shape = "catalog" then uri = "pkg:/images/ui/focus-catalog.png"
    if shape = "live" then uri = "pkg:/images/ui/focus-live.png"
    if shape = "reality" then uri = "pkg:/images/ui/focus-reality.png"
    if shape = "live-channel" then uri = "pkg:/images/ui/live-row-focus.png"
    if shape = "live-search" then uri = "pkg:/images/ui/focus-row.png"
    if shape = "appearance" then uri = "pkg:/images/ui/focus-appearance.png"
    if shape = "wide" and w > 1000 then uri = "pkg:/images/ui/focus-row.png"
    edge = art(uri,x,y,w,h)
    edge.visible = false
    m.focusItems.push({zone:zone,index:index,edge:edge})
end sub

sub selectable(zone as string, index as integer, text as string, x as integer, y as integer, w as integer, h as integer, primary = false as boolean)
    uri = "pkg:/images/ui/button-dark.png"
    ink = "0xF4F9FFFF"
    if primary
        uri = "pkg:/images/ui/button-white.png"
        ink = "0x14283CFF"
    end if
    art(uri,x,y,w,h)
    label = words(text,x+12,y+15,w-24,h-18,28,ink)
    label.horizAlign = "center"
    focusTarget(zone,index,x-4,y-4,w+8,h+8)
end sub

sub brand(x as integer, y as integer)
    art("pkg:/images/ui/logo.png",x,y,52,52)
    words("R+",x+6,y+7,44,42,29,"0x14283CFF")
    words("Roku Plus",x+69,y,212,35,30)
    words("por JGL Customs",x+69,y+36,212,26,18,"0xCDD6C9FF")
end sub

function countryName() as string
    country = orbitCountryLookup(m.countryCode)
    if country = invalid then return "México"
    return country.name
end function

function modeName() as string
    if m.catalogMode = "hevc" then return "Televisor 4K"
    return "HD / Full HD"
end function

sub topBar()
    panel(0,0,1920,111,"0x15221EEB")
    brand(48,29)
    glassSurface("glass-row",337,18,1535,77)
    labels = ["Inicio","Películas","Series","TV en vivo","App JGLCUSTOMS","Mi lista"]
    icons = ["home","movies","series","live","live","movies"]
    positions = [350,495,670,805,1000,1275]
    widths = [135,165,125,185,265,165]
    indices = [0,1,2,3,6,4]
    active = 0
    if m.view = "browse" or m.view = "detail" or m.view = "episodes"
        active = 1
        if m.kind = "series" then active = 2
    else if m.view = "live"
        active = 3
    else if m.view = "watchlist"
        active = 4
    else if m.view = "settings" or m.view = "credits" or m.view = "hd-source" or m.view = "appearance" or m.view = "media-prefs"
        active = 5
    end if
    for i = 0 to 5
        x = positions[i]
        ink = "0xEEF2E9FF"
        if active = indices[i]
            art("pkg:/images/ui/button-white.png",x,27,widths[i],59)
            ink = "0x14283CFF"
        end if
        if indices[i] = 6
            words(labels[i],x+12,43,widths[i]-24,35,23,ink)
        else
            navIcon = art("pkg:/images/ui/"+icons[i]+".png",x+11,44,25,25)
            navIcon.blendColor = ink
            words(labels[i],x+43,43,widths[i]-49,35,23,ink)
        end if
        focusTarget("nav",indices[i],x-3,24,widths[i]+6,65)
    end for
    if m.view <> "live" and m.view <> "browse"
        glassSurface("glass-chip",1450,27,271,59)
        art("pkg:/images/ui/search.png",1466,43,29,29)
        words("Buscar",1510,42,193,36,25)
        focusTarget("global-search",0,1447,24,277,65)
    end if
    if active = 5 then art("pkg:/images/ui/button-white.png",1761,27,92,59)
    settingsIcon = art("pkg:/images/ui/settings.png",1789,42,32,32)
    if active = 5 then settingsIcon.blendColor = "0x14283CFF"
    focusTarget("nav",5,1758,24,98,65)
end sub

sub drawScreen()
    if m.view = "player" or m.view = "jglv" then return
    eraseScreen()
    if m.view = "setup-tv"
        setupTvScreen()
    else if m.view = "setup-country"
        setupCountryScreen()
    else
        if m.view = "home" then homeScreen()
        if m.view = "browse" then browseScreen()
        if m.view = "detail" then detailScreen()
        if m.view = "episodes" then episodeScreen()
        if m.view = "live" then liveScreen()
        if m.view = "settings" then settingsScreen()
        if m.view = "appearance" then appearanceScreen()
        if m.view = "credits" then creditsScreen()
        if m.view = "hd-source" then hdSourceScreen()
        if m.view = "watchlist" then watchlistScreen()
        if m.view = "media-prefs" then mediaPrefsScreen()
        if m.busy or m.note <> ""
            glassSurface("glass-notice",60,967,1800,100)
            text = m.note
            if m.busy then text = "Consultando el catálogo…"
            if m.busy and type(m.pending) = "roAssociativeArray"
                if m.pending.operation = "country" then text = "Cargando canales de " + countryName() + "…"
                if m.pending.operation = "compatible" then text = "Preparando la reproducción con tu computadora…"
            end if
            words(text,84,987,1752,75,24,"0xDBEAF6FF").wrap = true
        end if
    end if
    paintFocus()
end sub

sub setupTvScreen()
    brand(85,65)
    setupHeading = "CONFIGURACIÓN INICIAL · 1 DE 2"
    if m.setupFromSettings then setupHeading = "CONFIGURACIÓN · 1 DE 2"
    words(setupHeading,87,177,1700,46,23,"0x9B9BA5FF")
    words("Selecciona tu televisor",82,244,1750,92,62)
    words("Elige la biblioteca que utilizarás. Podrás cambiarla después en Configuración.",87,350,1710,80,29,"0xB8B8C2FF").wrap = true
    names = ["HD / Full HD","4K"]
    tags = ["HD","4K"]
    descriptions = ["Películas y series con selección de fuentes H.264 compatibles.","El catálogo ampliado de películas y series que ya conoces."]
    for i = 0 to 1
        x = 84 + i * 912
        art("pkg:/images/ui/setup-card.png",x,466,838,300)
        art("pkg:/images/ui/tv.png",x+34,496,72,72)
        words(tags[i],x+132,492,620,77,60)
        words(names[i],x+38,588,760,54,34)
        words(descriptions[i],x+38,654,760,91,25,"0xAFAFB9FF").wrap = true
        recommended = (i = 0 and m.capabilities.recommendedCatalog = "hd") or (i = 1 and m.capabilities.recommendedCatalog = "hevc")
        if recommended then words("Recomendado para esta Roku",x+38,785,790,44,24,"0xE5E5EAFF")
        focusTarget("setup",i,x-6,460,850,312,"setup")
    end for
    words("La opción 4K describe el equipo. La calidad disponible depende de cada video.",87,881,1730,59,24,"0x888893FF").wrap = true
    words("← / →: elegir     OK: continuar",87,1004,1730,42,24,"0xB9B9C2FF")
end sub

sub setupCountryScreen()
    brand(85,65)
    setupHeading = "CONFIGURACIÓN INICIAL · 2 DE 2"
    if m.setupFromSettings then setupHeading = "CONFIGURACIÓN · 2 DE 2"
    if m.setupCountryOnly then setupHeading = "TU PAÍS O REGIÓN"
    words(setupHeading,87,177,1700,46,23,"0x9B9BA5FF")
    words("¿En qué país estás?",82,250,660,173,60).wrap = true
    words("Mostraremos los canales de tu país o región. Puedes cambiarlo cuando quieras.",87,470,620,193,31,"0xB8B8C2FF").wrap = true
    art("pkg:/images/ui/world.png",87,708,98,98)
    countries = orbitCountries()
    first = (m.setupCountry \ 7) * 7
    for i = 0 to 6
        n = first + i
        if n < countries.count()
            y = 268+i*91
            art("pkg:/images/ui/pill.png",793,y,1035,79)
            words(ucase(countries[n].code),824,y+21,106,42,25,"0xA2A2ADFF")
            words(countries[n].name,950,y+19,839,47,31)
            focusTarget("country",n,786,y-5,1048,89)
        end if
    end for
    words((m.setupCountry+1).toStr()+" de "+countries.count().toStr(),800,936,1000,39,22,"0x9595A1FF")
    words("↑ / ↓: elegir     OK: guardar y entrar     Atrás: volver",87,1004,1730,42,24,"0xB9B9C2FF")
end sub

sub homeScreen()
    hasContinue = false
    if type(m.continueItems) = "roArray" then hasContinue = m.continueItems.count() > 0
    heroHeight = 300
    if hasContinue then heroHeight = 230
    movieHeading = 455
    if hasContinue then movieHeading = 565
    seriesHeading = movieHeading+535
    scroll = 0
    if m.zone = "home-series" then scroll = seriesHeading-155
    if m.zone = "continue" then scroll = 180
    if scroll = 0
        if m.features.count() > 0
            item = m.features[0]
            heroUri = item.background
            if heroUri = "" then heroUri = item.poster
            if heroUri <> "" then art(heroUri,60,126,1800,heroHeight,"scaleToZoom")
            art("pkg:/images/ui/hero-shade.png",60,126,1800,heroHeight)
            glassSurface("hero-mask",60,126,1800,heroHeight)
            words("DESTACADO",94,149,1100,32,21,"0xC8DCECFF")
            if hasContinue
                words(item.title,91,174,1090,80,39).wrap = true
            else
                words(item.title,91,191,1090,102,49).wrap = true
            end if
            selectable("hero",0,"Reproducir",94,126+heroHeight-90,308,65,true)
            selectable("hero",1,"Ver detalles",423,126+heroHeight-90,290,65)
        else
            words("Tu próxima historia",90,180,1550,85,55)
            text = "Actualizando películas y series…"
            if not m.homeLoading then text = "Abre Películas o Series para explorar el catálogo."
            words(text,94,274,1570,65,28,"0xB8CEE1FF").wrap = true
            selectable("hero",0,"Actualizar",94,350,308,65,true)
        end if
    end if
    if hasContinue
        headingY = 375-scroll
        if headingY >= 120 and headingY < 1000
            words("Continuar viendo",60,headingY,1660,48,34)
            continueFirst = (m.continueCursor \ 3)*3
            for i = 0 to 2
                n = continueFirst+i
                if n < m.continueItems.count()
                    item = m.continueItems[n]
                    x = 60+i*610
                    y = headingY+54
                    uri = item.background
                    if uri = "" then uri = item.poster
                    thumbnail(uri,x,y,580,124)
                    panel(x+1,y+76,578,47,"0x11221EE6")
                    words(item.title,x+16,y+84,548,34,24)
                    panel(x+18,y+116,540,3,"0xDCE7DB55")
                    progress = 0
                    progressDuration = 0
                    if GetInterface(item.resumeDuration,"ifInt") <> invalid then progressDuration = item.resumeDuration
                    if progressDuration <= 0
                        if GetInterface(item.runtime,"ifInt") <> invalid then progressDuration = item.runtime
                    end if
                    if GetInterface(item.resumePosition,"ifFloat") <> invalid or GetInterface(item.resumePosition,"ifInt") <> invalid
                        if progressDuration > 0 then progress = item.resumePosition/progressDuration
                    end if
                    if progress < 0 then progress = 0
                    if progress > 1 then progress = 1
                    panel(x+18,y+116,540*progress,3,"0xE7F3DDFF")
                    focusTarget("continue",n,x-5,y-5,590,134,"landscape")
                end if
            end for
        end if
    end if
    drawHomePosterShelf(m.features,"Películas para explorar",movieHeading-scroll,"covers")
    drawHomePosterShelf(m.homeSeries,"Series por descubrir",seriesHeading-scroll,"home-series")
    topBar()
    words("↑ ↓ Explorar filas     OK Ver título",64,1040,1160,30,21,"0xCED9CDFF")
    words("Más películas y series ↓",1420,1040,435,30,21,"0xCED9CDFF").horizAlign = "right"
end sub

sub drawHomePosterShelf(items as object, heading as string, y as integer, zone as string)
    if y < 115 or y > 1010 then return
    words(heading,60,y,1710,50,34)
    if y+455 > 1030 then return
    for i = 0 to 5
        if i < items.count()
            item = items[i]
            x = 77+i*300
            thumbnail(item.poster,x,y+58,230,345,"poster")
            words(item.title,x,y+414,250,62,24).wrap = true
            focusTarget(zone,i,x-6,y+52,242,357,"card")
        end if
    end for
end sub

sub browseScreen()
    topBar()
    title = "Películas"
    if m.kind = "series" then title = "Series"
    words(title,60,127,1240,75,51)
    searchText = "Buscar películas…"
    if m.kind = "series" then searchText = "Buscar series…"
    searchWidth = 1800
    if m.query <> ""
        searchText = "Buscar: "+left(m.query,92)
        searchWidth = 1550
    end if
    glassSurface("glass-row",60,215,searchWidth,58)
    art("pkg:/images/ui/search.png",78,230,29,29)
    words(searchText,125,229,searchWidth-95,38,26)
    focusTarget("browse-search",0,56,211,searchWidth+8,66,"live-search")
    if m.query <> "" then selectable("browse-search",1,"Borrar",1630,215,230,58)
    drawCategoryChips(rpCatalogCategories(m.kind),m.catalogCategory,m.catalogCategoryCursor,"catalog-categories",287)
    first = (m.cursor \ 6)*6
    drawCatalogCards(m.titles,first,m.cursor,"grid",365)
    last = first+6
    if last > m.titles.count() then last = m.titles.count()
    if last > 0 then words("Títulos "+(first+1).toStr()+"–"+last.toStr()+" de "+m.titles.count().toStr(),64,1007,1120,38,23,"0xB5C5B5FF")
    if m.titles.count() = 0 and not m.busy
        empty = "No se encontraron títulos."
        if m.catalogCategory <> "all" then empty = "Sin títulos clasificados en esta categoría. Prueba Todas."
        if m.more then empty = "Aún no hay coincidencias. Pulsa → para consultar más títulos."
        words(empty,90,483,1710,120,33,"0xC6D1C3FF").wrap = true
    end if
    hint = "← Anteriores   → Más títulos"
    if first+6 >= m.titles.count() and not m.more then hint = "Fin del catálogo"
    words(hint,1390,1007,466,38,23,"0xCBDAC7FF").horizAlign = "right"
end sub

sub drawCategoryChips(choices as object, selected as string, cursor as integer, zone as string, y as integer)
    first = 0
    if cursor >= 6 then first = cursor-5
    count = choices.count()-first
    if count > 6 then count = 6
    if count <= 0 then return
    width = int((1800-(count-1)*16)/count)
    chipHeight = 53
    if zone = "live-categories" then chipHeight = 48
    for i = 0 to count-1
        n = first+i
        label = orbitText(choices[n].label,80)
        if label = "" then label = orbitText(choices[n].name,80)
        x = 60+i*(width+16)
        primary = choices[n].id = selected
        uri = "button-dark"
        ink = "0xEDF2E9FF"
        if primary
            uri = "button-white"
            ink = "0x14283CFF"
        end if
        glassSurface(uri,x,y,width,chipHeight)
        words(label,x+10,y+12,width-20,36,24,ink).horizAlign = "center"
        focusTarget(zone,n,x-4,y-4,width+8,chipHeight+8)
    end for
end sub

sub drawCatalogCards(items as object, first as integer, selected as integer, zone as string, y as integer)
    for i = 0 to 5
        n = first+i
        if n < items.count()
            item = items[n]
            x = 60+i*304
            glassSurface("glass-tile",x,y,280,574)
            thumbnail(item.poster,x+10,y+10,260,390,"poster")
            words(item.title,x+12,y+418,256,100,28).wrap = true
            facts = orbitText(item.year,12)
            if type(item.sourceOptions) = "roArray"
                if item.sourceOptions.count() > 1 then facts += " · "+item.sourceOptions.count().toStr()+" opciones"
            end if
            words(facts,x+13,y+530,254,32,21,"0xB3C4B0FF")
            focusTarget(zone,n,x+4,y+4,272,402,"card")
        end if
    end for
end sub

sub watchlistScreen()
    topBar()
    words("Mi lista",60,137,1550,83,54)
    words("Películas y series guardadas en esta Roku.",64,239,1710,53,28,"0xC5D0C0FF")
    if type(m.watchlistItems) <> "roArray" then return
    first = (m.watchlistCursor \ 6)*6
    drawCatalogCards(m.watchlistItems,first,m.watchlistCursor,"watchlist",345)
    if m.watchlistItems.count() = 0
        words("Tu próxima sesión empieza aquí",90,445,1670,85,43)
        words("Añade películas y series desde su ficha con Mi lista.",94,550,1660,100,29,"0xC4D1C0FF").wrap = true
    else
        words((first+1).toStr()+"–"+minUi(first+6,m.watchlistItems.count()).toStr()+" de "+m.watchlistItems.count().toStr(),64,1008,1710,36,23,"0xBBCBB7FF")
    end if
end sub

function minUi(a as integer, b as integer) as integer
    if a < b then return a
    return b
end function

sub detailScreen()
    topBar()
    if type(m.detail) <> "roAssociativeArray" then return
    item = m.detail
    ' Saved watchlist/history entries intentionally omit transient metadata.
    ' Render their minimal snapshot while metadata/resolve is still pending.
    thumbnail(orbitText(item.poster,4096),60,165,400,600,"poster")
    heading = "PELÍCULA"
    kind = orbitText(item.kind,12)
    if kind = "series" then heading = "SERIE"
    if kind = "episode" then heading = "EPISODIO"
    words(heading,520,145,1260,42,23,"0xBFCFBAFF")
    title = orbitText(item.title,200).trim()
    if title = "" then title = "Título guardado"
    words(title,516,200,1320,143,53).wrap = true
    facts = orbitText(item.year,32)
    runtime = orbitInteger(item.runtime,172800)
    if runtime > 0
        duration = timeText(runtime)
        if facts <> "" then duration += " · "+facts
        facts = duration
    end if
    words(facts,523,356,1300,43,26,"0xC2D1BEFF")
    summary = orbitText(item.description,2400).trim()
    if summary = "" then summary = "Consulta las opciones de reproducción disponibles para este título."
    words(left(summary,570),523,424,1300,195,28,"0xE0E7DDFF").wrap = true
    actions = detailActionLabels()
    count = actions.count()
    height = 63
    gap = 15
    for i = 0 to count-1
        y = 650+i*(height+gap)
        actionWidth = 660
        if i = 0 then actionWidth = 500
        if actions[i].id = "back" then actionWidth = 290
        selectable("action",i,actions[i].label,520,y,actionWidth,height,i=0)
    end for
    if type(item.sourceOptions) = "roArray"
        if item.sourceOptions.count() > 1 then words(item.sourceOptions.count().toStr()+" fuentes reunidas para este título",64,807,395,92,23,"0xB6C7B1FF").wrap = true
    end if
end sub

sub episodeScreen()
    topBar()
    if m.series = invalid or m.series.seasons.count() = 0 then return
    season = m.series.seasons[m.season]
    thumbnail(m.series.poster,60,170,340,510,"poster")
    words(m.series.title,450,135,1370,95,47).wrap = true
    words("← Temporada "+season.number.toStr()+" →",456,249,1340,48,29,"0xC4D2BDFF")
    first = (m.episode \ 6)*6
    for i = 0 to 5
        n = first+i
        if n < season.episodes.count()
            item = season.episodes[n]
            y = 326+i*103
            glassSurface("glass-row",450,y,1380,91)
            words(item.episode.toStr(),474,y+24,90,44,29,"0xD9E5D1FF")
            words(item.title,583,y+18,1210,62,29).wrap = true
            focusTarget("episodes",n,444,y-5,1392,101,"live")
        end if
    end for
    if season.episodes.count() > 0
        words("Episodio "+(m.episode+1).toStr()+" de "+season.episodes.count().toStr(),456,989,1340,42,24,"0xB7C7AFFF")
    else if not m.busy
        words("No hay episodios cargados. OK para volver a consultar.",456,430,1340,100,31,"0xC1CEBBFF").wrap = true
    end if
end sub

' Channel badges use source logos as-is, with a real fallback for absent or
' failed images. Live video is never simulated by an image.
sub liveChannelBadge(item as object, x as integer, y as integer)
    glassSurface("live-logo-badge",x,y,106,77)
    initials = "TV"
    if GetInterface(item.title,"ifString") <> invalid
        parts = item.title.trim().split(" ")
        if parts.count() > 1
            initials = ucase(left(parts[0],1)+left(parts[1],1))
        else if parts.count() = 1
            initials = ucase(left(parts[0],2))
        end if
    end if
    badge = words(initials,x+4,y+18,98,45,28,"0x303633FF")
    badge.horizAlign = "center"
    uri = ""
    if GetInterface(item.poster,"ifString") <> invalid then uri = item.poster
    if uri <> ""
        poster = art("",x+7,y+7,92,63,"scaleToFit")
        poster.visible = false
        m.liveLogoFallbacks.push({poster:poster,fallback:badge})
        ' Cached images may become ready as soon as URI is set.
        poster.observeField("loadStatus","liveLogoLoadStatusChanged")
        poster.uri = uri
    end if
end sub

sub liveLogoLoadStatusChanged(event as object)
    if type(m.liveLogoFallbacks) <> "roArray" then return
    poster = event.getRoSGNode()
    for each entry in m.liveLogoFallbacks
        if entry.poster.isSameNode(poster)
            ready = event.getData() = "ready"
            entry.poster.visible = ready
            entry.fallback.visible = not ready
            return
        end if
    end for
end sub

function liveChannelStatus(item as object) as string
    if item.available = false
        if GetInterface(item.availabilityLabel,"ifString") <> invalid then return item.availabilityLabel
        return "Sin señal disponible"
    end if
    return "En vivo"
end function

sub liveScreen()
    topBar()
    query = ""
    if GetInterface(m.liveQuery,"ifString") <> invalid then query = m.liveQuery
    searching = query <> ""
    searchEmpty = searching and m.channels.count() = 0 and not m.busy
    words("TV en vivo",60,132,600,80,51)
    selectable("live-filters",0,"Todos",828,134,182,62,m.liveFilter=0)
    selectable("live-filters",1,countryName(),1026,134,290,62,m.liveFilter=1)
    selectable("live-filters",2,"LATAM",1332,134,202,62,m.liveFilter=2)
    selectable("live-filters",3,"Favoritos",1550,134,310,62,m.liveFilter=3)
    searchWidth = 1800
    searchText = "Buscar canales…"
    if searching
        searchWidth = 1550
        searchText = "Buscar: "+left(query,92)
    end if
    glassSurface("glass-row",60,205,searchWidth,50)
    art("pkg:/images/ui/search.png",78,216,28,28)
    words(searchText,125,215,searchWidth-92,34,25,"0xE8EEE3FF")
    focusTarget("live-search",0,56,201,searchWidth+8,58,"live-search")
    if searching then selectable("live-search",1,"Borrar",1630,205,230,50)
    drawCategoryChips(rpLiveCategories(),m.liveCategory,m.liveCategoryCursor,"live-categories",269)
    ' The controller and player share this exact 16:9 rectangle.
    glassSurface("live-preview-frame",51,321,1138,648)
    panel(60,330,1120,630,"0x141A19FF")
    art("pkg:/images/ui/live-preview-base.png",60,330,1120,630)
    art("pkg:/images/ui/live.png",570,537,100,100)
    placeholder = "Elige un canal para comenzar"
    if type(m.livePreviewItem) = "roAssociativeArray"
        placeholder = "Preparando la señal…"
        if GetInterface(m.livePreviewStatus,"ifString") <> invalid
            if m.livePreviewStatus <> "" then placeholder = m.livePreviewStatus
        end if
    end if
    if searchEmpty then placeholder = "No se encontraron canales"
    words(placeholder,135,662,970,100,31,"0xC6CEC7FF").horizAlign = "center"
    art("pkg:/images/ui/live-preview-mask.png",60,330,1120,630)
    current = invalid
    if m.channels.count() > 0 and type(m.livePreviewItem) = "roAssociativeArray" then current = m.livePreviewItem
    if current = invalid and m.liveCursor >= 0 and m.liveCursor < m.channels.count() then current = m.channels[m.liveCursor]
    if type(current) = "roAssociativeArray"
        words(current.title,60,976,542,67,31).wrap = true
        selectable("live-actions",0,"Pantalla completa",620,980,260,60)
        favoriteText = "Añadir a favoritos"
        if rpLiveIsFavorite(current,m.liveFavorites) then favoriteText = "Quitar de favoritos"
        selectable("live-actions",1,favoriteText,899,980,281,60)
    else
        empty = "Selecciona un canal para ver su señal."
        if m.liveFilter = 3 then empty = "Guarda tus canales con * para encontrarlos aquí."
        if searchEmpty then empty = "Cambia o borra tu búsqueda para ver otros canales."
        words(empty,64,986,1110,56,26,"0xC6CEC7FF").wrap = true
    end if
    first = (m.liveCursor \ 6)*6
    last = first+6
    if last > m.channels.count() then last = m.channels.count()
    for i = 0 to 5
        n = first+i
        if n < m.channels.count()
            item = m.channels[n]
            y = 342+i*110
            surface = "live-channel-row"
            if n = m.liveCursor then surface = "live-channel-selected"
            glassSurface(surface,1210,y,650,102)
            liveChannelBadge(item,1227,y+12)
            ink = "0xF6F7F2FF"
            if item.available = false then ink = "0xBCC5BDFF"
            words(item.title,1350,y+12,435,56,27,ink).wrap = true
            dot = "live-status-on"
            if item.available = false then dot = "live-status-off"
            art("pkg:/images/ui/"+dot+".png",1350,y+76,11,11)
            words(liveChannelStatus(item),1371,y+75,420,27,19,"0xCCD5CCFF")
            star = "live-star-outline"
            if rpLiveIsFavorite(item,m.liveFavorites) then star = "live-star-filled"
            art("pkg:/images/ui/"+star+".png",1816,y+16,27,27)
            focusTarget("live",n,1204,y-5,662,112,"live-channel")
        end if
    end for
    if m.channels.count() > 6
        glassSurface("live-scroll-track",1874,345,8,647)
        pages = int((m.channels.count()+5)/6)
        thumb = int(647/pages)
        if thumb < 38 then thumb = 38
        sy = 345+int((647-thumb)*(first/6)/(pages-1))
        glassSurface("live-scroll-thumb",1874,sy,8,thumb)
    end if
    if m.channels.count() = 0
        empty = "No hay canales en esta selección."
        if m.busy then empty = "Cargando canales…"
        if m.liveFilter = 3 then empty = "Tus favoritos aparecerán aquí."
        if searchEmpty then empty = "No hay coincidencias. Cambia o borra la búsqueda."
        glassSurface("live-empty",1210,342,650,240)
        words(empty,1250,409,570,128,30,"0xDCE1D9FF").wrap = true
    end if
    if last > 0 then words((first+1).toStr()+"–"+last.toStr()+" de "+m.channels.count().toStr(),1215,1017,640,31,22,"0xC7CFC9FF").horizAlign = "right"
end sub

sub settingsScreen()
    topBar()
    words("Configuración",60,135,1690,83,53)
    words("Tus preferencias se guardan en esta Roku.",64,235,1660,53,27,"0xBDCCB7FF")
    appearance = "Vidrio"
    if m.theme = "classic" then appearance = "Clásico"
    labels = ["Tu televisor","País o región","Catálogo HD","Créditos de cortos y documentales","Apariencia","Audio y subtítulos"]
    values = [modeName(),countryName(),hdProviderName(),"Ver fuentes y licencias",appearance,"Preferencia de idioma y subtítulos"]
    for i = 0 to 5
        y = 315+i*113
        glassSurface("glass-row",60,y,1800,99)
        words(labels[i],88,y+13,1660,40,30)
        words(values[i],90,y+62,1655,30,23,"0xB7C7BEFF")
        focusTarget("settings",i,54,y-5,1812,109)
    end for
end sub

sub mediaPrefsScreen()
    topBar()
    words("Audio y subtítulos",60,135,1690,83,53)
    words("Solo se usan los idiomas que ofrece cada video.",64,238,1720,65,29,"0xC5D1C0FF")
    audio = "Español latino"
    subtitles = "Desactivados"
    if type(m.mediaPrefs) = "roAssociativeArray"
        audio = uiMediaPreferenceName(m.mediaPrefs.audio)
        subtitles = uiMediaPreferenceName(m.mediaPrefs.subtitles)
    end if
    labels = ["Audio preferido","Subtítulos preferidos"]
    values = [audio,subtitles]
    for i = 0 to 1
        y = 365+i*160
        glassSurface("glass-row",60,y,1800,135)
        words(labels[i],94,y+22,1680,48,33)
        words(values[i],97,y+82,1660,38,27,"0xC4D2BDFF")
        focusTarget("media-prefs",i,54,y-6,1812,147)
    end for
    words("Durante la reproducción puedes abrir Audio y subtítulos para elegir una pista disponible.",64,747,1730,105,30,"0xCDD8C7FF").wrap = true
    words("Español sin región no se presenta como latino. Si falta el idioma elegido, la app lo indicará.",64,890,1730,102,27,"0xB8C7B1FF").wrap = true
end sub

function uiMediaPreferenceName(value as dynamic) as string
    if GetInterface(value,"ifString") = invalid then return "Sin especificar"
    if value = "latino" then return "Español latino"
    if value = "castellano" then return "Español de España"
    if value = "spanish" then return "Español (sin región)"
    if value = "system" then return "Preferencia de Roku"
    if value = "off" then return "Desactivados"
    if value = "english" or value = "en" then return "Inglés"
    return "Sin especificar"
end function

sub appearanceScreen()
    topBar()
    words("Apariencia",60,135,1740,87,53)
    words("Elige cómo quieres ver Roku Plus.",64,240,1730,65,28,"0xCED8CEFF")
    names = ["Vidrio","Clásico"]
    descriptions = ["Superficies translúcidas, reflejos suaves y tonos naturales.","Paneles oscuros y un contraste más marcado."]
    for i = 0 to 1
        x = 60+i*920
        glassSurface("setup-card",x,326,880,456)
        preview = "appearance-glass-preview"
        if i = 1 then preview = "appearance-classic-preview"
        art("pkg:/images/ui/"+preview+".png",x+26,354,828,235)
        words(names[i],x+30,615,790,60,39)
        words(descriptions[i],x+32,695,810,67,25,"0xD1DACFFF").wrap = true
        current = (i = 0 and m.theme <> "classic") or (i = 1 and m.theme = "classic")
        if current then words("Actual",x+688,627,145,36,22,"0xF4EDC8FF").horizAlign = "right"
        focusTarget("appearance",i,x-6,320,892,468,"appearance")
    end for
    words("← / →  Elegir     OK  Aplicar     Atrás  Volver",64,945,1740,54,25,"0xDCE3D7FF")
end sub

sub hdSourceScreen()
    topBar()
    words("Catálogo HD",60,135,1740,87,53)
    words("Elige la biblioteca que se utilizará en el modo HD / Full HD.",64,236,1740,80,29,"0xADADB9FF").wrap = true
    choices = hdProviderChoices()
    first = 0
    if m.hdSourceCursor >= 6 then first = m.hdSourceCursor-5
    for i = 0 to 5
        n = first+i
        if n < choices.count()
        name = hdProviderName(choices[n])
        description = "Películas y series · alternativas en español"
        if choices[n] = "all" then description = "Una búsqueda, varias opciones de la misma película o serie"
        if choices[n] = "lamovie" then description = "Películas y series · alternativas etiquetadas en español"
        if choices[n] = "allcalidad" then description = "Películas y series · latino y dual"
        if choices[n] = "seriesmetro" then description = "Películas y series · servidores alternativos Fastream"
        if choices[n] = "cinecalidad" then description = "Películas · sin sección de series"
        if choices[n] = "open" then description = "Biblioteca pequeña de Blender y NASA"
        y = 330+i*106
        art("pkg:/images/ui/pill.png",60,y,1800,98)
        words(name,92,y+10,1720,41,29)
        words(description,94,y+56,1710,32,22,"0xAAAAB6FF")
        focusTarget("hd-source",n,54,y-5,1812,108)
        end if
    end for
    words("Las fuentes y los títulos disponibles pueden cambiar. Se comprueba el formato antes de reproducir.",64,1004,1740,59,22,"0x92929EFF").wrap = true
end sub

sub creditsScreen()
    topBar()
    words("Créditos de la biblioteca HD",60,135,1740,87,48)
    words(m.creditsPages[m.creditsPage],64,270,1740,710,25,"0xBDBDC8FF").wrap = true
    words("Página "+(m.creditsPage+1).toStr()+" / "+m.creditsPages.count().toStr()+" · ↑/↓: cambiar · Atrás: volver",64,1002,1740,46,22,"0x8F8F9DFF")
end sub

sub paintFocus()
    for each entry in m.focusItems
        chosen = false
        if entry.zone = m.zone
            if m.zone = "nav" then chosen = entry.index = m.nav
            if m.zone = "hero" then chosen = entry.index = m.hero
            if m.zone = "covers" then chosen = entry.index = m.cover
            if m.zone = "home-series" then chosen = entry.index = m.seriesCover
            if m.zone = "grid" then chosen = entry.index = m.cursor
            if m.zone = "global-search" then chosen = entry.index = 0
            if m.zone = "browse-search" then chosen = entry.index = m.browseSearchCursor
            if m.zone = "catalog-categories" then chosen = entry.index = m.catalogCategoryCursor
            if m.zone = "live-categories" then chosen = entry.index = m.liveCategoryCursor
            if m.zone = "continue" then chosen = entry.index = m.continueCursor
            if m.zone = "watchlist" then chosen = entry.index = m.watchlistCursor
            if m.zone = "media-prefs" then chosen = entry.index = m.mediaPrefsCursor
            if m.zone = "action" then chosen = entry.index = m.action
            if m.zone = "episodes" then chosen = entry.index = m.episode
            if m.zone = "live" then chosen = entry.index = m.liveCursor
            if m.zone = "live-filters" then chosen = entry.index = m.liveFilterCursor
            if m.zone = "live-search" then chosen = entry.index = m.liveSearchCursor
            if m.zone = "live-actions" then chosen = entry.index = m.liveAction
            if m.zone = "settings" then chosen = entry.index = m.settingsCursor
            if m.zone = "appearance" then chosen = entry.index = m.themeCursor
            if m.zone = "hd-source" then chosen = entry.index = m.hdSourceCursor
            if m.zone = "setup" then chosen = entry.index = m.setupTv
            if m.zone = "country" then chosen = entry.index = m.setupCountry
        end if
        entry.edge.visible = chosen
    end for
end sub
