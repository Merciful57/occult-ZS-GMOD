AddCSLuaFile()

SWEP.Base = "weapon_zs_base"

SWEP.PrintName = "'Blunderbuss' Shotgun"
SWEP.Description = "This is the weapon of choice for demonic horde killers everywhere."

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DPos = Vector(4, -3.5, -1.2)
	SWEP.HUD3DAng = Angle(90, 0, -30)
	SWEP.HUD3DScale = 0.02
	SWEP.HUD3DBone = "SS.Grip.Dummy"
end

SWEP.Slot = 3

SWEP.HoldType = "shotgun"

SWEP.ViewModel = "models/weapons/rarri/v_newlandpattern.mdl"
SWEP.WorldModel = "models/weapons/rarri/w_newlandpattern.mdl"
SWEP.UseHands = false

SWEP.Undroppable = true

SWEP.Primary.Sound = Sound("weapons/musket/musket_fire_9.wav")
SWEP.Primary.Damage = 4
SWEP.Primary.NumShots = 45
SWEP.Primary.Delay = 0.1

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "buckshot"
GAMEMODE:SetupDefaultClip(SWEP.Primary)
SWEP.NoDismantle = true
SWEP.AllowQualityWeapons = false

SWEP.ConeMax = 12
SWEP.ConeMin = 8


GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.344)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.172)

SWEP.WalkSpeed = SPEED_SLOWER

SWEP.ReloadSound = Sound("weapons/pistol/pistol_reload.wav")
