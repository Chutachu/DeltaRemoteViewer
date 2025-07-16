-- ✅ Delta RemoteEvent Viewer + Log + Input UI Split (Name + Jumlah)
-- 🔍 Bisa pilih remote, input argumen (nama item & jumlah), lihat log langsung di GUI

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaRemoteViewer"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Size = UDim2.new(0, 500, 0, 500)
holder.Position = UDim2.new(1, -510, 0.5, -250)
holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
holder.BorderSizePixel = 0
holder.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "📡 Delta Remote Viewer (UI Split + Log)"
title.TextScaled = true
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = holder

local searchBox = Instance.new("TextBox")
searchBox.PlaceholderText = "🔍 Search remote name..."
searchBox.Size = UDim2.new(1, -20, 0, 25)
searchBox.Position = UDim2.new(0, 10, 0, 35)
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
searchBox.Parent = holder

local itemBox = Instance.new("TextBox")
itemBox.PlaceholderText = "🧪 Nama item: 'GoldenEgg'"
itemBox.Size = UDim2.new(1, -20, 0, 25)
itemBox.Position = UDim2.new(0, 10, 0, 65)
itemBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
itemBox.TextColor3 = Color3.new(1, 1, 1)
itemBox.ClearTextOnFocus = false
itemBox.Text = ""
itemBox.Parent = holder

local jumlahBox = Instance.new("TextBox")
jumlahBox.PlaceholderText = "🔢 Jumlah / ID tambahan"
jumlahBox.Size = UDim2.new(1, -20, 0, 25)
jumlahBox.Position = UDim2.new(0, 10, 0, 95)
jumlahBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
jumlahBox.TextColor3 = Color3.new(1, 1, 1)
jumlahBox.ClearTextOnFocus = false
jumlahBox.Text = ""
jumlahBox.Parent = holder

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 0.5, -30)
scroll.Position = UDim2.new(0, 0, 0, 130)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
scroll.BorderSizePixel = 0
scroll.Parent = holder

local logBox = Instance.new("TextLabel")
logBox.Size = UDim2.new(1, -20, 0.5, -50)
logBox.Position = UDim2.new(0, 10, 0.5, 10)
logBox.Text = "[LOG]"
logBox.TextWrapped = true
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
logBox.TextColor3 = Color3.fromRGB(100, 255, 100)
logBox.Font = Enum.Font.Code
logBox.TextSize = 14
logBox.ClipsDescendants = true
logBox.Parent = holder

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

local allButtons = {}
local selectedRemote = nil

local function log(msg)
	logBox.Text = logBox.Text .. "\n" .. os.date("[%H:%M:%S] ") .. msg
end

local function fireSelectedRemote()
	if not selectedRemote or not selectedRemote.Instance then log("❌ Tidak ada Remote yang dipilih") return end
	local remote = selectedRemote.Instance
	local item = itemBox.Text
	local jumlah = tonumber(jumlahBox.Text) or jumlahBox.Text

	local success, err = pcall(function()
		if remote:IsA("RemoteEvent") then
			remote:FireServer(item, jumlah)
		elseif remote:IsA("RemoteFunction") then
			remote:InvokeServer(item, jumlah)
		end
	end)

	if success then
		log("✅ Fired " .. remote.Name .. " dengan argumen: " .. tostring(item) .. ", " .. tostring(jumlah))
	else
		log("❌ Gagal trigger: " .. tostring(err))
	end
end

local function createButton(v)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 25)
	btn.Text = v:GetFullName()
	btn.TextColor3 = Color3.fromRGB(0, 255, 0)
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Parent = scroll
	btn.MouseButton1Click:Connect(function()
		selectedRemote = {Instance = v}
		log("📌 Remote dipilih: " .. v:GetFullName())
	end)
	table.insert(allButtons, {button = btn, remote = v})
end

for _, v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		createButton(v)
	end
end

local function refreshButtons()
	local y = 5
	for _, data in pairs(allButtons) do
		local name = data.remote.Name:lower()
		local match = searchBox.Text == "" or name:find(searchBox.Text:lower())
		data.button.Visible = match
		if match then
			data.button.Position = UDim2.new(0, 5, 0, y)
			y += 28
		end
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, y + 5)
end

searchBox:GetPropertyChangedSignal("Text"):Connect(refreshButtons)
refreshButtons()

local fireBtn = Instance.new("TextButton")
fireBtn.Size = UDim2.new(0, 100, 0, 25)
fireBtn.Position = UDim2.new(0, 10, 1, -30)
fireBtn.Text = "🔥 Fire"
fireBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
fireBtn.TextColor3 = Color3.new(1, 1, 1)
fireBtn.Parent = holder
fireBtn.MouseButton1Click:Connect(fireSelectedRemote)

log("✅ GUI siap. Pilih Remote, isi item + jumlah, lalu klik 🔥 Fire")
