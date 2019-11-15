-- manages settings and stores values of settings
local Settings = {}

local hatid = _G.plugin_990908723:GetSetting("HatID")
local height = _G.plugin_990908723:GetSetting("Height")
local transparency = _G.plugin_990908723:GetSetting("Transparency")
local enabled = _G.plugin_990908723:GetSetting("Enabled")

-- checks if any settings aren't nil, if all are nil (user has never used the plugin) it enables the plugin and sets default settings
function Settings.CheckForFirstTimeUseAndSetUp()
    if not hatid then
        Settings.SetHatId(1028826)
    end

    if not height then
        Settings.SetHeight(5)
    end

    if not transparency then
        Settings.SetTransparency(0)
    end

    -- enabled is a boolean value, so need to check if its initialized without "not"
    if enabled == nil then
        Settings.SetEnabled(true)
    end
end

function Settings.GetHatId()
    return hatid
end

function Settings.GetHeight()
    return height
end

function Settings.GetTransparency()
    return transparency
end

function Settings.GetEnabled()
    return enabled
end

function Settings.SetHatId(newHatid)
    hatid = newHatid
    _G.plugin_990908723:SetSetting("HatID", newHatid)
end

function Settings.SetHeight(newHeight)
    height = newHeight
    _G.plugin_990908723:SetSetting("Height", newHeight)
end

function Settings.SetTransparency(newTransparency)
    transparency = newTransparency
    _G.plugin_990908723:SetSetting("Transparency", newTransparency)
end

function Settings.SetEnabled(newEnabled)
    enabled = newEnabled
    _G.plugin_990908723:SetSetting("Enabled", newEnabled)
end

return Settings