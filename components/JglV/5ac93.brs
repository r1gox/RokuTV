sub init()
    m.jglVStopped = false
    m.video       = m.top.FindNode("video")
    m.playerBg    = m.top.FindNode("playerBg")
    m.spinner     = m.top.FindNode("spinner")
    m.osd         = m.top.FindNode("osd")
    m.liveOsd     = m.top.FindNode("liveOsd")
    m.liveOsdLogo = m.top.FindNode("liveOsdLogo")
    m.liveOsdTitle = m.top.FindNode("liveOsdTitle")
    m.liveOsdCategory = m.top.FindNode("liveOsdCategory")
    m.liveStatus = m.top.FindNode("liveStatus")
    m.liveStatusLabel = m.top.FindNode("liveStatusLabel")
    m.osdTitle    = m.top.FindNode("osdTitle")
    m.osdProgram  = m.top.FindNode("osdProgram")
    m.osdLogo     = m.top.FindNode("osdLogo")
    m.osdCategory = m.top.FindNode("osdCategory")
    m.osdClock    = m.top.FindNode("osdClock")
    m.osdChNumber = m.top.FindNode("osdChNumber")
    m.liveBadge   = m.top.FindNode("liveBadge")
    m.liveBadgeLbl= m.top.FindNode("liveBadgeLbl")
    m.directoBadge= m.top.FindNode("directoBadge")
    m.directoLbl  = m.top.FindNode("directoLbl")
    m.progressFill= m.top.FindNode("progressFill")
    m.avInfo      = m.top.FindNode("avInfo")
    m.subGroup    = m.top.FindNode("subGroup")
    m.subLabel    = m.top.FindNode("subLabel")
    m.subShadow   = m.top.FindNode("subShadow")
    m.vodSubs     = []
    m.subTracks   = []
    m.subCues     = []
    m.subCache    = {}
    m.subLangIdx  = -1        ' -1 = apagado
    m.subCueIdx   = 0         ' cursor: última cue mostrada
    m.subOffset   = 2.0
    m.srtTask     = invalid
    m.slbTask    = invalid
    m.licTask    = invalid
    m.streamTask = invalid
    m.probeTask  = invalid
    m.proxyTask  = invalid
    m.slbData    = invalid
    m.liveAddr   = invalid
    m.streamHeaders = invalid
    m.lastDirectUrl = ""
    m.osdMode = "live"
    m.playGeneration = 0
    m.playStartedAt = 0
    m.previousVideoState = "none"
    m.liveGen = 0
    m.vodGen = 0
    m.vodPlaybackState = "PLAYBACK_CANCELLED"
    m.top.vodPlaybackState = m.vodPlaybackState
    m.acceptLiveVideoEvents = true
    m.video.enableUI = false
    m.video.enableTrickPlay = false
    m.clockTimer = CreateObject("roSGNode", "Timer")
    m.clockTimer.duration = 15
    m.clockTimer.repeat   = true
    m.clockTimer.ObserveField("fire", "UpdateClock")
    m.clockTimer.control  = "start"
    m.playingVod   = false
    m.vodUrls      = invalid
    m.vodUrlIdx    = 0
    m.slbDataVod   = invalid
    m.vodLicense   = invalid
    m.vodMediaCode = ""
    m.vodVariants = []
    m.vodVariantIdx = 0
    m.vodProbeAttempt = 0
    m.vodFallbackTimer = invalid
    m.vodIgnoreTerminal = false
    m.hardwareInfo = Hardware_Detect()
    m.video.ObserveField("state", "OnVideoState")
    m.video.ObserveField("position", "OnPosition")
    m.video.ObserveField("videoFormat", "OnVideoFormat")
    m.video.ObserveField("audioFormat", "OnAudioFormat")
    m.top.ObserveField("channelCode",  "OnChannelCodeSet")
    m.top.ObserveField("vodContentId", "OnVodContentSet")
    m.top.ObserveField("vodUrl",       "OnVodUrlSet")
    m.top.ObserveField("control",      "OnControlChanged")
    m.top.ObserveField("poke",         "OnPoke")
    m.top.ObserveField("transport",    "OnTransport")
    m.top.ObserveField("displayMode",  "OnDisplayMode")
    m.top.ObserveField("statusMessage", "OnStatusMessage")
    m.vodDuration = 0
end sub
sub OnStatusMessage(event as Object)
    if m.jglVStopped = true then return
    msg = SafeStr(event.GetData())
    m.liveStatusLabel.text = msg
    m.liveStatus.visible = (msg <> "" and m.top.displayMode = "fullscreen")
