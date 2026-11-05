' Original RokuPlus player. The source URL is never included in diagnostics.
sub init()
    m.top.focusable = true
    m.top.visible = false
    m.decoder = m.top.findNode("decoder")
    m.previewMask = m.top.findNode("previewMask")
    m.backdrop = m.top.findNode("backdrop")
    m.panel = m.top.findNode("transport")
    m.capsule = m.top.findNode("capsule")
    m.titleShade = m.top.findNode("titleShade")
    m.centerSurface = m.top.findNode("centerSurface")
    m.titleText = m.top.findNode("titleText")
    m.clockText = m.top.findNode("clockText")
    m.modeText = m.top.findNode("modeText")
    m.durationText = m.top.findNode("durationText")
    m.pauseText = m.top.findNode("pauseText")
    m.keyText = m.top.findNode("keyText")
    m.noticeText = m.top.findNode("noticeText")
    m.track = m.top.findNode("timeTrack")
    m.fill = m.top.findNode("timeFill")
    m.thumb = m.top.findNode("timeThumb")
    m.playGlyph = m.top.findNode("playGlyph")
    m.pauseGlyph = m.top.findNode("pauseGlyph")
    m.rewindControl = m.top.findNode("rewindControl")
    m.forwardControl = m.top.findNode("forwardControl")
    m.rewindSurface = m.top.findNode("rewindSurface")
    m.forwardSurface = m.top.findNode("forwardSurface")
    m.mediaMenu = m.top.findNode("mediaMenu")
    m.mediaMenuTitle = m.top.findNode("mediaMenuTitle")
    m.mediaMenuHint = m.top.findNode("mediaMenuHint")
    m.mediaMenuRows = m.top.findNode("mediaMenuRows")
    m.mediaSheet = m.top.findNode("mediaSheet")
    m.mediaMenuOpen = false
    m.mediaMenuView = "main"
    m.mediaMenuCursor = 0
    m.mediaOptions = []
    m.audioManual = false
    m.subtitleManual = false
    m.audioGatePending = false
    m.audioGateShown = false
    m.requestAudioPreference = ""
    m.requestLanguageConfirmed = false
    m.captionModeBeforePlayback = invalid
    m.preferenceUpdating = true
    languagePrefs = rpMediaLoadPreferences()
    m.appliedMediaPreferences = languagePrefs
    m.top.audioPreference = languagePrefs.audio
    m.top.subtitlePreference = languagePrefs.subtitles
    m.preferenceUpdating = false
    m.pulse = m.top.findNode("uiPulse")
    m.decoder.observeField("state", "onDecoderState")
    m.decoder.observeField("position", "onNativePosition")
    m.decoder.observeField("positionInfo", "onRenderedPosition")
    m.decoder.observeField("bufferingStatus", "onBufferDetails")
    m.decoder.observeField("availableAudioTracks", "onMediaTracksChanged")
    m.decoder.observeField("availableSubtitleTracks", "onMediaTracksChanged")
    m.decoder.observeField("currentAudioTrack", "onMediaTrackSelectionChanged")
    m.decoder.observeField("currentSubtitleTrack", "onMediaTrackSelectionChanged")
    if m.decoder.hasField("seamlessAudioTrackSelection") then m.decoder.seamlessAudioTrackSelection = true
    m.pulse.observeField("fire", "onPulse")
    m.monotonic = CreateObject("roTimespan")
    m.monotonic.mark()
    m.generation = 0
    m.mediaOpen = false
    m.closing = false
    m.alreadyClosed = true
    m.current = invalid
    m.ticket = invalid
    m.pendingSeek = invalid
    m.actionUntil = 0
    m.actionDirection = ""
    m.sequence = 0
    m.firstNative = invalid
    m.firstRendered = invalid
    m.lastBuffer = invalid
    m.watch = invalid
    applyPlayerTheme()
end sub

function playerSurfaceUri(name as string) as string
    prefix = "pkg:/images/newplayer-"
    if m.top.theme = "classic" then prefix += "classic-"
    return prefix + name + ".png"
end function

' Changing material must not change decoder state, transport visibility, or
' focus. Callbacks before init are harmless; init reapplies once nodes exist.
sub applyPlayerTheme()
    if m.capsule <> invalid then m.capsule.uri = playerSurfaceUri("capsule")
    if m.titleShade <> invalid then m.titleShade.uri = playerSurfaceUri("title-shade")
    if m.centerSurface <> invalid then m.centerSurface.uri = playerSurfaceUri("control-focus")
    if m.previewMask <> invalid
        m.previewMask.uri = "pkg:/images/ui/live-preview-mask.png"
        if m.top.theme = "classic" then m.previewMask.uri = "pkg:/images/ui/live-preview-mask-classic.png"
    end if
    if m.mediaSheet <> invalid
        m.mediaSheet.uri = "pkg:/images/ui/glass-section.png"
        if m.top.theme = "classic" then m.mediaSheet.uri = "pkg:/images/ui/glass-section-classic.png"
    end if
    applyControlSurfaces()
end sub

sub applyControlSurfaces()
    if m.rewindSurface = invalid or m.forwardSurface = invalid then return
    m.rewindSurface.uri = playerSurfaceUri("control")
    m.forwardSurface.uri = playerSurfaceUri("control")
    if m.monotonic = invalid or m.actionUntil = invalid then return
    if m.monotonic.totalMilliseconds() < m.actionUntil
        if m.actionDirection = "left" then m.rewindSurface.uri = playerSurfaceUri("control-pressed")
        if m.actionDirection = "right" then m.forwardSurface.uri = playerSurfaceUri("control-pressed")
    end if
end sub

sub onActiveChanged()
    if m.closing then return
    if not m.top.active
        closePlayback()
    else if m.mediaOpen
        m.top.visible = true
        applyPresentation()
    end if
end sub

sub onPresentationChanged()
    applyPresentation()
end sub

sub onPreviewRectChanged()
    applyPresentation()
end sub

function isPreviewPresentation() as boolean
    return m.top.presentation = "preview"
end function

