local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local getColor = require(root.gui.getColors)

local RadioButtonInput = Roact.Component:extend("LabeledNumberInput")


function RadioButtonInput:makeButton(pos)
    local total = #self.props.options
    local text = self.props.options[pos]

    return Roact.createElement("Frame", {
        Position = UDim2.new(0, 0, (pos-1)/total),
        Size = UDim2.new(1, 0, 1/total, 0),
        BackgroundTransparency = 1,
    }, {
        Text = Roact.createElement("TextLabel", {
            Position = UDim2.new(0.15, 0, 0, 0),
            Size = UDim2.new(0.6, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = self.props.Theme:GetColor(
                Enum.StudioStyleGuideColor.MainText,
                Enum.StudioStyleGuideModifier.Default
            ),
            TextXAlignment = Enum.TextXAlignment.Left,
        }),
        Button = Roact.createElement("TextButton", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(0.5, 0, 0.5, 0),
            Text = "",
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            BackgroundColor3 = (pos == self.props.selected) and
                getColor(self.props.Theme, "Blue") or
                getColor(self.props.Theme, "Gray"),

            [Roact.Event.Activated] = function()
                self.props.callback(pos)
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
                CornerRadius = UDim.new(1, 0),
            }),
        })
    })
end


function RadioButtonInput:init()
    self.props.LabelText = self.props.LabelText or ""

    self.props.Position = self.props.Position or UDim.new(0, 0)
    self.props.Size = self.props.Size or UDim.new(0, 30)

    self.props.options = self.props.options or {}
    self.props.selected = self.props.selected or 1
    assert(self.props.Theme ~= nil, "No theme found for numberinput")

    self.props.callback = self.props.callback or function() end
end


function RadioButtonInput:render()

    local generatedRadioButtons = {}

    for i = 1, #self.props.options do
        table.insert(generatedRadioButtons, self:makeButton(i))
    end


    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundTransparency = 1,

        }, {

            Label = Roact.createElement("TextLabel", {

                Size = UDim2.new(0.3, 0, 0, self.props.Size.Y.Offset/#self.props.options),
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

            RadioButtons = Roact.createElement("Frame", {

                Position = UDim2.new(0.3, 0, 0, 0),
                Size = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,

            }, generatedRadioButtons),

        })
    })
end


return RadioButtonInput