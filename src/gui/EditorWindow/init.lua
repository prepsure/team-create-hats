local root = script.Parent.Parent
local Roact = require(root.roact)

local HatController = require(root.world.hatController)
local PersistentFolder = require(root.world.persistentFolder)


local CheckboxInput = require(script.CheckboxInput)
local ButtonInput = require(script.ButtonInput)
local LabeledNumberInput = require(script.LabeledNumberInput)
local Vector3Input = require(script.Vector3Input)
local HorizontalChoiceList = require(script.HorizontalChoiceList)


local Editor = Roact.Component:extend("Editor")


function Editor:init()
    self:setState({
        theme = settings().Studio.Theme,
        currentIndex = 1,
        enabled = true,
        visibleLocally = false,
    })
end


function Editor:render()

    local enableProps = not not HatController.List[self.state.currentIndex]

    return Roact.createElement("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = self.state.theme:GetColor(
            Enum.StudioStyleGuideColor.MainBackground,
            Enum.StudioStyleGuideModifier.Default
        ),
    },
    {
        Enabled = Roact.createElement(CheckboxInput, { -- TODO: updates reset these checkboxes?
            Position = UDim2.new(0, 0, 0, 10),
            Size = UDim2.new(1, 0, 0, 30),
            LabelText = "Enabled",
            Theme = self.state.theme,

            Checked = self.state.enabled,
            callback = function()
                self:setState(function(state)
                    state.enabled = not state.enabled
                    return state
                end)

                PersistentFolder:Reparent(self.state.enabled and workspace or false)
            end
        }),

        VisibleLocally = Roact.createElement(CheckboxInput, {
            Position = UDim2.new(0, 0, 0, 50),
            Size = UDim2.new(1, 0, 0, 30),
            LabelText = "Visible to Self",
            Theme = self.state.theme,

            Checked = self.state.visibleLocally,
            callback = function()
                self:setState(function(state)
                    state.visibleLocally = not state.visibleLocally
                    return state
                end)

                HatController:ChangePropertyOnAll("VisibleLocally", self.state.visibleLocally)
            end
        }),

        ImportHats = Roact.createElement(ButtonInput, {
            Text = "Import Hats from Character",
            Color = Color3.fromRGB(74, 157, 253),
            Position = UDim2.new(0, 20, 0, 90),
            Size = UDim2.new(1, -40, 0, 30),

            callback = function()
                HatController:ImportFromCharacter() --TODO add a confirmation popup window
            end
        }),

        Choices = Roact.createElement(HorizontalChoiceList, {
            Position = UDim2.new(0, 0, 0, 130),
            Size = UDim2.new(1, 0, 0, 30),
            options = #HatController.List,
            MaxAllowed = HatController.MaxHats,
            Selected = self.state.currentIndex,
            callback = function(numOrPlus)
                local index = 1

                if numOrPlus == "+" then
                    HatController:Add(1028826)
                    index = #HatController.List
                else
                    index = tonumber(numOrPlus)
                end

                self:setState(function(state)
                    state.currentIndex = index
                    return state
                end)
            end,
        }),

        AccessoryId = Roact.createElement(LabeledNumberInput, {
            Position = UDim2.new(0, 20, 0, 170),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and HatController.List[self.state.currentIndex].id or 0,

            LabelText = "Accessory Id",
            Theme = self.state.theme,
            NumType = "whole",

            callback = function(id)
                HatController:ChangeProperty(self.state.currentIndex, "id", id)
            end
        }),

        Offset = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 210),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and HatController.List[self.state.currentIndex].offset or Vector3.new(0,0,0),

            LabelText = "Offset",
            Theme = self.state.theme,

            callback = function(offset)
                HatController:ChangeProperty(self.state.currentIndex, "Offset", offset)
            end
        }),

        Scale = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 250),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and HatController.List[self.state.currentIndex].scale or Vector3.new(1,1,1),

            LabelText = "Scale",
            Theme = self.state.theme,

            callback = function(scale)
                HatController:ChangeProperty(self.state.currentIndex, "Scale", scale)
            end
        }),

        RemoveHat = Roact.createElement(ButtonInput, {
            Text = "Remove Hat",
            Color = Color3.fromRGB(245, 106, 106),
            Position = UDim2.new(0, 20, 0, 330),
            Size = UDim2.new(1, -40, 0, 30),

            callback = function()
                HatController:Remove(self.state.currentIndex)
                self:setState(function(state)
                    state.currentIndex = 1
                    return state
                end)
            end
        }),

    })
end


function Editor:didMount()
    Editor._themeCxn = settings().Studio.ThemeChanged:Connect(function()
        self:setState(function(state)
            state.theme = settings().Studio.Theme
            return state
        end)
    end)

    Editor._listCxn = HatController:BindToUpdate(function()
        self:setState(self.state)
    end)
end


function Editor:willUnmount()
    Editor._themeCxn:Disconnect()
    Editor._listCxn:Disconnect()
end


return setmetatable({

    mount = function(docket)
        local handle = Roact.mount(Roact.createElement(Editor), docket, "Editor UI")

        script:FindFirstAncestorWhichIsA("Plugin").Unloading:Connect(function()
            Roact.unmount(handle)
        end)
    end,

}, {__index = Editor})