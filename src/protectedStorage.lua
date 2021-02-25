local RunService

local coolIconClass = "SunRaysEffect"
local userName = game:GetService("Players").LocalPlayer.Name



local ProtectedStorage = {}
ProtectedStorage.__index = ProtectedStorage


function ProtectedStorage.new(parent)
    local self = setmetatable({}, ProtectedStorage)

    local folder = Instance.new(coolIconClass)
    folder.Parent = workspace
    folder.Name = userName .. "'s hats"

    self.folder = folder
    self.parent = parent

    self.items = {}
    self._putBackFolder = folder.AncestryChanged:Connect(function()
        self:_saveFolderFromDeletion()
    end)


    return self
end


function ProtectedStorage:AddItem()

end


function ProtectedStorage:_saveFolderFromDeletion()
    self.folder.Parent = self.parent
end


function ProtectedStorage:_saveItemFromDeletion()
    
end


function ProtectedStorage:Destroy()
    self._putBackFolder:Disconnect()
    self._putBackFolder = nil
    self = nil
end


return ProtectedStorage