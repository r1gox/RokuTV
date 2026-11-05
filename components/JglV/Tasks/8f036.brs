sub init()
    m.jglVStopped = false
    m.top.functionName = "RunSrt"
end sub
sub RunSrt()
    if m.jglVStopped = true then return
    url = m.top.url
    if url = invalid or url = "" then
        m.top.cues = []
        return
    end if
    tmp = "tmp:/rokuplus_jglv_srt_" + Str(Rnd(2147483647)).Trim() + ".srt"
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.InitClientCertificates()
    xfer.SetUrl(url)
    ok = xfer.GetToFile(tmp)
    ba = CreateObject("roByteArray")
    if ok = 200 and ba.ReadFile(tmp)
        text = BytesToUtf8(ba)
    else
        text = xfer.GetToString()
    end if
    if text = invalid or text = "" then
        m.top.cues = []
        return
    end if
    m.top.cues = ParseSrt(text)
end sub
function BytesToUtf8(ba as Object) as String
    n = ba.Count()
    start = 0
    if n >= 3 and ba[0] = 239 and ba[1] = 187 and ba[2] = 191 then start = 3
    if IsValidUtf8(ba, start)
        if start = 0 then return ba.ToAsciiString()
        sub_ = CreateObject("roByteArray")
        for i = start to n - 1
            sub_.Push(ba[i])
        end for
        return sub_.ToAsciiString()
    end if
    out = CreateObject("roByteArray")
    for i = start to n - 1
        b = ba[i]
        if b < 128
            out.Push(b)
        else
            EncodeUtf8(out, Cp1252(b))
        end if
    end for
    return out.ToAsciiString()
end function
sub EncodeUtf8(out as Object, cp as Integer)
    if m.jglVStopped = true then return
    if cp < 128
        out.Push(cp)
    else if cp < 2048
        out.Push(192 + Int(cp / 64))
        out.Push(128 + (cp mod 64))
    else
        out.Push(224 + Int(cp / 4096))
        out.Push(128 + (Int(cp / 64) mod 64))
        out.Push(128 + (cp mod 64))
    end if
end sub
function IsValidUtf8(ba as Object, start as Integer) as Boolean
    n = ba.Count()
    i = start
    while i < n
        b = ba[i]
        if b < 128
            i = i + 1
        else if b >= 194 and b <= 223
            if i + 1 >= n or ba[i+1] < 128 or ba[i+1] > 191 then return false
            i = i + 2
        else if b >= 224 and b <= 239
            if i + 2 >= n then return false
            if ba[i+1] < 128 or ba[i+1] > 191 then return false
            if ba[i+2] < 128 or ba[i+2] > 191 then return false
            i = i + 3
        else
            return false
        end if
    end while
    return true
end function
function Cp1252(b as Integer) as Integer
    special = {
      "128": 8364, "130": 8218, "131": 402, "132": 8222, "133": 8230,
      "134": 8224, "135": 8225, "136": 710, "137": 8240, "138": 352,
      "139": 8249, "140": 338, "142": 381, "145": 8216, "146": 8217,
      "147": 8220, "148": 8221, "149": 8226, "150": 8211, "151": 8212,
      "152": 732, "153": 8482, "154": 353, "155": 8250, "156": 339,
      "158": 382, "159": 376 }
    v = special[b.ToStr()]
    if v <> invalid then return v
    return b
end function
function ParseSrt(text as String) as Object
    cues = []
    blockRx = CreateObject("roRegex", "\r?\n\r?\n+", "")
    lineRx  = CreateObject("roRegex", "\r?\n", "")
    tsRx    = CreateObject("roRegex", "(\d+):(\d+):(\d+)[,.](\d+)\s*-->\s*(\d+):(\d+):(\d+)[,.](\d+)", "")
    tagRx   = CreateObject("roRegex", "<[^>]+>|\{[^}]*\}", "")
    blocks = blockRx.Split(text)
    for each block in blocks
        cue = ParseBlock(block, lineRx, tsRx, tagRx)
        if cue <> invalid then cues.Push(cue)
    end for
    return cues
end function
function ParseBlock(block as Dynamic, lineRx as Object, tsRx as Object, tagRx as Object) as Dynamic
    if block = invalid or Len(block) = 0 then return invalid
    lines = lineRx.Split(block)
    tsIdx = -1
    for i = 0 to lines.Count() - 1
        if Instr(1, lines[i], "-->") > 0 then
            tsIdx = i
            exit for
        end if
    end for
    if tsIdx < 0 then return invalid
    mm = tsRx.Match(lines[tsIdx])
    if mm.Count() < 9 then return invalid
    startS = HmsToSec(mm[1], mm[2], mm[3], mm[4])
    endS   = HmsToSec(mm[5], mm[6], mm[7], mm[8])
    if endS <= startS then return invalid
    txt = ""
    for j = tsIdx + 1 to lines.Count() - 1
        ln = lines[j]
        if ln <> invalid and Len(ln) > 0
            if txt <> "" then txt = txt + Chr(10)
            txt = txt + ln
        end if
    end for
    txt = tagRx.ReplaceAll(txt, "")
    if txt = "" then return invalid
    return { s: startS, e: endS, t: txt }
end function
function HmsToSec(h as String, mn as String, s as String, ms as String) as Float
    return Val(h) * 3600.0 + Val(mn) * 60.0 + Val(s) + Val(ms) / 1000.0
end function
