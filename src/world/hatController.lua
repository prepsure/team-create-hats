local RunService = game:GetService("RunService")

local root = script.Parent.Parent

local Hat = require(root.world.hat)
local Importer = require(root.world.hat.importer)
local PersistentInstance = require(root.world.persistentInstance)
local PersistentFolder = require(root.world.persistentFolder)

local HatController = {}
HatController.List = {}

HatController.MaxHats = 10
HatController.IsImporting = false
local defaultHat = 1028826

function HatController:_insert(id, model, index, properties)
	assert(#HatController.List < HatController.MaxHats, "cannot go above max hats")

	local persistentModel = PersistentInstance.new(model, PersistentFolder)
	local hat = Hat.new(id, persistentModel, properties)

	index = index or (#HatController.List + 1)
	table.insert(HatController.List, index, hat)

	return hat
end

function HatController:Add(id, index, properties)
	id = id or defaultHat

	local code, response = Importer:LoadHat(id)

	if code == 200 then
		-- response will be a model if code is 200
		return self:_insert(id, response, index, properties)
	end

	print("team create with hats | error " .. code .. ": " .. response)
	return nil
end

function HatController:ChangeProperty(index, property, value)
	if #HatController.List == 0 then
		return
	end

	local hat = self.List[index]

	if property == "id" then -- for id changing, a new hat has to be imported, for other properties we can just modify the hat
		local oldProperties = hat:GetPropertyTable()

		local code, response = Importer:LoadHat(value)

		if code == 200 then
			-- response will be a model if code is 200
			self:Remove(index)
			self:_insert(value, response, index, oldProperties)
			return
		end

		print("team create with hats | error " .. code .. ": " .. response)
	else
		hat["Set" .. property](hat, value)
	end
end

function HatController:ChangePropertyOnAll(property, value)
	for i = 1, #HatController.List do
		self:ChangeProperty(i, property, value)
	end
end

function HatController:Remove(index: number)
	assert(typeof(index) == "number", "index was not a number") -- could cause program to hang if not defined

	if #HatController.List == 0 then
		return
	end

	-- if a new hat is being imported, we have to wait for it to finish
	while HatController.List[index] == nil do
		RunService.Heartbeat:Wait()
	end

	local hat = table.remove(HatController.List, index)
	hat:Destroy()
end

function HatController:RemoveAll()
	for i = #HatController.List, 1, -1 do
		HatController:Remove(i)
	end
end

function HatController:ImportFromCharacter()
	if HatController.IsImporting then
		return
	end

	HatController.IsImporting = true

	local idTable = Importer:LoadHatsFromCharacter()

	self:RemoveAll()
	for _, id in pairs(idTable) do
		self:Add(id)
	end

	HatController.IsImporting = false
end

return HatController
