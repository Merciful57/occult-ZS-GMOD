AddCSLuaFile()

SWEP.PrintName = "'M9a1' Pistol"
SWEP.Description = "High fire rate, less damage."
SWEP.Slot = 1
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70


end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "revolver"

SWEP.ViewModel = "models/weapons/tfa_ins2/c_beretta.mdl"
SWEP.WorldModel = "models/weapons/tfa_ins2/w_m9.mdl"
SWEP.UseHands = true

SWEP.CSMuzzleFlashes = false

SWEP.Primary.Sound = Sound("weapons/tfa_ins2/m9/fire_"..math.random(1, 3)..".wav")
SWEP.Primary.Delay = 0.22
SWEP.Primary.Damage = 48
SWEP.Primary.NumShots = 1

SWEP.Primary.ClipSize = 16
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
GAMEMODE:SetupDefaultClip(SWEP.Primary)

SWEP.WalkSpeed = SPEED_SLOW

SWEP.ConeMax = 3.25
SWEP.ConeMin = 1.35

SWEP.Tier = 4

SWEP.IronSightsPos = Vector(-4.65, 4, 0.25)
SWEP.IronSightsAng = Vector(0, 0, 1)

--SWEP.WallDivide = 6

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_SPREAD, -0.468)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MIN_SPREAD, -0.306)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.005, 1)


function SWEP:ProcessReloadEndTime()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if ( self:Clip1() < 1 ) then 
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 2.9))
	else if ( self:Clip1() > 0 ) then
		self:SetReloadFinish(CurTime() + (self.ReloadSpeed * 2.45))
	end
end
end 

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(4, -1, -2)
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