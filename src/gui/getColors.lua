local colors = {
    Light = {
        Red = Color3.fromRGB(255, 153, 153),
        Blue = Color3.fromRGB(149, 186, 251),
        Green = Color3.fromRGB(143, 233, 177),
        Gray = Color3.fromRGB(209, 209, 209),
    },

    Dark = {
        Red = Color3.fromRGB(245, 106, 106),
        Blue = Color3.fromRGB(74, 157, 253),
        Green = Color3.fromRGB(82, 241, 167),
        Gray = Color3.fromRGB(137, 137, 137),
    },
}


return function(theme, color)
    return colors[theme.Name][color]
end