end sub
sub OnVideoFormat(event as Object)
    if m.jglVStopped = true then return
    raw = SafeStr(event.GetData())
    m.top.detectedVideoFormat = raw
    codec = Hardware_CodecLabel(raw)
    if codec <> "" then m.top.detectedVideoCodec = codec
end sub
sub OnAudioFormat(event as Object)
    if m.jglVStopped = true then return
    raw = SafeStr(event.GetData())
    if raw <> "" then m.top.detectedAudioFormat = raw
end sub
sub OnDisplayMode(event as Object)
    if m.jglVStopped = true then return
    mode = SafeStr(event.GetData())
    if mode = "embedded"
        m.playerBg.translation = [340, 150]
        m.playerBg.width = 1080
        m.playerBg.height = 608
        m.video.translation = [340, 150]
        m.video.width = 1080
        m.video.height = 608
        m.osd.visible = false
        m.liveOsd.visible = false
        m.liveStatus.visible = false
        m.spinner.translation = [850, 420]
    else
        m.playerBg.translation = [0, 0]
        m.playerBg.width = 1920
        m.playerBg.height = 1080
        m.video.translation = [0, 0]
        m.video.width = 1920
        m.video.height = 1080
        m.liveStatus.visible = (SafeStr(m.top.statusMessage) <> "")
        m.spinner.translation = [920, 490]
    end if
end sub
sub OnTransport(event as Object)
    if m.jglVStopped = true then return
    cmd = event.GetData()
    if cmd = "cyclesub"
        CycleSub()
    else if cmd = "playpause"
        if m.video.state = "paused"
            m.video.control = "resume"
            FlashAV("Reproduciendo")
        else
            m.video.control = "pause"
            FlashAV("Pausa")
        end if
    else if cmd = "seekfwd"
        SeekBy(15)
    else if cmd = "seekback"
        SeekBy(-15)
    else if cmd = "sublater"
        NudgeSub(0.5)
    else if cmd = "subearlier"
        NudgeSub(-0.5)
    end if
    ShowOSD()
end sub
sub NudgeSub(delta as Float)
    if m.jglVStopped = true then return
    m.subOffset = m.subOffset + delta
    RenderSubAt(CurPos())
    sign = "+"
    if m.subOffset < 0 then sign = ""
    FlashAV("Sub sync: " + sign + Str(m.subOffset).Trim() + "s")
end sub
sub SeekBy(secs as Integer)
    if m.jglVStopped = true then return
    posn = m.video.position
    if posn = invalid then posn = 0
    target = posn + secs
    if target < 0 then target = 0
    if m.vodDuration > 0 and target > m.vodDuration - 2 then target = m.vodDuration - 2
    m.video.seek = target
    FlashAV(Tern(secs > 0, "Avance +", "Retroceso -") + Abs(secs).ToStr() + "s")
end sub
sub OnVodContentSet(event as Object)
    if m.jglVStopped = true then return
    contentId = event.GetData()
    if contentId = "" then return
    m.vodGen = m.vodGen + 1
    SetVodPlaybackState("PLAYBACK_LOADING")
    ClearPlaybackError()
    m.acceptLiveVideoEvents = false
    m.osdMode = "vod"
    m.top.detectedVideoCodec = ""
    m.liveOsd.visible = false
    m.spinner.visible = true
    m.osdTitle.text    = m.top.channelName
    m.osdCategory.text = SafeStr(m.top.channelCategory)
    m.osdChNumber.text = ""
    m.osdLogo.uri       = SafeStr(m.top.channelLogo)
    m.liveBadge.visible = false
    m.liveBadgeLbl.visible = false
    m.directoBadge.visible = false
    m.directoLbl.visible = false
    m.progressFill.visible = false
    backHint = m.top.FindNode("backHint")
    if backHint <> invalid then backHint.text = "OK Pausa   <> Avanzar   Arriba Subtitulos   << >> Ajustar sync   Back Salir"
    m.vodUrls    = invalid
    m.slbDataVod = invalid
    m.vodLicense = invalid
    columnId = m.top.columnId
    if columnId = invalid then columnId = 87026
    seriesContentId = SafeStr(m.top.vodSeriesContentId)   ' "" = película; <serie> = episodio
    op = "playVod"
    args = { contentId: contentId, columnId: columnId }
    if IsValidStr(seriesContentId)
        op = "playVodEp"
        args.seriesContentId = seriesContentId
    end if
    slb = Api_OpTask("slbInfo", {})
    lic = Api_OpTask(op, args)
    if slb = invalid or lic = invalid
        m.top.state = "error"
        return
    end if
    slb.generation = m.vodGen
    lic.generation = m.vodGen
    if m.slbTask <> invalid then m.slbTask.control = "STOP"
    m.slbTask = slb
    m.slbTask.ObserveField("rawResp", "OnVodSlbResp")
    m.slbTask.ObserveField("error",   "OnVodStreamError")
    m.slbTask.control = "RUN"
    if m.licTask <> invalid then m.licTask.control = "STOP"
    m.licTask = lic
    m.licTask.ObserveField("rawResp", "OnVodLicResp")
    m.licTask.ObserveField("error",   "OnVodStreamError")
    m.licTask.control = "RUN"
