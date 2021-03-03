local root = script.Parent.Parent.Parent
local Roact = require(root.roact)

local ButtonInput = require(script.Parent.ButtonInput)
local getColor = require(root.gui.getColors)


local HorizontalChoiceList = Roact.Component:extend("HorizontalChoiceList")


function HorizontalChoiceList:init()
    self.props.options = self.props.options or 0 -- number of choices in the list
    self.props.Selected = self.props.Selected or 1
    self.props.MaxAllowed = self.props.MaxAllowed or self.props.options

    self.props.Position = self.props.Position or UDim2.new(0,0,0)
    self.props.Size = self.props.Size or UDim2.new(0, 50, 0, 50)
    assert(self.props.Theme ~= nil, "No theme found for choice list")

    self.props.callback = self.props.callback or function() end
end


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

            Position = self.props.Position,
            Size = self.props.Size,
            BackgroundTransparency = 1,

        }, choices)
    })

end


function HorizontalChoiceList:didMount()
    
end


return HorizontalChoiceList