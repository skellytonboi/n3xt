--[[  ENI'S SCRIPT HUB  v8.2
      Key: ADMIN  |  MM2 full Syniox-style  |  others = placeholder  ]]

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TS         = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting   = game:GetService("Lighting")
local Camera     = workspace.CurrentCamera
local LP         = Players.LocalPlayer

local T = {
    BG        = Color3.fromRGB(8,8,12),
    CARD      = Color3.fromRGB(13,11,22),
    SIDEBAR   = Color3.fromRGB(16,13,26),
    CONTENT   = Color3.fromRGB(11,9,18),
    CC        = Color3.fromRGB(17,14,28),
    NEON      = Color3.fromRGB(140,255,0),
    CYAN      = Color3.fromRGB(0,180,255),
    TEXT      = Color3.fromRGB(225,222,240),
    DIM       = Color3.fromRGB(135,130,162),
    FAINT     = Color3.fromRGB(75,70,100),
    SEL       = Color3.fromRGB(26,22,42),
    BORDER    = Color3.fromRGB(40,34,66),
    POFF      = Color3.fromRGB(45,42,62),
    BAR       = Color3.fromRGB(20,16,32),
    GRID      = Color3.fromRGB(40,28,70),
    VERIFY    = Color3.fromRGB(128,255,0),
}

local function GetParent()
    if gethui then local ok,h=pcall(gethui);if ok then return h end end
    local ok=pcall(function() return game:GetService("CoreGui").Name end)
    if ok then return game:GetService("CoreGui") end
    return LP:WaitForChild("PlayerGui")
end

local SG = Instance.new("ScreenGui")
SG.Name="ENI_HUB";SG.ResetOnSpawn=false;SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;SG.Parent=GetParent()
if syn and syn.protect_gui then pcall(syn.protect_gui,SG) end

local function Notif(t,m) pcall(function() StarterGui:SetCore("SendNotification",{Title=t,Text=m,Duration=2.5}) end) end

local function MkGrid(par,w,h)
    local g=Instance.new("Frame",par);g.Size=UDim2.fromOffset(w,h);g.BackgroundTransparency=1;g.ClipsDescendants=true;g.ZIndex=0
    for x=0,math.floor(w/28) do local f=Instance.new("Frame",g);f.Size=UDim2.new(0,1,1,0);f.Position=UDim2.fromOffset(x*28,0);f.BackgroundColor3=T.GRID;f.BackgroundTransparency=0.86;f.BorderSizePixel=0;f.ZIndex=0 end
    for y=0,math.floor(h/28) do local f=Instance.new("Frame",g);f.Size=UDim2.new(1,0,0,1);f.Position=UDim2.fromOffset(0,y*28);f.BackgroundColor3=T.GRID;f.BackgroundTransparency=0.86;f.BorderSizePixel=0;f.ZIndex=0 end
end

-- ═══════════════════════════════════════════════════
-- KEY SCREEN  (image 1 style)
-- ═══════════════════════════════════════════════════
local function BuildKeyScreen(onSuccess)
    local ks=Instance.new("Frame",SG);ks.Size=UDim2.fromScale(1,1);ks.BackgroundColor3=T.BG;ks.BorderSizePixel=0;ks.ZIndex=1
    MkGrid(ks,1920,1080)
    for _,sz in ipairs({UDim2.fromOffset(560,430),UDim2.fromOffset(516,396)}) do
        local a=Instance.new("Frame",ks);a.AnchorPoint=Vector2.new(0.5,0.5);a.Position=UDim2.fromScale(0.5,0.5);a.Size=sz;a.BackgroundColor3=T.NEON;a.BackgroundTransparency=0.85;a.BorderSizePixel=0;a.ZIndex=2;Instance.new("UICorner",a).CornerRadius=UDim.new(0,22)
    end
    local card=Instance.new("Frame",ks);card.AnchorPoint=Vector2.new(0.5,0.5);card.Position=UDim2.fromScale(0.5,0.5);card.Size=UDim2.fromOffset(476,372);card.BackgroundColor3=T.CARD;card.BorderSizePixel=0;card.ZIndex=3
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,16)
    local stk=Instance.new("UIStroke",card);stk.Color=T.NEON;stk.Thickness=2.2;stk.Transparency=0.06

    local title=Instance.new("TextLabel",card);title.Position=UDim2.fromOffset(0,24);title.Size=UDim2.new(1,0,0,46);title.BackgroundTransparency=1;title.Font=Enum.Font.GothamBlack;title.Text="🔥  ENI'S SCRIPT HUB  🔥";title.TextColor3=T.NEON;title.TextScaled=true;title.ZIndex=4
    Instance.new("UITextSizeConstraint",title).MaxTextSize=30

    local pbt=Instance.new("Frame",card);pbt.Position=UDim2.new(0,28,0,84);pbt.Size=UDim2.new(1,-56,0,3);pbt.BackgroundColor3=Color3.fromRGB(26,22,42);pbt.BorderSizePixel=0;pbt.ZIndex=4;Instance.new("UICorner",pbt).CornerRadius=UDim.new(1,0)
    local pbf=Instance.new("Frame",pbt);pbf.Size=UDim2.new(0.28,0,1,0);pbf.BackgroundColor3=T.CYAN;pbf.BorderSizePixel=0;Instance.new("UICorner",pbf).CornerRadius=UDim.new(1,0)

    local lbl=Instance.new("TextLabel",card);lbl.Position=UDim2.new(0,28,0,100);lbl.Size=UDim2.new(1,-56,0,22);lbl.BackgroundTransparency=1;lbl.Font=Enum.Font.GothamMedium;lbl.Text="Enter your key here...";lbl.TextColor3=T.CYAN;lbl.TextSize=14;lbl.TextXAlignment=Enum.TextXAlignment.Left;lbl.ZIndex=4

    local kfr=Instance.new("Frame",card);kfr.Position=UDim2.new(0,28,0,124);kfr.Size=UDim2.new(1,-56,0,42);kfr.BackgroundColor3=Color3.fromRGB(8,8,14);kfr.BorderSizePixel=0;kfr.ZIndex=4
    Instance.new("UICorner",kfr).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",kfr).Color=T.CYAN
    local ktb=Instance.new("TextBox",kfr);ktb.Position=UDim2.fromOffset(10,0);ktb.Size=UDim2.new(1,-20,1,0);ktb.BackgroundTransparency=1;ktb.Font=Enum.Font.Code;ktb.Text="";ktb.TextColor3=T.CYAN;ktb.TextSize=15;ktb.ClearTextOnFocus=false;ktb.PlaceholderText="Enter key...";ktb.PlaceholderColor3=Color3.fromRGB(50,80,110);ktb.ZIndex=5

    local errL=Instance.new("TextLabel",card);errL.Position=UDim2.new(0,28,0,170);errL.Size=UDim2.new(1,-56,0,16);errL.BackgroundTransparency=1;errL.Font=Enum.Font.Gotham;errL.Text="";errL.TextColor3=Color3.fromRGB(255,80,80);errL.TextSize=12;errL.TextXAlignment=Enum.TextXAlignment.Left;errL.ZIndex=4

    local vbtn=Instance.new("TextButton",card);vbtn.Position=UDim2.new(0,28,0,192);vbtn.Size=UDim2.new(1,-56,0,48);vbtn.BackgroundColor3=T.VERIFY;vbtn.BorderSizePixel=0;vbtn.Font=Enum.Font.GothamBold;vbtn.Text="🔒  VERIFY KEY";vbtn.TextColor3=Color3.fromRGB(5,5,10);vbtn.TextSize=17;vbtn.ZIndex=4;vbtn.AutoButtonColor=true
    Instance.new("UICorner",vbtn).CornerRadius=UDim.new(0,10)

    local brow=Instance.new("Frame",card);brow.Position=UDim2.new(0,28,0,255);brow.Size=UDim2.new(1,-56,0,40);brow.BackgroundTransparency=1;brow.ZIndex=4
    local blay=Instance.new("UIListLayout",brow);blay.FillDirection=Enum.FillDirection.Horizontal;blay.HorizontalAlignment=Enum.HorizontalAlignment.Center;blay.Padding=UDim.new(0,10);blay.SortOrder=Enum.SortOrder.LayoutOrder
    for _,lx in ipairs({"JOIN DISCORD","GET KEY","OUR LINKS"}) do
        local b=Instance.new("TextButton",brow);b.Size=UDim2.fromOffset(118,36);b.BackgroundColor3=Color3.fromRGB(22,18,36);b.BorderSizePixel=0;b.Font=Enum.Font.GothamBold;b.Text=lx;b.TextColor3=T.DIM;b.TextSize=11;b.ZIndex=5;b.AutoButtonColor=true
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",b).Color=T.BORDER
        b.MouseButton1Click:Connect(function() end)
    end
    local ft=Instance.new("TextLabel",card);ft.Position=UDim2.new(0,28,0,310);ft.Size=UDim2.new(1,-56,0,14);ft.BackgroundTransparency=1;ft.Font=Enum.Font.Gotham;ft.Text="🔥 ENI Hub Agreement | byENI";ft.TextColor3=T.FAINT;ft.TextSize=10;ft.ZIndex=4

    task.delay(0.3,function() TS:Create(pbf,TweenInfo.new(0.9,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0.28,0,1,0)}):Play() end)

    local function tryVerify()
        local inp=ktb.Text:upper():gsub("%s","")
        if inp=="ADMIN" then
            errL.Text=""
            TS:Create(vbtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(180,255,80)}):Play()
            TS:Create(stk,TweenInfo.new(0.12),{Color=Color3.fromRGB(200,255,100)}):Play()
            TS:Create(pbf,TweenInfo.new(0.55,Enum.EasingStyle.Quad),{Size=UDim2.new(1,0,1,0)}):Play()
            task.wait(0.65)
            TS:Create(ks,TweenInfo.new(0.38),{BackgroundTransparency=1}):Play()
            task.wait(0.4);ks:Destroy();onSuccess()
        else
            errL.Text="✗  Invalid key. Try again."
            TS:Create(kfr,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(40,8,8)}):Play()
            task.wait(0.3);TS:Create(kfr,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(8,8,14)}):Play()
        end
    end
    vbtn.MouseButton1Click:Connect(tryVerify)
    ktb.FocusLost:Connect(function(ep) if ep then tryVerify() end end)
