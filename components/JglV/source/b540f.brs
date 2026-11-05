function THEME_BG()          as String : return "0x1B1B27FF" : end function
function THEME_SURFACE()     as String : return "0x242430FF" : end function
function THEME_SURFACE2()    as String : return "0x30303EFF" : end function
function THEME_LINE()        as String : return "0x2B2D39FF" : end function
function THEME_RAIL()        as String : return "0x14151DFF" : end function
function THEME_TEXT()        as String : return "0xF4F6F8FF" : end function
function THEME_MUTED()       as String : return "0x9BA1ACFF" : end function
function THEME_MUTED2()      as String : return "0x6A7180FF" : end function
function THEME_ACCENT()      as String : return "0xE51522FF" : end function
function THEME_ACCENT_LT()   as String : return "0xFF5A64FF" : end function
function THEME_ACCENT2()     as String : return "0x4979FFFF" : end function
function THEME_LIVE()        as String : return "0xFF3B3BFF" : end function
function THEME_GREEN()       as String : return "0x37E08AFF" : end function
function THEME_GOLD()        as String : return "0xFFC53DFF" : end function
function THEME_ERR_BG()      as String : return "0x2A1614FF" : end function
function THEME_ERR_LINE()    as String : return "0x4A221CFF" : end function
function THEME_ERR_ICON()    as String : return "0xFF6A52FF" : end function
function ThemeFont(size as Integer, bold as Boolean) as Object
    if m.fontCache = invalid then m.fontCache = {}
    key = size.ToStr() + Tern(bold, "b", "r")
    if m.fontCache[key] <> invalid then return m.fontCache[key]
    f = CreateObject("roSGNode", "Font")
    if bold
        f.uri = "font:BoldSystemFontFile"
    else
        f.uri = "font:SystemFontFile"
    end if
    f.size = size
    m.fontCache[key] = f
    return f
end function
function TextW(s as String, size as Integer) as Integer
    return Int(Len(s) * size * 0.56)
end function
function RAIL_W_COLLAPSED() as Integer : return 300 : end function
function RAIL_W_EXPANDED()  as Integer : return 300 : end function
function Tern(cond as Boolean, a as Dynamic, b as Dynamic) as Dynamic
    if cond then return a
    return b
end function
function PROXY_PORT() as Integer : return 8888 : end function
function GRID_COLS()     as Integer : return 5   : end function
function GRID_GAP()      as Integer : return 22  : end function
function TILE_W()        as Integer : return 282 : end function
function CH_TILE_H()     as Integer : return 158 : end function
function POSTER_TILE_H() as Integer : return 350 : end function
function TILE_LABEL_H()  as Integer : return 54  : end function
function VISIBLE_ROWS()  as Integer : return 2   : end function
