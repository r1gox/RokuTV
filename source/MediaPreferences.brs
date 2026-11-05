' Language choices are local short codes, never provider URLs or track IDs.
function rpMediaText(value as dynamic, limit = 160 as integer) as string
    if GetInterface(value,"ifString") = invalid then return ""
    value = value.trim()
    if CreateObject("roRegex","[\x00-\x1F\x7F]","").isMatch(value) then return ""
    return left(value,limit)
end function

function rpMediaNormalizePreference(value as dynamic, subtitles = false as boolean) as string
    fallback = "latino"
    if subtitles then fallback = "off"
    code = lcase(rpMediaText(value,20))
    if code = "off"
        if subtitles then return code
        return fallback
    end if
    if code = "latino" or code = "castellano" or code = "spanish" or code = "system" then return code
    if CreateObject("roRegex","^[a-z]{2,3}$","").isMatch(code) then return code
    return fallback
end function

function rpMediaPreferencesFromText(value as dynamic) as object
    fallback = {audio:"latino",subtitles:"off"}
    text = rpMediaText(value,300)
    if text = "" or left(text,1) <> "{" or right(text,1) <> "}" then return fallback
    if not CreateObject("roRegex","^\{\s*"+chr(34),"").isMatch(text) then return fallback
    parsed = ParseJson(text)
    if type(parsed) <> "roAssociativeArray" then return fallback
    if GetInterface(parsed.version,"ifInt") = invalid then return fallback
    if parsed.version <> 1 then return fallback
    return {audio:rpMediaNormalizePreference(parsed.audio),subtitles:rpMediaNormalizePreference(parsed.subtitles,true)}
end function

function rpMediaLoadPreferences() as object
    section = CreateObject("roRegistrySection","RokuPlusMedia")
    if GetInterface(section,"ifRegistrySection") = invalid then return {audio:"latino",subtitles:"off"}
    return rpMediaPreferencesFromText(section.read("languageV1"))
end function

function rpMediaSavePreferences(audio as dynamic, subtitles as dynamic) as boolean
    if rpMediaNormalizePreference(audio) <> audio then return false
    if rpMediaNormalizePreference(subtitles,true) <> subtitles then return false
    section = CreateObject("roRegistrySection","RokuPlusMedia")
    if GetInterface(section,"ifRegistrySection") = invalid then return false
    return rpMediaStorePreferences(section,audio,subtitles)
end function

function rpMediaStorePreferences(section as object, audio as dynamic, subtitles as dynamic) as boolean
    if rpMediaNormalizePreference(audio) <> audio then return false
    if rpMediaNormalizePreference(subtitles,true) <> subtitles then return false
    previous = section.read("languageV1")
    payload = FormatJson({version:1,audio:audio,subtitles:subtitles})
    if section.write("languageV1",payload) <> true then return false
    if section.flush() = true then return true
    if previous = "" then section.delete("languageV1") else section.write("languageV1",previous)
    section.flush()
    return false
end function

' Generic es/spa does not establish which regional dubbing or subtitle was used.
function rpMediaLanguageKey(rawLanguage as dynamic, rawName = "" as dynamic) as string
    code = lcase(rpMediaText(rawLanguage,40)).replace("_","-")
    name = lcase(rpMediaText(rawName))
    if code = "und" or code = "zxx" or code = "mul" or code = "mis" then code = ""
    if code = "eng" then code = "en"
    if code = "por" then code = "pt"
    if code = "fre" or code = "fra" then code = "fr"
    if code = "ger" or code = "deu" then code = "de"
    if code = "ita" then code = "it"
    if code = "jpn" then code = "ja"
    if code = "kor" then code = "ko"
    if left(code,3) = "en-" then code = "en"
    if left(code,3) = "pt-" then code = "pt"
    if code <> "" and code <> "es" and code <> "spa" and left(code,3) <> "es-"
        if CreateObject("roRegex","^[a-z]{2,3}$","").isMatch(code) then return code
    end if
    if code = "es-es" then return "castellano"
    for each region in ["419","mx","ar","bo","cl","co","cr","cu","do","ec","sv","gt","hn","ni","pa","py","pe","pr","uy","ve","us"]
        if code = "es-"+region then return "latino"
    end for
    if instr(1,name,"latino") > 0 or instr(1,name,"latam") > 0 or instr(1,name,"latin american") > 0 then return "latino"
    if instr(1,name,"castellano") > 0 or instr(1,name,"españa") > 0 or instr(1,name,"spain") > 0 then return "castellano"
    if code = "es" or code = "spa" or left(code,3) = "es-" or instr(1,name,"español") > 0 or instr(1,name,"spanish") > 0 then return "spanish"
    if instr(1,name,"portugu") > 0 then return "pt"
    if instr(1,name,"english") > 0 or instr(1,name,"inglés") > 0 then return "en"
    if instr(1,name,"fran") > 0 or instr(1,name,"french") > 0 then return "fr"
    return ""
