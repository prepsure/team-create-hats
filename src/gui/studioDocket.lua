local StudioDocket = {}

local plugin = script:FindFirstAncestorWhichIsA("Plugin")


StudioDocket.Toolbar = plugin:CreateToolbar("Team Create Hats")


local function createDocket(button, name)
    local docket = plugin:CreateDockWidgetPluginGui(
        name, DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, false, false, 200, 150)
    )

    docket.Title = name
    button:SetActive(docket.Enabled)

    button.Click:Connect(function()
        docket.Enabled = not docket.Enabled
        button:SetActive(docket.Enabled)
    end)

    return docket
end


StudioDocket.Windows = {
    ['Edit Hats'] = {
        Button = StudioDocket.Toolbar:CreateButton("Edit Hats", "change hat properties", "rbxassetid://692849427"),
    },
    ['Preview Hats'] = {
        Button = StudioDocket.Toolbar:CreateButton("Preview", "preview hats", "rbxassetid://692849427"),
    }
}

for name, window in pairs(StudioDocket.Windows) do
    window.Docket = createDocket(window.Button, name)
end


return StudioDocket