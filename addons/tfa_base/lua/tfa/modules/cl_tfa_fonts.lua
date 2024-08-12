TFA.Fonts = TFA.Fonts or {}

local ScaleH = TFA.ScaleH

local function GetFontHeight(fontname) -- UNCACHED!
	surface.SetFont(fontname)

	local _, h = surface.GetTextSize("W")

	return h
end

local function CreateFonts()
	local fontdata = {}

	fontdata.font = "Inter"
	fontdata.shadow = false
	fontdata.extended = true
	fontdata.weight = 400
	fontdata.size = ScaleH(36)
	surface.CreateFont("TFASleek", fontdata)
	TFA.Fonts.SleekHeight = GetFontHeight("TFASleek")

	fontdata.size = ScaleH(30)
	surface.CreateFont("TFASleekMedium", fontdata)
	TFA.Fonts.SleekHeightMedium = GetFontHeight("TFASleekMedium")

	fontdata.size = ScaleH(24)
	surface.CreateFont("TFASleekSmall", fontdata)
	TFA.Fonts.SleekHeightSmall = GetFontHeight("TFASleekSmall")

	fontdata.size = ScaleH(18)
	surface.CreateFont("TFASleekTiny", fontdata)
	TFA.Fonts.SleekHeightTiny = GetFontHeight("TFASleekTiny")

	fontdata = {}

	fontdata.font = "Inter"
	fontdata.extended = true
	fontdata.weight = 500
	fontdata.size = ScaleH(64)
	surface.CreateFont("TFA_INSPECTION_TITLE", fontdata)
	TFA.Fonts.InspectionHeightTitle = GetFontHeight("TFA_INSPECTION_TITLE")

	fontdata.size = ScaleH(32)
	surface.CreateFont("TFA_INSPECTION_DESCR", fontdata)
	TFA.Fonts.InspectionHeightDescription = GetFontHeight("TFA_INSPECTION_DESCR")

	fontdata.size = ScaleH(24)
	fontdata.weight = 400
	surface.CreateFont("TFA_INSPECTION_SMALL", fontdata)
	TFA.Fonts.InspectionHeightSmall = GetFontHeight("TFA_INSPECTION_SMALL")

	fontdata = {}
	fontdata.extended = true
	fontdata.weight = 400

	fontdata.font = "Inter"
	fontdata.size = ScaleH(12)
	surface.CreateFont("TFAAttachmentIconFont", fontdata)
	fontdata.size = ScaleH(10)
	surface.CreateFont("TFAAttachmentIconFontTiny", fontdata)

	fontdata.font = "Inter"
	fontdata.weight = 500
	fontdata.size = ScaleH(24)
	surface.CreateFont("TFAAttachmentTTHeader", fontdata)

	fontdata.font = "Inter"
	fontdata.weight = 300
	fontdata.size = ScaleH(18)
	surface.CreateFont("TFAAttachmentTTBody", fontdata)

	surface.CreateFont("TFASleekDebug", { font = "Roboto", size = 24, extended = true })
	TFA.Fonts.SleekHeightDebug = 24

	hook.Run("TFA_FontsLoaded")
end

CreateFonts()

hook.Add("OnScreenSizeChanged", "TFA_Fonts_Regenerate", CreateFonts)
cvars.AddChangeCallback("cl_tfa_hud_scale", CreateFonts, "TFA_RecreateFonts")