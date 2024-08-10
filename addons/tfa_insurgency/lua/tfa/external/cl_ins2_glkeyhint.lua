hook.Add("TFA_PopulateKeyBindHints", "INS2_GL_Hint", function(wep, keys)
    if wep:IsAttached("ins2_fg_gp25") or wep:IsAttached("ins2_fg_m203") then
        table.insert(keys, {
            label = language.GetPhrase("tfa.hint.keys.grenadelauncher"),
            keys = {wep:GetKeyBind({"+use", "+attack"})}
        })
    end
end)

list.Set("ContentCategoryIcons", "TFA Insurgency", "icon16/tfa/ins2.png")
list.Set("ContentCategoryIcons", "TFA Day of Infamy", "icon16/tfa/doi.png")