-- 클라이언트 스크립트 (LocalScript)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local qPressed = false


-- Q를 누를 때 동작하는 함수
local function onKeyPress(input)
	if input.KeyCode == Enum.KeyCode.Q  then
		qPressed = not qPressed
		if qPressed then
			-- 서버에 Q를 눌렀음을 알립니다.
			game.ReplicatedStorage.QPressed:FireServer()
		end
	end
end

-- Q 키 입력 감지
UserInputService.InputBegan:Connect(onKeyPress)

