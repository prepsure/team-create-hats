local Settings = require(script.Parent.settings)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local HatUpdate = {}

HatUpdate._connection = nil
HatUpdate.CurrentHat = nil
HatUpdate.Folder = nil

local function makeFolder()
	folder = script["Player'sHats"]:Clone()
	folder.Parent = workspace
	folder.Name = Players.LocalPlayer.Name.."'s hats"
    folder.Archivable = false
    HatUpdate.Folder = folder
	return folder
end

local function moveHat()
    if not HatUpdate.Folder then
        makeFolder
    end
    if not HatUpdate.CurrentHat then
        HatUpdate.UpdateHat(--[[TODO]])
    end
    CurrentHat:FindFirstChildOfClass("Part").CFrame = workspace.CurrentCamera.CFrame + Vector3.new(0, Settings.GetHeight(), 0)
end

function HatUpdate.UpdateHat(hat)
    if HatUpdate.CurrentHat then
        HatUpdate.CurrentHat:Destroy()
    end

    CurrentHat = hat
    CurrentHat.Archivable = false
    CurrentHat.Handle.Locked = true
    CurrentHat.Parent = HatUpdate.Folder or makeFolder() -- TODO: create this folder somewhere

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
end

return HatUpdate