local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local ButtonInput = require(script.Parent.ButtonInput)
local getColor = require(root.gui.getColors)


local HorizontalChoiceList = Roact.Component:extend("HorizontalChoiceList")


HorizontalChoiceList.defaultProps = {
    options = 0, -- number of choices in the list
    Selected = 1,

    LayoutOrder = 0,
    Position = UDim2.new(0,0,0),
    Size = UDim2.new(0, 50, 0, 50),

    callback = function() end,
}

HorizontalChoiceList.defaultProps.MaxAllowed = HorizontalChoiceList.defaultProps.options


function HorizontalChoiceList:render()
    local choices = {}
    local options = self.props.options + 1 -- + 1 for the plus at the end

    for i = 1, options do

        local color = (i == self.props.Selected) and getColor(self.props.Theme, "Blue") or getColor(self.props.Theme, "Gray")
        local allowedToAdd = (self.props.options < self.props.MaxAllowed)

        if i ~= options then

            table.insert(choices,
                Roact.createElement(ButtonInput, {
                    Text = i,
                    Position = UDim2.new(1/options * (i-1), 5, 0, 0),
                    Size = UDim2.new(1/options, -10, 1, 0),
                    Color = color,

                    ChangeMouse = self.props.ChangeMouse,

                    callback = function()
                        self.props.callback(i)
                    end
                })
            )

        else -- add plus button at end

            table.insert(choices,
                Roact.createElement(ButtonInput, {
                    Text = "+",
                    Position = UDim2.new(1/options * (i-1), 5, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    SizeConstraint = Enum.SizeConstraint.RelativeYY,
                    Color = allowedToAdd and getColor(self.props.Theme, "Green") or getColor(self.props.Theme, "Gray"),
                    CornerRadius = UDim.new(1, 0),

                    ChangeMouse = self.props.ChangeMouse,

                    callback = function()
                        if not allowedToAdd then
                            return
                        end

                        self.props.callback("+")
                    end
                })
            )

        end
    end

    return Roact.createFragment({
        Frame = Roact.createElement("Frame", {

            LayoutOrder = self.props.LayoutOrder,
            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundTransparency = 1,

        }, choices)
    })

end


return HorizontalChoiceList