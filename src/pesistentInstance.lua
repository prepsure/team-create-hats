local RunService = game:GetService("RunService")


local PersistentInstance = {}
PersistentInstance.__index = PersistentInstance


function PersistentInstance:__index(index)
    if PersistentInstance[index] then
		return PersistentInstance[index]
	else
		return self._instance[index]
	end
end


function PersistentInstance:__newindex(index, value)
	self._instance[index] = value
end


function PersistentInstance:__call()
    return self._instance
end


function PersistentInstance.new(inst, keepParent)
    local self = setmetatable({}, PersistentInstance)

    self._instance = inst

    self._clone = inst:Clone()
    self._parent = keepParent

    self._saveConnection = inst.AncestryChanged:Connect(function()
        self:_saveFromDeletion()
    end)

    self._className = "PersistentInstance"

    inst.Parent = self:_getParentInstance()

    return self
end


function PersistentInstance:_getParentInstance()
    local p = self._parent

    if type(p) == "table" and p._className == "PersistentInstance" then
        return p._instance
    end

    return self._parent
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
    self._instance.Parent = self:_getParentInstance()

    self._saveConnection:Disconnect()
    self._saveConnection = self._instance.AncestryChanged:Connect(function()
        self:_saveFromDeletion()
    end)
end


function PersistentInstance:Destroy()
    self._instance:Destroy()
    self._clone:Destroy()
    self._saveConnection:Disconnect()

    self = nil
end


return PersistentInstance