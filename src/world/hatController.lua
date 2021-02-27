local root = script.Parent.Parent

local Hat = require(root.world.hat)
local Importer = require(root.world.hat.importer)
local PersistentInstance = require(root.world.persistentInstance)
local PersistentFolder = require(root.world.persistentFolder)


local HatController = {}
HatController.List = {}


function HatController:_insert(model, index, properties)
    local persistentModel = PersistentInstance.new(model, PersistentFolder) -- TODO: get persistent folder
    local hat = Hat.new(persistentModel, properties)

    index = index or (#HatController.List + 1)
    table.insert(HatController.List, index, hat)

    return hat
end


function HatController:Add(id, index, properties)
    local _, model = Importer:LoadHat(id)

    return self:_insert(model, index, properties)
end


function HatController:ChangeProperty(index, property, value)
    local hat = self.List[index]

    if property == 'id' then -- for id changing, a new hat has to be imported, for other properties we can just modify the hat
        local oldProperties = hat:GetPropertyTable()

        self:Remove(index)
        self:Add(value, index, oldProperties)

        return
    end

    hat["Set" .. property](hat, value)
end


function HatController:Remove(index)
    local hat = table.remove(HatController.List, index)
    hat:Destroy()
end


function HatController:RemoveAll()
    for _ = 1, #HatController.List do
        HatController:Remove()
    end
end


function HatController:ImportFromCharacter()
    local hats = Importer:LoadHatsFromCharacter()

    self:RemoveAll()

    for _, hat in pairs(hats) do
        self:_insert(hat)
    end
end


return HatController