--[[
    ╔══════════════════════════════════════════════════╗
    ║   N3XT  ·  LAUNCHER  v7.6                        ║
    ║   universal + MM2 tabbed UI + rivals             ║
    ╚══════════════════════════════════════════════════╝
]]

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local StarterGui        = game:GetService("StarterGui")
local Lighting          = game:GetService("Lighting")
local Camera            = workspace.CurrentCamera
local LocalPlayer       = Players.LocalPlayer

local HAS_DRAWING    = (typeof(Drawing) == "table") and (type(Drawing.new) == "function")
local HAS_LOADSTRING = (typeof(loadstring) == "function")

local THEME = {
    BG_DEEP     = Color3.fromRGB(14, 12, 24),
    BG_PANEL    = Color3.fromRGB(20, 17, 32),
    BG_EDITOR   = Color3.fromRGB(16, 14, 26),
    BG_BAR      = Color3.fromRGB(24, 20, 38),
    GRID_LINE   = Color3.fromRGB(52, 40, 88),
    ACCENT      = Color3.fromRGB(100, 220, 235),
    PURPLE      = Color3.fromRGB(140, 100, 230),
    TEXT        = Color3.fromRGB(226, 224, 240),
    TEXT_DIM    = Color3.fromRGB(140, 135, 165),
    TEXT_FAINT  = Color3.fromRGB(90, 85, 115),
    READY_GREEN = Color3.fromRGB(120, 230, 150),
    BTN_ACTIVE  = Color3.fromRGB(52, 45, 78),
    BTN_BG      = Color3.fromRGB(30, 26, 46),
    LINE_NUM    = Color3.fromRGB(90, 85, 120),
}

local CFG = {
    INF_JUMP = true, NOCLIP = false, SPEED = false, FLY = false,
    JUMP_POWER = 50, WALK_SPEED = 80, FLY_SPEED = 120,

    ESP_ENABLED = false, ESP_BOXES = true, ESP_LINES = false,
    ESP_NAMES = true, ESP_TEAM_CHECK = false,
    ESP_COLOR = Color3.fromRGB(140, 90, 255),

    AIMBOT_ENABLED = false, AIMBOT_LOCK_STATE = false,
    AIMBOT_TEAM_CHECK = false, AIMBOT_WALLCHECK = false,
    AIMBOT_BYPASS = true, AIMBOT_MOUSELOCK = true,
    AIMBOT_FOV = 200, AIMBOT_SMOOTH = 0.45,
    AIMBOT_BONE_PRIORITY = {"Head","UpperTorso","Torso","HumanoidRootPart"},
    AIMBOT_LOCK_KEY = Enum.KeyCode.E,

    APP_FIRE = false, APP_HIGHLIGHT = false, APP_SMOKE = false,
    APP_SPARKLES = false, APP_NO_ARMS = false, APP_INVISIBLE = false,
    APP_FORCEFIELD = false, APP_4D = false, APP_ZOMBIE = false,

    ETC_GODMODE = false, ETC_ANCHOR = false,
    ETC_NO_LEGS = false, ETC_TOGGLE_NIGHT = false,
    ETC_FLASHLIGHT = false, ETC_HIGH_HIPS = false, ETC_FLOAT = false,
    ETC_CTRL_CLICK_TP = false, ETC_INVINCIBLE = false,

    GRID_DENSITY = 26,
}

local State = {
    Character = nil, Humanoid = nil, RootPart = nil,
    Connections = {}, FlyVelocity = Vector3.zero,
    UI = {}, GridDots = {},
    MM2Loaded = false, RivalsLoaded = false,
    ActiveTab = "Executor",
    ESP = { boxes = {}, lines = {}, names = {} },
    APP = { instances = {} },
    AIM = { fovCircle = nil, hookInstalled = false, origNewindex = nil,
            desiredCF = nil, bypassHook = false, lockedTarget = nil,
            origCamType = nil },
    originalLegs = {}, flashlight = nil, originalMaxHealth = nil,
}

