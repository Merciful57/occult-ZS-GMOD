SWEP.Base = "weapon_zs_basemelee"

SWEP.PrintName = "Small canned prop"
SWEP.Description = " A small randomly assorted prop compressed into a can with neutron technology./n Hard to get back in once opened.  "

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = "models/nseven/popcan01a.mdl"
SWEP.UseHands = true

SWEP.AmmoIfHas = true
SWEP.AllowEmpty = false

SWEP.Primary.ClipSize = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Delay = 1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Ammo = "dummy"
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.15

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

SWEP.JunkModels = {
	Model("models/props_c17/FurnitureDrawer001a_Chunk01.mdl"),
	Model("models/props_c17/FurnitureDrawer001a_Chunk02.mdl"),
	Model("models/props_c17/FurnitureDrawer001a_Chunk03.mdl"),
	Model("models/props_c17/FurnitureDrawer001a_Chunk05.mdl"),
	Model("models/props_c17/FurnitureShelf001b.mdl"),
	Model("models/props_junk/PlasticCrate01a.mdl"),
	Model("models/props_c17/pulleywheels_small01.mdl"),
	Model("models/props_combine/breenglobe.mdl"),
	Model("models/props_docks/dock01_cleat01a.mdl"),
	Model("models/props_interiors/pot01a.mdl"),
	Model("models/props_interiors/pot02a.mdl"),
	Model("models/props_junk/CinderBlock01a.mdl"),
	Model("models/props_junk/meathook001a.mdl"),
	Model("models/props_junk/MetalBucket02a.mdl"),
	Model("models/props_junk/TrafficCone001a.mdl"),
	Model("models/props_c17/doll01.mdl"),
	Model("models/props_c17/consolebox01a.mdl"),
	Model("models/props_c17/consolebox03a.mdl"),
	Model("models/props_c17/consolebox05a.mdl"),
	Model("models/props_c17/playground_swingset_seat01a.mdl"),
	Model("models/props_c17/SuitCase001a.mdl"),
	Model("models/props_c17/SuitCase_Passenger_Physics.mdl"),
	Model("models/props_lab/harddrive02.mdl"),
	Model("models/props_lab/harddrive01.mdl"),
	Model("models/props_lab/partsbin01.mdl"),
	Model("models/props_lab/reciever01a.mdl"),
	Model("models/props_phx/construct/metal_plate1_tri.mdl"),
	Model("models/props_phx/construct/metal_wire1x1.mdl"),
	Model("models/xqm/quad1.mdl"),
	Model("models/props/cs_office/Paper_towels.mdl"),
	Model("models/props/CS_militia/axe.mdl")
}
  
  --remember to not comma the last on this line ^
  
  
SWEP.HoldType = "physgun"

function SWEP:SetReplicatedAmmo(count)
	self:SetDTInt(0, count)
end

function SWEP:GetReplicatedAmmo()
	return self:GetDTInt(0)
end

function SWEP:GetWalkSpeed()
	if self:GetPrimaryAmmoCount() > 0 then
		return self.FullWalkSpeed
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local aimvec = self:GetOwner():GetAimVector()
	local shootpos = self:GetOwner():GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self:GetOwner()})

	self:SetNextPrimaryAttack(CurTime() + self.Primary.Delay)

	self:EmitSound("beer.wav", 100, math.random(105, 95))

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.IdleAnimation = CurTime() + math.min(self.Primary.Delay, self:SequenceDuration())

	if SERVER then
		self:GetOwner():RestartGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)

		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			local ang = aimvec:Angle()
			ang:RotateAroundAxis(ang:Forward(), 90)
			ent:SetPos(tr.HitPos)
			ent:SetAngles(ang)
			ent:SetModel(self.JunkModels[math.random(#self.JunkModels)])
			ent:Spawn()
			ent:SetHealth(350)
			ent.NoVolumeCarryCheck = true
			ent.NoDisTime = CurTime() + 15
			ent.NoDisOwner = self:GetOwner()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMass(math.min(phys:GetMass(), 50))
				phys:SetVelocityInstantaneous(self:GetOwner():GetVelocity())
			end
			ent:SetPhysicsAttacker(self:GetOwner())
			self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if math.abs(self:GetOwner():GetVelocity().z) >= 256 then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:Think()
	if self.IdleAnimation and self.IdleAnimation <= CurTime() then
		self.IdleAnimation = nil
		self:SendWeaponAnim(ACT_VM_IDLE)
	end

	if SERVER then
		local count = self:GetPrimaryAmmoCount()
		if count ~= self:GetReplicatedAmmo() then
			self:SetReplicatedAmmo(count)
			self:GetOwner():ResetSpeed()
		end

		if self:GetPrimaryAmmoCount() <= 0 then
			self:GetOwner():StripWeapon(self:GetClass())
		end
	end
end
