-- team create with hats: version 4
-- presssssure
-- 2021-02-24

--

local root = script.Parent
local shouldRun = require(root.prechecks)

if not shouldRun then
    return
end



--

local components = {
    hatImporter = require(root.hat.importer),
    hat = require(root.hat),
}


local myId = 553870650
local statusCode, accessory = components.hatImporter:LoadHat(myId)
components.hat.new(accessory, {
    id = myId,
    offset = Vector3.new(0,5,0),
    scale = accessory.Handle.Mesh.Scale,
    transformPriority = "Translate",
    visibleLocally = true,
})

accessory.Parent = workspace