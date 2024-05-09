local leaveGuiEvent = game.ReplicatedStorage:WaitForChild("LeaveGuiEvent")

script.Parent.Activated:Connect(function()
	script.Parent.Visible = false
	leaveGuiEvent:FireServer()
end)

leaveGuiEvent.OnClientEvent:Connect(function()
	script.Parent.Visible = true
end)