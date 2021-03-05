local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local changeMouse = require(root.gui.changeMouse)


local ButtonInput = Roact.Component:extend("ButtonInput")

ButtonInput.defaultProps = {
    AnchorPoint = Vector2.new(0,0),
    CornerRadius = UDim.new(0, 3),
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 30, 0, 30),
    SizeConstraint = Enum.SizeConstraint.RelativeXY,
    Text = "",
    ZIndex = 1,

    Color = Color3.new(),
    ChangeMouse = true,

    callback = function() end,
}


function ButtonInput:render()
    return Roact.createFragment({
        Box = Roact.createElement("TextButton", {

            Size = self.props.Size,
            Position = self.props.Position,
            Text = self.props.Text,
            TextScaled = true,
            AnchorPoint = self.props.AnchorPoint,
            BackgroundColor3 = self.props.Color,
            SizeConstraint = self.props.SizeConstraint,
            ZIndex = self.props.ZIndex,

            AutoButtonColor = self.props.ChangeMouse,

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
                CornerRadius = self.props.CornerRadius,
            }),
            TSize = Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 12,
            }),
        })
    })

end


return ButtonInput