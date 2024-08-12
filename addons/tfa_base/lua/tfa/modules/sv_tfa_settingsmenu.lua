local IsSinglePlayer = game.SinglePlayer()

util.AddNetworkString("TFA_SetServerCommand")

local function QueueConVarChange(convarname, convarvalue)
	if not convarname or not convarvalue then return end

	timer.Create("tfa_cvarchange_" .. convarname, 0.1, 1, function()
		if not string.find(convarname, "_tfa") or not GetConVar(convarname) then return end -- affect only TFA convars

		RunConsoleCommand(convarname, convarvalue)
	end)
end

local function ChangeServerOption(_length, _player)
	local _cvarname = net.ReadString()
	local _value = net.ReadString()

	if IsSinglePlayer then return end
	if not IsValid(_player) or not _player:IsAdmin() then return end

	QueueConVarChange(_cvarname, _value)
end

net.Receive("TFA_SetServerCommand", ChangeServerOption)
