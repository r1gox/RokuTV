sub init()
    m.jglVStopped = false
    m.info = m.top.FindNode("deviceInfo")
    m.codec = m.top.FindNode("codecStatus")
    m.codec2 = m.top.FindNode("codecStatus2")
    m.avcMark = m.top.FindNode("avcMark")
    m.hevcMark = m.top.FindNode("hevcMark")
    m.status = m.top.FindNode("status")
    m.labels = [m.top.FindNode("opt0"), m.top.FindNode("opt1"), m.top.FindNode("opt2")]
    m.bgs = [m.top.FindNode("optBg0"), m.top.FindNode("optBg1"), m.top.FindNode("optBg2")]
    m.idx = 0
    m.pinDlg = invalid
    m.pinStage = ""
    m.firstPin = ""
    m.pinResetTimer = invalid
    m.pinResetDlg = invalid
    m.pinResetMessage = ""
    m.top.ObserveField("visible", "OnSettingsShown")
end sub
sub OnSettingsShown(event as Object)
    if m.jglVStopped = true then return
    if event.GetData() <> true then return
    hw = Hardware_Detect()
    name = SafeStr(hw.modelName)
    if name = "" then name = "Roku " + SafeStr(hw.model)
    mode = SafeStr(hw.videoMode)
    if mode = "" then mode = "No determinado"
    m.info.text = "Modelo: " + name + "   ·   Resolución: " + mode
    m.avcMark.text = "H.264 " + Hardware_Mark(hw.avc)
    m.hevcMark.text = "HEVC/H.265 " + Hardware_Mark(hw.hevc)
    m.avcMark.color = CodecMarkColor(hw.avc)
    m.hevcMark.color = CodecMarkColor(hw.hevc)
    m.codec2.text = ""
    if hw.avc = true and hw.hevc = true
        m.codec.color = "0x5BD68AFF"
        m.codec.text = "Esta TV puede reproducir películas y series H.264/H.265 compatibles."
    else if hw.avc = true and hw.hevc = false
        m.codec.color = "0x5BD68AFF"
        m.codec.text = "Esta TV puede reproducir películas y series H.264 compatibles."
        m.codec2.color = "0xE96A72FF"
        m.codec2.text = "Esta TV no admite HEVC (H.265). Para ese contenido, consigue un Roku 4K compatible."
    else if hw.avc = invalid or hw.hevc = invalid
        m.codec.color = "0x999DA8FF"
        m.codec.text = "No se pudo determinar la compatibilidad de video."
    else
        m.codec.color = "0xE96A72FF"
        m.codec.text = "El Roku informó incompatibilidad con los perfiles H.264 y HEVC probados; otros formatos o perfiles pueden variar."
    end if
    m.labels[1].text = Tern(v4a10(), "  PIN +18 configurado", "  Configurar PIN +18")
    m.labels[2].visible = v4a10()
    m.bgs[2].visible = m.labels[2].visible
    if not m.labels[2].visible and m.idx = 2 then m.idx = 1
    m.status.text = ""
    HighlightSettings()
end sub
function CodecMarkColor(value as Dynamic) as String
    if value = invalid then return "0x999DA8FF"
    if value = true then return "0x5BD68AFF"
    return "0xE96A72FF"
end function
sub HighlightSettings()
    if m.jglVStopped = true then return
    for i = 0 to 2
        active = (i = m.idx and m.labels[i].visible)
        m.bgs[i].color = Tern(active, THEME_ACCENT(), "0x242631FF")
        m.labels[i].color = Tern(active, "0xFFFFFFFF", "0xE4E6EBFF")
    end for
end sub
function onKeyEvent(key as String, press as Boolean) as Boolean
    if m.jglVStopped = true then return false
    if not press then return false
    if key = "back" then m.top.action = "close" : return true
    if key = "up" and m.idx > 0 then m.idx = m.idx - 1 : HighlightSettings() : return true
    if key = "down"
        maxIdx = Tern(m.labels[2].visible, 2, 1)
        if m.idx < maxIdx then m.idx = m.idx + 1
        HighlightSettings() : return true
    end if
    if key = "OK" then ActivateSetting() : return true
    return false
end function
sub ActivateSetting()
    if m.jglVStopped = true then return
    if m.idx = 0
        dlg = CreateObject("roSGNode", "StandardMessageDialog")
        dlg.title = "Borrar historial"
        dlg.message = "¿Quieres eliminar todo el historial guardado en este dispositivo?"
        dlg.buttons = ["Cancelar", "Sí, borrar historial"]
        m.confirmDlg = dlg
        dlg.ObserveField("buttonSelected", "OnHistoryChoice")
        dlg.ObserveField("wasClosed", "OnHistoryClosed")
        JglVRoot().dialog = dlg
    else if m.idx = 1 and not v4a10()
        OpenPin("create1", "Crear PIN +18", "Escribe un PIN numérico de 4 dígitos.")
    else
        OpenPin("current", "Cambiar PIN +18", "Escribe el PIN actual.")
    end if
