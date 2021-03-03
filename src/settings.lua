local root = script.Parent

local HatController = require(root.world.hatController)
local Previewer = require(root.gui.PreviewWindow)
local Editor = require(root.gui.EditorWindow)

local plugin = script:FindFirstAncestorWhichIsA("Plugin")


local Settings = {}

local default = {
    Enabled = true,
    VisibleLocally = false,
    DoHighlight = true,
    Hats = {
        {
            id = HatController.DefaultHat,
            props = {
                offset = {
                    X = 0,
                    Y = 2,
                    Z = 0,
                },
                scale = {
                    X = 1,
                    Y = 1,
                    Z = 1,
                },
                transformPriority = 1,
            }
        },
    },
}


local function deepCopy(orig)
    local copy

    if type(orig) == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepCopy(orig_key)] = deepCopy(orig_value)
        end
        -- setmetatable(copy, deepCopy(getmetatable(orig))) -- don't need to save metatables
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end


local function vector3ToTable(v3)
    return {X = v3.X, Y = v3.Y, Z = v3.Z}
end


local function vector3FromTable(t)
    return Vector3.new(t.X, t.Y, t.Z)
end


local function convertHatTableForSettings()
    local orig = HatController.List
    local new = {}

    for _, hat in pairs(orig) do
        local props = hat:GetPropertyTable()

        props.offset = vector3ToTable(props.offset)
        props.scale = vector3ToTable(props.scale)

        table.insert(new, {
            id = hat.id,
            props = props,
        })
    end

    return new
end


function Settings:Save()
    plugin:SetSetting("Enabled", Editor:getSetting('enabled'))
    plugin:SetSetting("VisibleLocally", Editor:getSetting('visibleLocally'))
    plugin:SetSetting("DoHighlight", Previewer.Settings.DoHighlight)
    plugin:SetSetting("HatTable", convertHatTableForSettings())
end


function Settings:Load()
    local current = {
        Enabled = plugin:GetSetting("Enabled"),
        VisibleLocally = plugin:GetSetting("VisibleLocally"),
        DoHighlight = plugin:GetSetting("DoHighlight"),
        Hats = plugin:GetSetting("HatTable"),
    }
    Settings:FillInSettingsWithDefault(current)

    -- load Enabled and VisibleLocally
    Editor:Load(current.Enabled, current.VisibleLocally)

    -- load DoHighlight
    Previewer.Settings.DoHighlight = current.DoHighlight

    -- load Hats
    for _, hat in ipairs(current.Hats) do
        hat.props.offset = vector3FromTable(hat.props.offset)
        hat.props.scale = vector3FromTable(hat.props.scale)

        HatController:Add(hat.id, nil, hat.props)
    end
end


function Settings:FillInSettingsWithDefault(current)

    for key, value in pairs(default) do
        if current[key] == nil then

            if type(value) ~= "table" then
                current[key] = deepCopy(value)
            else
                current[key] = value
            end

        end
    end

end


return Settings