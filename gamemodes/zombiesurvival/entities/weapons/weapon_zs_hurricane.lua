AddCSLuaFile()

SWEP.PrintName = "'Fusion' Pulse SMG"
SWEP.Description = "Fires rapid pulse shots that slow targets."

if CLIENT then
	SWEP.Slot = 2
	SWEP.SlotPos = 0

	SWEP.HUD3DBone = "ValveBiped.base"
	SWEP.HUD3DPos = Vector(2.2, -0.85, 1)
	SWEP.HUD3DScale = 0.02

	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60

	SWEP.VElements = {
		["fence1++"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.831, 2.2, -4.65), angle = Angle(83.9, 170, 180), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["extra++++"] = { type = "Model", model = "models/props_lab/powerbox02a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.597, 0.23, -4.276), angle = Angle(0, 171.817, 180), size = Vector(0.046, 0.046, 0.046), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["extra+++"] = { type = "Model", model = "models/props_lab/teleportgate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.54, -0.219, -4.2), angle = Angle(180, -31.559, 87.662), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["extra"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.635, 1.299, -2.597), angle = Angle(-3.507, -104.027, 5.843), size = Vector(0.041, 0.041, 0.021), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["extra++"] = { type = "Model", model = "models/props_lab/labpart.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.558, 1.1, -5.715), angle = Angle(-57.273, 97.013, -87.663), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["extra+"] = { type = "Model", model = "models/props_lab/teleportgate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-2.54, 0.699, -4.2), angle = Angle(-180, 31.558, -87.663), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery"] = { type = "Model", model = "models/props_combine/combine_window001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 2.596, -3.636), angle = Angle(0, 92.337, 85.324), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery+"] = { type = "Model", model = "models/items/battery.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-1.558, 0.758, -4.137), angle = Angle(-1.17, -99.351, -85.325), size = Vector(0.291, 0.591, 0.49), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["fence1+"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(8.831, 2.2, -4.65), angle = Angle(83.9, 170, 180), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}

	SWEP.WElements = {
		["fence1++"] = { type = "Model", model = "models/props_combine/combine_fence01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.869, 1.557, -7.792), angle = Angle(80.649, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["extra"] = { type = "Model", model = "models/props_combine/combinethumper002.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.597, -2.597), angle = Angle(-3.507, 87.662, 0), size = Vector(0.052, 0.052, 0.032), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["battery"] = { type = "Model", model = "models/props_combine/combine_window001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(7.791, 1.557, -5.715), angle = Angle(0, -104.027, -99.351), size = Vector(0.029, 0.029, 0.029), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
		["fence1+"] = { type = "Model", model = "models/props_combine/combine_fence01b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.869, 1.557, -7.792), angle = Angle(80.649, 0, 0), size = Vector(0.07, 0.07, 0.07), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end

sound.Add(
{
	name = "Weapon_Hurricane.Single",
	channel = CHAN_WEAPON,
	volume = 0.7,
	soundlevel = 100,
	pitch = {70,80},
	sound = {"weapons/ar2/fire1.wav"}
})

SWEP.Base = "weapon_zs_base"
DEFINE_BASECLASS("weapon_zs_base")

SWEP.HoldType = "smg"

SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.ReloadSound = Sound("Weapon_SMG1.Reload")
SWEP.Primary.Sound = Sound("Weapon_Hurricane.Single")
SWEP.Primary.Damage = 14.5
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.09

SWEP.Primary.ClipSize = 40
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pulse"
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.TracerName = "AR2Tracer"

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SMG1

SWEP.ReloadSpeed = 0.9

SWEP.ConeMax = 4.3
SWEP.ConeMin = 2.5

SWEP.WalkSpeed = SPEED_NORMAL

SWEP.Tier = 2

SWEP.PointsMultiplier = GAMEMODE.PulsePointsMultiplier

SWEP.IronSightsPos = Vector(-6.425, 5, 1.02)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.5375, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.3125, 1)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1, 1)
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "'Typhusion' Pulse SMG", "Less damage, more accuracy, and gains damage if spooled", function(wept)
	wept.Primary.Damage = wept.Primary.Damage * 0.82
	wept.Primary.Delay = wept.Primary.Delay * 2.3
	wept.ConeMax = wept.ConeMax * 0.5
	wept.ConeMin = wept.ConeMin * 0.7

	wept.GetFireDelay = function(self) return BaseClass.GetFireDelay(self) - (self:GetDTFloat(9) * 0.15) end
	wept.ShootBullets = function(self, dmg, numbul, cone)
		dmg = dmg + dmg * self:GetDTFloat(9) * 0.6

		BaseClass.ShootBullets(self, dmg, numbul, cone)
	end

	wept.Think = function(self)
		if self:GetReloadFinish() == 0 and self:GetOwner():KeyDown(IN_ATTACK) then
			self:SetDTFloat(9, math.min(self:GetDTFloat(9) + FrameTime() * 0.12, 1))
		else
			self:SetDTFloat(9, math.max(0, self:GetDTFloat(9) - FrameTime() * 0.5))
		end

		BaseClass.Think(self)
	end
end)

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then
		ent:AddLegDamageExt(3.6, attacker, attacker:GetActiveWeapon(), SLOWTYPE_PULSE)
	end

	if IsFirstTimePredicted() then
		util.CreatePulseImpactEffect(tr.HitPos, tr.HitNormal)
	end
end

function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if ( self:Clip1() < 1 ) then 
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 1.3))
	else if ( self:Clip1() > 0 ) then
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 1.1))
	end
end
end 
