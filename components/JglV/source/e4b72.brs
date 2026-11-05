function v4a01() as String : return "des-ede3" : end function
function v4a02(keyStr as String) as String
    if Len(keyStr) = 48 and v4a03(keyStr) then return LCase(keyStr)
    stripped = keyStr.Replace("-", "")
    rawBytes = CreateObject("roByteArray")
    rawBytes.FromBase64String(stripped)
    if rawBytes.Count() <> 24 then return ""
    return v4a07(rawBytes)
end function
function v4a03(s as String) as Boolean
    for i = 1 to Len(s)
        c = Mid(s, i, 1)
        isDigit = (c >= "0" and c <= "9")
        isLow   = (c >= "a" and c <= "f")
        isUp    = (c >= "A" and c <= "F")
        if not (isDigit or isLow or isUp) then return false
    end for
    return true
end function
function v4a04(jsonStr as String, keyStr as String) as String
    keyHex = v4a02(keyStr)
    if Len(keyHex) <> 48 then return ""
    cipher = CreateObject("roEVPCipher")
    if cipher = invalid then return ""
    if cipher.Setup(true, v4a01(), keyHex, "", 1) <> 0 then return ""
    plainBytes = CreateObject("roByteArray")
    plainBytes.FromAsciiString(jsonStr)
    encBytes = cipher.Process(plainBytes)
    if encBytes = invalid then return ""
    b64 = encBytes.ToBase64String()
    b64Bytes = CreateObject("roByteArray")
    b64Bytes.FromAsciiString(b64)
    return v4a07(b64Bytes)
end function
function v4a05(hexStr as String, keyStr as String) as String
    hexBytes = CreateObject("roByteArray")
    hexBytes.FromHexString(hexStr)
    if hexBytes.Count() = 0 then return ""
    b64 = hexBytes.ToAsciiString()
    encBytes = CreateObject("roByteArray")
    encBytes.FromBase64String(b64)
    keyHex = v4a02(keyStr)
    if Len(keyHex) <> 48 then return ""
    cipher = CreateObject("roEVPCipher")
    if cipher = invalid then return ""
    if cipher.Setup(false, v4a01(), keyHex, "", 1) <> 0 then return ""
    decBytes = cipher.Process(encBytes)
    if decBytes = invalid then return ""
    return decBytes.ToAsciiString()
end function
function v4a06(hex as String) as Object
    n = Len(hex)
    if n mod 2 <> 0 then return invalid
    ba = CreateObject("roByteArray")
    ba.SetResize(n / 2, true)
    for i = 0 to n - 1 step 2
        ba[i / 2] = Val("&H" + Mid(hex, i + 1, 2))
    end for
    return ba
end function
function v4a07(ba as Object) as String
    if ba = invalid then return ""
    valueType = Type(ba)
    if valueType = "String" or valueType = "roString"
        encoded = LCase(ba.ToStr())
        if Len(encoded) > 0 and Len(encoded) mod 2 = 0 and v4a03(encoded) then return encoded
        return ""
    end if
    hex = ""
    for i = 0 to ba.Count() - 1
        hex += Right("0" + StrI(ba[i], 16), 2)
    end for
    return hex
end function
function v4a08(value as String) as String
    bytes = CreateObject("roByteArray")
    bytes.FromAsciiString(value)
    digest = CreateObject("roEVPDigest")
    if digest = invalid or digest.Setup("sha256") <> 0 then return ""
    result = digest.Process(bytes)
    if result = invalid then return ""
    encoded = v4a07(result)
    if Len(encoded) <> 64 then return ""
    return encoded
end function
function v4a09() as Object
    return CreateObject("roRegistrySection", "RokuPlusJglVParental")
end function
function v4a10() as Boolean
    reg = v4a09()
    if reg.Exists("pin_hash") and reg.Exists("pin_salt") then return true
    if reg.Exists("adult_pin")
        oldPin = reg.Read("adult_pin")
        if Len(oldPin) = 4 then return v4a11(oldPin)
    end if
    return false
end function
function v4a11(pin as String) as Boolean
    if Len(pin) <> 4 then return false
    di = CreateObject("roDeviceInfo")
    salt = ""
    if di <> invalid then salt = di.GetRandomUUID().Replace("-", "")
    if salt = "" then return false
    hash = v4a08("jglcustoms|pin|v2|" + salt + "|" + pin)
    if hash = "" then return false
    reg = v4a09()
    reg.Write("pin_salt", salt)
    reg.Write("pin_hash", hash)
    reg.Write("pin_version", "2")
    if not reg.Flush() then return false
    if reg.Exists("adult_pin")
        reg.Delete("adult_pin")
        reg.Flush()
    end if
    return true
end function
function v4a12(pin as String) as Boolean
    if not v4a10() then return false
    reg = v4a09()
    expected = reg.Read("pin_hash")
    actual = v4a08("jglcustoms|pin|v2|" + reg.Read("pin_salt") + "|" + pin)
    return actual <> "" and actual = expected
end function
function v4a13() as Integer
    reg = v4a09()
    if not reg.Exists("lock_until") then return 0
    untilValue = Val(reg.Read("lock_until"))
    remain = untilValue - CreateObject("roDateTime").AsSeconds()
    if remain <= 0
        reg.Delete("lock_until") : reg.Delete("failed_count") : reg.Flush()
        return 0
    end if
    return remain
end function
function v4a14() as Integer
    reg = v4a09()
    count = 0
    if reg.Exists("failed_count") then count = Val(reg.Read("failed_count"))
    count = count + 1
    if count >= 5
        reg.Write("lock_until", (CreateObject("roDateTime").AsSeconds() + 30).ToStr())
        count = 0
    end if
    reg.Write("failed_count", count.ToStr())
    reg.Flush()
    return v4a13()
end function
sub v4a15()
    if m.jglVStopped = true then return
    reg = v4a09()
    reg.Delete("failed_count") : reg.Delete("lock_until") : reg.Flush()
end sub
