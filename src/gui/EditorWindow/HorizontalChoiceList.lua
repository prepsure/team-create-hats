local root = script.Parent.Parent.Parent
local Roact = require(root.roact)


local ButtonInput = require(script.Parent.ButtonInput)


local HorizontalChoiceList = Roact.Component:extend("HorizontalChoiceList")


function HorizontalChoiceList:init()
    self.props.options = self.props.options or 0 -- number of choices in the list
    self.props.Position = self.props.Position or UDim2.new(0,0,0)
    self.props.Size = self.props.Size or UDim2.new(0, 50, 0, 50)

    self.props.callback = self.props.callback or function() end
end


function HorizontalChoiceList:render()
    local choices = {}
    local options = self.props.options + 1 -- + 1 for the plus at the end

    for i = 1, options do

        if i ~= options then

            table.insert(choices,
                Roact.createElement(ButtonInput, {
                    Text = i,
                    Position = UDim2.new(1/options * (i-1), 5, 0, 0),
                    Size = UDim2.new(1/options, -10, 1, 0),
                    Color = Color3.fromRGB(74, 157, 253),
                })
            )

        else -- add plus button at end

            table.insert(choices,
                Roact.createElement(ButtonInput, {
                    Text = "+",
                    Position = UDim2.new(1/options * (i-1), 5, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Color = Color3.fromRGB(74, 157, 253),
                    CornerRadius = UDim.new(1, 0),
                })
            )

        end
    end

    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundTransparency = 1,

        }, choices)
    })

end


function HorizontalChoiceList:didMount()
    
end


return HorizontalChoiceList