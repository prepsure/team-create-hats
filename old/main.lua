-- main script, starts all modules

local Prechecks = require(script.prechecks)

if Prechecks.shouldRun() then

	_G.plugin_990908723 = plugin -- apparently plugin doesn't work within a module script
	
	local Settings = require(script.settings)
	Settings.CheckForFirstTimeUseAndSetUp() -- checks for new users and sets default settings
	
	require(script.gui) -- sets up and runs guis
	require(script.changeproperty) -- sets up and runs properties
	
	local HatUpdate = require(script.hatupdate)
	
	
	if Settings.GetEnabled() then
		HatUpdate.Connect()
	end
	
	_G.plugin_990908723.Unloading:Connect(function()
		HatUpdate.Disconnect()
	end)

end