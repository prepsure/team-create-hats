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

local HatController = require(root.world.hatController)

local StudioDocket = require(root.gui.studioDocket)
local PreviewWindow = require(root.gui.PreviewWindow)
local EditorWindow = require(root.gui.EditorWindow)


----------


HatController:Add(553870650)
HatController:ChangeProperty(1, "offset", Vector3.new(0,1,0))

HatController:Add(5064875017)
HatController:ChangeProperty(2, "scale", Vector3.new(1, 1, 1) * 1.1)

PreviewWindow.mount(StudioDocket.Windows["Preview Hats"].Docket)
PreviewWindow.Settings.Hats = HatController.List

EditorWindow.mount(StudioDocket.Windows["Edit Hats"].Docket)