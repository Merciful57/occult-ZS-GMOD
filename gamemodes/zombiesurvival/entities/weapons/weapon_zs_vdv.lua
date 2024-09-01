AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_base")

SWEP.PrintName = "'RPK-74' Assault Rifle"
SWEP.Description = "A powerful LMG that shoots faster and more accurate for every shot landed."

SWEP.Slot = 2
SWEP.SlotPos = 0



sound.Add(
{
	name = "Weapon_Scar.Single",
	channel = CHAN_WEAPON,
	volume = 1,
	level = 85,
	pitch = {85,90},
	sound = {"weapons/zs_scar/scar_fire1.ogg"}
})

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/c_ins2_rpk_74m.mdl"
SWEP.WorldModel = "models/weapons/w_ins2_rpk_74m.mdl"
SWEP.UseHands = true

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 80

	SWEP.ViewModelFlip = false
	SWEP.ShowViewModel = true
	SWEP.ShowWorldModel = true
  
  	SWEP.HUD3DBone = "ValveBiped.Bip01_R_Hand"
  	SWEP.HUD3DPos = Vector(5, 4, -5)
  	SWEP.HUD3DAng = Angle(0, 90, 270)
	SWEP.HUD3DScale = .015

  
	local WorldModel = ClientsideModel(SWEP.WorldModel)
	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

  	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(3.6, -1, -1.5)
			local offsetAng = Angle(180, 180, 0)
			
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

SWEP.Primary.Sound = Sound("Weapon_Scar.Single")
SWEP.Primary.Damage = 33
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 0.25

SWEP.Primary.ClipSize = 95
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "ar2"
GAMEMODE:SetupDefaultClip(SWEP.Primary)


SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_AR2

SWEP.ConeMax = 2
SWEP.ConeMin = 2

SWEP.WalkSpeed = SPEED_SLOW

SWEP.Tier = 6
SWEP.MaxStock = 1

SWEP.FireAnimSpeed = 0.65

SWEP.IronSightsPos = Vector(-2.935, -5, .2)

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 13)

function SWEP:SetHitStacks(stacks)
	self:SetDTInt(9, stacks)
end

function SWEP:GetHitStacks()
	return self:GetDTInt(9)
end

function SWEP:FinishReload()
	BaseClass.FinishReload(self)
end

function SWEP:GetCone()
	return BaseClass.GetCone(self) * (1 - self:GetHitStacks()/100)
end

function SWEP:GetFireDelay()
	local owner = self:GetOwner()
	if (self.Primary.Delay * (1 - self:GetHitStacks()/100)) > 0.06 then
		return self.Primary.Delay * (1 - self:GetHitStacks()/100) 
	elseif (self.Primary.Delay * (1 - self:GetHitStacks()/100)) < 0.07 then
		return 0.06
	end
end

function SWEP.BulletCallback(attacker, tr, dmginfo)
	local ent = tr.Entity
	if SERVER then
		local wep = attacker:GetActiveWeapon()
		if ent:IsValidZombie() and wep:GetHitStacks() < 101 then
			wep:SetHitStacks(wep:GetHitStacks() + 1)
		elseif not ent:IsValidZombie() and wep:GetHitStacks() > 0 then 
			wep:SetHitStacks(wep:GetHitStacks() - 1)
		end
	end
end
