AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Use( activator, caller, usetype, val )
	if activator:IsPlayer() and activator:GetWeapon(self.gun) ~= nil then
		activator:GiveAmmo(1, activator:GetWeapon(self.gun):GetPrimaryAmmoType(), false)
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
end