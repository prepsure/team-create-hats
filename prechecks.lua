-- does preliminary checks to see if the plugin should run

local Prechecks = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

function Prechecks.shouldRun()
    return (not RunService:IsRunning()) and -- determines if the game is running
        (Players.LocalPlayer) -- determines if team create is active
end

return Prechecks