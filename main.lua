-- Moonhook Key System: call this after key validation
-- replace the URL with wherever you host this script
loadstring(game:HttpGet("https://yourcdn.com/mm2gui.lua"))()

-- === mm2gui.lua ===

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function createGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "MoonhookMM2GUI"
    gui.Parent = game.CoreGui

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0,500,0,400)
    main.Position = UDim2.new(0.5,-250,0.5,-200)
    main.BackgroundColor3 = Color3.fromRGB(18,18,18)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundTransparency = 1
    title.Text = "ars.red | 😍"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 22
    title.Parent = main

    -- Tabs
    local tabNames = {"Aimbot","Visuals","Misc","Settings"}
    local tabs = {}
    local tabButtons = Instance.new("Frame", main)
    tabButtons.Size = UDim2.new(1,0,0,30)
    tabButtons.Position = UDim2.new(0,0,0,30)
    tabButtons.BackgroundTransparency = 1

    for i,name in ipairs(tabNames) do
        local btn = Instance.new("TextButton")
        btn.Name = name.."Tab"
        btn.Size = UDim2.new(0.25,0,1,0)
        btn.Position = UDim2.new((i-1)*0.25,0,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
        btn.Text = name
        btn.TextColor3 = name=="Visuals" and Color3.new(1,0,0) or Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 18
        btn.Parent = tabButtons
        tabs[name] = btn
    end

    -- Container for content
    local container = Instance.new("Frame",main)
    container.Name = "Content"
    container.Position = UDim2.new(0,0,0,60)
    container.Size = UDim2.new(1,0,1,-90)
    container.BackgroundTransparency = 1

    local pages = {}
    -- create a page frame for each tab
    for _,name in ipairs(tabNames) do
        local page = Instance.new("Frame",container)
        page.Name = name.."Page"
        page.Size = UDim2.new(1,0,1,0)
        page.BackgroundTransparency = 1
        page.Visible = (name=="Visuals")
        pages[name] = page
    end

    -- function to switch tabs
    for name,btn in pairs(tabs) do
        btn.MouseButton1Click:Connect(function()
            for n,page in pairs(pages) do
                page.Visible = (n == name)
            end
            for n,b in pairs(tabs) do
                b.TextColor3 = (n == name) and Color3.new(1,0,0) or Color3.new(1,1,1)
            end
        end)
    end

    -- helper UI elements
    local function addToggle(page, text, pos, callback)
        local c = Instance.new("TextButton")
        c.Size = UDim2.new(0,0,0,25)
        c.Position = pos
        c.Text = "[ ] "..text
        c.TextColor3 = Color3.new(1,1,1)
        c.BackgroundColor3 = Color3.fromRGB(40,40,40)
        c.Font = Enum.Font.SourceSans
        c.TextSize = 16
        c.Parent = page
        local toggled = false
        c.MouseButton1Click:Connect(function()
            toggled = not toggled
            c.Text = (toggled and "[x] " or "[ ] ")..text
            callback(toggled)
        end)
    end

    local function addSlider(page, text, pos, min, max, init, callback)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0,0,0,20)
        lbl.Position = pos
        lbl.Text = text.." "..init
        lbl.TextColor3 = Color3.new(1,1,1)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.SourceSans
        lbl.TextSize = 14
        lbl.Parent = page

        local bar = Instance.new("Frame")
        bar.Position = pos + UDim2.new(0,0,0,20)
        bar.Size = UDim2.new(0,100,0,8)
        bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
        bar.Parent = page

        local handle = Instance.new("Frame")
        handle.Size = UDim2.new((init-min)/(max-min),0,1,0)
        handle.BackgroundColor3 = Color3.fromRGB(255,0,0)
        handle.Parent = bar

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local function update(posX)
                    local frac = math.clamp((posX - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
                    handle.Size = UDim2.new(frac,0,1,0)
                    local val = min + frac*(max-min)
                    lbl.Text = text.." "..math.floor(val)
                    callback(val)
                end
                update(input.Position.X)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then return end
                    update(input.Position.X)
                end)
            end
        end)
    end

    -- === Visuals page sample
    local vpage = pages["Visuals"]
    addToggle(vpage,"ESP: Murderer",UDim2.new(0,10,0,10),function(on)
        -- logic
    end)
    addToggle(vpage,"ESP: Sheriff",UDim2.new(0,10,0,40),function(on) end)
    addToggle(vpage,"ESP: All",    UDim2.new(0,10,0,70),function(on) end)
    addSlider(vpage,"ESP Distance",UDim2.new(0,300,0,10),0,2000,500,function(v) end)

    -- === Misc page sample
    local mpage = pages["Misc"]
    addToggle(mpage,"Walkspeed", UDim2.new(0,10,0,10),function(on)
        if on then LocalPlayer.Character.Humanoid.WalkSpeed = 50
        else LocalPlayer.Character.Humanoid.WalkSpeed = 16 end
    end)
    addSlider(mpage,"Speed",UDim2.new(0,200,0,10),16,100,50,function(v)
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end)
    addToggle(mpage,"Jumppower",UDim2.new(0,10,0,60),function(on)
        LocalPlayer.Character.Humanoid.JumpPower = on and 100 or 50
    end)
    addSlider(mpage,"Jump",UDim2.new(0,200,0,60),50,200,50,function(v)
        LocalPlayer.Character.Humanoid.JumpPower = v
    end)
    addToggle(mpage,"Godmode", UDim2.new(0,10,0,110),function(on) end)
    addToggle(mpage,"Btools", UDim2.new(0,10,0,140),function(on) end)
    addToggle(mpage,"Gun ESP", UDim2.new(0,10,0,170),function(on) end)
    addToggle(mpage,"Kill Aura (M)", UDim2.new(0,10,0,200),function(on) end)
    addToggle(mpage,"Kill All (M)", UDim2.new(0,10,0,230),function(on) end)
    addToggle(mpage,"Silent Aim (S)", UDim2.new(0,10,0,260),function(on) end)
    addToggle(mpage,"Grab Gun", UDim2.new(0,10,0,290),function(on) end)
    addToggle(mpage,"Xray", UDim2.new(0,10,0,320),function(on) end)
    addToggle(mpage,"XP & Coin AF", UDim2.new(0,10,0,350),function(on) end)

    -- Settings page: Discord link
    local spage = pages["Settings"]
    local dlink = Instance.new("TextLabel")
    dlink.Size = UDim2.new(1,0,0,30)
    dlink.Position = UDim2.new(0,0,1,-40)
    dlink.BackgroundTransparency = 1
    dlink.Text = "Discord: https://discord.gg/sEzR2fhP"
    dlink.TextColor3 = Color3.fromRGB(0,170,255)
    dlink.Font = Enum.Font.SourceSans
    dlink.TextSize = 18
    dlink.Parent = spage

    return gui
end

-- Launch
createGui()
