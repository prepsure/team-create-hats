local root = script.Parent.Parent

local Hat = require(root.world.hat)
local Importer = require(root.world.hat.importer)
local PersistentInstance = require(root.world.persistentInstance)
local PersistentFolder = require(root.world.persistentFolder)

local update = Instance.new("BindableEvent")


local HatController = {}
HatController.List = {}


HatController.MaxHats = 10
local defaultHat = 1028826


function HatController:_insert(id, model, index, properties)
    assert(#HatController.List < HatController.MaxHats, "cannot go above max hats")

    local persistentModel = PersistentInstance.new(model, PersistentFolder)
    local hat = Hat.new(id, persistentModel, properties)

    index = index or (#HatController.List + 1)
    table.insert(HatController.List, index, hat)

    self:_update()

    return hat
end


function HatController:Add(id, index, properties)
    id = id or defaultHat

    local _, model = Importer:LoadHat(id)

    return self:_insert(id, model, index, properties)
end


function HatController:ChangeProperty(index, property, value)
    if #HatController.List == 0 then
        return
    end


    local hat = self.List[index]

    if property == 'id' then -- for id changing, a new hat has to be imported, for other properties we can just modify the hat
        local oldProperties = hat:GetPropertyTable()

        self:Remove(index)
        self:Add(value, index, oldProperties)
    else
        hat["Set" .. property](hat, value)
    end

    self:_update()
end


function HatController:ChangePropertyOnAll(property, value)
    for i = 1, #HatController.List do
        self:ChangeProperty(i, property, value)
    end
end


function HatController:Remove(index)
    if #HatController.List == 0 then
        return
    end


    local hat = table.remove(HatController.List, index)
    hat:Destroy()

    self:_update()
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
        self:_insert("0", hat)
    end
end


function HatController:_update()
    update:Fire()
end


function HatController:BindToUpdate(func)
    return update.Event:Connect(func)
end


return HatController