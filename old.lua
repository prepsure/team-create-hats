local RunService = game:GetService("RunService")

if not RunService:IsRunning() then script.Disabled = true end -- checks whether the player is play testing the game or working in studio

local InsertService = game:GetService("InsertService")
local Players =  game:GetService("Players")

local defaultCount = 0

if not plugin:GetSetting("Height") then
	plugin:SetSetting("Height",5)
	defaultCount = defaultCount + 1
end

if not plugin:GetSetting("Transparency") then
	plugin:SetSetting("Transparency",0)
	defaultCount = defaultCount + 1
end

if not plugin:GetSetting("HatID") then
	plugin:SetSetting("HatID",1028826)
	defaultCount = defaultCount + 1
end

if defaultCount == 3 then -- if default count is 3, the player has never used the plugin
	plugin:SetSetting("Enabled",true)
end

local HatFolder
local CurrentHat
local connection

--gui stuff--
local TeamCreate = plugin:CreateToolbar("Team Create Hats")
local ToggleHat = TeamCreate:CreateButton("Change Hat","Enhance Your TC Experience","rbxassetid://692849427")
local DocketInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 200, 150)

local pluginGui = plugin:CreateDockWidgetPluginGui("Team Create Hats", DocketInfo)
pluginGui.Title = "Team Create Hat"
local studioWidgets = require(1638103268)

local LabeledCheckboxClass = studioWidgets.LabeledCheckbox
local LabeledTextInputClass = studioWidgets.LabeledTextInput
local CollapsibleTitledSectionClass = studioWidgets.CollapsibleTitledSection
local GuiUtil = studioWidgets.GuiUtilities

local Title = CollapsibleTitledSectionClass.new("HatProperties","Hat Properties",true,true)

do
	local Frame = Title:GetSectionFrame()
	Frame.Parent = pluginGui
end

local TextboxHatID = LabeledTextInputClass.new("HatID","AccessoryId",tostring(plugin:GetSetting("HatID")))
local TextboxHeight = LabeledTextInputClass.new("Height","Height",tostring(plugin:GetSetting("Height")))
local defaultTransparent = plugin:GetSetting("Transparency") == 0 and true or false
local CheckTransparency = LabeledCheckboxClass.new("Transparent","VisibleLocal",defaultTransparent,true)
local CheckEnabled = LabeledCheckboxClass.new("Enabled","Enabled",plugin:GetSetting("Enabled"),true)

local function SetGui(Objs)
	local background = Instance.new("Frame")
	background.BackgroundColor3 = Objs[1]:GetFrame().BackgroundColor3
	background.Size = UDim2.new(1,0,1,0)
	background.ZIndex = -10
	background.Parent = pluginGui
	GuiUtil.syncGuiElementBackgroundColor(background)
	
	for i,Obj in pairs(Objs)do
		local Frame = Obj:GetFrame()
		Frame.Position = UDim2.new(0,0,0,30*(i-1))
		Frame.Parent = Title:GetContentsFrame()
		i=i+1
	end
end

SetGui({TextboxHatID,TextboxHeight,CheckTransparency,CheckEnabled})

ToggleHat.Click:Connect(function()
	pluginGui.Enabled = not pluginGui.Enabled
	ToggleHat:SetActive(pluginGui.Enabled)
end)

-- connect gui stuff
local function ChangeHeight()
	local h = TextboxHeight:GetValue()
	if tonumber(h) and (h ~= "") then
		plugin:SetSetting("Height",TextboxHeight:GetValue())
	else
		TextboxHeight:SetValue(plugin:GetSetting("Height"))
	end
end

local function ChangeTransparency(visible)
	local transparency = visible and 0 or 1
	plugin:SetSetting("Transparency",transparency)
end

local function ChangeHat()
	--[
	local HatID = TextboxHatID:GetValue()
	if HatID ~= "" then
		local success,Hat = pcall(function()
			local Hat = InsertService:LoadAsset(tonumber(HatID)):FindFirstChildOfClass("Accessory")
			return Hat
		end)
		if success then
			if CurrentHat then
				CurrentHat:Destroy()
			end
			
			CurrentHat = Hat
			CurrentHat.Archivable = false
			CurrentHat.Handle.Locked = true
			CurrentHat.Parent = Folder
			plugin:SetSetting("HatID",HatID)
			CurrentHat.Handle.CFrame = workspace.CurrentCamera.CFrame + Vector3.new(0, plugin:GetSetting("Height"), 0)
			CurrentHat.Handle.LocalTransparencyModifier = plugin:GetSetting("Transparency")
			if CurrentHat.Handle:FindFirstChildOfClass("Attachment") then
				CurrentHat.Handle:FindFirstChildOfClass("Attachment"):Destroy()
			end
		else
			TextboxHatID:SetValue(plugin:GetSetting("HatID"))
		end
	else
		TextboxHatID:SetValue(plugin:GetSetting("HatID"))
	end
	--]]
end

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

--run plugin
local function MakeFolder()
	Folder = script.Parent["Player'sHats"]:Clone()
	Folder.Parent = workspace
	Folder.Name = Players.LocalPlayer.Name.."'s hats"
	Folder.Archivable = false
	ChangeHat()
end

local function UpdateHat()
	if CurrentHat.Parent == Folder then
		CurrentHat.Handle.CFrame = workspace.CurrentCamera.CFrame+Vector3.new(0, plugin:GetSetting("Height") ,0)
		CurrentHat.Handle.LocalTransparencyModifier = plugin:GetSetting("Transparency")
	else
		ChangeHat()
	end	
end

local function Move()
	--[
	if plugin:GetSetting("HatID") and Players.LocalPlayer and plugin:GetSetting("Enabled") then		
		if not(Folder) then
			MakeFolder()
		elseif Folder.Parent ~= workspace then
			local success = pcall(function() Folder.Parent = workspace end)
			if not(success) then
				MakeFolder()
			end
		end
		UpdateHat()
	end
	--]]
end
	
local function ChangeEnabled(enabled)
	plugin:SetSetting("Enabled",enabled)
	if enabled then
		connection = RunService.Heartbeat:Connect(Move)
	end
end

plugin.Unloading:Connect(function()
	if Folder then
		Folder:Destroy()
	end
	connection:Disconnect()
end)

CheckEnabled:SetValueChangedFunction(ChangeEnabled)
connection = RunService.Heartbeat:Connect(Move)