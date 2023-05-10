local PhysicsService = game:GetService("PhysicsService")

local groupName = "Plugin_Unselectable_Group"

local function hasCollisionGroup(name)
	for _, group in PhysicsService:GetRegisteredCollisionGroups() do
		if group.name == name then
			return true
		end
	end

	return false
end

local function getOrCreateGroup(name)
	if hasCollisionGroup(name) then
		return true
	end

	local ok, _ = pcall(PhysicsService.RegisterCollisionGroup, PhysicsService, name)
	return ok
end

local didGetGroup = getOrCreateGroup(groupName)

if didGetGroup then
	PhysicsService:CollisionGroupSetCollidable("Default", groupName, false)
end

return if didGetGroup then groupName else "Default"
