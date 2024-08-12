AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.DefaultModel = Model("models/weapons/w_eq_fraggrenade.mdl")

ENT.Damage = 100
ENT.Delay = 3

function ENT:Initialize()
	local mdl = self:GetModel()

	if not mdl or mdl == "" or mdl == "models/error.mdl" then
		self:SetModel(self.DefaultModel)
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self:SetFriction(self.Delay)
	self.killtime = CurTime() + self.Delay
	self:DrawShadow(true)

	if not self.Inflictor and self:GetOwner():IsValid() and self:GetOwner():GetActiveWeapon():IsValid() then
		self.Inflictor = self:GetOwner():GetActiveWeapon()
	end
end

function ENT:Think()
	if self.killtime < CurTime() then
		self:Explode()

		return false
	end

	self:NextThink(CurTime())

	return true
end

ENT.ExplosionSound = "BaseExplosionEffect.Sound"

function ENT:DoExplosionEffect()
	local effectdata = EffectData()
	effectdata:SetOrigin(self:GetPos())

	util.Effect("HelicopterMegaBomb", effectdata)
	util.Effect("Explosion", effectdata)

	self:EmitSoundNet(self.ExplosionSound)
end

function ENT:Explode()
	if not IsValid(self.Inflictor) then
		self.Inflictor = self
	end

	self.Damage = self.mydamage or self.Damage

	local dmg = DamageInfo()
	dmg:SetInflictor(self.Inflictor)
	dmg:SetAttacker(IsValid(self:GetOwner()) and self:GetOwner() or self)
	dmg:SetDamage(self.Damage)
	dmg:SetDamageType(bit.bor(DMG_BLAST, DMG_AIRBOAT))

	util.BlastDamageInfo(dmg, self:GetPos(), math.pow( self.Damage / 100, 0.75) * 200)

	util.ScreenShake(self:GetPos(), self.Damage * 20, 255, self.Damage / 200, math.pow(self.Damage / 100, 0.75) * 400)

	self:DoExplosionEffect()

	self:Remove()
end