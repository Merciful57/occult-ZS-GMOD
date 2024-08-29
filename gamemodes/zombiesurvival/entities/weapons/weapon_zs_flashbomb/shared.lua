SWEP.PrintName = "'Flash' Grenade"
SWEP.Description = "Deals no damage but stuns all zombies around the flash, especially if they're looking at it."

SWEP.Base = "weapon_zs_basethrown"

SWEP.ViewModel = "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel = "models/weapons/w_eq_flashbang.mdl"

SWEP.Primary.Ammo = "flashbomb"
SWEP.Primary.Sound = Sound("weapons/pinpull.wav")

function SWEP:Precache()
	util.PrecacheSound("weapons/pinpull.wav")
end
