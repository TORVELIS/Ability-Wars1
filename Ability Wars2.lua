local CoreGui = game.CoreGui
local PlaceId = game.PlaceId
local TeleportService = game:GetService("TeleportService")
-- global variables
getgenv().attach_to_nearest = false
getgenv().hitbox_extender = false
getgenv().visibleHMR = false
getgenv().PlatformAdd = nil
getgenv().distance_from_target = -3

-- other lol

local function RejoinGame()
   TeleportService:Teleport(PlaceId)
end

local function DestroyGui()
    CoreGui.PPHUD:Destroy()
end

if CoreGui:FindFirstChild("PPHUD") then
    DestroyGui()
end

if PlaceId ~= 8260276694 then
    game.Players.LocalPlayer:Kick("Wrong game")
end

local function inSafezone(char) -- returns true if player is in safezone, false if not
    if (char.HumanoidRootPart.Position - Vector3.new(70.7707, 257.81, -4.45903)).magnitude < 100 then
        return true
    end
    return false
end

function findNearestHrp()
    local dist = 2000
    local targetroot = nil
    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    for _,v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Name ~= game.Players.LocalPlayer.Name then
            if v.Character:FindFirstChild("HumanoidRootPart") then
                local target_Hrp = v.Character:FindFirstChild("HumanoidRootPart")
                if target_Hrp and not inSafezone(v.Character) and v.Character.Humanoid.Health > 0 then
                    local temp_dist = (hrp.Position - target_Hrp.Position).Magnitude
                    if temp_dist <= dist then
                        dist = temp_dist
                        targetroot = target_Hrp
                    end
                end
            end
        end
    end
    
    return targetroot -- returns target's hrp
end

local function Punch(char)
    local args = {
        [1] = char,
        [2] = Vector3.new(0,0,5),
        [3] = 1.25,
        [4] = char.Torso
    }
    game:GetService("ReplicatedStorage"):FindFirstChild("Remote Events").Punch:FireServer(unpack(args))
end

local function AttachAndKill()
    local target_hrp = findNearestHrp()
    if target_hrp then
        repeat
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target_hrp.CFrame + game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector * getgenv().distance_from_target
            Punch(target_hrp.Parent)
        until target_hrp.Parent.Humanoid.Health <= 0 or game.Players.LocalPlayer.Character.Humanoid.Health <= 0 or getgenv().attach_to_nearest == false
    end
end

local function RemovePlatforms()
    for _,v in pairs(game.Workspace:GetChildren()) do
        if v.Name == "SpawnPlatformlol" or v.Name == "SpleefPlatformFuckerEzKidLoL" or v.Name == "ArenaFuckShitLoLKillYourself" then
            v:Destroy()
        end
    end
end

local function PlatformOnSpawn(Selected)
   if Selected == "Spawn" then
       if Workspace:FindFirstChild("SpawnPlatformlol") then return end
       local Cl = game:GetService("Workspace").Main["Map Base"].Mainplate:Clone()
   
       Cl.Parent = game.Workspace
       Cl.Name = "SpawnPlatformlol"
       
       Cl.CFrame = Cl.CFrame * CFrame.new(Vector3.new(0,-50,0))
       Cl.Size = Vector3.new(1060,1,1060)
       Cl.Transparency = 0.5

   elseif Selected == "Spleef" then
      if Workspace:FindFirstChild("SpleefPlatformFuckerEzKidLoL") then return end
      local Cl = game:GetService("Workspace").Main["Map Base"].Mainplate:Clone()
      Cl.Parent = game.Workspace
      Cl.Name = "SpleefPlatformFuckerEzKidLoL"
      
      Cl.CFrame = Cl.CFrame * CFrame.new(Vector3.new(-19117.9746, -26.96139812, -57.5339622, -0.981866181, -7.51963753e-08, -0.189575449, -7.40857189e-08, 1, -1.29453523e-08, 0.189575449, 1.33422928e-09, -0.981866181))
      Cl.Size = Vector3.new(1060,1,1060)
      Cl.Transparency = 0.5

   elseif Selected == "Arena" then
      if Workspace:FindFirstChild("ArenaFuckShitLoLKillYourself") then return end
      local Cl = game:GetService("Workspace").Main["Map Base"].Mainplate:Clone()
      Cl.Parent = game.Workspace
      Cl.Name = "ArenaFuckShitLoLKillYourself"
      Cl.CFrame = Cl.CFrame * CFrame.new(Vector3.new(21713.9199, -22.11111111, 2.62695408, -0.00158537854, -1.06568841e-07, -0.999998748, 3.39828554e-10, 1, -1.06569516e-07, 0.999998748, -5.08781184e-10, -0.00158537854))
      Cl.Size = Vector3.new(1060,1,1060)
      Cl.Transparency = 0.5

   end
