-- ✅ Delta RemoteEvent Viewer + Auto Test Delay-Safe + Remote Listener (Delay 2 Detik + Toggleable)
-- 🔒 Kompatibel dengan Delta (tidak kena kick), delay auto test 2 detik, UI ringan + listener untuk lihat argumen

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaSafeViewer"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.5, -5, 1, -65)
leftPanel.Position = UDim2.new(0, 5, 0, 35)
leftPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
leftPanel.Parent = mainFrame

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.5, -5, 1, -65)
rightPanel.Position = UDim2.new(0.5, 5, 0, 35)
rightPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
rightPanel.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "📡 Delta Remote Viewer (Safe + Listener Mode)"
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
searchBox.PlaceholderText = "🔍 Cari remote..."
searchBox.Size = UDim2.new(1, -10, 0, 25)
searchBox.Position = UDim2.new(0, 5, 0, 5)
searchBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
searchBox.Parent = leftPanel

local scrollLeft = Instance.new("ScrollingFrame")
scrollLeft.Size = UDim2.new(1, -10, 1, -100)
scrollLeft.Position = UDim2.new(0, 5, 0, 35)
scrollLeft.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollLeft.ScrollBarThickness = 4
scrollLeft.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollLeft.BorderSizePixel = 0
scrollLeft.Parent = leftPanel

local testBtn = Instance.new("TextButton")
testBtn.Size = UDim2.new(0.5, -7, 0, 25)
testBtn.Position = UDim2.new(0, 5, 1, -60)
testBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
testBtn.Text = "🔁 Mulai Auto Test"
testBtn.TextColor3 = Color3.new(1, 1, 1)
testBtn.Parent = leftPanel

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.5, -7, 0, 25)
stopBtn.Position = UDim2.new(0.5, 2, 1, -60)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.Text = "⛔ Stop Auto Test"
stopBtn.TextColor3 = Color3.new(1, 1, 1)
stopBtn.Parent = leftPanel

local input1 = Instance.new("TextBox")
input1.PlaceholderText = "Argumen 1 (contoh: \"GoldenEgg\" / {a=1})"
input1.Size = UDim2.new(1, -10, 0, 25)
input1.Position = UDim2.new(0, 5, 0, 5)
input1.BackgroundColor3 = Color3.fromRGB(20,20,20)
input1.TextColor3 = Color3.new(1,1,1)
input1.Text = ""
input1.ClearTextOnFocus = false
input1.Parent = rightPanel

local input2 = Instance.new("TextBox")
input2.PlaceholderText = "Argumen 2 (opsional)"
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
scrollRight.CanvasSize = UDim2.new(0, 1000, 0, 0)
scrollRight.ScrollingDirection = Enum.ScrollingDirection.XY
scrollRight.ScrollBarThickness = 4
scrollRight.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scrollRight.BorderSizePixel = 0
scrollRight.Parent = rightPanel

local yLeft, yRight = 5, 5
local selectedRemote = nil
local allButtons, remotesList = {}, {}
local isTesting = false

local function parse(str)
	local f = loadstring("return " .. str)
	if f then local s,r = pcall(f); if s then return r end end
	return str
end

local function logRight(text)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 10, 0, 20)
	lbl.AutomaticSize = Enum.AutomaticSize.X
	lbl.Position = UDim2.new(0, 5, 0, yRight)
	lbl.BackgroundTransparency = 1
	lbl.Text = os.date("[%H:%M:%S] ") .. text
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextWrapped = false
	lbl.Parent = scrollRight
	yRight += 22
	scrollRight.CanvasSize = UDim2.new(0, 1000, 0, yRight + 30)
end

local function fireRemote(v)
	logRight("🧪 Firing: " .. v:GetFullName())
	local a1, a2 = parse(input1.Text), parse(input2.Text)
	local ok, err = pcall(function()
		v:FireServer(a1, a2)
	end)
	if ok then
		logRight("✅ Success: " .. v.Name)
	else
		logRight("❌ Error: " .. tostring(err))
	end
end

local function createBtn(v)
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
		logRight("➡️ Dipilih: " .. v:GetFullName())
		fireRemote(v)
	end)
	yLeft += 28
	scrollLeft.CanvasSize = UDim2.new(0, 0, 0, yLeft)
	table.insert(allButtons, {button = btn, remote = v})
	table.insert(remotesList, v)
end

for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		createBtn(v)
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	yLeft = 5
	for _, data in ipairs(allButtons) do
		local match = searchBox.Text == "" or data.remote.Name:lower():find(searchBox.Text:lower())
		data.button.Visible = match
		if match then
			data.button.Position = UDim2.new(0, 5, 0, yLeft)
			yLeft += 28
		end
	end
	scrollLeft.CanvasSize = UDim2.new(0, 0, 0, yLeft)
end)

testBtn.MouseButton1Click:Connect(function()
	if isTesting then return end
	isTesting = true
	logRight("🔁 Mulai Auto Test Delay: " .. #remotesList .. " remotes (2s)")
	spawn(function()
		for _, r in ipairs(remotesList) do
			if not isTesting then break end
			pcall(function()
				r:FireServer("Auto", true)
				logRight("✅ Fired: " .. r:GetFullName())
			end)
			task.wait(2)
		end
		logRight("🏁 Auto Test selesai!")
		isTesting = false
	end)
end)

stopBtn.MouseButton1Click:Connect(function()
	isTesting = false
	logRight("⛔ Auto Test dihentikan manual.")
end)

-- 🔍 Remote Listener: deteksi FireServer asli dari game
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if tostring(method) == "FireServer" and typeof(self) == "Instance" then
		logRight("📡 Detected: " .. self:GetFullName())
		local args = {...}
		for i,v in ipairs(args) do
			logRight("  Arg ["..i.."]: " .. tostring(v))
		end
	end
	return old(self, ...)
end)
setreadonly(mt, true)

logRight("✅ GUI + Remote Listener aktif. Klik remote atau gunakan fitur.")
