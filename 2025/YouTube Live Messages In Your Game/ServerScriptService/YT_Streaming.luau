-- Remember to Enable HTTPService in Game Settings!

local HTTPService = game:GetService("HttpService")
local submitEvent = game:GetService("ReplicatedStorage"):WaitForChild("SubmitVideoID") -- Remember to create a Remote Event in ReplicatedStorage

local API_KEY = "<your API key here>"
-- If using Secrets, do HTTPService:GetSecret("your_secret_name")

local function getLiveChatId(videoId: string)
	local success, response = pcall(function()
    -- If using Secrets, do API_KEY:AddPrefix(`https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id={videoId}&key=`)
		local url = `https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id={videoId}&key={API_KEY}`
		local res = HTTPService:RequestAsync({
			Url = url,
			Headers = {},
			Method = "GET"
		})
		local bodyRes = HTTPService:JSONDecode(res.Body)
		assert(res.Success, `Error occured: {bodyRes.error and bodyRes.error.message}`)
		return bodyRes
	end)
	
	if not success then
		return false, response
	end
	
	local details = response.items[1] and response.items[1].liveStreamingDetails
	return true, details and details.activeLiveChatId
end

local function getChatMessages(liveChatId: string, pageToken: string?)
	local success, response = pcall(function()
    -- If using Secrets, do API_KEY:AddPrefix(`https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId={liveChatId}&part=snippet,authorDetails&pageToken={pageToken}&key=`)
		local url = `https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId={liveChatId}&part=snippet,authorDetails&pageToken={pageToken}&key={API_KEY}`
		local res = HTTPService:RequestAsync({
			Url = url,
			Headers = {},
			Method = "GET"
		})
		local bodyRes = HTTPService:JSONDecode(res.Body)
		assert(res.Success, `Error occured: {bodyRes.error and bodyRes.error.message}`)
		return bodyRes
	end)
	return success, response
end
--================ MAIN ================
local registered = false

submitEvent.OnServerEvent:Connect(function(plr, videoId)
	if registered then return end
	
	local success1, LCI_response = getLiveChatId(videoId)

	if not success1 then
		warn(LCI_response)
		return
	end
	
	registered = true

	local LiveChatID = LCI_response
	local ditchInitial = false
	local nextPageToken = ""
	
	while true do
		local success2, chatMsg_response = getChatMessages(LiveChatID, nextPageToken)	
		if not success2 then
			task.wait(20)
			continue
		end

		nextPageToken = chatMsg_response.nextPageToken

		if not ditchInitial then 
			ditchInitial = true 
			task.wait((chatMsg_response.pollingIntervalMillis/1000)+1)
			continue 
		end

		for _, messageContent in chatMsg_response.items do
			print(`{messageContent.authorDetails.displayName} said "{messageContent.snippet.displayMessage}"`)
		end

		task.wait((chatMsg_response.pollingIntervalMillis/1000)+1)
	end
end)
