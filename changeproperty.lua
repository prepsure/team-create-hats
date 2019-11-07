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

--[=[
local function ChangeHat()
	--[
	local HatID = TextboxHatID:GetValue()
	if HatID ~= "" then
		local success,Hat = pcall(function()
			local Hat = InsertService:LoadAsset(tonumber(HatID)):FindFirstChildOfClass("Accessory")
			return Hat
		end)
		if success then
			if CurrentHat then
				CurrentHat:Destroy()
			end
			
			CurrentHat = Hat
			CurrentHat.Archivable = false
			CurrentHat.Handle.Locked = true
			CurrentHat.Parent = Folder
			plugin:SetSetting("HatID",HatID)
			CurrentHat.Handle.CFrame = workspace.CurrentCamera.CFrame + Vector3.new(0, plugin:GetSetting("Height"), 0)
			CurrentHat.Handle.LocalTransparencyModifier = plugin:GetSetting("Transparency")
			if CurrentHat.Handle:FindFirstChildOfClass("Attachment") then
				CurrentHat.Handle:FindFirstChildOfClass("Attachment"):Destroy()
			end
		else
			TextboxHatID:SetValue(plugin:GetSetting("HatID"))
		end
	else
		TextboxHatID:SetValue(plugin:GetSetting("HatID"))
	end
	--]]
end

local function ChangeHeight()
	local h = TextboxHeight:GetValue()
	if tonumber(h) and (h ~= "") then
		plugin:SetSetting("Height",TextboxHeight:GetValue())
	else
		TextboxHeight:SetValue(plugin:GetSetting("Height"))
	end
end

local function ChangeTransparency(visible)
	local transparency = visible and 0 or 1
	plugin:SetSetting("Transparency",transparency)
end
--]=]

return ChangeProperty