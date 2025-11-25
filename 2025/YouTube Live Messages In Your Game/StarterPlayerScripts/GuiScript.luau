local submitEvent = game:GetService("ReplicatedStorage"):WaitForChild("SubmitVideoID")

local playerGui = game.Players.LocalPlayer.PlayerGui

local gui : ScreenGui = playerGui:WaitForChild("ScreenGui")
local inputTxt : TextBox = gui.Input
local submitButton : TextButton = gui.TextButton

local function extractVideoId(url)
	local match = string.match(url, "v=([%w_%-]+)")
	if match and #match == 11 then
		return match
	end
	return nil
end

submitButton.MouseButton1Click:Connect(function()
	local videoId = extractVideoId(inputTxt.Text)
	
	if not videoId then 
		warn("Invalid input: No video ID detected")
		return 
	end
	
	submitEvent:FireServer(videoId)
end)
