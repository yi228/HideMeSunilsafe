local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")
-- 최소 음량 설정
local minVolume = 0.01
-- 최대 음량 설정
local maxVolume = 0.25
-- 최대 거리 설정
local maxDistance = 28
-- 기침 소리 딜레이
local coughingDelay = 5
local breathingSound = SoundService:FindFirstChild("BreathingSound")
breathingSound = Instance.new("Sound")
breathingSound.Name = "BreathingSound_Player"
breathingSound.SoundId = "rbxassetid://328460122"
breathingSound.Parent = SoundService


while wait(coughingDelay) do
	for _, player in ipairs(Players:GetPlayers()) do
		if workspace.Time.Value <= workspace.WaitTime.Value then
			continue
		end
		if player ~= LocalPlayer and player.Name ~= workspace.TaggerName.Value and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
			if distance > maxDistance then
				continue
			end
			local volume = (maxDistance - distance) / maxDistance * (maxVolume - minVolume) + minVolume
			volume = math.clamp(volume, minVolume, maxVolume)
			-- 숨소리 재생
			breathingSound.Volume = volume
			breathingSound:Play()
			print("플레이!")
		end
	end
end
