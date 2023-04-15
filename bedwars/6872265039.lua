repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character


local clownclientArray = Instance.new("ScreenGui")
local InvisFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
clownclient.Name = "MoonArray"
clownclient.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
clownclient.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
clownclient.ResetOnSpawn = false
InvisFrame.Name = "InvisFrame"
InvisFrame.Parent = clownclientArray
InvisFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InvisFrame.BackgroundTransparency = 1.000
InvisFrame.BorderSizePixel = 0
InvisFrame.Position = UDim2.new(0.84584707, 0, 0, 0)
InvisFrame.Size = UDim2.new(0, 232, 0, 379)
UIListLayout.Parent = InvisFrame
UIListLayout.SortOrder = Enum.SortOrder.Name

function MakeModule(name)
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Parent = InvisFrame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(0, 200, 0, 50)
	TextLabel.Font = Enum.Font.Merriweather
	TextLabel.Text = name 
	TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
	TextLabel.TextSize = 25
	TextLabel.TextStrokeTransparency = 0
	TextLabel.Name = name
end
function RemoveModule(name)
	if InvisFrame:FindFirstChild(name) then
		InvisFrame:FindFirstChild(name):Remove()
	end
end

--Enabled

_G.LongjumpEnabled = false
_G.HighjumpEnabled = false
_G.FlightEnabled = false
_G.SlowFallEnabled = false

--functions and locals

local lplr = game.Players.LocalPlayer
local char = lplr.Character
local hum = char.Humanoid
local hrp = char.HumanoidRootPart
local prpart = char.PrimaryPart
local uis = game:GetService("UserInputService")
local lighting = game.Lighting

function runcode(func)
	pcall(function()
		func()
	end)
end
function Chat(msg)
	local args = { [1] = msg, [2] = "All" }
	game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(unpack(args))
end

local knitRecieved, knit
knitRecieved, knit = pcall(function()
	repeat task.wait()
		return debug.getupvalue(require(game:GetService("Players")[game.Players.LocalPlayer.Name].PlayerScripts.TS.knit).setup, 6)
	until knitRecieved
end)

local events = {
	SprintController = knit.Controllers["SprintController"]
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Clownclient", "DarkTheme")

local Combat = Window:NewTab("Combat")
local Movement = Window:NewTab("Movement")
local Render = Window:NewTab("Render")
local Misc = Window:NewTab("Misc")
local Exploits = Window:NewTab("Exploits")

local CombatSection = Combat:NewSection("KillAura")
local MovementSection = Movement:NewSection("Movement")
local RenderSection = Render:NewSection("Render")
local MiscSection = Misc:NewSection("Misc")
local ExploitsSection = Exploits:NewSection("Exploits")

runcode(function()
	local isSprinting = false
	CombatSection:NewToggle("AutoSprint", "auto sprints for u", function(enabled)
		if enabled then
			MakeModule("AutoSprint")
			isSprinting = true
			repeat wait()
				if (not events.SprintController.sprinting) then
					events.SprintController:startSprinting()
				end
			until not isSprinting
		else
			isSprinting = false
			RemoveModule("AutoSprint")
		end
	end)
end)

runcode(function()
	local SpeedRepeat = false
	local You = lplr.Name
	local speed1 = 0.06
	MovementSection:NewToggle("Speed", "cframe mode 1!1!1", function(enabled)
		if enabled then
			MakeModule("Speed")
			SpeedRepeat = true
			repeat wait()
				if uis:IsKeyDown(Enum.KeyCode.W) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,-speed1)
				end;
				if uis:IsKeyDown(Enum.KeyCode.A) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(-speed1,0,0)
				end;
				if uis:IsKeyDown(Enum.KeyCode.S) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(0,0,speed1)
				end;
				if uis:IsKeyDown(Enum.KeyCode.D) then
					game:GetService("Workspace")[You].HumanoidRootPart.CFrame = game:GetService("Workspace")[You].HumanoidRootPart.CFrame * CFrame.new(speed1,0,0)
				end;
			until not SpeedRepeat
		else
			SpeedRepeat = false
			RemoveModule("Speed")
		end
	end)
	MovementSection:NewTextBox("SpeedAmount1", "recommended 0.06", function(speed2)
		speed1 = speed2
	end)
end)

