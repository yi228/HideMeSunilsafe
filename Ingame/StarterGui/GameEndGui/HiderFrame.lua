local hiderWin = game:GetService("ReplicatedStorage"):WaitForChild("HiderWin")

hiderWin.OnClientEvent:Connect(function()
	print("showGuiH")
	script.Parent.Visible = true
end)
