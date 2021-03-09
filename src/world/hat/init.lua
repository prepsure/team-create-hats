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
    self:SetRotTransformPriority(propTable.rotTransformPriority or 1)
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
        rotTransformPriority = self.rotTransformPriority,
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
    assert(1 <= state and state <= 2, "transform priority set incorrectly")
    self.transformPriority = state
end


function Hat:SetRotTransformPriority(state)
    assert(1 <= state and state <= 2, "rot transform priority set incorrectly")
    self.rotTransformPriority = state
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
function Hat:SetCFrame(headCf)
    if not self.model._instance:FindFirstChild("Handle") then
        return
    end

    local offsetCf = CFrame.new(self.offset)
    local hatRot = CFrame.Angles(math.rad(self.rotation.X), math.rad(self.rotation.Y), math.rad(self.rotation.Z))
    local headRot = (headCf - headCf.p)

    local cf = CFrame.new(0, 0, 0)

    if self.transformPriority == 1 then
        cf = CFrame.new((headCf * offsetCf).Position)
    elseif self.transformPriority == 2 then
        cf = CFrame.new(headCf.Position + offsetCf.Position)
    end

    if self.rotTransformPriority == 1 then
        cf = cf * headRot * hatRot
    elseif self.rotTransformPriority == 2 then
        cf = CFrame.new(cf.Position) * hatRot
    end

    self.model._instance.Handle.CFrame = cf

    self.model._instance.Handle.LocalTransparencyModifier = self.visibleLocally and 0 or 1
    -- if hat is selected, it resets the LTM
end


function Hat:Destroy()
    local model = self.model
    local floatConnection = self._floatConnection
    self = nil
    model:Destroy()
    floatConnection:Disconnect()
end


return Hat