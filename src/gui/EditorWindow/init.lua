local root = script.Parent.Parent
local Roact = require(root.roact)

local HatController = require(root.world.hatController)
local PersistentFolder = require(root.world.persistentFolder)


local CheckboxInput = require(script.CheckboxInput)
local ButtonInput = require(script.ButtonInput)
local LabeledNumberInput = require(script.LabeledNumberInput)
local Vector3Input = require(script.Vector3Input)
local HorizontalChoiceList = require(script.HorizontalChoiceList)
local RadioButtonInput = require(script.RadioButtonInput)
local PopUp = require(script.PopUp)

local getColors = require(root.gui.getColors)
local changeMouse = require(root.gui.changeMouse)

--[[
Roact.setGlobalConfig({
    elementTracing = true,
})
]]


local Editor = Roact.Component:extend("Editor")
local PreviewWindow = require(script.Parent.PreviewWindow)

local Loading = Instance.new("BindableEvent")


function Editor:Load(enabled, visibleLocally)
    Loading:Fire(enabled, visibleLocally)
end


function Editor:init()
    self:setState({
        theme = settings().Studio.Theme,
        currentIndex = 1,
        enabled = true,
        visibleLocally = false,
        importPopUpShown = false,
    })
end


function Editor:render()

    local currentHat = HatController.List[self.state.currentIndex]
    local enableProps = not not currentHat
    PreviewWindow.Settings.CurrentIndex = self.state.currentIndex

    return Roact.createElement("ScrollingFrame", {
        Size = UDim2.new(1,0,1,0),
        BorderSizePixel = 0,
        BackgroundColor3 = self.state.theme:GetColor(
            Enum.StudioStyleGuideColor.MainBackground,
            Enum.StudioStyleGuideModifier.Default
        ),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0,0,1,0),
        ScrollBarImageColor3 = self.state.theme:GetColor(
            Enum.StudioStyleGuideColor.Dark,
            Enum.StudioStyleGuideModifier.Default
        ),
    },
    {
        Enabled = Roact.createElement(CheckboxInput, { -- TODO: updates reset these checkboxes?
            Position = UDim2.new(0, 0, 0, 10),
            Size = UDim2.new(1, 0, 0, 30),
            LabelText = "Enabled",
            Theme = self.state.theme,
            ChangeMouse = not self.state.importPopUpShown,

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
            ChangeMouse = not self.state.importPopUpShown,

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
            Color = getColors(self.state.theme, "Blue"),
            Position = UDim2.new(0, 20, 0, 90),
            Size = UDim2.new(1, -40, 0, 30),
            ChangeMouse = not self.state.importPopUpShown,

            callback = function()
                self:setState(function(state)
                    state.importPopUpShown = true
                    return state
                end)

                changeMouse("Arrow", true)
            end
        }),

        ImportPopUp = Roact.createElement(PopUp, {
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.75, 0, 0.4, 0),
            Theme = self.state.theme,
            Text = "Importing from your character will erase all of your current hats.\n\n Continue importing?",
            OkText = "Yes",
            OnScreen = self.state.importPopUpShown,

            callback = function(oked)
                self:setState(function(state)
                    state.importPopUpShown = false
                    return state
                end)

                if oked then
                    HatController:ImportFromCharacter() --TODO add a confirmation popup window
                    HatController:ChangePropertyOnAll("VisibleLocally", self.state.visibleLocally)
                end

                self:setState(self.state)
            end,
        }),

        Divider = Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            BorderSizePixel = 0,
            BackgroundColor3 = self.state.theme:GetColor(
                Enum.StudioStyleGuideColor.Light,
                Enum.StudioStyleGuideModifier.Default
            ),
            Size = UDim2.new(1, -10, 0, 3),
            Position = UDim2.new(0, 5, 0, 135),
        }),

        Choices = Roact.createElement(HorizontalChoiceList, {
            Position = UDim2.new(0, 20, 0, 150),
            Size = UDim2.new(1, -40, 0, 30),

            ChangeMouse = not self.state.importPopUpShown,
            options = #HatController.List,
            MaxAllowed = HatController.MaxHats,
            Selected = self.state.currentIndex,
            Theme = self.state.theme,

            callback = function(numOrPlus)
                local index = 1

                if numOrPlus == "+" then
                    HatController:Add(nil, nil, {visibleLocally = self.state.visibleLocally})
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
            Position = UDim2.new(0, 20, 0, 190),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and currentHat.id or 0,

            LabelText = "Accessory Id",
            Theme = self.state.theme,
            NumType = "whole",
            ChangeMouse = not self.state.importPopUpShown,

            callback = function(id)
                HatController:ChangeProperty(self.state.currentIndex, "id", id)
                self:setState(self.state)
            end
        }),

        Offset = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 230),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and currentHat.offset or Vector3.new(0,0,0),

            LabelText = "Offset",
            Theme = self.state.theme,
            ChangeMouse = not self.state.importPopUpShown,

            callback = function(offset)
                HatController:ChangeProperty(self.state.currentIndex, "Offset", offset)
                self:setState(self.state)
            end
        }),

        Rotation = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 270),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and currentHat.rotation or Vector3.new(0,0,0),

            LabelText = "Rotation",
            Theme = self.state.theme,
            ChangeMouse = not self.state.importPopUpShown,

            callback = function(rotation)
                HatController:ChangeProperty(self.state.currentIndex, "Rotation", rotation)
                self:setState(self.state)
            end
        }),

        Scale = Roact.createElement(Vector3Input, {
            Position = UDim2.new(0, 20, 0, 310),
            Size = UDim2.new(1, -40, 0, 30),

            DefaultValue = enableProps and currentHat.scale or Vector3.new(1,1,1),

            LabelText = "Scale",
            Theme = self.state.theme,
            ChangeMouse = not self.state.importPopUpShown,

            callback = function(scale)
                HatController:ChangeProperty(self.state.currentIndex, "Scale", scale)
                self:setState(self.state)
            end
        }),

        TransformPriority = Roact.createElement(RadioButtonInput, {
            LabelText = "Rotation Method",
            Theme = self.state.theme,

            ChangeMouse = not self.state.importPopUpShown,
            Position = UDim2.new(0, 20, 0, 350),
            Size = UDim2.new(1, -40, 0, 60),

            options = {"relative to camera", "copy camera"},
            selected = enableProps and currentHat.transformPriority,

            callback = function(pos)
                HatController:ChangeProperty(self.state.currentIndex, "TransformPriority", pos)
                self:setState(self.state)
            end,

        }),

        RemoveHat = Roact.createElement(ButtonInput, {
            Text = "Remove Hat",
            Color = getColors(self.state.theme, "Red"),
            Position = UDim2.new(0, 20, 0, 420),
            Size = UDim2.new(1, -40, 0, 30),

            ChangeMouse = not self.state.importPopUpShown,

            callback = function()
                if #HatController.List == 0 then
                    return
                end

            HatController:Remove(self.state.currentIndex)
                self:setState(function(state)
                    if not HatController.List[self.state.currentIndex] then
                        state.currentIndex -= 1
                    end
                    return state
                end)
            end
        }),

    })
end


function Editor:didUpdate()
    require(root.settings):Save(self.state.enabled, self.state.visibleLocally)
end


function Editor:didMount()
    Editor._themeCxn = settings().Studio.ThemeChanged:Connect(function()
        self:setState(function(state)
            state.theme = settings().Studio.Theme
            return state
        end)
    end)

    Editor._loadCxn = Loading.Event:Connect(function(enabled, visibleLocally)
        self:setState(function(state)
            state.enabled = enabled
            state.visibleLocally = visibleLocally
            return state
        end)
    end)
end


function Editor:willUnmount()
    Editor._themeCxn:Disconnect()
    Editor._loadCxn:Disconnect()
end


return setmetatable({

    mount = function(docket)
        local handle = Roact.mount(Roact.createElement(Editor), docket, "Editor UI")

        script:FindFirstAncestorWhichIsA("Plugin").Unloading:Connect(function()
            Roact.unmount(handle)
        end)
    end,

}, {__index = Editor})