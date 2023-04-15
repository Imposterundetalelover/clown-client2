repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character

local clownclientArray = Instance.new("ScreenGui")
local InvisFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
clownclientArray.Name = "clownclientArray"
clownclientArray.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
clownclientArray.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
clownclientArray.ResetOnSpawn = false
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

function notify(name, desc, time1)
	game.StarterGui:SetCore("SendNotification", {
		Title = name;
		Text = desc;
		Duration = time1;
	})
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
		local function func2()
			func()
		end
		coroutine.wrap(func2)()
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
	SprintController = knit.Controllers["SprintController"],
	SwordController = knit.Controllers["SwordController"],
	GroundHit = game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit,
	Reach = require(game:GetService("ReplicatedStorage").TS.combat["combat-constant"]),
	Knockback = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1)
}

--rest of script ig

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("clownclient", "DarkTheme")

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
	local AuraEnabled = false
	CombatSection:NewToggle("KillAura", "attacks players around you.", function(enabled)
		if enabled then
			MakeModule("Aura")
			AuraEnabled = true
			repeat
				for i,v in pairs(game.Players:GetPlayers()) do
					if (v.Character) and (game.Players.LocalPlayer.Character) and v ~= game.Players.LocalPlayer then
						runcode(function()
							if (v.Character.PrimaryPart.Position - lplr.Character.PrimaryPart.Position).Magnitude < 14 and v.Character.Humanoid.health > 1 and lplr.Character.Humanoid.Health > 1 and v.Team ~= lplr.Team then
								events["SwordController"]:swingSwordAtMouse()
							end
						end)
					end
				end
				task.wait()
			until not AuraEnabled
		else
			AuraEnabled = false
			RemoveModule("Aura")
		end
	end)
end)

runcode(function()
	CombatSection:NewToggle("Velocity", "Allows you to not take knockback", function(enabled)
		if enabled then
			MakeModule("Velocity")
			events.Knockback.kbDirectionStrength = 0
			events.Knockback.kbUpwardStrength = 0
		else
			events.Knockback.kbDirectionStrength = 100
			events.Knockback.kbUpwardStrength = 100
			RemoveModule("Velocity")
		end
	end)
end)

runcode(function()
	CombatSection:NewToggle("Reach", "higher reach than legits ez momento", function(state)
		if state then
			MakeModule("Reach")
			events.Reach.RAYCAST_SWORD_CHARACTER_DISTANCE = 18
		else
			RemoveModule("Reach")
			events.Reach.RAYCAST_SWORD_CHARACTER_DISTANCE = 14
		end
	end)
end)

runcode(function()
	local isSprinting = false
	CombatSection:NewToggle("AutoSprint", "auto sprints for u", function(enabled)
		if enabled then
			MakeModule("AutoSprint")
			isSprinting = true
			repeat wait()
				if (not events.SprintController.sprinting) and hum.Health ~= 1 then
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
	runcode(function()
		pcall(function()
			repeat task.wait(0.49)
				if _G.LongjumpEnabled == true then
					if hum.Health ~= 1 then
						hum:ChangeState(3)
					end
				end
			until false
		end)
	end)
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
	runcode(function()
		repeat task.wait()
			pcall(function()
				if _G.HighjumpEnabled == true and hum.Health ~= 1 then
					hrp.CFrame = hrp.CFrame * CFrame.new(0, 30, 0)
				end
			end)
		until false
	end)
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
	runcode(function()
		repeat task.wait()
			pcall(function()
				if _G.FlightEnabled == true and hum.Health ~= 1 then
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
			end)
		until false
	end)
	MovementSection:NewKeybind("Flight - Bind", "coolio", Enum.KeyCode.R, function()
		_G.FlightEnabled = not _G.FlightEnabled
		if _G.FlightEnabled == true and hum.Health ~= 1 then
			prpart.Velocity = Vector3.new(0,0,0)
		end
		if _G.FlightEnabled == true and hum.Health ~= 1 then
			MakeModule("Flight")
		else
			RemoveModule("Flight")
		end
	end)	
end)

runcode(function()
	local nofallenabled = false
	MovementSection:NewToggle("NoFall", "allows for no fall damage", function(enabled)
		if enabled then
			MakeModule("NoFall")
			nofallenabled = true
			repeat
				game:GetService("ReplicatedStorage").rbxts_include.node_modules:FindFirstChild("@rbxts").net.out._NetManaged.GroundHit:FireServer()
				task.wait(0.25)
			until not nofallenabled
		else
			nofallenabled = false
			RemoveModule("NoFall")
		end
	end)	
end)

runcode(function()
	MovementSection:NewToggle("SlowFall", "makes u slow faller lol", function(state)
		if state then
			MakeModule("SlowFall")
			_G.SlowFallEnabled = true
			repeat
				if _G.SlowFallEnabled == true and hum.Health ~= 1 then
					if hum.FloorMaterial == Enum.Material.Air and hum.Health ~= 1 then
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
    MovementSection:NewToggle("FunnyFly", "not longer fly, made 4 fun xD.", function(state)
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
			clownclientLogo = Instance.new("ScreenGui")
			local Frame = Instance.new("Frame")
			local TextLabel = Instance.new("TextLabel")
			clownclientLogo.Name = "clownclientLogo"
			clownclientLogo.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
			clownclientLogo.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			clownclientLogo.ResetOnSpawn = false
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
			TextLabel.Text = "Private beta clownware"
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
	RenderSection:NewToggle("FemboyAmbient", "'My favorite module', -Spring67#2760", function(state)
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

--[[
runcode(function()
	local TeleportAmount1 = 15
	local AcBypassEnabled = false
	local AnticheatBypassSection = Player:NewSection("AnticheatBypass")
	AnticheatBypassSection:NewToggle("AnticheatBypass", "allows you to bypass the anticheat speed check", function(enabled)
		if enabled then
			local oldchar
			local clone
			oldchar = lplr.Character
			oldchar.Archivable = true
			clone = oldchar:Clone()
			oldchar.PrimaryPart.Anchored = false
			local humc = oldchar.Humanoid:Clone()
			humc.Parent = lplr.Character
			game:GetService("RunService").Stepped:connect(function()
				local mag = (clone.PrimaryPart.Position - oldchar.PrimaryPart.Position).Magnitude
				if mag >= 18 then
					oldchar:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame)
				end
			end)
			cam.CameraSubject = clone.Humanoid 
			clone.Parent = workspace
			lplr.Character = clone
			for _,v in pairs(lplr.Character:GetChildren()) do
				v.Transparency = 0.5
			end
		else
			lplr.Character.Humanoid.Health = 0
		end
	end)
	AnticheatBypass:NewTextBox("TeleportAmount", "recommended 14", function(TeleportAmount2)
		TeleportAmount1 = TeleportAmount2
	end)
end)
--]]

notify("Clownware Private", "Loaded clownware..", 3)
notify("Clownware Private", "If u want config dm genl private", 10)
notify("Clownware Private", "More modules and features soon", 5)
notify("Clownware Private", "pro", 10)
