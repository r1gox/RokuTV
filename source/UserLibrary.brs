' Local watchlist and verified VOD progress. Never persist playback URLs/headers.
function rpUserSnapshot(value as dynamic, includeSources = true as boolean) as dynamic
    if type(value) <> "roAssociativeArray" then return invalid
    kind = orbitText(value.kind,12)
    if kind <> "movie" and kind <> "series" and kind <> "episode" then return invalid
    id = orbitText(value.id,180)
    title = orbitText(value.title,200)
    if id = "" or title = "" then return invalid
    item = {id:id,title:title,kind:kind,seasons:[]}
    for each key in ["imdbId","tmdbId","providerTmdbId","providerId","providerKind","providerSlug","provider","library","catalogProfile","year","seriesTitle","contentRating"]
        raw = value[key]
        if GetInterface(raw,"ifString") <> invalid
            item[key] = left(raw,200)
        else if GetInterface(raw,"ifInt") <> invalid
            item[key] = raw
        end if
    end for
    for each key in ["season","episode","runtime"]
        number = orbitInteger(value[key],86400,-1)
        if number >= 0 then item[key] = number
    end for
    for each key in ["poster","background"]
        uri = orbitText(value[key],512)
        safe = orbitHttpsUrl(uri)
        if instr(1,uri,"?") > 0 or instr(1,uri,"#") > 0 then safe = ""
        if left(uri,12) = "pkg:/images/" and instr(1,uri,"?") = 0 and instr(1,uri,"#") = 0 and instr(1,uri,"..") = 0
            if not CreateObject("roRegex","[\x00-\x1F]","").isMatch(uri) then safe = uri
        end if
        item[key] = safe
    end for
    if type(value.genres) = "roArray"
        item.genres = []
        for each genre in value.genres
            if item.genres.count() < 12 and GetInterface(genre,"ifString") <> invalid then item.genres.push(left(genre,40))
        end for
    end if
    if includeSources and type(value.sourceOptions) = "roArray"
        item.sourceOptions = []
        for each source in value.sourceOptions
            clean = rpUserSnapshot(source,false)
            if clean <> invalid and item.sourceOptions.count() < 8 then item.sourceOptions.push(clean)
        end for
    end if
    return item
end function

function rpUserItemKey(value as dynamic) as string
    if type(value) <> "roAssociativeArray" then return ""
    kind = orbitText(value.kind,12)
    suffix = ""
    if kind = "episode" then suffix = ":"+orbitInteger(value.season,999).toStr()+":"+orbitInteger(value.episode,9999).toStr()
    imdb = orbitImdb(value.imdbId)
    if imdb <> "" then return kind+":"+imdb+suffix
    provider = orbitText(value.provider,32)
    id = orbitText(value.id,180)
    if id = "" then return ""
    return kind+":"+provider+":"+id+suffix
end function

function rpUserLibraryNormalize(raw as dynamic) as object
    result = {version:1,watchlist:[],history:[]}
    if type(raw) <> "roAssociativeArray" then return result
    if raw.version <> 1 then return result
    for each field in ["watchlist","history"]
        entries = raw[field]
        seen = {}
        limit = 40
        if field = "history" then limit = 20
        if type(entries) = "roArray"
            for each value in entries
                clean = rpUserSnapshot(value)
                if clean <> invalid and result[field].count() < limit
                    key = rpUserItemKey(clean)
                    if key <> "" and not seen.doesExist(key)
                        if field = "history"
                            position = orbitInteger(value.resumePosition,86400)
                            duration = orbitInteger(value.resumeDuration,86400)
                            if position >= 5
                                clean.resumePosition = position
                                clean.resumeDuration = duration
                                result[field].push(clean)
                                seen[key] = true
                            end if
                        else
                            result[field].push(clean)
                            seen[key] = true
                        end if
                    end if
                end if
            end for
        end if
    end for
    return result
end function

function rpUserLibraryFromText(value as dynamic) as object
    if GetInterface(value,"ifString") = invalid then return rpUserLibraryNormalize(invalid)
    if len(value) = 0 or len(value) > 16000 then return rpUserLibraryNormalize(invalid)
    value = value.trim()
    if left(value,1) <> "{" or right(value,1) <> "}" then return rpUserLibraryNormalize(invalid)
    return rpUserLibraryNormalize(ParseJson(value))
end function

