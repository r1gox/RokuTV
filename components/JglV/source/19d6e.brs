function Hardware_Decode(di as Object, spec as Object) as Dynamic
    if di = invalid then return invalid
    answer = di.CanDecodeVideo(spec)
    if answer = invalid or answer.result = invalid then return invalid
    return (answer.result = true)
end function
function Hardware_YesNo(value as Dynamic) as String
    if value = invalid then return "No determinado"
    if value = true then return "Sí"
    return "No"
end function
function Hardware_Mark(value as Dynamic) as String
    if value = invalid then return "?"
    if value = true then return "✓"
    return "✕"
end function
function Hardware_CodecLabel(raw as Dynamic) as String
    value = LCase(SafeStr(raw)).Replace("_", " ").Replace("-", " ")
    if value = "" or value = "unknown" or value = "none" then return ""
    if Instr(1, value, "hevc") > 0 or Instr(1, value, "h265") > 0 or Instr(1, value, "h.265") > 0 then return "H.265/HEVC"
    if Instr(1, value, "avc") > 0 or Instr(1, value, "h264") > 0 or Instr(1, value, "h.264") > 0 or Instr(1, value, "mpeg4 10") > 0 or Instr(1, value, "mpeg4 15") > 0 then return "H.264/AVC"
    if Instr(1, value, "mpeg2") > 0 or Instr(1, value, "mpeg 2") > 0 then return "MPEG-2"
    if Instr(1, value, "av1") > 0 then return "AV1"
    if Instr(1, value, "vp9") > 0 then return "VP9"
    if Instr(1, value, "mpeg4 2") > 0 or Instr(1, value, "mpeg 4 part 2") > 0 then return "MPEG-4 Part 2"
    return ""
end function
function Hardware_CodecFromMetadata(data as Dynamic) as String
    if data = invalid or GetInterface(data, "ifAssociativeArray") = invalid then return ""
    for each key in ["videoCodec", "video_codec", "vCodec", "videoEncoding", "videoFormat", "videoCoding"]
        label = Hardware_CodecLabel(data[key])
        if label <> "" then return label
    end for
    for each key in ["videoInfo", "videoTrack", "technicalInfo", "mediaInfo"]
        nested = data[key]
        if nested <> invalid and GetInterface(nested, "ifAssociativeArray") <> invalid
            label = Hardware_CodecFromMetadata(nested)
            if label <> "" then return label
        end if
    end for
    return ""
end function
function Hardware_CodecSupported(info as Object, codecLabel as String) as Dynamic
    if info = invalid or codecLabel = "" then return invalid
    if codecLabel = "H.264/AVC" then return info.avc
    if codecLabel = "H.265/HEVC" then return info.hevc
    if codecLabel = "MPEG-2" then return info.mpeg2
    if codecLabel = "AV1" then return info.av1
    return invalid
