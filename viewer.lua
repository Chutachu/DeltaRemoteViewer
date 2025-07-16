-- Modul dump untuk melihat isi argumen
local function dump(tbl)
	if typeof(tbl) ~= "table" then return tostring(tbl) end
	local str = "{ "
	for k, v in pairs(tbl) do
		str = str .. tostring(k) .. " = " .. dump(v) .. ", "
	end
	return str .. "}"
end

-- Parent UI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "RemoteScannerUI"

-- Scrolling container
local scroll = Instance.new("ScrollingFrame", screenGui)
scroll.Size = UDim2.new(0, 400, 0, 300)
scroll.Position = UDim2.new(0, 100, 0, 100)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scroll.BorderSizePixel = 0
scroll.Name = "RemoteScroll"

-- UIList untuk menyusun tombol
local layout = Instance.new("UIListLayout", scroll)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)

-- Scan semua RemoteEvent & RemoteFunction di ReplicatedStorage.GameEvents
local folder = game:GetService("ReplicatedStorage"):FindFirstChild("GameEvents")
if folder then
	for _, remote in pairs(folder:GetDescendants()) do
		if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 30)
			button.Text = remote.Name
			button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
			button.Parent = scroll
			button.AutoButtonColor = true
			button.TextScaled = true
			button.Font = Enum.Font.Gotham

			-- ON CLICK: Coba jalankan dengan contoh args
			button.MouseButton1Click:Connect(function()
				local args = { Zone = "BugEggZone", ForceUnlock = true }
				print("🧪 Trigger:", remote.Name, "Args:", dump(args))

				if remote:IsA("RemoteEvent") then
					remote:FireServer(args)
				elseif remote:IsA("RemoteFunction") then
					local result = remote:InvokeServer(args)
					print("📦 Invoke Result:", dump(result))
				end
			end)
		end
	end
end