runcode(function()
	local function LongjumpToggleKey()
		repeat task.wait()
			if _G.LongjumpEnabled == true then
				if hum.FloorMaterial ~= Enum.Material.Air then
					hum:ChangeState(3)
				end
			end
		until false
	end
	coroutine.wrap(LongjumpToggleKey)()
	MovementSection:NewKeybind("Longjump - Bind", "very long jump fr", Enum.KeyCode.J, function()
		_G.LongjumpEnabled = not _G.LongjumpEnabled
		if _G.LongjumpEnabled == true then
			MakeModule("Longjump")
		else
			RemoveModule("Longjump")
		end
	end)	
end)

runcode(function()
	local function HighjumpToggleKey()
		repeat task.wait()
			if _G.HighjumpEnabled == true then
				hrp.CFrame = hrp.CFrame * CFrame.new(0, 30, 0)
			end
		until false
	end
	coroutine.wrap(HighjumpToggleKey)()
	MovementSection:NewKeybind("Highjump - Bind", "very high jump fr", Enum.KeyCode.H, function()
		_G.HighjumpEnabled = not _G.HighjumpEnabled
		if _G.HighjumpEnabled == true then
			MakeModule("Highjump")
		else
			RemoveModule("Highjump")
		end
	end)	
end)

runcode(function()
	local function FlightToggleKey()
		repeat task.wait()
			if _G.FlightEnabled == true then
				game.Workspace.Gravity = 0
				if uis:IsKeyDown(Enum.KeyCode.Space) then
					prpart.CFrame += Vector3.new(0, 0.7, 0)
				end
				if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
					prpart.CFrame += Vector3.new(0, -0.7, 0)
				end
			else
				game.Workspace.Gravity = 196.2
			end
		until false
	end
	coroutine.wrap(FlightToggleKey)()
	MovementSection:NewKeybind("Flight - Bind", "coolio", Enum.KeyCode.R, function()
		_G.FlightEnabled = not _G.FlightEnabled
		if _G.FlightEnabled == true then
			prpart.Velocity = Vector3.new(0,0,0)
		end
		if _G.FlightEnabled == true then
			MakeModule("Flight")
		else
			RemoveModule("Flight")
		end
	end)	
end)

runcode(function()
	MovementSection:NewToggle("SlowFall", "makes u slow faller lol", function(state)
		if state then
			MakeModule("SlowFall")
			_G.SlowFallEnabled = true
			repeat
				if _G.SlowFallEnabled == true then
					if hum.FloorMaterial == Enum.Material.Air then
						lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.PrimaryPart.Velocity.X,2,lplr.Character.PrimaryPart.Velocity.Z)
					end
				end
				task.wait(0.4)
			until false
		else
			_G.SlowFallEnabled = false
			RemoveModule("SlowFall")
		end
	end)
end)

--[[
runcode(function()
    local FunnyFlyTog = false
    MovementSection:NewToggle("FunnyFly", "not longer fly, made 4 fun xD. Also if u wanna use this, get rid of the code that hides this XD", function(state)
        if state then
            FunnyFlyTog = true
            game.Workspace.Gravity = 4
            repeat
                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                task.wait()
                lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0)
                task.wait()
            until not FunnyFlyTog
        else
            game.Workspace.Gravity = 196.2
            FunnyFlyTog = false
        end
    end)
end)
--]]

