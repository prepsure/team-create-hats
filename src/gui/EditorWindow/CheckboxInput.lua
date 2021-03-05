local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local getColor = require(root.gui.getColors)
local changeMouse = require(root.gui.changeMouse)


local CheckboxInput = Roact.Component:extend("CheckboxInput")

local implicitProps = {
    textWidth = 120,

    checkboxCornerRadius = 2,
    leftPadding = 20,
    topPadding = 10,
}


function CheckboxInput:boolToCheckColor(b)
    return b and getColor(self.props.Theme, "Blue") or getColor(self.props.Theme, "Gray")
end


function CheckboxInput:init()
    self.defaultProps = {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 50, 0, 50),
        ZIndex = 1,

        LabelText = "",
        Checked = false,
        ChangeMouse = true,

        callback = function() end,
    }

    assert(self.props.Theme ~= nil, "No theme found for checkbox")

    self.checkColor, self.updateCheckColor = Roact.createBinding(self:boolToCheckColor(self.props.Checked))
end


function CheckboxInput:render()
    return Roact.createFragment({
        Roact.createElement("Frame", {

            Size = self.props.Size + UDim2.new(0, -implicitProps.leftPadding, 0, 0),
            BackgroundTransparency = 1,
            ZIndex = self.props.ZIndex,

            Position = self.props.Position + UDim2.new(0, implicitProps.leftPadding, 0, 0),

        }, {
            Label = Roact.createElement("TextLabel", {

                Size = UDim2.new(0, implicitProps.textWidth, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = self.props.Theme:GetColor(
                    Enum.StudioStyleGuideColor.MainText,
                    Enum.StudioStyleGuideModifier.Default
                ),
                TextScaled = 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = self.props.ZIndex,

                Text = self.props.LabelText,

            }, {
                TSize = Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 12,
                }),
            }),
            Box = Roact.createElement("TextButton", {

                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, self.props.Size.Y.Offset * 3/5, 0, self.props.Size.Y.Offset * 3/5),
                Position = UDim2.new(0, implicitProps.textWidth + implicitProps.leftPadding, 0.5, 0),
                Text = "",
                AutoButtonColor = self.props.ChangeMouse,
                ZIndex = self.props.ZIndex,
                BackgroundColor3 = self:boolToCheckColor(self.props.Checked),

                [Roact.Event.Activated] = function()
                    self.props.callback()
                end,

                [Roact.Event.MouseEnter] = function()
                    changeMouse("PointingHand", self.props.ChangeMouse)
                end,
                [Roact.Event.MouseLeave] = function()
                    changeMouse("Arrow", self.props.ChangeMouse)
                end,

            }, {
                Corner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(0, implicitProps.checkboxCornerRadius),
                })
            }),
        })
    })

end


return CheckboxInput