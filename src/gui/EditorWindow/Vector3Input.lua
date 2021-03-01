local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local NumberInput = require(script.Parent.NumberInput)


local Vector3Input = Roact.Component:extend("Vector3Input")


function Vector3Input:updateValue()
    self.props.callback(self.props.DefaultValue)
end


function Vector3Input:init()
    self.props.LabelText = self.props.LabelText or ""

    self.props.Position = self.props.Position or UDim.new(0, 0)
    self.props.Size = self.props.Size or UDim.new(0, 30)

    self.props.DefaultValue = self.props.DefaultValue or Vector3.new(0, 0, 0)
    assert(self.props.Theme ~= nil, "No theme found for numberinput")

    self.props.callback = self.props.callback or function() end
end


function Vector3Input:render()
    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundTransparency = 1,

        }, {

            Label = Roact.createElement("TextLabel", {

                Size = UDim2.new(0.3, 0, 1, 0),
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

            X = Roact.createElement(NumberInput, {
                Position = UDim2.new(0.3, 0, 0, 0),
                Size = UDim2.new(0.2, 0, 1, 0),

                NumType = "all",
                Theme = self.props.Theme,
                DefaultValue = self.props.DefaultValue.X,

                callback = function(num)
                    self.props.DefaultValue = Vector3.new(num, 0, 0) + (self.props.DefaultValue * Vector3.new(0, 1, 1))
                    self:updateValue()
                end,
            }),

            Comma1 = Roact.createElement("TextLabel", {

                Position = UDim2.new(0.525, 0, 0, 0),
                Size = UDim2.new(0.05, 0, 1, 0),
                Text = ",",
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

            Y = Roact.createElement(NumberInput, {
                Position = UDim2.new(0.55, 0, 0, 0),
                Size = UDim2.new(0.2, 0, 1, 0),

                NumType = "all",
                Theme = self.props.Theme,
                DefaultValue = self.props.DefaultValue.Y,

                callback = function(num)
                    self.props.DefaultValue = Vector3.new(0, num, 0) + (self.props.DefaultValue * Vector3.new(1, 0, 1))
                    self:updateValue()
                end,
            }),

            Comma2 = Roact.createElement("TextLabel", {

                Position = UDim2.new(0.775, 0, 0, 0),
                Size = UDim2.new(0.05, 0, 1, 0),
                Text = ",",
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

            Z = Roact.createElement(NumberInput, {
                Position = UDim2.new(0.8, 0, 0, 0),
                Size = UDim2.new(0.2, 0, 1, 0),

                NumType = "all",
                Theme = self.props.Theme,
                DefaultValue = self.props.DefaultValue.Z,

                callback = function(num)
                    self.props.DefaultValue = Vector3.new(0, 0, num) + (self.props.DefaultValue * Vector3.new(1, 1, 0))
                    self:updateValue()
                end,
            }),

        })
    })
end


return Vector3Input