local guideChangeEvent = game.ReplicatedStorage:FindFirstChild("GuideChangeEvent")
local guide1 = script.Parent:FindFirstChild("Guide 1")
local guide2 = script.Parent:FindFirstChild("Guide 2")

guideChangeEvent.OnClientEvent:Connect(function()
	if guide1.Visible then
		guide1.Visible = false
		guide2.Visible = true
	else
		guide1.Visible = true
		guide2.Visible = false
	end
end)