AddCSLuaFile()

SWEP.PrintName = "'Holdout' Pistol"
SWEP.Description = "Subsonic silenced rounds completely hide your aura."

SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFOV = 75
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "pistol"

SWEP.Tier = 3

SWEP.ViewModel = "models/weapons/c_deika_silencedpistol22.mdl"
SWEP.WorldModel = "models/weapons/w_deika_silencedpistol22.mdl"
SWEP.UseHands = true

SWEP.Primary.Sound = Sound("weapons/falloutnewvegas/silenced22/wpn_silenced22smg1.wav")
SWEP.Primary.Damage = 45
SWEP.Primary.Delay = 0.18

SWEP.NoDismantle = false

SWEP.Primary.ClipSize = 18
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

function SWEP:GetAuraRange()
	return 0
end

SWEP.ConeMax = 4
SWEP.ConeMin = 0.75

SWEP.IronSightsPos = Vector(-4.7, -1, 2.25)

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if ( self:Clip1() < 1 ) then 
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 2.3))
	else if ( self:Clip1() > 0 ) then
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 1.5))
	end
end
end 