local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Karate - .gg/Yc5krSCZHD",
    LoadingTitle = "Karate",
    LoadingSubtitle = "by Sw1ndler#7733"
})

local Tab = Window:CreateTab("Main") 
Tab:CreateSection("Info")

Tab:CreateLabel("This script is now paid")
Tab:CreateLabel("join discord.gg/Yc5krSCZHD to purchase the full version")
Tab:CreateButton({
    Name = "Copy Discord",
    Callback = function()
        setclipboard("discord.gg/Yc5krSCZHD")
    end,
})
