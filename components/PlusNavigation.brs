' Horizontal navigation and one contextual search. No provider requests on focus.
function handleLibraryKey(key as string) as boolean
    supported = m.view = "home" or m.view = "browse" or m.view = "live" or m.view = "detail" or m.view = "episodes" or m.view = "watchlist" or m.view = "settings" or m.view = "media-prefs"
    if not supported then return false
    previousLayout = navigationLayoutKey()
    if key = "back"
        if m.busy
            cancelRequest()
            m.autoplay = false
            drawScreen()
        else if m.view = "live" and m.zone <> "live-filters" and m.zone <> "nav"
            m.zone = "live-filters"
            refreshNavigation(previousLayout)
        else if m.view = "browse" and m.zone = "grid"
            m.zone = "catalog-categories"
            refreshNavigation(previousLayout)
        else
            returnOneStep()
        end if
        return true
    end if
    if key = "options" or key = "info"
        if m.view = "live"
            toggleLiveFavorite()
        else if m.view = "browse"
            openSearch()
        else
            openGlobalSearch()
        end if
        return true
    end if
    hasGlobalSearch = m.view <> "browse" and m.view <> "live"
    if m.zone = "global-search"
        if key = "left" then m.nav = 4: m.zone = "nav"
        if key = "right" then m.nav = 5: m.zone = "nav"
        if key = "down" then focusSectionContent()
        if key = "OK" then openGlobalSearch(): return true
        refreshNavigation(previousLayout)
        return true
    end if
    if m.zone = "nav"
        if key = "left"
            if m.nav = 5 and hasGlobalSearch
                m.zone = "global-search"
            else if m.nav = 4
                m.nav = 6
            else if m.nav = 6
                m.nav = 3
            else if m.nav > 0
                m.nav--
            end if
        end if
        if key = "right"
            if m.nav = 4 and hasGlobalSearch
                m.zone = "global-search"
            else if m.nav = 3
                m.nav = 6
            else if m.nav = 6
                m.nav = 4
            else if m.nav < 5
                m.nav++
            end if
        end if
        if key = "down" then focusSectionContent()
        if key = "OK" then activateNav(): return true
        refreshNavigation(previousLayout)
        return true
    end if
    if m.busy and m.view <> "live" then return true
    if m.view = "settings"
        if key = "up"
            if m.settingsCursor > 0 then m.settingsCursor-- else m.zone = "nav"
        end if
        if key = "left" then m.zone = "nav"
        if key = "down" and m.settingsCursor < 5 then m.settingsCursor++
        if key = "OK"
            if m.settingsCursor = 0 then beginSetup(true,false)
            if m.settingsCursor = 1 then beginSetup(true,true)
            if m.settingsCursor = 2 then openHdSource()
            if m.settingsCursor = 3 then openCredits()
            if m.settingsCursor = 4 then openAppearance()
            if m.settingsCursor = 5 then openMediaPreferences()
            return true
        end if
    else if m.view = "media-prefs"
        if key = "up"
            if m.mediaPrefsCursor > 0 then m.mediaPrefsCursor-- else m.zone = "nav"
        end if
        if key = "left" then m.zone = "nav"
        if key = "down" and m.mediaPrefsCursor < 1 then m.mediaPrefsCursor++
        if key = "OK" then chooseMediaPreference(): return true
    else if m.view = "home"
        if m.zone = "hero"
            if key = "left" then m.hero = 0
            if key = "right" and m.features.count() > 0 then m.hero = 1
            if key = "up" then m.zone = "nav": m.nav = 0
            if key = "down"
                if m.continueItems.count() > 0 then m.zone = "continue" else m.zone = "covers"
            end if
            if key = "OK"
                if m.features.count() > 0 then openDetails(m.features[0],"home",m.hero=0) else refreshHome(): drawScreen()
                return true
            end if
        else if m.zone = "continue"
            if key = "left" and m.continueCursor > 0 then m.continueCursor--
            if key = "right" and m.continueCursor+1 < m.continueItems.count() then m.continueCursor++
            if key = "up" then m.zone = "hero"
            if key = "down" then m.zone = "covers"
            if key = "OK" and m.continueCursor < m.continueItems.count()
                item = restoreSavedItem(m.continueItems[m.continueCursor])
                openDetails(item,"continue",true)
                return true
            end if
        else if m.zone = "covers"
            if key = "left" and m.cover > 0 then m.cover--
            if key = "right" and m.cover < 5 and m.cover+1 < m.features.count() then m.cover++
            if key = "up"
                if m.continueItems.count() > 0 then m.zone = "continue" else m.zone = "hero"
            end if
            if key = "down" and m.homeSeries.count() > 0 then m.zone = "home-series"
            if key = "OK" and m.cover < m.features.count() then openDetails(m.features[m.cover],"home"): return true
        else if m.zone = "home-series"
            if key = "left" and m.seriesCover > 0 then m.seriesCover--
            if key = "right" and m.seriesCover < 5 and m.seriesCover+1 < m.homeSeries.count() then m.seriesCover++
            if key = "up" then m.zone = "covers"
            if key = "OK" and m.seriesCover < m.homeSeries.count() then openDetails(m.homeSeries[m.seriesCover],"home"): return true
        end if
    else if m.view = "browse"
        if m.zone = "browse-search"
            if key = "up" then m.zone = "nav"
            if key = "down" then m.zone = "catalog-categories"
            if key = "left" then m.browseSearchCursor = 0
            if key = "right" and m.query <> "" then m.browseSearchCursor = 1
            if key = "OK"
                if m.browseSearchCursor = 1 then clearCatalogSearch() else openSearch()
                return true
            end if
        else if m.zone = "catalog-categories"
            if key = "up" then m.zone = "browse-search"
            if key = "left" then selectCatalogCategory(m.catalogCategoryCursor-1): return true
            if key = "right" then selectCatalogCategory(m.catalogCategoryCursor+1): return true
            if key = "OK" or key = "down"
                m.zone = "grid"
                if m.titles.count() = 0 and m.more then requestMoreBrowse(): return true
            end if
        else
            ' The catalog is one horizontal sequence, including loaded blocks.
            if key = "left" and m.cursor > 0 then m.cursor--
            if key = "right"
                if m.cursor+1 < m.titles.count()
                    m.cursor++
                else if m.more
                    requestMoreBrowse()
                    return true
                end if
            end if
            if key = "up"
                if m.cursor >= 6 then m.cursor -= 6 else m.zone = "catalog-categories"
            end if
            if key = "rewind"
                m.cursor -= 6
                if m.cursor < 0 then m.cursor = 0
            end if
            if key = "down" or key = "fastforward"
                if m.cursor+6 < m.titles.count()
                    m.cursor += 6
                else if (m.cursor\6+1)*6 < m.titles.count()
                    m.cursor = m.titles.count()-1
                else if m.more
                    requestMoreBrowse()
                    return true
                end if
            end if
            if key = "OK" and m.cursor < m.titles.count() then openDetails(m.titles[m.cursor],"browse"): return true
        end if
    else if m.view = "watchlist"
        if key = "up"
            if m.watchlistCursor >= 6 then m.watchlistCursor -= 6 else m.zone = "nav": m.nav = 4
        end if
        if key = "left" and m.watchlistCursor mod 6 > 0 then m.watchlistCursor--
        if key = "right" and m.watchlistCursor mod 6 < 5 and m.watchlistCursor+1 < m.watchlistItems.count() then m.watchlistCursor++
        if key = "down" and (m.watchlistCursor\6+1)*6 < m.watchlistItems.count()
            m.watchlistCursor += 6
            if m.watchlistCursor >= m.watchlistItems.count() then m.watchlistCursor = m.watchlistItems.count()-1
        end if
        if key = "OK" and m.watchlistCursor < m.watchlistItems.count()
            openDetails(restoreSavedItem(m.watchlistItems[m.watchlistCursor]),"watchlist")
            return true
        end if
    else if m.view = "detail"
        if key = "up"
            if m.action > 0 then m.action-- else m.zone = "nav"
        end if
        if key = "left" then m.zone = "nav"
        actions = detailActionLabels()
        if key = "down" and m.action+1 < actions.count() then m.action++
        if key = "OK" and m.action < actions.count()
            action = actions[m.action].id
            if action = "play"
                if m.detail.kind = "series" then enterEpisodes() else playDetail()
            else if action = "watch"
                toggleMovieWatchlist()
            else if action = "sources"
                openSourceOptions()
            else
                returnOneStep()
            end if
            return true
        end if
    else if m.view = "episodes"
        if m.series = invalid or m.series.seasons.count() = 0 then return true
        if key = "left" and m.season > 0
            m.season--
            m.episode = 0
            loadEpisodeSeason()
        end if
        if key = "right" and m.season+1 < m.series.seasons.count()
            m.season++
            m.episode = 0
            loadEpisodeSeason()
        end if
        items = m.series.seasons[m.season].episodes
        if key = "up"
            if m.episode > 0 then m.episode-- else m.zone = "nav": m.nav = 2
        end if
        if key = "down" and m.episode+1 < items.count() then m.episode++
        if key = "OK"
            if m.episode < items.count() then openDetails(items[m.episode],"episodes") else loadEpisodeSeason()
            return true
        end if
    else if m.view = "live"
        if m.zone = "live-filters"
            if key = "up" then m.zone = "nav": m.nav = 3
            if key = "left" and m.liveFilterCursor > 0 then selectLiveFilter(m.liveFilterCursor-1): return true
            if key = "right" and m.liveFilterCursor < 3 then selectLiveFilter(m.liveFilterCursor+1): return true
            if key = "down" or key = "OK" then m.zone = "live-search": m.liveSearchCursor = 0
        else if m.zone = "live-search"
            if key = "up" then m.zone = "live-filters"
            if key = "down" then m.zone = "live-categories"
            if key = "left" then m.liveSearchCursor = 0
            if key = "right" and m.liveQuery <> "" then m.liveSearchCursor = 1
            if key = "OK"
                if m.liveSearchCursor = 1 then clearLiveSearch() else openLiveSearch()
                return true
            end if
        else if m.zone = "live-categories"
            if key = "up" then m.zone = "live-search"
            nextCategory = m.liveCategoryCursor
            if key = "left" then nextCategory--
            if key = "right" then nextCategory++
            choices = rpLiveCategories()
            if nextCategory >= 0 and nextCategory < choices.count() and nextCategory <> m.liveCategoryCursor
                m.liveCategoryCursor = nextCategory
                m.liveCategory = choices[nextCategory].id
                refreshLiveList(false)
            end if
            if (key = "down" or key = "OK") and m.channels.count() > 0 then m.zone = "live"
        else if m.zone = "live-actions"
            if key = "up" then m.zone = "live-categories"
            if key = "left" then m.liveAction = 0
            if key = "right"
                if m.liveAction = 0 then m.liveAction = 1 else m.zone = "live"
            end if
            if key = "OK"
                if m.liveAction = 0 then playLiveSelection() else toggleLiveFavorite()
                return true
            end if
        else
            previous = m.liveCursor
            if key = "left" then m.zone = "live-actions": m.liveAction = 0
            if key = "up"
                if m.liveCursor > 0 then m.liveCursor-- else m.zone = "live-categories"
            end if
            if key = "down" and m.liveCursor+1 < m.channels.count() then m.liveCursor++
            if key = "OK" and m.liveCursor < m.channels.count() then playLiveSelection(): return true
            if previous <> m.liveCursor then scheduleLivePreview()
        end if
    end if
    refreshNavigation(previousLayout)
    return true
