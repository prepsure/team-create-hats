-- manages settings and stores values of settings
local Settings = {}

local hatid = plugin:GetSetting("HatID")
local height = plugin:GetSetting("Height")
local transparency = plugin:GetSetting("Transparency")
local enabled = plugin:GetSetting("Enabled")

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
    plugin:SetSetting("HatID", newHatid)
end

function Settings.SetHeight(newHeight)
    height = newHeight
    plugin:SetSetting("Height", newHeight)
end

function Settings.SetTransparency(newTransparency)
    transparency = newTransparency
    plugin:SetSetting("Transparency", newTransparency)
end

function Settings.SetEnabled(newEnabled)
    enabled = newEnabled
    plugin:SetSetting("Enabled", newEnabled)
end



return 0