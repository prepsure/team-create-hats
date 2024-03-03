local PhysicsService = game:GetService("PhysicsService")

local groupName = "Plugin_Unselectable_Group"

local function createNonCursorCollidingGroup(groupName): boolean
	-- Register cursor group if it does not exist.
	local CURSOR_GROUP = "StudioSelectable"
	if not PhysicsService:IsCollisionGroupRegistered(CURSOR_GROUP) then
		if #PhysicsService:GetRegisteredCollisionGroups() >= PhysicsService:GetMaxCollisionGroups() then
			return false
		end
		PhysicsService:RegisterCollisionGroup(CURSOR_GROUP)
	end

	-- Register our group if not it does not exist.
	if not PhysicsService:IsCollisionGroupRegistered(groupName) then
		if #PhysicsService:GetRegisteredCollisionGroups() >= PhysicsService:GetMaxCollisionGroups() then
			return false
		end
		PhysicsService:RegisterCollisionGroup(groupName)
	end

	-- Change collision status if needed...

	-- For new StudioSelectable cursor group once change is enabled.
	if PhysicsService:CollisionGroupsAreCollidable(groupName, CURSOR_GROUP) then
		PhysicsService:CollisionGroupSetCollidable(groupName, CURSOR_GROUP, false)
	end

	-- For old Default cursor group before change is enabled.
	if PhysicsService:CollisionGroupsAreCollidable(groupName, "Default") then
		PhysicsService:CollisionGroupSetCollidable(groupName, "Default", false)
	end

	-- Group is registered and configured.
	return true
end

return if createNonCursorCollidingGroup(groupName) then groupName else "Default"
