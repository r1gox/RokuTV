function v4a16(s as String) as String
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(s)
    d = CreateObject("roEVPDigest")
    d.Setup("md5")
    return LCase(d.Process(ba))
end function
function v4a17() as String
    info = CreateObject("roAppInfo")
    return "1.0.39"
end function
