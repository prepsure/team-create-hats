local root = script.Parent.Parent.Parent
local Roact = require(root.roact)


local CheckboxInput = Roact.Component:extend("CheckboxInput")

local implicitProps = {
    height = 30,
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
    self.props.LabelText = self.props.LabelText or ""
    self.props.Checked = self.props.Checked or false
    self.props.callback = self.props.callback or function() end
    assert(self.props.Theme ~= nil, "No theme found for checkbox")


    self.checkColor, self.updateCheckColor = Roact.createBinding(boolToCheckColor(self.props.Checked))
end

function CheckboxInput:render()
    return Roact.createFragment({
        Roact.createElement("Frame", {

            Size = UDim2.new(1, -implicitProps.leftPadding, 0, implicitProps.height),
            BackgroundTransparency = 1,

            Position = self.props.Position + UDim2.new(0, implicitProps.leftPadding, 0, 0),

        }, {
            Label = Roact.createElement("TextLabel", {

                Size = UDim2.new(0.4, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = self.props.Theme:GetColor(
                    Enum.StudioStyleGuideColor.MainText,
                    Enum.StudioStyleGuideModifier.Default
                ),
                TextSize = 12,
                TextXAlignment = Enum.TextXAlignment.Left,

                Text = self.props.LabelText,

            }),
            Box = Roact.createElement("TextButton", {

                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(0, implicitProps.height * 3/5, 0, implicitProps.height * 3/5),
                Position = UDim2.new(0.4, 0, 0.5, 0),
                Text = "",
                BackgroundColor3 = self.checkColor,

                [Roact.Event.Activated] = function()
                    self.props.Checked = not self.props.Checked
                    self.updateCheckColor(boolToCheckColor(self.props.Checked))
                end

            }, {
                Corner = Roact.createElement("UICorner", {
                    CornerRadius = UDim.new(0, implicitProps.checkboxCornerRadius),
                })
            }),
        })
    })

end


return CheckboxInput