-- does preliminary checks to see if the plugin should run

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local function shouldRun()
    return (RunService:IsEdit()) and -- determines if the game is running
           (Players.LocalPlayer ~= nil) -- determines if team create is active
end

return shouldRun()