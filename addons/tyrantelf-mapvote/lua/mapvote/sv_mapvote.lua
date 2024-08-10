util.AddNetworkString("RAM_MapVoteStart")
util.AddNetworkString("RAM_GMVoteStart")
util.AddNetworkString("RAM_MapVoteUpdate")
util.AddNetworkString("RAM_MapVoteCancel")
util.AddNetworkString("RTV_Delay")

MapVote.Continued = false

net.Receive("RAM_MapVoteUpdate", function(len, ply)
	if (MapVote.Allow) then
		if (IsValid(ply)) then
			local update_type = net.ReadUInt(3)
			
			if (update_type == MapVote.UPDATE_VOTE) then
				local map_id = net.ReadUInt(32)
				
				if (MapVote.CurrentOptions[map_id]) then
					MapVote.Votes[ply:SteamID()] = map_id
					
					net.Start("RAM_MapVoteUpdate")
						net.WriteUInt(MapVote.UPDATE_VOTE, 3)
						net.WriteEntity(ply)
						net.WriteUInt(map_id, 32)
					net.Broadcast()
				end
			end
		end
	end
end)

if file.Exists( "mapvote/recentmaps.txt", "DATA" ) then
	recentmaps = util.JSONToTable(file.Read("mapvote/recentmaps.txt", "DATA"))
else
	recentmaps = {}
end

if file.Exists( "mapvote/config.txt", "DATA" ) then
	MapVote.Config = util.JSONToTable(file.Read("mapvote/config.txt", "DATA"))
else
	MapVote.Config = {}
end

local function CoolDownDoStuff()
	cooldownnum = MapVote.Config.MapsBeforeRevote or 3

	if table.getn(recentmaps) == cooldownnum then 
		table.remove(recentmaps)
	end

	local curmap = game.GetMap():lower()

	if not table.HasValue(recentmaps, curmap) then
		table.insert(recentmaps, 1, curmap)
	end

	file.Write("mapvote/recentmaps.txt", util.TableToJSON(recentmaps))
end

local function StartChangeLevel(map, gamemode)
	timer.Simple(4, function()
		if (hook.Run("MapVoteChange", map) ~= false) then
			if (callback) then
				callback(map)
			else
				-- if map requires another gamemode then switch to it
				if (gamemode and gamemode ~= engine.ActiveGamemode()) then
					RunConsoleCommand("gamemode", gamemode)
				end
				RunConsoleCommand("changelevel", map)
			end
		end
	end)
end

