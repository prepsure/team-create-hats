-- handles all guis
local Guis = {}

-- studio widgets plugin gui module
local studioWidgets = require(1638103268)

local TeamCreate = plugin:CreateToolbar("Team Create Hats")
local ToggleHat = TeamCreate:CreateButton("Change Hat","Enhance Your TC Experience","rbxassetid://692849427")
local DocketInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 150)

local pluginGui = plugin:CreateDockWidgetPluginGui("Team Create Hats", DocketInfo)
pluginGui.Title = "Team Create Hat"

local LabeledCheckboxClass = studioWidgets.LabeledCheckbox
local LabeledTextInputClass = studioWidgets.LabeledTextInput
local CollapsibleTitledSectionClass = studioWidgets.CollapsibleTitledSection
local GuiUtil = studioWidgets.GuiUtilities

local Title = CollapsibleTitledSectionClass.new("HatProperties", "Hat Properties", true, true)
Title:GetSectionFrame().Parent = pluginGui

local TextboxHatID = LabeledTextInputClass.new("HatID", "AccessoryId", tostring(plugin:GetSetting("HatID")))
local TextboxHeight = LabeledTextInputClass.new("Height", "Height", tostring(plugin:GetSetting("Height")))
local defaultTransparent = plugin:GetSetting("Transparency") == 0 and true or false
local CheckboxTransparency = LabeledCheckboxClass.new("Transparent", "VisibleLocal", defaultTransparent, true)
local CheckboxEnabled = LabeledCheckboxClass.new("Enabled", "Enabled", plugin:GetSetting("Enabled"), true)

local function SetGui(Objs)
	local background = Instance.new("Frame")
	background.BackgroundColor3 = Objs[1]:GetFrame().BackgroundColor3
	background.Size = UDim2.new(1, 0, 1, 0)
	background.ZIndex = -10
	background.Parent = pluginGui
	GuiUtil.syncGuiElementBackgroundColor(background)

	for i, Obj in pairs(Objs)do
		local Frame = Obj:GetFrame()
		Frame.Position = UDim2.new(0, 0, 0, 30 * (i - 1))
		Frame.Parent = Title:GetContentsFrame()
		i = i + 1
	end
end

SetGui({TextboxHatID, TextboxHeight, CheckboxTransparency, CheckboxEnabled})

function Guis.bindToButton()

end

ToggleHat.Click:Connect(function()
	pluginGui.Enabled = not pluginGui.Enabled
	ToggleHat:SetActive(pluginGui.Enabled)
end)

local function KeepNumbers(HatID)
	TextboxHatID:SetValue(HatID:gsub('%D',''))
end

local function KeepNumbersH(Height)
	local NumericString = Height:match("%d[%d.]*") or ""
	if TextboxHeight:GetValue():sub(1,1) == "-" then
		NumericString = "-"..NumericString
	end
	TextboxHeight:SetValue(NumericString)
end

TextboxHatID:SetValueChangedFunction(KeepNumbers)
TextboxHatID:GetFrame().Wrapper.TextBox.FocusLost:Connect(ChangeHat)
TextboxHeight:SetValueChangedFunction(KeepNumbersH)
TextboxHeight:GetFrame().Wrapper.TextBox.FocusLost:Connect(ChangeHeight)

CheckTransparency:SetValueChangedFunction(ChangeTransparency)