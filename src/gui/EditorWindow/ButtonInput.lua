local root = script.Parent.Parent.Parent
local Roact = require(root.roact)


local ButtonInput = Roact.Component:extend("ButtonInput")


function ButtonInput:init()
    self.props.Position = self.props.Position or UDim.new(0, 0)
    self.props.Size = self.props.Size or UDim.new(0, 30)
    self.props.Text = self.props.Text or ""
    self.props.Color = self.props.Color or Color3.new()
    self.props.CornerRadius = self.props.CornerRadius or UDim.new(0, 3)
    self.props.SizeConstraint = self.props.SizeConstraint or Enum.SizeConstraint.RelativeXY

    self.props.callback = self.props.callback or function() end
end


function ButtonInput:render()
    return Roact.createFragment({
        Box = Roact.createElement("TextButton", {

            Size = self.props.Size,
            Position = self.props.Position,
            Text = self.props.Text,
            TextScaled = true,
            BackgroundColor3 = self.props.Color,
            SizeConstraint = self.props.SizeConstraint,

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
                CornerRadius = self.props.CornerRadius,
            }),
            TSize = Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 12,
            }),
        })
    })

end


return ButtonInput