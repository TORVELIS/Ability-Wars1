local CoreGui = game.CoreGui
local PlaceId = game.PlaceId

-- global variables
getgenv().attach_to_nearest = false
getgenv().PlatformAdd = nil
getgenv().distance_from_target = -3

-- other lol

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
    local dist = 1000
    local targetroot = nil
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    
    for _,v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Name ~= game.Players.LocalPlayer.Name then
            if v.Character:FindFirstChild("HumanoidRootPart") then
                local target_Hrp = v.Character.HumanoidRootPart
                if target_Hrp and not inSafezone(v.Character) then
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
        if v.Name == "SpawnPlatformlol" or v.Name == "SpleefPlatformFuckerEzKidLoL" then
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

   end
end


-- threads
spawn(function()
    while true do
        task.wait()
        if getgenv().attach_to_nearest then
            game:GetService("ReplicatedStorage"):FindFirstChild("Remote Events").ActivateStarted:FireServer("Normal")
            AttachAndKill()
            task.wait(3)
        end
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
    Text = "Autofarm",
    Side = "Left"
})

Section2:Check({
    Text = "Attach to nearest",
    Callback = function(bool)
        getgenv().attach_to_nearest = bool
    end
 })

local Section3 = Tab2:Section({
    Text = "Other",
    Side = "Right"
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
            print("Arena not work yet lol")
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

Tab:Select()
