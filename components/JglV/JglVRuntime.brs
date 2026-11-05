' Integration-only lifecycle helpers. Original provider protocol is unchanged.
function JglVRoot() as Dynamic
    node = m.top
    while node <> invalid
        if node.subtype() = "JglVModule" then return node
        node = node.getParent()
    end while
    return invalid
end function

sub JglVReturnHome()
    if m.jglVStopped = true then return
    root = JglVRoot()
    if root <> invalid then root.requestExit = true
end sub

function shutdown() as Boolean
    if m.jglVStopped = true then return true
    m.jglVStopped = true
    ' m.global belongs to the host SceneGraph application. Never stop it.
    for each key in m
        if key <> "top" and key <> "global"
            value = m[key]
            if type(value) = "roSGNode" then JglVStopNode(value)
        end if
    end for
    for each child in m.top.getChildren(-1, 0)
        JglVStopNode(child)
    end for
    JglVUnobserve(m.top)
    if m.top.subtype() = "JglVModule"
        dialog = m.top.dialog
        scene = m.top.getScene()
        if dialog <> invalid
            JglVUnobserve(dialog)
            if dialog.hasField("close") then dialog.close = true
            if scene <> invalid and scene.dialog <> invalid
                if scene.dialog.isSameNode(dialog) then scene.dialog = invalid
            end if
        end if
        m.top.active = false
    end if
    m.top.visible = false
    m.top.setFocus(false)
    return true
end function

sub JglVUnobserve(node as Object)
    for each field in ["rawResp", "error", "ready", "okUrl", "cues", "fire", "state", "position", "videoFormat", "audioFormat", "start", "halt", "visible", "action", "showDebug", "showSettings", "sessionStale", "channelCode", "vodContentId", "vodUrl", "control", "poke", "transport", "displayMode", "statusMessage", "detectedVideoCodec", "detectedAudioFormat", "buttonSelected", "wasClosed", "text", "active", "dialog"]
        if node.hasField(field) then node.unobserveField(field)
    end for
end sub

sub JglVStopNode(node as Object)
    if node.isSameNode(m.top) then return
    JglVUnobserve(node)
    subtype = lcase(node.subtype())
    if subtype = "jglvxupertask" or subtype = "jglvmanifestproxy" or subtype = "jglvprobetask" or subtype = "jglvsrttask"
        ' STOP terminates the worker and releases its local transfers/sockets.
        if node.hasField("cancelRequested") then node.cancelRequested = true
        node.control = "STOP"
        return
    end if
    if left(subtype, 4) = "jglv"
        node.callFunc("shutdown")
        return
    end if
    if subtype = "timer" or subtype = "animation" or subtype = "video"
        node.control = "stop"
        if subtype = "video" then node.content = invalid
    end if
    if node.hasField("close") then node.close = true
    for each child in node.getChildren(-1, 0)
        JglVStopNode(child)
    end for
end sub
