local LocalPlayer = LocalPlayer
local math = math

local function GetScreenAspectRatio()
	return ScrW() / ScrH()
end

local function ScaleFOVByWidthRatio(fovDegrees, ratio)
	local halfAngleRadians = fovDegrees * (0.5 * math.pi / 180.0)
	local t = math.tan(halfAngleRadians)
	t = t * ratio
	local retDegrees = (180.0 / math.pi) * math.atan(t)

	return retDegrees * 2.0
end

local default_fov_cv = GetConVar("default_fov")

function SWEP:GetTrueFOV()
	local fov = TFADUSKFOV or default_fov_cv:GetFloat()
	local ply = LocalPlayer()

	if not ply:IsValid() then return fov end

	if ply:GetFOV() < ply:GetDefaultFOV() - 1 then
		fov = ply:GetFOV()
	end

	if TFADUSKFOV_FINAL then
		fov = TFADUSKFOV_FINAL
	end

	return fov
end

function SWEP:GetViewModelFinalFOV()
	local fov_default = default_fov_cv:GetFloat()
	local fov = self:GetTrueFOV()
	local flFOVOffset = fov_default - fov
	local fov_vm = self.ViewModelFOV - flFOVOffset
	local aspectRatio = GetScreenAspectRatio() * 0.75 -- (4/3)
	--local final_fov = ScaleFOVByWidthRatio( fov,  aspectRatio )
	local final_fovViewmodel = ScaleFOVByWidthRatio(fov_vm, aspectRatio)

	return final_fovViewmodel
end
