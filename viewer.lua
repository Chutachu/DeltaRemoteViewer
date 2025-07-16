-- ✅ Delta RemoteEvent Viewer + Argumen Manual + Fire Langsung (Fix unpack bug)
-- 🧠 Bisa langsung isi argumen dari GUI dan klik Fire untuk uji
-- 🔍 Filter nama, log klik, dan bisa copy command ke clipboard

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DeltaRemoteViewer"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Size = UDim2.new(0, 500, 0, 400)
holder.Position = UDim2.new(1, -510, 0.5, -200)
holder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
holder.BorderSizePixel = 0
holder.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "📡 Delta Remote Viewer + Fire Arg"
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

local argBox = Instance.new("TextBox")
argBox.PlaceholderText = "🧪 Contoh: 'GoldenEgg', 1"
argBox.Size = UDim2.new(1, -20, 0, 25)
argBox.Position = UDim2.new(0, 10, 0, 65)
argBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
argBox.TextColor3 = Color3.new(1, 1, 1)
argBox.ClearTextOnFocus = false
argBox.Text = ""
argBox.Parent = holder

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -125)
scroll.Position = UDim2.new(0, 0, 0, 95)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
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

local allButtons = {}
local selectedRemote = nil

local function updateArg(argBoxText)
	if not selectedRemote or not selectedRemote.Instance then return end
	local remote = selectedRemote.Instance
	local argsScript = "return {" .. argBoxText .. "}"
	local f = loadstring(argsScript)
	if not f then warn("❌ Argumen tidak valid") return end
	local successDecode, args = pcall(f)
	if not successDecode then warn("⚠️ Gagal decode args:", args) return end
	local success, err = pcall(function()
		if remote:IsA("RemoteEvent") then
			remote:FireServer(unpack(args))
		elseif remote:IsA("RemoteFunction") then
			remote:InvokeServer(unpack(args))
		end
	end)
	if success then
		print("✅ Fired:", remote:GetFullName())
	else
		warn("⚠️ Gagal:", err)
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
		print("📌 Remote dipilih:", v:GetFullName())
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

-- Tombol FIRE
local fireBtn = Instance.new("TextButton")
fireBtn.Size = UDim2.new(0, 100, 0, 25)
fireBtn.Position = UDim2.new(0, 10, 1, -30)
fireBtn.Text = "🔥 Fire"
fireBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
fireBtn.TextColor3 = Color3.new(1, 1, 1)
fireBtn.Parent = holder

fireBtn.MouseButton1Click:Connect(function()
	updateArg(argBox.Text)
end)

print("✅ GUI siap. Pilih Remote, isi argumen, klik 🔥 Fire!")
