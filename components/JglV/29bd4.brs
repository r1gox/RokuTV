sub init()
    m.jglVStopped = false
    m.setupScreen = m.top.FindNode("setupScreen")
    m.homeScreen  = m.top.FindNode("homeScreen")
    m.debugScreen = m.top.FindNode("debugScreen")
    m.debugScreen.ObserveField("action", "OnDebugAction")
    m.top.ObserveField("showDebug", "OnShowDebug")
    m.settingsScreen = m.top.FindNode("settingsScreen")
    m.settingsScreen.ObserveField("action", "OnSettingsAction")
    m.top.ObserveField("showSettings", "OnShowSettings")
    m.top.ObserveField("sessionStale", "OnSessionStale")
    m.jglVStarted = false
    m.top.observeField("active", "JglVOnActive")
    m.top.observeField("dialog", "JglVOnDialog")
end sub
sub OnShowSettings(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() <> true then return
    m.top.showSettings = false
    m.homeScreen.halt = true
    m.settingsScreen.visible = true
    m.settingsScreen.SetFocus(true)
end sub
sub OnSettingsAction(event as Object)
    if m.jglVStopped = true then return
    action = SafeStr(event.GetData())
    if action = "historyCleared"
        m.homeScreen.CallFunc("ClearHistoryMemory")
    else if action = "close"
        m.settingsScreen.visible = false
        m.homeScreen.visible = true
        m.homeScreen.SetFocus(true)
    end if
end sub
sub ShowSetup()
    if m.jglVStopped = true then return
    m.homeScreen.visible  = false
    m.setupScreen.visible = true
    m.setupScreen.SetFocus(true)
    m.setupScreen.status = "Preparando tu equipo..."
    m.renewing = false
    m.retryDelay = 0
    RegisterAccount()
end sub
sub ShowHome()
    if m.jglVStopped = true then return
    m.setupScreen.visible = false
    m.homeScreen.visible = true
    m.homeScreen.SetFocus(true)
    m.homeScreen.start = true
end sub
sub OnShowDebug(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() <> true then return
    m.top.showDebug = false
    m.homeScreen.halt = true          ' que no siga sonando nada de fondo
    m.debugScreen.visible = true
    m.debugScreen.SetFocus(true)
end sub
sub OnDebugAction(event as Object)
    if m.jglVStopped = true then return
    action = SafeStr(event.GetData())
    if action = "renew"
        CloseDebug()
        m.top.sessionStale = true      ' re-registra y recarga el Home
    else if action = "wipe"
        v4a24()
        CloseDebug()
        ShowSetup()
    else if action = "close"
        CloseDebug()
        ShowHome()
    end if
end sub
sub CloseDebug()
    if m.jglVStopped = true then return
    m.debugScreen.visible = false
end sub
sub OnSessionStale(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() <> true then return
    m.top.sessionStale = false
    if m.renewing = true then return
    if not v4a26() then return
    RegisterAccount()
end sub
sub RegisterAccount()
    if m.jglVStopped = true then return
    m.renewing = true
    v4a27()
    m.fp = v4a34()
    t = Api_OpTask("snToken", m.fp)
    if t = invalid
        RenewFailed("sin plantilla de alta")
        return
    end if
    if m.regTask <> invalid then m.regTask.control = "STOP"
    m.regTask = t
    m.regTask.ObserveField("rawResp", "OnRenewSnToken")
    m.regTask.ObserveField("error",   "OnRenewError")
    m.regTask.control = "RUN"
end sub
sub OnRenewSnToken(event as Object)
    if m.jglVStopped = true then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or not IsValidStr(data.snToken)
        RenewFailed("snToken sin token")
        return
    end if
    if IsValidStr(data.sn)
        m.newSn = data.sn
    else
        k = v4a21()
        m.newSn = v4a16(data.snToken + SafeStr(k.snSecret))
    end if
    m.newSnToken = data.snToken
    t = Api_OpTask("active", { snToken: m.newSnToken, sn: m.newSn })
    if t = invalid
        RenewFailed("sin plantilla de activacion")
        return
    end if
    if m.actTask <> invalid then m.actTask.control = "STOP"
    m.actTask = t
    m.actTask.ObserveField("rawResp", "OnRenewActive")
    m.actTask.ObserveField("error",   "OnRenewError")
    m.actTask.control = "RUN"
end sub
sub OnRenewActive(event as Object)
    if m.jglVStopped = true then return
    data = Api_ParseOp(event.GetData())
    if data = invalid or not IsValidStr(data.userId)
        RenewFailed("active sin userId")
        return
    end if
    portalCode = "masnew"
    if data.portalCodeList <> invalid and data.portalCodeList.Count() > 0
        portalCode = data.portalCodeList[0].portalCode
    else if IsValidStr(data.portalCode)
        portalCode = data.portalCode
    end if
    id = v4a27()
    v4a23({
        sn:         m.newSn,
        snToken:    m.newSnToken,
        drmId:      id.drmId,
        reserve1:   id.reserve1,
        userId:     data.userId,
        userToken:  SafeStr(data.userToken),
        portalCode: portalCode
    })
    m.renewing = false
    if m.retryTimer <> invalid then m.retryTimer.control = "stop"
    ShowHome()
end sub
sub OnRenewError(event as Object)
    if m.jglVStopped = true then return
    RenewFailed(SafeStr(event.GetData()))
end sub
sub RenewFailed(why as String)
    if m.jglVStopped = true then return
    m.renewing = false
    if v4a26() then return
    if m.retryDelay = invalid or m.retryDelay < 5
        m.retryDelay = 5
    else
        m.retryDelay = m.retryDelay * 2
        if m.retryDelay > 60 then m.retryDelay = 60
    end if
    m.setupScreen.status = "Sin conexion. Reintentando en " + m.retryDelay.ToStr() + " s..."
    if m.retryTimer = invalid
        m.retryTimer = CreateObject("roSGNode", "Timer")
        m.retryTimer.repeat = false
        m.retryTimer.ObserveField("fire", "OnRetryTick")
    end if
    m.retryTimer.control = "stop"
    m.retryTimer.duration = m.retryDelay
    m.retryTimer.control = "start"
end sub
sub OnRetryTick(event as Object)
    if m.jglVStopped = true then return
    if v4a26() then return
    m.setupScreen.status = "Preparando tu equipo..."
    RegisterAccount()
end sub

' The host creates this component only on entering App JGLV, appends it,
' observes requestExit, and THEN sets active=true. No API call precedes active.
sub JglVOnActive(event as Object)
    if event.getData() <> true
        ignored = shutdown()
        return
    end if
    if m.jglVStopped = true or m.jglVStarted = true then return
    m.jglVStarted = true
    if v4a26()
        ShowHome()
    else
        ShowSetup()
    end if
end sub

sub JglVOnDialog(event as Object)
    if m.jglVStopped = true then return
    dialog = event.getData()
    scene = m.top.getScene()
    if scene <> invalid and dialog <> invalid then scene.dialog = dialog
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if m.jglVStopped = true or not press then return false
    if key = "back"
        m.top.requestExit = true
        return true
    end if
    return false
end function
