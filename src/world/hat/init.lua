local RunService = game:GetService("RunService")


local Hat = {}
Hat.__index = Hat


--[[

    constructor
    @param: model
        - an accessory that is ready to be used as a hat
        - should have a Handle part as a child and a SpecialMesh
          as a child of that Handle
    @param: property table
        - a dictionary with the following properties:

        offset -            a Vector3, the offset the accessory from the player's camera
        scale -             a Vector3, the scale of the accessory's mesh
        transformPriority - a number,  signifying "rotate" or "translate" that describes in what
                                       order orientations should be applied to the accessory
        visibleLocally -    a boolean, whether the local transparency modifier should be toggled

--]]

function Hat.new(id, model, propTable)
    local self = setmetatable({}, Hat)

    propTable = propTable or {}

    self.model = model
    self._implicitScale = model.Handle:FindFirstChildOfClass("SpecialMesh").Scale

    self.id = id -- just to store, cannot change

    self:SetOffset(propTable.offset or Vector3.new(0, 0, 0))
    self:SetScale(propTable.scale or Vector3.new(1, 1, 1))
    self:SetRotation(propTable.rotation or Vector3.new(0, 0, 0))
    self:SetTransformPriority(propTable.transformPriority or 1)
    self:SetVisibleLocally(propTable.visibleLocally or false)

    self._floatConnection = self:_bindFloating()

    return self
end


function Hat:GetPropertyTable()
    return {
        offset = self.offset,
        scale = self.scale,
        rotation = self.rotation,
        transformPriority = self.transformPriority,
        visibleLocally = self.visibleLocally,
    }
end


--------- setters ----------


function Hat:SetOffset(offset)
    self.offset = offset
end


function Hat:SetScale(scale)
    self.scale = scale
    self.model.Handle:FindFirstChildOfClass("SpecialMesh").Scale = self._implicitScale * scale
end


function Hat:SetRotation(rotation)
    self.rotation = rotation
end


function Hat:SetTransformPriority(state)
    assert(state == 1 or state == 2 or state == 3, "transform priority set incorrectly")
    self.transformPriority = state
end


function Hat:SetVisibleLocally(state)
    self.visibleLocally = state
    self.model.Handle.LocalTransparencyModifier = state and 0 or 1
end


---------- other functions ----------


function Hat:_bindFloating()
    return RunService.RenderStepped:Connect(function()
        self:SetCFrame(workspace.CurrentCamera.CFrame)
    end)
end


-- takes all the properties the hat currently has and positions it correctly
function Hat:SetCFrame(aroundCf)
    if not self.model._instance:FindFirstChild("Handle") then
        return
    end

    local hatRot = CFrame.Angles(math.rad(self.rotation.X), math.rad(self.rotation.Y), math.rad(self.rotation.Z))
    local headRot = (aroundCf - aroundCf.p)

    if self.transformPriority == 1 then
        self.model.Handle.CFrame = aroundCf * CFrame.new(self.offset)
    elseif self.transformPriority == 2 then
        self.model.Handle.CFrame = (CFrame.new(aroundCf.p) + self.offset) * headRot
    else -- transformPriority = "none"
        self.model.Handle.CFrame = CFrame.new(aroundCf.p) + self.offset
    end

    self.model.Handle.CFrame *= hatRot
end


function Hat:Destroy()
    local model = self.model
    local floatConnection = self._floatConnection
    self = nil
    model:Destroy()
    floatConnection:Disconnect()
end


return Hat