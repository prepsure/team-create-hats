local PhysicsService = game:GetService("PhysicsService")

local groupName = "Plugin_Unselectable_Group"

local function getOrCreateGroup(name)
	local ok, _ = pcall(PhysicsService.GetCollisionGroupId, PhysicsService, name)
	if not ok then
		-- Create may fail if we have hit the maximum of 32 different groups
		ok, _ = pcall(PhysicsService.CreateCollisionGroup, PhysicsService, name)
	end
	return ok
end

local didGetGroup = getOrCreateGroup(groupName)

if didGetGroup then
	PhysicsService:CollisionGroupSetCollidable("Default", groupName, false)
end

return if didGetGroup then groupName else "Default"
