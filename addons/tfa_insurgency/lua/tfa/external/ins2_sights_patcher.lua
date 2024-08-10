TFA.INS2 = TFA.INS2 or {}
TFA.INS2.SightReplacements = TFA.INS2.SightReplacements or {}

local SightReplacements = TFA.INS2.SightReplacements
SightReplacements.Atts = SightReplacements.Atts or {}

hook.Add("TFAAttachmentsLoaded", "INS2PatchNewSights", function()
	table.Empty(SightReplacements.Atts)

	local path = "tfa/ins2_sights/"
	local files, _ = file.Find(path .. "*.lua", "LUA")

	for _, fname in ipairs(files) do
		local SIGHT = {}
	
		local _ENV = {
			SIGHT = SIGHT
		}
	
		setmetatable(_ENV, {
			__index = _G,
			__newindex = function(self, k, v)
				_G[k] = v
			end
		})

		if SERVER then AddCSLuaFile(path .. fname) end

		local id = fname:lower():Replace(".lua", "")

		local sight = CompileFile(path .. fname)
		setfenv(sight, _ENV)
		ProtectedCall(sight)

		if not SIGHT.Base then
			ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "' does not have base attachment ID set\n")
			continue
		end

		if not TFA.Attachments.Atts[SIGHT.Base] then
			ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "' attempts to inherit invalid " .. SIGHT.Base .. " attachment\n")
			continue
		end

		if not SIGHT.BaseElement then
			ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "' must contain base element name (SIGHT.BaseElement)\n")
			continue
		end

		if not SIGHT.ReplacementElement then
			ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "' must contain replacement element name (SIGHT.ReplacementElement)\n")
			continue
		end

		if SIGHT.ReticleData then
			if not SIGHT.ReticleData.material then ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "': 'material' value missing from reticle data\n") SIGHT.ReticleData = nil continue end
			if not SIGHT.ReticleData.dist then ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "': 'dist' value missing from reticle data\n") SIGHT.ReticleData = nil continue end
			if not SIGHT.ReticleData.size then ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "': 'size' value missing from reticle data\n") SIGHT.ReticleData = nil continue end
			if not SIGHT.ReticleData.bone then ErrorNoHalt("[TFA INS2] [!] Sight '" .. fname .. "': 'bone' value missing from reticle data\n") SIGHT.ReticleData = nil continue end
		end

		local ATTACHMENT = table.Copy(TFA.Attachments.Atts[SIGHT.Base])

		ATTACHMENT.ID = id
		ATTACHMENT.Name = SIGHT.Name or ATTACHMENT.Name
		ATTACHMENT.Icon = SIGHT.Icon or ATTACHMENT.Icon
		ATTACHMENT.ShortName = SIGHT.ShortName or ATTACHMENT.ShortName

		local WeaponTable = ATTACHMENT.WeaponTable
		if not WeaponTable then
			ErrorNoHalt(fname .. " inherits attachment with no stats table")
			continue
		end

		local vel, wel = "VElements", "WElements"
		if ATTACHMENT.TFADataVersion and ATTACHMENT.TFADataVersion >= 1 then
			vel, wel = "ViewModelElements", "WorldModelElements"
		end

		local baseName, replName = SIGHT.BaseElement, SIGHT.ReplacementElement

		local VElements = WeaponTable[vel]
		if VElements and VElements[baseName] then
			VElements[replName] = table.Copy(VElements[baseName])
			VElements[baseName] = nil

			if VElements[baseName .. "_lens"] then
				WeaponTable.INS2_SightVElement = replName

				VElements[replName .. "_lens"] = table.Copy(VElements[baseName .. "_lens"])
				VElements[baseName .. "_lens"] = nil
			end
		end

		local WElements = WeaponTable[wel]
		if WElements and WElements[baseName] then
			WElements[replName] = table.Copy(WElements[baseName])
			WElements[baseName] = nil
		end

		TFA.Attachments.Register(id, ATTACHMENT)

		SightReplacements.Atts[SIGHT.Base] = SightReplacements.Atts[SIGHT.Base] or {}
		SightReplacements.Atts[SIGHT.Base][id] = SIGHT
	end
end)

function SightReplacements:PatchAttachment(wep, attTable, attName, attIndex)
	for id, r in pairs(self.Atts[attName] or {}) do
		local vel, wel = "VElements", "WElements"
		if wep.TFADataVersion and wep.TFADataVersion >= 1 then
			vel, wel = "ViewModelElements", "WorldModelElements"
		end

		if r.BaseElement and r.ReplacementElement then
			local baseName, replName = r.BaseElement, r.ReplacementElement

			if r.VElement and wep[vel] then
				local VElements = wep[vel]

				if VElements[baseName] then
					local t = table.Copy(VElements[baseName])

					if not t.model:find(r.VElement[1]) then continue end -- кастомная модель? ПОШЁЛ НАХУЙ
					t.model = t.model:Replace(r.VElement[1], r.VElement[2])
					VElements[replName] = t

					local Reticle

					if CLIENT then
						if r.ReticleData then
							TFA.INS2.AddHoloSightType(replName, r.ReticleData.material, r.ReticleData.dist, r.ReticleData.size, r.ReticleData.bone)
						end

						Reticle = TFA.INS2.GetHoloSightReticle(replName) or TFA.INS2.GetHoloSightReticle(baseName, replName)
					end

					VElements[replName .. "_lens"] = Reticle
				end
			end
		
			if r.WElement and wep[wel] then
				local WElements = wep[wel] or {}
		
				if WElements[baseName] then
					local t = table.Copy(WElements[baseName])
					t.model = t.model:Replace(r.WElement[1], r.WElement[2])
					WElements[replName] = t
				end
			end

			if not table.HasValue(attTable, id) then
				table.insert(attTable, attIndex, id)
			end
		end
	end
end

hook.Add("PreRegisterSWEP", "TFA_INS2_PatchSights", function(SWEP, ClassName)
	if not SWEP.Attachments and not (SWEP.VElements or SWEP.ViewModelElements) then return end

	for k, v in pairs(SWEP.Attachments or {}) do
		local selN

		if v.sel then
			if isnumber(v.sel) and v.sel >= 0 then
				selN = v.atts[v.sel]
			elseif isstring(v.sel) then
				selN = v.sel
			end
		end

		for l, b in pairs(v.atts or {}) do
			if SightReplacements.Atts[b] then
				SightReplacements:PatchAttachment(SWEP, v.atts, b, l)
			end
		end

		if selN then
			for n, m in pairs(v.atts) do
				if m == selN then
					v.sel = n
				end
			end
		end
	end
end)