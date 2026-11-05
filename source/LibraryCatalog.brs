' Pure catalog presentation. Reliable IDs only; no title-only deduplication.
function rpCatalogCategories(kind = "movie" as string) as object
    allLabel = "Todas"
    return [{id:"all",label:allLabel},{id:"family",label:"Infantil y familiar"},{id:"action",label:"Acción"},{id:"comedy",label:"Comedia"},{id:"drama",label:"Drama"},{id:"animation",label:"Animación"},{id:"documentary",label:"Documentales"},{id:"horror",label:"Terror"}]
end function

' The public Cinemeta manifest advertises these exact genre options for both
' movie and series top catalogs. Never guess a provider genre from a title.
function rpCatalogUpstreamGenre(categoryId as dynamic) as string
    names = {family:"Family",action:"Action",comedy:"Comedy",drama:"Drama",animation:"Animation",documentary:"Documentary",horror:"Horror"}
    key = lcase(orbitText(categoryId,32))
    if names.doesExist(key) then return names[key]
    return ""
end function

function rpCatalogEndpoint(kind as string, query as string, skip as integer, categoryId as dynamic, encoder = invalid as dynamic) as string
    if kind <> "movie" and kind <> "series" then return ""
    if encoder = invalid then encoder = CreateObject("roUrlTransfer")
    extras = ""
    genre = rpCatalogUpstreamGenre(categoryId)
    if genre <> "" then extras = "genre="+encoder.escape(genre)
    query = left(query.trim(),120)
    if query <> ""
        if extras <> "" then extras += "&"
        extras += "search="+encoder.escape(query)
    end if
    if skip > 0
        if extras <> "" then extras += "&"
        extras += "skip="+skip.toStr()
    end if
    endpoint = "https://v3-cinemeta.strem.io/catalog/"+kind+"/top"
    if extras <> "" then endpoint += "/"+extras
    return endpoint+".json"
end function

' Keep previous pages and their alternative sources while adding new results.
function rpCatalogAppendItems(existing as dynamic, incoming as dynamic) as object
    merged = []
    if type(existing) = "roArray"
        for each item in existing
            merged.push(item)
        end for
    end if
    if type(incoming) = "roArray"
        for each item in incoming
            merged.push(item)
        end for
    end if
    return rpCatalogGroupItems(merged)
end function

function rpCatalogCategoryItems(items as dynamic, categoryId as dynamic) as object
    result = []
    if type(items) <> "roArray" then return result
    category = lcase(orbitText(categoryId,32))
    for each item in items
        if type(item) = "roAssociativeArray"
            include = category = "" or category = "all"
            if not include
                for each genre in orbitGenres(item.genres)
                    if genre = category then include = true
                end for
                if category = "family"
                    rating = ucase(orbitText(item.contentRating,32))
                    if rating = "G" or rating = "TV-Y" or rating = "TV-Y7" or rating = "TV-G" or rating = "AA" then include = true
                end if
            end if
            if include then result.push(item)
        end if
    end for
    return result
end function

function rpCatalogWorkKey(item as dynamic) as string
    if type(item) <> "roAssociativeArray" then return ""
    kind = orbitText(item.kind,16)
    if kind <> "movie" and kind <> "series" and kind <> "episode" then return ""
    imdb = orbitImdb(item.imdbId)
    if imdb = "" then imdb = orbitImdb(item.id)
    identity = ""
    if imdb <> "" then identity = "imdb:"+imdb
    tmdb = rpCatalogTmdb(item)
    if identity = "" and tmdb <> "" then identity = "tmdb:"+tmdb
    if identity = ""
        localId = orbitText(item.id,200)
        if localId = "" then return ""
        identity = "source:"+orbitText(item.provider,32)+":"+localId
    end if
    if kind = "episode" then identity += ":s"+orbitInteger(item.season,999).toStr()+":e"+orbitInteger(item.episode,9999).toStr()
    return kind+":"+identity
end function

function rpCatalogTmdb(item as object) as string
    id = orbitInteger(item.tmdbId,999999999)
    if id = 0 then id = orbitInteger(item.providerTmdbId,999999999)
    if id = 0 then return ""
    return id.toStr()
end function

function rpCatalogCopyItem(item as object) as object
    result = {}
    for each key in item
        if key <> "sourceOptions" and key <> "sourceCount" then result[key] = item[key]
    end for
    return result
end function

function rpCatalogSourceOptions(item as dynamic) as object
    result = []
    if type(item) <> "roAssociativeArray" then return result
    inputs = item.sourceOptions
    if type(inputs) <> "roArray" then inputs = [item]
    seen = {}
    for each option in inputs
        if type(option) = "roAssociativeArray"
            key = orbitText(option.provider,32)+":"+orbitText(option.id,200)
            if key <> ":" and not seen.doesExist(key)
                result.push(rpCatalogCopyItem(option))
                seen[key] = true
                if result.count() >= 16 then exit for
            end if
        end if
    end for
    return result
end function

function rpCatalogGroupItems(items as dynamic) as object
    result = []
    if type(items) <> "roArray" then return result
    imdbMap = {}
    tmdbMap = {}
    localMap = {}
    for each item in items
        if type(item) = "roAssociativeArray"
            key = rpCatalogWorkKey(item)
            if key <> ""
                kind = orbitText(item.kind,16)
                suffix = ""
                if kind = "episode" then suffix = ":s"+orbitInteger(item.season,999).toStr()+":e"+orbitInteger(item.episode,9999).toStr()
                imdb = orbitImdb(item.imdbId)
                if imdb = "" then imdb = orbitImdb(item.id)
                tmdb = rpCatalogTmdb(item)
                imdbKey = kind+":"+imdb+suffix
                tmdbKey = kind+":"+tmdb+suffix
                index = -1
                conflict = false
                if imdb <> "" and imdbMap.doesExist(imdbKey) then index = imdbMap[imdbKey]
                if tmdb <> "" and tmdbMap.doesExist(tmdbKey)
                    if index >= 0 and index <> tmdbMap[tmdbKey] then conflict = true else index = tmdbMap[tmdbKey]
                end if
                if index < 0 and localMap.doesExist(key) then index = localMap[key]
                if conflict then index = -1
                if index < 0
                    grouped = rpCatalogCopyItem(item)
                    grouped.sourceOptions = rpCatalogSourceOptions(item)
                    grouped.sourceCount = grouped.sourceOptions.count()
                    result.push(grouped)
                    index = result.count()-1
                else
                    grouped = result[index]
                    alternatives = rpCatalogSourceOptions(item)
                    merged = []
                    for each old in grouped.sourceOptions
                        merged.push(old)
                    end for
                    for each option in alternatives
                        merged.push(option)
                    end for
                    grouped.sourceOptions = rpCatalogSourceOptions({sourceOptions:merged})
                    grouped.sourceCount = grouped.sourceOptions.count()
                    genres = []
                    for each genre in orbitGenres(grouped.genres)
                        genres.push(genre)
                    end for
                    for each genre in orbitGenres(item.genres)
                        genres.push(genre)
                    end for
                    grouped.genres = orbitGenres(genres)
                end if
                if not conflict
                    if imdb <> "" then imdbMap[imdbKey] = index
                    if tmdb <> "" then tmdbMap[tmdbKey] = index
                    localMap[key] = index
                end if
            end if
        end if
    end for
    return result
end function
