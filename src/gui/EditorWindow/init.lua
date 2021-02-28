local root = script.Parent.Parent
local Roact = require(root.roact)

local HatController = require(root.world.hatController)
local PersistentFolder = require(root.world.persistentFolder)


local CheckboxInput = require(script.CheckboxInput)
local ButtonInput = require(script.ButtonInput)
local NumberInput = require(script.NumberInput)
local LabeledNumberInput = require(script.LabeledNumberInput)
local Vector3Input = require(script.Vector3Input)


local Editor = Roact.Component:extend("Editor")

local EditorSettings = {
    Hats = {}
}


function Editor:init()
    self:setState({
        theme = settings().Studio.Theme,
    })
end


function Editor:render()

    return Roact.createElement("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = self.state.theme:GetColor(
            Enum.StudioStyleGuideColor.MainBackground,
            Enum.StudioStyleGuideModifier.Default
        ),
    },
    {
        Enabled = Roact.createElement(CheckboxInput, {
            Position = UDim2.new(0, 0, 0, 10),
            Size = UDim2.new(1, 0, 0, 30),
            LabelText = "Enabled",
            Theme = self.state.theme,

            Checked = true,
            callback = function(state)
                PersistentFolder:Reparent(state and workspace or false)
            end
        }),

        VisibleLocally = Roact.createElement(CheckboxInput, {
            Position = UDim2.new(0, 0, 0, 50),
            Size = UDim2.new(1, 0, 0, 30),
            LabelText = "Visible to Self",
            Theme = self.state.theme,

            Checked = false,
            callback = function(state)
                HatController:ChangePropertyOnAll("VisibleLocally", state)
            end
        }),

        ImportHats = Roact.createElement(ButtonInput, {
            Text = "Import Hats from Character",
            Color = Color3.fromRGB(74, 157, 253),
            YPosition = UDim.new(0, 90),
            YSize = UDim.new(0, 30),

            callback = function()
                HatController:ImportFromCharacter() --TODO add a confirmation popup window
            end
        }),

        AccessoryId = Roact.createElement(LabeledNumberInput, {
            Position = UDim2.new(0, 20, 0, 170),
            Size = UDim2.new(1, -40, 0, 30),

            LabelText = "Accessory Id",
            Theme = self.state.theme,
            NumType = "whole",
        }),

        Offset = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 210),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = Vector3.new(0, 0, 0),

            LabelText = "Offset",
            Theme = self.state.theme,
        }),

        Scale = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 250),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = Vector3.new(0, 0, 0),

            LabelText = "Scale",
            Theme = self.state.theme,
        }),

        RemoveHat = Roact.createElement(ButtonInput, {
            Text = "Remove Hat",
            Color = Color3.fromRGB(245, 106, 106),
            YPosition = UDim.new(0, 330),
            YSize = UDim.new(0, 30),

            callback = function()

            end
        }),

    })
end


function Editor:didMount()
    settings().Studio.ThemeChanged:Connect(function()
        self:setState(function(state)
            state.theme = settings().Studio.Theme
            return state
        end)
    end)
end


return setmetatable({
    Settings = EditorSettings,

    mount = function(docket)
        Roact.mount(Roact.createElement(Editor), docket, "Editor UI")
    end,

}, {__index = Editor})