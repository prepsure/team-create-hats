local StudioDocket = {}

local plugin = script:FindFirstAncestorWhichIsA("Plugin")


StudioDocket.Toolbar = plugin:CreateToolbar("Team Create Hats")


local function createDocket(button, name)
    local docket = plugin:CreateDockWidgetPluginGui(
        name, DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, false, false, 200, 150)
    )

    docket.Title = name
    docket.Name = "Team Create Hats: " .. name
    button:SetActive(docket.Enabled)

    button.Click:Connect(function()
        docket.Enabled = not docket.Enabled
        button:SetActive(docket.Enabled)
    end)

    docket:BindToClose(function()
        button:SetActive(false)
        docket.Enabled = false
    end)

    return docket
end


StudioDocket.Windows = {
    ['Configure Hats'] = {
        Button = StudioDocket.Toolbar:CreateButton(
            "Configure Hats",
            "change your hat properties",
            "rbxassetid://6475451437"
        ),
    },
    ['Preview Hats'] = {
        Button = StudioDocket.Toolbar:CreateButton(
            "Preview Hats",
            "see what hats look like on your team create ball",
            "rbxassetid://6475451821"
        ),
    }
}

for name, window in pairs(StudioDocket.Windows) do
    window.Docket = createDocket(window.Button, name)
end


return StudioDocket