-- ============================================================
--  MM2 SOURCE v4.0 — tabbed UI
-- ============================================================
local MM2_SOURCE = [==[
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera            = workspace.CurrentCamera
local LocalPlayer       = Players.LocalPlayer

local CFG = {
    esp = { Murderer = true, Sheriff = true, Innocent = true },
    aimbot = { enabled = false, fov = 120, showFOV = true, strength = 0.05 },
    invis = false,
    rolePreference = nil,
    gunTP = { enabled = false, cooldown = 1.5 },
    gunPickup = { enabled = false },
    kill = { purgeInnocents = false, lastPurge = 0, purgeInterval = 2.0 },
    invincible = false,
    updateInterval = 0.5,
}

local COLORS = {
    Murderer = Color3.fromRGB(230, 55, 55),
    Sheriff  = Color3.fromRGB(75, 155, 255),
    Innocent = Color3.fromRGB(75, 215, 100),
    Unknown  = Color3.fromRGB(180, 180, 180),
}
local ICONS = { Murderer = "MURDERER", Sheriff = "SHERIFF",
    Innocent = "INNOCENT", Unknown = "UNKNOWN" }

local KNIFE_PAT = {"knife","blade","dark","seer","chroma","godly","elder","shadow","luger","corrupt","shard","ice","wood","rainbow"}
local GUN_PAT = {"gun","sheriff","revolver","deagle","pistol"}

local function matchAny(name, pats)
    name = name:lower()
    for _, p in ipairs(pats) do
        if name:find(p, 1, true) then return true end
    end
    return false
end

local function scanTools(c)
    if not c then return nil end
    for _, o in ipairs(c:GetChildren()) do
        if o:IsA("Tool") then
            if matchAny(o.Name, KNIFE_PAT) then return "Murderer" end
            if matchAny(o.Name, GUN_PAT) then return "Sheriff" end
        end
    end
    return nil
end

local function detectRole(player)
    local char = player.Character
    local bp = player:FindFirstChild("Backpack")
    local r = char and scanTools(char); if r then return r end
    r = scanTools(bp); if r then return r end
    for _, loc in ipairs({player, char}) do
        if loc then
            local rv = loc:FindFirstChild("Role")
            if rv and rv:IsA("StringValue") and rv.Value ~= "" then return rv.Value end
        end
    end
    for _, key in ipairs({"RoleData","Roles","PlayerRoles","GameRoles"}) do
        local tbl = ReplicatedStorage:FindFirstChild(key)
        if tbl then
            local e = tbl:FindFirstChild(player.Name) or tbl:FindFirstChild(tostring(player.UserId))
            if e and e.Value and e.Value ~= "" then return e.Value end
        end
    end
    return "Innocent"
end

local function getLocalRole() return detectRole(LocalPlayer) end
local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and detectRole(p) == "Murderer" then return p end
    end
end
local function getSheriff()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and detectRole(p) == "Sheriff" then return p end
    end
end
local function getInnocents()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and detectRole(p) == "Innocent" and p.Character then
            table.insert(list, p)
        end
    end
    return list
end

local KILL_REMOTE_NAMES = {
    "KillPlayer","Kill","Damage","DamagePlayer","Stab","Shoot",
    "Hit","Attack","DamageHumanoid","ApplyDamage","KillCharacter",
    "Murder","KillTarget","HitPlayer","AttackPlayer","Slash",
    "KnifeHit","GunHit","PlayerDamage","DamageRemote",
}
local function blastKillRemotes(target)
    if not target then return false end
    local char = target.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local fired = false
    local function tryKillRemote(obj)
        if not (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then return end
        local nm = obj.Name:lower()
        local matched = false
        for _, name in ipairs(KILL_REMOTE_NAMES) do
            if nm == name:lower() then matched = true; break end
        end
        if not matched then return end
        local sigs = {
            {target}, {target, hum}, {target, char}, {target.Character, hum},
            {char, hum}, {char, target}, {target.Name}, {target.UserId},
            {hum}, {hum, 9999}, {hum, 100}, {target, "kill"}, {"kill", target},
            {target, 9999}, {target, true}, {char, 9999}, {char, "kill"},
            {target.Name, 9999}, {target.UserId, 9999},
        }
        for _, sig in ipairs(sigs) do
            if obj:IsA("RemoteEvent") then
                if pcall(function() obj:FireServer(unpack(sig)) end) then fired = true end
            elseif obj:IsA("RemoteFunction") then
                if pcall(function() obj:InvokeServer(unpack(sig)) end) then fired = true end
            end
        end
    end
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do tryKillRemote(obj) end
    for _, obj in ipairs(workspace:GetDescendants()) do tryKillRemote(obj) end
    return fired
end
_G.N3xtMM2_Kill = function(p) if not p then return false end return blastKillRemotes(p) end
_G.N3xtMM2_KillMurderer = function()
    local m = getMurderer(); if not m then return false end
    return _G.N3xtMM2_Kill(m)
end
_G.N3xtMM2_KillSheriff = function()
    local s = getSheriff(); if not s then return false end
    return _G.N3xtMM2_Kill(s)
end
_G.N3xtMM2_PurgeStep = function()
    local list = getInnocents()
    if #list == 0 then return false end
    return _G.N3xtMM2_Kill(list[math.random(1, #list)])
end

local highlights, billboards = {}, {}
local function makeHighlight(player)
    local role = detectRole(player)
    if not CFG.esp[role] then
        if highlights[player] then highlights[player]:Destroy(); highlights[player] = nil end
        return
    end
    local char = player.Character; if not char then return end
    if highlights[player] then highlights[player]:Destroy() end
    local h = Instance.new("Highlight")
    h.FillColor = COLORS[role] or COLORS.Unknown
    h.OutlineColor = COLORS[role] or COLORS.Unknown
    h.FillTransparency = 0.45; h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = char; h.Parent = char
    highlights[player] = h
end
local function makeBillboard(player)
    local role = detectRole(player)
    if not CFG.esp[role] then
        if billboards[player] then billboards[player]:Destroy(); billboards[player] = nil end
        return
    end
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    if not hrp then return end
    if billboards[player] then billboards[player]:Destroy() end
    local color = COLORS[role] or COLORS.Unknown
    local bg = Instance.new("BillboardGui")
    bg.Size = UDim2.new(0,150,0,44); bg.StudsOffset = Vector3.new(0,3.4,0)
    bg.AlwaysOnTop = true; bg.MaxDistance = 500
    bg.Adornee = hrp; bg.Parent = hrp
    local frame = Instance.new("Frame", bg)
    frame.Size = UDim2.new(1,0,1,0)
    frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
    frame.BackgroundTransparency = 0.25
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,7)
    local txt = Instance.new("TextLabel", frame)
    txt.Size = UDim2.new(1,0,1,0); txt.BackgroundTransparency = 1
    txt.Text = player.Name.."\n"..(ICONS[role] or ICONS.Unknown)
    txt.TextColor3 = color; txt.TextScaled = true
    txt.Font = Enum.Font.GothamBold
    billboards[player] = bg
end
local function removeESP(player)
    if highlights[player] then highlights[player]:Destroy(); highlights[player] = nil end
    if billboards[player] then billboards[player]:Destroy(); billboards[player] = nil end
end

local fovCircle
local function buildFOVCircle()
    if not (typeof(Drawing) == "table") then return end
    if fovCircle then pcall(function() fovCircle:Remove() end) end
    local ok, c = pcall(function()
        local circ = Drawing.new("Circle")
        circ.Radius = CFG.aimbot.fov
        circ.Color = Color3.fromRGB(200,200,255)
        circ.Thickness = 1.2; circ.Filled = false; circ.Visible = false
        return circ
    end)
    if ok then fovCircle = c end
end
local function inFOV(sp)
    local c = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    return (sp - c).Magnitude <= CFG.aimbot.fov
end
local function doAimbot()
    if not CFG.aimbot.enabled then return end
    local m = getMurderer()
    if not m or not m.Character then return end
    local head = m.Character:FindFirstChild("Head")
    if not head then return end
    local sp, onScreen = Camera:WorldToViewportPoint(head.Position)
    if not onScreen then return end
    if not inFOV(Vector2.new(sp.X, sp.Y)) then return end
    local camCF = Camera.CFrame
    local worldDir = head.Position - camCF.Position
    if worldDir.Magnitude < 0.001 then return end
    worldDir = worldDir.Unit
    if camCF.LookVector:Dot(worldDir) <= 0 then return end
    local hA = math.asin(math.clamp(camCF.RightVector:Dot(worldDir), -1, 1))
    local vA = math.asin(math.clamp(camCF.UpVector:Dot(worldDir), -1, 1))
    local ppr = Camera.ViewportSize.X / (2 * math.pi)
    local strength = CFG.aimbot.strength or 0.05
    if mousemoverel then
        pcall(mousemoverel, hA * ppr * strength, -vA * ppr * strength)
    end
end

local invisActive = false
local invisLoopConn = nil
local invisOrigCFrame = nil
local invisOrigTrans = {}
local invisOrigLocalMod = {}
local INVIS_REMOTES = {"SetInvisible","Invisible","HidePlayer","PlayerInvis",
    "SetVisibility","VisibilityChange","HideCharacter","GhostMode","SetGhost",
    "PlayerGhost","InvisRequest"}
local function fireInvisRemotes(state)
    local fired = false
    local function tryContainer(container)
        for _, obj in ipairs(container:GetDescendants()) do
            for _, name in ipairs(INVIS_REMOTES) do
                if obj.Name:lower() == name:lower() then
                    if obj:IsA("RemoteEvent") then
                        if pcall(function() obj:FireServer(state) end) then fired = true end
                    elseif obj:IsA("RemoteFunction") then
                        if pcall(function() obj:InvokeServer(state) end) then fired = true end
                    end
                end
            end
        end
    end
    tryContainer(ReplicatedStorage); tryContainer(workspace)
    return fired
end
local function invisApplyChar(char)
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            if invisOrigTrans[p] == nil then
                invisOrigTrans[p] = p.Transparency
                invisOrigLocalMod[p] = p.LocalTransparencyModifier
            end
            p.Transparency = 1; p.LocalTransparencyModifier = 1
            p.CanCollide = false; p.CanTouch = false; p.CanQuery = false
        elseif p:IsA("Decal") or p:IsA("Texture") then
            if invisOrigTrans[p] == nil then invisOrigTrans[p] = p.Transparency end
            p.Transparency = 1
        end
    end
end
local function invisRestoreChar(char)
    if not char then return end
    for inst, t in pairs(invisOrigTrans) do
        pcall(function()
            if inst.Parent then
                inst.Transparency = t
                if inst:IsA("BasePart") and invisOrigLocalMod[inst] ~= nil then
                    inst.LocalTransparencyModifier = invisOrigLocalMod[inst]
                end
                if inst:IsA("BasePart") then
                    inst.CanCollide = true; inst.CanTouch = true; inst.CanQuery = true
                end
            end
        end)
    end
    invisOrigTrans, invisOrigLocalMod = {}, {}
end
local function invisStop()
    if invisLoopConn then invisLoopConn:Disconnect(); invisLoopConn = nil end
end
local function invisStart()
    invisStop()
    invisLoopConn = RunService.RenderStepped:Connect(function()
        if not invisActive then invisStop(); return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position.X, -5000, hrp.Position.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        if char then invisApplyChar(char) end
    end)
end
local function setInvisible(state)
    local char = LocalPlayer.Character
    invisActive = state
    if state then
        fireInvisRemotes(true)
        if not invisOrigCFrame then invisOrigCFrame = Camera.CFrame end
        pcall(function()
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CameraSubject = nil
        end)
        if char then invisApplyChar(char) end
        invisStart()
    else
        invisStop(); invisActive = false
        pcall(function()
            Camera.CameraType = Enum.CameraType.Custom
            Camera.CameraSubject = char and char:FindFirstChildOfClass("Humanoid") or nil
        end)
        if invisOrigCFrame then Camera.CFrame = invisOrigCFrame; invisOrigCFrame = nil end
        invisRestoreChar(char)
        fireInvisRemotes(false)
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    invisActive = false; invisStop()
    invisOrigTrans, invisOrigLocalMod = {}, {}
    invisOrigCFrame = nil
    pcall(function()
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = LocalPlayer.Character
            and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or nil
    end)
end)

local mm2OrigMax = nil
local function setMM2Invincible(on)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if on then
        mm2OrigMax = mm2OrigMax or hum.MaxHealth
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        hum.MaxHealth = 1e6; hum.Health = 1e6
    else
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        if mm2OrigMax then hum.MaxHealth = mm2OrigMax end
        if hum.Health > hum.MaxHealth then hum.Health = hum.MaxHealth end
        mm2OrigMax = nil
    end
end
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.6)
    mm2OrigMax = nil
    if CFG.invincible then setMM2Invincible(true) end
end)

local ROLE_REMOTE_NAMES = {"RequestRole","SetRole","ChooseRole","RoleRequest",
    "SelectRole","AssignRole","SetMurderer","SetSheriff",
    "RoleSelection","PickRole","PlayerRole","RoleAssign",
    "SetPlayerRole","PreferredRole","RolePick"}
local function directWriteRole(role)
    local char = LocalPlayer.Character
    if char then
        for _, loc in ipairs({LocalPlayer, char}) do
            local rv = loc:FindFirstChild("Role")
            if rv and rv:IsA("StringValue") then pcall(function() rv.Value = role end) end
        end
    end
end
local function blastRoleRemotes(role)
    local function tryContainer(container)
        for _, obj in ipairs(container:GetDescendants()) do
            for _, name in ipairs(ROLE_REMOTE_NAMES) do
                if obj.Name:lower() == name:lower() then
                    if obj:IsA("RemoteEvent") then
                        pcall(function() obj:FireServer(role) end)
                        pcall(function() obj:FireServer(role, LocalPlayer) end)
                    elseif obj:IsA("RemoteFunction") then
                        pcall(function() obj:InvokeServer(role) end)
                    end
                end
            end
        end
    end
    tryContainer(ReplicatedStorage); tryContainer(workspace)
end
local function applyRolePreference()
    if not CFG.rolePreference then return end
    blastRoleRemotes(CFG.rolePreference)
    directWriteRole(CFG.rolePreference)
end
LocalPlayer.CharacterAdded:Connect(function()
    for i = 1, 5 do task.wait(0.3 * i); applyRolePreference() end
end)

local lastGunTP = 0
local function findGunTool()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and matchAny(obj.Name, GUN_PAT) then return obj end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and matchAny(obj.Name, GUN_PAT) then return obj end
        if obj:IsA("Model") and matchAny(obj.Name, GUN_PAT) then
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("BasePart") then return child end
            end
        end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            for _, obj in ipairs(plr.Character:GetChildren()) do
                if obj:IsA("Tool") and matchAny(obj.Name, GUN_PAT) then return obj end
            end
            local bp = plr:FindFirstChild("Backpack")
            if bp then
                for _, obj in ipairs(bp:GetChildren()) do
                    if obj:IsA("Tool") and matchAny(obj.Name, GUN_PAT) then return obj end
                end
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
            local parent = obj.Parent
            if parent and matchAny(parent.Name, GUN_PAT) then
                if parent:IsA("BasePart") then return parent end
                local base = parent:FindFirstChildWhichIsA("BasePart", true)
                if base then return base end
            end
        end
    end
    return nil
end
local function teleportToGun()
    local now = tick()
    if now - lastGunTP < CFG.gunTP.cooldown then return false end
    local found = findGunTool()
    if not found then return false end
    local pos = nil
    if found:IsA("BasePart") then pos = found.Position
    elseif found:IsA("Tool") then
        local handle = found:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") then pos = handle.Position end
    end
    if not pos then return false end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    lastGunTP = now
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 2.5, 0))
    return true
end

