' Optional user-supplied app. Constructing the host never constructs this module.
' Only the explicit App JGLCUSTOMS action starts its original provider/client flow.
sub openJglV()
    if m.jglVActive = true then return
    m.jglVReturn = {view:m.view,zone:m.zone,nav:6}
    m.jglVActive = true
    m.view = "jglv"
    cancelRequest()
    cancelHomeRequests()
    stopLivePreview()
    if m.noteTimer <> invalid then m.noteTimer.control = "stop"
    if m.lease <> invalid then m.lease.control = "stop"
    if m.leaseTask <> invalid then m.leaseTask.cancelRequested = true
    m.leaseTask = invalid
    m.activeJobId = ""
    releaseDialog()
    if m.player <> invalid
        m.player.callFunc("closePlayback")
        m.player.visible = false
    end if
    releaseHostCanvas()
    m.canvas.visible = false
    module = CreateObject("roSGNode","JglVModule")
    if module = invalid
        closeJglV(false)
        m.note = "No se pudo abrir App JGLCUSTOMS. Puedes seguir usando Roku Plus."
        drawScreen()
        return
    end if
    m.jglVModule = module
    module.observeField("requestExit","jglVExitRequested")
    m.top.appendChild(module)
    ' Delayed activation is essential: init runs before the node has a Scene.
    module.active = true
    module.setFocus(true)
end sub

sub jglVExitRequested(event as object)
    if m.jglVModule = invalid then return
    if not m.jglVModule.isSameNode(event.getRoSGNode()) then return
    if event.getData() = true then closeJglV()
end sub

sub closeJglV(toHome = true as boolean)
    if not m.jglVActive then return
    module = m.jglVModule
    m.jglVModule = invalid
    if module <> invalid
        module.unobserveField("requestExit")
        module.callFunc("shutdown")
        module.active = false
        m.top.removeChild(module)
    end if
    m.jglVActive = false
    m.view = "home"
    m.zone = "nav"
    m.nav = 0
    if not toHome and type(m.jglVReturn) = "roAssociativeArray"
        m.view = m.jglVReturn.view
        ' Return focus to App JGLCUSTOMS; do not automatically restart a TV stream.
        m.nav = m.jglVReturn.nav
    end if
    m.jglVReturn = invalid
    m.canvas.visible = true
    drawScreen()
    m.top.setFocus(true)
end sub