' Presentation changes only geometry and overlays. Keep the same native Video
' and ContentNode so opening/closing fullscreen does not reload a live stream.
sub applyPresentation()
    if m.decoder = invalid or m.panel = invalid or m.backdrop = invalid then return
    preview = isPreviewPresentation()
    m.top.focusable = not preview
    m.backdrop.visible = not preview
    if preview
        closeMediaMenu(false)
        rect = plusPreviewBounds(m.top.previewRect)
        m.decoder.translation = [rect[0],rect[1]]
        m.decoder.width = rect[2]
        m.decoder.height = rect[3]
        m.panel.visible = false
        if m.top.hasFocus() then m.top.setFocus(false)
    else
        m.decoder.translation = [0,0]
        m.decoder.width = 1920
        m.decoder.height = 1080
        if m.mediaOpen
            revealTransport()
            m.top.setFocus(true)
        end if
    end if
    if m.previewMask <> invalid
        m.previewMask.translation = m.decoder.translation
        m.previewMask.width = m.decoder.width
        m.previewMask.height = m.decoder.height
        m.previewMask.visible = preview and m.mediaOpen
    end if
    m.decoder.visible = false
    if m.mediaOpen
        m.top.visible = true
        m.decoder.visible = not m.failed
        publishProgress(true)
    end if
end sub

' Bounds are in the scene's 1920x1080 design coordinates, independent of the
' panel's physical resolution. Malformed rectangles fall back to the live card.
function plusPreviewBounds(value as dynamic) as object
    fallback = [294,206,1016,572]
    if GetInterface(value,"ifArray") = invalid then return fallback
    if value.count() <> 4 then return fallback
    for each coordinate in value
        if not plusNativeNumeric(coordinate) then return fallback
        if coordinate <> coordinate then return fallback
        if coordinate < 0 or coordinate > 1920 then return fallback
    end for
    if value[2] <= 0 or value[3] <= 0 then return fallback
    if value[0]+value[2] > 1920 or value[1]+value[3] > 1080 then return fallback
    return [value[0],value[1],value[2],value[3]]
end function

sub openRequest()
    supplied = m.top.request
    if type(supplied) <> "roAssociativeArray" then return
    if GetInterface(supplied.url, "ifString") = invalid then return
    if len(supplied.url) = 0 then return
    closeMediaMenu(false)
    restoreCaptionMode()
    ' Stop the preceding decoder without emitting a close for the new request.
    m.mediaOpen = false
    m.pulse.control = "stop"
    m.decoder.visible = false
    m.decoder.control = "stop"
    m.decoder.content = invalid
    m.generation++
    m.monotonic.mark()
    m.current = supplied
    m.requestAudioPreference = rpMediaAudioOverride(supplied.audioPreference)
    m.requestLanguageConfirmed = supplied.languageConfirmed = true
    languagePrefs = rpMediaLoadPreferences()
    m.appliedMediaPreferences = languagePrefs
    m.preferenceUpdating = true
    m.top.audioPreference = languagePrefs.audio
    m.top.subtitlePreference = languagePrefs.subtitles
    m.preferenceUpdating = false
    m.audioManual = false
    m.subtitleManual = false
    m.audioGatePending = false
    m.audioGateShown = false
    m.audioPolicyApplied = false
    m.audioGatePriorPaused = false
    m.trackWarningShown = false
    m.resumePending = plusClockValue(supplied.resumePosition)
    m.resumeChecked = false
    m.ticket = invalid
    m.pendingSeek = invalid
    m.actionUntil = 0
    m.actionDirection = ""
    m.lastBuffer = invalid
    m.firstNative = invalid
    m.firstRendered = invalid
    m.failed = false
    m.closing = false
    m.alreadyClosed = false
    m.live = supplied.kind = "live"
    m.wantPaused = supplied.startPaused = true
    m.panelUntil = 6000
    m.noticeUntil = 0
    m.notice = ""
    m.bufferSince = 0
    m.watch = plusWatchdogCreate(0)
    m.lastProgressAt = -1000
    m.phase = "opening"
    m.titleText.text = "Reproducción"
    if GetInterface(supplied.title, "ifString") <> invalid then m.titleText.text = left(supplied.title, 130)
    format = "mp4"
    if GetInterface(supplied.streamFormat, "ifString") <> invalid then format = lcase(supplied.streamFormat)
    if format = "mpegts" then format = "ts"
    if format = "m3u8" then format = "hls"
    media = CreateObject("roSGNode", "ContentNode")
    media.url = supplied.url
    media.title = m.titleText.text
    media.streamFormat = format
    media.live = m.live
    media.httpCertificatesFile = "common:/certs/ca-bundle.crt"
    media.httpHeaders = ["User-Agent: RokuPlus/1.0"]
    ' Additional subtitle metadata has already passed the catalog URL boundary.
    ' Never synthesize a language or a track that the source did not provide.
    if type(supplied.subtitleTracks) = "roArray" then media.SubtitleTracks = supplied.subtitleTracks
    if type(supplied.mediaHeaders) = "roAssociativeArray"
        agent = supplied.mediaHeaders["User-Agent"]
        if GetInterface(agent, "ifString") <> invalid
            if len(agent) > 0 and len(agent) <= 512 and instr(1,agent,chr(13)) = 0 and instr(1,agent,chr(10)) = 0 then media.httpHeaders = ["User-Agent: " + agent]
        end if
        referer = supplied.mediaHeaders["Referer"]
        if GetInterface(referer, "ifString") <> invalid
            if len(referer) <= 2048 and instr(1,referer,chr(13)) = 0 and instr(1,referer,chr(10)) = 0
                if left(referer,7) = "http://" or left(referer,8) = "https://" then media.httpHeaders.push("Referer: " + referer)
            end if
        end if
    end if
    m.decoder.enableUI = false
    m.decoder.enableTrickPlay = false
    m.decoder.notificationInterval = 0.1
    m.decoder.autoplayAfterSeek = true
    m.accuracyMode = "unavailable"
    if m.decoder.hasField("seekMode")
        m.decoder.seekMode = "accurate"
        m.accuracyMode = m.decoder.seekMode
    end if
    m.decoder.audioTrack = ""
    m.decoder.subtitleTrack = ""
    m.decoder.content = media
    m.captionModeBeforePlayback = m.decoder.globalCaptionMode
    m.decoder.suppressCaptions = true
    if rpMediaNormalizePreference(m.top.subtitlePreference,true) <> "system" then m.decoder.globalCaptionMode = "Off"
    m.mediaOpen = true
    m.top.visible = true
    m.top.active = true
    applyPresentation()
    m.decoder.control = "play"
    m.pulse.control = "start"
    emitDiagnostic("open")
    drawTransport()
