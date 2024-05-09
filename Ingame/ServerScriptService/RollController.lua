local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local taggerWin = game:GetService("ReplicatedStorage"):WaitForChild("TaggerWin")
local hiderWin = game:GetService("ReplicatedStorage"):WaitForChild("HiderWin")

local maxPlayer = 3
local tagger -- 술래 플레이어 정보 저장
local Time = 0
local endTime = 180
local playerCount

-- 시간을 분과 초로 변환하는 함수
local function formatTime(seconds)
	local minutes = math.floor(seconds / 60)
	local remainingSeconds = seconds % 60

	-- 시간 값을 00:00 형식으로 포맷
	local formattedTime = string.format("%02d:%02d", minutes, remainingSeconds)

	return formattedTime
end

local function setTimerScreenGui(player)
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then
		return
	end

	local timerScreenGui = playerGui:FindFirstChild("TimerScreenGui")
	if not timerScreenGui then
		return
	end

	local timeLabel = timerScreenGui:FindFirstChild("TimeLabel")
	if not timeLabel then
		return
	end

	timeLabel.Text = formatTime(Time)
	workspace.Time.Value = Time
end

local function unfreezePlayer(player)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
			humanoid.AutoRotate = true
			humanoid.WalkSpeed = 16
		end
	end
end

local taggerUnfreezed = false

local function increaseTime()
	Time = Time + 1
	-- 30초가 지나면 술래가 아닌 플레이어들의 이동속도 16에서 13으로 낮춤
	if taggerUnfreezed == false and Time >= workspace.WaitTime.Value then
		-- 30초가 지났으므로 술래도 움직이게 해줌
		unfreezePlayer(tagger)
		taggerUnfreezed = true
		print("얼음 땡")
		local playerList = Players:GetPlayers()
		for i, player in ipairs(playerList) do
			if(player ~= tagger) then
				player.Character.Humanoid.WalkSpeed = 13
			else
				-- 술래는 눈가리개를 invisible 해줌
			end
		end
	end
	if Time >= endTime + workspace.WaitTime.Value then
		if game.Workspace.CatchCount.Value < workspace.PlayerCount-1 then
			print("timeEndH")
			hiderWin:FireAllClients()
		else
			print("timeEndT")
			taggerWin:FireAllClients()
		end
	end
	workspace.Time.Value = Time
	-- 모든 접속한 플레이어에게 TimerScreenGui 업데이트
	for _, player in ipairs(game.Players:GetPlayers()) do
		setTimerScreenGui(player)
	end
end

local function freezePlayer(player)
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = true
			humanoid.AutoRotate = false
			humanoid.WalkSpeed = 0
			print("freeze player name "..tagger.Name)
		end
	end
end

local function waitForChildOfClass(parent, className)
	local child = parent:FindFirstChildOfClass(className)
	while not child do
		child = parent:FindFirstChildOfClass(className)
		print("대기중...")
		wait()
	end
	return child
end

local function startGame()
	print("인원이 다 모여서 게임이 시작됩니다!")
	print("game start!")
	playerCount = #Players:GetPlayers()
	--workspace.PlayerCount.Value = playerCount
	local randomIndex = math.random(1,playerCount)
	local randomPlayer = Players:GetPlayers()[randomIndex]
	print("술래는 "..randomPlayer.Name.."입니다!")
	tagger = randomPlayer
	
	-- <술래 플레이어 처리 부분>
	-- 1. 술래의 금고 삭제
	if tagger then
		workspace:WaitForChild(tagger.Name):WaitForChild("Safe"):Destroy()
		--tagger:WaitForChild("character"):WaitForChild("Captain"):Destroy()
		print("술래 금고 제거!")
	end
	
	local workspace = game:GetService("Workspace")
	
	local taggerName
	taggerName = workspace:FindFirstChild("TaggerName")
	if not taggerName then
		taggerName = Instance.new("StringValue")
	end
	taggerName.Name = "TaggerName"
	taggerName.Value = tagger.Name
	taggerName.Parent = workspace
	
	
	-- <술래가 아닌 플레이어들 처리 부분>
	-- 1. 술래가 아닌 플레이어들의 무기 없애기
	local playerList = Players:GetPlayers()

	--for i, player in ipairs(playerList) do
	--	if player ~= tagger then
	--		print(player.Name.."의 무기 제거")
	--		-- 플레이어의 손에 있는 ClassicSword 확인
	--		-- 에러남
	--		local tool = player.character:FindFirstChildOfClass("ClassicSword")
	--		-- 밑에 코드는 tool 받을때까지 계속 wait하면 받는 함수인데 무한 대기함, 존재 안한느 거 같음
	--		--local tool = waitForChildOfClass(player.character, "ClassicSword")
	--		if tool ~= nil and tool.Name == "ClassicSword" then
	--			-- ClassicSword를 손에서 제거
	--			tool.Parent = nil
	--			tool:Destroy()
	--			print("ClassicSword removed from player:", player.Name)
	--		else
	--			-- ClassicSword를 손에 들지 않았을 경우도 삭제
	--			local backpack = player:FindFirstChild("Backpack")
	--			if backpack ~= nil then
	--				local sword = backpack:FindFirstChild("ClassicSword")
	--				if sword then
	--					-- ClassicSword를 제거
	--					sword:Destroy()
	--					print("ClassicSword removed from player:", player.Name)
	--				end
	--			end
	--		end
	--	end
	--end

	-- 2. 술래 일시 정지
	freezePlayer(tagger)
	
	-- 시간 전역변수 만들기
	local Time
	if workspace.Time ~= nil then
		Time = Instance.new("IntValue")
	else
		Time = workspace.Time
	end
	
	Time.Name = "Time"
	Time.Value = Time
	Time.Parent = workspace
	
	-- 플레이어 숨기 시작하면서 타이머 시작
	for _, player in ipairs(game.Players:GetPlayers()) do
		setTimerScreenGui(player)
	end
	-- 1초마다 increaseTime 함수 실행
	while true do
		wait(1)
		increaseTime()
	end

end


-- 플레이어 접속 시 실행될 함수
local function onPlayerAdded(player)
	-- 현재 접속한 플레이어 수 확인
	local playerCount = #Players:GetPlayers()
	print(player.Name.." 입장!")
	if playerCount == maxPlayer then
		startGame()
	end
end


-- 플레이어 접속 및 접속 끊기 이벤트에 함수 연결
Players.PlayerAdded:Connect(onPlayerAdded)
