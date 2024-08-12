AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:GetNPCRestTimes()
	return 0, 0
end

function SWEP:GetNPCBurstSettings()
	return 1, 1, 1
end

function SWEP:GetNPCBulletSpread()
	return 1 -- we handle this manually, in calculate cone, recoil and shootbullet
end
