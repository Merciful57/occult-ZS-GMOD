AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "Ripper"
SWEP.Description = "A relatively simple SMG with a decent fire rate and reload speed."

SWEP.Slot = 2
SWEP.SlotPos = 0

if CLIENT then
	SWEP.HUD3DBone = "bolt001"
	SWEP.HUD3DPos = Vector(4, 0, -0.5)
		SWEP.HUD3DAng = Angle(90, 0, 0)

	SWEP.HUD3DScale = 0.02

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/razorswep/weapons/v_smg_rippe.mdl"
SWEP.WorldModel = "models/razorswep/weapons/w_smg_rippe.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.Primary.Sound = Sound("razorswep/ripper/fire.wav")
SWEP.Primary.Damage = 22
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.065
SWEP.Primary.ClipSize = 32

SWEP.Tier = 5
SWEP.MaxStock = 2

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

--SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1

SWEP.ReloadSpeed = 1.25
SWEP.FireAnimSpeed = 0.55

SWEP.ConeMax = 4.5
SWEP.ConeMin = 2.5

SWEP.IronSightsPos = Vector(1, 1, 1)	


--Crotch Gun Fix
SWEP.Offset = {
Pos = {
Up = 0,
Right = 1,
Forward = -3,
},
Ang = {
Up = 0,
Right = 0,
Forward = 180,
}
}

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/ripper/clipout.wav"
instbl["name"] = "Weapon_RIPPE.Clipout"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/ripper/magdrop.wav"
instbl["name"] = "magdrop"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/ripper/clipin.wav"
instbl["name"] = "Weapon_RIPPE.Clipin"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/ripper/boltpull.wav"
instbl["name"] = "Weapon_RIPPE.Boltpull"

sound.Add(instbl)

local instbl = {}
instbl["channel"] = "3"
instbl["level"] = "75"
instbl["volume"] = "1.0"
instbl["CompatibilityAttenuation"] = "1"
instbl["pitch"] = "95,105"
instbl["sound"] = "razorswep/ripper/deploy.wav"
instbl["name"] = "evo.draw"

sound.Add(instbl)