RunService.Heartbeat:Connect(function()
    if CFG.gunTP.enabled then teleportToGun() end
    if CFG.gunPickup.enabled then
        local char = LocalPlayer.Character
        local hasGun = false
        if char then
            for _, obj in ipairs(char:GetChildren()) do
                if obj:IsA("Tool") and matchAny(obj.Name, GUN_PAT) then hasGun = true; break end
            end
        end
        if not hasGun then teleportToGun() end
    end
    if CFG.kill.purgeInnocents then
        local now = tick()
        if now - CFG.kill.lastPurge >= CFG.kill.purgeInterval then
            CFG.kill.lastPurge = now
            _G.N3xtMM2_PurgeStep()
        end
    end
    if CFG.invincible then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 then hum.Health = hum.MaxHealth end
    end
end)

-- ===== MM2 UI (tabbed) =====
local pg = LocalPlayer:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("MM2_Hub"); if old then old:Destroy() end
local sg = Instance.new("ScreenGui")
sg.Name = "MM2_Hub"; sg.ResetOnSpawn = false; sg.IgnoreGuiInset = true
sg.Parent = pg

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 260, 0, 520)
main.Position = UDim2.new(1, -275, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
main.BackgroundTransparency = 0.06
main.BorderSizePixel = 0
main.Active = true; main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 13)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(55, 55, 80); stroke.Thickness = 1

local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 13)
local fix = Instance.new("Frame", titleBar)
fix.Size = UDim2.new(1, 0, 0.5, 0); fix.Position = UDim2.new(0, 0, 0.5, 0)
fix.BackgroundColor3 = Color3.fromRGB(18, 18, 26); fix.BorderSizePixel = 0
local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -140, 1, 0); titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "N3xt . MM2"
titleLbl.TextColor3 = Color3.fromRGB(235, 235, 255)
titleLbl.Font = Enum.Font.GothamBold; titleLbl.TextSize = 11
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local uniBtn = Instance.new("TextButton", titleBar)
uniBtn.Size = UDim2.new(0, 46, 0, 26)
uniBtn.Position = UDim2.new(1, -114, 0.5, -13)
uniBtn.BackgroundColor3 = Color3.fromRGB(80, 45, 170)
uniBtn.Text = "uni"; uniBtn.TextColor3 = Color3.fromRGB(235, 235, 255)
uniBtn.Font = Enum.Font.GothamBold; uniBtn.TextSize = 11
uniBtn.BorderSizePixel = 0
Instance.new("UICorner", uniBtn).CornerRadius = UDim.new(0, 7)
uniBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
    if _G.N3xt_Reopen then pcall(_G.N3xt_Reopen) end
end)

local minBtn = Instance.new("TextButton", titleBar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -34, 0.5, -13)
minBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
minBtn.Text = "-"; minBtn.TextColor3 = Color3.fromRGB(235, 235, 255)
minBtn.Font = Enum.Font.GothamBold; minBtn.TextSize = 16
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 7)

local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, 0, 0, 32)
tabBar.Position = UDim2.new(0, 0, 0, 42)
tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
tabBar.BorderSizePixel = 0
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)
tabLayout.Parent = tabBar

local TABS = {"ESP","Aim","Kill","Gun","Roles","Misc"}
local tabButtons = {}
local tabPages = {}
local contentHolder = Instance.new("Frame", main)
contentHolder.Size = UDim2.new(1, 0, 1, -106)
contentHolder.Position = UDim2.new(0, 0, 0, 74)
contentHolder.BackgroundTransparency = 1
contentHolder.ClipsDescendants = true

for i, name in ipairs(TABS) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(1/#TABS, -2, 1, 0)
    btn.LayoutOrder = i
    btn.BackgroundColor3 = i == 1 and Color3.fromRGB(80, 45, 170) or Color3.fromRGB(24, 24, 34)
    btn.Text = name
    btn.TextColor3 = i == 1 and Color3.fromRGB(235, 235, 255) or Color3.fromRGB(140, 140, 175)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    tabButtons[name] = btn

    local page = Instance.new("ScrollingFrame", contentHolder)
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 110)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = (i == 1)
    local lp = Instance.new("UIListLayout", page)
    lp.Padding = UDim.new(0, 5)
    lp.SortOrder = Enum.SortOrder.LayoutOrder
    local pp = Instance.new("UIPadding", page)
    pp.PaddingTop = UDim.new(0, 8); pp.PaddingBottom = UDim.new(0, 10)
    pp.PaddingLeft = UDim.new(0, 8); pp.PaddingRight = UDim.new(0, 8)
    tabPages[name] = page
end

local function selectTab(name)
    for i, n in ipairs(TABS) do
        local on = n == name
        local b = tabButtons[n]
        TweenService:Create(b, TweenInfo.new(0.15), {
            BackgroundColor3 = on and Color3.fromRGB(80, 45, 170) or Color3.fromRGB(24, 24, 34),
        }):Play()
        b.TextColor3 = on and Color3.fromRGB(235, 235, 255) or Color3.fromRGB(140, 140, 175)
        tabPages[n].Visible = on
    end
end
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function() selectTab(name) end)
end

local function sectionOn(page, text, order)
    local f = Instance.new("Frame", page)
    f.Size = UDim2.new(1, 0, 0, 22)
    f.BackgroundTransparency = 1
    f.LayoutOrder = order
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = text:upper()
    l.TextColor3 = Color3.fromRGB(110, 110, 160)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    local div = Instance.new("Frame", f)
    div.Size = UDim2.new(1, 0, 0, 1)
    div.Position = UDim2.new(0, 0, 1, -1)
    div.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    div.BorderSizePixel = 0
end

local function toggleOn(page, label, default, accent, order, cb)
    local row = Instance.new("Frame", page)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(19, 19, 27)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(218, 218, 235)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local pill = Instance.new("Frame", row)
    pill.Size = UDim2.new(0, 38, 0, 20)
    pill.Position = UDim2.new(1, -48, 0.5, -10)
    pill.BackgroundColor3 = default and accent or Color3.fromRGB(45, 45, 62)
    pill.BorderSizePixel = 0
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", pill)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local state = default
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = state and accent or Color3.fromRGB(45,45,62)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)}):Play()
        cb(state)
    end)
end

local function sliderOn(page, label, minV, maxV, default, order, cb)
    local row = Instance.new("Frame", page)
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = Color3.fromRGB(19, 19, 27)
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.72, 0, 0, 24)
    lbl.Position = UDim2.new(0, 12, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(218, 218, 235)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local val = Instance.new("TextLabel", row)
    val.Size = UDim2.new(0.28, -12, 0, 24)
    val.Position = UDim2.new(0.72, 0, 0, 4)
    val.BackgroundTransparency = 1
    val.Text = tostring(default)
    val.TextColor3 = Color3.fromRGB(130, 130, 210)
    val.Font = Enum.Font.GothamBold
    val.TextSize = 11
    val.TextXAlignment = Enum.TextXAlignment.Right
    local track = Instance.new("Frame", row)
    track.Size = UDim2.new(1, -24, 0, 4)
    track.Position = UDim2.new(0, 12, 0, 36)
    track.BackgroundColor3 = Color3.fromRGB(38, 38, 58)
    track.BorderSizePixel = 0
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Size = UDim2.new((default - minV)/(maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(95, 95, 220)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local grab = Instance.new("TextButton", track)
    grab.Size = UDim2.new(1, 0, 0, 22)
    grab.Position = UDim2.new(0, 0, 0.5, -11)
    grab.BackgroundTransparency = 1
    grab.Text = ""
    local dragging = false
    grab.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local r = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local v = math.floor(minV + r * (maxV - minV))
            fill.Size = UDim2.new(r, 0, 1, 0)
            val.Text = tostring(v)
            cb(v)
        end
    end)
end

local function buttonOn(page, label, accent, order, cb)
    local btn = Instance.new("TextButton", page)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = accent or Color3.fromRGB(30, 30, 46)
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(235, 235, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(cb)
end

do
    local page = tabPages["ESP"]; local o = 0
    sectionOn(page, "ESP Options", o); o = o + 1
    toggleOn(page, "Show Murderer", CFG.esp.Murderer, COLORS.Murderer, o, function(v) CFG.esp.Murderer = v end); o = o + 1
    toggleOn(page, "Show Sheriff", CFG.esp.Sheriff, COLORS.Sheriff, o, function(v) CFG.esp.Sheriff = v end); o = o + 1
    toggleOn(page, "Show Innocents", CFG.esp.Innocent, COLORS.Innocent, o, function(v) CFG.esp.Innocent = v end); o = o + 1
end

do
    local page = tabPages["Aim"]; local o = 0
    sectionOn(page, "Assist", o); o = o + 1
    toggleOn(page, "Aim Assist", CFG.aimbot.enabled, Color3.fromRGB(255,180,50), o, function(v)
        CFG.aimbot.enabled = v
        if v then buildFOVCircle() end
    end); o = o + 1
    toggleOn(page, "FOV Circle", CFG.aimbot.showFOV, Color3.fromRGB(180,180,255), o, function(v)
        CFG.aimbot.showFOV = v
    end); o = o + 1
    sliderOn(page, "FOV radius", 30, 400, CFG.aimbot.fov, o, function(v)
        CFG.aimbot.fov = v
        if fovCircle then fovCircle.Radius = v end
    end); o = o + 1
    sliderOn(page, "Strength", 1, 40, 5, o, function(v) CFG.aimbot.strength = v / 100 end); o = o + 1
end

do
    local page = tabPages["Kill"]; local o = 0
    sectionOn(page, "Kill Remotes (server-gated)", o); o = o + 1
    buttonOn(page, "Kill Murderer", COLORS.Murderer, o, function() _G.N3xtMM2_KillMurderer() end); o = o + 1
    buttonOn(page, "Kill Sheriff", COLORS.Sheriff, o, function() _G.N3xtMM2_KillSheriff() end); o = o + 1
    toggleOn(page, "Purge Innocents (1 per 2s)", false, COLORS.Innocent, o, function(v)
        CFG.kill.purgeInnocents = v
        CFG.kill.lastPurge = 0
    end); o = o + 1
end

do
    local page = tabPages["Gun"]; local o = 0
    sectionOn(page, "Gun Teleport", o); o = o + 1
    buttonOn(page, "Teleport to Gun", Color3.fromRGB(60, 60, 110), o, teleportToGun); o = o + 1
    toggleOn(page, "Auto-TP to Gun", CFG.gunTP.enabled, Color3.fromRGB(90, 90, 200), o, function(v)
        CFG.gunTP.enabled = v
    end); o = o + 1
    toggleOn(page, "Auto-Pickup Gun", CFG.gunPickup.enabled, Color3.fromRGB(180, 120, 60), o, function(v)
        CFG.gunPickup.enabled = v
    end); o = o + 1
end

do
    local page = tabPages["Roles"]; local o = 0
    sectionOn(page, "Role Preference (next round)", o); o = o + 1
    local roleBtns = {}
    local function roleBtn(label, role, color)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = role == nil and Color3.fromRGB(100,100,140) or color
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.LayoutOrder = o
        btn.Text = label
        btn.TextColor3 = Color3.fromRGB(235, 235, 240)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        o = o + 1
        btn.MouseButton1Click:Connect(function()
            CFG.rolePreference = role
            if role then
                blastRoleRemotes(role)
                directWriteRole(role)
            end
            for _, b in ipairs(roleBtns) do b.BackgroundTransparency = 0.5 end
            btn.BackgroundTransparency = 0.05
        end)
        table.insert(roleBtns, btn)
    end
    roleBtn("Random (normal)", nil, Color3.fromRGB(100,100,140))
    roleBtn("Murderer", "Murderer", COLORS.Murderer)
    roleBtn("Sheriff", "Sheriff", COLORS.Sheriff)
    roleBtns[1].BackgroundTransparency = 0.05
end

do
    local page = tabPages["Misc"]; local o = 0
    sectionOn(page, "Player", o); o = o + 1
    toggleOn(page, "Invisibility (proper)", false, Color3.fromRGB(175,75,255), o, function(v)
        setInvisible(v)
    end); o = o + 1
    toggleOn(page, "Invincible (client)", CFG.invincible, Color3.fromRGB(255,120,120), o, function(v)
        CFG.invincible = v
        setMM2Invincible(v)
    end); o = o + 1
end

local collapsed = false
local fullH = 520
minBtn.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    minBtn.Text = collapsed and "+" or "-"
    TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
        Size = UDim2.new(0, 260, 0, collapsed and 42 or fullH)
    }):Play()
    contentHolder.Visible = not collapsed
    tabBar.Visible = not collapsed
end)

