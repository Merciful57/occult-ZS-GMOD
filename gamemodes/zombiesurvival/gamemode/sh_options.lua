GM.ZombieEscapeWeaponsPrimary = {
	"weapon_zs_zeakbar",
	"weapon_zs_zesweeper",
	"weapon_zs_zesmg",
	"weapon_zs_zeinferno",
	"weapon_zs_zestubber",
	"weapon_zs_zebulletstorm",
	"weapon_zs_zesilencer",
	"weapon_zs_zequicksilver",
	"weapon_zs_zeamigo",
	"weapon_zs_zem4"
}

GM.ZombieEscapeWeaponsSecondary = {
	"weapon_zs_zedeagle",
	"weapon_zs_zebattleaxe",
	"weapon_zs_zeeraser",
	"weapon_zs_zeglock",
	"weapon_zs_zetempest"
}

-- Change this if you plan to alter the cost of items or you severely change how Worth works.
-- Having separate cart files allows people to have separate loadouts for different servers.
GM.CartFile = "zscarts.txt"
GM.SkillLoadoutsFile = "occultskillloadouts.txt"

ITEMCAT_GUNS = 1
ITEMCAT_AMMO = 2
ITEMCAT_MELEE = 3
ITEMCAT_TOOLS = 4
ITEMCAT_DEPLOYABLES = 5
ITEMCAT_TRINKETS = 6
ITEMCAT_OTHER = 7
ITEMCAT_LEGENDARY = 8

ITEMSUBCAT_TRINKETS_DEFENSIVE = 1
ITEMSUBCAT_TRINKETS_OFFENSIVE = 2
ITEMSUBCAT_TRINKETS_MELEE = 3
ITEMSUBCAT_TRINKETS_PERFORMANCE = 4
ITEMSUBCAT_TRINKETS_SUPPORT = 5
ITEMSUBCAT_TRINKETS_SPECIAL = 6

GM.ItemCategories = {
	[ITEMCAT_GUNS] = "Guns",
	[ITEMCAT_AMMO] = "Ammunition",
	[ITEMCAT_MELEE] = "Melee",
	[ITEMCAT_TOOLS] = "Tools",
	[ITEMCAT_DEPLOYABLES] = "Deployables",
	[ITEMCAT_TRINKETS] = "Trinkets",
	[ITEMCAT_OTHER] = "Other",
	[ITEMCAT_LEGENDARY] = "Legendary Weapons"
}

GM.ItemSubCategories = {
	[ITEMSUBCAT_TRINKETS_DEFENSIVE] = "Defensive",
	[ITEMSUBCAT_TRINKETS_OFFENSIVE] = "Offensive",
	[ITEMSUBCAT_TRINKETS_MELEE] = "Melee",
	[ITEMSUBCAT_TRINKETS_PERFORMANCE] = "Performance",
	[ITEMSUBCAT_TRINKETS_SUPPORT] = "Support",
	[ITEMSUBCAT_TRINKETS_SPECIAL] = "Special"
}

