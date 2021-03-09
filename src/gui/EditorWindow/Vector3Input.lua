local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local NumberInput = require(script.Parent.NumberInput)


local Vector3Input = Roact.Component:extend("Vector3Input")

Vector3Input.defaultProps = {
    LabelText = "",
    ChangeMouse = true,

    LayoutOrder = 0,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0, 30, 0, 30),

    DefaultValue = Vector3.new(0, 0, 0),

    callback = function() end,
}


local function getVectorBaseFromDirection(dir)
    dir = dir:lower()
    return (dir == 'x') and Vector3.new(1, 0, 0) or
           (dir == 'y') and Vector3.new(0, 1, 0) or
           (dir == 'z') and Vector3.new(0, 0, 1)
end


function Vector3Input:updateValue()
    self.props.callback(self.props.DefaultValue)
end


-- dir must be X, Y, or Z
function Vector3Input:makeField(dir, pos)
    local vectorBase = getVectorBaseFromDirection(dir)

    return Roact.createElement(NumberInput, {
        Position = pos,
        Size = UDim2.new(0.2, 0, 1, 0),

        NumType = "all",
        Theme = self.props.Theme,
        DefaultValue = self.props.DefaultValue[dir],
        ChangeMouse = self.props.ChangeMouse,

        callback = function(num)
            self.props.DefaultValue = num * vectorBase + (self.props.DefaultValue * (Vector3.new(1, 1, 1) - vectorBase))
            self:updateValue()
        end,
    })
end


function Vector3Input:makeComma(pos)
    return Roact.createElement("TextLabel", {

        Position = pos,
        Size = UDim2.new(0.05, 0, 1, 0),
        Text = ",",
        BackgroundTransparency = 1,
        TextColor3 = self.props.Theme:GetColor(
            Enum.StudioStyleGuideColor.MainText,
            Enum.StudioStyleGuideModifier.Default
        ),
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Center,

    }, {
        TSize = Roact.createElement("UITextSizeConstraint", {
            MaxTextSize = 12,
        }),
    })
end


function Vector3Input:render()
    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

            LayoutOrder = self.props.LayoutOrder,
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

            X = self:makeField("X", UDim2.new(0.3, 0, 0, 0)),
            Comma1 = self:makeComma(UDim2.new(0.5, 0, 0, 0)),
            Y = self:makeField("Y", UDim2.new(0.55, 0, 0, 0)),
            Comma2 = self:makeComma(UDim2.new(0.75, 0, 0, 0)),
            Z = self:makeField("Z", UDim2.new(0.8, 0, 0, 0))

        })
    })
end


return Vector3Input