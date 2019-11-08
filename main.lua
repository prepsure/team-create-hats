-- main script, starts all modules

local Prechecks = require(script.prechecks)

if not Prechecks.shouldRun() then script.Disabled = true end

local Settings = require(script.settings)
Settings.CheckForFirstTimeUseAndSetUp() -- checks for new users and sets default settings

local Guis = require(script.gui) -- sets up and runs guis