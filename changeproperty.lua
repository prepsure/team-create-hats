-- changes properties of the plugin and updates settings and guis accordingly

local ChangeProperty = {}

local Gui = require(script.Parent.gui)
local Settings = require(script.Parent.settings)
local HatUpdate = require(script.Parent.hatupdate)

local InsertService = game:GetService("InsertService")

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
        Gui.TextboxHatID:SetValue(Settings.GetHatId())
    end
end

function ChangeProperty.ChangeHeight(height)
	if tonumber(height) then
        Settings.SetHeight(height)
    else
        Gui.TextboxHeight:SetValue(Settings.GetHeight())
	end
end

function ChangeProperty.ChangeTransparent(visible)
    local transparency = visible and 0 or 1
    Settings.SetTransparency(transparency)
	HatUpdate.GetHatPart().LocalTransparencyModifier = transparency
end

function ChangeProperty.ChangeEnabled(state)
    Settings.SetEnabled(state)
    
	if state then
        HatUpdate.Connect()
    else
        HatUpdate.Disconnect()
	end
end

Gui.TextboxHatID:GetFrame().Wrapper.TextBox.FocusLost:Connect(function()
	ChangeProperty.ChangeHat(Gui.TextboxHatID:GetValue())
end)
Gui.TextboxHeight:GetFrame().Wrapper.TextBox.FocusLost:Connect(function()
	ChangeProperty.ChangeHeight(Gui.TextboxHeight:GetValue())
end)
Gui.CheckboxEnabled:SetValueChangedFunction(ChangeProperty.ChangeEnabled)
Gui.CheckboxTransparency:SetValueChangedFunction(ChangeProperty.ChangeTransparent)

return ChangeProperty