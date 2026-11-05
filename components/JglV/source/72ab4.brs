function v4a18() as String : return "RokuPlusJglVSession" : end function
function v4a19() as String : return "pkg:/components/JglV/rsc/4d91.dat" : end function
function q9(v as Object, k as Integer) as String
    o = ""
    for each n in v
        o = o + Chr(n - k)
    end for
    return o
end function
function v4a20() as String
    a = q9([175,177,107,175,158,166,169,107,159,175,158,171,161,107,118,160,111],61)
    b = q9([199,196,124,186,184,195,124,177,187,190,177,124,197,128],79)
    return Left(v4a16(a + q9([167],43) + b) + v4a16(b + a), 48)
end function
function v4a21() as Dynamic
    if m.kitCache <> invalid then return m.kitCache
    raw = ReadAsciiFile(v4a19())
    if raw = q9([],40) then
        return invalid
    end if
    plain = v4a05(raw, v4a20())
    if plain = q9([],91) then
        return invalid
    end if
    k = ParseJSON(plain)
    if k = invalid or k.ops = invalid then return invalid
    m.kitCache = k
    return k
end function
function v4a22() as Boolean
    return v4a21() <> invalid
end function
sub v4a23(session as Object)
    if m.jglVStopped = true then return
    reg = CreateObject(q9([166,163,134,153,155,157,167,168,166,173,135,153,151,168,157,163,162],52), v4a18())
    reg.Write(q9([184,170,184,184,174,180,179],69), FormatJson(session))
    reg.Flush()
end sub
sub v4a24()
    if m.jglVStopped = true then return
    reg = CreateObject(q9([200,197,168,187,189,191,201,202,200,207,169,187,185,202,191,197,196],86), v4a18())
    reg.Delete(q9([145,131,145,145,135,141,140],30))
    reg.Delete(q9([155,144,162,163,129,148,144,164,163,151],47))
    reg.Flush()
end sub
function v4a25() as Object
    reg = CreateObject(q9([178,175,146,165,167,169,179,180,178,185,147,165,163,180,169,175,174],64), v4a18())
    if not reg.Exists(q9([196,182,196,196,186,192,191],81)) then return {}
    s = ParseJSON(reg.Read(q9([140,126,140,140,130,136,135],25)))
    if s = invalid then return {}
    return s
end function
function v4a26() as Boolean
    return IsValidStr(SafeStr(v4a25().userId))
end function
function v4a27() as Object
    s = v4a25()
    if IsValidStr(SafeStr(s.drmId)) and IsValidStr(SafeStr(s.reserve1))
        return { drmId: SafeStr(s.drmId), reserve1: SafeStr(s.reserve1) }
    end if
    di = CreateObject(q9([156,153,110,143,160,147,141,143,115,152,144,153],42))
    big   = v4a06(di.GetRandomUUID().Replace(q9([104],59), q9([],76)) + di.GetRandomUUID().Replace(q9([138],93), q9([],37)))
    small = v4a06(di.GetRandomUUID().Replace(q9([99],54), q9([],71)))
    asAscii = CreateObject(q9([202,199,154,209,204,189,153,202,202,185,209],88))
    asAscii.FromAsciiString(small.ToBase64String())
    id = { drmId: big.ToBase64String(), reserve1: v4a07(asAscii) }
    s[q9([132,146,141,105,132],32)]    = id.drmId
    s[q9([163,150,164,150,163,167,150,98],49)] = id.reserve1
    v4a23(s)
    return id
end function
function v4a28(tpl as String, vals as Object) as String
    out = tpl
    for each k in vals
        out = out.Replace(q9([206,206],83) + k + q9([152,152],27), vals[k])
    end for
    return out
end function
function v4a29() as Object
    return [q9([160,172,169,178,170,171,128,172,161,162],61), q9([177,182,175,188,188,179,186,145,189,178,179],78), q9([194,206,205,211,196,205,211,168,195],95), q9([154,140,153,144,140,154,106,150,149,155,140,149,155,112,139],39), q9([172,153,159],56), q9([191,170,181,190,174],73),
            q9([187,200,190,204,201,195,190,163,190],90), q9([138,145,149,150],34), q9([149,168,156,159,151],51), q9([183,178,152,179,175,169,178],68), q9([200,195],85)]