end sub

sub closePlayback()
    if m.closing then return
    if m.alreadyClosed
        m.top.visible = false
        if m.previewMask <> invalid then m.previewMask.visible = false
        return
    end if
    closedRequest = {generation:m.generation}
    if m.mediaOpen
        closedRequest.position = m.decoder.position
        closedRequest.duration = m.decoder.duration
        closedRequest.state = m.decoder.state
        if m.live then closedRequest.kind = "live" else closedRequest.kind = "movie"
        publishProgress(true)
    end if
    if type(m.current) = "roAssociativeArray"
        if GetInterface(m.current.itemId,"ifString") <> invalid then closedRequest.itemId = m.current.itemId
        if GetInterface(m.current.requestId,"ifString") <> invalid then closedRequest.requestId = m.current.requestId
        if GetInterface(m.current.kind,"ifString") <> invalid then closedRequest.kind = m.current.kind
    end if
    closeMediaMenu(false)
    restoreCaptionMode()
    m.closing = true
    emitDiagnostic("close")
    m.mediaOpen = false
    m.ticket = invalid
    m.pendingSeek = invalid
    m.resumePending = invalid
    m.audioGatePending = false
    m.watch = invalid
    m.panel.visible = false
    m.decoder.visible = false
    if m.previewMask <> invalid then m.previewMask.visible = false
    m.top.visible = false
    m.pulse.control = "stop"
    m.decoder.control = "stop"
    m.decoder.content = invalid
    m.current = invalid
    m.top.request = invalid
    m.top.active = false
    m.alreadyClosed = true
    m.closing = false
    m.top.closedRequest = closedRequest
    m.top.closed = true
end sub

sub onDecoderState()
    if not m.mediaOpen or m.closing then return
    m.phase = m.decoder.state
    if m.phase = "buffering"
        m.bufferSince = m.monotonic.totalMilliseconds()
        if m.ticket <> invalid then m.ticket.sawBuffering = true
        revealTransport()
    end if
    emitDiagnostic("state")
    if m.phase = "playing"
        applyResumePosition()
        m.bufferSince = invalid
        ' Desired pause is persistent across rebuffering. A user Play clears
        ' it before resume, so a source that already stays paused is safe too.
        if m.wantPaused
            m.decoder.control = "pause"
            return
        end if
        m.panelUntil = m.monotonic.totalMilliseconds() + 6000
    else if m.phase = "paused"
        m.bufferSince = invalid
        if not m.wantPaused
            m.decoder.control = "resume"
            return
        end if
        revealTransport()
    else if m.phase = "error"
        closeMediaMenu(false)
        m.failed = true
        m.ticket = invalid
        m.pendingSeek = invalid
        m.decoder.visible = false
        m.notice = "La fuente no respondió. OK para reintentar; Atrás para elegir otra."
        m.noticeUntil = 2147483647
        revealTransport()
    else if m.phase = "finished"
        ' Roku may follow a source error with finished. Keep the error/retry
        ' surface instead of treating that terminal event as a normal ending.
        if m.failed
            revealTransport()
        else
            closePlayback()
            return
        end if
    end if
    drawTransport()
    publishProgress(true)
end sub

sub onNativePosition()
    if not m.mediaOpen then return
    applyResumePosition()
    p = plusClockValue(m.decoder.position)
    if m.firstNative = invalid and p <> invalid
        m.firstNative = p
        emitDiagnostic("first_native_position")
    end if
    if m.ticket <> invalid then emitDiagnostic("position")
    verifySeekResult()
    publishProgress()
end sub

sub onRenderedPosition()
    if not m.mediaOpen then return
    sample = renderedFields()
    if m.firstRendered = invalid and sample.video <> invalid
        m.firstRendered = sample.video
        emitDiagnostic("first_rendered_position")
    end if
    if m.ticket <> invalid then emitDiagnostic("rendered")
    verifySeekResult()
end sub

sub onBufferDetails()
    if not m.mediaOpen then return
    info = m.decoder.bufferingStatus
    if type(info) = "roAssociativeArray"
        sample = {observedAtMs: m.monotonic.totalMilliseconds(), seekId: 0}
        if m.ticket <> invalid then sample.seekId = m.ticket.id
        for each field in ["percentage", "isUnderrun", "prebufferDone", "actualStart"]
            if info[field] <> invalid then sample[field] = info[field]
        end for
        m.lastBuffer = sample
        if m.ticket <> invalid
            actualStart = plusClockValue(info.actualStart)
            if actualStart <> invalid
                m.ticket.actualStart = actualStart
                m.ticket.actualStartAt = sample.observedAtMs
            end if
        end if
    end if
    emitDiagnostic("buffering_status")
end sub

sub publishProgress(force = false as boolean)
    now = m.monotonic.totalMilliseconds()
    if not force and now - m.lastProgressAt < 500 then return
    m.lastProgressAt = now
    state = m.decoder.state
    if m.phase = "opening" then state = "opening"
    presentation = "fullscreen"
    if isPreviewPresentation() then presentation = "preview"
    progress = {generation: m.generation, state: state, position: m.decoder.position, duration: m.decoder.duration, live: m.live, presentation: presentation, failed: m.failed, notice: m.notice}
    if type(m.current) = "roAssociativeArray"
        if GetInterface(m.current.itemId,"ifString") <> invalid then progress.itemId = m.current.itemId
        if GetInterface(m.current.provider,"ifString") <> invalid then progress.provider = m.current.provider
        if GetInterface(m.current.requestId,"ifString") <> invalid then progress.requestId = m.current.requestId
    end if
    m.top.progress = progress
end sub

sub revealTransport()
    if isPreviewPresentation()
        m.panel.visible = false
        return
    end if
    m.panel.visible = true
    m.panelUntil = m.monotonic.totalMilliseconds() + 6000
