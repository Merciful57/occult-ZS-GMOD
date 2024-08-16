local PLAYER = FindMetaTable('Player')
PLAYER.ONick = PLAYER.ONick or PLAYER.Nick --для получения 'старого ника'
TableNick = TableNick or {} --чистить таблицу не надо всё равно максимум возможных значений 128 (так же зависит от макс игроков, но резерв 128.)
local Index = FindMetaTable('Entity').EntIndex
function PLAYER:Nick()
    return TableNick[Index(self)] or self:ONick()
end

PLAYER.GetName = PLAYER.Nick
PLAYER.Name = PLAYER.Nick
if CLIENT then
    net.Receive('PLAYER.Nick', function()
        local id = net.ReadUInt(7) + 1 -- лимит 7-ми битов 127 по этому на сервере мы отняли 1 что бы 1 стал 0 и т.д
        local name = net.ReadString()
        TableNick[id] = name
    end)

    local util_JSONToTable = util.JSONToTable
    net.Receive('PLAYER.Nick_Fix', function() TableNick = util_JSONToTable(net.ReadString()) end)
    local color_dead = Color(255, 30, 40)
    local color_team = Color(30, 160, 40)
    local str_dead = "*DEAD* "
    local str_team = "(TEAM) "
    local bit_band = bit.band
    hook.Add('OnPlayerChat', 'ChatCommand2', function(pl, str, tm, dead)
        local tab = {}
        if dead then
            tab[#tab + 1] = color_dead
            tab[#tab + 1] = str_dead
        end

        if tm then
            tab[#tab + 1] = color_team
            tab[#tab + 1] = str_team
        end

        if IsValid(pl) then
            tab[#tab + 1] = team.GetColor(pl:Team())
            tab[#tab + 1] = pl:Nick()
        else
            tab[#tab + 1] = "Console"
        end

        local filter_context = TEXT_FILTER_GAME_CONTENT
        if bit_band(GetConVarNumber("cl_chatfilters"), 64) ~= 0 then filter_context = TEXT_FILTER_CHAT end
        tab[#tab + 1] = color_white
        tab[#tab + 1] = ": " .. util.FilterText(str, filter_context, IsValid(pl) and pl or nil)
        chat.AddText(unpack(tab))
        return true
    end)
end

if SERVER then
    util.AddNetworkString('PLAYER.Nick')
    util.AddNetworkString('PLAYER.Nick_Fix')
    function PLAYER:SetNick(name) -- на сервере сразу заносим в таблицу 
        TableNick[Index(self)] = name
        net.Start('PLAYER.Nick')
        net.WriteUInt(Index(self) - 1, 7) -- 0-127 -=-
        net.WriteString(name)
        net.Broadcast() --отправляем всем
        WriteNickSQL(self:SteamID(), name)
    end

    function PLAYER:RNick() -- менял ли игрок ник хоть раз
        return TableNick[Index(self)] and true or false
    end

    local util_TableToJSON = util.TableToJSON
    hook.Add('PlayerAuthed', 'PLAYER.Nick', function(pl, steam)
        net.Start('PLAYER.Nick_Fix')
        net.WriteString(util_TableToJSON(TableNick))
        net.Send(pl) --тут отправляем все ники игроку.
    end)

    hook.Add("PlayerInitialSpawn", "AnnounceConnection", function(pl)
        local name = ReadNickSQL(pl:SteamID())
        if not name then --не будем сохранять оригинальный ник, зачем?
            return
        end

        pl:SetNick(name) --тут отправляет всем ник игрока
    end)

    local sql_SQLStr = sql.SQLStr
    local sql_QueryValue = sql.QueryValue
    local sql_Query = sql.Query
    sql_Query("CREATE TABLE IF NOT EXISTS player_Name ( SteamID TEXT, Name TEXT )")
    function WriteNickSQL(steam, name)
        local data = sql_Query("SELECT * FROM player_Name WHERE SteamID = " .. sql_SQLStr(steam) .. ";")
        if data then
            sql_Query("UPDATE player_Name SET Name = " .. sql_SQLStr(name) .. " WHERE SteamID = " .. sql_SQLStr(steam) .. ";")
        else
            sql_Query("INSERT INTO player_Name ( SteamID, Name ) VALUES( " .. sql_SQLStr(steam) .. ", " .. sql_SQLStr(name) .. " )")
        end
    end

    function ReadNickSQL(steam)
        return sql_QueryValue("SELECT Name FROM player_Name WHERE SteamID = " .. sql_SQLStr(steam) .. ";")
    end
end