local RunService = game:GetService("RunService")

local root = script.Parent.Parent
local Roact = require(root.roact)

local pluginMouse = script:FindFirstAncestorWhichIsA("Plugin"):GetMouse()

local HatController = require(root.world.hatController)
local CheckboxInput = require(root.gui.EditorWindow.CheckboxInput)

local maxCamPos = Vector3.new(3.5, 3.5, 20)
local movementCxn = nil
local zoomCxn = nil


local Previewer = Roact.Component:extend("Previewer")

local PreviewSettings = {
    CameraCFrame = CFrame.new(Vector3.new(0,0,-5), Vector3.new(0,0,0)) + Vector3.new(0,1,0),
    BallColor = Color3.new(0.627450, 0.321568, 0.721568),
    BallTransparency = 0.5,
    CurrentIndex = 0,
    DoHighlight = true,
}


function Previewer:init()
    self.cameraRef = Roact.createRef()

    self:setState({
        theme = settings().Studio.Theme,
        partCf = CFrame.new(0, 0, 0),
        hats = {},
    })
end


function Previewer:render()
    local hatComponents = {}

    for i, hat in pairs(HatController.List) do
        local handle = hat.model.Handle
        local mesh = handle:FindFirstChildOfClass("SpecialMesh")

        local camCf = workspace.CurrentCamera.CFrame
        local cf = (handle.CFrame - camCf.Position) + self.state.partCf.Position

        local shouldHighlight = ((PreviewSettings.CurrentIndex == i) and  PreviewSettings.DoHighlight)

        hatComponents[tostring(i)] = Roact.createElement("Part", {
            Size = handle.Size,
            CFrame = cf,
            Color = Color3.fromRGB(85, 255, 0)
        },
        {
            Mesh = Roact.createElement("SpecialMesh", {
                MeshId = mesh.MeshId,
                TextureId = (not shouldHighlight) and mesh.TextureId or nil,
                Scale = mesh.Scale,
            }),
        })
    end


    return Roact.createElement("Frame", {
        Size = UDim2.new(1,0,1,0),
        BackgroundColor3 = self.state.theme:GetColor(
            Enum.StudioStyleGuideColor.MainBackground,
            Enum.StudioStyleGuideModifier.Default
        ),
    },
    {
        DoHighlight = Roact.createElement(CheckboxInput, {
            Position = UDim2.new(0, -15, 0, 0),
            Size = UDim2.new(1, 0, 0, 30),
            Theme = self.state.theme,
            Checked = PreviewSettings.DoHighlight,
            LabelText = "Highlight Selection",
            ZIndex = 5,
            callback = function()
                PreviewSettings.DoHighlight = not PreviewSettings.DoHighlight
            end
        }),

        ActiveButton = Roact.createElement("TextButton", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            ZIndex = 5,
            Text = "",

            [Roact.Event.MouseButton1Down] = function(rbx)
                pluginMouse.Icon = "rbxasset://SystemCursors/ClosedHand"

                movementCxn = rbx.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        local delta = input.Delta/100
                        local safeInput = Vector3.new(0,0,0)

                        if math.abs(PreviewSettings.CameraCFrame.X + delta.X) < maxCamPos.X then
                            safeInput += Vector3.new(delta.X, 0, 0)
                        end
                        if math.abs(PreviewSettings.CameraCFrame.Y + delta.Y) < maxCamPos.Y then
                            safeInput += Vector3.new(0, delta.Y, 0)
                        end

                        PreviewSettings.CameraCFrame += safeInput
                    end
                end)
            end,
            [Roact.Event.MouseButton1Up] = function()
                pluginMouse.Icon = "rbxasset://SystemCursors/OpenHand"

                if movementCxn then
                    movementCxn:Disconnect()
                    movementCxn = nil
                end
            end,
            [Roact.Event.MouseEnter] = function(rbx)
                pluginMouse.Icon = "rbxasset://SystemCursors/OpenHand"

                zoomCxn = rbx.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseWheel then
                        local delta = input.Position.Z
                        local safeInput = 0

                        if math.abs(PreviewSettings.CameraCFrame.Z + delta) < maxCamPos.Z then
                            safeInput = delta
                        end

                        PreviewSettings.CameraCFrame += Vector3.new(0, 0, safeInput)
                    end
                end)
            end,
            [Roact.Event.MouseLeave] = function()
                pluginMouse.Icon = "rbxasset://SystemCursors/Arrow"

                if movementCxn then
                    movementCxn:Disconnect()
                    movementCxn = nil
                end

                if zoomCxn then
                    zoomCxn:Disconnect()
                    zoomCxn = nil
                end
            end,
        }),

        Viewport = Roact.createElement("ViewportFrame", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            CurrentCamera = self.cameraRef,
            BackgroundColor3 =self.state.theme:GetColor(
                Enum.StudioStyleGuideColor.MainBackground,
                Enum.StudioStyleGuideModifier.Default
            ),
        },
        {
            Camera = Roact.createElement("Camera", {
                [Roact.Ref] = self.cameraRef,
                CFrame = PreviewSettings.CameraCFrame,
            }),
            Ball = Roact.createElement("Part", {
                CFrame = self.state.partCf,
                Shape = Enum.PartType.Ball,
                Size = Vector3.new(1.5, 1.5, 1.5),

                Color = PreviewSettings.BallColor,
                Transparency = PreviewSettings.BallTransparency,

                TopSurface = Enum.SurfaceType.SmoothNoOutlines,
                BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
            }),
            Cone = Roact.createElement("Part", {
                CFrame = self.state.partCf * CFrame.new(0, 0, -1.4) * CFrame.Angles(-math.pi/2, 0, 0),
                Size = Vector3.new(0.25, 0.5, 0.25),

                Color = PreviewSettings.BallColor,
                Transparency = PreviewSettings.BallTransparency,
            },
            {
                Mesh = Roact.createElement("SpecialMesh", {
                    MeshId = "rbxassetid://5608714345",
                    Scale = Vector3.new(0.75,0.75,0.75)
                }),
            }),
            Cylinder = Roact.createElement("Part", {
                CFrame = self.state.partCf * CFrame.Angles(0, math.pi/2, 0),
                Shape = Enum.PartType.Cylinder,
                Size = Vector3.new(2.3, 0.1, 0.1),

                Color = PreviewSettings.BallColor,
                Transparency = PreviewSettings.BallTransparency,
            }),
            Hats = Roact.createElement("Folder", {}, hatComponents),
        })
    })
end


function Previewer:didMount()
    Previewer._themeCxn = settings().Studio.ThemeChanged:Connect(function()
        self:setState(function(state)
            state.theme = settings().Studio.Theme
            return state
        end)
    end)

    Previewer._runCxn = RunService.Heartbeat:Connect(function()
        self:setState(function(state)
            local camCf = workspace.CurrentCamera.CFrame
            state.partCf = (camCf - camCf.Position)
            return state
        end)
    end)
end


function Previewer:willUnmount()
    Previewer._themeCxn:Disconnect()
    Previewer._runCxn:Disconnect()
end


return setmetatable({
    Settings = PreviewSettings,

    mount = function(previewDocket)
        local handle = Roact.mount(Roact.createElement(Previewer), previewDocket, "Preview UI")

        script:FindFirstAncestorWhichIsA("Plugin").Unloading:Connect(function()
            Roact.unmount(handle)
        end)
    end,

}, {__index = Previewer})