end

-- ═══════════════════════════════════════════════════
-- SCRIPT SELECTOR  (Syniox image 1 left/right style)
-- ═══════════════════════════════════════════════════
local function BuildScriptSelector(onSelect)
    local sel=Instance.new("Frame",SG);sel.Size=UDim2.fromScale(1,1);sel.BackgroundColor3=T.BG;sel.BorderSizePixel=0;sel.ZIndex=1
    MkGrid(sel,1920,1080)

    local outer=Instance.new("Frame",sel);outer.AnchorPoint=Vector2.new(0.5,0.5);outer.Position=UDim2.fromScale(0.5,0.5);outer.Size=UDim2.fromOffset(720,440);outer.BackgroundColor3=T.CARD;outer.BorderSizePixel=0;outer.ZIndex=2
    Instance.new("UICorner",outer).CornerRadius=UDim.new(0,14)
    local outerStk=Instance.new("UIStroke",outer);outerStk.Color=T.NEON;outerStk.Thickness=2;outerStk.Transparency=0.12

    -- LEFT panel
    local LW=268
    local left=Instance.new("Frame",outer);left.Size=UDim2.fromOffset(LW,440);left.BackgroundColor3=Color3.fromRGB(10,8,18);left.BorderSizePixel=0;left.ZIndex=3
    Instance.new("UICorner",left).CornerRadius=UDim.new(0,14)
    local lfix=Instance.new("Frame",left);lfix.Position=UDim2.fromOffset(LW-14,0);lfix.Size=UDim2.fromOffset(14,440);lfix.BackgroundColor3=Color3.fromRGB(10,8,18);lfix.BorderSizePixel=0;lfix.ZIndex=3

    local htl=Instance.new("TextLabel",left);htl.Position=UDim2.fromOffset(16,16);htl.Size=UDim2.new(1,-32,0,26);htl.BackgroundTransparency=1;htl.Font=Enum.Font.GothamBlack;htl.Text="🔥 ENI'S SCRIPT HUB 🔥";htl.TextColor3=T.NEON;htl.TextSize=14;htl.TextXAlignment=Enum.TextXAlignment.Left;htl.ZIndex=4
    local hdiv=Instance.new("Frame",left);hdiv.Position=UDim2.fromOffset(16,46);hdiv.Size=UDim2.new(1,-32,0,2);hdiv.BackgroundColor3=T.NEON;hdiv.BorderSizePixel=0;hdiv.ZIndex=4;Instance.new("UICorner",hdiv).CornerRadius=UDim.new(1,0)

    local feats={{"👑","Nice, You're In!"},{"✨","You're a Pro"},{"⚡","Pick Your Script"},{"🏆","Dominate the Game"},{"💎","Exclusive Access"},{"🔥","Made for Winners"}}
    local lSc=Instance.new("ScrollingFrame",left);lSc.Position=UDim2.fromOffset(0,54);lSc.Size=UDim2.new(1,0,1,-80);lSc.BackgroundTransparency=1;lSc.BorderSizePixel=0;lSc.ScrollBarThickness=0;lSc.ZIndex=4;lSc.CanvasSize=UDim2.new(0,0,0,0);lSc.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local lLy=Instance.new("UIListLayout",lSc);lLy.Padding=UDim.new(0,2);lLy.SortOrder=Enum.SortOrder.LayoutOrder
    local lPd=Instance.new("UIPadding",lSc);lPd.PaddingLeft=UDim.new(0,14);lPd.PaddingTop=UDim.new(0,4)
    for _,f in ipairs(feats) do
        local fr=Instance.new("Frame",lSc);fr.Size=UDim2.new(1,0,0,38);fr.BackgroundTransparency=1
        local ico=Instance.new("TextLabel",fr);ico.Position=UDim2.fromOffset(0,0);ico.Size=UDim2.fromOffset(26,38);ico.BackgroundTransparency=1;ico.Text=f[1];ico.TextSize=16;ico.TextColor3=T.NEON
        local lt=Instance.new("TextLabel",fr);lt.Position=UDim2.fromOffset(30,0);lt.Size=UDim2.new(1,-36,1,0);lt.BackgroundTransparency=1;lt.Font=Enum.Font.Gotham;lt.Text=f[2];lt.TextColor3=T.TEXT;lt.TextSize=13;lt.TextXAlignment=Enum.TextXAlignment.Left
    end
    local attr=Instance.new("TextLabel",left);attr.AnchorPoint=Vector2.new(0,1);attr.Position=UDim2.new(0,14,1,-8);attr.Size=UDim2.new(1,-28,0,16);attr.BackgroundTransparency=1;attr.Font=Enum.Font.Gotham;attr.Text="🔥 ENI Hub Agreement | byENI";attr.TextColor3=T.FAINT;attr.TextSize=10;attr.TextXAlignment=Enum.TextXAlignment.Left;attr.ZIndex=4

    -- RIGHT panel
    local right=Instance.new("Frame",outer);right.Position=UDim2.fromOffset(LW,0);right.Size=UDim2.new(1,-LW,1,0);right.BackgroundColor3=T.CONTENT;right.BorderSizePixel=0;right.ZIndex=3
    Instance.new("UICorner",right).CornerRadius=UDim.new(0,14)
    local rfix=Instance.new("Frame",right);rfix.Size=UDim2.fromOffset(14,440);rfix.BackgroundColor3=T.CONTENT;rfix.BorderSizePixel=0;rfix.ZIndex=3

    local rth=Instance.new("Frame",right);rth.Size=UDim2.new(1,0,0,44);rth.BackgroundColor3=Color3.fromRGB(12,10,20);rth.BorderSizePixel=0;rth.ZIndex=4
    local rib=Instance.new("TextLabel",rth);rib.Position=UDim2.fromOffset(14,0);rib.Size=UDim2.new(1,-28,1,0);rib.BackgroundTransparency=1;rib.Font=Enum.Font.GothamBlack;rib.Text="  🚀  SELECT SCRIPT  🚀";rib.TextColor3=T.TEXT;rib.TextSize=14;rib.TextXAlignment=Enum.TextXAlignment.Left;rib.ZIndex=5

    local srf=Instance.new("Frame",right);srf.Position=UDim2.fromOffset(12,50);srf.Size=UDim2.new(1,-24,0,32);srf.BackgroundColor3=Color3.fromRGB(14,12,24);srf.BorderSizePixel=0;srf.ZIndex=4
    Instance.new("UICorner",srf).CornerRadius=UDim.new(0,8);Instance.new("UIStroke",srf).Color=T.BORDER
    local srIco=Instance.new("TextLabel",srf);srIco.Position=UDim2.fromOffset(6,0);srIco.Size=UDim2.fromOffset(22,32);srIco.BackgroundTransparency=1;srIco.Text="🔍";srIco.TextSize=13;srIco.ZIndex=5
    local stb=Instance.new("TextBox",srf);stb.Position=UDim2.fromOffset(26,0);stb.Size=UDim2.new(1,-34,1,0);stb.BackgroundTransparency=1;stb.Font=Enum.Font.Gotham;stb.Text="";stb.TextColor3=T.TEXT;stb.TextSize=13;stb.PlaceholderText="Search game...";stb.PlaceholderColor3=T.DIM;stb.ClearTextOnFocus=false;stb.ZIndex=5

    local GAMES={
        {ico="🔪",name="Murder Mystery 2", ready=true},
        {ico="🌴",name="Blox Fruits",       ready=false},
        {ico="🔫",name="Arsenal",            ready=false},
        {ico="🌊",name="Escape The Tsunami", ready=false},
        {ico="🎹",name="Keyboard Escape",    ready=false},
        {ico="🥚",name="Steal an Egg",       ready=false},
        {ico="🎮",name="Rivals",             ready=false},
    }

    local gSc=Instance.new("ScrollingFrame",right);gSc.Position=UDim2.fromOffset(0,90);gSc.Size=UDim2.new(1,0,1,-90);gSc.BackgroundTransparency=1;gSc.BorderSizePixel=0;gSc.ScrollBarThickness=3;gSc.ScrollBarImageColor3=T.NEON;gSc.CanvasSize=UDim2.new(0,0,0,0);gSc.AutomaticCanvasSize=Enum.AutomaticSize.Y;gSc.ZIndex=4
    local gLy=Instance.new("UIListLayout",gSc);gLy.Padding=UDim.new(0,5);gLy.SortOrder=Enum.SortOrder.LayoutOrder
    local gPd=Instance.new("UIPadding",gSc);gPd.PaddingLeft=UDim.new(0,12);gPd.PaddingRight=UDim.new(0,12);gPd.PaddingTop=UDim.new(0,6);gPd.PaddingBottom=UDim.new(0,10)

    local gBtns={}
    for i,g in ipairs(GAMES) do
        local gb=Instance.new("TextButton",gSc);gb.Size=UDim2.new(1,0,0,42);gb.BackgroundColor3=Color3.fromRGB(16,13,28);gb.BorderSizePixel=0;gb.Text="";gb.ZIndex=5;gb.AutoButtonColor=false;gb.LayoutOrder=i
        Instance.new("UICorner",gb).CornerRadius=UDim.new(0,8)
        local gbStk=Instance.new("UIStroke",gb);gbStk.Color=g.ready and T.NEON or T.BORDER;gbStk.Thickness=g.ready and 1.5 or 1
        local gico=Instance.new("TextLabel",gb);gico.Position=UDim2.fromOffset(10,0);gico.Size=UDim2.fromOffset(28,42);gico.BackgroundTransparency=1;gico.Text=g.ico;gico.TextSize=18;gico.ZIndex=6
        local gnm=Instance.new("TextLabel",gb);gnm.Position=UDim2.fromOffset(42,0);gnm.Size=UDim2.new(1,-100,1,0);gnm.BackgroundTransparency=1;gnm.Font=Enum.Font.GothamMedium;gnm.Text=g.name;gnm.TextColor3=g.ready and T.TEXT or T.DIM;gnm.TextSize=14;gnm.TextXAlignment=Enum.TextXAlignment.Left;gnm.ZIndex=6
        if not g.ready then
            local cs=Instance.new("TextLabel",gb);cs.AnchorPoint=Vector2.new(1,0.5);cs.Position=UDim2.new(1,-10,0.5,0);cs.Size=UDim2.fromOffset(88,22);cs.BackgroundColor3=Color3.fromRGB(26,20,42);cs.BorderSizePixel=0;cs.Font=Enum.Font.GothamBold;cs.Text="Coming Soon";cs.TextColor3=T.FAINT;cs.TextSize=10;cs.ZIndex=6;Instance.new("UICorner",cs).CornerRadius=UDim.new(0,6)
        end
        gBtns[g.name]=gb
        gb.MouseEnter:Connect(function() TS:Create(gb,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(22,18,40)}):Play() end)
        gb.MouseLeave:Connect(function() TS:Create(gb,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(16,13,28)}):Play() end)
        gb.MouseButton1Click:Connect(function()
            if not g.ready then Notif("ENI Hub",g.name.." — Coming Soon! 🔜");return end
            TS:Create(gb,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(30,26,52)}):Play()
            task.wait(0.15)
            TS:Create(sel,TweenInfo.new(0.35),{BackgroundTransparency=1}):Play()
            task.wait(0.38);sel:Destroy();onSelect(g)
        end)
    end
    stb:GetPropertyChangedSignal("Text"):Connect(function()
        local t=stb.Text:lower()
        for nm,gb in pairs(gBtns) do gb.Visible=t=="" or nm:lower():find(t,1,true)~=nil end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════
-- MM2 HUB  v5  —  full Syniox sidebar layout, our purple/neon theme
-- ═══════════════════════════════════════════════════════════════════════
local function LaunchMM2()
    local ST={
        coinFarm=false,autoReset=false,antiAFK=false,
        murdESP=true,sheriffESP=true,innocESP=false,
        aimOn=false,aimFOV=180,aimStr=0.18,showFOV=false,
        noclip=false,invisible=false,infJump=false,
        selectedPlayer=nil,playerList={},
    }
    local COL={Murderer=Color3.fromRGB(230,55,55),Sheriff=Color3.fromRGB(75,155,255),Innocent=Color3.fromRGB(75,215,100)}
    local RPS=game:GetService("ReplicatedStorage")

    -- Role detection
    local KP={"knife","blade","dark","seer","chroma","godly","elder","shadow","luger","corrupt","shard","ice","wood","rainbow"}
    local GP={"gun","sheriff","revolver","deagle","pistol"}
    local function mA(n,p) n=n:lower();for _,v in ipairs(p) do if n:find(v,1,true) then return true end end;return false end
    local function sT(c) if not c then return nil end;for _,o in ipairs(c:GetChildren()) do if o:IsA("Tool") then if mA(o.Name,KP) then return "Murderer" end;if mA(o.Name,GP) then return "Sheriff" end end end;return nil end
    local function dR(p)
        local ch=p.Character;local bp=p:FindFirstChild("Backpack")
        local r=ch and sT(ch);if r then return r end;r=sT(bp);if r then return r end
        for _,loc in ipairs({p,ch}) do if loc then local rv=loc:FindFirstChild("Role");if rv and rv:IsA("StringValue") and rv.Value~="" then return rv.Value end end end
        return "Innocent"
    end
    local function gM() for _,p in ipairs(Players:GetPlayers()) do if p~=LP and dR(p)=="Murderer" then return p end end end
    local function gS() for _,p in ipairs(Players:GetPlayers()) do if p~=LP and dR(p)=="Sheriff"   then return p end end end

    -- ESP
    local HL={}
    local function mHL(p)
        local role=dR(p)
        local show=(role=="Murderer" and ST.murdESP) or (role=="Sheriff" and ST.sheriffESP) or (role=="Innocent" and ST.innocESP)
        if not show then if HL[p] then HL[p]:Destroy();HL[p]=nil end;return end
        local ch=p.Character;if not ch then return end;if HL[p] then HL[p]:Destroy() end
        local h=Instance.new("Highlight");h.FillColor=COL[role] or COL.Innocent;h.OutlineColor=COL[role] or COL.Innocent;h.FillTransparency=0.45;h.OutlineTransparency=0;h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;h.Adornee=ch;h.Parent=ch;HL[p]=h
    end
    local espT=0
    RunService.Heartbeat:Connect(function(dt) espT=espT+dt;if espT<0.5 then return end;espT=0;for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then mHL(p) end end end)
    Players.PlayerRemoving:Connect(function(p) if HL[p] then HL[p]:Destroy();HL[p]=nil end end)

    -- Aimbot — mousemoverel ONLY, camera stays free, no Scriptable lock
    local fovObj=nil
    local function bFOV()
        if not(typeof(Drawing)=="table") then return end
        if fovObj then pcall(function() fovObj:Remove() end) end
        local ok,c=pcall(function() local ci=Drawing.new("Circle");ci.Radius=ST.aimFOV;ci.Color=T.NEON;ci.Thickness=1.5;ci.Filled=false;ci.Visible=false;return ci end)
        if ok then fovObj=c end
    end
    RunService.RenderStepped:Connect(function()
        if fovObj then fovObj.Visible=ST.aimOn and ST.showFOV;if fovObj.Visible then fovObj.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2) end end
        if not ST.aimOn then return end
        local m=gM();if not m or not m.Character then return end
        local head=m.Character:FindFirstChild("Head");if not head then return end
        local sp,on=Camera:WorldToViewportPoint(head.Position);if not on then return end
        local centre=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)
        local sv=Vector2.new(sp.X,sp.Y)
        if(sv-centre).Magnitude>ST.aimFOV then return end
        if mousemoverel then local d=sv-centre;pcall(mousemoverel,d.X*ST.aimStr,d.Y*ST.aimStr) end
    end)

    -- Kill remotes
    local KN={"KillPlayer","Kill","Damage","DamagePlayer","Stab","Shoot","Hit","Attack","DamageHumanoid","ApplyDamage","KillCharacter","Murder","KillTarget"}
    local function bK(tgt)
        if not tgt then return end;local ch=tgt.Character;local hm=ch and ch:FindFirstChildOfClass("Humanoid");if not hm then return end
        local function tr(obj)
            if not(obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then return end
            local nm=obj.Name:lower();local ok=false;for _,n in ipairs(KN) do if nm==n:lower() then ok=true;break end end;if not ok then return end
            for _,s in ipairs({{tgt},{tgt,hm},{ch,hm},{hm},{hm,9999}}) do if obj:IsA("RemoteEvent") then pcall(function() obj:FireServer(unpack(s)) end) else pcall(function() obj:InvokeServer(unpack(s)) end) end end
        end
        for _,o in ipairs(RPS:GetDescendants()) do tr(o) end;for _,o in ipairs(workspace:GetDescendants()) do tr(o) end
    end

    -- Noclip
    local dP={};local ls=0
    RunService.Heartbeat:Connect(function()
        if not ST.noclip then for p in pairs(dP) do if p.Parent then p.CanCollide=true end end;dP={};return end
        local n=tick();if n-ls<2.5 then return end;ls=n
        for p in pairs(dP) do if p.Parent then p.CanCollide=true end end;dP={}
        for _,p in ipairs(workspace:GetDescendants()) do if p:IsA("BasePart") and p.Anchored and p.CanCollide and p.Name~="Baseplate" and p.Size.Magnitude<500 then p.CanCollide=false;dP[p]=true end end
        local char=LP.Character;if char then for _,p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end end end
    end)

    -- Invisible
    local invOT,invLM={},{}
    local function applyInv(char)
        if not char then return end
        for _,p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then if invOT[p]==nil then invOT[p]=p.Transparency;invLM[p]=p.LocalTransparencyModifier end;p.Transparency=1;p.LocalTransparencyModifier=1;p.CanCollide=false;p.CanTouch=false
            elseif p:IsA("Decal") or p:IsA("Texture") then if invOT[p]==nil then invOT[p]=p.Transparency end;p.Transparency=1 end
        end
    end
    local function restoreInv(char)
        if not char then return end
        for inst,tv in pairs(invOT) do pcall(function() if inst.Parent then inst.Transparency=tv;if inst:IsA("BasePart") and invLM[inst] then inst.LocalTransparencyModifier=invLM[inst];inst.CanCollide=true;inst.CanTouch=true end end end) end
        invOT,invLM={},{}
    end

    -- Inf jump
    UIS.JumpRequest:Connect(function()
        if not ST.infJump then return end
        local char=LP.Character;if not char then return end
        local hm=char:FindFirstChildOfClass("Humanoid");if hm and hm:GetState()~=Enum.HumanoidStateType.Dead then hm:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)

    -- Auto coin farm
    RunService.Heartbeat:Connect(function()
        if not ST.coinFarm then return end
        local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");if not hrp then return end
        local nearest,nearDist=nil,math.huge
        for _,obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                local nm=obj.Name:lower()
                if nm:find("coin",1,true) or(obj.BrickColor==BrickColor.new("Bright yellow") and obj.Size.Magnitude<2) then
                    local d=(obj.Position-hrp.Position).Magnitude;if d<nearDist then nearDist=d;nearest=obj end
                end
            end
        end
        if nearest and nearDist>3 then hrp.CFrame=nearest.CFrame+Vector3.new(0,2.5,0) end
    end)

    -- Auto reset (every 42s when enabled)
    task.spawn(function()
        while SG.Parent do task.wait(42);if ST.autoReset then local char=LP.Character;local hm=char and char:FindFirstChildOfClass("Humanoid");if hm then hm.Health=0 end end end
    end)

    -- Anti AFK
    task.spawn(function()
        while SG.Parent do task.wait(480);if ST.antiAFK then pcall(function() local vu=game:GetService("VirtualUser");vu:Button1Down(Vector2.new(0,0),CFrame.new());task.wait(0.1);vu:Button1Up(Vector2.new(0,0),CFrame.new()) end) end end
    end)

    -- Misc helpers
    local function fpsBoost()
        pcall(function() Lighting.GlobalShadows=false;Lighting.FogEnd=9e9 end)
        pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
        for _,o in ipairs(workspace:GetDescendants()) do pcall(function() if o:IsA("BasePart") then o.CastShadow=false end end) end
    end
    local function changeTime(t) if t=="Day" then Lighting.ClockTime=14;Lighting.Brightness=2 elseif t=="Sunset" then Lighting.ClockTime=18;Lighting.Brightness=1.5 elseif t=="Night" then Lighting.ClockTime=20;Lighting.Brightness=1 elseif t=="Midnight" then Lighting.ClockTime=0;Lighting.Brightness=0.5 end end
    local function rejoin() pcall(function() game:GetService("TeleportService"):Teleport(game.PlaceId,LP) end) end
    local function serverHop()
        local ok,srv=pcall(function() return game:GetService("TeleportService"):GetServersByGameId(game.PlaceId) end)
        if ok and srv then local pg=srv:GetCurrentPage();for _,s in ipairs(pg) do if s.playing<s.maxPlayers and s.id~=game.JobId then pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,s.id,LP) end);return end end end
        rejoin()
    end
    local function refreshPlayers() ST.playerList={};for _,p in ipairs(Players:GetPlayers()) do if p~=LP then table.insert(ST.playerList,p) end end end
    local function tpTo(p) if not p then return end;local char=LP.Character;local hrp=char and char:FindFirstChild("HumanoidRootPart");if not hrp then return end;local tHRP=p.Character and p.Character:FindFirstChild("HumanoidRootPart");if tHRP then hrp.CFrame=tHRP.CFrame+Vector3.new(0,3.5,0) end end

    -- ═══════════════════════════════════════════════
    -- MM2 UI  BUILD
    -- ═══════════════════════════════════════════════
    local WW,WH,SBW,TBH = 694,474,198,34

    local win=Instance.new("Frame",SG)
    win.Size=UDim2.fromOffset(WW,WH);win.Position=UDim2.new(0.5,-WW/2,0.5,-WH/2)
    win.BackgroundColor3=T.BG;win.BorderSizePixel=0;win.Active=true;win.Draggable=true
    Instance.new("UICorner",win).CornerRadius=UDim.new(0,12)
    local wStk=Instance.new("UIStroke",win);wStk.Color=T.BORDER;wStk.Thickness=1.5

    -- Title bar
    local tBar=Instance.new("Frame",win);tBar.Size=UDim2.new(1,0,0,TBH);tBar.BackgroundColor3=T.SIDEBAR;tBar.BorderSizePixel=0
    Instance.new("UICorner",tBar).CornerRadius=UDim.new(0,12)
    local tFix=Instance.new("Frame",tBar);tFix.Size=UDim2.new(1,0,0.5,0);tFix.Position=UDim2.new(0,0,0.5,0);tFix.BackgroundColor3=T.SIDEBAR;tFix.BorderSizePixel=0

    local tIco=Instance.new("TextLabel",tBar);tIco.Position=UDim2.fromOffset(10,6);tIco.Size=UDim2.fromOffset(22,22);tIco.BackgroundTransparency=1;tIco.Text="🔪";tIco.TextSize=16
    local tNm=Instance.new("TextLabel",tBar);tNm.Position=UDim2.fromOffset(34,4);tNm.Size=UDim2.new(1,-170,0,15);tNm.BackgroundTransparency=1;tNm.Text="ENI Hub  Murder Mystery 2";tNm.TextColor3=T.TEXT;tNm.Font=Enum.Font.GothamBold;tNm.TextSize=12;tNm.TextXAlignment=Enum.TextXAlignment.Left
    local tBy=Instance.new("TextLabel",tBar);tBy.Position=UDim2.fromOffset(34,19);tBy.Size=UDim2.new(0.4,0,0,12);tBy.BackgroundTransparency=1;tBy.Text="by ENI";tBy.TextColor3=T.DIM;tBy.Font=Enum.Font.Gotham;tBy.TextSize=10;tBy.TextXAlignment=Enum.TextXAlignment.Left

    local function mkWB(ox,txt,bc)
        local b=Instance.new("TextButton",tBar);b.Size=UDim2.fromOffset(22,20);b.Position=UDim2.new(1,ox,0.5,-10);b.BackgroundColor3=bc;b.BorderSizePixel=0;b.Text=txt;b.TextColor3=Color3.fromRGB(225,225,225);b.Font=Enum.Font.GothamBold;b.TextSize=11;b.AutoButtonColor=true;Instance.new("UICorner",b).CornerRadius=UDim.new(0,5);return b
    end
    local closeBtn=mkWB(-28,"✕",Color3.fromRGB(160,40,40))
    local minBtn=mkWB(-54,"−",Color3.fromRGB(40,40,65))
    closeBtn.MouseButton1Click:Connect(function() win:Destroy() end)
    local mm2min=false
    minBtn.MouseButton1Click:Connect(function()
        mm2min=not mm2min;minBtn.Text=mm2min and "+" or "−"
        TS:Create(win,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{Size=mm2min and UDim2.fromOffset(WW,TBH) or UDim2.fromOffset(WW,WH)}):Play()
    end)

    -- Body
    local body=Instance.new("Frame",win);body.Position=UDim2.fromOffset(0,TBH);body.Size=UDim2.new(1,0,1,-TBH);body.BackgroundTransparency=1;body.ClipsDescendants=true

    -- Sidebar
    local sb=Instance.new("Frame",body);sb.Size=UDim2.fromOffset(SBW,WH-TBH);sb.BackgroundColor3=T.SIDEBAR;sb.BorderSizePixel=0
    local sbDiv=Instance.new("Frame",body);sbDiv.Position=UDim2.fromOffset(SBW,0);sbDiv.Size=UDim2.fromOffset(1,WH-TBH);sbDiv.BackgroundColor3=T.BORDER;sbDiv.BorderSizePixel=0

    -- Search
    local sfr=Instance.new("Frame",sb);sfr.Position=UDim2.fromOffset(8,8);sfr.Size=UDim2.new(1,-16,0,30);sfr.BackgroundColor3=Color3.fromRGB(20,16,34);sfr.BorderSizePixel=0;Instance.new("UICorner",sfr).CornerRadius=UDim.new(0,8)
    local sIco=Instance.new("TextLabel",sfr);sIco.Position=UDim2.fromOffset(6,0);sIco.Size=UDim2.fromOffset(20,30);sIco.BackgroundTransparency=1;sIco.Text="🔍";sIco.TextSize=12
    local sBx=Instance.new("TextBox",sfr);sBx.Position=UDim2.fromOffset(24,0);sBx.Size=UDim2.new(1,-32,1,0);sBx.BackgroundTransparency=1;sBx.Font=Enum.Font.Gotham;sBx.Text="";sBx.TextColor3=T.TEXT;sBx.TextSize=12;sBx.PlaceholderText="Search...";sBx.PlaceholderColor3=T.DIM;sBx.ClearTextOnFocus=false

    -- Nav
    local NAV={
        {id="Main",     ico="🏠",lbl="Main"},
        {id="Visuals",  ico="👁",lbl="Visuals"},
        {id="Combat",   ico="⚔",lbl="Combat"},
        {id="Fun",      ico="🎮",lbl="Fun"},
        {id="Teleports",ico="📍",lbl="Teleports"},
        {id="Misc",     ico="",  lbl="Misc"},
        {id="Settings", ico="⚙",lbl="Settings"},
    }
    local navSc=Instance.new("ScrollingFrame",sb);navSc.Position=UDim2.fromOffset(0,46);navSc.Size=UDim2.new(1,0,1,-46-58);navSc.BackgroundTransparency=1;navSc.BorderSizePixel=0;navSc.ScrollBarThickness=2;navSc.ScrollBarImageColor3=T.BORDER;navSc.CanvasSize=UDim2.new(0,0,0,0);navSc.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local navLy=Instance.new("UIListLayout",navSc);navLy.Padding=UDim.new(0,2);navLy.SortOrder=Enum.SortOrder.LayoutOrder
    local navPd=Instance.new("UIPadding",navSc);navPd.PaddingLeft=UDim.new(0,6);navPd.PaddingRight=UDim.new(0,6);navPd.PaddingTop=UDim.new(0,4)

    local navBtns={}
    for i,itm in ipairs(NAV) do
        local nb=Instance.new("TextButton",navSc);nb.Size=UDim2.new(1,0,0,36);nb.BackgroundColor3=i==1 and T.SEL or T.SIDEBAR;nb.BackgroundTransparency=i==1 and 0 or 1;nb.BorderSizePixel=0;nb.Text="";nb.LayoutOrder=i
        Instance.new("UICorner",nb).CornerRadius=UDim.new(0,8)
        local nico=Instance.new("TextLabel",nb);nico.Position=UDim2.fromOffset(10,0);nico.Size=UDim2.fromOffset(22,36);nico.BackgroundTransparency=1;nico.Text=itm.ico;nico.TextSize=14;nico.TextColor3=i==1 and T.NEON or T.DIM;nico.Font=Enum.Font.GothamBold
        local nlbl=Instance.new("TextLabel",nb);nlbl.Position=UDim2.fromOffset(34,0);nlbl.Size=UDim2.new(1,-44,1,0);nlbl.BackgroundTransparency=1;nlbl.Text=itm.lbl;nlbl.TextSize=13;nlbl.Font=Enum.Font.GothamMedium;nlbl.TextColor3=i==1 and T.TEXT or T.DIM;nlbl.TextXAlignment=Enum.TextXAlignment.Left
        navBtns[itm.id]={btn=nb,ico=nico,lbl=nlbl}
    end
    sBx:GetPropertyChangedSignal("Text"):Connect(function()
        local t=sBx.Text:lower()
        for _,itm in ipairs(NAV) do local nb=navBtns[itm.id];if nb then nb.btn.Visible=t=="" or itm.lbl:lower():find(t,1,true)~=nil end end
    end)

    -- User info (bottom of sidebar)
    local uFr=Instance.new("Frame",sb);uFr.Position=UDim2.new(0,0,1,-56);uFr.Size=UDim2.new(1,0,0,56);uFr.BackgroundColor3=Color3.fromRGB(12,10,20);uFr.BorderSizePixel=0
    local uDiv=Instance.new("Frame",uFr);uDiv.Size=UDim2.new(1,0,0,1);uDiv.BackgroundColor3=T.BORDER;uDiv.BorderSizePixel=0
    local avaC=Instance.new("Frame",uFr);avaC.Position=UDim2.fromOffset(10,8);avaC.Size=UDim2.fromOffset(38,38);avaC.BackgroundColor3=T.NEON;avaC.BorderSizePixel=0;Instance.new("UICorner",avaC).CornerRadius=UDim.new(1,0)
    local avaI=Instance.new("TextLabel",avaC);avaI.Size=UDim2.fromScale(1,1);avaI.BackgroundTransparency=1;avaI.Text=LP.Name:sub(1,1):upper();avaI.TextColor3=Color3.fromRGB(8,8,16);avaI.Font=Enum.Font.GothamBlack;avaI.TextSize=22
    local uNm=Instance.new("TextLabel",uFr);uNm.Position=UDim2.fromOffset(54,8);uNm.Size=UDim2.new(1,-62,0,20);uNm.BackgroundTransparency=1;uNm.Text=LP.DisplayName or LP.Name;uNm.TextColor3=T.TEXT;uNm.Font=Enum.Font.GothamBold;uNm.TextSize=13;uNm.TextXAlignment=Enum.TextXAlignment.Left
    local uNm2=Instance.new("TextLabel",uFr);uNm2.Position=UDim2.fromOffset(54,26);uNm2.Size=UDim2.new(1,-62,0,16);uNm2.BackgroundTransparency=1;uNm2.Text="@"..LP.Name;uNm2.TextColor3=T.DIM;uNm2.Font=Enum.Font.Gotham;uNm2.TextSize=11;uNm2.TextXAlignment=Enum.TextXAlignment.Left

    -- Content area
    local ca=Instance.new("Frame",body);ca.Position=UDim2.fromOffset(SBW+1,0);ca.Size=UDim2.new(1,-SBW-1,1,0);ca.BackgroundColor3=T.CONTENT;ca.BorderSizePixel=0

    -- Pages
    local pages={}
    local function newPg(id)
        local p=Instance.new("ScrollingFrame",ca);p.Size=UDim2.fromScale(1,1);p.BackgroundTransparency=1;p.BorderSizePixel=0;p.ScrollBarThickness=3;p.ScrollBarImageColor3=T.NEON;p.CanvasSize=UDim2.new(0,0,0,0);p.AutomaticCanvasSize=Enum.AutomaticSize.Y;p.Visible=(id=="Main")
        local pad=Instance.new("UIPadding",p);pad.PaddingLeft=UDim.new(0,14);pad.PaddingRight=UDim.new(0,14);pad.PaddingTop=UDim.new(0,10);pad.PaddingBottom=UDim.new(0,14)
        local ly=Instance.new("UIListLayout",p);ly.Padding=UDim.new(0,7);ly.SortOrder=Enum.SortOrder.LayoutOrder
        pages[id]=p;return p
    end
    for _,itm in ipairs(NAV) do newPg(itm.id) end

    local function selNav(id)
        for nid,nb in pairs(navBtns) do
            local on=nid==id
            TS:Create(nb.btn,TweenInfo.new(0.15),{BackgroundColor3=on and T.SEL or T.SIDEBAR,BackgroundTransparency=on and 0 or 1}):Play()
            nb.ico.TextColor3=on and T.NEON or T.DIM;nb.lbl.TextColor3=on and T.TEXT or T.DIM
        end
        for pid,p in pairs(pages) do p.Visible=(pid==id) end
    end
    for _,itm in ipairs(NAV) do navBtns[itm.id].btn.MouseButton1Click:Connect(function() selNav(itm.id) end) end

    -- ── Widget helpers ──────────────────────────────────────────
    local function mkSec(par,title,order)
        local f=Instance.new("Frame",par);f.Size=UDim2.new(1,0,0,26);f.BackgroundTransparency=1;f.LayoutOrder=order
        local l=Instance.new("TextLabel",f);l.Size=UDim2.fromScale(1,1);l.BackgroundTransparency=1;l.Text=title;l.TextColor3=T.TEXT;l.Font=Enum.Font.GothamBold;l.TextSize=14;l.TextXAlignment=Enum.TextXAlignment.Left
        local d=Instance.new("Frame",f);d.Size=UDim2.new(1,0,0,1);d.Position=UDim2.new(0,0,1,-1);d.BackgroundColor3=T.BORDER;d.BorderSizePixel=0
    end
    local function mkCard(par,order,h)
        local c=Instance.new("Frame",par);c.Size=UDim2.new(1,0,0,h or 64);c.BackgroundColor3=T.CC;c.BorderSizePixel=0;c.LayoutOrder=order;Instance.new("UICorner",c).CornerRadius=UDim.new(0,10);return c
    end
    local function mkTog(par,title,desc,order,gFn,sFn,onChange)
        local h=desc and 64 or 46;local card=mkCard(par,order,h)
        local tl=Instance.new("TextLabel",card);tl.Position=UDim2.fromOffset(14,desc and 10 or 13);tl.Size=UDim2.new(1,-80,0,20);tl.BackgroundTransparency=1;tl.Text=title;tl.TextColor3=T.TEXT;tl.Font=Enum.Font.GothamMedium;tl.TextSize=13;tl.TextXAlignment=Enum.TextXAlignment.Left
        if desc then local dl=Instance.new("TextLabel",card);dl.Position=UDim2.fromOffset(14,30);dl.Size=UDim2.new(1,-80,0,18);dl.BackgroundTransparency=1;dl.Text=desc;dl.TextColor3=T.DIM;dl.Font=Enum.Font.Gotham;dl.TextSize=11;dl.TextXAlignment=Enum.TextXAlignment.Left end
        local pill=Instance.new("Frame",card);pill.Size=UDim2.fromOffset(44,24);pill.Position=UDim2.new(1,-54,0.5,-12);pill.BackgroundColor3=gFn() and T.NEON or T.POFF;pill.BorderSizePixel=0;Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
        local knob=Instance.new("Frame",pill);knob.Size=UDim2.fromOffset(18,18);knob.Position=gFn() and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3);knob.BackgroundColor3=Color3.fromRGB(255,255,255);knob.BorderSizePixel=0;Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
        local btn=Instance.new("TextButton",card);btn.Size=UDim2.fromScale(1,1);btn.BackgroundTransparency=1;btn.Text=""
        btn.MouseButton1Click:Connect(function()
            sFn(not gFn());local on=gFn()
            TS:Create(pill,TweenInfo.new(0.15),{BackgroundColor3=on and T.NEON or T.POFF}):Play()
            TS:Create(knob,TweenInfo.new(0.15),{Position=on and UDim2.fromOffset(23,3) or UDim2.fromOffset(3,3)}):Play()
            if onChange then pcall(onChange,on) end
        end)
    end
    local function mkAction(par,title,desc,order,icon,cb)
        local h=desc and 64 or 46;local card=mkCard(par,order,h)
        local tl=Instance.new("TextLabel",card);tl.Position=UDim2.fromOffset(14,desc and 10 or 13);tl.Size=UDim2.new(1,-56,0,20);tl.BackgroundTransparency=1;tl.Text=title;tl.TextColor3=T.TEXT;tl.Font=Enum.Font.GothamMedium;tl.TextSize=13;tl.TextXAlignment=Enum.TextXAlignment.Left
        if desc then local dl=Instance.new("TextLabel",card);dl.Position=UDim2.fromOffset(14,30);dl.Size=UDim2.new(1,-56,0,18);dl.BackgroundTransparency=1;dl.Text=desc;dl.TextColor3=T.DIM;dl.Font=Enum.Font.Gotham;dl.TextSize=11;dl.TextXAlignment=Enum.TextXAlignment.Left end
        local ib=Instance.new("TextButton",card);ib.Size=UDim2.fromOffset(32,32);ib.Position=UDim2.new(1,-42,0.5,-16);ib.BackgroundColor3=Color3.fromRGB(26,22,42);ib.BorderSizePixel=0;ib.Text=icon or "▶";ib.TextColor3=T.NEON;ib.Font=Enum.Font.GothamBold;ib.TextSize=14;ib.AutoButtonColor=true;Instance.new("UICorner",ib).CornerRadius=UDim.new(0,8)
        local cl=Instance.new("TextButton",card);cl.Size=UDim2.fromScale(1,1);cl.BackgroundTransparency=1;cl.Text="";cl.MouseButton1Click:Connect(cb)
    end
    local function mkSld(par,title,order,mn,mx,df,cb)
        local card=mkCard(par,order,72)
        local tl=Instance.new("TextLabel",card);tl.Position=UDim2.fromOffset(14,8);tl.Size=UDim2.new(0.65,0,0,20);tl.BackgroundTransparency=1;tl.Text=title;tl.TextColor3=T.TEXT;tl.Font=Enum.Font.GothamMedium;tl.TextSize=13;tl.TextXAlignment=Enum.TextXAlignment.Left
        local vl=Instance.new("TextLabel",card);vl.Position=UDim2.new(0.65,0,0,8);vl.Size=UDim2.new(0.35,-14,0,20);vl.BackgroundTransparency=1;vl.Text=tostring(df);vl.TextColor3=T.NEON;vl.Font=Enum.Font.GothamBold;vl.TextSize=13;vl.TextXAlignment=Enum.TextXAlignment.Right
        local tr=Instance.new("Frame",card);tr.Position=UDim2.fromOffset(14,46);tr.Size=UDim2.new(1,-28,0,4);tr.BackgroundColor3=Color3.fromRGB(34,30,54);tr.BorderSizePixel=0;Instance.new("UICorner",tr).CornerRadius=UDim.new(1,0)
        local fl=Instance.new("Frame",tr);fl.Size=UDim2.new((df-mn)/(mx-mn),0,1,0);fl.BackgroundColor3=T.NEON;fl.BorderSizePixel=0;Instance.new("UICorner",fl).CornerRadius=UDim.new(1,0)
        local gr=Instance.new("TextButton",tr);gr.Size=UDim2.new(1,0,0,22);gr.Position=UDim2.new(0,0,0.5,-11);gr.BackgroundTransparency=1;gr.Text=""
        local dr=false;gr.MouseButton1Down:Connect(function() dr=true end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end end)
        UIS.InputChanged:Connect(function(i) if dr and i.UserInputType==Enum.UserInputType.MouseMovement then local r=math.clamp((i.Position.X-tr.AbsolutePosition.X)/math.max(1,tr.AbsoluteSize.X),0,1);local v=math.floor(mn+r*(mx-mn));fl.Size=UDim2.new(r,0,1,0);vl.Text=tostring(v);cb(v) end end)
    end
    local function mkInput(par,title,desc,order,ph,cb)
        local h=desc and 76 or 60;local card=mkCard(par,order,h)
        local tl=Instance.new("TextLabel",card);tl.Position=UDim2.fromOffset(14,8);tl.Size=UDim2.new(1,-28,0,20);tl.BackgroundTransparency=1;tl.Text=title;tl.TextColor3=T.TEXT;tl.Font=Enum.Font.GothamMedium;tl.TextSize=13;tl.TextXAlignment=Enum.TextXAlignment.Left
        if desc then local dl=Instance.new("TextLabel",card);dl.Position=UDim2.fromOffset(14,26);dl.Size=UDim2.new(1,-28,0,16);dl.BackgroundTransparency=1;dl.Text=desc;dl.TextColor3=T.DIM;dl.Font=Enum.Font.Gotham;dl.TextSize=10;dl.TextXAlignment=Enum.TextXAlignment.Left end
        local yO=desc and 46 or 34;local ifr=Instance.new("Frame",card);ifr.Position=UDim2.fromOffset(14,yO);ifr.Size=UDim2.new(1,-28,0,22);ifr.BackgroundColor3=Color3.fromRGB(14,12,24);ifr.BorderSizePixel=0;Instance.new("UICorner",ifr).CornerRadius=UDim.new(0,6)
        local ib=Instance.new("TextBox",ifr);ib.Size=UDim2.new(1,-10,1,0);ib.Position=UDim2.fromOffset(8,0);ib.BackgroundTransparency=1;ib.Font=Enum.Font.Gotham;ib.Text="";ib.TextColor3=T.TEXT;ib.TextSize=12;ib.PlaceholderText=ph;ib.PlaceholderColor3=T.DIM;ib.ClearTextOnFocus=false
        ib.FocusLost:Connect(function(ep) if ep then cb(ib.Text) end end)
    end

    -- ── PAGE CONTENTS ──────────────────────────────────────────

    -- MAIN
    local mp=pages["Main"];local o=0
    local dcC=mkCard(mp,o+1,44);o=o+1;dcC.BackgroundColor3=Color3.fromRGB(88,101,242)
    local dcB=Instance.new("TextButton",dcC);dcB.Size=UDim2.fromScale(1,1);dcB.BackgroundTransparency=1;dcB.Text="💬  Copy Discord Invite";dcB.TextColor3=Color3.fromRGB(255,255,255);dcB.Font=Enum.Font.GothamBold;dcB.TextSize=14
    dcB.MouseButton1Click:Connect(function() if setclipboard then setclipboard("discord.gg/enihub") end;Notif("ENI","Copied invite!") end)
    mkSec(mp,"💰 Auto Farm",o+1);o=o+1
    mkTog(mp,"Auto Coin Farm","Only active during rounds (Stops in Lobby)",o+1,function() return ST.coinFarm end,function(v) ST.coinFarm=v end);o=o+1
    mkTog(mp,"Auto Reset","Resets character after 40 coins",o+1,function() return ST.autoReset end,function(v) ST.autoReset=v end);o=o+1
    mkSec(mp,"⏳ Anti-AFK",o+1);o=o+1
    mkTog(mp,"Anti-AFK","Clicks every 10 minutes to prevent kick",o+1,function() return ST.antiAFK end,function(v) ST.antiAFK=v end);o=o+1

    -- VISUALS
    local vp=pages["Visuals"];o=0
    mkSec(vp,"👁 ESP Highlights",o+1);o=o+1
    mkTog(vp,"Murderer ESP","Highlight the murderer through walls",o+1,function() return ST.murdESP end,function(v) ST.murdESP=v end);o=o+1
    mkTog(vp,"Sheriff ESP","Highlight the sheriff through walls",o+1,function() return ST.sheriffESP end,function(v) ST.sheriffESP=v end);o=o+1
    mkTog(vp,"Innocent ESP","Highlight innocents through walls",o+1,function() return ST.innocESP end,function(v) ST.innocESP=v end);o=o+1

    -- COMBAT
    local cp=pages["Combat"];o=0
    local noteC=mkCard(cp,o+1,30);o=o+1;noteC.BackgroundColor3=Color3.fromRGB(10,20,10)
    local noteL=Instance.new("TextLabel",noteC);noteL.Size=UDim2.fromScale(1,1);noteL.BackgroundTransparency=1;noteL.Text="  ✅ mousemoverel only — camera stays FREE";noteL.TextColor3=Color3.fromRGB(120,230,120);noteL.Font=Enum.Font.Gotham;noteL.TextSize=11;noteL.TextXAlignment=Enum.TextXAlignment.Left
    mkTog(cp,"Enable Aimlock","Aims toward the murderer automatically",o+1,function() return ST.aimOn end,function(v) ST.aimOn=v;if v then bFOV() else if fovObj then pcall(function() fovObj:Remove() end);fovObj=nil end end end);o=o+1
    mkTog(cp,"Show FOV Circle","Draw FOV indicator on screen",o+1,function() return ST.showFOV end,function(v) ST.showFOV=v end);o=o+1
    mkSld(cp,"FOV Radius",o+1,30,400,ST.aimFOV,function(v) ST.aimFOV=v;if fovObj then fovObj.Radius=v end end);o=o+1
    mkSld(cp,"Strength (18=default)",o+1,1,60,math.floor(ST.aimStr*100),function(v) ST.aimStr=v/100 end);o=o+1
    mkSec(cp,"⚔ Kill Remotes",o+1);o=o+1
    mkAction(cp,"Kill Murderer","Fire kill remotes at the murderer",o+1,"⚡",function() bK(gM()) end);o=o+1
    mkAction(cp,"Kill Sheriff","Fire kill remotes at the sheriff",o+1,"⚡",function() bK(gS()) end);o=o+1

    -- FUN
    local fp=pages["Fun"];o=0
    mkSec(fp,"🚀 Powerups",o+1);o=o+1
    mkTog(fp,"Noclip","Walk through walls",o+1,function() return ST.noclip end,function(v) ST.noclip=v end);o=o+1
    mkTog(fp,"Invisible","Makes your character invisible",o+1,function() return ST.invisible end,function(v) ST.invisible=v;local char=LP.Character;if v then applyInv(char) else restoreInv(char) end end);o=o+1
    mkSec(fp,"🏃 Movement Settings",o+1);o=o+1
    mkInput(fp,"WalkSpeed","Type a speed (Default: 16)",o+1,"Enter speed...",function(v) local n=tonumber(v);if n then local c=LP.Character;local hm=c and c:FindFirstChildOfClass("Humanoid");if hm then hm.WalkSpeed=n end end end);o=o+1
    mkInput(fp,"JumpPower","Type jump height (Default: 50)",o+1,"Enter jump power...",function(v) local n=tonumber(v);if n then local c=LP.Character;local hm=c and c:FindFirstChildOfClass("Humanoid");if hm then hm.UseJumpPower=true;hm.JumpPower=n end end end);o=o+1

    -- TELEPORTS
    local tp2=pages["Teleports"];o=0
    local plC=mkCard(tp2,o+1,56);o=o+1
    local plTL=Instance.new("TextLabel",plC);plTL.Position=UDim2.fromOffset(14,8);plTL.Size=UDim2.new(0.5,0,0,20);plTL.BackgroundTransparency=1;plTL.Text="Select Player";plTL.TextColor3=T.TEXT;plTL.Font=Enum.Font.GothamMedium;plTL.TextSize=13;plTL.TextXAlignment=Enum.TextXAlignment.Left
    local plDL=Instance.new("TextLabel",plC);plDL.Position=UDim2.fromOffset(14,28);plDL.Size=UDim2.new(0.7,0,0,16);plDL.BackgroundTransparency=1;plDL.Text="Choose a player to teleport";plDL.TextColor3=T.DIM;plDL.Font=Enum.Font.Gotham;plDL.TextSize=10;plDL.TextXAlignment=Enum.TextXAlignment.Left
    local plDDF=Instance.new("Frame",plC);plDDF.Size=UDim2.fromOffset(130,26);plDDF.Position=UDim2.new(1,-140,0.5,-13);plDDF.BackgroundColor3=Color3.fromRGB(18,14,30);plDDF.BorderSizePixel=0;Instance.new("UICorner",plDDF).CornerRadius=UDim.new(0,7);Instance.new("UIStroke",plDDF).Color=T.BORDER
    local plDDL=Instance.new("TextLabel",plDDF);plDDL.Size=UDim2.new(1,-22,1,0);plDDL.Position=UDim2.fromOffset(8,0);plDDL.BackgroundTransparency=1;plDDL.Text="--";plDDL.TextColor3=T.TEXT;plDDL.Font=Enum.Font.Gotham;plDDL.TextSize=11;plDDL.TextXAlignment=Enum.TextXAlignment.Left
    local plArrow=Instance.new("TextLabel",plDDF);plArrow.Size=UDim2.fromOffset(18,26);plArrow.Position=UDim2.new(1,-20,0,0);plArrow.BackgroundTransparency=1;plArrow.Text="▼";plArrow.TextColor3=T.DIM;plArrow.Font=Enum.Font.GothamBold;plArrow.TextSize=10
    local plIdx=1
    local plBtn=Instance.new("TextButton",plDDF);plBtn.Size=UDim2.fromScale(1,1);plBtn.BackgroundTransparency=1;plBtn.Text=""
    plBtn.MouseButton1Click:Connect(function()
        refreshPlayers();if #ST.playerList==0 then plDDL.Text="--";return end
        plIdx=plIdx%#ST.playerList+1;ST.selectedPlayer=ST.playerList[plIdx];plDDL.Text=ST.playerList[plIdx].Name
    end)
    mkAction(tp2,"Refresh Player List","Update the player dropdown",o+1,"🔄",function() refreshPlayers();if #ST.playerList>0 then ST.selectedPlayer=ST.playerList[1];plDDL.Text=ST.playerList[1].Name;plIdx=1 else plDDL.Text="--" end end);o=o+1
    mkAction(tp2,"Teleport to Selected","TP to the chosen player",o+1,"🎯",function() tpTo(ST.selectedPlayer) end);o=o+1
    mkAction(tp2,"Teleport to Murderer","TP directly to the murderer",o+1,"🔪",function() tpTo(gM()) end);o=o+1
    mkAction(tp2,"Teleport to Sheriff","TP directly to the sheriff",o+1,"🔫",function() tpTo(gS()) end);o=o+1

    -- MISC
    local mip=pages["Misc"];o=0
    mkSec(mip,"🏃 Movement",o+1);o=o+1
    mkTog(mip,"Infinite Jump","Jump as many times as you want",o+1,function() return ST.infJump end,function(v) ST.infJump=v end);o=o+1
    mkSec(mip,"🌍 Environment",o+1);o=o+1
    -- Change Time card
    local ctC=mkCard(mip,o+1,64);o=o+1
    local ctTL=Instance.new("TextLabel",ctC);ctTL.Position=UDim2.fromOffset(14,10);ctTL.Size=UDim2.new(0.55,0,0,20);ctTL.BackgroundTransparency=1;ctTL.Text="Change Time";ctTL.TextColor3=T.TEXT;ctTL.Font=Enum.Font.GothamMedium;ctTL.TextSize=13;ctTL.TextXAlignment=Enum.TextXAlignment.Left
    local ctDL=Instance.new("TextLabel",ctC);ctDL.Position=UDim2.fromOffset(14,28);ctDL.Size=UDim2.new(0.7,0,0,16);ctDL.BackgroundTransparency=1;ctDL.Text="Select the world time";ctDL.TextColor3=T.DIM;ctDL.Font=Enum.Font.Gotham;ctDL.TextSize=10;ctDL.TextXAlignment=Enum.TextXAlignment.Left
    local ctDDF=Instance.new("Frame",ctC);ctDDF.Size=UDim2.fromOffset(110,26);ctDDF.Position=UDim2.new(1,-120,0.5,-13);ctDDF.BackgroundColor3=Color3.fromRGB(18,14,30);ctDDF.BorderSizePixel=0;Instance.new("UICorner",ctDDF).CornerRadius=UDim.new(0,7);Instance.new("UIStroke",ctDDF).Color=T.BORDER
    local ctDDL=Instance.new("TextLabel",ctDDF);ctDDL.Size=UDim2.new(1,-22,1,0);ctDDL.Position=UDim2.fromOffset(8,0);ctDDL.BackgroundTransparency=1;ctDDL.Text="Day";ctDDL.TextColor3=T.TEXT;ctDDL.Font=Enum.Font.Gotham;ctDDL.TextSize=12;ctDDL.TextXAlignment=Enum.TextXAlignment.Left
    local ctArr=Instance.new("TextLabel",ctDDF);ctArr.Size=UDim2.fromOffset(18,26);ctArr.Position=UDim2.new(1,-20,0,0);ctArr.BackgroundTransparency=1;ctArr.Text="▼";ctArr.TextColor3=T.DIM;ctArr.Font=Enum.Font.GothamBold;ctArr.TextSize=10
    local timeOpts={"Day","Sunset","Night","Midnight"};local timeIdx=1
    local ctBtn=Instance.new("TextButton",ctDDF);ctBtn.Size=UDim2.fromScale(1,1);ctBtn.BackgroundTransparency=1;ctBtn.Text=""
    ctBtn.MouseButton1Click:Connect(function() timeIdx=timeIdx%#timeOpts+1;ctDDL.Text=timeOpts[timeIdx];changeTime(timeOpts[timeIdx]) end)
    mkSec(mip,"📋 External Scripts",o+1);o=o+1
    mkAction(mip,"Infinite Yield","Loads the most popular admin command script",o+1,"🎯",function()
        if not(typeof(loadstring)=="function") then Notif("ENI","no loadstring");return end
        pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
    end);o=o+1
    mkAction(mip,"Emote Script","Activates custom emotes for your character",o+1,"🎭",function() Notif("ENI","Paste your emote script URL in a custom executor") end);o=o+1

    -- SETTINGS
    local sp=pages["Settings"];o=0
    mkSec(sp,"🎯 Keybinds & FPS Boost",o+1);o=o+1
    local kbC=mkCard(sp,o+1,56);o=o+1
    local kbTL=Instance.new("TextLabel",kbC);kbTL.Position=UDim2.fromOffset(14,8);kbTL.Size=UDim2.new(0.65,0,0,20);kbTL.BackgroundTransparency=1;kbTL.Text="Toggle Menu";kbTL.TextColor3=T.TEXT;kbTL.Font=Enum.Font.GothamMedium;kbTL.TextSize=13;kbTL.TextXAlignment=Enum.TextXAlignment.Left
    local kbDL=Instance.new("TextLabel",kbC);kbDL.Position=UDim2.fromOffset(14,28);kbDL.Size=UDim2.new(0.75,0,0,16);kbDL.BackgroundTransparency=1;kbDL.Text="Choose a key to open or close the UI";kbDL.TextColor3=T.DIM;kbDL.Font=Enum.Font.Gotham;kbDL.TextSize=10;kbDL.TextXAlignment=Enum.TextXAlignment.Left
    local kbKBtn=Instance.new("TextButton",kbC);kbKBtn.Size=UDim2.fromOffset(36,28);kbKBtn.Position=UDim2.new(1,-46,0.5,-14);kbKBtn.BackgroundColor3=Color3.fromRGB(24,20,40);kbKBtn.BorderSizePixel=0;kbKBtn.Text="F";kbKBtn.TextColor3=T.NEON;kbKBtn.Font=Enum.Font.GothamBold;kbKBtn.TextSize=13;kbKBtn.AutoButtonColor=true;Instance.new("UICorner",kbKBtn).CornerRadius=UDim.new(0,7)
    local curKey=Enum.KeyCode.RightBracket
    kbKBtn.MouseButton1Click:Connect(function()
        kbKBtn.Text="...";local conn;conn=UIS.InputBegan:Connect(function(inp,gpe)
            if gpe then return end;curKey=inp.KeyCode;kbKBtn.Text=inp.KeyCode.Name:sub(1,3):upper();conn:Disconnect()
        end)
    end)
    UIS.InputBegan:Connect(function(inp,gpe) if gpe then return end;if inp.KeyCode==curKey then win.Visible=not win.Visible end end)
    mkAction(sp,"FPS Boost","Removes textures, shadows and effects for more FPS",o+1,"⚡",function() fpsBoost();Notif("ENI","FPS Boost applied!") end);o=o+1
    mkSec(sp,"🌐 Server Management",o+1);o=o+1
    mkAction(sp,"Rejoin Server","Reconnect to the same server instantly",o+1,"🔄",function() rejoin() end);o=o+1
    mkAction(sp,"Server Hop","Search and join a different public server",o+1,"🔀",function() serverHop() end);o=o+1

    Notif("ENI Hub","MM2 v5 loaded ✓")
    print("[ENI MM2 v5] Syniox-style loaded — aimbot=mousemoverel camera FREE")
end

-- ═══════════════════════════════════════════════════
-- BOOT
-- ═══════════════════════════════════════════════════
BuildKeyScreen(function()
    BuildScriptSelector(function(game)
        if game.name=="Murder Mystery 2" then
            LaunchMM2()
        else
            Notif("ENI Hub",game.name.." — Coming Soon! 🔜")
        end
    end)
end)

print("[ENI Hub v8.2] booted  |  Key: ADMIN")
