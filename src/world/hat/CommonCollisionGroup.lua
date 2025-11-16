local PhysicsService = game:GetService("PhysicsService")

local selectableGroup = "StudioSelectable"
local unselectableGroup = "StudioUnselectable"

local function createNonCursorCollidingGroup(): boolean
	if
		not PhysicsService:IsCollisionGroupRegistered(unselectableGroup)
		and #PhysicsService:GetRegisteredCollisionGroups() >= PhysicsService:GetMaxCollisionGroups()
	then
		-- group could not be registered
		return false
	end

	PhysicsService:RegisterCollisionGroup(unselectableGroup)
	PhysicsService:CollisionGroupSetCollidable(unselectableGroup, selectableGroup, false)

	return true
end

local oldUnselectableGroup = "Plugin_Unselectable_Group"

local function removeOldUnselectableGroup()
	warn("make sure you check this works before publishing")
	if PhysicsService:IsCollisionGroupRegistered() then
		PhysicsService:UnregisterCollisionGroup(oldUnselectableGroup)
	end
end

removeOldUnselectableGroup()
return if createNonCursorCollidingGroup() then unselectableGroup else "Default"
