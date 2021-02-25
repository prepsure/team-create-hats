-- team create with hats: version 4
-- presssssure
-- 2021-02-24


local root = script.Parent
local shouldRun = require(root.prechecks)

if not shouldRun then
    return
end


----------

-- cleanup from last time
local CollectionService = game:GetService("CollectionService")
local yourHatTag = game:GetService("Players").LocalPlayer.Name .. "'s hats"

for _, f in pairs(CollectionService:GetTagged(yourHatTag)) do
    f:Destroy()
end

----------

local HatImporter = require(root.hat.importer)
local Hat = require(root.hat)
local Storage = require(root.storage)
local PersistentInstance = require(root.persistentInstance)

local folder = Storage("SunRaysEffect", game:GetService("Players").LocalPlayer.Name)
CollectionService:AddTag(folder, yourHatTag)
local persistentFolder = PersistentInstance.new(folder, workspace)

local myId = 553870650
local statusCode, accessory = HatImporter:LoadHat(myId)

local persistentAccessory = PersistentInstance.new(accessory, persistentFolder)

local myHat = Hat.new(persistentAccessory, {
    id = myId,
    offset = Vector3.new(0,5,0),
    scale = accessory.Handle.Mesh.Scale,
    transformPriority = "Translate",
    visibleLocally = true,
})