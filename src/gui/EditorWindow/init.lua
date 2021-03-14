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

    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 1, 0),
    }, {
        Config = Roact.createElement("ScrollingFrame", {
            Size = UDim2.new(1,0,1,0),
            BorderSizePixel = 0,
            BackgroundColor3 = self.state.theme:GetColor(
                Enum.StudioStyleGuideColor.MainBackground,
                Enum.StudioStyleGuideModifier.Default
            ),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0,0,1,10),
            ScrollBarImageColor3 = self.state.theme:GetColor(
                Enum.StudioStyleGuideColor.Dark,
                Enum.StudioStyleGuideModifier.Default
            ),
        },
        {
            UIListLayout = Roact.createElement("UIListLayout", {
                Padding = UDim.new(0, 10),
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),

            TopPadding = Roact.createElement("Frame", {
                LayoutOrder = 0,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
            }),

            Enabled = Roact.createElement(CheckboxInput, {
                LayoutOrder = 1,

                Size = UDim2.new(1, -40, 0, 30),
                LabelText = "Enabled",
                Theme = self.state.theme,
                ChangeMouse = not self.state.importPopUpShown,

                Checked = self.state.enabled,
                callback = function()
                    self:setState(function(state)
                        state.enabled = not state.enabled
                        return state
                    end)

                    PersistentFolder:Reparent(self.state.enabled and workspace:FindFirstChildOfClass("Terrain") or false)
                end
            }),

            VisibleLocally = Roact.createElement(CheckboxInput, {
                LayoutOrder = 2,

                Size = UDim2.new(1, -40, 0, 30),
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
                LayoutOrder = 3,
                Size = UDim2.new(1, -40, 0, 30),

                Text = "Import Hats from Character",
                Color = getColors(self.state.theme, "Blue"),
                ChangeMouse = not self.state.importPopUpShown,

                callback = function()
                    self:setState(function(state)
                        state.importPopUpShown = true
                        return state
                    end)

                    changeMouse("Arrow", true)
                end
            }),

            Divider = Roact.createElement("Frame", {

                LayoutOrder = 4,
                Size = UDim2.new(1, 0, 0, 15),
                BackgroundTransparency = 1,

            }, {
                Line = Roact.createElement("Frame", {
                    Size = UDim2.new(1, -10, 0, 3),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BorderSizePixel = 0,
                    BackgroundColor3 = self.state.theme:GetColor(
                        Enum.StudioStyleGuideColor.Light,
                        Enum.StudioStyleGuideModifier.Default
                    ),
                }),
            }),

            Choices = Roact.createElement(HorizontalChoiceList, {
                LayoutOrder = 5,
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
                LayoutOrder = 6,
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
                LayoutOrder = 7,
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
                LayoutOrder = 8,
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
                LayoutOrder = 9,
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

            ParticleToggle = Roact.createElement(CheckboxInput, {
                LayoutOrder = 9.5,
                Size = UDim2.new(1, -40, 0, 30),
                Visible = enableProps and currentHat:HasParticles() or false,

                LabelText = "Particles",
                TextWidthScale = 0.3,
                TextWidth = 0,
                Checked = enableProps and currentHat.particlesEnabled or false,
                Theme = self.state.theme,

                callback = function(b)
                    HatController:ChangeProperty(self.state.currentIndex, "ParticlesEnabled", b)
                    self:setState(self.state)
                end,
            }),

            TransformPriority = Roact.createElement(RadioButtonInput, {
                LayoutOrder = 10,
                Size = UDim2.new(1, -40, 0, 60),

                LabelText = "Offset\nMethod",
                Theme = self.state.theme,
                ChangeMouse = not self.state.importPopUpShown,

                options = {"relative to camera", "relative to world"},
                selected = enableProps and currentHat.transformPriority,

                callback = function(pos)
                    HatController:ChangeProperty(self.state.currentIndex, "TransformPriority", pos)
                    self:setState(self.state)
                end,

            }),

            RotTransformPriority = Roact.createElement(RadioButtonInput, {
                LayoutOrder = 11,
                Size = UDim2.new(1, -40, 0, 60),

                LabelText = "Rotation\nMethod",
                Theme = self.state.theme,
                ChangeMouse = not self.state.importPopUpShown,

                options = {"relative to camera", "relative to world"},
                selected = enableProps and currentHat.rotTransformPriority,

                callback = function(pos)
                    HatController:ChangeProperty(self.state.currentIndex, "RotTransformPriority", pos)
                    self:setState(self.state)
                end,

            }),

            RemoveHat = Roact.createElement(ButtonInput, {
                LayoutOrder = 12,
                Size = UDim2.new(1, -40, 0, 30),

                Text = "Remove Hat",
                Color = getColors(self.state.theme, "Red"),
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

            BottomPadding = Roact.createElement("Frame", {
                LayoutOrder = 13,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
            }),

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