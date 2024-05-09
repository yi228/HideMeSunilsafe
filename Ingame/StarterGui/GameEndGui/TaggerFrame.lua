local taggerWin = game:GetService("ReplicatedStorage"):WaitForChild("TaggerWin")

taggerWin.OnClientEvent:Connect(function()
	print("showGuiT")
	script.Parent.Visible = true
end)