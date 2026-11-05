sub init()
    m.jglVStopped = false
    m.top.functionName = "JglVXuperTask"
end sub
sub JglVXuperTask()
    if m.jglVStopped = true then return
    req = CreateObject("roUrlTransfer")
    req.SetUrl(m.top.url)
    headers = m.top.headers
    if headers <> invalid
        for each k in headers
            req.AddHeader(k, headers[k])
        end for
    end if
    req.EnableEncodings(true)
    req.SetCertificatesFile("common:/certs/ca-bundle.crt")
    req.InitClientCertificates()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    if not req.AsyncPostFromString(m.top.body)
        m.top.error = "async_fallo"
        return
    end if
    msg = wait(20000, port)
    if msg = invalid
        m.top.error = "timeout_20s"
        return
    end if
    if type(msg) <> "roUrlEvent"
        m.top.error = "evento_inesperado"
        return
    end if
    code = msg.GetResponseCode()
    if code <> 200
        m.top.error = "http_" + code.ToStr()
        return
    end if
    m.top.rawResp = msg.GetString()
end sub
