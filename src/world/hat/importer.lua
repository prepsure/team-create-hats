local InsertService = game:GetService("InsertService")
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local inactiveCollisionGroup = require(script.Parent.CommonCollisionGroup)

local Importer = {}


local function cleanModel(model)
    local children = model:GetChildren()

    if #children == 0 then
        return
    end

    for _, child in pairs(children) do

        cleanModel(child)

        if child:IsA("Attachment") or child:IsA("LuaSourceContainer") then
            child:Destroy()
        elseif child:IsA("BasePart") then
            PhysicsService:SetPartCollisionGroup(child, inactiveCollisionGroup)
            child.Locked = true
        end

    end
end


local function makeIntoSpecialMesh(meshpart)
    local part = Instance.new("Part")
    local mesh = Instance.new("SpecialMesh")

    part.Name = meshpart.Name
    part.Size = Vector3.new(2,2,2)

    mesh.MeshId = meshpart.MeshId
    mesh.TextureId = meshpart.TextureID
    mesh.Parent = part

    for _, inst in pairs(meshpart:GetChildren()) do
        inst.Parent = part
    end

    part.Parent = meshpart.Parent
    meshpart:Destroy()

    return part
end


function Importer:LoadHat(id)
    local success, model = pcall(function()
        return InsertService:LoadAsset(id)
    end)

    if not success then
        return 404, "id not found"
    end

    local hat = model:FindFirstChildOfClass("Accessory", true)

    if not hat then
        model:Destroy()
        return 428, "id is not an accessory"
    end

    if not hat:FindFirstChild("Handle") then
        model:Destroy()
        return 406, "no handle found"
    end

    if hat.Handle:IsA("MeshPart") then
        makeIntoSpecialMesh(hat.Handle)
    end

    if not hat.Handle:FindFirstChildOfClass("SpecialMesh") then
        model:Destroy()
        return 406, "no mesh found"
    end

    hat.Handle.Anchored = true
    hat.Handle.CastShadow = false

    cleanModel(hat)

    return 200, hat
end


function Importer:LoadHatsFromCharacter()
    local charAppearance = Players:GetCharacterAppearanceInfoAsync(Players.LocalPlayer.UserId)
    local ids = {}

    for _, asset in pairs(charAppearance.assets) do
        if asset.assetType.name == "Hat" or asset.assetType.name:find("Accessory") then
            table.insert(ids, asset.id)
        end
    end

    return ids
end


return Importer