end sub

sub drawTransport()
    if not m.mediaOpen then return
    state = m.decoder.state
    mode = "Reproduciendo"
    if state = "paused" then mode = "En pausa"
    if state = "buffering" or state = "none" or state = "stopped" then mode = "Cargando"
    if m.ticket <> invalid or m.pendingSeek <> invalid then mode = "Buscando posición"
    if m.failed then mode = "No se pudo reproducir"
    clock = plusClockText(m.decoder.position)
    d = plusClockValue(m.decoder.duration)
    p = plusClockValue(m.decoder.position)
    ' Show the last requested destination while a command is queued; this is
    ' a preview only and is never substituted for the decoder's media clock.
    if m.pendingSeek <> invalid
        clock = plusClockText(m.pendingSeek.target)
    else if m.ticket <> invalid
        clock = plusClockText(m.ticket.target)
    end if
    showBar = false
    if d <> invalid and p <> invalid then showBar = d > 0
    m.track.visible = showBar and not m.live
    m.fill.visible = showBar and not m.live
    m.thumb.visible = showBar and not m.live
    if showBar
        fraction = p / d
        if fraction < 0 then fraction = 0
        if fraction > 1 then fraction = 1
        m.fill.width = fraction * 1260
        m.thumb.translation = [219 + fraction * 1260,28]
    end if
    if m.live then clock = "En vivo"
    m.modeText.text = mode
    if not m.failed then m.modeText.text += " · ↓ Audio y subtítulos"
    m.clockText.text = clock
    m.durationText.text = ""
    if showBar and not m.live then m.durationText.text = plusClockText(d)
    m.pauseText.text = "OK / Play · Pausar"
    if m.wantPaused then m.pauseText.text = "OK / Play · Reanudar"
    if m.failed then m.pauseText.text = "OK · Reintentar"
    m.playGlyph.visible = m.wantPaused or m.failed
    m.pauseGlyph.visible = not m.playGlyph.visible
    m.rewindControl.visible = not m.live
    m.forwardControl.visible = not m.live
    applyControlSurfaces()
    m.keyText.text = "Atrás · Volver al título"
    if m.live then m.keyText.text = "Atrás · Volver a los canales"
    m.noticeText.text = ""
    if m.monotonic.totalMilliseconds() < m.noticeUntil then m.noticeText.text = m.notice
end sub

sub onPulse()
    if not m.mediaOpen then return
    applyResumePosition()
    verifySeekResult()
    now = m.monotonic.totalMilliseconds()
    if m.ticket <> invalid
        if now - m.ticket.issuedAt >= 12000
            emitDiagnostic("seek_timeout")
            m.notice = "El destino no se confirmó. Puedes seguir reproduciendo o volver."
            m.noticeUntil = now + 6000
            m.ticket = invalid
            m.pendingSeek = invalid
        end if
    end if
    dispatchPendingSeek()
    if not m.failed and m.watch <> invalid
        sample = renderedFields()
        reason = plusWatchdogObserve(m.watch,m.decoder.state,m.decoder.position,sample.video,m.wantPaused,m.ticket <> invalid,now)
        if reason <> ""
            m.failed = true
            m.ticket = invalid
            m.pendingSeek = invalid
            m.decoder.visible = false
            m.notice = "La fuente dejó de avanzar. OK para reintentar; Atrás para elegir otra."
            if reason = "loading_timeout" then m.notice = "La fuente tardó demasiado. OK para reintentar; Atrás para elegir otra."
            m.noticeUntil = 2147483647
            revealTransport()
            emitDiagnostic(reason)
            publishProgress(true)
            m.decoder.control = "stop"
        end if
    end if
    if not m.failed and m.ticket = invalid and m.pendingSeek = invalid and m.decoder.state = "playing" and now >= m.panelUntil and m.mediaMenuOpen <> true then m.panel.visible = false
    drawTransport()
    publishProgress()
end sub

sub togglePause()
    if m.failed
        retry = {kind: m.current.kind}
        if m.current.itemId <> invalid then retry.itemId = m.current.itemId
        if GetInterface(m.current.requestId,"ifString") <> invalid then retry.requestId = m.current.requestId
        m.top.retryRequested = retry
        return
    end if
    ' Intent survives intermediate buffering / seek states. Reading only the
    ' current decoder state loses a quick second Play before pause completes.
    m.wantPaused = not m.wantPaused
    m.decoder.autoplayAfterSeek = not m.wantPaused
    if m.ticket <> invalid then m.ticket.paused = m.wantPaused
    if m.wantPaused and m.decoder.state = "playing" then m.decoder.control = "pause"
    if not m.wantPaused and m.decoder.state = "paused" then m.decoder.control = "resume"
    revealTransport()
    drawTransport()
end sub

sub shiftTen(backwards as boolean)
    revealTransport()
    if m.live
        m.notice = "Este canal está en vivo."
        m.noticeUntil = m.monotonic.totalMilliseconds() + 5000
        drawTransport()
        return
    end if
    state = m.decoder.state
    origin = plusClockValue(m.decoder.position)
    if m.failed then return
    ' During an outstanding seek a source normally buffers. Keep accepting
    ' remote intent there, but never start a seek during initial loading.
    if (state <> "playing" and state <> "paused" and m.ticket = invalid) or origin = invalid
        m.notice = "Espera a que termine de cargar."
        m.noticeUntil = m.monotonic.totalMilliseconds() + 5000
        drawTransport()
        return
    end if
    base = origin
    if m.ticket <> invalid then base = m.ticket.target
    if m.pendingSeek <> invalid then base = m.pendingSeek.target
    target = plusShiftDestination(base, m.decoder.duration, backwards)
    if target = invalid then return
    if abs(target - base) < 0.05 then return
    m.resumePending = invalid
    m.resumeChecked = true
    now = m.monotonic.totalMilliseconds()
    ' Collapse a short burst into one absolute destination and serialize it
    ' behind the decoder's existing request. No overlapping decoder.seek calls.
    m.pendingSeek = {target:target,dueAt:now+180}
    m.actionDirection = "right"
    if backwards then m.actionDirection = "left"
    m.actionUntil = now + 450
    m.notice = "Ir a " + plusClockText(target)
    m.noticeUntil = now + 6000
    drawTransport()
