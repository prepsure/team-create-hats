local root = script.Parent.Parent.Parent
local Roact = require(root.roact)


local NumberInput = Roact.Component:extend("NumberInput")


-- removes everything that isn't a number from a string
local function filterToWholeNumber(str)
	return str:gsub('%D','')
end


-- removes everything that isn't a number, -, or . from the string (- is removed if it occurs anywhere other than the beginning)
local function filterToNumber(str)
	local numericString = str:match("%d[%d.]*") or ""
	if str:sub(1,1) == "-" then
		numericString = "-" .. numericString
	end
	return numericString
end


-- much like filterToNumber except that it removes - if its the only character, this should be used when the user is done typing
local function filterForFinalNumber(str)
    local numericString = str:match("%d[%d.]*") or ""

    if str:sub(1,1) == "-" then
        if #str == 1 then
            return ""
        end
		numericString = "-" .. numericString
	end

    -- check if a string has more than 1 .
    if #str - #str:gsub("%.", "") > 1 then
        return ""
    end

    -- add a 0 at the end if the last char is a .
    if str:sub(#str, #str) == "." then
        numericString ..= "0"
    end

	return numericString
end



function NumberInput:init()
    self.props.Position = self.props.Position or UDim.new(0, 0)
    self.props.Size = self.props.Size or UDim.new(0, 30)
    self.props.NumType = self.props.NumType or "all"
    self.props.TextColor = self.props.TextColor or Color3.new()
    self.props.DefaultValue = self.props.DefaultValue or "0"

    self.props.callback = self.props.callback or function() end
    self.input, self.updateInput = Roact.createBinding("")
end


function NumberInput:render()

    return Roact.createFragment({
        Input = Roact.createElement("TextBox", {

            AnchorPoint = Vector2.new(0, 0),
            Size = self.props.Size,
            Position = self.props.Position,
            Text = self.input,
            TextScaled = true,
            TextColor3 = self.props.TextColor,
            BackgroundTransparency = 1,

            [Roact.Change.Text] = function(rbx)
                if self.props.NumType == 'whole' then
                    self.updateInput(filterToWholeNumber(rbx.Text))
                else
                    self.updateInput(filterToNumber(rbx.Text))
                end
            end,

            [Roact.Event.FocusLost] = function(rbx)
                local newVal = filterForFinalNumber(rbx.Text)

                if newVal ~= "" then
                    self.props.DefaultValue = newVal
                end

                self.updateInput(self.props.DefaultValue)
                self.props.callback(self.props.DefaultValue)
            end,

        },
        {
            TSize = Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 12,
            }),
            Underline = Roact.createElement("Frame", {
                AnchorPoint = Vector2.new(0.5, 0),
                BorderSizePixel = 0,
                Size = UDim2.new(0.9, 0, 0, 1),
                BackgroundColor3 = self.props.TextColor,
                Position = UDim2.new(0.5, 0, 1, 0),
            })
        })
    })

end


return NumberInput