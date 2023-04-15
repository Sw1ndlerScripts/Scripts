local CatCooldown = 86400 -- 24 hours in seconds


local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local getsynasset = getsynasset or getcustomasset

local lastFactShown
if isfile("LastCatShown.txt") then
    lastFactShown = tonumber(readfile("LastCatShown.txt"))
end

if lastFactShown and os.time() - lastFactShown < CatCooldown then -- end prematurely if the cooldown is not over
    return 
end

writefile("LastCatShown.txt", tostring(os.time()))

local catFact

while true do
    local response = game:HttpGet("https://meowfacts.herokuapp.com/")
    local info = HttpService:JSONDecode(response)
    
    catFact = info.data[1]

    if catFact and #catFact <= 96 then
        break
    end
end


local catImage = game:HttpGet("https://cataas.com/cat?width=500&height=500")


writefile("Cat.jpg", catImage)




-- localizing these outside the [do end] to access later
local ScreenGui = Instance.new("ScreenGui")
local Container = Instance.new("Frame")
local CatImage = Instance.new("ImageLabel")
local CatFact = Instance.new("TextLabel")
local TopBar = Instance.new("Frame")
local CloseButton = Instance.new("ImageButton")
local Title = Instance.new("TextLabel")
local TitlePadding = Instance.new("UIPadding")

do

    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Enabled = false -- set it to disabled to let the image and text load
    
    Container.Name = "Container"
    Container.Parent = ScreenGui
    Container.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0.7, 0, 0.25, 0)
    Container.Size = UDim2.new(0, 236, 0, 273)
    
    CatImage.Name = "CatImage"
    CatImage.Parent = Container
    CatImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CatImage.Position = UDim2.new(0, 30, 0, 80)
    CatImage.Size = UDim2.new(0, 175, 0, 175)
    CatImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    CatImage.BackgroundTransparency = 1
    
    CatFact.Name = "CatFact"
    CatFact.Parent = Container
    CatFact.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CatFact.BackgroundTransparency = 1.000
    CatFact.Position = UDim2.new(0, 5, 0, 22)
    CatFact.Size = UDim2.new(0, 225, 0, 51)
    CatFact.Font = Enum.Font.SourceSans
    CatFact.Text = "Cat Fact Here"
    CatFact.TextColor3 = Color3.fromRGB(255, 255, 255)
    CatFact.TextSize = 14.000
    CatFact.TextWrapped = true
    
    TopBar.Name = "TopBar"
    TopBar.Parent = Container
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TopBar.BorderSizePixel = 0
    TopBar.Position = UDim2.new(0, 0, -0.000938564539, 0)
    TopBar.Size = UDim2.new(1, 0, -0.0320284702, 31)
    
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderSizePixel = 0
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = "Daily Cat Fact"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    TitlePadding.Name = "TitlePadding"
    TitlePadding.Parent = Title
    TitlePadding.PaddingLeft = UDim.new(0, 6)
    
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.BackgroundTransparency = 1.000
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(0.919491529, 0, 0.0449312441, 0)
    CloseButton.Size = UDim2.new(0, 19, 0, 19)
    CloseButton.Image = "rbxassetid://10747384394"
    
    if syn then
        syn.protect_gui(ScreenGui)
    end
end -- gui styling

do

    local isDragging = false
    local startPosition = nil
    local startOffset = nil
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            startPosition = input.Position
            startOffset = Container.Position - UDim2.new(0, startPosition.X, 0, startPosition.Y)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local newPosition = startOffset + UDim2.new(0, input.Position.X, 0, input.Position.Y)
            Container.Position = newPosition
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)

end -- ui dragging i pasted from chat gpt


CatFact.Text = catFact
CatImage.Image = getsynasset('Cat.jpg')

ScreenGui.Enabled = true


CloseButton.MouseButton1Click:Connect(function()
    if isfile("Cat.jpg") then
        delfile("Cat.jpg")
    end
    ScreenGui:Destroy()
end)