end sub

sub dispatchPendingSeek()
    if m.pendingSeek = invalid or m.ticket <> invalid or m.failed or not m.mediaOpen then return
    if m.monotonic.totalMilliseconds() < m.pendingSeek.dueAt then return
    state = m.decoder.state
    if state <> "playing" and state <> "paused" then return
    origin = plusClockValue(m.decoder.position)
    if origin = invalid then return
    target = m.pendingSeek.target
    m.pendingSeek = invalid
    if abs(target-origin) < 0.05 then return
    m.sequence++
    sample = renderedFields()
    v = plusClockValue(sample.video)
    verifyRendered = false
    if v <> invalid then verifyRendered = abs(v-origin) <= 2
    m.ticket = {id:m.sequence,origin:origin,target:target,paused:m.wantPaused,issuedPaused:state="paused",issuedAt:m.monotonic.totalMilliseconds(),sawBuffering:false,logs:0,verifyRendered:verifyRendered,landingAt:invalid,landingPosition:invalid,sawClockJump:false}
    m.decoder.autoplayAfterSeek = not m.wantPaused
    emitDiagnostic("seek_request")
    m.decoder.seek = target
    drawTransport()
end sub

sub verifySeekResult()
    if m.ticket = invalid or not m.mediaOpen then return
    now = m.monotonic.totalMilliseconds()
    if now - m.ticket.issuedAt < 200 then return
    state = m.decoder.state
    if state <> "playing" and state <> "paused" then return
    if m.wantPaused and state <> "paused" then return
    p = plusClockValue(m.decoder.position)
    if p = invalid then return
    sample = renderedFields()
    candidate = plusSeekLanding(m.ticket,p,sample.video,now,state)
    if not candidate.ready then return
    result = {id: m.ticket.id, requested: m.ticket.target, observed: p, difference: p - m.ticket.target, pauseRequested: m.ticket.paused, state: state}
    result.withinOneSecond = abs(result.difference) <= 1
    m.ticket.result = result
    emitDiagnostic("seek_result")
    m.ticket = invalid
    if not result.withinOneSecond
        m.notice = "La fuente ajustó el salto a " + plusClockText(p)
        m.noticeUntil = now + 5000
    end if
end sub

' A requested point can also be reached by ordinary playback after an ignored
' seek. Require a clock discontinuity or a fresh native actualStart indication
' before proximity can confirm anything; buffering by itself is not an ACK.
function plusSeekLanding(ticket as object, position as dynamic, video as dynamic, now as integer, state = "" as string) as object
    p = plusClockValue(position)
    answer = {ready:false}
    if p = invalid then return answer
    elapsed = (now-ticket.issuedAt)/1000.0
    if elapsed < 0.2 then return answer
    distance = abs(ticket.target-ticket.origin)
    movementEpsilon = distance/4
    if movementEpsilon > 0.05 then movementEpsilon = 0.05
    if abs(p-ticket.origin) < movementEpsilon then return answer
    v = plusClockValue(video)
    if ticket.verifyRendered
        if v = invalid then return answer
        if abs(v-p) > 2 then return answer
    end if
    nativePaused = ticket.paused
    if state <> "" then nativePaused = state = "paused"
    previousPosition = ticket.origin
    previousAt = ticket.issuedAt
    previousPaused = ticket.paused
    if ticket.issuedPaused <> invalid then previousPaused = ticket.issuedPaused
    if ticket.observedPosition <> invalid then previousPosition = ticket.observedPosition
    if ticket.observedAt <> invalid then previousAt = ticket.observedAt
    if ticket.observedPaused <> invalid then previousPaused = ticket.observedPaused
    sampleElapsed = (now-previousAt)/1000.0
    if sampleElapsed < 0 then return answer
    naturalCeiling = sampleElapsed
    if previousPaused and nativePaused then naturalCeiling = 0.0
    jumpTolerance = distance/4
    if jumpTolerance > 2 then jumpTolerance = 2.0
    if jumpTolerance < 0.02 then jumpTolerance = 0.02
    delta = p-previousPosition
    if delta < -jumpTolerance or delta > naturalCeiling+jumpTolerance then ticket.sawClockJump = true
    ticket.observedPosition = p
    ticket.observedAt = now
    ticket.observedPaused = nativePaused
    actualStart = plusClockValue(ticket.actualStart)
    nativeAck = false
    if actualStart <> invalid and ticket.actualStartAt <> invalid and ticket.sawBuffering
        if ticket.actualStartAt >= ticket.issuedAt and ticket.actualStartAt <= now
            nativeAck = abs(actualStart-ticket.origin) >= movementEpsilon and abs(actualStart-p) <= 1.25
        end if
    end if
    if ticket.sawClockJump <> true and not nativeAck then return answer
    nearTarget = abs(p-ticket.target) <= 1.25
    if nearTarget
        answer.ready = true
        return answer
    end if
    if ticket.landingAt = invalid
        ticket.landingAt = now
        ticket.landingPosition = p
        return answer
    end if
    settledFor = (now-ticket.landingAt)/1000.0
    expectedLandingMotion = settledFor
    if nativePaused then expectedLandingMotion = 0.0
    if abs((p-ticket.landingPosition)-expectedLandingMotion) > 1.5
        ticket.landingAt = now
        ticket.landingPosition = p
        return answer
    end if
    answer.ready = settledFor >= 0.8
    return answer
end function

function renderedFields() as object
    output = {}
    source = m.decoder.positionInfo
    if type(source) = "roAssociativeArray"
        for each field in ["audio", "video", "epoch", "clip_id", "clipId"]
            if source[field] <> invalid then output[field] = source[field]
        end for
    end if
    return output
end function

