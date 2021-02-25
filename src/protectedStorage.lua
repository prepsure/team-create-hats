local RunService = game:GetService("RunService")

local coolIconClass = "SunRaysEffect"
local userName = game:GetService("Players").LocalPlayer.Name



local ProtectedStorage = {}
ProtectedStorage.__index = ProtectedStorage


local function makeFolder()
    local folder = Instance.new(coolIconClass)
    folder.Parent = workspace
    folder.Name = userName .. "'s hats"

    return folder
end



function ProtectedStorage.new(parent)
    local self = setmetatable({}, ProtectedStorage)

    self.folder = makeFolder()
    self.parent = parent

    self.hats = {}
    self._putBackFolder = self.folder.AncestryChanged:Connect(function()
        self:_saveFolderFromDeletion()
    end)
    self._putBackItem = self.folder.DescendantRemoving:Connect(function(item)
        self:_saveItemFromDeletion(item)
    end)

    return self
end


function ProtectedStorage:AddHat(hat)
    table.insert(self.hats, hat)
    hat.model.Parent = self.folder
end


function ProtectedStorage:_saveFolderFromDeletion()
    RunService.Heartbeat:Wait()
    local success = pcall(function()
        self.folder.Parent = workspace
    end)

    if success then
        return
    end
    -- if we get to here, the folder was destroyed and we need to clean up the object

    self:Destroy()
end


function ProtectedStorage:_saveItemFromDeletion(item)
    local previousParent = item.Parent

    RunService.Heartbeat:Wait()
    local success = pcall(function()
        item.Parent = previousParent
    end)

    if success then
        return
    end

    for _, hat in pairs(self.hats) do
        if item == hat then
            hat:Destroy()
        end
    end
end


function ProtectedStorage:Destroy()
    self.folder:Destroy()

    self._putBackFolder:Disconnect()
    self._putBackFolder = nil

    for i, hat in pairs(self.hats) do
        hat:Destroy()
    end
    self.hats = nil

    self = nil
end


return ProtectedStorage