return function(icon, canChange)
	if not canChange then
		return
	end

	local pluginMouse = script:FindFirstAncestorWhichIsA("Plugin"):GetMouse()
	pluginMouse.Icon = "rbxasset://SystemCursors/" .. icon
end
