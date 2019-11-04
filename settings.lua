-- checks if any settings aren't nil, if all are nil (user has never used the plugin) it enables the plugin and sets default settings
if not (plugin:GetSetting("Height") or plugin:GetSetting("Transparency") or plugin:GetSetting("HatID")) then
	plugin:SetSetting("Height",5)
	plugin:SetSetting("Transparency",0)
	plugin:SetSetting("HatID",1028826)
	plugin:SetSetting("Enabled",true)
end

return 0