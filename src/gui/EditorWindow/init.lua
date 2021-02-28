local root = script.Parent.Parent
local Roact = require(root.roact)


local CheckboxInput = require(script.CheckboxInput)


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
    print('rendering!')

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
            LabelText = "Enabled",
            Theme = self.state.theme,
            Checked = true,
        }),
        VisibleLocally = Roact.createElement(CheckboxInput, {
            Position = UDim2.new(0, 0, 0, 50),
            LabelText = "Visible to Self",
            Theme = self.state.theme,
            Checked = false,
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