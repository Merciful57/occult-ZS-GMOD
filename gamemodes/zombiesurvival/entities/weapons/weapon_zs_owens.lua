AddCSLuaFile()

SWEP.PrintName = "'Owens' Pistol"
SWEP.Description = "A somewhat less accurate pistol that fires two shots that deal respectable total damage."

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.HUD3DBone = "ValveBiped.square"
	SWEP.HUD3DPos = Vector(1.1, 0.25, -2)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.Primary.Sound = Sound("Weapon_Pistol.NPC_Single")
SWEP.Primary.Damage = 14.2
SWEP.Primary.NumShots = 2
SWEP.Primary.Delay = 0.2

SWEP.Primary.ClipSize = 10
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.ClipMultiplier = 12/10
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.NoDismantle = true

SWEP.ReloadSpeed = 0.7

SWEP.ConeMax = 16
SWEP.ConeMin = 0.5

SWEP.IronSightsPos = Vector(-5.95, 3, 2.75)
SWEP.IronSightsAng = Vector(-0.15, -1, 2)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.46, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.22, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.0175, 1)

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if ( self:Clip1() < 1 ) then 
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 3))
	else if ( self:Clip1() > 0 ) then
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 2))
	end
end
end