end

local function ExtendHMR()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            local target_char = v.Character
            if target_char then
                local target_hmr = target_char:FindFirstChild("HumanoidRootPart")
                if target_hmr then
                    target_hmr.Size = Vector3.new(20,20,20)
                    if getgenv().visibleHMR then
                        target_hmr.Transparency = 0.7
                        target_hmr.Color = Color3.fromRGB(255,0,0)
                    else
                        target_hmr.Transparency = 1
                    end
                end
            end
        end
    end
end

local function UnExtendHMR()
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            local target_char = v.Character
            if target_char then
                local target_hmr = target_char:FindFirstChild("HumanoidRootPart")
                if target_hmr then
                    target_hmr.Size = Vector3.new(2,2,1)
                    target_hmr.Transparency = 1
                end
            end
        end
    end
end

-- threads
spawn(function()
    while true do
        if getgenv().attach_to_nearest then
            game:GetService("ReplicatedStorage"):FindFirstChild("Remote Events").ActivateStarted:FireServer("Normal")
            AttachAndKill()
            task.wait(3)
        end
        task.wait(.5)
    end
end)

spawn(function()
    while true do
        if getgenv().hitbox_extender then
            ExtendHMR()
        else
            UnExtendHMR()
        end
        task.wait(0.5)
    end
end)

-- ui

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/TORVELIS/PPHub/main/Lib.lua'))()
local Flags = Library.Flags

local Window = Library:Window({
  Text = "Console"
})

local Tab = Window:Tab({
   Text = "Home"
})

local Section1 = Tab:Section({
    Text = "About",
    Side = "Left"
})

Section1:Label({
    Text = "Credits: nae & torvelis",
    Color = Color3.fromRGB(255,255,255)
})

Section1:Label({
    Text = "Menu Toggle: Right Control",
    Color = Color3.fromRGB(255,255,255)
})

Section1:Button({
   Text = "Copy Discord link",
   Callback = function()
       setclipboard("discord.gg/QzgbdcXYaP")
   end
})

Tab2 = Window:Tab({
    Text = "Main"
})

local Section2 = Tab2:Section({
    Text = "Main",
    Side = "Left"
})

Section2:Check({
    Text = "Attach to nearest (kick warning)",
    Callback = function(bool)
        getgenv().attach_to_nearest = bool
    end
 })

Section2:Slider({
   Text = "Distance from Target",
   Minimum = -10,
   Default = -3,
   Maximum = 10,
   Postfix = " Studs",
   Callback = function(S)
      getgenv().distance_from_target = S
   end
})

Section2:Label({
    Text = "",
    Color = Color3.fromRGB(255,255,255)
})

Section2:Check({
    Text = "Extended hitboxes",
    Callback = function(bool)
        getgenv().hitbox_extender = bool
    end
})

Section2:Check({
    Text = "Visible hitboxes",
    Callback = function(bool)
        getgenv().visibleHMR = bool
    end
})

local Section3 = Tab2:Section({
    Text = "Other",
    Side = "Right"
})

Section3:Slider({
    Text = "WalkSpeed",
    Minimum = 16,
    Default = 16,
    Maximum = 200,
    Callback = function(S)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = S
    end
})

Section3:Slider({
    Text = "JumpPower",
    Minimum = 50,
    Default = 50,
    Maximum = 200,
    Callback = function(S)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = S
    end
})

Section3:Label({
Text = ""
})

Section3:Dropdown({
    Text = "Platform",
    List = {"Arena Platform", "Spawn Platform", "Spleef Platform"},
    Callback = function(Platform)
        getgenv().PlatformAdd = Platform
    end
})

Section3:Button({
    Text = "Add Platform",
    Callback = function()
        if getgenv().PlatformAdd == "Arena Platform" then
         PlatformOnSpawn("Arena")
        elseif getgenv().PlatformAdd == "Spawn Platform" then
            PlatformOnSpawn("Spawn")
        elseif getgenv().PlatformAdd == "Spleef Platform" then
            PlatformOnSpawn("Spleef")
        end
    end
})

Section3:Button({
    Text = "Remove Platforms",
    Callback = RemovePlatforms
})


local tab3 = Window:Tab({
   Text = "Misc",
})


local Section4 = tab3:Section({
   Text = "Main",
   Side = "Left",
})

Section4:Label({
   Text = ""
})

Section4:Button({
   Text = "Rejoin",
   Callback = RejoinGame

})

Section4:Button({
   Text = "Unload GUI",
   Callback = DestroyGui

})
local Section5 = tab3:Section({
   Text = "Visuals",
   Side = "Right",
})

Tab:Select()
