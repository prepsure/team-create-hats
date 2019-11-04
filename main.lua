local Prechecks = require(script.prechecks)

if not Prechecks.shouldRun() then script.Disabled = true end

require(script.settings) -- checks for new users and sets default settings