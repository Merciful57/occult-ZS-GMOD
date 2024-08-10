SIGHT.Base = "ins2_si_kobra" -- base sight attachment ID

SIGHT.Name = "CMore RDS" -- new ATTACHMENT.Name, optional
SIGHT.Icon = "entities/ins2_si_cmore_blitz.png" -- new ATTACHMENT.Icon, optional
SIGHT.ShortName = "CMORE" -- new ATTACHMENT.ShortName, optional

SIGHT.BaseElement = "sight_kobra" -- name of VElement/WElement to look up
SIGHT.ReplacementElement = "sight_kobra_blitz" -- name of new VElement/WElement to copy data into
SIGHT.VElement = {"models/weapons/tfa_ins2/upgrades/a_optic_kobra", "models/weapons/upblitz/a_optic_cmore"} -- VElement model prefix replacement, sight is added to weapon only if model prefix matches this value
SIGHT.WElement = {"models/weapons/tfa_ins2/upgrades/w_kobra", "models/weapons/upblitz/w_cmore"} -- WElement model prefix replacement, optional

SIGHT.ReticleData = {
    material = "models/weapons/tfa_ins2/optics/kobra_dot",
    dist = 4,
    size = .15,
    bone = "A_RenderReticle"
} -- holo reticle data, optional, requires all values to be present; falls back to base attachment's holo if needed
-- default values:
-- {material = "models/weapons/tfa_ins2/optics/kobra_dot", dist = 4, size = 0.15, bone = "A_RenderReticle"} -- sight_kobra
-- {material = "models/weapons/tfa_ins2/optics/eotech_reticule_holo", dist = 7, size = 0.28, bone = "A_RenderReticle"} -- sight_eotech
-- {material = "models/weapons/tfa_ins2/optics/aimpoint_reticule_holo", dist = 5, size = 0.05, bone = "A_RenderReticle"} -- sight_rds