function rpUserLoadLibrary() as object
    section = CreateObject("roRegistrySection","RokuPlusLibrary")
    if GetInterface(section,"ifRegistrySection") = invalid then return rpUserLibraryNormalize(invalid)
    return rpUserLibraryFromText(section.read("libraryV1"))
end function

function rpUserSaveLibrary(value as dynamic) as boolean
    library = rpUserLibraryNormalize(value)
    payload = FormatJson(library)
    if len(payload) > 16000 then return false
    section = CreateObject("roRegistrySection","RokuPlusLibrary")
    if GetInterface(section,"ifRegistrySection") = invalid then return false
    previous = section.read("libraryV1")
    if section.write("libraryV1",payload) <> true then return false
    if section.flush() = true then return true
    if previous = "" then section.delete("libraryV1") else section.write("libraryV1",previous)
    section.flush()
    return false
end function

function rpUserHasWatchlist(library as dynamic, item as dynamic) as boolean
    key = rpUserItemKey(item)
    if key = "" then return false
    entries = rpUserQueryEntries(library,"watchlist")
    limit = entries.count()
    if limit > 40 then limit = 40
    if limit > 0
        for index = 0 to limit-1
            saved = entries[index]
            if rpUserQueryRecord(saved)
                if rpUserItemKey(saved) = key then return true
            end if
        end for
    end if
    return false
end function

function rpUserToggleWatchlist(library as dynamic, item as dynamic) as object
    clean = rpUserLibraryNormalize(library)
    key = rpUserItemKey(item)
    snapshot = rpUserSnapshot(item)
    if snapshot = invalid or key = "" then return {ok:false,library:clean,added:false,message:"Este título no puede guardarse."}
    nextItems = []
    found = false
    for each saved in clean.watchlist
        if rpUserItemKey(saved) = key then found = true else nextItems.push(saved)
    end for
    if not found
        if nextItems.count() >= 40 then return {ok:false,library:clean,added:false,message:"Mi lista está llena. Quita un título para guardar otro."}
        nextItems.unshift(snapshot)
    end if
    clean.watchlist = nextItems
    if len(FormatJson(clean)) > 16000 then return {ok:false,library:rpUserLibraryNormalize(library),added:false,message:"Mi lista está llena. Quita un título para guardar otro."}
    return {ok:true,library:clean,added:not found,message:""}
end function

function rpUserWithProgress(library as dynamic, item as dynamic, position as dynamic, duration as dynamic) as object
    clean = rpUserLibraryNormalize(library)
    snapshot = rpUserSnapshot(item)
    if snapshot = invalid then return clean
    p = orbitInteger(position,86400)
    d = orbitInteger(duration,86400)
    if p < 5 then return clean
    key = rpUserItemKey(snapshot)
    remaining = []
    for each saved in clean.history
        if rpUserItemKey(saved) <> key then remaining.push(saved)
    end for
    finished = false
    if d > 0 then finished = p >= d-20 or p >= d*0.97
    if not finished
        snapshot.resumePosition = p
        snapshot.resumeDuration = d
        remaining.unshift(snapshot)
    end if
    while remaining.count() > 20
        remaining.pop()
    end while
    clean.history = remaining
    while len(FormatJson(clean)) > 16000 and clean.history.count() > 0
        clean.history.pop()
    end while
    return clean
end function

function rpUserResumePosition(library as dynamic, item as dynamic) as integer
    key = rpUserItemKey(item)
    if key = "" then return 0
    entries = rpUserQueryEntries(library,"history")
    limit = entries.count()
    if limit > 20 then limit = 20
    if limit > 0
        for index = 0 to limit-1
            saved = entries[index]
            if rpUserQueryRecord(saved)
                if rpUserItemKey(saved) = key
                    position = orbitInteger(saved.resumePosition,86400)
                    if position >= 5 then return position
                end if
            end if
        end for
    end if
    return 0
end function

' State is normalized at registry/load/save boundaries. UI membership checks
' only read bounded records; they do not recopy artwork and eight sources for
' every library entry whenever a button gets focus.
function rpUserQueryEntries(library as dynamic, field as string) as object
    if type(library) <> "roAssociativeArray" then return []
    if library.version <> 1 then return []
    if type(library[field]) <> "roArray" then return []
    return library[field]
end function

function rpUserQueryRecord(saved as dynamic) as boolean
    if type(saved) <> "roAssociativeArray" then return false
    if orbitText(saved.id,180) = "" or orbitText(saved.title,200) = "" then return false
    kind = orbitText(saved.kind,12)
    return kind = "movie" or kind = "series" or kind = "episode"
end function
