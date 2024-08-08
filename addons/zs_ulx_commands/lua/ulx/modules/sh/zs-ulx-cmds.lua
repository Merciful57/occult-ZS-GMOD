local category = GetGlobalString( "zs-ulx-cmds_category", "Zombie Survival" )


-- save the player's position and return a function that restores it
local function SavePlayerPositon( player )
	local pos, vel, ang = player:GetPos(), player:GetVelocity(), player:EyeAngles()

	return function()
		player:SetPos( pos )
		player:SetEyeAngles( ang )

		timer.Simple( 0, function() player:SetVelocity( vel ) end )
	end
end


function ulx.redeem( caller, targets, inPlace )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			local restorePos = SavePlayerPositon( target )

			local lastSpawned = target.SpawnedTime

			target:Redeem()

			-- Redeem will update SpawnedTime if it succeeded
			if lastSpawned ~= target.SpawnedTime then
				table.insert( affected, target )

				if inPlace then restorePos() end
			end
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A redeemed #T", affected )
end

local redeem = ulx.command( category, "ulx redeem", ulx.redeem, "!redeem" )
redeem:addParam{ type = ULib.cmds.PlayersArg }
redeem:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
redeem:defaultAccess( ULib.ACCESS_ADMIN )
redeem:help( "Redeem target(s)" )


function ulx.forceboss( caller, targets, inPlace, silent )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			local restorePos = SavePlayerPositon( target )

			gamemode.Call( "SpawnBossZombie", target, silent )

			if inPlace then restorePos() end

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A forced #T to be boss", affected )
end

local forceboss = ulx.command( category, "ulx forceboss", ulx.forceboss, "!forceboss" )
forceboss:addParam{ type = ULib.cmds.PlayersArg }
forceboss:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
forceboss:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "silent", ULib.cmds.optional }
forceboss:defaultAccess( ULib.ACCESS_ADMIN )
forceboss:help( "Respawn target(s) as boss" )


function ulx.forceclass( caller, targets, className, inPlace )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() == TEAM_UNDEAD then
			local restorePos = SavePlayerPositon( target )

			-- set zombie class and respawn
			target:SetZombieClassName( className )
			target:UnSpectateAndSpawn()

			if inPlace then restorePos() end

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " isn't a zombie!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A forced #T to be #s", affected, className )
end


local TeamLookup = { zombies = TEAM_UNDEAD, humans = TEAM_SURVIVOR }
function ulx.forceteam( caller, targets, teamName )
	local affected = {}

	local teamIndex = TeamLookup[ teamName ]
	for i = 1, #targets do
		local target = targets[ i ]

		if target:Team() ~= teamIndex then
			target:SetTeam( teamIndex )

			table.insert( affected, target )
		end
	end

	ulx.fancyLogAdmin( caller, "#A made #T join #s", affected, team.GetName( teamIndex ) )
end

local forceteam = ulx.command( category, "ulx forceteam", ulx.forceteam, "!forceteam" )
forceteam:addParam{ type = ULib.cmds.PlayersArg }
forceteam:addParam{ type = ULib.cmds.StringArg, hint = "team name", completes = { "zombies", "humans" }, ULib.cmds.restrictToCompletes }
forceteam:defaultAccess( ULib.ACCESS_ADMIN )
forceteam:help( "Make target(s) join the specified team without respawning" )


function ulx.respawn( caller, targets, inPlace, asTeam )
	asTeam = asTeam ~= "" and asTeam or nil

	local teamIndex = TeamLookup[ asTeam ]
	for i = 1, #targets do
		local target = targets[ i ]

		local restorePos = SavePlayerPositon( target )

		if asTeam and target:Team() ~= teamIndex then
			target:SetTeam( teamIndex )
		end

		target:UnSpectateAndSpawn()
		-- DoHulls isn't called for humans
		target:DoHulls()

		if inPlace then restorePos() end
	end

	ulx.fancyLogAdmin( caller, "#A respawned #T" .. ( asTeam and " as #s" or "" ), targets, team.GetName( teamIndex ) )
end

local respawn = ulx.command( category, "ulx respawn", ulx.respawn, "!respawn" )
respawn:addParam{ type = ULib.cmds.PlayersArg }
respawn:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
respawn:addParam{ type = ULib.cmds.StringArg, hint = "as team", completes = { "zombies", "humans" }, ULib.cmds.restrictToCompletes, ULib.cmds.optional }
respawn:defaultAccess( ULib.ACCESS_ADMIN )
respawn:help( "Respawn target(s)" )


function ulx.waveactive( caller, active )
	if active ~= gamemode.Call( "GetWaveActive" ) then
		gamemode.Call( "SetWaveActive", active )

		ulx.fancyLogAdmin( caller, "#A #s the wave", active and "started" or "ended" )
	end
end

local waveactive = ulx.command( category, "ulx waveactive", ulx.waveactive, "!waveactive" )
waveactive:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "active" }
waveactive:defaultAccess( ULib.ACCESS_ADMIN )
waveactive:help( "Start or end the wave" )


function ulx.wavetime( caller, time )
	time = time * 60

	if time > 0 then
		gamemode.Call(
			gamemode.Call( "GetWaveActive" ) and "SetWaveEnd" or "SetWaveStart",
			CurTime() + time
		);

		ulx.fancyLogAdmin( caller, "#A set time until wave start/end to #s", ULib.secondsToStringTime( time ) )
	else
		local active = not gamemode.Call( "GetWaveActive" )
		gamemode.Call( "SetWaveActive", active )

		ulx.fancyLogAdmin( caller, "#A #s the wave", active and "started" or "ended" )
	end
