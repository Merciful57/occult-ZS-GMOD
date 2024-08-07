SWEP.Base = "weapon_zs_basemelee"

SWEP.PrintName = "Large canned prop"
SWEP.Description = " A huge randomly assorted prop compressed into a can with neutron technology./n Impossible to get back in once opened.  "

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
	Model("models/props_borealis/borealis_door001a.mdl"),
	Model("models/props_building_details/Storefront_Template001a_Bars.mdl"),
	Model("models/props_c17/concrete_barrier001a.mdl"),
	Model("models/props_c17/door01_left.mdl"),
	Model("models/props_c17/door02_double.mdl"),
	Model("models/props_c17/FurnitureShelf001a.mdl"),
	Model("models/props_c17/gravestone001a.mdl"),
	Model("models/props_c17/Lockers001a.mdl"),
	Model("models/props_c17/shelfunit01a.mdl"),
	Model("models/props_combine/breendesk.mdl"),
	Model("models/props_debris/metal_panel01a.mdl"),
	Model("models/props_doors/door03_slotted_left.mdl"),
	--Model("models/props_interiors/ElevatorShaft_Door01a.mdl"),--nincompoop door cant be nailed fuck you
	Model("models/props_interiors/Furniture_shelf01a.mdl"),
	Model("models/props_interiors/refrigerator01a.mdl"),
	Model("models/props_interiors/VendingMachineSoda01a.mdl"),
	Model("models/props_wasteland/kitchen_shelf001a.mdl"),
	Model("models/props_wasteland/prison_celldoor001b.mdl"),
	Model("models/props_interiors/VendingMachineSoda01a_door.mdl"),
	Model("models/props/de_nuke/equipment1.mdl"),
	Model("models/props/cs_office/file_cabinet1_group.mdl")
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