sub emitDiagnostic(reason as string)
    if m.current = invalid then return
    entry = {event: reason, generation: m.generation, ms: m.monotonic.totalMilliseconds(), state: m.decoder.state, position: m.decoder.position, duration: m.decoder.duration, seekMode: m.accuracyMode, live: m.live, wantPaused: m.wantPaused, rendered: renderedFields()}
    itemId = plusSafePlaybackIdentity(m.current.itemId)
    provider = plusSafePlaybackIdentity(m.current.provider,true)
    if itemId <> "" then entry.itemId = itemId
    if provider <> "" then entry.provider = provider
    if m.decoder.state = "error" then entry.nativeError = plusSafeNativeError(m.decoder.errorCode,m.decoder.errorInfo)
    if m.firstNative <> invalid then entry.firstNativePosition = m.firstNative
    if m.firstRendered <> invalid then entry.firstRenderedVideo = m.firstRendered
    if m.lastBuffer <> invalid then entry.buffer = m.lastBuffer
    if m.ticket <> invalid
        entry.seek = {id: m.ticket.id, origin: m.ticket.origin, target: m.ticket.target, issuedAt: m.ticket.issuedAt, paused: m.ticket.paused, sawBuffering: m.ticket.sawBuffering}
        if m.ticket.actualStart <> invalid then entry.seek.actualStart = m.ticket.actualStart
        if m.ticket.result <> invalid then entry.seek.result = m.ticket.result
        if reason = "position" or reason = "rendered"
            m.ticket.logs++
            if m.ticket.logs > 120 then return
        end if
    else if reason = "position" or reason = "rendered"
        return
    end if
    m.top.diagnostics = entry
    print "[RokuPlus] "; FormatJson(entry)
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if key = "home" then return false
    if not m.mediaOpen then return false
    if isPreviewPresentation() then return false
    ' Roku retains its standard Options menu for audio/accessibility controls.
    if key = "options" or key = "info" then return false
    if not press then return true
    if m.mediaMenuOpen = true then return handleMediaMenuKey(key)
    if key = "back"
        if m.live and m.top.allowPreviewReturn = true
            m.top.presentation = "preview"
            applyPresentation()
            m.top.previewReturned = true
        else
            closePlayback()
        end if
    else if key = "play"
        if m.audioGatePending = true then openMediaMenu("audio") else togglePause()
    else if key = "OK"
        if m.audioGatePending = true
            openMediaMenu("audio")
        else if m.panel.visible
            togglePause()
        else
            revealTransport()
        end if
    else if key = "down"
        openMediaMenu()
    else if key = "left" or key = "rewind" or key = "replay"
        shiftTen(true)
    else if key = "right" or key = "fastforward"
        shiftTen(false)
    else
        revealTransport()
    end if
    return true
end function

' Resume is queued once, after the native decoder reports a real duration.
' Reuse the serialized seek path; never reset content or guess a byte offset.
sub applyResumePosition()
    if m.resumeChecked = true or m.resumePending = invalid or not m.mediaOpen or m.live or m.failed then return
    if m.decoder.state <> "playing" and m.decoder.state <> "paused" then return
    duration = plusClockValue(m.decoder.duration)
    position = plusClockValue(m.decoder.position)
    if duration = invalid or duration <= 0 or position = invalid then return
    target = rpMediaResumeDestination(m.resumePending,duration,position)
    m.resumeChecked = true
    m.resumePending = invalid
    if target = invalid then return
    if m.ticket <> invalid or m.pendingSeek <> invalid then return
    now = m.monotonic.totalMilliseconds()
    m.pendingSeek = {target:target,dueAt:now}
    m.notice = "Reanudando en "+plusClockText(target)
    m.noticeUntil = now+6000
end sub

sub restoreCaptionMode()
    if m.decoder = invalid or m.captionModeBeforePlayback = invalid then return
    if GetInterface(m.captionModeBeforePlayback,"ifString") <> invalid then m.decoder.globalCaptionMode = m.captionModeBeforePlayback
    m.captionModeBeforePlayback = invalid
end sub

sub onMediaPreferenceChanged()
    if m.preferenceUpdating = true or m.decoder = invalid then return
    audio = rpMediaNormalizePreference(m.top.audioPreference)
    subtitles = rpMediaNormalizePreference(m.top.subtitlePreference,true)
    ' Field callbacks may be queued. A user-selected track stays selected when
    ' the short language preference we just saved echoes back asynchronously.
    if type(m.appliedMediaPreferences) = "roAssociativeArray"
        if m.appliedMediaPreferences.audio = audio and m.appliedMediaPreferences.subtitles = subtitles then return
    end if
    m.appliedMediaPreferences = {audio:audio,subtitles:subtitles}
    m.requestAudioPreference = ""
    m.requestLanguageConfirmed = false
    rpMediaSavePreferences(audio,subtitles)
    m.audioManual = false
    m.subtitleManual = false
    m.audioPolicyApplied = false
    onMediaTracksChanged()
end sub

sub onMediaTrackSelectionChanged()
    ' A choice made through Roku's own Options sheet is explicit too. Do not
    ' trap the viewer behind our language prompt after a native selection.
    if m.mediaOpen and m.audioGatePending = true
        selected = rpMediaText(m.decoder.currentAudioTrack,4096)
        explicit = rpMediaText(m.decoder.audioTrack,4096)
        for each track in rpMediaTracks(m.decoder.availableAudioTracks)
            if track.id = selected
                if track.language = mediaEffectiveAudioPreference() or (explicit <> "" and explicit = selected)
                    m.audioManual = true
                    releaseAudioGate()
                end if
            end if
        end for
    end if
    if m.mediaMenuOpen = true then drawMediaMenu()
end sub

