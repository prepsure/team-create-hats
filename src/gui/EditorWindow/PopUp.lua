local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local Button = require(script.Parent.ButtonInput)
local getColor = require(root.gui.getColors)

local PopUp = Roact.Component:extend("LabeledNumberInput")


function PopUp:init()
    self.props.Text = self.props.Text or ""

    self.props.Position = self.props.Position or UDim.new(0, 0)
    self.props.Size = self.props.Size or UDim.new(0, 30)

    self.props.OnScreen = self.props.OnScreen or false

    self.props.OkText = self.props.OkText or "Ok"
    self.props.CancelText = self.props.CancelText or "Cancel"

    assert(self.props.Theme ~= nil, "No theme found for popup")

    self.props.callback = self.props.callback or function() end
end


function PopUp:render()
    return Roact.createFragment({
        PopUpBackground = Roact.createElement("TextButton", {

            BackgroundColor3 = Color3.fromRGB(31, 31, 32),
            BackgroundTransparency = 0.25,
            Size = UDim2.new(1, 0, 1, 0),
            Active = true,
            Text = "",
            ZIndex = 998,
            AutoButtonColor = false,
            Visible = self.props.OnScreen,

        }),

        PopUpFrame = Roact.createElement("Frame", {

            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundColor3 = self.props.Theme:GetColor(
                Enum.StudioStyleGuideColor.MainBackground,
                Enum.StudioStyleGuideModifier.Default
            ),
            ZIndex = 999,
            Visible = self.props.OnScreen

        }, {
            Corner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 5),
            }),

            Label = Roact.createElement("TextLabel", {

                Size = UDim2.new(0.8, 0, 0.7, 0),
                Position = UDim2.new(0.5, 0, 0.05, 0),
                AnchorPoint = Vector2.new(0.5, 0),
                Text = self.props.Text,
                BackgroundTransparency = 1,
                TextColor3 = self.props.Theme:GetColor(
                    Enum.StudioStyleGuideColor.MainText,
                    Enum.StudioStyleGuideModifier.Default
                ),
                TextScaled = true,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 999,

            }, {
                TSize = Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 12,
                }),
            }),
            Ok = Roact.createElement(Button, {
                Color = getColor(self.props.Theme, "Green"),
                ChangeMouse = true,

                Size = UDim2.new(0.4, 0, 0.2, 0),
                ZIndex = 999,
                Text = self.props.OkText or "Ok",
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0.05, 0, 1-0.05, 0),

                callback = function()
                    self.props.callback(true)
                end
            }),
            Cancel = Roact.createElement(Button, {
                Color = getColor(self.props.Theme, "Red"),
                ChangeMouse = true,

                Size = UDim2.new(0.4, 0, 0.2, 0),
                ZIndex = 999,
                Text = self.props.CancelText or "Cancel",
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1-0.05, 0, 1-0.05, 0),

                callback = function()
                    self.props.callback(false)
                end
            }),

        })
    })
end


return PopUp