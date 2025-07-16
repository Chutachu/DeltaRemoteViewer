-- ✅ Delta RemoteEvent Viewer + Argumen UI + Log + Egg Scanner UI (vFinal)
-- 🔍 Versi UI modern minimalis kiri-kanan, input argumen, scroll log, dan FireServer test

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaRemoteViewer"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.5, -5, 1, -40)
leftPanel.Position = UDim2.new(0, 5, 0, 35)
leftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
leftPanel.Parent = mainFrame

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.5, -5, 1, -40)
rightPanel.Position = UDim2.new(0.5, 5, 0, 35)
rightPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
rightPanel.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "🔍 Delta Remote Viewer UI"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = mainFrame

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 80, 0, 25)
close.Position = UDim2.new(1, -85, 0, 2)
close.Text = "Hide"
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = mainFrame
close.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

local searchBox = Instance.new("TextBox")
searchBox.PlaceholderText = "🔍 Search remote name..."
searchBox.Size = UDim2.new(1, -10, 0, 25)
searchBox.Position = UDim2.new(0, 5, 0, 5)
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
searchBox.Parent = leftPanel

local scrollLeft = Instance.new("ScrollingFrame")
scrollLeft.Size = UDim2.new(1, -10, 1, -35)
scrollLeft.Position = UDim2.new(0, 5, 0, 35)
scrollLeft.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollLeft.ScrollBarThickness = 4
scrollLeft.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollLeft.BorderSizePixel = 0
scrollLeft.Parent = leftPanel

local input1 = Instance.new("TextBox")
input1.PlaceholderText = "Argumen 1 (contoh: GoldenEgg)"
input1.Size = UDim2.new(1, -10, 0, 25)
input1.Position = UDim2.new(0, 5, 0, 5)
input1.BackgroundColor3 = Color3.fromRGB(20,20,20)
input1.TextColor3 = Color3.new(1,1,1)
input1.Text = ""
input1.ClearTextOnFocus = false
input1.Parent = rightPanel

local input2 = Instance.new("TextBox")
input2.PlaceholderText = "Argumen 2 (contoh: 1)"
input2.Size = UDim2.new(1, -10, 0, 25)
input2.Position = UDim2.new(0, 5, 0, 35)
input2.BackgroundColor3 = Color3.fromRGB(20,20,20)
input2.TextColor3 = Color3.new(1,1,1)
input2.Text = ""
input2.ClearTextOnFocus = false
input2.Parent = rightPanel

local scrollRight = Instance.new("ScrollingFrame")
scrollRight.Size = UDim2.new(1, -10, 1, -70)
scrollRight.Position = UDim2.new(0, 5, 0, 65)
scrollRight.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollRight.ScrollBarThickness = 4
scrollRight.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollRight.ScrollBarInset = Enum.ScrollBarInset.ScrollBar
scrollRight.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scrollRight.BorderSizePixel = 0
scrollRight.Parent = rightPanel

local allButtons = {}
local selectedRemote = nil
local yLeft = 5
local yRight = 5

local function logRight(msg)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0, 5, 0, yRight)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Text = os.date("[%H:%M:%S] ") .. msg
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = scrollRight
	yRight += 22
	scrollRight.CanvasSize = UDim2.new(0, 0, 0, yRight + 30)
end

local function fireRemote(v)
	logRight("🔧 Fire attempt: " .. v:GetFullName())
	local success, err = pcall(function()
		v:FireServer(input1.Text, tonumber(input2.Text), true)
	end)
	if success then
		logRight("✅ Success: " .. v.Name)
	else
		logRight("❌ Failed: " .. tostring(err))
	end
end

local function createButton(v)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 25)
	btn.Position = UDim2.new(0, 5, 0, yLeft)
	btn.Text = v:GetFullName()
	btn.TextColor3 = Color3.fromRGB(0, 255, 0)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Parent = scrollLeft
	btn.MouseButton1Click:Connect(function()
		selectedRemote = v
		logRight("📌 Selected: " .. v:GetFullName())
		fireRemote(v)
	end)
	yLeft += 28
	scrollLeft.CanvasSize = UDim2.new(0, 0, 0, yLeft)
	table.insert(allButtons, {button = btn, remote = v})
end

for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		createButton(v)
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	yLeft = 5
	for _, data in ipairs(allButtons) do
		local name = data.remote.Name:lower()
		local match = searchBox.Text == "" or name:find(searchBox.Text:lower())
		data.button.Visible = match
		if match then
			data.button.Position = UDim2.new(0, 5, 0, yLeft)
			yLeft += 28
		end
	end
	scrollLeft.CanvasSize = UDim2.new(0, 0, 0, yLeft)
end)

logRight("✅ UI Initialized. Klik remote untuk tes trigger dan lihat log di kanan.")
