local safeModel = game:GetService("ServerStorage"):FindFirstChild("Captain")

local taggerWin = game:GetService("ReplicatedStorage"):WaitForChild("TaggerWin")

game.Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		workspace.PlayerCount.Value +=1
		local randomInt=math.random(1,4)
		print(randomInt)
		if(randomInt==1) then
			safeModel = game:GetService("ServerStorage"):FindFirstChild("Captain")
		elseif(randomInt==2) then
			safeModel = game:GetService("ServerStorage"):FindFirstChild("Ironman")
		elseif(randomInt==3) then
			safeModel = game:GetService("ServerStorage"):FindFirstChild("Avengers")
		elseif(randomInt==4) then
			safeModel = game:GetService("ServerStorage"):FindFirstChild("Gogh")

		end
		local captainClone = safeModel:Clone()
		captainClone.Name = "Safe"
		captainClone.Parent = character

		local humanoid = character:WaitForChild("Humanoid")
		while humanoid and humanoid.Health > 0 do
			if(script.Parent == nil) then
				print("술래 금고 제거!")
				break
			end
			local rotation =  Vector3.new(math.rad(90), math.rad(0), math.rad(-player.Character.PrimaryPart.Orientation.Y)) 
			local position=player.Character.PrimaryPart.Position+Vector3.new(0, 1.8, 0)			
			local cframe = CFrame.new(position) * CFrame.Angles(rotation.X, rotation.Y,rotation.Z)
			captainClone:SetPrimaryPartCFrame(cframe)
			wait()
		end
		humanoid.Died:Connect(function()
			workspace.CatchCount.Value += 1
			if game.Workspace.CatchCount.Value >= workspace.PlayerCount.Value-1 then
				print("allHiderCaught")
				taggerWin:FireAllClients()
			end
			captainClone:Destroy()
		end)
	end)
end)