end function
function v4a30() as Object
    return [q9([128,140,137,146,138,139,102,129],29), q9([158,143,149,147],46)]
end function
function v4a31(args as Object) as Object
    s = v4a25()
    vals = {}
    vals[q9([178,173],63)]         = JsonEsc(SafeStr(s.sn))
    vals[q9([195,190,164,191,187,181,190],80)]    = JsonEsc(SafeStr(s.snToken))
    vals[q9([141,139,125,138,97,124],24)]     = JsonEsc(SafeStr(s.userId))
    vals[q9([158,156,142,155,125,152,148,142,151],41)]  = JsonEsc(SafeStr(s.userToken))
    vals[q9([170,169,172,174,155,166,125,169,158,159],58)] = JsonEsc(SafeStr(s.portalCode))
    vals[q9([175,189,184,148,175],75)]      = JsonEsc(SafeStr(s.drmId))
    vals[q9([206,193,207,193,206,210,193,141],92)]   = JsonEsc(SafeStr(s.reserve1))
    if args = invalid then return vals
    for each k in v4a29()
        if args[k] <> invalid then vals[k] = JsonEsc(SafeStr(args[k]))
    end for
    for each k in v4a30()
        if args[k] <> invalid then vals[k] = AsInt(args[k]).ToStr()
    end for
    return vals
end function
function v4a32(op as String, args as Object) as String
    k = v4a21()
    if k = invalid then return q9([],53)
    entry = k.ops[op]
    if entry = invalid then return q9([],70)
    return v4a04(v4a28(entry.tpl, v4a31(args)), k.key)
end function
function v4a33(op as String) as String
    k = v4a21()
    if k = invalid then return q9([],87)
    entry = k.ops[op]
    if entry = invalid then return q9([],31)
    return k.base + entry.path
end function
function v4a34() as Object
    di = CreateObject(q9([179,176,133,166,183,170,164,166,138,175,167,176],65))
    r1 = LCase(di.GetRandomUUID().Replace(q9([127],82), q9([],26)))
    r2 = LCase(di.GetRandomUUID().Replace(q9([88],43), q9([],60)))
    build = q9([],77)
    for i = 1 to 7
        d = Instr(1, q9([142,143,144,145,146,147,148,149,150,151,191,192,193,194,195,196],94), Mid(r2, i, 1)) - 1
        if d < 0 then d = 0
        build = build + (d mod 10).ToStr()
    end for
    return {
        androidId: Left(r1, 16),
        build:     build,
        host:      q9([135,136,140,135,152,147,83],38) + Mid(r1, 17, 8)
    }
end function
function v4a35() as Object
    return [q9([169,169,169,121,120,120,120,122,127],72), q9([186,186,186,138,137,137,137,139,145],89)]
end function
function v4a36(rc as String) as Boolean
    for each c in v4a35()
        if c = rc then return true
    end for
    k = v4a21()
    if k = invalid or k.reauthCodes = invalid then return false
    for each c in k.reauthCodes
        if SafeStr(c) = rc then return true
    end for
    return false
end function
function v4a37(rc as String) as Boolean
    if v4a36(rc) then return true
    reg = CreateObject(q9([164,161,132,151,153,155,165,166,164,171,133,151,149,166,155,161,160],50), v4a18())
    now = CreateObject(q9([181,178,135,164,183,168,151,172,176,168],67)).AsSeconds()
    last = 0
    if reg.Exists(q9([192,181,199,200,166,185,181,201,200,188],84)) then last = Int(Val(reg.Read(q9([136,125,143,144,110,129,125,145,144,132],28))))
    if now - last < 1800 then return false
    reg.Write(q9([153,142,160,161,127,146,142,162,161,149],45), now.ToStr())
    reg.Flush()
    return true
end function
