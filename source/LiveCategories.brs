' Categories use source groups or specific broadcaster identities, not audiences.
function rpLiveCategories() as object
    return [{id:"all",label:"Todos"},{id:"sports",label:"Fútbol y deportes"},{id:"kids",label:"Infantil"},{id:"news",label:"Noticias"},{id:"movies",label:"Cine y series"},{id:"music",label:"Música"},{id:"documentary",label:"Documentales"},{id:"other",label:"Otros"}]
end function

function rpLiveCategoryMatch(item as dynamic, category as string) as boolean
    if type(item) <> "roAssociativeArray" then return false
    if category = "all" then return true
    group = lcase(orbitText(item.group,200))
    id = lcase(orbitText(item.id,180))
    title = lcase(orbitText(item.title,200))
    if category = "sports"
        if instr(1,group,"sport") > 0 or instr(1,group,"deport") > 0 then return true
        return CreateObject("roRegex","(espn|tudn|tycsports|foxsports|p[x]?sports|aymsports|winsports|clarosports|goltv|dsports)","i").isMatch(id)
    end if
    if category = "kids"
        if instr(1,id,"adultswim") > 0 or instr(1,title,"adult swim") > 0 then return false
        if instr(1,group,"kids") > 0 or instr(1,group,"infantil") > 0 then return true
        return CreateObject("roRegex","(discoverykids|disneychannel|disneyjunior|disneyjr|nickjr|nickelodeon|cartoonito|cartoonnetwork|babytv)","i").isMatch(id)
    end if
    if category = "news" then return instr(1,group,"news") > 0 or instr(1,group,"notic") > 0
    if category = "movies" then return instr(1,group,"movie") > 0 or instr(1,group,"series") > 0 or instr(1,group,"cine") > 0 or instr(1,group,"películ") > 0
    if category = "music" then return instr(1,group,"music") > 0 or instr(1,group,"músic") > 0
    if category = "documentary" then return instr(1,group,"document") > 0
    if category = "other"
        for each known in ["sports","kids","news","movies","music","documentary"]
            if rpLiveCategoryMatch(item,known) then return false
        end for
        return true
    end if
    return false
end function

function rpLiveCategoryItems(items as dynamic, category as dynamic) as object
    result = []
    if type(items) <> "roArray" then return result
    selected = orbitText(category,32)
    valid = false
    for each definition in rpLiveCategories()
        if definition.id = selected then valid = true
    end for
    if not valid then selected = "all"
    for each item in items
        if rpLiveCategoryMatch(item,selected) then result.push(item)
    end for
    return result
end function
