-- 서버 스크립트 (Script)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function addValue(player)
	print("플레이어 입장")
end
Players.PlayerAdded:Connect(addValue)

local captain=workspace:FindFirstChild("Captain")

--local captain = workspace:FindFirstChild("Captain")
local qPressedPlayers = {}

-- 클라이언트에서 Q를 눌렀음을 받는 함수
local function onQPressed(player)

	qPressedPlayers[player] = true

	if qPressedPlayers[player] and captain then
		-- Captain 오브젝트의 위치를 플레이어 위치로 업데이트
		local function updateCaptainPosition()
			if qPressedPlayers[player] and captain and player.Character then

				captain:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame+Vector3.new(0,1.8,0))
				captain["Meshes/캡틴아메리카_Shape_1"].Orientation=Vector3.new(90,player.Character.PrimaryPart.Orientation.Y,player.Character.PrimaryPart.Orientation.Z)      
				captain["Meshes/캡틴아메리카_Shape_2"].Orientation=Vector3.new(90,player.Character.PrimaryPart.Orientation.Y,player.Character.PrimaryPart.Orientation.Z)
				captain["Meshes/캡틴아메리카_Shape_2"].Position=captain["Meshes/캡틴아메리카_Shape_1"].Position+player.Character.HumanoidRootPart.CFrame.LookVector*2.5

			end
		end

		-- 계속해서 Captain 위치 업데이트
		while qPressedPlayers[player] do
			updateCaptainPosition()
			wait(0.0001) -- 매 0.1초마다 업데이트 이거 지우면 무한루프로 실행 안됨
		end
	end
end

-- 클라이언트에서 Q를 눌렀음을 받는 이벤트 핸들러
ReplicatedStorage:WaitForChild("QPressed").OnServerEvent:Connect(onQPressed)

-- 플레이어가 서버에서 나갔을 때 동작하는 함수
local function onPlayerRemoving(player)
	qPressedPlayers[player] = nil
end

-- 플레이어가 서버에서 나갈 때 이벤트 핸들러 연결
Players.PlayerRemoving:Connect(onPlayerRemoving)