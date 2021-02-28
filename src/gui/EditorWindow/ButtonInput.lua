local root = script.Parent.Parent.Parent
local Roact = require(root.roact)


local ButtonInput = Roact.Component:extend("ButtonInput")

local implicitProps = {
    cornerRadius = 3,
    leftPadding = 20,
    topPadding = 10,

    clickedColor = Color3.fromRGB(74, 157, 253),
    unclickedColor = Color3.fromRGB(137, 137, 137),
}


function ButtonInput:init()
    self.props.YPosition = self.props.YPosition or UDim.new(0, 0)
    self.props.YSize = self.props.YSize or UDim.new(0, 30)
    self.props.Text = self.props.Text or ""

    self.props.callback = self.props.callback or function() end
end


function ButtonInput:render()
    return Roact.createFragment({
        Box = Roact.createElement("TextButton", {

            AnchorPoint = Vector2.new(0.5, 0),
            Size = UDim2.new(1, 0, self.props.YSize.Scale, self.props.YSize.Offset) - UDim2.new(0, implicitProps.leftPadding*2, 0, 0),
            Position = UDim2.new(0.5, 0, self.props.YPosition.Scale, self.props.YPosition.Offset),
            Text = self.props.Text,
            TextScaled = true,
            BackgroundColor3 = implicitProps.clickedColor,

            [Roact.Event.Activated] = function()
                self.props.callback()
            end

        }, {
            Corner = Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, implicitProps.cornerRadius),
            }),
            TSize = Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 12,
            }),
        })
    })

end


return ButtonInput