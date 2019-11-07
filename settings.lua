-- manages settings and stores values of settings
local Settings = {}

local hatid = plugin:GetSetting("HatID")
local height = plugin:GetSetting("Height")
local transparency = plugin:GetSetting("Transparency")
local enabled = plugin:GetSetting("Enabled")

local function storeValue

-- checks if any settings aren't nil, if all are nil (user has never used the plugin) it enables the plugin and sets default settings
function Settings.CheckForFirstTimeUse()
    if not hatid then
        plugin:SetSetting("HatID", 1028826)
    end

    if not height then
        plugin:SetSetting("Height", 5)
    end

    if not transparency then
        plugin:SetSetting("Transparency", 0)
    end

    -- enabled is a boolean value, so need to check if its initialized without "not"
    if enabled == nil then
        plugin:SetSetting("Enabled", true)
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

function Settings.SetHatId()

end

function Settings.SetHeight()

end

function Settings.SetTransparency()

end

function Settings.SetEnabled()

end



return 0