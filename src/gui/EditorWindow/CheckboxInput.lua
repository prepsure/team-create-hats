local root = script.Parent.Parent.Parent
local Roact = require(root.roact)


local CheckboxInput = Roact.Component:extend("CheckboxInput")

local implicitProps = {
    textWidth = 120,

    checkboxCornerRadius = 2,
    leftPadding = 20,
    topPadding = 10,

    clickedColor = Color3.fromRGB(74, 157, 253),
    unclickedColor = Color3.fromRGB(137, 137, 137),
}


local function boolToCheckColor(b)
    return b and implicitProps.clickedColor or implicitProps.unclickedColor
end


function CheckboxInput:init()
    self.props.Position = self.props.Position or UDim2.new(0, 0, 0, 0)
    self.props.Size = self.props.Size or UDim2.new(0, 50, 0, 50)
    self.props.LabelText = self.props.LabelText or ""
    self.props.Checked = self.props.Checked or false
    self.props.ZIndex = self.props.ZIndex or 1
    self.props.callback = self.props.callback or function() end
    assert(self.props.Theme ~= nil, "No theme found for checkbox")

    self.checkColor, self.updateCheckColor = Roact.createBinding(boolToCheckColor(self.props.Checked))
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
                ZIndex = self.props.ZIndex,
                BackgroundColor3 = boolToCheckColor(self.props.Checked),

                [Roact.Event.Activated] = function()
                    self.props.callback()
                end,

                [Roact.Event.MouseEnter] = function()
                    local pluginMouse = script:FindFirstAncestorWhichIsA("Plugin"):GetMouse()
                    pluginMouse.Icon = "rbxasset://SystemCursors/PointingHand"
                end,
                [Roact.Event.MouseLeave] = function()
                    local pluginMouse = script:FindFirstAncestorWhichIsA("Plugin"):GetMouse()
                    pluginMouse.Icon = "rbxasset://SystemCursors/Arrow"
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