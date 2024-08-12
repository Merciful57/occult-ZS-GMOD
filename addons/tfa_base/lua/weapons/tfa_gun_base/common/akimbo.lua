SWEP.AnimCycle = SWEP.ViewModelFlip and 0 or 1

function SWEP:FixAkimbo()
	if not self:GetStatL("IsAkimbo") or self.Secondary_TFA.ClipSize <= 0 then return end

	self.Primary_TFA.ClipSize = self.Primary_TFA.ClipSize + self.Secondary_TFA.ClipSize
	self.Secondary_TFA.ClipSize = -1
	self.Primary_TFA.RPM = self.Primary_TFA.RPM * 2
	self.Akimbo_Inverted = self.ViewModelFlip
	self:ResetAnimCycle()
	self:ClearStatCache()

	timer.Simple(FrameTime(), function()
		timer.Simple(0.01, function()
			if IsValid(self) and self:OwnerIsValid() then
				self:SetClip1(self.Primary_TFA.ClipSize)
			end
		end)
	end)
end

function SWEP:ResetAnimCycle()
	self:SetAnimCycle(self.Akimbo_Inverted and 0 or 1)
	self.AnimCycle = self:GetAnimCycle()
end

function SWEP:ToggleAkimbo(arg1)
	if self:GetStatL("IsAkimbo") then
		self:SetAnimCycle(1 - self:GetAnimCycle())
		self.AnimCycle = self:GetAnimCycle()
	end
end