--[[
Humans select what weapons (or other things) they want to start with and can even save favorites. Each object has a number of 'Worth' points.
Signature is a unique signature to give in case the item is renamed or reordered. Don't use a number or a string number!
A human can only use 100 points (default) when they join. Redeeming or joining late starts you out with a random loadout from above.
SWEP is a swep given when the player spawns with that perk chosen.
Callback is a function called. Model is a display model. If model isn't defined then the SWEP model will try to be used.
swep, callback, and model can all be nil or empty
]]
GM.Items = {}
function GM:AddItem(signature, category, price, swep, name, desc, model, callback)
	local tab = {Signature = signature, Name = name or "?", Description = desc, Category = category, Price = price or 0, SWEP = swep, Callback = callback, Model = model}

	tab.Worth = tab.Price -- compat

	self.Items[#self.Items + 1] = tab
	self.Items[signature] = tab

	return tab
end

function GM:AddStartingItem(signature, category, price, swep, name, desc, model, callback)
	local item = self:AddItem(signature, category, price, swep, name, desc, model, callback)
	item.WorthShop = true

	return item
end

function GM:AddPointShopItem(signature, category, price, swep, name, desc, model, callback)
	local item = self:AddItem("ps_"..signature, category, price, swep, name, desc, model, callback)
	item.PointShop = true

	return item
end

-- How much ammo is considered one 'clip' of ammo? For use with setting up weapon defaults. Works directly with zs_survivalclips
GM.AmmoCache = {}
GM.AmmoCache["ar2"]							= 48		-- Assault rifles.
GM.AmmoCache["alyxgun"]						= 24		-- Not used.
GM.AmmoCache["pistol"]						= 36		-- Pistols.
GM.AmmoCache["smg1"]						= 48		-- SMG's and some rifles.
GM.AmmoCache["357"]							= 12			-- Rifles, especially of the sniper variety.
GM.AmmoCache["xbowbolt"]					= 12			-- Crossbows
GM.AmmoCache["buckshot"]					= 16		-- Shotguns
GM.AmmoCache["ar2altfire"]					= 1			-- Not used.
GM.AmmoCache["slam"]						= 1			-- Force Field Emitters.
GM.AmmoCache["rpg_round"]					= 1			-- Not used. Rockets?
GM.AmmoCache["smg1_grenade"]				= 1			-- Not used.
GM.AmmoCache["sniperround"]					= 1			-- Barricade Kit
GM.AmmoCache["sniperpenetratedround"]		= 1			-- Remote Det pack.
GM.AmmoCache["grenade"]						= 1			-- Grenades.
GM.AmmoCache["thumper"]						= 1			-- Gun turret.
GM.AmmoCache["gravity"]						= 1			-- Unused.
GM.AmmoCache["battery"]						= 32		-- Used with the Medical Kit.
GM.AmmoCache["gaussenergy"]					= 10			-- Nails used with the Carpenter's Hammer.
GM.AmmoCache["combinecannon"]				= 1			-- Not used.
GM.AmmoCache["airboatgun"]					= 1			-- Arsenal crates.
GM.AmmoCache["striderminigun"]				= 1			-- Message beacons.
GM.AmmoCache["helicoptergun"]				= 1			-- Resupply boxes.
GM.AmmoCache["spotlamp"]					= 1
GM.AmmoCache["manhack"]						= 1
GM.AmmoCache["repairfield"]					= 1
GM.AmmoCache["zapper"]						= 1
GM.AmmoCache["pulse"]						= 30
GM.AmmoCache["impactmine"]					= 3
GM.AmmoCache["chemical"]					= 20
GM.AmmoCache["flashbomb"]					= 1
GM.AmmoCache["turret_buckshot"]				= 1
GM.AmmoCache["turret_assault"]				= 1
GM.AmmoCache["scrap"]						= 8

GM.AmmoResupply = table.ToAssoc({"ar2", "pistol", "smg1", "357", "xbowbolt", "buckshot", "battery", "pulse", "impactmine", "chemical", "gaussenergy", "scrap"})

-----------
-- Scrap --
-----------
item =
GM:AddStartingItem("resupplybox",		ITEMCAT_TOOLS,			15,				"weapon_zs_resupplybox")
item.Countables = "prop_resupplybox"
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("nail",				ITEMCAT_AMMO,			4,				nil,							"10 Nails",							"It's just 10 nails.",					"ammo_nail",						function(pl) pl:GiveAmmo(10, "GaussEnergy", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("pistolammo",		ITEMCAT_AMMO,			4,				nil,							"16 pistol ammo",				nil,									"ammo_pistol",						function(pl) pl:GiveAmmo(16, "pistol", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("shotgunammo",		ITEMCAT_AMMO,			4,				nil,							"12 shotgun ammo",				nil,									"ammo_shotgun",						function(pl) pl:GiveAmmo(12, "buckshot", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("smgammo",			ITEMCAT_AMMO,			4,				nil,							"36 SMG ammo",					nil,									"ammo_smg",							function(pl) pl:GiveAmmo(36, "smg1", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("rifleammo",		ITEMCAT_AMMO,			4,				nil,							"8 rifle ammo",					nil,									"ammo_rifle",						function(pl) pl:GiveAmmo(8, "357", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("crossbowammo",		ITEMCAT_AMMO,			4,				nil,							"8 crossbow bolts",				nil,									"ammo_bolts",						function(pl) pl:GiveAmmo(8,	"XBowBolt",	true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("assaultrifleammo",	ITEMCAT_AMMO,			4,				nil,							"32 assault rifle ammo",		nil,									"ammo_assault",						function(pl) pl:GiveAmmo(32, "ar2", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("pulseammo",		ITEMCAT_AMMO,			4,				nil,							"30 pulse ammo",				nil,									"ammo_pulse",						function(pl) pl:GiveAmmo(30, "pulse", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("impactmine",		ITEMCAT_AMMO,			4,				nil,							"3 explosives",					nil,									"ammo_explosive",					function(pl) pl:GiveAmmo(3, "impactmine", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("chemical",			ITEMCAT_AMMO,			4,				nil,							"20 chemical vials",			nil,									"ammo_chemical",					function(pl) pl:GiveAmmo(20, "chemical", true) end)
item.CanMakeFromScrap = true
item =
GM:AddStartingItem("25mkit",			ITEMCAT_AMMO,			4,		nil,							"25 Medical Kit power",			"25 extra power for the Medical Kit.",	"ammo_medpower",					function(pl) pl:GiveAmmo(25, "Battery", true) end)
item.CanMakeFromScrap = true

------------
-- Points --
------------

-- Tier 1
GM:AddPointShopItem("pshtr",			ITEMCAT_GUNS,			0,				"weapon_zs_peashooter", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_peashooter") end)
GM:AddPointShopItem("btlax",			ITEMCAT_GUNS,			0,				"weapon_zs_battleaxe", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_battleaxe") end)
GM:AddPointShopItem("SAA",			ITEMCAT_GUNS,			0,				"weapon_zs_peacemaker", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_peacemaker") end)
GM:AddPointShopItem("owens",			ITEMCAT_GUNS,			0,				"weapon_zs_owens", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_owens") end)
GM:AddPointShopItem("blstr",			ITEMCAT_GUNS,			0,				"weapon_zs_blaster", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_blaster") end)
GM:AddPointShopItem("blunder",			ITEMCAT_GUNS,			0,				"weapon_zs_blunderbuss", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_blunderbuss") end)
GM:AddPointShopItem("tossr",			ITEMCAT_GUNS,			0,				"weapon_zs_tosser", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_tosser") end)
GM:AddPointShopItem("mosin",			ITEMCAT_GUNS,			0,				"weapon_zs_slavianka", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_slavianka") end)
GM:AddPointShopItem("stbbr",			ITEMCAT_GUNS,			0,				"weapon_zs_stubber", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_stubber") end)
GM:AddPointShopItem("chief",			ITEMCAT_GUNS,			0,				"weapon_zs_ma5c", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_ma5c") end)
GM:AddPointShopItem("crklr",			ITEMCAT_GUNS,			0,				"weapon_zs_crackler", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_crackler") end)
GM:AddPointShopItem("sling",			ITEMCAT_GUNS,			0,				"weapon_zs_slinger", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_slinger") end)
GM:AddPointShopItem("z9000",			ITEMCAT_GUNS,			0,				"weapon_zs_z9000", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_z9000") end)
GM:AddPointShopItem("minelayer",		ITEMCAT_GUNS,			0,				"weapon_zs_minelayer", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_minelayer") end)
-- Tier 2
GM:AddPointShopItem("glock3",			ITEMCAT_GUNS,			35,				"weapon_zs_glock3")
GM:AddPointShopItem("magnum",			ITEMCAT_GUNS,			35,				"weapon_zs_magnum")
GM:AddPointShopItem("eraser",			ITEMCAT_GUNS,			35,				"weapon_zs_eraser")
GM:AddPointShopItem("sawedoff",			ITEMCAT_GUNS,			35,				"weapon_zs_sawedoff")
GM:AddPointShopItem("uzi",				ITEMCAT_GUNS,			35,				"weapon_zs_uzi")
GM:AddPointShopItem("annabelle",		ITEMCAT_GUNS,			35,				"weapon_zs_annabelle")
GM:AddPointShopItem("inquisitor",		ITEMCAT_GUNS,			35,				"weapon_zs_inquisitor")
GM:AddPointShopItem("amigo",			ITEMCAT_GUNS,			35,				"weapon_zs_amigo")
GM:AddPointShopItem("norinco",			ITEMCAT_GUNS,			35,				"weapon_zs_norinco")
GM:AddPointShopItem("hurricane",		ITEMCAT_GUNS,			35,				"weapon_zs_hurricane")
-- Tier 3
GM:AddPointShopItem("deagle",			ITEMCAT_GUNS,			70,				"weapon_zs_deagle")
GM:AddPointShopItem("holdou",			ITEMCAT_GUNS,			70,				"weapon_zs_holdout")
GM:AddPointShopItem("tempest",			ITEMCAT_GUNS,			70,				"weapon_zs_tempest")
GM:AddPointShopItem("ender",			ITEMCAT_GUNS,			70,				"weapon_zs_ender")
GM:AddPointShopItem("shredder",			ITEMCAT_GUNS,			70,				"weapon_zs_smg")
GM:AddPointShopItem("silencer",			ITEMCAT_GUNS,			70,				"weapon_zs_silencer")
GM:AddPointShopItem("hunter",			ITEMCAT_GUNS,			70,				"weapon_zs_hunter")
GM:AddPointShopItem("onyx",				ITEMCAT_GUNS,			70,				"weapon_zs_onyx")
GM:AddPointShopItem("charon",			ITEMCAT_GUNS,			70,				"weapon_zs_charon")
GM:AddPointShopItem("akbar",			ITEMCAT_GUNS,			70,				"weapon_zs_akbar")
GM:AddPointShopItem("oberon",			ITEMCAT_GUNS,			70,				"weapon_zs_oberon")
GM:AddPointShopItem("hyena",			ITEMCAT_GUNS,			70,				"weapon_zs_hyena")
GM:AddPointShopItem("pollutor",			ITEMCAT_GUNS,			70,				"weapon_zs_pollutor")
-- Tier 4
GM:AddPointShopItem("longarm",			ITEMCAT_GUNS,			125,			"weapon_zs_longarm")
GM:AddPointShopItem("m9a1",			ITEMCAT_GUNS,			125,			"weapon_zs_m9a1")
GM:AddPointShopItem("sweeper",			ITEMCAT_GUNS,			125,			"weapon_zs_sweepershotgun")
GM:AddPointShopItem("jackhammer",		ITEMCAT_GUNS,			125,			"weapon_zs_jackhammer")
GM:AddPointShopItem("bulletstorm",		ITEMCAT_GUNS,			125,			"weapon_zs_bulletstorm")
GM:AddPointShopItem("reaper",			ITEMCAT_GUNS,			125,			"weapon_zs_reaper")
GM:AddPointShopItem("quicksilver",		ITEMCAT_GUNS,			125,			"weapon_zs_quicksilver")
GM:AddPointShopItem("slugrifle",		ITEMCAT_GUNS,			125,			"weapon_zs_slugrifle")
GM:AddPointShopItem("artemis",			ITEMCAT_GUNS,			125,			"weapon_zs_artemis")
GM:AddPointShopItem("zeus",				ITEMCAT_GUNS,			125,			"weapon_zs_zeus")
GM:AddPointShopItem("stalker",			ITEMCAT_GUNS,			125,			"weapon_zs_m4")
GM:AddPointShopItem("inferno",			ITEMCAT_GUNS,			125,			"weapon_zs_inferno")
GM:AddPointShopItem("quasar",			ITEMCAT_GUNS,			125,			"weapon_zs_quasar")
GM:AddPointShopItem("gluon",			ITEMCAT_GUNS,			125,			"weapon_zs_gluon")
GM:AddPointShopItem("barrage",			ITEMCAT_GUNS,			125,			"weapon_zs_barrage")
-- Tier 5
GM:AddPointShopItem("novacolt",			ITEMCAT_GUNS,			200,			"weapon_zs_novacolt")
GM:AddPointShopItem("c96",			ITEMCAT_GUNS,			200,			"weapon_zs_c96")
GM:AddPointShopItem("bulwark",			ITEMCAT_GUNS,			200,			"weapon_zs_bulwark")
GM:AddPointShopItem("juggernaut",		ITEMCAT_GUNS,			200,			"weapon_zs_juggernaut")
GM:AddPointShopItem("scar",				ITEMCAT_GUNS,			200,			"weapon_zs_scar")
GM:AddPointShopItem("boomstick",		ITEMCAT_GUNS,			200,			"weapon_zs_boomstick")
GM:AddPointShopItem("deathdlrs",		ITEMCAT_GUNS,			200,			"weapon_zs_deathdealers")
GM:AddPointShopItem("colossus",			ITEMCAT_GUNS,			200,			"weapon_zs_colossus")
GM:AddPointShopItem("renegade",			ITEMCAT_GUNS,			200,			"weapon_zs_renegade")
GM:AddPointShopItem("crossbow",			ITEMCAT_GUNS,			200,			"weapon_zs_crossbow")
GM:AddPointShopItem("pulserifle",		ITEMCAT_GUNS,			200,			"weapon_zs_pulserifle")
GM:AddPointShopItem("spinfusor",		ITEMCAT_GUNS,			200,			"weapon_zs_spinfusor")
GM:AddPointShopItem("broadside",		ITEMCAT_GUNS,			200,			"weapon_zs_broadside")
GM:AddPointShopItem("smelter",			ITEMCAT_GUNS,			200,			"weapon_zs_smelter")
-- Legendary Weapon
GM:AddPointShopItem("osiris",		ITEMCAT_LEGENDARY,		360,			"weapon_zs_crookofosiris")
GM:AddPointShopItem("haloce",		ITEMCAT_LEGENDARY,		360,			"weapon_zs_cepistol")
GM:AddPointShopItem("ripper",		ITEMCAT_LEGENDARY,		360,			"weapon_zs_ripper")
GM:AddPointShopItem("rpk74",		ITEMCAT_LEGENDARY,		360,			"weapon_zs_vdv")

GM:AddPointShopItem("nail",				ITEMCAT_AMMO,			4,				nil,							"10 Nails",							"It's just nails.",					"ammo_nail",						function(pl) pl:GiveAmmo(10, "GaussEnergy", true) end)
GM:AddPointShopItem("nail10",				ITEMCAT_AMMO,			40,				nil,							"120 Nails",							"It's just nails.",					"ammo_nail",						function(pl) pl:GiveAmmo(120, "GaussEnergy", true) end)
GM:AddPointShopItem("pistolammo",		ITEMCAT_AMMO,			4,				nil,							"16 pistol ammo",				nil,									"ammo_pistol",						function(pl) pl:GiveAmmo(16, "pistol", true) end)
GM:AddPointShopItem("pistolammo10",		ITEMCAT_AMMO,			40,				nil,							"192 pistol ammo",				nil,									"ammo_pistol",						function(pl) pl:GiveAmmo(192, "pistol", true) end)
GM:AddPointShopItem("shotgunammo",		ITEMCAT_AMMO,			4,				nil,							"12 shotgun ammo",				nil,									"ammo_shotgun",						function(pl) pl:GiveAmmo(12, "buckshot", true) end)
GM:AddPointShopItem("shotgunammo10",		ITEMCAT_AMMO,			40,				nil,							"144 shotgun ammo",				nil,									"ammo_shotgun",						function(pl) pl:GiveAmmo(144, "buckshot", true) end)
GM:AddPointShopItem("smgammo",			ITEMCAT_AMMO,			4,				nil,							"36 SMG ammo",					nil,									"ammo_smg",							function(pl) pl:GiveAmmo(36, "smg1", true) end)
GM:AddPointShopItem("smgammo10",			ITEMCAT_AMMO,			40,				nil,							"432 SMG ammo",					nil,									"ammo_smg",							function(pl) pl:GiveAmmo(432, "smg1", true) end)
GM:AddPointShopItem("rifleammo",		ITEMCAT_AMMO,			4,				nil,							"8 rifle ammo",					nil,									"ammo_rifle",						function(pl) pl:GiveAmmo(8, "357", true) end)
GM:AddPointShopItem("rifleammo10",		ITEMCAT_AMMO,			40,				nil,							"96 rifle ammo",					nil,									"ammo_rifle",						function(pl) pl:GiveAmmo(96, "357", true) end)
GM:AddPointShopItem("crossbowammo",		ITEMCAT_AMMO,			4,				nil,							"8 crossbow bolts",				nil,									"ammo_bolts",						function(pl) pl:GiveAmmo(8,	"XBowBolt",	true) end)
GM:AddPointShopItem("crossbowammo10",		ITEMCAT_AMMO,			40,				nil,							"96 crossbow bolts",				nil,									"ammo_bolts",						function(pl) pl:GiveAmmo(96,	"XBowBolt",	true) end)
GM:AddPointShopItem("assaultrifleammo",	ITEMCAT_AMMO,			4,				nil,							"32 assault rifle ammo",		nil,									"ammo_assault",						function(pl) pl:GiveAmmo(32, "ar2", true) end)
GM:AddPointShopItem("assaultrifleammo10",	ITEMCAT_AMMO,			40,				nil,							"384 assault rifle ammo",		nil,									"ammo_assault",						function(pl) pl:GiveAmmo(384, "ar2", true) end)
GM:AddPointShopItem("pulseammo",		ITEMCAT_AMMO,			4,				nil,							"30 pulse ammo",				nil,									"ammo_pulse",						function(pl) pl:GiveAmmo(30, "pulse", true) end)
GM:AddPointShopItem("pulseammo10",		ITEMCAT_AMMO,			40,				nil,							"360 pulse ammo",				nil,									"ammo_pulse",						function(pl) pl:GiveAmmo(360, "pulse", true) end)
GM:AddPointShopItem("impactmine",		ITEMCAT_AMMO,			4,				nil,							"3 explosives",					nil,									"ammo_explosive",					function(pl) pl:GiveAmmo(3, "impactmine", true) end)
GM:AddPointShopItem("impactmine10",		ITEMCAT_AMMO,			40,				nil,							"36 explosives",					nil,									"ammo_explosive",					function(pl) pl:GiveAmmo(36, "impactmine", true) end)
GM:AddPointShopItem("chemical",			ITEMCAT_AMMO,			4,				nil,							"20 chemical vials",			nil,									"ammo_chemical",					function(pl) pl:GiveAmmo(20, "chemical", true) end)
GM:AddPointShopItem("chemical10",			ITEMCAT_AMMO,			40,				nil,							"240 chemical vials",			nil,									"ammo_chemical",					function(pl) pl:GiveAmmo(240, "chemical", true) end)
GM:AddPointShopItem("25mkit",			ITEMCAT_AMMO,			4,				nil,							"25 Medical Kit power",			"25 extra power for the Medical Kit.",	"ammo_medpower",					function(pl) pl:GiveAmmo(25, "Battery", true) end)
GM:AddPointShopItem("25mkit10",			ITEMCAT_AMMO,			40,				nil,							"300 Medical Kit power",			"300 extra power for the Medical Kit.",	"ammo_medpower",					function(pl) pl:GiveAmmo(300, "Battery", true) end)
GM:AddPointShopItem("scrap",			ITEMCAT_AMMO,			4,				nil,							"8 Scrap",			nil,	"ammo_scrap",				function(pl) pl:GiveAmmo(8, "Scrap", true) end)
GM:AddPointShopItem("scrap10",			ITEMCAT_AMMO,			40,				nil,							"80 Scrap",			nil,	"ammo_scrap",					function(pl) pl:GiveAmmo(80, "Scrap", true) end)
-- Tier 1
GM:AddPointShopItem("brassknuckles",	ITEMCAT_MELEE,			0,				"weapon_zs_brassknuckles").Model = "models/props_c17/utilityconnecter005.mdl"
GM:AddPointShopItem("knife",			ITEMCAT_MELEE,			0,				"weapon_zs_swissarmyknife")
GM:AddPointShopItem("zpplnk",			ITEMCAT_MELEE,			0,				"weapon_zs_plank")
GM:AddPointShopItem("axe",				ITEMCAT_MELEE,			0,				"weapon_zs_axe")
GM:AddPointShopItem("zpfryp",			ITEMCAT_MELEE,			0,				"weapon_zs_fryingpan")
GM:AddPointShopItem("zpcpot",			ITEMCAT_MELEE,			0,				"weapon_zs_pot")
GM:AddPointShopItem("crowbar",			ITEMCAT_MELEE,			0,				"weapon_zs_crowbar")
GM:AddPointShopItem("pipe",				ITEMCAT_MELEE,			0,				"weapon_zs_pipe")
GM:AddPointShopItem("stunbaton",		ITEMCAT_MELEE,			0,				"weapon_zs_stunbaton")
GM:AddPointShopItem("hook",				ITEMCAT_MELEE,			0,				"weapon_zs_hook")
-- Tier 2
GM:AddPointShopItem("broom",			ITEMCAT_MELEE,			35,				"weapon_zs_pushbroom")
GM:AddPointShopItem("shovel",			ITEMCAT_MELEE,			35,				"weapon_zs_shovel")
GM:AddPointShopItem("sledgehammer",		ITEMCAT_MELEE,			35,				"weapon_zs_sledgehammer")
GM:AddPointShopItem("harpoon",			ITEMCAT_MELEE,			35,				"weapon_zs_harpoon")
GM:AddPointShopItem("butcherknf",		ITEMCAT_MELEE,			35,				"weapon_zs_butcherknife")
-- Tier 3
GM:AddPointShopItem("longsword",		ITEMCAT_MELEE,			70,				"weapon_zs_longsword")
GM:AddPointShopItem("executioner",		ITEMCAT_MELEE,			70,				"weapon_zs_executioner")
GM:AddPointShopItem("rebarmace",		ITEMCAT_MELEE,			70,				"weapon_zs_rebarmace")
GM:AddPointShopItem("meattenderizer",	ITEMCAT_MELEE,			70,				"weapon_zs_meattenderizer")
-- Tier 4
GM:AddPointShopItem("graveshvl",		ITEMCAT_MELEE,			125,			"weapon_zs_graveshovel")
GM:AddPointShopItem("kongol",			ITEMCAT_MELEE,			125,			"weapon_zs_kongolaxe")
GM:AddPointShopItem("scythe",			ITEMCAT_MELEE,			125,			"weapon_zs_scythe")
GM:AddPointShopItem("powerfists",		ITEMCAT_MELEE,			125,			"weapon_zs_powerfists")
-- Tier 5
GM:AddPointShopItem("frotchet",			ITEMCAT_MELEE,			200,			"weapon_zs_frotchet")
GM:AddPointShopItem("ladel",			ITEMCAT_MELEE,		200,				"weapon_zs_ladel")

GM:AddPointShopItem("crphmr",			ITEMCAT_TOOLS,			0,				"weapon_zs_hammer",			nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_hammer") pl:GiveAmmo(0, "GaussEnergy") end)
GM:AddPointShopItem("lectro",			ITEMCAT_TOOLS,			35,				"weapon_zs_electrohammer")
GM:AddPointShopItem("wrench",			ITEMCAT_TOOLS,			0,				"weapon_zs_wrench").NoClassicMode = true
--GM:AddPointShopItem("arsenalcrate",		ITEMCAT_DEPLOYABLES,			40,				"weapon_zs_arsenalcrate").Countables = "prop_arsenalcrate"
GM:AddPointShopItem("resupplybox",		ITEMCAT_DEPLOYABLES,			15,				"weapon_zs_resupplybox").Countables = "prop_resupplybox"
GM:AddPointShopItem("msgbeacon",		ITEMCAT_DEPLOYABLES,			10,				"weapon_zs_messagebeacon").Countables = "prop_messagebeacon"
GM:AddPointShopItem("camera",			ITEMCAT_DEPLOYABLES,			15,				"weapon_zs_camera").Countables = "prop_camera"
GM:AddPointShopItem("tv",				ITEMCAT_DEPLOYABLES,			25,				"weapon_zs_tv").Countables = "prop_tv"
item =
GM:AddPointShopItem("infturret",		ITEMCAT_DEPLOYABLES,			50,				"weapon_zs_gunturret",			nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_gunturret") pl:GiveAmmo(1, "thumper") end)
item.NoClassicMode = true
item.Countables = "prop_gunturret"
item =
GM:AddPointShopItem("blastturret",		ITEMCAT_DEPLOYABLES,			50,				"weapon_zs_gunturret_buckshot",	nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_gunturret_buckshot") pl:GiveAmmo(1, "turret_buckshot") end)
item.Countables = "prop_gunturret_buckshot"
item.NoClassicMode = true
item =
GM:AddPointShopItem("assaultturret",	ITEMCAT_DEPLOYABLES,			125,			"weapon_zs_gunturret_assault",	nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_gunturret_assault") pl:GiveAmmo(1, "turret_assault") end)
item.NoClassicMode = true
item.Countables = "prop_gunturret_assault"
item =
GM:AddPointShopItem("rocketturret",		ITEMCAT_DEPLOYABLES,			125,			"weapon_zs_gunturret_rocket",	nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_gunturret_rocket") pl:GiveAmmo(1, "turret_rocket") end)
item.Countables = "prop_gunturret_rocket"
item.NoClassicMode = true
GM:AddPointShopItem("manhack",			ITEMCAT_DEPLOYABLES,			30,				"weapon_zs_manhack").Countables = "prop_manhack"
item =
GM:AddPointShopItem("drone",			ITEMCAT_DEPLOYABLES,			40,				"weapon_zs_drone")
item.Countables = "prop_drone"
item =
GM:AddPointShopItem("pulsedrone",		ITEMCAT_DEPLOYABLES,			40,				"weapon_zs_drone_pulse")
item.Countables = "prop_drone_pulse"
item =
GM:AddPointShopItem("hauldrone",		ITEMCAT_DEPLOYABLES,			15,				"weapon_zs_drone_hauler")
item.Countables = "prop_drone_hauler"
item =
GM:AddPointShopItem("rollermine",		ITEMCAT_DEPLOYABLES,			35,				"weapon_zs_rollermine")
item.Countables = "prop_rollermine"

item =
GM:AddPointShopItem("repairfield",		ITEMCAT_DEPLOYABLES,			55,				"weapon_zs_repairfield",		nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_repairfield") pl:GiveAmmo(1, "repairfield") pl:GiveAmmo(30, "pulse") end)
item.Countables = "prop_repairfield"
item.NoClassicMode = true
item =
GM:AddPointShopItem("zapper",			ITEMCAT_DEPLOYABLES,			50,				"weapon_zs_zapper",				nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_zapper") pl:GiveAmmo(1, "zapper") pl:GiveAmmo(30, "pulse") end)
item.Countables = "prop_zapper"
item.NoClassicMode = true
item =
GM:AddPointShopItem("zapper_arc",		ITEMCAT_DEPLOYABLES,			100,			"weapon_zs_zapper_arc",			nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_zapper_arc") pl:GiveAmmo(1, "zapper_arc") pl:GiveAmmo(30, "pulse") end)
item.Countables = "prop_zapper_arc"
item.NoClassicMode = true
item =
GM:AddPointShopItem("ffemitter",		ITEMCAT_DEPLOYABLES,			40,				"weapon_zs_ffemitter",			nil,							nil,									nil,											function(pl) pl:GiveEmptyWeapon("weapon_zs_ffemitter") pl:GiveAmmo(1, "slam") pl:GiveAmmo(30, "pulse") end)
item.Countables = "prop_ffemitter"
GM:AddPointShopItem("propanetank",		ITEMCAT_TOOLS,			15,				"comp_propanecan")
GM:AddPointShopItem("busthead",			ITEMCAT_TOOLS,			25,				"comp_busthead")
GM:AddPointShopItem("sawblade",			ITEMCAT_TOOLS,			30,				"comp_sawblade")
GM:AddPointShopItem("cpuparts",			ITEMCAT_TOOLS,			30,				"comp_cpuparts")
GM:AddPointShopItem("electrobattery",	ITEMCAT_TOOLS,			40,				"comp_electrobattery")
--GM:AddPointShopItem("barricadekit",		ITEMCAT_DEPLOYABLES,	85,				"weapon_zs_barricadekit")
GM:AddPointShopItem("medkit",			ITEMCAT_TOOLS,			0,				"weapon_zs_medicalkit", nil, nil, nil, function(pl) pl:GiveEmptyWeapon("weapon_zs_medicalkit") end)
--GM:AddPointShopItem("medgun",			ITEMCAT_TOOLS,			30,				"weapon_zs_medicgun")
GM:AddPointShopItem("strengthshot",		ITEMCAT_TOOLS,			30,				"weapon_zs_strengthshot")
GM:AddPointShopItem("antidote",			ITEMCAT_TOOLS,			30,				"weapon_zs_antidoteshot")
--GM:AddPointShopItem("medrifle",			ITEMCAT_TOOLS,			55,				"weapon_zs_medicrifle")
GM:AddPointShopItem("healray",			ITEMCAT_TOOLS,			45,			"weapon_zs_healingray")

-- Tier 1
GM:AddPointShopItem("cutlery",			ITEMCAT_TRINKETS,		10,				"trinket_cutlery").SubCategory =								ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("boxingtraining",	ITEMCAT_TRINKETS,		10,				"trinket_boxingtraining").SubCategory =							ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("hemoadrenali",		ITEMCAT_TRINKETS,		10,				"trinket_hemoadrenali").SubCategory =							ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("oxtank",			ITEMCAT_TRINKETS,		10,				"trinket_oxygentank").SubCategory =								ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("acrobatframe",		ITEMCAT_TRINKETS,		10,				"trinket_acrobatframe").SubCategory =							ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("portablehole",		ITEMCAT_TRINKETS,		10,				"trinket_portablehole").SubCategory =							ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("magnet",			ITEMCAT_TRINKETS,		10,				"trinket_magnet").SubCategory =									ITEMSUBCAT_TRINKETS_SPECIAL
GM:AddPointShopItem("targetingvisi",	ITEMCAT_TRINKETS,		10,				"trinket_targetingvisori").SubCategory =						ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("pulseampi",		ITEMCAT_TRINKETS,		10,				"trinket_pulseampi").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
-- Tier 2
GM:AddPointShopItem("momentumsupsysii",	ITEMCAT_TRINKETS,		15,				"trinket_momentumsupsysii").SubCategory =						ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("sharpkit",			ITEMCAT_TRINKETS,		15,				"trinket_sharpkit").SubCategory =								ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("nightvision",		ITEMCAT_TRINKETS,		15,				"trinket_nightvision").SubCategory =							ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("loadingframe",		ITEMCAT_TRINKETS,		15,				"trinket_loadingex").SubCategory =								ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("pathfinder",		ITEMCAT_TRINKETS,		15,				"trinket_pathfinder").SubCategory =								ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("ammovestii",		ITEMCAT_TRINKETS,		15,				"trinket_ammovestii").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("olympianframe",	ITEMCAT_TRINKETS,		15,				"trinket_olympianframe").SubCategory =							ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("autoreload",		ITEMCAT_TRINKETS,		15,				"trinket_autoreload").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("curbstompers",		ITEMCAT_TRINKETS,		15,				"trinket_curbstompers").SubCategory =							ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("vitpackagei",		ITEMCAT_TRINKETS,		15,				"trinket_vitpackagei").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("cardpackagei",		ITEMCAT_TRINKETS,		15,				"trinket_cardpackagei").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("forcedamp",		ITEMCAT_TRINKETS,		15,				"trinket_forcedamp").SubCategory =								ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("kevlar",			ITEMCAT_TRINKETS,		15,				"trinket_kevlar").SubCategory =									ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("antitoxinpack",	ITEMCAT_TRINKETS,		15,				"trinket_antitoxinpack").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("hemostasis",		ITEMCAT_TRINKETS,		15,				"trinket_hemostasis").SubCategory =								ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("bloodpack",		ITEMCAT_TRINKETS,		15,				"trinket_bloodpack").SubCategory =								ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("reactiveflasher",	ITEMCAT_TRINKETS,		15,				"trinket_reactiveflasher").SubCategory =						ITEMSUBCAT_TRINKETS_SPECIAL
GM:AddPointShopItem("iceburst",			ITEMCAT_TRINKETS,		15,				"trinket_iceburst").SubCategory =								ITEMSUBCAT_TRINKETS_SPECIAL
GM:AddPointShopItem("biocleanser",		ITEMCAT_TRINKETS,		15,				"trinket_biocleanser").SubCategory =							ITEMSUBCAT_TRINKETS_SPECIAL
GM:AddPointShopItem("necrosense",		ITEMCAT_TRINKETS,		15,				"trinket_necrosense").SubCategory =								ITEMSUBCAT_TRINKETS_SPECIAL
GM:AddPointShopItem("blueprintsi",		ITEMCAT_TRINKETS,		15,				"trinket_blueprintsi").SubCategory =							ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("processor",		ITEMCAT_TRINKETS,		15,				"trinket_processor").SubCategory =								ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("acqmanifest",		ITEMCAT_TRINKETS,		15,				"trinket_acqmanifest").SubCategory =							ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("mainsuite",		ITEMCAT_TRINKETS,		15,				"trinket_mainsuite").SubCategory =								ITEMSUBCAT_TRINKETS_SUPPORT
-- Tier 3
--GM:AddPointShopItem("climbinggear",	ITEMCAT_TRINKETS,		30,				"trinket_climbinggear").SubCategory =							ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("reachem",			ITEMCAT_TRINKETS,		30,				"trinket_reachem").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("momentumsupsysiii",ITEMCAT_TRINKETS,		30,				"trinket_momentumsupsysiii").SubCategory =						ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("powergauntlet",	ITEMCAT_TRINKETS,		30,				"trinket_powergauntlet").SubCategory =							ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("hemoadrenalii",	ITEMCAT_TRINKETS,		30,				"trinket_hemoadrenalii").SubCategory =							ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("sharpstone",		ITEMCAT_TRINKETS,		30,				"trinket_sharpstone").SubCategory =								ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("analgestic",		ITEMCAT_TRINKETS,		30,				"trinket_analgestic").SubCategory =								ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("feathfallframe",	ITEMCAT_TRINKETS,		30,				"trinket_featherfallframe").SubCategory =						ITEMSUBCAT_TRINKETS_PERFORMANCE
GM:AddPointShopItem("aimcomp",			ITEMCAT_TRINKETS,		30,				"trinket_aimcomp").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("pulseampii",		ITEMCAT_TRINKETS,		30,				"trinket_pulseampii").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("extendedmag",		ITEMCAT_TRINKETS,		30,				"trinket_extendedmag").SubCategory =							ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("vitpackageii",		ITEMCAT_TRINKETS,		30,				"trinket_vitpackageii").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("cardpackageii",	ITEMCAT_TRINKETS,		30,				"trinket_cardpackageii").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("regenimplant",		ITEMCAT_TRINKETS,		30,				"trinket_regenimplant").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("barbedarmor",		ITEMCAT_TRINKETS,		30,				"trinket_barbedarmor").SubCategory =							ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("blueprintsii",		ITEMCAT_TRINKETS,		30,				"trinket_blueprintsii").SubCategory =							ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("curativeii",		ITEMCAT_TRINKETS,		30,				"trinket_curativeii").SubCategory =								ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("remedy",			ITEMCAT_TRINKETS,		30,				"trinket_remedy").SubCategory =									ITEMSUBCAT_TRINKETS_SUPPORT
-- Tier 4
GM:AddPointShopItem("hemoadrenaliii",	ITEMCAT_TRINKETS,		50,				"trinket_hemoadrenaliii").SubCategory =							ITEMSUBCAT_TRINKETS_MELEE
GM:AddPointShopItem("ammoband",			ITEMCAT_TRINKETS,		50,				"trinket_ammovestiii").SubCategory =							ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("resonance",		ITEMCAT_TRINKETS,		50,				"trinket_resonance").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("cryoindu",			ITEMCAT_TRINKETS,		50,				"trinket_cryoindu").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("refinedsub",		ITEMCAT_TRINKETS,		50,				"trinket_refinedsub").SubCategory =								ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("targetingvisiii",	ITEMCAT_TRINKETS,		50,				"trinket_targetingvisoriii").SubCategory =						ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("eodvest",			ITEMCAT_TRINKETS,		50,				"trinket_eodvest").SubCategory =								ITEMSUBCAT_TRINKETS_DEFENSIVE
GM:AddPointShopItem("composite",		ITEMCAT_TRINKETS,		50,				"trinket_composite").SubCategory =								ITEMSUBCAT_TRINKETS_DEFENSIVE
--GM:AddPointShopItem("arsenalpack",		ITEMCAT_TRINKETS,		50,				"trinket_arsenalpack").SubCategory =							ITEMSUBCAT_TRINKETS_SUPPORT
--GM:AddPointShopItem("resupplypack",		ITEMCAT_TRINKETS,		50,				"trinket_resupplypack").SubCategory =							ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("promanifest",		ITEMCAT_TRINKETS,		50,				"trinket_promanifest").SubCategory =							ITEMSUBCAT_TRINKETS_SUPPORT
GM:AddPointShopItem("opsmatrix",		ITEMCAT_TRINKETS,		50,				"trinket_opsmatrix").SubCategory =								ITEMSUBCAT_TRINKETS_SUPPORT
-- Tier 5
GM:AddPointShopItem("supasm",			ITEMCAT_TRINKETS,		70,				"trinket_supasm").SubCategory =									ITEMSUBCAT_TRINKETS_OFFENSIVE
GM:AddPointShopItem("pulseimpedance",	ITEMCAT_TRINKETS,		70,				"trinket_pulseimpedance").SubCategory =							ITEMSUBCAT_TRINKETS_OFFENSIVE

item =
GM:AddPointShopItem("cans",			ITEMCAT_OTHER,			16,				"weapon_zs_can_small")
item.CanMakeFromScrap = true
item =
GM:AddPointShopItem("canm",			ITEMCAT_OTHER,			64,				"weapon_zs_can_medium")
item.CanMakeFromScrap = true
item =
GM:AddPointShopItem("canl",			ITEMCAT_OTHER,			92	,				"weapon_zs_can_large")
item.CanMakeFromScrap = true
GM:AddPointShopItem("flashbomb",		ITEMCAT_OTHER,			5,				"weapon_zs_flashbomb")
GM:AddPointShopItem("molotov",			ITEMCAT_OTHER,			15,				"weapon_zs_molotov")
GM:AddPointShopItem("grenade",			ITEMCAT_OTHER,			15,				"weapon_zs_grenade")
GM:AddPointShopItem("betty",			ITEMCAT_OTHER,			10,				"weapon_zs_proxymine")
GM:AddPointShopItem("detpck",			ITEMCAT_OTHER,			5,				"weapon_zs_detpack")
GM:AddPointShopItem("crygasgrenade",	ITEMCAT_OTHER,			5,				"weapon_zs_crygasgrenade")
GM:AddPointShopItem("corgasgrenade",	ITEMCAT_OTHER,			5,				"weapon_zs_corgasgrenade")
GM:AddPointShopItem("sigfragment",		ITEMCAT_OTHER,			100,				"weapon_zs_sigilfragment")
GM:AddPointShopItem("bloodshot",		ITEMCAT_OTHER,			10,				"weapon_zs_bloodshotbomb")
GM:AddPointShopItem("corruptedfragment",ITEMCAT_OTHER,			1000,				"weapon_zs_corruptedfragment")
GM:AddPointShopItem("medcloud",			ITEMCAT_OTHER,			15,				"weapon_zs_mediccloudbomb")
GM:AddPointShopItem("nanitecloud",		ITEMCAT_OTHER,			15,				"weapon_zs_nanitecloudbomb")
-- These are the honorable mentions that come at the end of the round.

local function genericcallback(pl, magnitude) return pl:Name(), magnitude end
GM.HonorableMentions = {}
GM.HonorableMentions[HM_MOSTZOMBIESKILLED] = {Name = "Most zombies killed", String = "by %s, with %d killed zombies.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTDAMAGETOUNDEAD] = {Name = "Most damage to undead", String = "goes to %s, with a total of %d damage dealt to the undead.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHEADSHOTS] = {Name = "Most headshot kills", String = "goes to %s, with a total of %s headshot kills.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_PACIFIST] = {Name = "Pacifist", String = "goes to %s for not killing a single zombie and still surviving!", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_MOSTHELPFUL] = {Name = "Most helpful", String = "goes to %s for assisting in the disposal of %d zombies.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_LASTHUMAN] = {Name = "Last Human", String = "goes to %s for being the last person alive.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_OUTLANDER] = {Name = "Outlander", String = "goes to %s for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_GOODDOCTOR] = {Name = "Good Doctor", String = "goes to %s for healing their team for %d points of health.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_HANDYMAN] = {Name = "Handy Man", String = "goes to %s for getting %d barricade assistance points.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_SCARECROW] = {Name = "Scarecrow", String = "goes to %s for killing %d poor crows.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_MOSTBRAINSEATEN] = {Name = "Most brains eaten", String = "by %s, with %d brains eaten.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_MOSTDAMAGETOHUMANS] = {Name = "Most damage to humans", String = "goes to %s, with a total of %d damage given to living players.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_LASTBITE] = {Name = "Last Bite", String = "goes to %s for ending the round.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_USEFULTOOPPOSITE] = {Name = "Most useful to opposite team", String = "goes to %s for giving up a whopping %d kills!", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_STUPID] = {Name = "Stupid", String = "is what %s is for getting killed %d feet away from a zombie spawn.", Callback = genericcallback, Color = COLOR_RED}
GM.HonorableMentions[HM_SALESMAN] = {Name = "Salesman", String = "is what %s is for having %d points worth of items taken from their arsenal crate.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_WAREHOUSE] = {Name = "Warehouse", String = "describes %s well since they had their resupply boxes used %d times.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_DEFENCEDMG] = {Name = "Defender", String = "goes to %s for protecting humans from %d damage with defence boosts.", Callback = genericcallback, Color = COLOR_WHITE}
GM.HonorableMentions[HM_STRENGTHDMG] = {Name = "Alchemist", String = "is what %s is for boosting players with an additional %d damage.", Callback = genericcallback, Color = COLOR_CYAN}
GM.HonorableMentions[HM_BARRICADEDESTROYER] = {Name = "Barricade Destroyer", String = "goes to %s for doing %d damage to barricades.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTDESTROYER] = {Name = "Nest Destroyer", String = "goes to %s for destroying %d nests.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_NESTMASTER] = {Name = "Nest Master", String = "goes to %s for having %d zombies spawn through their nest.", Callback = genericcallback, Color = COLOR_LIMEGREEN}
GM.HonorableMentions[HM_BESTBARRICADE] = {Name = "Barricader", String = "goes to %s for having their barricade take %d points of damage.", Callback = genericcallback, Color = COLOR_CYAN}


-- Don't let humans use these models because they look like undead models. Must be lower case.
GM.RestrictedModels = {
	"models/player/zombie_classic.mdl",
	"models/player/zombie_classic_hbfix.mdl",
	"models/player/zombine.mdl",
	"models/player/zombie_soldier.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/corpse1.mdl",
	"models/player/charple.mdl",
	"models/player/skeleton.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/soldier_stripped.mdl",
	"models/player/zelpa/stalker.mdl",
	"models/player/fatty/fatty.mdl",
	"models/player/zombie_lacerator2.mdl"
}

-- If a person has no player model then use one of these (auto-generated).
GM.RandomPlayerModels = {}
for name, mdl in pairs(player_manager.AllValidModels()) do
	if not table.HasValue(GM.RestrictedModels, string.lower(mdl)) then
		table.insert(GM.RandomPlayerModels, name)
	end
end

GM.DeployableInfo = {}
function GM:AddDeployableInfo(class, name, wepclass)
	local tab = {Class = class, Name = name or "?", WepClass = wepclass}

	self.DeployableInfo[#self.DeployableInfo + 1] = tab
	self.DeployableInfo[class] = tab

	return tab
end
GM:AddDeployableInfo("prop_arsenalcrate", 		"Arsenal Crate", 		"weapon_zs_arsenalcrate")
GM:AddDeployableInfo("prop_resupplybox", 		"Resupply Box", 		"weapon_zs_resupplybox")
GM:AddDeployableInfo("prop_remantler", 			"Weapon Remantler", 	"weapon_zs_remantler")
GM:AddDeployableInfo("prop_messagebeacon", 		"Message Beacon", 		"weapon_zs_messagebeacon")
GM:AddDeployableInfo("prop_camera", 			"Camera",	 			"weapon_zs_camera")
GM:AddDeployableInfo("prop_gunturret", 			"Gun Turret",	 		"weapon_zs_gunturret")
GM:AddDeployableInfo("prop_gunturret_assault", 	"Assault Turret",	 	"weapon_zs_gunturret_assault")
GM:AddDeployableInfo("prop_gunturret_buckshot",	"Blast Turret",	 		"weapon_zs_gunturret_buckshot")
GM:AddDeployableInfo("prop_gunturret_rocket",	"Rocket Turret",	 	"weapon_zs_gunturret_rocket")
GM:AddDeployableInfo("prop_repairfield",		"Repair Field Emitter",	"weapon_zs_repairfield")
GM:AddDeployableInfo("prop_zapper",				"Zapper",				"weapon_zs_zapper")
GM:AddDeployableInfo("prop_zapper_arc",			"Arc Zapper",			"weapon_zs_zapper_arc")
GM:AddDeployableInfo("prop_ffemitter",			"Force Field Emitter",	"weapon_zs_ffemitter")
GM:AddDeployableInfo("prop_manhack",			"Manhack",				"weapon_zs_manhack")
GM:AddDeployableInfo("prop_manhack_saw",		"Sawblade Manhack",		"weapon_zs_manhack_saw")
GM:AddDeployableInfo("prop_drone",				"Drone",				"weapon_zs_drone")
GM:AddDeployableInfo("prop_drone_pulse",		"Pulse Drone",			"weapon_zs_drone_pulse")
GM:AddDeployableInfo("prop_drone_hauler",		"Hauler Drone",			"weapon_zs_drone_hauler")
GM:AddDeployableInfo("prop_rollermine",			"Rollermine",			"weapon_zs_rollermine")
GM:AddDeployableInfo("prop_tv",                   	 "TV",                    	"weapon_zs_tv")

GM.MaxSigils = 1

GM.DefaultRedeem = CreateConVar("zs_redeem", "0", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The amount of kills a zombie needs to do in order to redeem. Set to 0 to disable."):GetInt()
cvars.AddChangeCallback("zs_redeem", function(cvar, oldvalue, newvalue)
	GAMEMODE.DefaultRedeem = math.max(0, tonumber(newvalue) or 0)
end)

GM.WaveOneZombies = 0--math.Round(CreateConVar("zs_waveonezombies", "0.1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "The percentage of players that will start as zombies when the game begins."):GetFloat(), 2)
-- cvars.AddChangeCallback("zs_waveonezombies", function(cvar, oldvalue, newvalue)
-- 	GAMEMODE.WaveOneZombies = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
-- end)

-- Game feeling too easy? Just change these values!
GM.ZombieSpeedMultiplier = math.Round(CreateConVar("zs_zombiespeedmultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Zombie running speed will be scaled by this value."):GetFloat(), 2)
cvars.AddChangeCallback("zs_zombiespeedmultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieSpeedMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

-- This is a resistance, not for claw damage. 0.5 will make zombies take half damage, 0.25 makes them take 1/4, etc.
GM.ZombieDamageMultiplier = math.Round(CreateConVar("zs_zombiedamagemultiplier", "1", FCVAR_REPLICATED + FCVAR_ARCHIVE + FCVAR_NOTIFY, "Scales the amount of damage that zombies take. Use higher values for easy zombies, lower for harder."):GetFloat(), 2)
cvars.AddChangeCallback("zs_zombiedamagemultiplier", function(cvar, oldvalue, newvalue)
	GAMEMODE.ZombieDamageMultiplier = math.ceil(100 * (tonumber(newvalue) or 1)) * 0.01
end)

GM.TimeLimit = CreateConVar("zs_timelimit", "15", FCVAR_ARCHIVE + FCVAR_NOTIFY, "Time in minutes before the game will change maps. It will not change maps if a round is currently in progress but after the current round ends. -1 means never switch maps. 0 means always switch maps."):GetInt() * 60
cvars.AddChangeCallback("zs_timelimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.TimeLimit = tonumber(newvalue) or 15
	if GAMEMODE.TimeLimit ~= -1 then
		GAMEMODE.TimeLimit = GAMEMODE.TimeLimit * 60
	end
end)

GM.RoundLimit = CreateConVar("zs_roundlimit", "3", FCVAR_ARCHIVE + FCVAR_NOTIFY, "How many times the game can be played on the same map. -1 means infinite or only use time limit. 0 means once."):GetInt()
cvars.AddChangeCallback("zs_roundlimit", function(cvar, oldvalue, newvalue)
	GAMEMODE.RoundLimit = tonumber(newvalue) or 3
end)

-- Static values that don't need convars...

-- Initial length for wave 1.
GM.WaveOneLength = 220

-- Add this many seconds for each additional wave.
GM.TimeAddedPerWave = 15

-- New players are put on the zombie team if the current wave is this or higher. Do not put it lower than 1 or you'll break the game.
GM.NoNewHumansWave = 7

-- Humans can not commit suicide if the current wave is this or lower.
GM.NoSuicideWave = -1

-- How long 'wave 0' should last in seconds. This is the time you should give for new players to join and get ready.
GM.WaveZeroLength = 180

-- Time humans have between waves to do stuff without NEW zombies spawning. Any dead zombies will be in spectator (crow) view and any living ones will still be living.
GM.WaveIntermissionLength = 60

-- Time in seconds between end round and next map.
GM.EndGameTime = 45

-- How many clips of ammo guns from the Worth menu start with. Some guns such as shotguns and sniper rifles have multipliers on this.
GM.SurvivalClips = 4 --2

-- How long do humans have to wait before being able to get more ammo from a resupply box?
GM.ResupplyBoxCooldown = 30

-- Put your unoriginal, 5MB Rob Zombie and Metallica music here.
GM.LastHumanSound = Sound("zombiesurvival/lasthuman.ogg")

-- Sound played when humans all die.
GM.AllLoseSound = Sound("zombiesurvival/music_lose.ogg")

-- Sound played when humans survive.
GM.HumanWinSound = Sound("zombiesurvival/music_win.ogg")

-- Sound played to a person when they die as a human.
GM.DeathSound = Sound("zombiesurvival/human_death_stinger.ogg")

-- Fetch map profiles and node profiles from noxiousnet database?
GM.UseOnlineProfiles = true

-- This multiplier of points will save over to the next round. 1 is full saving. 0 is disabled.
-- Setting this to 0 will not delete saved points and saved points do not "decay" if this is less than 1.
GM.PointSaving = 0

-- Lock item purchases to waves. Tier 2 items can only be purchased on wave 2, tier 3 on wave 3, etc.
-- HIGHLY suggested that this is on if you enable point saving. Always false if objective map, zombie escape, classic mode, or wave number is changed by the map.
GM.LockItemTiers = false

-- Don't save more than this amount of points. 0 for infinite.
GM.PointSavingLimit = 0

-- For Classic Mode
GM.WaveIntermissionLengthClassic = 20
GM.WaveOneLengthClassic = 120
GM.TimeAddedPerWaveClassic = 10

-- Max amount of damage left to tick on these. Any more pending damage is ignored.
GM.MaxPoisonDamage = 50
GM.MaxBleedDamage = 99999

-- Give humans this many points when the wave ends.
GM.EndWavePointsBonus = 0

-- Also give humans this many points when the wave ends, multiplied by (wave - 1)
GM.EndWavePointsBonusPerWave = 0
