local RunService = game:GetService("RunService")


local PersistentInstance = {}


function PersistentInstance:__index(index)
    if rawget(self, index) then
		return rawget(self, index)
    elseif rawget(PersistentInstance, index) then
        return rawget(PersistentInstance, index)
	else
		return rawget(self, "_instance")[index]
	end
end


function PersistentInstance:__newindex(index, value)
	rawget(self, "_instance")[index] = value
end


function PersistentInstance.new(inst, keepParent)
    local self = {}

    self._instance = inst

    self._clone = inst:Clone()
    self._parent = keepParent

    self._instance.Archivable = false
    self._className = "PersistentInstance"
    self._dead = false

    self._saveConnection = inst.AncestryChanged:Connect(function()
        if self._dead then
            return
        end
        PersistentInstance._saveFromDeletion(self)
    end)

    self._descendants = {}
    for _, lowerInst in ipairs(inst:GetChildren()) do
        table.insert(self._descendants, PersistentInstance.new(lowerInst, self))
        print(lowerInst.Name)
    end

    self._clone:ClearAllChildren()

    setmetatable(self, PersistentInstance)

    inst.Parent = self:_getParentInstance()

    return self
end


function PersistentInstance:_getParentInstance()
    local p = self._parent

    if type(p) == "table" and p._className == "PersistentInstance" then
        return p._instance
    end

    return p
end


function PersistentInstance:_saveFromDeletion()
    RunService.Heartbeat:Wait()
    local success = pcall(function()
        self._instance.Parent = self:_getParentInstance()
    end)

    if success then
        return
    end
    -- if we get to here, the folder was destroyed and we need to clean up the object

    self:_reinstantiate()
end


function PersistentInstance:_reinstantiate()
    -- expects the instance is already destroyed, so it doesn't destroy it on its own
    self._instance = self._clone:Clone()
    self._instance.Archivable = false
    self._instance.Parent = self:_getParentInstance()

    self._saveConnection:Disconnect()
    self._saveConnection = self._instance.AncestryChanged:Connect(function()
        self:_saveFromDeletion()
    end)
end


function PersistentInstance:Destroy()
    self._dead = true

    self._instance:Destroy()
    self._clone:Destroy()
    self._saveConnection:Disconnect()

    for _, inst in pairs(self._descendants) do
        inst:Destroy()
    end
    self._descendants = nil

    self = nil
end


return PersistentInstance