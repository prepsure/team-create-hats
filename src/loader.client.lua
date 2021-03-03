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

local Settings = require(root.settings)


EditorWindow.mount(StudioDocket.Windows["Configure Hats"].Docket)
PreviewWindow.mount(StudioDocket.Windows["Preview Hats"].Docket)


Settings:Load()

local saveCxn = HatController:BindToUpdate(function()
    Settings:Save()
end)

plugin.Unloading:Connect(function()
    saveCxn:Disconnect()
end)