RunService.RenderStepped:Connect(function()
    if fovCircle then
        fovCircle.Visible = CFG.aimbot.enabled and CFG.aimbot.showFOV
        if fovCircle.Visible then
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
    end
    doAimbot()
end)

local timer = 0
RunService.Heartbeat:Connect(function(dt)
    timer = timer + dt
    if timer >= CFG.updateInterval then
        timer = 0
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                makeHighlight(p); makeBillboard(p)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) removeESP(p) end)

print("[N3xt-MM2 v4.0] loaded (tabbed UI)")
]==]

-- ============================================================
--  RIVALS SOURCE — stub (fill in later, separate file planned)
-- ============================================================
local RIVALS_SOURCE = [==[
-- PASTE RIVALS v10.1 SOURCE HERE
]==]

-- ============================================================
--  LAUNCHER UTILITY
-- ============================================================
local function Notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 2})
    end)
end
local function GetUIParent()
    if gethui then
        local ok, hui = pcall(gethui); if ok and hui then return hui end
    end
    local ok = pcall(function() return CoreGui.Name end)
    if ok then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end
local function Make(t, props, children)
    local inst = Instance.new(t)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end
local GetCenter = function()
    local v = Camera.ViewportSize
    return Vector2.new(v.X * 0.5, v.Y * 0.5)
end

local function BuildGrid(parent, w, h)
    local grid = Make("Frame", {
        Size = UDim2.fromOffset(w, h), BackgroundTransparency = 1,
        ClipsDescendants = true, ZIndex = 0, Parent = parent,
    })
    local d = CFG.GRID_DENSITY
    for x = 0, math.floor(w / d) do
        Make("Frame", { Size = UDim2.new(0, 1, 1, 0), Position = UDim2.fromOffset(x * d, 0),
            BackgroundColor3 = THEME.GRID_LINE, BackgroundTransparency = 0.82,
            BorderSizePixel = 0, ZIndex = 0, Parent = grid })
    end
    for y = 0, math.floor(h / d) do
        Make("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, y * d),
            BackgroundColor3 = THEME.GRID_LINE, BackgroundTransparency = 0.82,
            BorderSizePixel = 0, ZIndex = 0, Parent = grid })
    end
    return grid
end

-- [continues in BLOCK 2]
local function BuildSplash(parent)
    local splash = Make("Frame", {
        Size = UDim2.fromScale(1, 1), BackgroundColor3 = THEME.BG_DEEP,
        BorderSizePixel = 0, ZIndex = 100, Parent = parent,
    })
    BuildGrid(splash, 1920, 1080)
    local holder = Make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(420, 140), BackgroundTransparency = 1,
        ZIndex = 101, Parent = splash,
    })
    local logo = Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 78), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBlack, Text = "N3xt",
        TextColor3 = Color3.fromRGB(240, 240, 255),
        TextScaled = true, TextTransparency = 1, ZIndex = 102, Parent = holder,
    })
    Make("UITextSizeConstraint", {MaxTextSize = 76}, {Parent = logo})
    local tag = Make("TextLabel", {
        Position = UDim2.new(0, 0, 0, 82), Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "n3xt launcher · v7.6", TextColor3 = THEME.ACCENT,
        TextSize = 13, TextTransparency = 1, ZIndex = 102, Parent = holder,
    })
    TweenService:Create(logo, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
    task.wait(0.25)
    TweenService:Create(tag, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
    task.delay(2.0, function()
        TweenService:Create(logo, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(tag, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        TweenService:Create(splash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.55); splash:Destroy()
    end)
end

local function buildPreview()
    local lines = {
        {1, "<font color='#6a5e8c'>-- n3xt launcher state</font>"},
        {1, "local <font color='#8eb8ff'>CFG</font> = {"},
        {3, "<font color='#a88ef2'>movement</font> = {"},
        {3, "<font color='#e8e6f0'>  inf_jump</font> = <font color='#8ee0a0'>"..tostring(CFG.INF_JUMP).."</font>,"},
        {3, "<font color='#e8e6f0'>  noclip  </font> = <font color='#8ee0a0'>"..tostring(CFG.NOCLIP).."</font>,"},
        {3, "<font color='#e8e6f0'>  speed   </font> = <font color='#8ee0a0'>"..tostring(CFG.SPEED).."</font>,"},
        {3, "<font color='#e8e6f0'>  fly     </font> = <font color='#8ee0a0'>"..tostring(CFG.FLY).."</font>"},
        {3, "}"},
        {1, "  <font color='#a88ef2'>esp</font> = {"},
        {3, "<font color='#e8e6f0'>  enabled</font> = <font color='#8ee0a0'>"..tostring(CFG.ESP_ENABLED).."</font>,"},
        {3, "<font color='#e8e6f0'>  boxes  </font> = <font color='#8ee0a0'>"..tostring(CFG.ESP_BOXES).."</font>"},
        {3, "}"},
        {1, "  <font color='#a88ef2'>aimbot</font> = {"},
        {3, "<font color='#e8e6f0'>  armed </font> = <font color='#8ee0a0'>"..tostring(CFG.AIMBOT_ENABLED).."</font>,"},
        {3, "<font color='#e8e6f0'>  locked</font> = <font color='#8ee0a0'>"..tostring(CFG.AIMBOT_LOCK_STATE).."</font>,"},
        {3, "<font color='#e8e6f0'>  key   </font> = <font color='#f0c890'>'"..CFG.AIMBOT_LOCK_KEY.Name.."'</font>"},
        {3, "}"},
        {1, "}"},
    }
    local out, nums = "", ""
    for i, ln in ipairs(lines) do
        out = out .. string.rep("  ", ln[1] - 1) .. ln[2] .. "\n"
        nums = nums .. tostring(i) .. "\n"
    end
    return out, nums
end

local function MakeToggle(parent, label, getFn, setFn, order, onChange, refresh)
    local row = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0,
        LayoutOrder = order, Parent = parent,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 8)}, {Parent = row})
    Make("TextLabel", {
        Size = UDim2.new(1, -72, 1, 0), Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = label, TextColor3 = THEME.TEXT, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local pill = Make("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(38, 18),
        BackgroundColor3 = getFn() and THEME.ACCENT or Color3.fromRGB(42, 38, 60),
        BorderSizePixel = 0, Parent = row,
    })
    Make("UICorner", {CornerRadius = UDim.new(1, 0)}, {Parent = pill})
    local knob = Make("Frame", {
        Size = UDim2.fromOffset(12, 12),
        Position = getFn() and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.fromRGB(240, 240, 255),
        BorderSizePixel = 0, Parent = pill,
    })
    Make("UICorner", {CornerRadius = UDim.new(1, 0)}, {Parent = knob})
    local btn = Make("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", Parent = row,
    })
    local function render(on)
        TweenService:Create(pill, TweenInfo.new(0.15), {
            BackgroundColor3 = on and THEME.ACCENT or Color3.fromRGB(42, 38, 60)}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = on and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)}):Play()
    end
    btn.MouseButton1Click:Connect(function()
        local v = not getFn(); setFn(v); render(v)
        if onChange then pcall(onChange, v) end
        if refresh then refresh() end
    end)
end

local function MakeButton(parent, label, color, order, cb)
    local btn = Make("TextButton", {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = color or THEME.BTN_ACTIVE,
        BackgroundTransparency = 0.05, BorderSizePixel = 0,
        LayoutOrder = order, Text = label, TextColor3 = THEME.TEXT,
        Font = Enum.Font.GothamBold, TextSize = 12,
        AutoButtonColor = true, Parent = parent,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 8)}, {Parent = btn})
    btn.MouseButton1Click:Connect(cb)
end

