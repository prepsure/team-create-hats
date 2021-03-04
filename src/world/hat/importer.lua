local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")


local Importer = {}


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