end function

function rpMediaLanguageLabel(code as dynamic) as string
    key = rpMediaText(code,20)
    if key = "latino" then return "Español latino"
    if key = "castellano" then return "Español de España"
    if key = "spanish" then return "Español (región no indicada)"
    if key = "system" then return "Automático del sistema"
    if key = "off" then return "Desactivados"
    if key = "en" or key = "eng" then return "Inglés"
    if key = "pt" or key = "por" then return "Portugués"
    if key = "fr" or key = "fra" then return "Francés"
    if key = "it" then return "Italiano"
    if key = "de" then return "Alemán"
    if key = "ja" then return "Japonés"
    if key = "ko" then return "Coreano"
    if key <> "" then return "Idioma: "+key
    return "Idioma no especificado"
end function

' A source-version override applies to this request, never to the registry.
function rpMediaAudioOverride(value as dynamic) as string
    code = lcase(rpMediaText(value,40))
    if code = "latino" or code = "castellano" or code = "spanish" or code = "system" then return code
    return rpMediaLanguageKey(code)
end function

function rpMediaDeclaredAudioMayMatch(tracks as dynamic, declared as dynamic, preference as dynamic) as boolean
    if type(tracks) <> "roArray" then return false
    if tracks.count() <> 1 then return false
    ' A known contradictory native track always wins over a provider label.
    if tracks[0].language <> "" and tracks[0].language <> "spanish" then return false
    key = rpMediaLanguageKey(declared)
    if key = "" then return false
    return key = preference
end function

function rpMediaTracks(raw as dynamic, subtitles = false as boolean) as object
    tracks = []
    if type(raw) <> "roArray" then return tracks
    seen = {}
    seen.setModeCaseSensitive()
    for each value in raw
        if type(value) = "roAssociativeArray"
            id = rpMediaText(value.Track,4096)
            name = rpMediaText(value.Name)
            if subtitles
                id = rpMediaText(value.TrackName,4096)
                name = rpMediaText(value.Description)
            end if
            if id <> "" and not seen.doesExist(id)
                language = rpMediaLanguageKey(value.Language,name)
                label = rpMediaLanguageLabel(language)
                if language = "" and name <> "" and instr(1,name,"://") = 0 then label = name+" · Idioma no especificado"
                tracks.push({id:id,language:language,label:label,descriptive:value.HasAccessibilityDescription = true})
                seen[id] = true
                if tracks.count() >= 64 then exit for
            end if
        end if
    end for
    ' Distinguish multiple tracks in one language without exposing track IDs.
    labelCounts = {}
    for each track in tracks
        if not labelCounts.doesExist(track.label) then labelCounts[track.label] = 0
        labelCounts[track.label]++
    end for
    for i = 0 to tracks.count()-1
        if labelCounts[tracks[i].label] > 1 then tracks[i].label += " · Pista "+(i+1).toStr()
        if tracks[i].descriptive then tracks[i].label += " · Audiodescripción"
    end for
    return tracks
end function

function rpMediaPreferredTrack(tracks as dynamic, preference as dynamic) as string
    if type(tracks) <> "roArray" then return ""
    if preference = "off" or preference = "system" then return ""
    descriptiveFallback = ""
    for each track in tracks
        if track.language = preference
            if not track.descriptive then return track.id
            if descriptiveFallback = "" then descriptiveFallback = track.id
        end if
    end for
    return descriptiveFallback
end function

' A saved position must be interior to a measured native duration. A different
' cut with a shorter duration starts normally rather than jumping near its end.
function rpMediaResumeDestination(saved as dynamic, duration as dynamic, position as dynamic) as dynamic
    for each value in [saved,duration,position]
        t = type(value)
        if t <> "Integer" and t <> "LongInteger" and t <> "Float" and t <> "Double" and t <> "roInt" and t <> "roFloat" and t <> "roDouble" and t <> "roLongInteger" then return invalid
        if value <> value or value < 0 or value > 172800 then return invalid
    end for
    if duration < 30 or saved < 10 or saved > duration-15 or position >= saved-2 then return invalid
    return saved
end function
