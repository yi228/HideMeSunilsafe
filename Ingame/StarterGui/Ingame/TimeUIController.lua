local timeLabel = script.Parent

-- 폰트와 크기 설정
timeLabel.Font = Enum.Font.Gotham
timeLabel.FontSize = Enum.FontSize.Size36

-- 텍스트 색상 설정
timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 흰색

-- 배경 색상 설정
timeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 검은색
timeLabel.BackgroundTransparency = 0.5 -- 반투명도 조정

-- 테두리 설정
timeLabel.BorderSizePixel = 2
timeLabel.BorderColor3 = Color3.fromRGB(255, 0, 0) -- 빨간색

-- 텍스트 정렬 설정
timeLabel.TextXAlignment = Enum.TextXAlignment.Center
timeLabel.TextYAlignment = Enum.TextYAlignment.Center

timeLabel.LayoutOrder = 100
