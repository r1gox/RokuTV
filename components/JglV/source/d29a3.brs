function BuildQueryString(params as Object) as String
    parts = []
    for each key in params
        parts.push(key + "=" + EncodeUrl(params[key].toStr()))
    end for
    return parts.join("&")
end function
function EncodeUrl(str as String) as String
    encoded = ""
    for i = 0 to Len(str) - 1
        c = Mid(str, i + 1, 1)
        code = Asc(c)
        if (code >= 48 and code <= 57) or (code >= 65 and code <= 90) or (code >= 97 and code <= 122) or c = "-" or c = "_" or c = "." or c = "~"
            encoded += c
        else
            encoded += "%" + Right("0" + StrI(code, 16), 2).Upper()
        end if
    end for
    return encoded
end function
function GetDeviceId() as String
    devInfo = CreateObject("roDeviceInfo")
    return devInfo.GetChannelClientId()
end function
function GetAppVersion() as String
    return "1.0.0"
end function
function IsValidStr(s as Dynamic) as Boolean
    return s <> invalid and Type(s) = "String" and s <> ""
end function
function SafeStr(val as Dynamic) as String
    if val = invalid then return ""
    return val.ToStr()
end function
function CanPlayVod() as Boolean
    m.hevcOk = true
    return true
end function
function HevcDetalle() as String
    di = CreateObject("roDeviceInfo")
    out = "codec="
    a = di.CanDecodeVideo({ "Codec": "hevc" })
    if a <> invalid and a.Result = true then out = out + "si" else out = out + "no"
    out = out + "  codec+ts="
    b = di.CanDecodeVideo({ "Codec": "hevc", "Container": "ts" })
    if b <> invalid and b.Result = true then out = out + "si" else out = out + "no"
    return out
end function
