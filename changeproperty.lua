-- changes properties of the plugin and updates settings and guis accordingly

local ChangeProperty = {}

local Gui = require(script.Parent.gui)
local HatUpdate = require(script.Parent.hatupdate)
local Settings = require(script.Parent.settings)

function ChangeProperty.ChangeHat(hatId)
    -- if success returns true and hat is non nil, the id corresponds to a hat. if it doesn't, set the id back to the previous hat
    local success, hat = pcall(function()
        local hat = InsertService:LoadAsset(tonumber(hatId)):FindFirstChildOfClass("Accessory")
        return hat
    end)

    if success and hat then
        Settings.SetHatId(hatId)
        HatUpdate.UpdateHat(hat)
    else
        Gui.HatId:SetValue(Settings.GetHatId())
    end
end

function ChangeProperty.ChangeTransparent(visible)
    local transparency = visible and 0 or 1
    Settings.SetTransparency(transparency)
end

function ChangeProperty.ChangeHeight(height)
	if tonumber(h) then
        Settings.SetHeight(height)
    else
        Gui.Height:SetValue(Settings.GetHeight())
	end
end

function ChangeProperty.ChangeEnabled(state)
    Settings.SetEnabled(state)
    
	if state then
        HatUpdate.Connect()
    else
        HatUpdate.Disconnect()
	end
end

return ChangeProperty