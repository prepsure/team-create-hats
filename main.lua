local Prechecks = require(script.prechecks)

if not Prechecks.shouldRun() then script.Disabled = true end
