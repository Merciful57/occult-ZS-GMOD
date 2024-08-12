include("shared.lua")

function ENT:Draw()
	if IsValid( self:GetParent() ) then
		self:GetParent():SetupBones()
	end
	self:SetupBones()
	self:DrawModel()
end