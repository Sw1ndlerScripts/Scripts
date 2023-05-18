local HttpService = game:GetService("HttpService")
local vim = game:GetService("VirtualInputManager")

local plr = game.Players.LocalPlayer
local autoPress = false

function getItem(itemName)
    local url = "https://catalog.roblox.com/v1/search/items/details?Category=1&Keyword='" .. itemName .. "'"

    local res = HttpService:JSONDecode(game:HttpGet(url))
    local item = res["data"][1]

    return item
end

function getArena()
    return plr.DataSave.DontSave.MostRecentArena.Value
end

function clickButton(a)
    vim:SendMouseButtonEvent(a.AbsolutePosition.X + a.AbsoluteSize.X/2, a.AbsolutePosition.Y + 50, 0, true, a, 1)
    vim:SendMouseButtonEvent(a.AbsolutePosition.X + a.AbsoluteSize.X/2 ,a.AbsolutePosition.Y + 50, 0, false, a, 1)
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Price is Right - Sw1ndler#7733",
    LoadingTitle = "Price is Right - Sw1ndler#7733",
    LoadingSubtitle = "Loading..."
})

local MainTab = Window:CreateTab("Main")
local InfoTab = Window:CreateTab("Info")

MainTab:CreateSection("Main")

MainTab:CreateToggle({
    Name = "Auto Press",
    CurrentValue = false,
    Callback = function(value)
        autoPress = value
    end
})

InfoTab:CreateSection("Read Me")

InfoTab:CreateLabel("The answer may not always be correct")
InfoTab:CreateLabel("due to the games prices being outdated")


MainTab:CreateSection("Info")

local guessPriceLabel = MainTab:CreateLabel("Guess Price: ")
local actualPriceLabel = MainTab:CreateLabel("Actual Price: ")
local resultLabel = MainTab:CreateLabel("Result: ")

local connection

function gameConnection()
    local arena = getArena()

    -- wait until guessPriceInstance and itemNameInstance exist
    repeat 
        task.wait()
    until pcall(function()
        local l = arena.ArenaTemplate.Important.GuessPrice.SurfaceGui.TextLabel
        local l = arena.ArenaTemplate.Important.ItemName.SurfaceGui.TextLabel
    end)

    local guessPriceInstance = arena.ArenaTemplate.Important.GuessPrice.SurfaceGui.TextLabel
    local itemNameInstance = arena.ArenaTemplate.Important.ItemName.SurfaceGui.TextLabel

    repeat task.wait() until guessPriceInstance.Text and itemNameInstance.Text

    connection = itemNameInstance:GetPropertyChangedSignal("Text"):Connect(function()
        task.wait(0.1)
        local itemName = itemNameInstance.Text
        local guessPrice = guessPriceInstance.Text

        local actualPrice = getItem(itemName)
        actualPrice = actualPrice.lowestPrice or actualPrice.price
        
        guessPrice = guessPrice:gsub(",", "")
        guessPrice = tonumber(guessPrice:match("%d+"))
        
        guessPriceLabel:Set("Guess Price: " .. guessPrice)
        actualPriceLabel:Set("Actual Price: " .. actualPrice)

        if actualPrice > guessPrice then
            resultLabel:Set("Result: Higher")
            if autoPress then
                clickButton(game:GetService("Players").LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Buttons.Higher)
            end
        else
            resultLabel:Set("Result: Lower")
            if autoPress then
                clickButton(game:GetService("Players").LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Buttons.Lower)
            end
        end
        
    end)

    repeat task.wait() until plr.DataSave.DontSave.IsBattling.Value == false
    connection:Disconnect()
end

if plr.DataSave.DontSave.IsBattling.Value then
    gameConnection()
end

repeat task.wait() until plr.DataSave.DontSave.MostRecentArena.Value ~= nil
if connection then connection:Disconnect() end

gameConnection()

plr.DataSave.DontSave.MostRecentArena:GetPropertyChangedSignal("Value"):Connect(gameConnection)
