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


local HatImporter = require(root.world.hat.importer)
local Hat = require(root.world.hat)
local PersistentInstance = require(root.world.persistentInstance)
local PersistentFolder = require(root.world.storage)

local StudioDocket = require(root.gui.studioDocket)
local PreviewWindow = require(root.gui.PreviewWindow)
local EditorWindow = require(root.gui.EditorWindow)


----------

local myId = 553870650
local _, accessory = HatImporter:LoadHat(myId)
local persistentAccessory = PersistentInstance.new(accessory, PersistentFolder)

local _, accessory2 = HatImporter:LoadHat(5064875017)

local myHats = {
    Hat.new(persistentAccessory, {
        offset = Vector3.new(0,1,0),
    }),
    Hat.new(PersistentInstance.new(accessory2, PersistentFolder), {
        scale = Vector3.new(1, 1, 1) * 1.1,
    })
}

PreviewWindow.mount(StudioDocket.Windows["Preview Hats"].Docket)
PreviewWindow.Settings.Hats = myHats

EditorWindow.mount(StudioDocket.Windows["Edit Hats"].Docket)