local function MapVoteStart(gamemode, length, current, limit, prefix)
	current = current or MapVote.Config.AllowCurrentMap or false
	length = length or MapVote.Config.TimeLimit or 28
	limit = limit or MapVote.Config.MapLimit or 24
	cooldown = MapVote.Config.EnableCooldown or MapVote.Config.EnableCooldown == nil and true
	prefix = prefix or MapVote.Config.MapPrefixes
	-- local autoGamemode = autoGamemode or MapVote.Config.AutoGamemode or MapVote.Config.AutoGamemode == nil and true

	local is_expression = false

	-- file.Read("mapvote/recentmaps.txt", "DATA")

	local shouldFindMaps = true
	local maps = {}

	local customMaplist = file.Read("mapvote/maplist_" .. gamemode .. ".txt", "DATA")

	if customMaplist then
		shouldFindMaps = false
		maps = string.Split(customMaplist, "\n")
	elseif not prefix or MapVote.Config.VoteGamemode then // Auto prefixes if enabled gamemode voting
		local info = file.Read("gamemodes/"..gamemode.."/"..gamemode..".txt", "GAME")

		if (info) then
			local info = util.KeyValuesToTable(info)
			if (info.fretta_maps) then
				prefix = info.fretta_maps
				for k, v in pairs(prefix) do
					prefix[k] = "^" .. v
				end
			else
				prefix = string.Split(info.maps, "|")
			end
		else
			error("MapVote Prefix can not be loaded from gamemode")
		end

		is_expression = true
	else
		if prefix and type(prefix) ~= "table" then
			prefix = {prefix}
		end
	end

	if (shouldFindMaps) then
		local amt = 0
		for k, map in pairs(file.Find("maps/*.bsp", "GAME")) do
			local mapstr = map:sub(1, -5):lower()

			local valid = false

			if is_expression then
				for k, v in pairs(prefix) do
					if (string.match(map, v)) then -- This might work (from gamemode.txt)
						valid = true
						amt = amt + 1
						break
					end
				end
			else
				for k, v in pairs(prefix) do
					if string.match(map, "^"..v) then
						valid = true
						amt = amt + 1
						break
					end
				end
			end

			if (valid) then
				table.insert(maps, mapstr)
			end
		end
	end

	// Re-parse maps
	for k, v in pairs(maps) do
		maps[k] = string.Trim(v)
	end

	// Get random maps from maps list

	local vote_maps = {}
	local vote_maps_recent = {}

	local amt = 0

	for k, mapstr in RandomPairs(maps) do
		if (not current and game.GetMap():lower() == mapstr) then continue end
		local recent = cooldown and table.HasValue(recentmaps, mapstr)

		if not recent then vote_maps[#vote_maps + 1] = mapstr end
		vote_maps_recent[#vote_maps_recent + 1] = mapstr

		amt = amt + 1
		
		if (limit and amt >= limit) then break end
	end

	if #vote_maps == 0 then vote_maps = vote_maps_recent end

	// Dont even vote if there's only one map
	if #vote_maps == 1 then
		StartChangeLevel(vote_maps[1], gamemode)
		return
	end

	net.Start("RAM_MapVoteStart")
		net.WriteUInt(#vote_maps, 32)
		
		for i = 1, #vote_maps do
			net.WriteString(vote_maps[i])
		end
		
		net.WriteUInt(length, 32)
	net.Broadcast()
	
	MapVote.Allow = true
	MapVote.CurrentOptions = vote_maps
	MapVote.Votes = {}
	
	timer.Create("RAM_MapVote", length, 1, function()
		MapVote.Allow = false
		local map_results = {}
		
		for k, v in pairs(MapVote.Votes) do
			if (not map_results[v]) then
				map_results[v] = 0
			end
			
			for k2, v2 in pairs(player.GetAll()) do
				if (v2:SteamID() == k) then
					if (MapVote.HasExtraVotePower(v2)) then
						map_results[v] = map_results[v] + 2
					else
						map_results[v] = map_results[v] + 1
					end
				end
			end
			
		end
		
		CoolDownDoStuff()

		local winner = table.GetWinningKey(map_results) or 1
		
		net.Start("RAM_MapVoteUpdate")
			net.WriteUInt(MapVote.UPDATE_WIN, 3)
			
			net.WriteUInt(winner, 32)
		net.Broadcast()
		
		local map = MapVote.CurrentOptions[winner]

		// We're assuming the current gamemode is the maps too
		-- if (autoGamemode) then
		-- 	-- check if map matches a gamemode's map pattern
		-- 	for k, gm in pairs(engine.GetGamemodes()) do
		-- 		-- ignore empty patterns
		-- 		if (gm.maps and gm.maps ~= "") then
		-- 			-- patterns are separated by "|"
		-- 			for k2, pattern in pairs(string.Split(gm.maps, "|")) do
		-- 				if (string.match(map, pattern)) then
		-- 					gamemode = gm.name
		-- 					break
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end
		
		StartChangeLevel(map, gamemode)
	end)
end

function MapVote.Start(length, current, limit, prefix, callback)
	length = length or MapVote.Config.TimeLimit or 28
	local voteGamemode = MapVote.Config.VoteGamemode or MapVote.Config.VoteGamemode == nil and true
	local whitelistGamemodes = MapVote.Config.GamemodesWhitelist or MapVote.Config.GamemodesWhitelist == nil and true
	local voteGamemodes = MapVote.Config.GamemodesToVote or {}

	local gamemode = engine.ActiveGamemode()

	if (not voteGamemode) then
		MapVoteStart(gamemode, length, current, limit, prefix, callback)
	else
		local candidate_gamemodes = {}

		for k, v in pairs(voteGamemodes) do
			if (isstring(v)) then
				table.insert(candidate_gamemodes, v)
			else
				if v.min and player.GetCount() < v.min then
					continue
				end
				if v.max and player.GetCount() > v.max then
					continue
				end
				table.insert(candidate_gamemodes, v.gamemode)
			end
		end

		local gamemodes_vote = {}
		local gamemodes_info = {}

		for k, v in pairs(engine.GetGamemodes()) do
			local info = file.Read("gamemodes/"..v.name.."/"..v.name..".txt", "GAME")
			if (info) then
				gamemodes_info[v.name] = util.KeyValuesToTable(info)
			end

			if (whitelistGamemodes) then
				if (table.HasValue(candidate_gamemodes, v.name)) then
					table.insert(gamemodes_vote, v.name)
				end
			else
				if (v.menusystem) then // Experimental
					table.insert(gamemodes_vote, v.name)
				end
			end
		end

		net.Start("RAM_GMVoteStart")
			net.WriteUInt(#gamemodes_vote, 32)
			
			for i = 1, #gamemodes_vote do
				net.WriteString(gamemodes_vote[i])
				net.WriteString(gamemodes_info[gamemodes_vote[i]].title or gamemodes_vote[i])
			end
			
			net.WriteUInt(length, 32)
		net.Broadcast()
		
		MapVote.Allow = true
		MapVote.CurrentOptions = gamemodes_vote
		MapVote.Votes = {}

		timer.Create("RAM_MapVote", length, 1, function()
			MapVote.Allow = false
			local gm_results = {}
			
			for k, v in pairs(MapVote.Votes) do
				if (not gm_results[v]) then
					gm_results[v] = 0
				end
				
				for k2, v2 in pairs(player.GetAll()) do
					if (v2:SteamID() == k) then
						if (MapVote.HasExtraVotePower(v2)) then
							gm_results[v] = gm_results[v] + 2
						else
							gm_results[v] = gm_results[v] + 1
						end
					end
				end
				
			end

			local winner = table.GetWinningKey(gm_results) or 1
			
			net.Start("RAM_MapVoteUpdate")
				net.WriteUInt(MapVote.UPDATE_WIN, 3)
				
				net.WriteUInt(winner, 32)
			net.Broadcast()
			
			gamemode = MapVote.CurrentOptions[winner]

			// We're assuming the current gamemode is the maps too
			-- if (autoGamemode) then
			-- 	-- check if map matches a gamemode's map pattern
			-- 	for k, gm in pairs(engine.GetGamemodes()) do
			-- 		-- ignore empty patterns
			-- 		if (gm.maps and gm.maps ~= "") then
			-- 			-- patterns are separated by "|"
			-- 			for k2, pattern in pairs(string.Split(gm.maps, "|")) do
			-- 				if (string.match(map, pattern)) then
			-- 					gamemode = gm.name
			-- 					break
			-- 				end
			-- 			end
			-- 		end
			-- 	end
			-- end
			
			timer.Simple(4, function()
				MapVoteStart(gamemode, length, current, limit, prefix, callback)
			end)
		end)
	end

end

hook.Add("Shutdown", "RemoveRecentMaps", function()
	if file.Exists( "mapvote/recentmaps.txt", "DATA" ) then
		file.Delete( "mapvote/recentmaps.txt" )
	end
end)

function MapVote.Cancel()
	if MapVote.Allow then
		MapVote.Allow = false

		net.Start("RAM_MapVoteCancel")
		net.Broadcast()

		timer.Destroy("RAM_MapVote")
	end
end