local function MakeSlider(parent, label, minV, maxV, default, order, cb)
    local row = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0,
        LayoutOrder = order, Parent = parent,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 8)}, {Parent = row})
    Make("TextLabel", {
        Size = UDim2.new(0.65, -10, 0, 22), Position = UDim2.fromOffset(12, 4),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = label,
        TextColor3 = THEME.TEXT, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local val = Make("TextLabel", {
        Size = UDim2.new(0.35, -12, 0, 22), Position = UDim2.new(0.65, 0, 0, 4),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = tostring(default), TextColor3 = THEME.ACCENT, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = row,
    })
    local track = Make("Frame", {
        Size = UDim2.new(1, -24, 0, 3), Position = UDim2.new(0, 12, 0, 34),
        BackgroundColor3 = Color3.fromRGB(42, 38, 60), BorderSizePixel = 0, Parent = row,
    })
    Make("UICorner", {CornerRadius = UDim.new(1, 0)}, {Parent = track})
    local fill = Make("Frame", {
        Size = UDim2.new((default - minV) / math.max(1, maxV - minV), 0, 1, 0),
        BackgroundColor3 = THEME.ACCENT, BorderSizePixel = 0, Parent = track,
    })
    Make("UICorner", {CornerRadius = UDim.new(1, 0)}, {Parent = fill})
    local grab = Make("TextButton", {
        Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0.5, -10),
        BackgroundTransparency = 1, Text = "", Parent = track,
    })
    local dragging = false
    grab.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local r = math.clamp((i.Position.X - track.AbsolutePosition.X) /
                                 math.max(1, track.AbsoluteSize.X), 0, 1)
            local v = math.floor(minV + r * (maxV - minV))
            fill.Size = UDim2.new(r, 0, 1, 0); val.Text = tostring(v); cb(v)
        end
    end)
end

local function MakeSectionLabel(parent, text, order)
    return Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold, Text = string.upper(text),
        TextColor3 = THEME.TEXT_DIM, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = order, Parent = parent,
    })
end

-- ============================================================
--  LAUNCHER ESP
-- ============================================================
local function espClear()
    for _, g in pairs(State.ESP) do
        for _, o in pairs(g) do pcall(function() o:Remove() end) end
        for k in pairs(g) do g[k] = nil end
    end
end
local function espUpdate()
    espClear()
    if not CFG.ESP_ENABLED or not HAS_DRAWING then return end
    local myTeam = LocalPlayer.Team
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not CFG.ESP_TEAM_CHECK or p.Team ~= myTeam then
                local hrp  = p.Character:FindFirstChild("HumanoidRootPart")
                local head = p.Character:FindFirstChild("Head")
                local hum  = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and head and hum and hum.Health > 0 then
                    local sp, on   = Camera:WorldToViewportPoint(hrp.Position)
                    local hsp, hon = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    if on and hon then
                        local h = math.abs(hsp.Y - sp.Y) * 1.9
                        local w = h * 0.55
                        if CFG.ESP_BOXES then
                            local b = Drawing.new("Square")
                            b.Thickness = 1; b.Color = CFG.ESP_COLOR
                            b.Filled = false; b.Size = Vector2.new(w, h)
                            b.Position = Vector2.new(sp.X - w/2, sp.Y - h * 0.75)
                            b.Visible = true
                            table.insert(State.ESP.boxes, b)
                        end
                        if CFG.ESP_LINES then
                            local l = Drawing.new("Line")
                            l.Thickness = 1; l.Color = CFG.ESP_COLOR
                            l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            l.To = Vector2.new(sp.X, sp.Y + h/2)
                            l.Visible = true
                            table.insert(State.ESP.lines, l)
                        end
                        if CFG.ESP_NAMES then
                            local n = Drawing.new("Text")
                            n.Size = 12; n.Center = true; n.Outline = true
                            n.OutlineColor = Color3.fromRGB(0,0,0); n.Color = CFG.ESP_COLOR
                            n.Text = p.Name
                            n.Position = Vector2.new(sp.X, sp.Y - h * 0.75 - 14)
                            n.Visible = true
                            table.insert(State.ESP.names, n)
                        end
                    end
                end
            end
        end
    end
end

-- ============================================================
--  LAUNCHER AIMBOT
-- ============================================================
local function aimbotInstallHook()
    if State.AIM.hookInstalled then return end
    pcall(function()
        local mt = getrawmetatable(Camera); if not mt then return end
        State.AIM.origNewindex = mt.__newindex
        setreadonly(mt, false)
        local wrap = (typeof(newcclosure) == "function") and newcclosure or function(fn) return fn end
        mt.__newindex = wrap(function(self, k, v)
            if self == Camera and CFG.AIMBOT_ENABLED and State.AIM.lockedTarget and not State.AIM.bypassHook then
                if k == "CameraType" then return State.AIM.origNewindex(self, k, Enum.CameraType.Scriptable) end
                if k == "CFrame" and State.AIM.desiredCF ~= nil then return State.AIM.origNewindex(self, k, State.AIM.desiredCF) end
            end
            return State.AIM.origNewindex(self, k, v)
        end)
        setreadonly(mt, true); State.AIM.hookInstalled = true
    end)
end
local function aimbotUninstallHook()
    if not State.AIM.hookInstalled then return end
    pcall(function()
        local mt = getrawmetatable(Camera)
        if mt and State.AIM.origNewindex then
            setreadonly(mt, false); mt.__newindex = State.AIM.origNewindex; setreadonly(mt, true)
        end
    end)
    State.AIM.hookInstalled = false; State.AIM.lockedTarget = nil; State.AIM.desiredCF = nil
end
local function aimbotBuildFOV()
    if not HAS_DRAWING then return end
    if State.AIM.fovCircle then pcall(function() State.AIM.fovCircle:Remove() end) end
    local ok, c = pcall(function()
        local circ = Drawing.new("Circle")
        circ.Color = THEME.ACCENT; circ.Radius = CFG.AIMBOT_FOV
        circ.Thickness = 1.2; circ.Filled = false; circ.Transparency = 0.7
        circ.Visible = false; return circ
    end)
    if ok then State.AIM.fovCircle = c end
end
local function aimbotBoneOf(model)
    for _, name in ipairs(CFG.AIMBOT_BONE_PRIORITY) do
        local part = model:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
