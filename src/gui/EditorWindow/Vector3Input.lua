local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local NumberInput = require(script.Parent.NumberInput)


local Vector3Input = Roact.Component:extend("Vector3Input")


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
function Vector3Input:makeField(dir)
    local vectorBase = getVectorBaseFromDirection(dir)

    return Roact.createElement(NumberInput, {
        Position = UDim2.new(0.3, 0, 0, 0),
        Size = UDim2.new(0.2, 0, 1, 0),

        NumType = "all",
        Theme = self.props.Theme,
        DefaultValue = self.props.DefaultValue[dir],

        callback = function(num)
            self.props.DefaultValue = num * vectorBase + (self.props.DefaultValue * (Vector3.new(1, 1, 1) - vectorBase))
            self:updateValue()
        end,
    })
end


function Vector3Input:makeComma()
    return Roact.createElement("TextLabel", {

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
    })
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

            X = Vector3Input:makeField("X"),
            Comma1 = Vector3Input:makeComma(),
            Y = Vector3Input:makeField("Y"),
            Comma2 = Vector3Input:makeComma(),
            Z = Vector3Input:makeField("Z")

        })
    })
end


return Vector3Input