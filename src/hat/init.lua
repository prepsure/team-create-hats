local Importer = require(script.importer)

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

        id -                a number,  the asset id of the model
        offset -            a Vector3, the offset the accessory from the player's camera
        scale -             a Vector3, the scale of the accessory's mesh
        transformPriority - a string,  "rotate" or "translate" that describes in what order 
                                       orientations should be applied to the accessory
        visibleLocally -    a boolean, whether the local transparency modifier should be toggled

]]

function Hat.new(folder, model, propTable)
    local self = setmetatable({}, Hat)

    self.model = model
    self.id = propTable.id

    self:SetOffset(propTable.offset)
    self:SetScale(propTable.scale)
    self:SetTransformPriority(propTable.transformPriority)
    self:SetVisibleLocally(propTable.visibleLocally)

    self._floatConnection = self:_bindFloating()

    self.model.Parent = folder

    return self
end


--------- setters


function Hat:SetId(id)
    if self.model then
        self.model:Destroy()
    end

    self.model = Importer:LoadHat(id)
    self.id = id
end


function Hat:SetOffset(offset)
    self.offset = offset
end


function Hat:SetScale(scale)
    self.scale = scale
    self.model.Handle:FindFirstChildOfClass("SpecialMesh").Scale = scale
end


function Hat:SetTransformPriority(state)
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
    if self.transformPriority == "rotate" then
        self.model.Handle.CFrame = aroundCf * CFrame.new(self.offset)
    else
        self.model.Handle.CFrame = (CFrame.new(aroundCf.p) + self.offset) * (aroundCf - aroundCf.p)
    end
end


function Hat:Destroy()
    local model = self.model
    local floatConnection = self._floatConnection
    self = nil
    model:Destroy()
    floatConnection:Disconnect()
end


return Hat