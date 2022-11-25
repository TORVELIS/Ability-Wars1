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

Section3:Button({
    Text = "Add platforms",
    Callback = function()
        print("")
    end
})

Tab:Select()
