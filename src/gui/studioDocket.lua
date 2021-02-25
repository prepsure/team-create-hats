local StudioDocket = {}

local plugin = script:FindFirstAncestorWhichIsA("Plugin")

StudioDocket.Toolbar = plugin:CreateToolbar("Team Create Hats")

StudioDocket.TogglePropertyWindow = StudioDocket.Toolbar:CreateButton("Edit Hats", "change hat properties", "rbxassetid://692849427")
StudioDocket.TogglePreviewWindow = StudioDocket.Toolbar:CreateButton("Preview", "preview hats", "rbxassetid://692849427")

StudioDocket.Docket = plugin:CreateDockWidgetPluginGui(
    "Team Create with Hats",
    DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, false, false, 200, 150)
)
StudioDocket.Docket.Title = "Hat Editor"
StudioDocket.TogglePropertyWindow:SetActive(StudioDocket.Docket.Enabled)

StudioDocket.TogglePropertyWindow.Click:Connect(function()
    StudioDocket.Docket.Enabled = not StudioDocket.Docket.Enabled
    StudioDocket.TogglePropertyWindow:SetActive(StudioDocket.Docket.Enabled)
end)

return StudioDocket