end sub
sub OnVodSlbResp(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or data.cdn_list = invalid
        m.top.state = "error"
        return
    end if
    m.slbDataVod = data
    TryStartVod()
end sub
sub OnVodLicResp(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen then return
    lic = ExtractVodLicense(Api_ParseOp(event.GetData()))
    if lic = invalid
        m.top.state = "error"
        return
    end if
    m.vodVariants  = lic.variants
    m.vodLicense   = lic.variants
    m.vodSubs      = lic.subs        ' [{lang, url}] subtítulos .srt externos
    m.vodDuration  = lic.duration
    TryStartVod()
end sub
function ExtractVodLicense(data as Object) as Dynamic
    if data = invalid or data.episodeList = invalid or data.episodeList.Count() = 0 then return invalid
    ep = data.episodeList[0]
    if ep.totalMovieList = invalid or ep.totalMovieList.Count() = 0 then return invalid
    subs = []
    if ep.subtitleList <> invalid
        for each s in ep.subtitleList
            if s.file <> invalid and s.file.Count() > 0
                subs.Push({ lang: SafeStr(s.language), url: SafeStr(s.file[0].url) })
            end if
        end for
    end if
    variants = []
    seen = {}
    duration = 0
    for each tm in ep.totalMovieList
        if tm.movieList <> invalid
            for each mv in tm.movieList
                mediaCode = SafeStr(mv.contentId)
                license = ""
                if mv.licenseList <> invalid and mv.licenseList.Count() > 0
                    license = SafeStr(mv.licenseList[0].license)
                end if
                if mediaCode <> "" and license <> "" and seen[mediaCode] = invalid
                    seen[mediaCode] = true
                    codec = Hardware_CodecFromMetadata(mv)
                    if codec = "" then codec = Hardware_CodecFromMetadata(tm)
                    if codec = "" then codec = Hardware_CodecFromMetadata(ep)
                    itemDuration = VodDurationOf(mv, ep)
                    if duration = 0 and itemDuration > 0 then duration = itemDuration
                    variants.Push({ mediaCode: mediaCode, license: license, codec: codec, duration: itemDuration })
                end if
            end for
        end if
    end for
    if variants.Count() = 0 then return invalid
    return { variants: variants, subs: subs, duration: duration }
end function
function VodDurationOf(mv as Object, ep as Object) as Integer
    for each src in [mv, ep]
        for each k in ["duration", "timeLen", "totalTime", "time", "playTime", "length"]
            v = src[k]
            if v <> invalid
                n = Int(Val(SafeStr(v)))
                if n > 0 then return n
            end if
        end for
    end for
    return 0
end function
sub TryStartVod()
    if m.jglVStopped = true then return
    if m.slbDataVod = invalid or m.vodLicense = invalid then return
    k = v4a21()
    if k = invalid
        m.top.state = "error"
        return
    end if
    ca = invalid
    hosts = []
    for each entry in m.slbDataVod.cdn_list
        if entry.tag = "vod"
            if ca = invalid and entry.url_list <> invalid and entry.url_list.Count() > 0
                ca = entry.url_list[0].url
            end if
            if IsValidStr(entry.main_addr)
                hosts.Push(HostOf(entry.main_addr))
            end if
        end if
    end for
    if ca = invalid or hosts.Count() = 0
        m.top.state = "error"
        return
    end if
    playable = []
    for each variant in m.vodVariants
        urls = []
        format = ""
        for each host in hosts
            url = v4a28(k.vodUrl, { host: host, code: variant.mediaCode })
            if format = "" then format = StreamFormatForUrl(url)
            urls.Push(url)
        end for
        supported = Hardware_CodecSupported(m.hardwareInfo, SafeStr(variant.codec))
        if format <> "" and supported <> false
            playable.Push({ mediaCode: variant.mediaCode, codec: variant.codec, duration: variant.duration, urls: urls, headers: StreamHeaders(k, ca, variant.license), format: format })
        else if supported = false
        end if
    end for
    if playable.Count() = 0
        m.top.state = "error"
        return
    end if
    m.vodVariants = playable
    m.vodVariantIdx = 0
    m.vodUrlIdx = 0
    PlayVodUrl()
end sub
function StreamFormatForUrl(url as String) as String
    path = LCase(url)
    queryPos = Instr(1, path, "?")
    if queryPos > 0 then path = Left(path, queryPos - 1)
    if Right(path, 5) = ".m3u8" then return "hls"
    if Right(path, 4) = ".mp4" then return "mp4"
    if Right(path, 4) = ".mkv" then return "mkv"
    if Right(path, 4) = ".mpd" then return "dash"
    if Right(path, 3) = ".ts" then return "ts"
    return ""
end function
sub PlayVodUrl()
    if m.jglVStopped = true then return
    if m.vodVariants = invalid or m.vodVariantIdx < 0 or m.vodVariantIdx >= m.vodVariants.Count()
        m.top.state = "error"
        return
    end if
    variant = m.vodVariants[m.vodVariantIdx]
    m.vodUrls = variant.urls
    m.vodHeaders = variant.headers
    m.vodDuration = variant.duration
    if SafeStr(variant.codec) <> "" then m.top.detectedVideoCodec = SafeStr(variant.codec)
    if m.probeTask <> invalid then m.probeTask.control = "STOP"
    m.vodProbeAttempt = m.vodProbeAttempt + 1
    m.probeTask = createObject("roSGNode", "JglVProbeTask")
    m.probeTask.generation = m.vodGen
    m.probeTask.attempt = m.vodProbeAttempt
    m.probeTask.ObserveField("okUrl", "OnVodHostPicked")
    m.probeTask.urls    = m.vodUrls
    m.probeTask.headers = m.vodHeaders
    m.probeTask.control = "RUN"
end sub
sub OnVodHostPicked(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen or src.attempt <> m.vodProbeAttempt then return
    url = SafeStr(event.GetData())
    if url = ""
        m.top.state = "error"
        return
    end if
    m.vodUrlIdx = 0
    for i = 0 to m.vodUrls.Count() - 1
        if m.vodUrls[i] = url then m.vodUrlIdx = i
    end for
    m.spinner.visible = false
    m.playingVod = true
    PlayUrl(url, m.vodHeaders, false, m.vodVariants[m.vodVariantIdx].format)
end sub
sub PlayVodUrlAt(idx as Integer)
    if m.jglVStopped = true then return
    if m.vodUrls = invalid or idx < 0 or idx >= m.vodUrls.Count()
        m.top.state = "error"
        return
    end if
    m.playingVod = true
    PlayUrl(m.vodUrls[idx], m.vodHeaders, false, m.vodVariants[m.vodVariantIdx].format)
end sub
function TryNextVodVariant(reason as String) as Boolean
    nextIdx = m.vodVariantIdx + 1
    if m.vodVariants = invalid then return false
    if nextIdx >= m.vodVariants.Count() then return false
    m.vodVariantIdx = nextIdx
    m.vodUrlIdx = 0
    m.vodIgnoreTerminal = true
    m.playingVod = false
    SetVodPlaybackState("PLAYBACK_LOADING")
    m.spinner.visible = true
    if m.vodFallbackTimer <> invalid then m.vodFallbackTimer.control = "stop"
    m.vodFallbackTimer = CreateObject("roSGNode", "Timer")
    m.vodFallbackTimer.duration = 0.25
    m.vodFallbackTimer.repeat = false
    m.vodFallbackTimer.ObserveField("fire", "OnVodFallbackTimer")
    m.vodFallbackTimer.control = "start"
    return true
end function
sub OnVodFallbackTimer(event as Object)
    if m.jglVStopped = true then return
    if m.vodFallbackTimer <> invalid then m.vodFallbackTimer.control = "stop"
    m.vodFallbackTimer = invalid
    PlayVodUrl()
end sub
function LangName(code as String) as String
    c = LCase(code)
    if c = "es" or c = "spa" then return "Español"
    if c = "en" or c = "eng" then return "English"
    if c = "pt" or c = "por" then return "Português"
    if c = "fr" or c = "fra" then return "Français"
    if c = "" then return "Idioma"
    return UCase(code)
end function
sub OnChannelCodeSet(event as Object)
    if m.jglVStopped = true then return
    channelCode = event.GetData()
    if channelCode = "" then return
    m.liveGen = m.top.requestGeneration
    m.vodGen = m.vodGen + 1
    if m.probeTask <> invalid
        m.probeTask.control = "STOP"
        m.probeTask = invalid
    end if
    if m.vodFallbackTimer <> invalid
        m.vodFallbackTimer.control = "stop"
        m.vodFallbackTimer = invalid
    end if
    m.acceptLiveVideoEvents = false
    m.video.control = "stop"
    m.video.content = invalid
    m.playGeneration = m.playGeneration + 1
    m.playStartedAt = CreateObject("roDateTime").AsSeconds()
    m.osdMode = "live"
    m.osd.visible = false
    m.spinner.visible = true
    m.liveOsdTitle.text = m.top.channelName
    m.liveOsdCategory.text = SafeStr(m.top.channelCategory)
    m.liveOsdLogo.uri = SafeStr(m.top.channelLogo)
    m.osdTitle.text    = m.top.channelName
    m.osdCategory.text = SafeStr(m.top.channelCategory)
    m.osdChNumber.text = "Canal " + SafeStr(m.top.channelNumber)
    m.osdLogo.uri       = SafeStr(m.top.channelLogo)
    m.liveBadge.visible = true
    m.liveBadgeLbl.visible = true
    m.directoBadge.visible = true
    m.directoLbl.visible = true
    m.progressFill.visible = true
    m.slbData  = invalid
    m.liveAddr = invalid
    columnId = m.top.columnId
    if columnId = invalid then columnId = 76182
    slb = Api_OpTask("slbInfo", {})
    lic = Api_OpTask("startPlayLive", { channelCode: channelCode, columnId: columnId })
    if slb = invalid or lic = invalid
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    slb.generation = m.liveGen
    lic.generation = m.liveGen
    if m.slbTask <> invalid then m.slbTask.control = "STOP"
    m.slbTask = slb
    m.slbTask.ObserveField("rawResp", "OnSlbResp")
    m.slbTask.ObserveField("error",   "OnStreamError")
    m.slbTask.control = "RUN"
    if m.licTask <> invalid then m.licTask.control = "STOP"
    m.licTask = lic
    m.licTask.ObserveField("rawResp", "OnLicResp")
    m.licTask.ObserveField("error",   "OnStreamError")
    m.licTask.control = "RUN"
end sub
function IsFormatError() as Boolean
    msg = LCase(SafeStr(m.video.errorMsg))
    if Instr(1, msg, "unsupported") > 0 then return true
    if Instr(1, msg, "format") > 0 then return true
    return false
end function
sub OnStreamError(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    m.spinner.visible = false
    m.top.stateGeneration = m.liveGen
    m.top.state = "error"
end sub
sub OnVodStreamError(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid or src.generation <> m.vodGen then return
    m.spinner.visible = false
    m.playingVod = false
    m.top.state = "error"
end sub
sub OnSlbResp(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or data.cdn_list = invalid
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    m.slbData = data
    TryStartPlayback()
end sub
sub OnLicResp(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or data.liveAddressList = invalid or data.liveAddressList.Count() = 0
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    m.liveAddr = data.liveAddressList[0]
    TryStartPlayback()
end sub
sub TryStartPlayback()
    if m.jglVStopped = true then return
    if m.slbData = invalid or m.liveAddr = invalid then return
    r = BuildStreamRequest(m.slbData, m.liveAddr)
    m.spinner.visible = false
    if r = invalid
        m.top.stateGeneration = m.liveGen
        m.top.state = "error"
        return
    end if
    StartLive(r.url, r.headers)
end sub
sub StartLive(url as String, headers as Object)
    if m.jglVStopped = true then return
    m.lastDirectUrl = url
    m.streamHeaders = headers
    if m.proxyTask <> invalid then m.proxyTask.control = "STOP"
    m.proxyTask = createObject("roSGNode", "JglVManifestProxy")
    m.proxyTask.generation = m.liveGen
    m.proxyTask.ObserveField("ready", "OnProxyReady")
    m.proxyTask.ObserveField("error", "OnProxyError")
    m.proxyTask.srcUrl  = url
    m.proxyTask.headers = headers
    m.proxyTask.control = "RUN"
end sub
sub OnProxyReady(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    if event.GetData() <> true then return
    url = "http://127.0.0.1:" + PROXY_PORT().ToStr() + "/live.m3u8"
    PlayUrl(url, m.streamHeaders)
end sub
sub OnProxyError(event as Object)
    if m.jglVStopped = true then return
    src = event.GetRoSGNode()
    if src = invalid then return
    if src.generation <> m.liveGen then return
    if m.lastDirectUrl <> invalid and m.lastDirectUrl <> ""
        PlayUrl(m.lastDirectUrl, m.streamHeaders)
    end if
end sub
function BuildStreamRequest(slbData as Object, liveAddr as Object) as Dynamic
    k = v4a21()
    if k = invalid or slbData.cdn_list = invalid then return invalid
    chosen = invalid
    for each entry in slbData.cdn_list
        if entry.tag = "live" and entry.cdn_type = "4" and IsValidStr(entry.main_addr)
            chosen = entry
            exit for
        end if
    end for
    if chosen = invalid then return invalid
    if chosen.url_list = invalid or chosen.url_list.Count() = 0 then return invalid
    mediaCode = SafeStr(liveAddr.playCode)
    if mediaCode = "" then return invalid
    return {
        url:     v4a28(k.liveUrl, { host: HostOf(chosen.main_addr), code: mediaCode }),
        headers: StreamHeaders(k, chosen.url_list[0].url, SafeStr(liveAddr.license))
    }
end function
function StreamHeaders(k as Object, contentAuth as String, license as String) as Object
    h = {}
    if k.streamHeaders <> invalid
        for each name in k.streamHeaders
            h[name] = k.streamHeaders[name]
        end for
    end if
    h["Content-Auth"]    = contentAuth
    h["Content-License"] = license
    return h
end function
function HostOf(mainAddr as String) as String
    h = mainAddr.Replace("https://", "").Replace("http://", "")
    sp = Instr(1, h, "/")
    if sp > 0 then h = Left(h, sp - 1)
    return h
end function
sub OnVodUrlSet(event as Object)
    if m.jglVStopped = true then return
    url = event.GetData()
    if url = "" or url = invalid then return
    m.vodGen = m.vodGen + 1
    SetVodPlaybackState("PLAYBACK_LOADING")
    ClearPlaybackError()
    m.osdMode = "vod"
    m.liveOsd.visible = false
    m.osdTitle.text = m.top.vodTitle
    m.osdCategory.text = ""
    m.osdChNumber.text = ""
    m.liveBadge.visible = false
    m.liveBadgeLbl.visible = false
    PlayUrl(url, invalid, false)
end sub
sub PlayUrl(url as String, headers = invalid as Dynamic, isLive = true as Boolean, fmt = "hls" as String)
    if m.jglVStopped = true then return
    if m.video.state = "error" or m.video.state = "finished"
        m.video.control = "stop"
    end if
    if headers <> invalid
        agent = CreateObject("roHttpAgent")
        agent.SetHeaders(headers)
        m.video.SetHttpAgent(agent)
    end if
    content = CreateObject("roSGNode", "ContentNode")
    content.url          = url
    content.streamformat = fmt      ' "hls" para live, "ts" para el _media.ts de VOD
    content.live = isLive
    if isLive
        content.playStart = 0
        m.video.enableTrickPlay = false
    else
        m.video.enableTrickPlay = true
        m.video.notificationInterval = 0.1
        if m.vodDuration > 0 then content.length = m.vodDuration
    end if
    if not isLive then SubOff()
    m.subLangIdx = -1      ' -1 = subtítulos apagados
    m.audioIdx = 0
    if not isLive and m.vodDuration > 0
        m.progressFill.width = 0
        m.progressFill.visible = true
    end if
    if isLive then m.acceptLiveVideoEvents = true
    m.video.content = content
    m.video.control = "play"
    ShowOSD()
end sub
sub CycleSub()
    if m.jglVStopped = true then return
    n = 0
    if m.vodSubs <> invalid then n = m.vodSubs.Count()
    if n = 0
        FlashAV("Sin subtítulos")
        return
    end if
    m.subLangIdx = m.subLangIdx + 1
    if m.subLangIdx >= n
        m.subLangIdx = -1
        SubOff()
        FlashAV("Subtítulos: Off")
    else
        sub_ = m.vodSubs[m.subLangIdx]
        lang = SafeStr(sub_.lang)
        FlashAV("Subtítulos: " + LangName(lang))
        LoadSub(SafeStr(sub_.url))
    end if
end sub
sub SubOff()
    if m.jglVStopped = true then return
    m.subCues = []
    m.subCueIdx = 0
    m.subLabel.text = ""
    m.subShadow.text = ""
    m.subGroup.visible = false
end sub
sub LoadSub(url as String)
    if m.jglVStopped = true then return
    if url = "" then return
    m.subCueIdx = 0
    m.subLabel.text = ""
    m.subShadow.text = ""
    cached = m.subCache[url]
    if cached <> invalid
        m.subCues = cached
        m.subGroup.visible = true
        RenderSubAt(CurPos())
        return
    end if
    m.subPendingUrl = url
    m.srtTask = CreateObject("roSGNode", "JglVSrtTask")
    m.srtTask.ObserveField("cues", "OnSrtParsed")
    m.srtTask.url = url
    m.srtTask.control = "RUN"
end sub
sub OnSrtParsed(event as Object)
    if m.jglVStopped = true then return
    cues = event.GetData()
    if cues = invalid then cues = []
    if m.subPendingUrl <> invalid then m.subCache[m.subPendingUrl] = cues
    m.subCues = cues
    m.subCueIdx = 0
    if cues.Count() = 0
        FlashAV("Subtítulo vacío")
        m.subGroup.visible = false
        return
    end if
    m.subGroup.visible = true
    RenderSubAt(CurPos())
end sub
function CurPos() as Integer
    p = m.video.position
    if p = invalid then return 0
    return p
end function
sub RenderSubAt(posn as Integer)
    if m.jglVStopped = true then return
    if m.subLangIdx < 0 or m.subCues.Count() = 0 then return
    look = posn - m.subOffset
    if look < 0 then look = 0
    if m.subCueIdx >= m.subCues.Count() then m.subCueIdx = 0
    if m.subCues[m.subCueIdx].s > look then m.subCueIdx = 0
    txt = ""
    i = m.subCueIdx
    while i < m.subCues.Count()
        c = m.subCues[i]
        if look < c.s
            exit while
        else if look <= c.e
            txt = c.t
            m.subCueIdx = i
            exit while
        end if
        i = i + 1
    end while
    if m.subLabel.text <> txt
        m.subLabel.text = txt
        m.subShadow.text = txt
    end if
end sub
sub FlashAV(msg as String)
    if m.jglVStopped = true then return
    m.avInfo.text = msg
    m.avInfo.visible = true
    ShowOSD()
    m.avTimer = CreateObject("roSGNode", "Timer")
    m.avTimer.duration = 3
    m.avTimer.repeat = false
    m.avTimer.ObserveField("fire", "HideAV")
    m.avTimer.control = "start"
end sub
sub HideAV(event as Object)
    if m.jglVStopped = true then return
    m.avInfo.visible = false
end sub
sub ShowOSD()
    if m.jglVStopped = true then return
    if m.top.displayMode = "embedded"
        m.osd.visible = false
        m.liveOsd.visible = false
        return
    end if
    if m.osdMode = "live"
        m.osd.visible = false
        m.liveOsd.visible = true
    else
        m.liveOsd.visible = false
        m.osd.visible = true
        UpdateClock(invalid)
    end if
    if m.osdTimer <> invalid then m.osdTimer.control = "stop"
    m.osdTimer = CreateObject("roSGNode", "Timer")
    m.osdTimer.duration = 4
    m.osdTimer.repeat   = false
    m.osdTimer.ObserveField("fire", "HideOSD")
    m.osdTimer.control  = "start"
end sub
sub UpdateClock(event as Object)
    if m.jglVStopped = true then return
    t = CreateObject("roDateTime")
    t.ToLocalTime()
    m.osdClock.text = Right("0" + t.GetHours().ToStr(), 2) + ":" + Right("0" + t.GetMinutes().ToStr(), 2)
end sub
sub HideOSD(event as Object)
    if m.jglVStopped = true then return
    m.osd.visible = false
    m.liveOsd.visible = false
end sub
sub OnVideoState(event as Object)
    if m.jglVStopped = true then return
    state = event.GetData()
    if m.osdMode = "live" and not m.acceptLiveVideoEvents then return
    elapsed = 0
    if m.playStartedAt > 0 then elapsed = CreateObject("roDateTime").AsSeconds() - m.playStartedAt
    opLabel = "LIVE"
    opGen = m.liveGen
    if m.osdMode = "vod"
        opLabel = "VOD"
        opGen = m.vodGen
    end if
    m.previousVideoState = state
    if m.osdMode = "vod" and m.vodIgnoreTerminal
        if state = "error" or state = "finished" or state = "stopped" or state = "closed"
            return
        end if
    end if
    if m.osdMode = "vod" and (state = "buffering" or state = "playing") then m.vodIgnoreTerminal = false
    if m.osdMode = "vod" and m.vodPlaybackState = "PLAYBACK_FAILED"
        if state = "finished" or state = "stopped" or state = "closed"
            return
        end if
    end if
    if state = "error" and m.playingVod = true and IsFormatError()
        CapturePlaybackError()
        m.playingVod = false
        if TryNextVodVariant("format") then return
        SetVodPlaybackState("PLAYBACK_FAILED")
        m.top.state = "nocodec"
        return
    end if
    if state = "error" and m.playingVod = true and m.vodUrls <> invalid
        m.vodUrlIdx = m.vodUrlIdx + 1
        if m.vodUrlIdx < m.vodUrls.Count()
            m.spinner.visible = true
            PlayVodUrlAt(m.vodUrlIdx)
            return
        end if
        if TryNextVodVariant("hosts_agotados") then return
    end if
    if state = "playing" or state = "error" or state = "closed" then m.playingVod = false
    if m.osdMode = "vod"
        if state = "playing"
            SetVodPlaybackState("PLAYBACK_PLAYING")
        else if state = "error"
            CapturePlaybackError()
            SetVodPlaybackState("PLAYBACK_FAILED")
        else if state = "finished"
            SetVodPlaybackState("PLAYBACK_FINISHED")
        end if
    end if
    if state = "playing"
        at = m.video.availableAudioTracks
        st = m.video.availableSubtitleTracks
        na = 0 : ns = 0
        if at <> invalid then na = at.Count()
        if st <> invalid then ns = st.Count()
        if at <> invalid
            for each t in at
            end for
        end if
        if st <> invalid
            for each t in st
            end for
        end if
    end if
    m.top.stateGeneration = m.liveGen
    m.top.state = state
    if state = "playing"
        m.spinner.visible = false
    else if state = "buffering"
        m.spinner.visible = true
    end if
end sub
sub OnPosition(event as Object)
    if m.jglVStopped = true then return
    posn = event.GetData()
    if posn = invalid then posn = 0
    RenderSubAt(posn)
    if m.vodDuration = invalid or m.vodDuration <= 0 then return
    if not m.osd.visible then return
    frac = posn / m.vodDuration
    if frac < 0 then frac = 0
    if frac > 1 then frac = 1
    m.progressFill.width = Int(1500 * frac)
    m.osdProgram.text = FmtTime(posn) + " / " + FmtTime(m.vodDuration)
end sub
function FmtTime(s as Integer) as String
    if s < 0 then s = 0
    h = s \ 3600
    mn = (s mod 3600) \ 60
    sec = s mod 60
    ss = Right("0" + sec.ToStr(), 2)
    if h > 0
        return h.ToStr() + ":" + Right("0" + mn.ToStr(), 2) + ":" + ss
    end if
    return mn.ToStr() + ":" + ss
end function
sub OnControlChanged(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() = "stop"
        m.vodGen = m.vodGen + 1
        m.liveGen = m.liveGen + 1
        m.acceptLiveVideoEvents = false
        if m.vodPlaybackState <> "PLAYBACK_FAILED" then SetVodPlaybackState("PLAYBACK_CANCELLED")
        if m.slbTask <> invalid then m.slbTask.control = "STOP"
        if m.licTask <> invalid then m.licTask.control = "STOP"
        if m.probeTask <> invalid then m.probeTask.control = "STOP"
        if m.vodFallbackTimer <> invalid then m.vodFallbackTimer.control = "stop"
        m.slbTask = invalid
        m.licTask = invalid
        m.probeTask = invalid
        m.vodFallbackTimer = invalid
        m.vodIgnoreTerminal = false
        m.video.control = "stop"
        m.video.content = invalid
        SubOff()
        m.subLangIdx = -1
        if m.proxyTask <> invalid
            m.proxyTask.control = "STOP"
            m.proxyTask = invalid
        end if
    end if
end sub
sub SetVodPlaybackState(value as String)
    if m.jglVStopped = true then return
    m.vodPlaybackState = value
    m.top.vodPlaybackState = value
end sub
sub ClearPlaybackError()
    if m.jglVStopped = true then return
    m.top.lastErrorCode = 0
    m.top.lastErrorMessage = ""
    m.top.lastErrorDetail = ""
end sub
sub CapturePlaybackError()
    if m.jglVStopped = true then return
    m.top.lastErrorCode = m.video.errorCode
    m.top.lastErrorMessage = SafeStr(m.video.errorMsg)
    detail = ""
    if m.video.HasField("errorStr") then detail = SafeStr(m.video.GetField("errorStr"))
    if detail = "" and m.video.HasField("errorInfo") then detail = SafeStr(m.video.GetField("errorInfo"))
    m.top.lastErrorDetail = detail
end sub
sub OnPoke(event as Object)
    if m.jglVStopped = true then return
    ShowOSD()
end sub
