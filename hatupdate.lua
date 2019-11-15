local Settings = require(script.Parent.settings)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local HatUpdate = {}

HatUpdate._connection = nil
HatUpdate.CurrentHat = nil
HatUpdate.Folder = nil

local defaultfolder = (function()
	local folder = Instance.new("SunRaysEffect") -- i like the icon, it's easily recongnizable as something the person didn't put in the workspace
	folder.Name = "PlayerHats"
	
	folder.Enabled = false
	folder.Intensity = 0
	folder.Spread = 0
	
	return folder
end)()

local function makeFolder()
	local folder = defaultfolder:Clone()
	folder.Parent = workspace
	folder.Name = Players.LocalPlayer.Name.."'s hats"
    folder.Archivable = false
    HatUpdate.Folder = folder
	return folder
end

local function findFolder()
	if not HatUpdate.Folder then
		makeFolder()
	elseif HatUpdate.Folder.Parent ~= workspace then
		HatUpdate.Folder.Parent = workspace
	end
	return HatUpdate.Folder
end

local function findHat()
	if not HatUpdate.CurrentHat then
		require(script.Parent.changeproperty).ChangeHat(Settings.GetHatId()) -- equivalent to a makeHat() function
	elseif HatUpdate.CurrentHat ~= HatUpdate.Folder then
		HatUpdate.CurrentHat.Parent = HatUpdate.Folder
	end
	return HatUpdate.CurrentHat
end

function HatUpdate.GetHatPart()
	return findHat():FindFirstChildOfClass("Part")
end

local function moveHat()
    findFolder()
    HatUpdate.GetHatPart().CFrame = workspace.CurrentCamera.CFrame + Vector3.new(0, Settings.GetHeight(), 0)
end

function HatUpdate.UpdateHat(hat)
    if HatUpdate.CurrentHat then
        HatUpdate.CurrentHat:Destroy()
    end

    HatUpdate.CurrentHat = hat
    HatUpdate.CurrentHat.Archivable = false
    HatUpdate.CurrentHat.Handle.Locked = true
    HatUpdate.CurrentHat.Parent = findFolder()

    local handle = hat:FindFirstChildOfClass("Part")
    handle.LocalTransparencyModifier = Settings.GetTransparency()

    local attachment = handle:FindFirstChildOfClass("Attachment")
    if attachment then
        attachment:Destroy()
    end
end

function HatUpdate.Connect()
    HatUpdate._connection = RunService.RenderStepped:Connect(moveHat)
end

function HatUpdate.Disconnect()
    HatUpdate._connection:Disconnect()
	findHat():Destroy()
	HatUpdate.CurrentHat = nil
	findFolder():Destroy()
	HatUpdate.Folder = nil
end

return HatUpdate