end

local wavetime = ulx.command( category, "ulx wavetime", ulx.wavetime, "!wavetime" )
wavetime:addParam{ type = ULib.cmds.NumArg, hint = "time (0 starts/ends wave)", max = 60, ULib.cmds.allowTimeString }
wavetime:defaultAccess( ULib.ACCESS_ADMIN )
wavetime:help( "Set time until wave start/end" )


function ulx.givepoints( caller, targets, points )
	for i = 1, #targets do
		local target = targets[ i ]
		-- AddPoints does way more than just adding points
		-- set the points directly instead
		target:SetPoints( target:GetPoints() + points )
	end

	ulx.fancyLogAdmin( caller, "#A gave #i points to #T", points, targets )
end

local givepoints = ulx.command( category, "ulx givepoints", ulx.givepoints, "!givepoints" )
givepoints:addParam{ type = ULib.cmds.PlayersArg }
givepoints:addParam{ type = ULib.cmds.NumArg, hint = "points" }
givepoints:defaultAccess( ULib.ACCESS_ADMIN )
givepoints:help( "Give points to target(s)" )


function ulx.giveweapon( caller, targets, weapon, giveAmmo )
	local affected = {}

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Alive() then
			target:Give( weapon, not giveAmmo )

			table.insert( affected, target )
		else
			ULib.tsayError( caller, target:Nick() .. " is dead!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A gave #s to #T", weapon, targets )
end


local AmmoLookup = {}

do
	local GAMEMODE = gmod.GetGamemode()
	if GAMEMODE and GAMEMODE.AmmoNames then
		for class, name in pairs( GAMEMODE.AmmoNames ) do
			AmmoLookup[ name ] = class
		end
	end
end

function ulx.giveammo( caller, targets, ammo, amount )
	local affected = {}

	local ammoType = AmmoLookup[ ammo ]

	for i = 1, #targets do
		local target = targets[ i ]

		if target:Alive() then
			local result = target:GiveAmmo( amount, ammoType, true )
			if result and result > 0 then
				table.insert( affected, target )
			end
		else
			ULib.tsayError( caller, target:Nick() .. " is dead!", true )
		end
	end

	ulx.fancyLogAdmin( caller, "#A gave #i #s ammo to #T", amount, ammo, affected )
end


-- these commands depend on data that doesn't exist until the gamemode is fully loaded
hook.Add( "Initialize", "zs_ulx_cmds",
	function()
		local GAMEMODE = gmod.GetGamemode()

		TeamLookup = { zombies = TEAM_UNDEAD, humans = TEAM_SURVIVOR }

		local forceclassCompletes
		if GAMEMODE.ZombieClasses then
			forceclassCompletes = {}

			for k in pairs( GAMEMODE.ZombieClasses ) do
				if isstring( k ) then
					table.insert( forceclassCompletes, k )
				end
			end
		end

		local forceclass = ulx.command( category, "ulx forceclass", ulx.forceclass, "!forceclass" )
		forceclass:addParam{ type = ULib.cmds.PlayersArg }
		forceclass:addParam{ type = ULib.cmds.StringArg, hint = "class", completes = forceclassCompletes, ULib.cmds.restrictToCompletes }
		forceclass:addParam{ type = ULib.cmds.BoolArg, default = false, hint = "respawn in place", ULib.cmds.optional }
		forceclass:defaultAccess( ULib.ACCESS_ADMIN )
		forceclass:help( "Respawn target(s) as the specified class" )


		local weaponClasses = {}
		for _, tbl in pairs( weapons.GetList() ) do
			table.insert( weaponClasses, tbl.ClassName )
		end

		local giveweapon = ulx.command( category, "ulx giveweapon", ulx.giveweapon, "!giveweapon" )
		giveweapon:addParam{ type = ULib.cmds.PlayersArg }
		giveweapon:addParam{ type = ULib.cmds.StringArg, hint = "weapon class name", completes = weaponClasses, ULib.cmds.restrictToCompletes }
		giveweapon:addParam{ type = ULib.cmds.BoolArg, default = true, hint = "give ammo", ULib.cmds.optional }
		giveweapon:defaultAccess( ULib.ACCESS_ADMIN )
		giveweapon:help( "Give weapon to target(s)" )


		local ammoClasses = {}
		if GAMEMODE.AmmoNames then
			for class, name in pairs( GAMEMODE.AmmoNames ) do
				AmmoLookup[ name ] = class
				table.insert( ammoClasses, name )
			end
		end

		local giveammo = ulx.command( category, "ulx giveammo", ulx.giveammo, "!giveammo" )
		giveammo:addParam{ type = ULib.cmds.PlayersArg }
		giveammo:addParam{ type = ULib.cmds.StringArg, hint = "ammo type", completes = ammoClasses, ULib.cmds.restrictToCompletes }
		giveammo:addParam{ type = ULib.cmds.NumArg, hint = "amount", min = 1 }
		giveammo:defaultAccess( ULib.ACCESS_ADMIN )
		giveammo:help( "Give target(s) ammo" )
	end
)