end sub
sub OnHistoryChoice(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.confirmDlg = invalid or not dlg.isSameNode(m.confirmDlg) then return
    if event.GetData() = 1 then ClearLocalHistory()
    CloseConfirm(dlg)
end sub
sub OnHistoryClosed(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.confirmDlg = invalid or not dlg.isSameNode(m.confirmDlg) then return
    CloseConfirm(dlg)
end sub
sub CloseConfirm(dlg as Object)
    if m.jglVStopped = true then return
    dlg.UnobserveField("buttonSelected") : dlg.UnobserveField("wasClosed")
    m.confirmDlg = invalid
    m.top.SetFocus(true)
end sub
sub ClearLocalHistory()
    if m.jglVStopped = true then return
    reg = CreateObject("roRegistrySection", "RokuPlusJglVHistory")
    for each key in ["history", "searchHistory", "lastSearch", "continueWatching", "playbackPositions", "watchProgress"]
        if reg.Exists(key) then reg.Delete(key)
    end for
    if reg.Flush()
        m.status.color = "0x5BD68AFF"
        m.status.text = "Historial eliminado correctamente. Los datos del proveedor no fueron modificados."
        m.top.action = "historyCleared"
    else
        m.status.color = "0xE96A72FF" : m.status.text = "No se pudo eliminar el historial local."
    end if
end sub
sub OpenPin(stage as String, title as String, message as String)
    if m.jglVStopped = true then return
    wait = v4a13()
    if wait > 0
        m.status.color = "0xE96A72FF" : m.status.text = "Demasiados intentos. Espera " + wait.ToStr() + " segundos."
        return
    end if
    dlg = CreateObject("roSGNode", "PinDialog")
    dlg.title = title : dlg.message = message : dlg.buttons = ["Aceptar", "Cancelar"]
    m.pinStage = stage : m.pinDlg = dlg
    dlg.ObserveField("buttonSelected", "OnSettingsPinButton")
    dlg.ObserveField("wasClosed", "OnSettingsPinClosed")
    JglVRoot().dialog = dlg
end sub
sub OnSettingsPinButton(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    if event.GetData() <> 0
        CloseSettingsPin(dlg)
        return
    end if
    pin = SafeStr(dlg.pin)
    if Len(pin) <> 4
        SettingsPinScheduleReset(dlg, "El PIN debe tener 4 dígitos.")
        return
    end if
    stage = m.pinStage
    if stage = "current"
        if v4a12(pin)
            v4a15()
            CloseSettingsPin(dlg)
            OpenPin("new1", "PIN nuevo", "Escribe el PIN nuevo de 4 dígitos.")
        else
            wait = v4a14()
            m.status.color = "0xE96A72FF"
            if wait > 0
                msg = "Demasiados intentos. Espera " + wait.ToStr() + " segundos."
                m.status.text = msg
            else
                msg = "PIN incorrecto. Inténtalo nuevamente."
                m.status.text = msg
            end if
            SettingsPinScheduleReset(dlg, msg)
        end if
        return
    end if
    CloseSettingsPin(dlg)
    if stage = "create1" or stage = "new1"
        m.firstPin = pin
        OpenPin(Tern(stage = "create1", "create2", "new2"), "Confirmar PIN +18", "Repite el PIN nuevo.")
    else if stage = "create2" or stage = "new2"
        if pin <> m.firstPin
            m.firstPin = "" : m.status.color = "0xE96A72FF" : m.status.text = "Los PIN no coinciden. Inténtalo nuevamente."
            OpenPin(Tern(stage = "create2", "create1", "new1"), "PIN +18", "Escribe nuevamente el PIN nuevo.")
        else if v4a11(pin)
            m.firstPin = "" : v4a15()
            m.status.color = "0x5BD68AFF" : m.status.text = "PIN +18 guardado correctamente."
            RefreshParentalOptions()
        else
            m.status.color = "0xE96A72FF" : m.status.text = "No se pudo guardar el PIN."
        end if
    end if
end sub
sub RefreshParentalOptions()
    if m.jglVStopped = true then return
    configured = v4a10()
    m.labels[1].text = Tern(configured, "  PIN +18 configurado", "  Configurar PIN +18")
    m.labels[2].visible = configured
    m.bgs[2].visible = configured
    HighlightSettings()
end sub
sub OnSettingsPinClosed(event as Object)
    if m.jglVStopped = true then return
    dlg = event.GetRoSGNode()
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    CloseSettingsPin(dlg)
end sub
sub CloseSettingsPin(dlg as Object)
    if m.jglVStopped = true then return
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetTimer = invalid : m.pinResetDlg = invalid
    dlg.UnobserveField("buttonSelected") : dlg.UnobserveField("wasClosed")
    dlg.close = true : m.pinDlg = invalid : m.top.SetFocus(true)
end sub
sub SettingsPinScheduleReset(dlg as Object, message as String)
    if m.jglVStopped = true then return
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    if m.pinResetTimer <> invalid then m.pinResetTimer.control = "stop"
    m.pinResetDlg = dlg : m.pinResetMessage = message
    timer = CreateObject("roSGNode", "Timer")
    timer.duration = 0.05 : timer.repeat = false
    timer.ObserveField("fire", "OnSettingsPinResetFire")
    m.pinResetTimer = timer
    timer.control = "start"
end sub
sub OnSettingsPinResetFire(event as Object)
    if m.jglVStopped = true then return
    timer = event.GetRoSGNode()
    if timer <> invalid then timer.UnobserveField("fire")
    m.pinResetTimer = invalid
    dlg = m.pinResetDlg : m.pinResetDlg = invalid
    if dlg = invalid or m.pinDlg = invalid or not dlg.isSameNode(m.pinDlg) then return
    dlg.message = m.pinResetMessage
    dlg.messageColor = "0xE96A72FF"
    dlg.pin = ""
    dlg.pinPadFocused = true
    if dlg.pinPad <> invalid then dlg.pinPad.SetFocus(true)
end sub
