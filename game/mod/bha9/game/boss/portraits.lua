local portraits = {
    "Satori",
    "Haiji",
    "Belle",
    "Misaki",
}
for index, character in ipairs(portraits) do
    for i = 1, 8, 1 do
        LoadImageFromFile(character .. "_" .. tostring(int(i)), "assets/portraits/" .. character .. "_" .. tostring(i) .. ".png")
    end
end