local root = script.Parent.Parent

local PersistentInstance = require(root.world.persistentInstance)

local CollectionService = game:GetService("CollectionService")
local yourHatTag = game:GetService("Players").LocalPlayer.Name .. "'s hats"


function makeFolder(coolClassIcon)
    local folder = Instance.new(coolClassIcon)
    folder.Name = yourHatTag
    CollectionService:AddTag(folder, yourHatTag)

    return folder
end


local PersistentFolder = PersistentInstance.new(makeFolder("SunRaysEffect"), workspace)

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local unloadingCxn = nil

unloadingCxn = plugin.Unloading:Connect(function()
    PersistentFolder:Destroy()
    unloadingCxn:Disconnect()
end)


return PersistentFolder