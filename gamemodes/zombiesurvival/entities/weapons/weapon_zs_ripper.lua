AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'Ripper' Sub Machine Gun"
SWEP.Description = "A high fire rate SMG with a decent mag."

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
SWEP.Primary.Damage = 27
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.065
SWEP.Primary.ClipSize = 32

SWEP.Tier = 6
SWEP.MaxStock = 1

SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.ReloadSpeed = 1.20
SWEP.FireAnimSpeed = 0.55

SWEP.ConeMax = 3.5
SWEP.ConeMin = 2

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Ripper' Assault Rifle", "Ues assault rifle ammo shoots slower but deals more damage.", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 1.3 
	wept.Primary.Delay = 0.085
	wept.Primary.Ammo = "ar2"
	wept.ConeMax = 3.0
	wept.ConeMin = 1.5
end)

SWEP.IronSightsPos = Vector(1, 1, 1)	

if CLIENT then
local WorldModel = ClientsideModel(SWEP.WorldModel)

-- Settings...
WorldModel:SetSkin(1)
WorldModel:SetNoDraw(true)

function SWEP:DrawWorldModel()
local _Owner = self:GetOwner()

if (IsValid(_Owner)) then
            -- Specify a good position
local offsetVec = Vector(-.5, -1, -1)
local offsetAng = Angle(0, 0, 180)

local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
if !boneid then return end

local matrix = _Owner:GetBoneMatrix(boneid)
if !matrix then return end

local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

WorldModel:SetPos(newPos)
WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
else
WorldModel:SetPos(self:GetPos())
WorldModel:SetAngles(self:GetAngles())
end

WorldModel:DrawModel()
end
end

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

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if ( self:Clip1() < 1 ) then 
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 2.3))
	else if ( self:Clip1() > 0 ) then
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 1.7))
	end
end
end 