runcode(function()
	local clownclientLogo
	RenderSection:NewToggle("Logo", "", function(state)
		if state then
			MakeModule("Logo")
			MoonLogo = Instance.new("ScreenGui")
			local Frame = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			MoonLogo.Name = "clownclientLogo"
			MoonLogo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			MoonLogo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			MoonLogo.ResetOnSpawn = false
			Frame.Parent = clownclientLogo
			Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BackgroundTransparency = 0.500
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Position = UDim2.new(0.007, 0, 0.012, 0)
			Frame.Size = UDim2.new(0, 261, 0, 44)
			TextLabel.Parent = Frame
			TextLabel.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
			TextLabel.BackgroundTransparency = 1.000
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.BorderSizePixel = 0
			TextLabel.Position = UDim2.new(0.11, 0, 0.1, 0)
			TextLabel.Size = UDim2.new(0, 200, 0, 33)
			TextLabel.Font = Enum.Font.SourceSans
			TextLabel.Text = "Private beta clownclient"
			TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextSize = 30.000
			TextLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.TextStrokeTransparency = 0.200
		else
			clownclientLogo:Remove()
			RemoveModule("Logo")
		end
	end)
end)

runcode(function()
	RenderSection:NewToggle("FemboyAmbient", "'why did i make this', -genl", function(state)
		if state then
			MakeModule("FemboyAmbient")
			lighting.Ambient = Color3.fromRGB(255, 85, 255)
			lighting.OutdoorAmbient = Color3.fromRGB(255, 85, 255)
			lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
			lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
			lighting.EnvironmentDiffuseScale = 0
		else
			lighting.Ambient = Color3.fromRGB(91, 91, 91)
			lighting.OutdoorAmbient = Color3.fromRGB(201, 201, 201)
			lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
			lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
			lighting.EnvironmentDiffuseScale = 1
			RemoveModule("FemboyAmbient")
		end
	end)
end)

runcode(function()
	RenderSection:NewButton("Chams", "lets u see plrs through walls", function()
		MakeModule("Chams")
		local players = game.Players:GetPlayers()
		for i,v in pairs(players) do
			local esp = Instance.new("Highlight")
			esp.Name = v.Name
			esp.FillTransparency = 0.5
			esp.FillColor = Color3.new(0.462745, 0, 0.462745)
			esp.OutlineColor = Color3.new(0.462745, 0, 0.462745)
			esp.OutlineTransparency = 0
			esp.Parent = v.Character
		end
		game.Players.PlayerAdded:Connect(function(plr)
			plr.CharacterAdded:Connect(function(chr)
				local esp = Instance.new("Highlight")
				esp.Name = plr.Name
				esp.FillTransparency = 0.5
				esp.FillColor = Color3.new(0.462745, 0, 0.462745)
				esp.OutlineColor = Color3.new(0.462745, 0, 0.462745)
				esp.OutlineTransparency = 0
				esp.Parent = chr
			end)
		end)
	end)
end)

runcode(function()
	RenderSection:NewButton("ESP", "dead", function()
		MakeModule("ESP")
		local body
		local gui = Instance.new("BillboardGui");
		gui.Name = "names";
		gui.AlwaysOnTop = true;
		gui.LightInfluence = 0;
		gui.Size = UDim2.new(1.75, 0, 1.75, 0);
		local frame = Instance.new("Frame", gui);
		frame.BackgroundColor3 = Color3.fromRGB(170, 0, 0);
		frame.Size = UDim2.new(1.7, 0, 3.89, 0);
		frame.BorderSizePixel = 4;
		frame.BorderColor3 = Color3.fromRGB(0, 0, 0);
		local gi = gui:Clone();
		body = frame:Clone();
		body.Parent = gi;
		body.BackgroundColor3 = Color3.fromRGB(0, 170, 170);
		for _, v in pairs(game:GetService("Players"):GetPlayers()) do
			if v.Name ~= lplr.Name and v.Character and v.Character:FindFirstChild("Head") then
				gui:Clone().Parent = v.Character.Head;
			end
		end
	end)
end)

runcode(function()
	RenderSection:NewKeybind("ToggleUi", "toggles ui lol", Enum.KeyCode.RightShift, function()
		Library:ToggleUI()
	end)
end)
