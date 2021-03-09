local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local NumberInput = require(script.Parent.NumberInput)


local LabeledNumberInput = Roact.Component:extend("LabeledNumberInput")


LabeledNumberInput.defaultProps = {
    LabelText = "",

    LayoutOrder = 0,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 30, 0, 30),

    NumType = "all",
    DefaultValue = "0",
    ChangeMouse = true,

    callback = function() end,
}


function LabeledNumberInput:render()
    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

            LayoutOrder = self.props.LayoutOrder,
            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundTransparency = 1,

        }, {

            Label = Roact.createElement("TextLabel", {

                Size = UDim2.new(0.5, 0, 1, 0),
                Text = self.props.LabelText,
                BackgroundTransparency = 1,
                TextColor3 = self.props.Theme:GetColor(
                    Enum.StudioStyleGuideColor.MainText,
                    Enum.StudioStyleGuideModifier.Default
                ),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,

            }, {
                TSize = Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 12,
                }),
            }),

            Input = Roact.createElement(NumberInput, {
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),

                NumType = self.props.NumType,
                Theme = self.props.Theme,
                DefaultValue = self.props.DefaultValue,
                ChangeMouse = self.props.ChangeMouse,

                callback = self.props.callback,
            }),

        })
    })
end


return LabeledNumberInput