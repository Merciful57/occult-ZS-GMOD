SWEP.Base = "weapon_zs_basemelee"

SWEP.PrintName = "Medium canned prop"
SWEP.Description = " A randomly assorted prop compressed into a can with neutron technology./n Very hard get back in once opened.  "

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
	Model("models/props_borealis/bluebarrel001.mdl"),
	Model("models/props_c17/canister01a.mdl"),
	Model("models/props_c17/bench01a.mdl"),
	Model("models/props_c17/chair02a.mdl"),
	Model("models/props_c17/FurnitureBed001a.mdl"),
	Model("models/props_c17/FurnitureChair001a.mdl"),
	Model("models/props_c17/FurnitureCouch001a.mdl"),
	Model("models/props_c17/FurnitureCouch002a.mdl"),
	Model("models/props_c17/FurnitureDrawer001a.mdl"),
	Model("models/props_c17/FurnitureDrawer002a.mdl"),
	Model("models/props_c17/FurnitureDrawer003a.mdl"),
	Model("models/props_c17/FurnitureDresser001a.mdl"),
	Model("models/props_c17/FurnitureFridge001a.mdl"),
	Model("models/props_c17/FurnitureRadiator001a.mdl"),
	Model("models/props_c17/FurnitureShelf001b.mdl"),
	Model("models/props_c17/FurnitureSink001a.mdl"),
	Model("models/props_c17/furnitureStove001a.mdl"),
	Model("models/props_c17/FurnitureTable001a.mdl"),
	Model("models/props_c17/FurnitureTable002a.mdl"),
	Model("models/props_c17/FurnitureTable003a.mdl"),
	Model("models/props_c17/FurnitureWashingmachine001a.mdl"),
	Model("models/props_c17/oildrum001.mdl"),
	Model("models/props_c17/gravestone003a.mdl"),
	Model("models/props_c17/metalladder001.mdl"),
	Model("models/props_combine/breenchair.mdl"),
	Model("models/props_debris/metal_panel02a.mdl"),
	Model("models/props_docks/channelmarker_gib01.mdl"),
	Model("models/props_docks/dock01_pole01a_128.mdl"),
	Model("models/props_interiors/Furniture_chair01a.mdl"),
	Model("models/props_interiors/Furniture_chair03a.mdl"),
	Model("models/props_interiors/Furniture_Couch01a.mdl"),
	Model("models/props_interiors/Furniture_Couch02a.mdl"),
	Model("models/props_interiors/Furniture_Desk01a.mdl"),
	Model("models/props_interiors/Furniture_Lamp01a.mdl"),
	Model("models/props_interiors/Radiator01a.mdl"),
	Model("models/props_interiors/refrigeratorDoor01a.mdl"),
	Model("models/props_interiors/refrigeratorDoor02a.mdl"),
	Model("models/props_interiors/SinkKitchen01a.mdl"),
	Model("models/props_junk/cardboard_box001a.mdl"),
	Model("models/props_junk/cardboard_box002a.mdl"),
	Model("models/props_junk/cardboard_box003a.mdl"),
	Model("models/props_junk/harpoon002a.mdl"),
	Model("models/props_junk/PushCart01a.mdl"),
	Model("models/props_junk/ravenholmsign.mdl"),
	Model("models/props_junk/sawblade001a.mdl"),
	Model("models/props_junk/TrashBin01a.mdl"),
	Model("models/props_junk/wood_pallet001a.mdl"),
	Model("models/props_lab/filecabinet02.mdl"),
	Model("models/props_trainstation/BenchOutdoor01a.mdl"),
	Model("models/props_lab/lockerdoorleft.mdl"),
	Model("models/props_trainstation/Ceiling_Arch001a.mdl"),
	Model("models/props_trainstation/TrackSign08.mdl"),
	Model("models/props_trainstation/TrackSign09.mdl"),
	Model("models/props_trainstation/TrackSign10.mdl"),
	Model("models/props_trainstation/traincar_rack001.mdl"),
	Model("models/props_wasteland/cafeteria_bench001a.mdl"),
	Model("models/props_wasteland/cafeteria_table001a.mdl"),
	Model("models/props_wasteland/controlroom_desk001a.mdl"),
	Model("models/props_wasteland/controlroom_chair001a.mdl"),
	Model("models/props_wasteland/controlroom_filecabinet002a.mdl"),
	Model("models/props_wasteland/prison_heater001a.mdl"),
	Model("models/props_wasteland/prison_heater001a.mdl"),
	Model("models/props_wasteland/prison_bedframe001b.mdl"),
	Model("models/props_wasteland/prison_shelf002a.mdl"),
	Model("models/props_c17/Frame002a.mdl"),
	Model("models/props_combine/breenchair.mdl"),
	Model("models/props_junk/bicycle01a.mdl"),
	Model("models/props_lab/hevplate.mdl"),
	Model("models/props_trainstation/payphone001a.mdl"),
	Model("models/props_vehicles/carparts_door01a.mdl"),
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
