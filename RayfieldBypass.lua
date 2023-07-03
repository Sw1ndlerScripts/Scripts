-- Run before the rayfield script

local keyWindow

local oldGet
oldGet = hookfunction(game.GetObjects, function(self, url, ...) -- grabbing the key system ui
	if keyWindow == nil and url == "rbxassetid://11380036235" then
		local res = oldGet(self, url, ...)
		keyWindow = res[1]
	
		return res	
	end
	return oldGet(self, url, ...)
end)

repeat task.wait() until keyWindow ~= nil
task.wait(1)

local con = getconnections(keyWindow.Main.Input.InputBox.FocusLost)[1]
local settings = getupvalue(con.Function, 2)
local keys = settings.KeySettings.Key

for i,v in pairs(keys) do
	print("Key:  " .. v)
end

keyWindow.Main.Input.InputBox.Text = keys[1] -- setting the texbox to the key
con.Function() -- run the function that checks the key
