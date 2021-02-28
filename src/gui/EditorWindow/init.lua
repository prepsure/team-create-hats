local root = script.Parent.Parent
local Roact = require(root.roact)

local HatController = require(root.world.hatController)
local PersistentFolder = require(root.world.persistentFolder)


local CheckboxInput = require(script.CheckboxInput)
local ButtonInput = require(script.ButtonInput)


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

        RemoveHat = Roact.createElement(ButtonInput, {
            Text = "Remove Hat",
            Color = Color3.fromRGB(245, 106, 106),
            YPosition = UDim.new(0, 300),
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