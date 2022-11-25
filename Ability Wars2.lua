local CoreGui = game.CoreGui
local PlaceId = game.PlaceId

if PlaceId ~= 8260276694 then
    game.Players.LocalPlayer:Kick("Wrong game")
end

local function DestroyGui()
    CoreGui.PPHUD:Destroy()
end

if CoreGui:FindFirstChild("PPHUD") then
    DestroyGui()
end

local function PlatformOnSpawn(Selected)
   if Selected == "Spawn" then
       local Cl = game:GetService("Workspace").Main["Map Base"].Mainplate:Clone()
   
       Cl.Parent = game.Workspace
       Cl.Name = "SpawnPlatformlol"
       
       Cl.CFrame = Cl.CFrame * CFrame.new(Vector3.new(0,-50,0))
       Cl.Size = Vector3.new(1060,1,1060)
       Cl.Transparency = 0.5

   elseif Selected == "Spleef" then
      local Cl = game:GetService("Workspace").Main["Map Base"].Mainplate:Clone()
      Cl.Parent = game.Workspace
      Cl.Name = "SpleefPlatformFuckerEzKidLoL"
      
      Cl.CFrame = Cl.CFrame * CFrame.new(Vector3.new(-19117.9746, -26.96139812, -57.5339622, -0.981866181, -7.51963753e-08, -0.189575449, -7.40857189e-08, 1, -1.29453523e-08, 0.189575449, 1.33422928e-09, -0.981866181))
      Cl.Size = Vector3.new(1060,1,1060)
      Cl.Transparency = 0.5

   end
end


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
    Text = "Menu Toggle: Left Alt",
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
       warn(bool)
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
    print("Arena added")
    elseif getgenv().PlatformAdd == "Spawn Platform" then
      PlatformOnSpawn("Spawn")
    elseif getgenv().PlatformAdd == "Spleef Platform" then
      PlatformOnSpawn("Spleef")
    
    end
end
})
Tab:Select()
