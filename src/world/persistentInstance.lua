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
		PersistentInstance._saveFromDeletion(self)
	end)

	self._replicateConnection = inst.Changed:Connect(function(prop)
		PersistentInstance._replicateToClone(self, prop)
	end)

	self._descendants = {}
	for _, lowerInst in ipairs(inst:GetChildren()) do
		table.insert(self._descendants, PersistentInstance.new(lowerInst, self))
	end

	self._clone:ClearAllChildren()

	setmetatable(self, PersistentInstance)

	inst.Parent = self:_getParentInstance()

	return self
end

function PersistentInstance:_getParentInstance()
	local p = self._parent

	if p == false then -- if p is set to false that means it doesn't have a parent (can't set to nil for reasons)
		return nil
	end

	if type(p) == "table" and p._className == "PersistentInstance" then
		return p._instance
	end

	return p
end

function PersistentInstance:_saveFromDeletion()
	if self._dead then
		return
	end

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

function PersistentInstance:_replicateToClone(prop)
	if prop == "Parent" then
		return
	end

	pcall(function() -- need to pcall because some properties cant be modified by scripts and its like eh whatever
		self._clone[prop] = self._instance[prop]
	end)
end

function PersistentInstance:_reinstantiate()
	-- expects the instance is already destroyed, so it doesn't destroy it on its own
	self._instance = self._clone:Clone()

	if self._clone:IsA("BasePart") then
		self._instance.LocalTransparencyModifier = self._clone.LocalTransparencyModifier
		-- :Clone() doesn't clone LocalTransparencyModifer for some reason?
	end

	self._instance.Archivable = false
	self._instance.Parent = self:_getParentInstance()

	self._saveConnection:Disconnect()
	self._saveConnection = self._instance.AncestryChanged:Connect(function()
		self:_saveFromDeletion()
	end)

	self._replicateConnection:Disconnect()
	self._replicateConnection = self._instance.Changed:Connect(function(prop)
		self:_replicateToClone(prop)
	end)
end

function PersistentInstance:Reparent(p)
	rawset(self, "_parent", p)
	self._instance.Parent = self:_getParentInstance()
end

function PersistentInstance:Destroy()
	self._dead = true

	self._instance:Destroy()
	self._clone:Destroy()
	self._saveConnection:Disconnect()
	self._replicateConnection:Disconnect()

	for _, inst in pairs(self._descendants) do
		inst:Destroy()
	end
	self._descendants = nil

	self = nil
end

return PersistentInstance
