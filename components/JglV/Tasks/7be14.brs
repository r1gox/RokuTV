sub init()
    m.jglVStopped = false
    m.top.functionName = "Probe"
end sub
sub Probe()
    if m.jglVStopped = true then return
    urls = m.top.urls
    if urls = invalid or urls.Count() = 0
        m.top.okUrl = ""
        return
    end if
    headers = m.top.headers
    for each url in urls
        if TryHead(url, headers)
            m.top.okUrl = url
            return
        end if
    end for
    m.top.okUrl = urls[0]
end sub
function TryHead(url as String, headers as Object) as Boolean
    req = CreateObject("roUrlTransfer")
    req.SetUrl(url)
    if headers <> invalid
        for each k in headers
            req.AddHeader(k, headers[k])
        end for
    end if
    req.AddHeader("Range", "bytes=0-0")
    req.SetCertificatesFile("common:/certs/ca-bundle.crt")
    req.InitClientCertificates()
    port = CreateObject("roMessagePort")
    req.SetMessagePort(port)
    if not req.AsyncGetToString() then return false
    msg = wait(6000, port)
    if msg = invalid
        req.AsyncCancel()
        return false
    end if
    if type(msg) <> "roUrlEvent" then return false
    code = msg.GetResponseCode()
    return code >= 200 and code < 300
end function
