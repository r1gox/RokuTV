function Q(s as String) as String
    return Chr(34) + JsonEsc(s) + Chr(34)
end function
function JsonEsc(s as String) as String
    bs = Chr(92)
    out = s.Replace(bs, bs + bs)
    out = out.Replace(Chr(34), bs + Chr(34))
    out = out.Replace(Chr(13), " ")
    out = out.Replace(Chr(10), " ")
    out = out.Replace(Chr(9), " ")
    return out
end function
function AsInt(v as Dynamic) as Integer
    if v = invalid then return 0
    if Type(v) = "String" or Type(v) = "roString" then return Int(Val(v))
    return Int(v)
end function
function Api_OpTask(op as String, args as Object) as Dynamic
    k = v4a21()
    if k = invalid then return invalid
    body = v4a32(op, args)
    if body = "" then return invalid
    t = createObject("roSGNode", "JglVXuperTask")
    t.url     = v4a33(op)
    t.headers = k.headers
    t.body    = body
    return t
end function
function Api_ParseOp(rawResp as String) as Dynamic
    outer = ParseJSON(rawResp)
    if outer = invalid then return invalid
    rc = SafeStr(outer.returnCode)
    if rc <> "0"
        if v4a37(rc)
            sc = JglVRoot()
            if sc <> invalid then sc.sessionStale = true
        end if
        return invalid
    end if
    if Type(outer.data) = "String" and outer.data <> ""
        k = v4a21()
        if k = invalid then return invalid
        plain = v4a05(outer.data, k.key)
        if plain = "" then return invalid
        return ParseJSON(plain)
    end if
    return outer.data
end function
function Api_LicenseGone(err as Dynamic) as Boolean
    return false
end function
