local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local NumberInput = require(script.Parent.NumberInput)


local LabeledNumberInput = Roact.Component:extend("LabeledNumberInput")


function LabeledNumberInput:init()
    self.props.LabelText = self.props.LabelText or ""

    self.props.Position = self.props.Position or UDim.new(0, 0)
    self.props.Size = self.props.Size or UDim.new(0, 30)

    self.props.NumType = self.props.NumType or "all"
    self.props.DefaultValue = self.props.DefaultValue or "0"
    assert(self.props.Theme ~= nil, "No theme found for numberinput")

    self.props.callback = self.props.callback or function() end
end


function LabeledNumberInput:render()
    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

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

                callback = self.props.callback,
            }),

        })
    })
end


return LabeledNumberInput