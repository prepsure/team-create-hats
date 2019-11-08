local HatUpdate = {}

HatUpdate._connection
HatUpdate.CurrentHat

local function moveHat()
    CurrentHat:FindFirstChildOfClass("Part").CFrame = workspace.CurrentCamera.CFrame + Vector3.new(0, Settings.GetHeight(), 0)
end

function HatUpdate.UpdateHat(hat)
    if HatUpdate.CurrentHat then
        HatUpdate.CurrentHat:Destroy()
    end

    CurrentHat = hat
    CurrentHat.Archivable = false
    CurrentHat.Handle.Locked = true
    CurrentHat.Parent = Folder

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