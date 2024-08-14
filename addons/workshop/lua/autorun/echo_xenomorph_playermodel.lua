CreateConVar( "player_xenomorph_sounds", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY } ) 
CreateConVar( "player_xenomorph_footsteps", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY } ) 
CreateConVar( "player_xenomorph_viewheight", "1", { FCVAR_NOTIFY, FCVAR_ARCHIVE } )



player_manager.AddValidModel( "Xenomorph", "models/echo/xenomorph_pm.mdl" )
player_manager.AddValidHands( "Xenomorph", "models/weapons/c_arms_echosxenomorph.mdl", 0, "0"  )

sound.AddSoundOverrides( "lua/pm_xenomorph_sounds.lua" )
xenomorph_sound = "models/echo/xenomorph_pm.mdl"

hook.Add("PlayerDeathSound","xenomorph_PlayerDeathSound",function(ply,velocity)
	if GetConVarNumber( "player_xenomorph_sounds" ) == 1 then	
	if(ply:GetModel() == xenomorph_sound)then
		ply:EmitSound("playermodel_xenomorphs.die")
		return true
	end
end
end)

hook.Add("PlayerHurt","xenomorph_PlayerHurt",function(ply,velocity)
	if GetConVarNumber( "player_xenomorph_sounds" ) == 1 then	
	if(ply:GetModel() == xenomorph_sound)then
		ply:EmitSound("playermodel_xenomorphs.pain")
		return true
	end
end
end)
if SERVER then
hook.Add("PlayerFootstep","xenomorph_PlayerFootstep",function(ply,velocity)
if GetConVarNumber( "player_xenomorph_footsteps" ) == 1 and ply:Alive() then
	if(ply:GetModel () == xenomorph_sound)then
		ply:EmitSound("playermodel_xenomorphs.footsteps")
		return true
	end
end
end)
end
if CLIENT then
hook.Add("PlayerFootstep","mute_xenomorph_PlayerFootstep",function(ply,velocity)
if GetConVarNumber( "player_xenomorph_footsteps" ) == 1 and ply:Alive() then
	if(ply:GetModel () == xenomorph_sound)then
		ply:EmitSound("player/null.mp3")
		return true
	end
end
end)
end

hook.Add("PlayerSpawn",  "echos_xenomorph_Viewheight_Offset", function(ply)
	if not ply or not ply:IsValid() then return end
	if (ply:GetModel() == "models/echo/xenomorph_pm.mdl") then
	timer.Simple(0.1, function()
	if GetConVarNumber( "player_xenomorph_viewheight" ) == 1 then
	ply:SetViewOffset( Vector( 0, 0, 76 ) )
	ply:SetViewOffsetDucked( Vector( 0, 0, 29 ) )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 82 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 34 ) )
	end
	end)
else
	ply:SetViewOffset( Vector(0,0,64) )
	ply:SetViewOffsetDucked( Vector(0,0,28) )
	ply:SetHull( Vector( -16, -16, 0 ), Vector( 16, 16, 70 ) )
	ply:SetHullDuck( Vector( -16, -16, 0 ), Vector( 16, 16, 34 ) )
	end
end)

hook.Add("PreDrawPlayerHands", "c_arms_xenomorph", function(hands, vm, ply, wpn)
    if IsValid(hands) and hands:GetModel() == "models/weapons/c_arms_echosxenomorph.mdl" then
        hands:SetSkin(ply:GetSkin())
    end
end)