end function
function Hardware_Detect() as Object
    di = CreateObject("roDeviceInfo")
    if di = invalid then return { modelName: "Roku no determinado", model: "", videoMode: "No determinado" }
    details = di.GetModelDetails()
    display = di.GetDisplayProperties()
    model = SafeStr(di.GetModel())
    displayName = SafeStr(di.GetModelDisplayName())
    vendor = ""
    modelNumber = ""
    if details <> invalid
        vendor = SafeStr(details.VendorName)
        modelNumber = SafeStr(details.ModelNumber)
    end if
    modelName = displayName
    if vendor <> "" and Instr(1, LCase(modelName), LCase(vendor)) = 0 then modelName = vendor + " " + modelName
    if modelName = ""
        if vendor <> "" then modelName = vendor + " Roku" else modelName = "Roku " + model
    end if
    avc = Hardware_Decode(di, { "codec": "mpeg4 avc" })
    hevc = Hardware_Decode(di, { "codec": "hevc" })
    avc720 = Hardware_Decode(di, { "codec": "mpeg4 avc", "profile": "high", "level": "4.1", "width": 1280, "height": 720 })
    avc1080 = Hardware_Decode(di, { "codec": "mpeg4 avc", "profile": "high", "level": "4.1", "width": 1920, "height": 1080 })
    hevcMain1080 = Hardware_Decode(di, { "codec": "hevc", "profile": "main", "level": "4.1", "width": 1920, "height": 1080 })
    hevcMain4k = Hardware_Decode(di, { "codec": "hevc", "profile": "main", "level": "5.1", "width": 3840, "height": 2160 })
    hevc10 = Hardware_Decode(di, { "codec": "hevc", "profile": "main 10", "level": "5.1", "width": 3840, "height": 2160 })
    mpeg2 = Hardware_Decode(di, { "codec": "mpeg2", "width": 1920, "height": 1080 })
    av1 = Hardware_Decode(di, { "codec": "av1", "profile": "main", "level": "5.1", "width": 3840, "height": 2160 })
    hdr10 = invalid : hlg = invalid : dolbyVision = invalid : hdr10Plus = invalid
    if display <> invalid
        hdr10 = display.Hdr10
        hlg = display.HLG
        dolbyVision = display.DolbyVision
        hdr10Plus = display.Hdr10Plus
    end if
    os = di.GetOSVersion()
    osText = "No determinado"
    if os <> invalid
        osText = SafeStr(os.major) + "." + SafeStr(os.minor) + "." + SafeStr(os.revision) + " build " + SafeStr(os.build)
    end if
    return {
        model: model, modelName: modelName, modelNumber: modelNumber,
        modelType: SafeStr(di.GetModelType()), os: osText,
        videoMode: SafeStr(di.GetVideoMode()), display: display,
        avc: avc, hevc: hevc, avc720: avc720, avc1080: avc1080,
        hevcMain1080: hevcMain1080, hevcMain4k: hevcMain4k, hevcMain10: hevc10,
        mpeg2: mpeg2, av1: av1,
        hdr10: hdr10, hdr10Plus: hdr10Plus, hlg: hlg, dolbyVision: dolbyVision
    }
end function
function Hardware_Summary(info as Object) as String
    if info = invalid then return "Hardware no determinado"
    name = SafeStr(info.modelName)
    if name = "" then name = "Roku " + SafeStr(info.model)
    mode = SafeStr(info.videoMode)
    if mode = "" then mode = "No determinado"
    return name + "  ·  H.264 " + Hardware_Mark(info.avc) + "  ·  HEVC " + Hardware_Mark(info.hevc) + "  ·  " + mode
end function
function Hardware_DetailText(info as Object, currentFormat as String) as String
    if info = invalid then return "Información de hardware no determinada."
    t = "Modelo:             " + SafeStr(info.modelName) + " [" + SafeStr(info.model) + "]" + Chr(10)
    t = t + "Modelo específico:  " + SafeStr(info.modelNumber) + "   Tipo: " + SafeStr(info.modelType) + Chr(10)
    t = t + "Roku OS:            " + SafeStr(info.os) + "   Salida: " + SafeStr(info.videoMode) + Chr(10)
    t = t + "H.264: 720p " + Hardware_YesNo(info.avc720) + " · 1080p " + Hardware_YesNo(info.avc1080) + Chr(10)
    t = t + "HEVC Main: 1080p " + Hardware_YesNo(info.hevcMain1080) + " · 4K " + Hardware_YesNo(info.hevcMain4k) + Chr(10)
    t = t + "HEVC Main 10: " + Hardware_YesNo(info.hevcMain10) + "   MPEG-2: " + Hardware_YesNo(info.mpeg2) + "   AV1: " + Hardware_YesNo(info.av1) + Chr(10)
    t = t + "HDR10: " + Hardware_YesNo(info.hdr10) + " · HDR10+: " + Hardware_YesNo(info.hdr10Plus) + " · HLG: " + Hardware_YesNo(info.hlg) + " · Dolby Vision: " + Hardware_YesNo(info.dolbyVision) + Chr(10)
    if currentFormat = "" then currentFormat = "No determinado (sin reproducción activa)"
    return t + "Formato detectado del video actual: " + currentFormat
end function
