ENT.Type = "anim"

ENT.m_NoNailUnfreeze = true
ENT.NoNails = true

ENT.CanPackUp = true

ENT.IsBarricadeObject = true
ENT.AlwaysGhostable = true

function ENT:SetObjectHealth(health)
	self:SetDTFloat(0, health)
	if health <= 0 and not self.Destroyed then
		self.Destroyed = true
		self:FakePropBreak()
	end
end

function ENT:GetObjectHealth()
	return self:GetDTFloat(0)
end

function ENT:SetMaxObjectHealth(health)
	self:SetDTFloat(1, health)
end

function ENT:GetMaxObjectHealth()
	return self:GetDTFloat(1)
end

function ENT:SetObjectOwner(ent)
	self:SetDTEntity(0, ent)
end

function ENT:GetObjectOwner()
	return self:GetDTEntity(0)
end

function ENT:ClearObjectOwner()
	self:SetObjectOwner(NULL)
end

function ENT:ShouldNotCollide(ent)
    if ent:IsProjectile() then
        local owner = ent:GetOwner()
        if owner:IsValid() then
            if owner:IsHuman() then return true end
        end
    end

    if ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_UNDEAD then return end

    local colgroup = ent:GetCollisionGroup()
    if colgroup == COLLISION_GROUP_PLAYER or colgroup == COLLISION_GROUP_WEAPON or colgroup == COLLISION_GROUP_NONE then
        return true
    end

    return false
end