sub onMediaTracksChanged()
    if not m.mediaOpen or m.closing or m.failed then return
    audioTracks = rpMediaTracks(m.decoder.availableAudioTracks)
    subtitleTracks = rpMediaTracks(m.decoder.availableSubtitleTracks,true)
    preference = mediaEffectiveAudioPreference()
    if m.audioManual <> true and m.audioPolicyApplied <> true
        if preference = "system"
            m.audioPolicyApplied = true
        else
            choice = rpMediaPreferredTrack(audioTracks,preference)
            if choice <> ""
                m.decoder.audioTrack = choice
                m.audioPolicyApplied = true
            else if m.requestLanguageConfirmed = true and audioTracks.count() > 0
                ' The source-version screen already obtained consent for this
                ' exact video. Keep the picker available without asking twice.
                m.audioPolicyApplied = true
            else if type(m.current) = "roAssociativeArray"
                if rpMediaDeclaredAudioMayMatch(audioTracks,m.current.languageCode,preference)
                    m.audioPolicyApplied = true
                    m.notice = "Audio según la fuente: "+rpMediaLanguageLabel(preference)+". ↓ para ver pistas."
                    m.noticeUntil = m.monotonic.totalMilliseconds()+8000
                end if
            end if
            if choice = "" and m.audioPolicyApplied <> true and audioTracks.count() > 0 and m.audioGateShown <> true
                ' Regionless Spanish is honest but not a confirmed Latino track.
                ' Ask before a different known language/dub instead of silently
                ' picking Portuguese, Spain Spanish, or English as a fallback.
                m.audioGateShown = true
                m.audioPolicyApplied = true
                m.notice = "No hay "+rpMediaLanguageLabel(preference)+" confirmado. ↓ para elegir audio."
                m.noticeUntil = m.monotonic.totalMilliseconds()+10000
                if not isPreviewPresentation()
                    m.audioGatePriorPaused = m.wantPaused
                    m.audioGatePending = true
                    m.wantPaused = true
                    m.decoder.autoplayAfterSeek = false
                    if m.decoder.state = "playing" then m.decoder.control = "pause"
                    openMediaMenu("audio")
                end if
            end if
        end if
    end if
    preference = rpMediaNormalizePreference(m.top.subtitlePreference,true)
    if m.subtitleManual <> true
        if preference = "off"
            m.decoder.suppressCaptions = true
            m.decoder.globalCaptionMode = "Off"
        else if preference = "system"
            m.decoder.suppressCaptions = false
            if GetInterface(m.captionModeBeforePlayback,"ifString") <> invalid then m.decoder.globalCaptionMode = m.captionModeBeforePlayback
        else
            choice = rpMediaPreferredTrack(subtitleTracks,preference)
            if choice <> ""
                m.decoder.subtitleTrack = choice
                m.decoder.suppressCaptions = false
                m.decoder.globalCaptionMode = "On"
            else
                m.decoder.suppressCaptions = true
                m.decoder.globalCaptionMode = "Off"
                if subtitleTracks.count() > 0 and m.trackWarningShown <> true and m.audioGatePending <> true
                    m.trackWarningShown = true
                    m.notice = "No hay subtítulos "+rpMediaLanguageLabel(preference)+" confirmados. ↓ para ver opciones."
                    m.noticeUntil = m.monotonic.totalMilliseconds()+8000
                end if
            end if
        end if
    end if
    if m.mediaMenuOpen = true then drawMediaMenu()
end sub

function mediaEffectiveAudioPreference() as string
    override = rpMediaText(m.requestAudioPreference,20)
    if override <> "" then return override
    return rpMediaNormalizePreference(m.top.audioPreference)
end function

function mediaCurrentTrackLabel(subtitles = false as boolean) as string
    if subtitles and m.decoder.suppressCaptions = true then return "Desactivados"
    raw = m.decoder.availableAudioTracks
    selected = rpMediaText(m.decoder.currentAudioTrack,4096)
    if subtitles
        raw = m.decoder.availableSubtitleTracks
        selected = rpMediaText(m.decoder.currentSubtitleTrack,4096)
    end if
    for each track in rpMediaTracks(raw,subtitles)
        if track.id = selected then return track.label
    end for
    if subtitles then return "Sin pista seleccionada"
    return "Idioma no especificado"
end function

sub openMediaMenu(view = "main" as string)
    if not m.mediaOpen or m.failed or isPreviewPresentation() or m.mediaMenu = invalid then return
    if view <> "audio" and view <> "subtitles" then view = "main"
    m.mediaMenuView = view
    m.mediaMenuCursor = 0
    m.mediaMenuGeneration = m.generation
    m.mediaMenuOpen = true
    m.mediaMenu.visible = true
    revealTransport()
    drawMediaMenu()
end sub

sub closeMediaMenu(restoreFocus = true as boolean)
    wasOpen = m.mediaMenuOpen = true
    m.mediaMenuOpen = false
    if m.mediaMenu <> invalid then m.mediaMenu.visible = false
    if wasOpen and restoreFocus and m.mediaOpen and not m.closing and not isPreviewPresentation()
        m.top.setFocus(true)
        revealTransport()
    end if
end sub

function mediaMenuOptions() as object
    rows = []
    if m.mediaMenuView = "main"
        rows.push({action:"audio",label:"Audio · "+mediaCurrentTrackLabel()})
        rows.push({action:"subtitles",label:"Subtítulos · "+mediaCurrentTrackLabel(true)})
        rows.push({action:"close",label:"Volver al video"})
        return rows
    end if
    subtitles = m.mediaMenuView = "subtitles"
    if subtitles
        rows.push({action:"off",label:"Desactivar subtítulos",value:"off"})
    else if m.audioGatePending = true
        rows.push({action:"current",label:"Continuar con el audio actual (solo este video)"})
    end if
    rows.push({action:"prefer",label:"Preferir español latino cuando esté disponible",value:"latino"})
    rows.push({action:"system",label:"Usar la preferencia del sistema",value:"system"})
    raw = m.decoder.availableAudioTracks
    selected = rpMediaText(m.decoder.currentAudioTrack,4096)
    if subtitles
        raw = m.decoder.availableSubtitleTracks
        selected = rpMediaText(m.decoder.currentSubtitleTrack,4096)
    end if
    for each track in rpMediaTracks(raw,subtitles)
        label = track.label
        if track.id = selected then label = "✓ "+label
        rows.push({action:"track",label:label,id:track.id,value:track.language})
    end for
    return rows
end function