end function

' Focus edges already exist for every item in a visible block. Preserve those
' nodes and loaded posters while moving within it instead of rebuilding images.
function navigationLayoutKey() as string
    state = [m.view,m.busy,m.note]
    if m.view = "home"
        group = "base"
        if m.zone = "continue" then group = "continue"
        if m.zone = "home-series" then group = "series"
        state.push(group)
        state.push(navigationPage(m.continueCursor,3))
    else if m.view = "browse"
        state.push(navigationPage(m.cursor,6))
    else if m.view = "watchlist"
        state.push(navigationPage(m.watchlistCursor,6))
    else if m.view = "episodes"
        ' The episode footer includes the selected episode; keep it current.
        state.push(m.season)
        state.push(m.episode)
    else if m.view = "live"
        ' TV changes the preview metadata and row background with selection.
        state.push(m.liveCursor)
        state.push(m.liveFilter)
        state.push(m.liveCategory)
        state.push(m.liveQuery)
    end if
    return FormatJson(state)
end function

function navigationPage(value as dynamic, size as integer) as integer
    if GetInterface(value,"ifInt") = invalid then return 0
    if value < 0 then return 0
    return value \ size
end function

sub refreshNavigation(previousLayout as string)
    if previousLayout = navigationLayoutKey()
        paintFocus()
    else
        drawScreen()
    end if
end sub
