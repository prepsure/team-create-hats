-- main script, starts all modules

_G.plugin_990908723 = plugin -- apparently plugin doesn't work within a module script

local Prechecks = require(script.prechecks)

if not Prechecks.shouldRun() then script.Disabled = true end

local Settings = require(script.settings)
Settings.CheckForFirstTimeUseAndSetUp() -- checks for new users and sets default settings
local Guis = require(script.gui) -- sets up and runs guis
local HatUpdate = require(script.hatupdate)

HatUpdate.Connect()

_G.plugin_990908723.Unloading:Connect(function()
	HatUpdate.Disconnect()
end)