sub drawMediaMenu()
    if m.mediaMenuRows = invalid or m.mediaMenuOpen <> true then return
    if m.mediaMenuGeneration <> m.generation then closeMediaMenu(false): return
    m.mediaOptions = mediaMenuOptions()
    if m.mediaMenuCursor >= m.mediaOptions.count() then m.mediaMenuCursor = m.mediaOptions.count()-1
    if m.mediaMenuCursor < 0 then m.mediaMenuCursor = 0
    m.mediaMenuRows.removeChildrenIndex(m.mediaMenuRows.getChildCount(),0)
    m.mediaMenuTitle.text = "Audio y subtítulos"
    m.mediaMenuHint.text = "Solo se muestran las pistas que anuncia este video. Los idiomas sin región no se etiquetan como latino."
    if m.mediaMenuView = "audio" then m.mediaMenuTitle.text = "Elegir audio"
    if m.mediaMenuView = "subtitles" then m.mediaMenuTitle.text = "Elegir subtítulos"
    if m.audioGatePending = true and m.mediaMenuView = "audio" then m.mediaMenuHint.text = "La fuente no anuncia el idioma preferido. Elige una pista o confirma usar el audio actual."
    first = (m.mediaMenuCursor \ 6)*6
    for i = 0 to 5
        index = first+i
        if index < m.mediaOptions.count()
            row = m.mediaMenuRows.createChild("Rectangle")
            row.translation = [0,i*86]
            row.width = 890
            row.height = 77
            row.color = "0x32433DE8"
            if index = m.mediaMenuCursor then row.color = "0xE6EBDAFF"
            label = m.mediaMenuRows.createChild("Label")
            label.translation = [20,i*86+8]
            label.width = 850
            label.height = 62
            label.wrap = true
            label.color = "0xF4F6EEFF"
            if index = m.mediaMenuCursor then label.color = "0x142923FF"
            face = label.font
            face.size = 25
            label.font = face
            label.text = m.mediaOptions[index].label
        end if
    end for
end sub

sub persistMediaChoice(value as string, subtitles as boolean)
    if value = "" then return
    audio = rpMediaNormalizePreference(m.top.audioPreference)
    captions = rpMediaNormalizePreference(m.top.subtitlePreference,true)
    if subtitles then captions = rpMediaNormalizePreference(value,true) else audio = rpMediaNormalizePreference(value)
    m.appliedMediaPreferences = {audio:audio,subtitles:captions}
    m.preferenceUpdating = true
    if subtitles then m.top.subtitlePreference = rpMediaNormalizePreference(value,true) else m.top.audioPreference = rpMediaNormalizePreference(value)
    m.preferenceUpdating = false
    saved = rpMediaSavePreferences(rpMediaNormalizePreference(m.top.audioPreference),rpMediaNormalizePreference(m.top.subtitlePreference,true))
    if not saved
        m.notice = "El idioma se aplicó, pero no pudo guardarse para la próxima vez."
        m.noticeUntil = m.monotonic.totalMilliseconds()+8000
    end if
end sub

sub releaseAudioGate()
    if m.audioGatePending <> true then return
    m.audioGatePending = false
    m.wantPaused = m.audioGatePriorPaused = true
    m.decoder.autoplayAfterSeek = not m.wantPaused
    if not m.wantPaused and m.decoder.state = "paused" then m.decoder.control = "resume"
    if left(m.notice,7) = "No hay "
        m.notice = ""
        m.noticeUntil = 0
    end if
end sub

sub selectMediaMenuOption()
    if m.mediaMenuGeneration <> m.generation or not m.mediaOpen then closeMediaMenu(false): return
    rows = mediaMenuOptions()
    if m.mediaMenuCursor < 0 or m.mediaMenuCursor >= rows.count() then return
    option = rows[m.mediaMenuCursor]
    if option.action = "close" then closeMediaMenu(): return
    if option.action = "audio" then openMediaMenu("audio"): return
    if option.action = "subtitles" then openMediaMenu("subtitles"): return
    subtitles = m.mediaMenuView = "subtitles"
    if option.action = "track"
        if subtitles
            m.subtitleManual = true
            m.decoder.subtitleTrack = option.id
            m.decoder.suppressCaptions = false
            m.decoder.globalCaptionMode = "On"
        else
            m.audioManual = true
            m.requestLanguageConfirmed = true
            m.requestAudioPreference = option.value
            m.decoder.audioTrack = option.id
        end if
        persistMediaChoice(option.value,subtitles)
        if not subtitles then releaseAudioGate()
    else if option.action = "off"
        m.subtitleManual = true
        m.decoder.suppressCaptions = true
        m.decoder.globalCaptionMode = "Off"
        persistMediaChoice("off",true)
    else if option.action = "current"
        m.audioManual = true
        m.requestLanguageConfirmed = true
        releaseAudioGate()
    else if option.action = "system"
        persistMediaChoice("system",subtitles)
        if subtitles
            m.subtitleManual = true
            m.decoder.suppressCaptions = false
            if GetInterface(m.captionModeBeforePlayback,"ifString") <> invalid then m.decoder.globalCaptionMode = m.captionModeBeforePlayback
            m.decoder.subtitleTrack = ""
        else
            m.audioManual = true
            m.requestAudioPreference = "system"
            m.requestLanguageConfirmed = true
            m.decoder.audioTrack = ""
            releaseAudioGate()
        end if
    else if option.action = "prefer"
        persistMediaChoice("latino",subtitles)
        if subtitles then m.subtitleManual = false else m.audioManual = false
        if not subtitles
            m.requestAudioPreference = ""
            m.requestLanguageConfirmed = false
        end if
        if not subtitles then m.audioPolicyApplied = false
        onMediaTracksChanged()
        if not subtitles and m.audioGatePending = true
            choice = rpMediaPreferredTrack(rpMediaTracks(m.decoder.availableAudioTracks),"latino")
            if choice <> "" then releaseAudioGate()
        end if
    end if
    closeMediaMenu()
    drawTransport()
end sub

function handleMediaMenuKey(key as string) as boolean
    if key = "back"
        if m.mediaMenuView = "main" then closeMediaMenu() else openMediaMenu()
    else if key = "up"
        if m.mediaMenuCursor > 0 then m.mediaMenuCursor--
        drawMediaMenu()
    else if key = "down"
        if m.mediaMenuCursor+1 < mediaMenuOptions().count() then m.mediaMenuCursor++
        drawMediaMenu()
    else if key = "OK"
        selectMediaMenuOption()
    end if
    return true
end function
