AddCSLuaFile()
DEFINE_BASECLASS("weapon_zs_shotgun")

SWEP.PrintName = "'Slavianka' Rifle"
SWEP.Description = "The iron sights have worn down after 135 years, you cannot aim with this rifle."

SWEP.Slot = 3
SWEP.SlotPos = 0

if CLIENT then
	SWEP.ViewModelFlip = false

	SWEP.HUD3DBone = "v_weapon.scout_Parent"
	SWEP.HUD3DPos = Vector(-1, -2.75, -6)
	SWEP.HUD3DAng = Angle(0, 0, 0)
	SWEP.HUD3DScale = 0.015
end

SWEP.Base = "weapon_zs_base"

SWEP.HoldType = "ar2"

SWEP.ViewModel = "models/weapons/v_mosin_tannenberg.mdl"
SWEP.WorldModel = "models/weapons/w_tanneberg_mosin.mdl"
SWEP.UseHands = true

SWEP.ReloadSound = Sound("weapons/tfa_tannenberg_mosin_nagant_1891/kar98_magin.wav")
SWEP.Primary.Sound = Sound("weapons/tfa_tannenberg_mosin_nagant_1891/mosin1891_fp.wav")
SWEP.Primary.Damage = 25
SWEP.Primary.NumShots = 1
SWEP.Primary.Delay = 2
SWEP.ReloadDelay = 0.7

SWEP.Primary.ClipSize = 6
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "357"
SWEP.Primary.DefaultClip = 25
SWEP.NoDismantle = true
SWEP.AllowQualityWeapons = false

SWEP.Pierces = 6
SWEP.Penetration = 1

SWEP.Primary.Gesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW
SWEP.ReloadGesture = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN

SWEP.ConeMax = 0.4
SWEP.ConeMin = 0.4

SWEP.IronSightsPos = Vector(5.015, -8, 2.52)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WalkSpeed = SPEED_SLOW
SWEP.PumpActivity = ACT_VM_PULLBACK_LOW


function SWEP:SendWeaponAnimation()
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

	timer.Simple(0.35, function()
		if IsValid(self) then
			self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
			self:GetOwner():GetViewModel():SetPlaybackRate(self.FireAnimSpeed)

			if CLIENT and self:GetOwner() == MySelf then
				self:EmitSound("weapons/m3/m3_pump.wav", 65, 100, 0.4, CHAN_AUTO)
			end
		end
	end)
end

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_CLIP_SIZE, 1)


if CLIENT then
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 70
end


function SWEP:Reload()
	if not self:IsReloading() and self:CanReload() then
		self:StartReloading()
	end
end

function SWEP:Think()
	if self:ShouldDoReload() then
		self:DoReload()
	end

	self:NextThink(CurTime())
	return true
end

function SWEP:StartReloading()
	local delay = self:GetReloadDelay()
	self:SetDTFloat(3, CurTime() + delay)
	self:SetDTBool(2, true) 
	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:GetOwner():DoReloadEvent()

	if self.ReloadStartActivity then
		self:ProcessReloadAnim()
	end
	
	if CLIENT and self:GetOwner() == MySelf then
		self:EmitSound("weapons/tfa_tannenberg_mosin_nagant_1891/mosin_boltback.wav", 65, 100, 0.4, CHAN_AUTO)
	end
	
end

function SWEP:StopReloading()
	self:SetDTFloat(3, 0)
	self:SetDTBool(2, false)
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay * 0.75)
	self:SendWeaponAnim(ACT_VM_IDLE)
	
	if CLIENT and self:GetOwner() == MySelf then
		self:EmitSound("weapons/tfa_tannenberg_mosin_nagant_1891/mosin_boltforward.wav", 65, 100, 0.4, CHAN_AUTO)
	end
	
end

function SWEP:DoReload()
	if not self:CanReload() or self:GetOwner():KeyDown(IN_ATTACK) or not self:GetDTBool(2) and not self:GetOwner():KeyDown(IN_RELOAD) then
		self:StopReloading()
		return
	end

	local delay = self:GetReloadDelay()
	if self.ReloadActivity then
	end
	if self.ReloadSound then
		self:EmitSound(self.ReloadSound)
	end
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self:GetOwner():RemoveAmmo(1, self.Primary.Ammo, false)
	self:SetClip1(self:Clip1() + 1)

	self:SetDTBool(2, false)
	self:SetDTFloat(3, CurTime() + delay)

	self:SetNextPrimaryFire(CurTime() + math.max(self.Primary.Delay, delay))
end

function SWEP:ProcessReloadAnim()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	if not self.DontScaleReloadSpeed then
		self:GetOwner():GetViewModel():SetPlaybackRate(reloadspeed)
	end
end

function SWEP:GetReloadDelay()
	local reloadspeed = self.ReloadSpeed * self:GetReloadSpeedMultiplier()
	return self.ReloadDelay / reloadspeed
end

function SWEP:ShouldDoReload()
	return self:GetDTFloat(3) > 0 and CurTime() >= self:GetDTFloat(3)
end

function SWEP:IsReloading()
	return self:GetDTFloat(3) > 0
end

function SWEP:CanReload()
	return self:Clip1() < self.Primary.ClipSize and 0 < self:GetOwner():GetAmmoCount(self.Primary.Ammo)
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:Clip1() < self.RequiredClip then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)

		return false
	end

	if self:IsReloading() then
		self:StopReloading()
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end


if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
			local offsetVec = Vector(15, -1, -2)
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

function SWEP:SecondaryAttack()
end
