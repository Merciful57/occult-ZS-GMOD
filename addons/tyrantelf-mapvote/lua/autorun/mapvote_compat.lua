hook.Add( "Initialize", "AutoMapVoteCompat", function()
	local GAMEMODE_NAME = engine.ActiveGamemode()
	if SERVER then
		local gmInfo = {}
		local info = file.Read("gamemodes/"..GAMEMODE_NAME.."/"..GAMEMODE_NAME..".txt", "GAME")
		if (info) then
			gmInfo = util.KeyValuesToTable(info)
		else
			print("Gamemode info can't be loaded")
		end

		
		-- This is a relatively standard next map thing
		-- Covers awesomestrike, zombiesurvival, stalker, gmtower standalone
		hook.Add("LoadNextMap", "MAPVOTE", function()
			MapVote.Start()
			return true
		end)
		

		-- Fretta gamemodes, or fretta based
		if GAMEMODE_NAME == "extremefootballthrowdown" or GAMEMODE_NAME == "garryware13" or GAMEMODE_NAME == "dogfightarcade" or (gmInfo.base and (gmInfo.base == "fretta13" or gmInfo.base == "fretta"))
		or fretta_voting or GAMEMODE_NAME == "prop_hunt" then
			function GAMEMODE:StartGamemodeVote()
				MapVote.Start()
			end
		end

		if GAMEMODE_NAME == "terrortown" then
			if TTT2 then
				hook.Add("TTT2LoadNextMap", "MAPVOTE", function(nextmap, roundsLeft, timeLeft)
					MapVote.Start()
					return true
				end)
			else
				// Better solution:
				game.OldLoadNextMap = game.OldLoadNextMap or game.LoadNextMap
				game.LoadNextMap = function()
					MapVote.Start()
				end
			end
		end

		if GAMEMODE_NAME == "deathrun" then
			function RTV.Start()
				MapVote.Start()
			end
		end

		if GAMEMODE_NAME == "morbusgame" or string.find(GAMEMODE_NAME, "morbusgame") then // Multiple check made because of variations
			hook.Add("Morbus_MapChange", "A_MAPVOTEMB", function()
				MapVote.Start()

				return true // stop other hooks
			end)

			// Remove original mapvote
			hook.Remove("Morbus_MapChange", "SMV_MapHook")
			if (SMV) then
				function RTV(ply)
				end
				function SMV.StartMapVote()
				end
				function SMV.EndMapVote()
				end
			end
		end


		if GAMEMODE_NAME == "ultimatechimerahunt" then
			function StartMapVote()
				MapVote.Start()
			end
		end

		if GAMEMODE_NAME == "infectedwars" then
			function GAMEMODE:LoadNextMap(map)
				MapVote.Start()
			end
		end

		if GAMEMODE_NAME == "stronghold" then
			function GAMEMODE:EnableVotingSystem()
				MapVote.Start()
			end
		end

		if GAMEMODE_NAME == "thehidden" then
			hook.Remove("Think", "RTV Think")
			concommand.Remove("hdn_start_rtv") // This is a debug variable that doesn't have any checks? Better stop it before anything wrong happens

			RTV = MapVote.RTV // Re-override RTV system
		end

		if GAMEMODE_NAME == "murder" then
			function GAMEMODE:ChangeMap()
				MapVote.Start()
			end
		end

		-- TODO: Test
		if GAMEMODE_NAME == "melonbomber" then
			local maxRounds = 10
			GAMEMODE.OldEndRound = GAMEMODE.OldEndRound or GAMEMODE.EndRound
			GAMEMODE.TotalRounds = GAMEMODE.TotalRounds or 0
			function GAMEMODE:EndRound(reason, winner)
				self.TotalRounds = self.TotalRounds + 1

				if self.TotalRounds >= maxRounds then
					self.GameEnded = true
				end
				self:OldEndRound(reason, winner)
				if self.GameEnded then
					self.MapVoting = false
				end
			end

			GAMEMODE.OldNetworkMapList = GAMEMODE.OldNetworkMapList or GAMEMODE.NetworkMapList
			function GAMEMODE:NetworkMapList()
				if not self.GameEnded then self:OldNetworkMapList() end
			end

			GAMEMODE.OldSetGameState = GAMEMODE.OldSetGameState or GAMEMODE.SetGameState
			function GAMEMODE:SetGameState(state)
				if not self.GameEnded then self:OldSetGameState(state) end
			end
		end

		if GAMEMODE_NAME == "flood" then
			local maxRounds = 4
			GAMEMODE.OldSetGameState = GAMEMODE.OldSetGameState or GAMEMODE.SetGameState
			GAMEMODE.TotalRounds = GAMEMODE.TotalRounds or 0
			function GAMEMODE:SetGameState(state)
				if state == 0 then
					self.TotalRounds = self.TotalRounds + 1
				end
				self:OldSetGameState(state)

				if self.TotalRounds >= maxRounds then
					self.LastRound = true
				end
			end

			GAMEMODE.OldResetPhase = GAMEMODE.OldResetPhase or GAMEMODE.ResetPhase
			function GAMEMODE:ResetPhase()
				if self.LastRound then
					if Flood_resetTime <= 0 then
						if not self.MapVoting then
							self.MapVoting = true
							MapVote.Start()
						end
					else
						Flood_resetTime = Flood_resetTime -1
					end
				else
					self:OldResetPhase()
				end
			end
		end

		if GAMEMODE_NAME == "melonracer" then
			local maxRounds = 8
			GAMEMODE.OldNewMatch = GAMEMODE.OldNewMatch or GAMEMODE.NewMatch
			GAMEMODE.TotalRounds = GAMEMODE.TotalRounds or 0
			function GAMEMODE:NewMatch(wait)
				self.TotalRounds = self.TotalRounds or 0

				if self.TotalRounds >= maxRounds then
					MapVote.Start()
				else
					self:OldNewMatch(wait)
				end
			end
		end
	else
		if GAMEMODE_NAME == "stronghold" then
			function GAMEMODE:EnableVotingSystem()
				// Do nothing
			end
		end
	end
end )
