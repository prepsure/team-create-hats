local RunService = game:GetService("RunService")

local root = script.Parent.Parent
local Roact = require(root.roact)

local Previewer = Roact.Component:extend("Previewer")

local Settings = {
    CameraCFrame = CFrame.new(Vector3.new(0,0,10), Vector3.new(0,0,0)) + Vector3.new(0,3,0),
    BallColor = Color3.new(0.627450, 0.321568, 0.721568),
    BallTransparency = 0.5,
    Hats = {},
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

    for _, hat in pairs(Settings.Hats) do
        local handle = hat.model.Handle
        local mesh = handle.Mesh

        local camCf = workspace.CurrentCamera.CFrame
        local cf = (handle.CFrame - camCf.Position) + self.state.partCf.Position

        hatComponents[tostring(_)] = Roact.createElement("Part", {
            Size = handle.Size,
            CFrame = cf
        },
        {
            Mesh = Roact.createElement("SpecialMesh", {
                MeshId = mesh.MeshId,
                TextureId = mesh.TextureId,
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
        Viewport = Roact.createElement("ViewportFrame", {
            Size = UDim2.new(1,0,1,0),
            BackgroundTransparency = 1,
            CurrentCamera = self.cameraRef
        },
        {
            Camera = Roact.createElement("Camera", {
                [Roact.Ref] = self.cameraRef,
                CFrame = Settings.CameraCFrame,
            }),
            Ball = Roact.createElement("Part", {
                CFrame = self.state.partCf,
                Shape = Enum.PartType.Ball,
                Size = Vector3.new(1.5, 1.5, 1.5),
                
                Color = Settings.BallColor,
                Transparency = Settings.BallTransparency,

                TopSurface = Enum.SurfaceType.SmoothNoOutlines,
                BottomSurface = Enum.SurfaceType.SmoothNoOutlines,
            }),
            Cone = Roact.createElement("Part", {
                CFrame = self.state.partCf * CFrame.new(0, 0, -1.4) * CFrame.Angles(-math.pi/2, 0, 0),
                Size = Vector3.new(0.25, 0.5, 0.25),
                
                Color = Settings.BallColor,
                Transparency = Settings.BallTransparency,
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
                
                Color = Settings.BallColor,
                Transparency = Settings.BallTransparency,
            }),
            Hats = Roact.createElement("Folder", {}, hatComponents),
        })
    })
end


function Previewer:didMount()
    settings().Studio.ThemeChanged:Connect(function()
        self:setState(function(state)
            state.theme = settings().Studio.Theme
            return state
        end)
    end)

    RunService.Heartbeat:Connect(function()
        self:setState(function(state)
            local camCf = workspace.CurrentCamera.CFrame
            state.partCf = (camCf - camCf.Position)
            return state
        end)
    end)
end


return function(previewDocket, hats)
    Settings.Hats = hats
    local handle = Roact.mount(Roact.createElement(Previewer), previewDocket, "Preview UI")

    -- unmount?
    return Previewer
end