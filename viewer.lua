-- ✅ Delta RemoteEvent & Function Viewer + Logger (Tanpa Key)
-- 🧠 Versi mandiri mirip LimitHub, tapi tanpa sistem kunci
-- 📜 Menampilkan dan mencatat semua RemoteEvent/RemoteFunction yang diklik
-- 🧪 Disiapkan agar kamu bisa mengisi manual argumen trigger

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaRemoteViewer"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Size = UDim2.new(0, 500, 0, 300)
holder.Position = UDim2.new(1, -510, 0.5, -150)
holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
holder.BorderSizePixel = 0
holder.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "📡 Delta Remote Viewer"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = holder

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -60)
scroll.Position = UDim2.new(0, 0, 0, 35)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scroll.BorderSizePixel = 0
scroll.Parent = holder

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 100, 0, 25)
close.Position = UDim2.new(1, -110, 1, -30)
close.Text = "Hide"
close.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = holder

close.MouseButton1Click:Connect(function()
	holder.Visible = false
end)

local y = 5
local total = 0
local log = {}

local function logRemote(remotePath, callType)
	table.insert(log, callType .. ": game." .. remotePath .. "(...)\n")
	print("\n📥 Copied:", "game." .. remotePath .. (callType == "Event" and ":FireServer(...)" or ":InvokeServer(...)"))
	setclipboard("game." .. remotePath .. (callType == "Event" and ":FireServer(...)" or ":InvokeServer(...)"))
end

for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		total += 1
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 25)
		btn.Position = UDim2.new(0, 5, 0, y)
		btn.Text = v:GetFullName()
		btn.TextColor3 = Color3.fromRGB(0, 255, 0)
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.Parent = scroll

		btn.MouseButton1Click:Connect(function()
			if not v or not v.Parent then
				warn("⚠️ Remote tidak ditemukan.")
				return
			end
			logRemote(v:GetFullName(), v:IsA("RemoteEvent") and "Event" or "Function")
		end)
		y += 28
	end
end

scroll.CanvasSize = UDim2.new(0, 0, 0, y + 5)
print("✅ Loaded " .. total .. " Remote(s). Klik untuk copy & log trigger. Siapkan argumen manual di console.")