end
local function aimbotPickTarget()
    local center = GetCenter(); local myTeam = LocalPlayer.Team
    local best, bestPart, bestDist = nil, nil, CFG.AIMBOT_FOV
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if not CFG.AIMBOT_TEAM_CHECK or p.Team ~= myTeam then
                local part = aimbotBoneOf(p.Character)
                local hum  = p.Character:FindFirstChildOfClass("Humanoid")
                if part and hum and hum.Health > 0 then
                    local sp, on = Camera:WorldToViewportPoint(part.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bestDist then bestDist = d; best = p; bestPart = part end
                    end
                end
            end
        end
    end
    return best, bestPart
end
local function aimbotMouselock(camCF, targetPos)
    if not CFG.AIMBOT_MOUSELOCK or not mousemoverel then return end
    local worldDir = targetPos - camCF.Position
    if worldDir.Magnitude < 0.001 then return end
    worldDir = worldDir.Unit
    if camCF.LookVector:Dot(worldDir) <= 0 then return end
    local hA = math.asin(math.clamp(camCF.RightVector:Dot(worldDir), -1, 1))
    local vA = math.asin(math.clamp(camCF.UpVector:Dot(worldDir), -1, 1))
    local ppr = Camera.ViewportSize.X / (2 * math.pi)
    local f = math.clamp(CFG.AIMBOT_SMOOTH * 1.6, 0.05, 1)
    pcall(mousemoverel, hA * ppr * f, -vA * ppr * f)
end
local function aimbotTick()
    local armed  = CFG.AIMBOT_ENABLED
    local locked = armed and CFG.AIMBOT_LOCK_STATE
    if State.AIM.fovCircle then
        State.AIM.fovCircle.Position = GetCenter()
        State.AIM.fovCircle.Visible = armed
    end
    if not armed then
        if State.AIM.lockedTarget then
            State.AIM.lockedTarget = nil; State.AIM.desiredCF = nil
            aimbotUninstallHook()
            if State.AIM.origCamType then
                State.AIM.bypassHook = true
                Camera.CameraType = State.AIM.origCamType
                State.AIM.bypassHook = false
            end
        end
        return
    end
    if not State.AIM.origCamType then State.AIM.origCamType = Camera.CameraType end
    if not locked then
        if State.AIM.lockedTarget then
            State.AIM.lockedTarget = nil; State.AIM.desiredCF = nil; aimbotUninstallHook()
        end
        return
    end
    local target, targetPart = aimbotPickTarget()
    if not target then State.AIM.lockedTarget = nil; State.AIM.desiredCF = nil; return end
    State.AIM.lockedTarget = target
    if CFG.AIMBOT_BYPASS then aimbotInstallHook() end
    local camCF   = Camera.CFrame
    local desired = CFrame.lookAt(camCF.Position, targetPart.Position)
    local smooth  = math.clamp(CFG.AIMBOT_SMOOTH, 0, 1)
    local blend   = (smooth <= 0.001) and desired or camCF:Lerp(desired, smooth)
    State.AIM.desiredCF = blend
    State.AIM.bypassHook = true
    pcall(function() Camera.CameraType = Enum.CameraType.Scriptable end)
    Camera.CFrame = blend
    State.AIM.bypassHook = false
    aimbotMouselock(camCF, targetPart.Position)
end

-- ============================================================
--  LAUNCHER APPEARANCE
-- ============================================================
local function appClear()
    for _, i in pairs(State.APP.instances) do pcall(function() i:Destroy() end) end
    State.APP.instances = {}
end
local function appApply()
    appClear()
    local char = LocalPlayer.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if CFG.APP_FIRE and hrp then
        local f = Instance.new("Fire"); f.Size = 5; f.Heat = 5; f.Parent = hrp
        table.insert(State.APP.instances, f)
    end
    if CFG.APP_HIGHLIGHT then
        local h = Instance.new("Highlight"); h.FillColor = THEME.PURPLE
        h.OutlineColor = THEME.PURPLE
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = char; h.Parent = char
        table.insert(State.APP.instances, h)
    end
    if CFG.APP_SMOKE and hrp then
        local s = Instance.new("Smoke"); s.Size = 3; s.RiseVelocity = 2; s.Opacity = 0.4
        s.Parent = hrp; table.insert(State.APP.instances, s)
    end
    if CFG.APP_SPARKLES and hrp then
        local s = Instance.new("Sparkles"); s.SparkleColor = THEME.ACCENT; s.Parent = hrp
        table.insert(State.APP.instances, s)
    end
    if CFG.APP_FORCEFIELD then
        local ff = Instance.new("ForceField"); ff.Visible = true; ff.Parent = char
        table.insert(State.APP.instances, ff)
    end
    if CFG.APP_4D and hrp then
        local bg = Instance.new("BillboardGui")
        bg.Size = UDim2.fromOffset(80, 80); bg.AlwaysOnTop = true
        bg.Adornee = hrp; bg.Parent = hrp
        local img = Instance.new("ImageLabel", bg)
        img.Size = UDim2.fromScale(1, 1); img.BackgroundTransparency = 1
        table.insert(State.APP.instances, bg)
    end
    if CFG.APP_ZOMBIE and hum then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://180435571"
        pcall(function()
            local t = hum:LoadAnimation(anim); t:Play()
            table.insert(State.APP.instances, t)
        end)
    end
    if CFG.APP_INVISIBLE then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end
        end
    end
    if CFG.APP_NO_ARMS then
        for _, n in ipairs({"Left Arm","Right Arm","LeftUpperArm","RightUpperArm"}) do
            local a = char:FindFirstChild(n)
            if a and a:IsA("BasePart") then a.Transparency = 1; a.LocalTransparencyModifier = 1 end
        end
    end
end
local function appRestore()
    local char = LocalPlayer.Character
    if char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
        end
    end
    appClear()
end

-- ============================================================
--  LAUNCHER ETC
-- ============================================================
local function etcGodMode(on)
    local hum = State.Humanoid; if not hum then return end
    if on then
        hum.MaxHealth = math.max(hum.MaxHealth, 1000); hum.Health = hum.MaxHealth
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    else hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end
end
local function setInvincible(on)
    local hum = State.Humanoid
    if not hum then return end
    if on then
        if State.originalMaxHealth == nil then
            State.originalMaxHealth = hum.MaxHealth
        end
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        hum.MaxHealth = 1e6; hum.Health = 1e6
        Notify("N3xt", "Invincible ON (client)")
    else
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        if State.originalMaxHealth then
            hum.MaxHealth = State.originalMaxHealth
            State.originalMaxHealth = nil
        end
        if hum.Health > hum.MaxHealth then hum.Health = hum.MaxHealth end
        Notify("N3xt", "Invincible OFF")
    end
end
local function tickInvincible()
    if not CFG.ETC_INVINCIBLE then return end
    local hum = State.Humanoid
    if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end
end
local function etcAnchor(on)  if State.RootPart then State.RootPart.Anchored = on end end
local function etcRespawn()   if State.Humanoid then State.Humanoid.Health = 0 end end
local function etcFling(targetPlayer)
    targetPlayer = targetPlayer or LocalPlayer
    local char = targetPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(0, 0, 1e5); bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bv.Parent = hrp; task.delay(0.3, function() bv:Destroy() end)
end
local function etcBtools()
    local bp = LocalPlayer:FindFirstChild("Backpack"); if not bp then return end
    for _, n in ipairs({"Weld","Rope","Grab","Clone","Hammer","Fence","Remove"}) do
        local t = Instance.new("HopperBin"); t.Name = n; t.Parent = bp
    end
end
local function etcNoLegs(on)
    local char = LocalPlayer.Character; if not char then return end
    for _, n in ipairs({"Left Leg","Right Leg","LeftFoot","RightFoot","LeftUpperLeg","RightUpperLeg"}) do
        local leg = char:FindFirstChild(n)
        if leg and leg:IsA("BasePart") then
            if on then
                if State.originalLegs[leg] == nil then State.originalLegs[leg] = leg.Transparency end
                leg.Transparency = 1; leg.LocalTransparencyModifier = 1
            else
                leg.Transparency = State.originalLegs[leg] or 0
                leg.LocalTransparencyModifier = 0
            end
        end
    end
end
local function etcToggleNight()
    local c = Lighting.ClockTime
    Lighting.ClockTime  = (c > 12) and 2 or 14
    Lighting.Brightness = (c > 12) and 2 or 1
end
local function etcFlashlight(on)
    if not on then
        if State.flashlight then pcall(function() State.flashlight:Destroy() end); State.flashlight = nil end
        return
    end
    local char = LocalPlayer.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if not head then return end
    local l = Instance.new("SpotLight")
    l.Angle = 90; l.Range = 60; l.Brightness = 3; l.Face = Enum.NormalId.Front
    l.Parent = head; State.flashlight = l
end
local function etcHighHips(on)
    local hum = State.Humanoid; if not hum then return end
    hum.HipHeight = on and 5 or 2
end
local function etcFloat(on)
    local hrp = State.RootPart; if not hrp then return end
    local ex = hrp:FindFirstChild("N3xtFloat")
    if on then
        if not ex then
            local bf = Instance.new("BodyForce")
            bf.Name = "N3xtFloat"
            bf.Force = Vector3.new(0, workspace.Gravity * hrp.AssemblyMass, 0)
            bf.Parent = hrp
        end
    else if ex then ex:Destroy() end end
end
local function etcTPTool()
    local m = LocalPlayer:GetMouse(); local hrp = State.RootPart
    if m and m.Target and hrp then hrp.CFrame = CFrame.new(m.Hit.Position + Vector3.new(0, 3, 0)) end
end

-- ============================================================
--  LAUNCHER MENU
-- ============================================================
local previewRefresh = function() end

local function BuildMenu(parent)
    local W, H = 640, 460
    local main = Make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(W, H), BackgroundColor3 = THEME.BG_DEEP,
        BorderSizePixel = 0, Parent = parent,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 14)}, {Parent = main})
    Make("UIStroke", {Color = Color3.fromRGB(60, 50, 100), Thickness = 1, Transparency = 0.4}, {Parent = main})
    BuildGrid(main, W, H)

    local bar = Make("Frame", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = THEME.BG_BAR,
        BackgroundTransparency = 0.1, BorderSizePixel = 0, ZIndex = 3, Parent = main,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 14)}, {Parent = bar})
    Make("Frame", {
        Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = THEME.BG_BAR, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, ZIndex = 3, Parent = bar,
    })
    local minBtn = Make("TextButton", {
        Position = UDim2.fromOffset(14, 8), Size = UDim2.fromOffset(24, 24),
        BackgroundColor3 = Color3.fromRGB(40, 34, 60), BorderSizePixel = 0,
        Font = Enum.Font.GothamBold, Text = "−",
        TextColor3 = THEME.TEXT_DIM, TextSize = 14, ZIndex = 4, Parent = bar,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 7)}, {Parent = minBtn})
    local closeBtn = Make("TextButton", {
        Position = UDim2.fromOffset(46, 8), Size = UDim2.fromOffset(24, 24),
        BackgroundColor3 = Color3.fromRGB(40, 34, 60), BorderSizePixel = 0,
        Font = Enum.Font.GothamBold, Text = "✕",
        TextColor3 = THEME.TEXT_DIM, TextSize = 12, ZIndex = 4, Parent = bar,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 7)}, {Parent = closeBtn})
    closeBtn.MouseButton1Click:Connect(function() main:Destroy() end)

    local tabsRow = Make("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(280, 30), BackgroundTransparency = 1,
        ZIndex = 4, Parent = bar,
    })
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.Parent = tabsRow

    local tabNames = {"Executor","Scripts","Settings"}
    local tabButtons, tabPages = {}, {}
    local contentArea = Make("Frame", {
        Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -80),
        BackgroundTransparency = 1, ZIndex = 2, Parent = main,
    })
    local codePane = Make("Frame", {
        Position = UDim2.fromOffset(14, 14),
        Size = UDim2.new(0.52, -20, 1, -28),
        BackgroundColor3 = THEME.BG_EDITOR, BackgroundTransparency = 0.05,
        BorderSizePixel = 0, ZIndex = 2, Parent = contentArea,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 10)}, {Parent = codePane})
    Make("UIStroke", {Color = Color3.fromRGB(50, 42, 82), Thickness = 1, Transparency = 0.4}, {Parent = codePane})
    local icons = Make("Frame", {
        Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(80, 18),
        BackgroundTransparency = 1, ZIndex = 4, Parent = codePane,
    })
    for i, sym in ipairs({"🔍", "P", "▷"}) do
        Make("TextLabel", {
            Position = UDim2.fromOffset((i-1) * 22, 0), Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
            Text = sym, TextColor3 = THEME.TEXT_DIM, TextSize = 11,
            ZIndex = 4, Parent = icons,
        })
    end
    local nums = Make("TextLabel", {
        Position = UDim2.fromOffset(8, 34), Size = UDim2.fromOffset(24, 380),
        BackgroundTransparency = 1, Font = Enum.Font.Code,
        Text = "", TextColor3 = THEME.LINE_NUM, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 3, Parent = codePane,
    })
    local codeText = Make("TextLabel", {
        Position = UDim2.fromOffset(38, 34), Size = UDim2.new(1, -50, 1, -44),
        BackgroundTransparency = 1, Font = Enum.Font.Code,
        Text = "", TextColor3 = THEME.TEXT, TextSize = 12,
        RichText = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 3, Parent = codePane,
    })
    Make("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -6),
        Size = UDim2.new(1, -16, 0, 16), BackgroundTransparency = 1,
        Font = Enum.Font.Gotham, Text = "read-only preview",
        TextColor3 = THEME.TEXT_FAINT, TextSize = 10, ZIndex = 3, Parent = codePane,
    })
    previewRefresh = function()
        local body, numsText = buildPreview()
        codeText.Text = body; nums.Text = numsText
    end
    previewRefresh()

    local rightPane = Make("Frame", {
        Position = UDim2.new(0.52, 6, 0, 14),
        Size = UDim2.new(0.48, -20, 1, -28),
        BackgroundColor3 = THEME.BG_PANEL, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, ZIndex = 2, Parent = contentArea,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 10)}, {Parent = rightPane})
    Make("UIStroke", {Color = Color3.fromRGB(50, 42, 82), Thickness = 1, Transparency = 0.4}, {Parent = rightPane})

    local function newPage()
        local p = Make("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            ScrollBarThickness = 3, ScrollBarImageColor3 = THEME.ACCENT,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false, ZIndex = 3, Parent = rightPane,
        })
        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 10); pad.PaddingRight = UDim.new(0, 10)
        pad.PaddingTop = UDim.new(0, 10);  pad.PaddingBottom = UDim.new(0, 10)
        pad.Parent = p
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 6); lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Parent = p
        return p
    end
    for i, name in ipairs(tabNames) do
        local btn = Make("TextButton", {
            Size = UDim2.fromOffset(78, 24),
            BackgroundColor3 = i == 1 and THEME.ACCENT or Color3.fromRGB(30, 26, 46),
            BackgroundTransparency = i == 1 and 0 or 0.1,
            BorderSizePixel = 0, Font = Enum.Font.GothamMedium,
            Text = name, TextColor3 = i == 1 and THEME.BG_DEEP or THEME.TEXT_DIM,
            TextSize = 12, LayoutOrder = i, ZIndex = 5, Parent = tabsRow,
        })
        Make("UICorner", {CornerRadius = UDim.new(1, 0)}, {Parent = btn})
        table.insert(tabButtons, btn)
        tabPages[name] = newPage()
    end
    tabPages["Executor"].Visible = true
    local function selectTab(name)
        State.ActiveTab = name
        for i, n in ipairs(tabNames) do
            local on = n == name
            local b = tabButtons[i]
            TweenService:Create(b, TweenInfo.new(0.18), {
                BackgroundColor3 = on and THEME.ACCENT or Color3.fromRGB(30, 26, 46),
                BackgroundTransparency = on and 0 or 0.1,
            }):Play()
            b.TextColor3 = on and THEME.BG_DEEP or THEME.TEXT_DIM
            tabPages[n].Visible = on
        end
    end
    for i, name in ipairs(tabNames) do
        tabButtons[i].MouseButton1Click:Connect(function() selectTab(name) end)
    end

    local exec = tabPages["Executor"]
    local order = 0
    local function O() order += 1; return order end
    MakeSectionLabel(exec, "Movement", O())
    MakeToggle(exec, "Infinite Jump", function() return CFG.INF_JUMP end,
        function(v) CFG.INF_JUMP = v end, O(), nil, previewRefresh)
    MakeToggle(exec, "Noclip", function() return CFG.NOCLIP end,
        function(v) CFG.NOCLIP = v end, O(), function(on)
            if State.Character then
                for _, p in ipairs(State.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = on and false or (p.Name ~= "HumanoidRootPart") end
                end
            end
        end, previewRefresh)
    MakeToggle(exec, "Speed", function() return CFG.SPEED end,
        function(v) CFG.SPEED = v end, O(), function(on)
            if State.Humanoid then State.Humanoid.WalkSpeed = on and CFG.WALK_SPEED or 16 end
        end, previewRefresh)
    MakeToggle(exec, "Fly", function() return CFG.FLY end,
        function(v) CFG.FLY = v end, O(), function(on)
            if State.Humanoid then State.Humanoid.PlatformStand = on end
            if not on then State.FlyVelocity = Vector3.zero end
        end, previewRefresh)
    MakeSlider(exec, "Walk Speed", 16, 300, CFG.WALK_SPEED, O(), function(v)
        CFG.WALK_SPEED = v
        if CFG.SPEED and State.Humanoid then State.Humanoid.WalkSpeed = v end
    end)
    MakeSlider(exec, "Jump Power", 16, 500, CFG.JUMP_POWER, O(), function(v)
        CFG.JUMP_POWER = v
        if State.Humanoid then State.Humanoid.UseJumpPower = true; State.Humanoid.JumpPower = v end
    end)

    MakeSectionLabel(exec, "ESP", O())
    MakeToggle(exec, "ESP", function() return CFG.ESP_ENABLED end,
        function(v)
            CFG.ESP_ENABLED = v
            if v and not HAS_DRAWING then Notify("N3xt", "no Drawing in this executor") end
        end, O(), nil, previewRefresh)
    MakeToggle(exec, "Boxes", function() return CFG.ESP_BOXES end,
        function(v) CFG.ESP_BOXES = v end, O(), nil, previewRefresh)
    MakeToggle(exec, "Lines", function() return CFG.ESP_LINES end,
        function(v) CFG.ESP_LINES = v end, O(), nil, previewRefresh)
    MakeToggle(exec, "Names", function() return CFG.ESP_NAMES end,
        function(v) CFG.ESP_NAMES = v end, O(), nil, previewRefresh)
    MakeToggle(exec, "Team Check", function() return CFG.ESP_TEAM_CHECK end,
        function(v) CFG.ESP_TEAM_CHECK = v end, O(), nil, previewRefresh)

    MakeSectionLabel(exec, "Aimbot (E = hard lock)", O())
    MakeToggle(exec, "Armed", function() return CFG.AIMBOT_ENABLED end,
        function(v)
            CFG.AIMBOT_ENABLED = v
            if v then
                if HAS_DRAWING then aimbotBuildFOV() end
            else aimbotUninstallHook() end
        end, O(), nil, previewRefresh)
    MakeToggle(exec, "Hard Lock", function() return CFG.AIMBOT_LOCK_STATE end,
        function(v) CFG.AIMBOT_LOCK_STATE = v end, O(), nil, previewRefresh)
    MakeToggle(exec, "Team Check", function() return CFG.AIMBOT_TEAM_CHECK end,
        function(v) CFG.AIMBOT_TEAM_CHECK = v end, O(), nil, previewRefresh)
    MakeToggle(exec, "Camera Bypass", function() return CFG.AIMBOT_BYPASS end,
        function(v) CFG.AIMBOT_BYPASS = v; if not v then aimbotUninstallHook() end end, O(), nil, previewRefresh)
    MakeToggle(exec, "Mouse Assist", function() return CFG.AIMBOT_MOUSELOCK end,
        function(v) CFG.AIMBOT_MOUSELOCK = v end, O(), nil, previewRefresh)
    MakeSlider(exec, "FOV", 30, 600, CFG.AIMBOT_FOV, O(), function(v)
        CFG.AIMBOT_FOV = v
        if State.AIM.fovCircle then State.AIM.fovCircle.Radius = v end
    end)
    MakeSlider(exec, "Smooth (0=snap)", 0, 100, math.floor(CFG.AIMBOT_SMOOTH * 100), O(),
        function(v) CFG.AIMBOT_SMOOTH = v / 100 end)

    MakeSectionLabel(exec, "Appearance", O())
    for _, row in ipairs({
        {"Fire","APP_FIRE"}, {"Highlight","APP_HIGHLIGHT"}, {"Smoke","APP_SMOKE"},
        {"Sparkles","APP_SPARKLES"}, {"No Arms","APP_NO_ARMS"}, {"Invisible","APP_INVISIBLE"},
        {"Forcefield","APP_FORCEFIELD"}, {"4D Character","APP_4D"}, {"Zombie Walk","APP_ZOMBIE"},
    }) do
        local key = row[2]
        MakeToggle(exec, row[1], function() return CFG[key] end,
            function(v) CFG[key] = v; appApply() end, O(), nil, previewRefresh)
    end
    MakeButton(exec, "Reset Appearance", Color3.fromRGB(60, 45, 110), O(), appRestore)

    MakeSectionLabel(exec, "Etc", O())
    MakeToggle(exec, "God Mode", function() return CFG.ETC_GODMODE end,
        function(v) CFG.ETC_GODMODE = v; etcGodMode(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "Invincible (client)", function() return CFG.ETC_INVINCIBLE end,
        function(v) CFG.ETC_INVINCIBLE = v; setInvincible(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "Anchor", function() return CFG.ETC_ANCHOR end,
        function(v) CFG.ETC_ANCHOR = v; etcAnchor(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "No Legs", function() return CFG.ETC_NO_LEGS end,
        function(v) CFG.ETC_NO_LEGS = v; etcNoLegs(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "High Hips", function() return CFG.ETC_HIGH_HIPS end,
        function(v) CFG.ETC_HIGH_HIPS = v; etcHighHips(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "Float", function() return CFG.ETC_FLOAT end,
        function(v) CFG.ETC_FLOAT = v; etcFloat(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "Flashlight", function() return CFG.ETC_FLASHLIGHT end,
        function(v) CFG.ETC_FLASHLIGHT = v; etcFlashlight(v) end, O(), nil, previewRefresh)
    MakeToggle(exec, "Ctrl+Click TP", function() return CFG.ETC_CTRL_CLICK_TP end,
        function(v) CFG.ETC_CTRL_CLICK_TP = v end, O(), nil, previewRefresh)
    MakeButton(exec, "Toggle Night", Color3.fromRGB(30, 24, 50), O(), etcToggleNight)
    MakeButton(exec, "Btools", Color3.fromRGB(30, 24, 50), O(), etcBtools)
    MakeButton(exec, "Respawn", Color3.fromRGB(120, 45, 45), O(), etcRespawn)
    MakeButton(exec, "TP Tool", Color3.fromRGB(60, 45, 110), O(), etcTPTool)
    MakeButton(exec, "Fling Self", Color3.fromRGB(80, 40, 40), O(), function() etcFling(LocalPlayer) end)
    MakeButton(exec, "Fling Nearest", Color3.fromRGB(90, 40, 40), O(), function()
        local myPos = State.RootPart and State.RootPart.Position
        if not myPos then return end
        local nearest, dist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - myPos).Magnitude
                    if d < dist then dist = d; nearest = p end
                end
            end
        end
        if nearest then etcFling(nearest) end
    end)
    MakeButton(exec, "Fling All", Color3.fromRGB(120, 40, 40), O(), function()
        task.spawn(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then etcFling(p); task.wait(0.05) end
            end
        end)
    end)

    local scripts = tabPages["Scripts"]
    local so = 0
    local function SO() so += 1; return so end
    MakeSectionLabel(scripts, "Game Hubs", SO())
    MakeButton(scripts, "Launch MM2 Hub", Color3.fromRGB(120, 45, 90), SO(), function()
        if #MM2_SOURCE < 100 then Notify("N3xt", "MM2 source is empty"); return end
        if State.MM2Loaded then Notify("N3xt", "MM2 already running"); return end
        if not HAS_LOADSTRING then Notify("N3xt", "no loadstring"); return end
        local chunk, err = loadstring(MM2_SOURCE, "=MM2")
        if not chunk then warn("[N3xt] mm2 compile: " .. tostring(err)); return end
        local ok, e = pcall(chunk)
        if ok then State.MM2Loaded = true else warn("[N3xt] mm2 runtime: " .. tostring(e)) end
    end)
    MakeButton(scripts, "Launch Rivals v10.1", Color3.fromRGB(60, 45, 140), SO(), function()
        if #RIVALS_SOURCE < 100 then Notify("N3xt", "Rivals source is empty"); return end
        if State.RivalsLoaded then Notify("N3xt", "Rivals already running"); return end
        if not HAS_LOADSTRING then Notify("N3xt", "no loadstring"); return end
        local chunk, err = loadstring(RIVALS_SOURCE, "=Rivals")
        if not chunk then warn("[N3xt] rivals compile: " .. tostring(err)); return end
        local ok, e = pcall(chunk)
        if ok then State.RivalsLoaded = true else warn("[N3xt] rivals runtime: " .. tostring(e)) end
    end)
    MakeSectionLabel(scripts, "Utility Loaders", SO())
    MakeButton(scripts, "Infinite Yield", Color3.fromRGB(80, 45, 170), SO(), function()
        if not HAS_LOADSTRING then return end
        local ok, chunk = pcall(loadstring,
            'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()')
        if ok and chunk then pcall(chunk) end
    end)
    MakeButton(scripts, "Dex Explorer", Color3.fromRGB(80, 45, 170), SO(), function()
        if not HAS_LOADSTRING then return end
        local ok, chunk = pcall(loadstring,
            'loadstring(game:HttpGet("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"))()')
        if ok and chunk then pcall(chunk) end
    end)

    local settings = tabPages["Settings"]
    local po = 0
    local function PO() po += 1; return po end
    MakeSectionLabel(settings, "Diagnostics", PO())
    Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Font = Enum.Font.Gotham,
        Text = "Drawing: " .. (HAS_DRAWING and "available" or "MISSING"),
        TextColor3 = HAS_DRAWING and THEME.READY_GREEN or Color3.fromRGB(230, 100, 100),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = PO(), Parent = settings,
    })
    Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Font = Enum.Font.Gotham,
        Text = "loadstring: " .. (HAS_LOADSTRING and "available" or "MISSING"),
        TextColor3 = HAS_LOADSTRING and THEME.READY_GREEN or Color3.fromRGB(230, 100, 100),
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = PO(), Parent = settings,
    })
    Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Font = Enum.Font.Gotham,
        Text = "MM2 source: " .. (#MM2_SOURCE < 100 and "empty stub" or "loaded"),
        TextColor3 = #MM2_SOURCE < 100 and Color3.fromRGB(230, 100, 100) or THEME.READY_GREEN,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = PO(), Parent = settings,
    })
    Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Font = Enum.Font.Gotham,
        Text = "Rivals source: " .. (#RIVALS_SOURCE < 100 and "empty stub" or "loaded"),
        TextColor3 = #RIVALS_SOURCE < 100 and Color3.fromRGB(230, 100, 100) or THEME.READY_GREEN,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = PO(), Parent = settings,
    })

    MakeSectionLabel(settings, "Keybinds", PO())
    for _, row in ipairs({
        {"Hard Lock", "E"}, {"Infinite Jump", "Space"},
        {"Fly", "WASD + Space / LCtrl"}, {"Ctrl+Click TP", "Ctrl + LMB"},
    }) do
        Make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = THEME.BTN_BG,
            BackgroundTransparency = 0.15, BorderSizePixel = 0, Font = Enum.Font.Gotham,
            Text = row[1] .. ":  " .. row[2], TextColor3 = THEME.TEXT, TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = PO(), Parent = settings,
        })
    end

    MakeSectionLabel(settings, "About", PO())
    Make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60), BackgroundColor3 = THEME.BTN_BG,
        BackgroundTransparency = 0.15, BorderSizePixel = 0, Font = Enum.Font.Gotham,
        Text = "N3xt launcher v7.6\nloaded for " .. LocalPlayer.Name,
        TextColor3 = THEME.TEXT_DIM, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        LayoutOrder = PO(), Parent = settings,
    })

    local status = Make("Frame", {
        Position = UDim2.new(0, 0, 1, -34), Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = THEME.BG_BAR, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, ZIndex = 3, Parent = main,
    })
    Make("UICorner", {CornerRadius = UDim.new(0, 14)}, {Parent = status})
    Make("Frame", {
        Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = THEME.BG_BAR, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, ZIndex = 3, Parent = status,
    })
    local statusText = Make("TextLabel", {
        Position = UDim2.fromOffset(20, 0), Size = UDim2.new(1, -40, 1, 0),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "Ready", TextColor3 = THEME.READY_GREEN,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4, Parent = status,
    })
    State.UI.setStatus = function(txt, col)
        statusText.Text = txt
        statusText.TextColor3 = col or THEME.READY_GREEN
    end
    State.UI.setStatus(
        "Ready  ·  Drawing: " .. (HAS_DRAWING and "yes" or "no") ..
        "  ·  loadstring: " .. (HAS_LOADSTRING and "yes" or "no") ..
        "  ·  MM2: " .. (#MM2_SOURCE < 100 and "empty" or "ok") ..
        "  ·  Rivals: " .. (#RIVALS_SOURCE < 100 and "empty" or "ok"),
        THEME.READY_GREEN)

    local dragging, dragStart, startPos
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging, dragStart, startPos = true, input.Position, main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                       startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        minBtn.Text = minimized and "+" or "−"
        TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {
            Size = minimized and UDim2.fromOffset(W, 40) or UDim2.fromOffset(W, H)
        }):Play()
        contentArea.Visible = not minimized
        status.Visible = not minimized
    end)
