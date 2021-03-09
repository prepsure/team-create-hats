local InsertService = game:GetService("InsertService")
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

local inactiveCollisionGroup = require(script.Parent.CommonCollisionGroup)

local Importer = {}


function removeAttachmentsAndSetCollisions(model)
    local children = model:GetChildren()

    if #children == 0 then
        return
    end

    for _, child in pairs(children) do

        removeAttachmentsAndSetCollisions(child)

        if child:IsA("Attachment") then
            child:Destroy()
        elseif child:IsA("BasePart") then
            PhysicsService:SetPartCollisionGroup(child, inactiveCollisionGroup)
        end

    end
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

    if not hat.Handle:FindFirstChildOfClass("SpecialMesh") then
        model:Destroy()
        return 406, "no mesh found"
    end

    hat.Handle.Anchored = true
    hat.Handle.CastShadow = false

    removeAttachmentsAndSetCollisions(hat)

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