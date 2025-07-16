-- 📡 Delta-Compatible RemoteEvent Viewer GUI (LimitHub-style)
-- ✅ Scroll, Click to log FireServer/InvokeServer, Hide GUI
-- 🧠 Tanpa elemen berat, kompatibel untuk executor ringan

local plr = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "RemoteEventDeltaViewer"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 450, 0, 300)
main.Position = UDim2.new(1, -460, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "📡 Remote Viewer (Delta Style)"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(40,40,40)
title.TextScaled = true

local scroll = Instance.new("ScrollingFrame", main)
scroll.Position = UDim2.new(0,0,0,30)
scroll.Size = UDim2.new(1, 0, 1, -60)
scroll.BackgroundColor3 = Color3.fromRGB(20,20,20)
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 4

local close = Instance.new("TextButton", main)
close.Text = "Hide"
close.Size = UDim2.new(0, 80, 0, 25)
close.Position = UDim2.new(1, -85, 1, -30)
close.BackgroundColor3 = Color3.fromRGB(80,0,0)
close.TextColor3 = Color3.new(1,1,1)

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

local y = 5
local count = 0

for _,v in ipairs(game:GetDescendants()) do
	if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
		count += 1
		local b = Instance.new("TextButton", scroll)
		b.Size = UDim2.new(1, -10, 0, 25)
		b.Position = UDim2.new(0, 5, 0, y)
		b.Text = v:GetFullName()
		b.TextColor3 = Color3.fromRGB(0,255,0)
		b.TextXAlignment = Enum.TextXAlignment.Left
		b.BackgroundColor3 = Color3.fromRGB(35,35,35)

		b.MouseButton1Click:Connect(function()
			if not v or not v.Parent then
				warn("⚠️ Remote hilang.")
				return
			end
			print("🔹 Trigger manual:")
			if v:IsA("RemoteEvent") then
				print("game." .. v:GetFullName() .. ":FireServer(--[[ args ]])")
			else
				print("game." .. v:GetFullName() .. ":InvokeServer(--[[ args ]])")
			end
		end)
		y += 28
	end
end

scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)
print("✅ Viewer Loaded - Total:", count)