end

-- ============================================================
--  CHARACTER + LOOPS
-- ============================================================
local function OnCharacter(char)
    State.Character = char
    State.Humanoid  = char:WaitForChild("Humanoid", 5)
    State.RootPart  = char:WaitForChild("HumanoidRootPart", 5)
    if State.Humanoid then
        pcall(function()
            State.Humanoid.UseJumpPower = true
            State.Humanoid.JumpPower = CFG.JUMP_POWER
        end)
        if CFG.ETC_INVINCIBLE then task.wait(0.4); setInvincible(true) end
    end
end
local function ApplyNoclip()
    if not State.Character then return end
    for _, p in ipairs(State.Character:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
    end
end
local function InfJump()
    if not CFG.INF_JUMP or not State.Humanoid then return end
    if State.Humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
        State.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end
local function UpdateFly(dt)
    if not CFG.FLY or not State.RootPart then State.FlyVelocity = Vector3.zero; return end
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
    if dir.Magnitude > 0 then dir = dir.Unit end
    State.FlyVelocity = State.FlyVelocity:Lerp(dir * CFG.FLY_SPEED, math.clamp(dt*10, 0, 1))
    State.RootPart.AssemblyLinearVelocity = State.FlyVelocity
end
local function UpdateGodMode()
    if not CFG.ETC_GODMODE then return end
    local hum = State.Humanoid
    if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
end

-- ============================================================
--  BOOT
-- ============================================================
local uiParent = GetUIParent()
local screenGui = Make("ScreenGui", {
    Name = "N3xtUI", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = uiParent,
})
if syn and syn.protect_gui then pcall(function() syn.protect_gui(screenGui) end) end
BuildSplash(screenGui)
task.delay(2.6, function() BuildMenu(screenGui) end)

_G.N3xt_Reopen = function()
    State.MM2Loaded = false; State.RivalsLoaded = false
    local old = uiParent:FindFirstChild("N3xtUI")
    if old then old:Destroy() end
    local newGui = Make("ScreenGui", {
        Name = "N3xtUI", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = uiParent,
    })
    if syn and syn.protect_gui then pcall(function() syn.protect_gui(newGui) end) end
    BuildMenu(newGui)
end

if LocalPlayer.Character then OnCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(OnCharacter)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then InfJump() end
    if input.KeyCode == CFG.AIMBOT_LOCK_KEY then
        CFG.AIMBOT_LOCK_STATE = not CFG.AIMBOT_LOCK_STATE
        Notify("N3xt", "Hard lock " .. (CFG.AIMBOT_LOCK_STATE and "ON" or "OFF"))
        if State.UI.setStatus then
            State.UI.setStatus(
                "Hard lock " .. (CFG.AIMBOT_LOCK_STATE and "enabled" or "disabled"),
                CFG.AIMBOT_LOCK_STATE and THEME.ACCENT or THEME.READY_GREEN)
        end
        if previewRefresh then previewRefresh() end
    end
    if CFG.ETC_CTRL_CLICK_TP and
       input.UserInputType == Enum.UserInputType.MouseButton1 and
       UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
        local mouse = LocalPlayer:GetMouse(); local hrp = State.RootPart
        if mouse and mouse.Hit and hrp then hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)) end
    end
end)

RunService.RenderStepped:Connect(function()
    espUpdate()
    aimbotTick()
end)
RunService.Heartbeat:Connect(function(dt)
    if CFG.NOCLIP then ApplyNoclip() end
    if CFG.SPEED and State.Humanoid then State.Humanoid.WalkSpeed = CFG.WALK_SPEED
    elseif State.Humanoid and not CFG.SPEED then State.Humanoid.WalkSpeed = 16 end
    UpdateFly(dt)
    UpdateGodMode()
    tickInvincible()
end)

Notify("N3xt", "Launcher v7.6 loaded")
print("[N3xt launcher v7.6] ready")
