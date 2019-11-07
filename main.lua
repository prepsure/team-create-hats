local Prechecks = require(script.prechecks)

if not Prechecks.shouldRun() then script.Disabled = true end

local Settings = require(script.settings)
Settings.CheckForFirstTimeUseAndSetUp()-- checks for new users and sets default settings