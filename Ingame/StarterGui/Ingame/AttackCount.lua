--script.Parent.Text=5
game:GetService("RunService").RenderStepped:Connect(function()
	script.Parent.Text="남은 공격 횟수: "..tostring(game.ReplicatedStorage.AttackCount.Value)
end)