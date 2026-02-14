--[[
    Thormrand's OLED Saver - OLED Burn-in Prevention for WoW 3.3.5a
    Author: Thormrand
    Version: 1.2.0
    Description: Simple script to reduce the burns on your OLED screen.
]]

-- Configuration
local CONFIG = {
    AFK_TIMEOUT = 300,      -- Seconds of inactivity before blackout (5 minutes)
    UPDATE_INTERVAL = 0.05, -- Faster update for smoother movement.
    FACT_DURATION = 10,     -- Seconds to show each fact.
    TEXT_SPEED = 1.2,       -- Movement speed.
    DEBUG = false
}

-- Fact Database - Verified Facts and Legends from WoW History
local FACTS = {
    -- === VERIFIED VANILLA FACTS ===
    "FACT: Hunters originally used Mana for their abilities, not Focus, meaning they had to drink water like mages between fights.",
    "FACT: You had to manually level up weapon skills (e.g., Swords, Maces) by swinging at enemies; switching weapon types reset you to skill level 1.",
    "FACT: Flight paths were originally not connected; you had to land at every single stop and manually click the flight master to continue.",
    "FACT: Meeting stones outside dungeons originally did not summon players; they were just used to queue for a group finder system.",
    "FACT: Bosses originally had a hard limit of 8 (later 16) debuffs, meaning Hunters were often forbidden from using Serpent Sting in raids.",
    "FACT: Hunter pets would run away permanently if you didn't feed them enough to keep their happiness meter in the green.",
    "FACT: Hunters had to buy thousands of arrows or bullets, sacrificing an entire bag slot for a Quiver or Ammo Pouch.",
    "FACT: Warlocks had to farm Soul Shards from mobs before raids, and these shards did not stack, filling their entire inventory.",
    "FACT: Players kept lower ranks of spells on action bars to save mana (down-ranking), as max-rank spells were too costly for long fights.",
    "FACT: You couldn't get your first mount until level 40, and it cost 90 gold—a massive fortune at the time.",
    "FACT: Tauren male models were so large they literally could not fit through certain doors in Undercity and had issues in Molten Core.",
    "FACT: Rogues and Hunters could equip Bucklers (small shields) in the Alpha and early Beta versions of the game.",
    "FACT: You didn't need any Enchanting skill to disenchant items originally, leading to level 1 bank alts disenchanting raid epics.",
    "FACT: Scholomance and Stratholme were originally designed as 10-player raid dungeons, not 5-player instances.",
    "FACT: Upper Blackrock Spire (UBRS) was a 15-player raid dungeon for most of Vanilla, reduced to 10-man in patch 1.10.",
    "FACT: Only an estimated 1% or less of the total player base cleared the original Naxxramas raid before The Burning Crusade launched.",
    "FACT: C'Thun in the Temple of Ahn'Qiraj was mathematically impossible to kill at launch due to bugged tentacle spawn rates.",
    "FACT: A Paladin once one-shot Lord Kazzak using the Reckoning talent stacked endlessly on low-level mobs before engaging the boss.",
    "FACT: Hunters could kite Baron Geddon from Molten Core all the way to Stormwind, where he massacred low-level players.",
    "FACT: Baron Geddon's Living Bomb debuff could be transferred by Hunter pets into the Auction House, exploding and killing everyone inside.",
    "FACT: The Corrupted Blood pandemic from the Hakkar encounter escaped Zul'Gurub and killed thousands of players in major cities.",
    "FACT: The Suppression Room in Blackwing Lair originally respawned whelps almost instantly, making it a guild-breaking nightmare.",
    "FACT: The Alliance Onyxia attunement chain was incredibly long and included a disguise quest infiltrating Orgrimmar.",
    "FACT: Opening the Gates of Ahn'Qiraj required the entire server to collect millions of materials, taking weeks or months.",
    "FACT: The Scarab Lord title and Black Qiraji Battle Tank mount could only be obtained within a 10-hour window after the gates opened.",
    "FACT: Tier 2 pants originally dropped from Ragnaros in Molten Core because Blackwing Lair wasn't released yet.",
    "FACT: GM Island exists off the coast of Teldrassil and was used by Game Masters to teleport players for investigations.",
    "FACT: Mount Hyjal existed in vanilla game files and could be reached by wall-walking, complete with placeholder signs.",
    "FACT: Old Ironforge lies beneath the throne room in Ironforge—a fully modeled area accessible only by glitching through doors.",
    "FACT: The Karazhan Crypts contain cut content including the disturbing 'Upside-down Sinners' area with hanging corpses.",
    "FACT: A hidden Dancing Troll Village existed in the mountains between Moonglade and Darkshore, reachable by creative jumping.",
    "FACT: Azshara Crater was a fully planned battleground found in the game files but was never officially released.",
    "FACT: Large portions of the Emerald Dream zone existed in vanilla files, featuring strange flowery terrain.",
    "FACT: Thousand Needles was a dry canyon with a goblin and gnome race track before Cataclysm flooded it.",
    "FACT: The Deeprun Tram connecting Stormwind and Ironforge shows an ocean through the windows despite being underground.",
    "FACT: Spirit was found on almost all gear, including Warrior and Rogue armor, because health regeneration was crucial while leveling.",
    "FACT: Teebu's Blazing Longsword is an extremely rare world drop that glows like a lightsaber and remains highly sought after.",
    "FACT: The original epic mounts (Ivory Raptor, Teal Kodo) had no armor and were replaced, making the originals incredibly rare.",
    "FACT: Naxxramas required expensive Frost Resistance gear, making certain craftable green items worth hundreds of gold.",
    "FACT: Flask of Petrification turned you to stone and dropped all threat, used to survive wipes or cheese boss mechanics.",
    "FACT: The Luffa trinket, despite being low-level, was used by tanks in endgame raids to remove bleed effects.",
    
    -- === VERIFIED TBC FACTS ===
    "FACT: The Burning Crusade introduced flying mounts, but they only worked in Outland—not in Azeroth.",
    "FACT: Jewelcrafting was added in TBC, introducing gems and the first profession-exclusive epic gems for jewelcrafters.",
    "FACT: Paladins and Shamans were faction-exclusive until TBC: Alliance had Paladins, Horde had Shamans.",
    "FACT: Karazhan was the first 10-player raid, a significant shift from the 40-player raids of Vanilla.",
    "FACT: Attunement chains for TBC raids were extensive, requiring players to complete long dungeon and quest sequences.",
    "FACT: The 'Gruul the Dragonkiller' encounter featured a stacking debuff called 'Shatter' that could one-shot entire raids.",
    "FACT: Black Temple required players to complete a lengthy attunement chain including Karazhan, Serpentshrine, and Tempest Keep.",
    "FACT: Illidan Stormrage in Black Temple was famously defeated by guild 'Nihilum' after multiple days of progression.",
    "FACT: The original Zul'Aman bear mount required completing the timed run and saving all four prisoners in 45 minutes or less.",
    "FACT: Sunwell Plateau was released with pre-nerf M'uru, one of the hardest boss encounters ever designed.",
    "FACT: Kael'thas Sunstrider's fight in Tempest Keep featured five legendary weapons that players had to avoid or control.",
    "FACT: Heroic dungeons were introduced in TBC, offering harder versions with better loot and requiring Honored reputation.",
    "FACT: Daily quests were introduced in TBC, fundamentally changing how players earned gold and reputation.",
    "FACT: The Outland zones Hellfire Peninsula, Zangarmarsh, and Nagrand featured a completely alien aesthetic.",
    "FACT: Shattrath City had two major faction hubs: the Aldor and the Scryers, and you could only choose one.",
    
    -- === VERIFIED WOTLK FACTS ===
    "FACT: Death Knights started at level 55 with a full set of blue gear, making them the first hero class.",
    "FACT: The Wrathgate cinematic was the first major in-game cinematic event, featuring Bolvar Fordragon and Saurfang.",
    "FACT: Achievements were introduced in WotLK, adding meta-progression and mount/title rewards for completionists.",
    "FACT: Naxxramas was re-released as a level 80 raid in WotLK, now available in both 10-man and 25-man versions.",
    "FACT: Ulduar featured hard modes activated by special triggers during boss fights, not a separate difficulty selector.",
    "FACT: The Sarth 3D (Sartharion with 3 Drakes) fight was one of the hardest early WotLK challenges, rewarding the Twilight Drake.",
    "FACT: Wintergrasp was a world PvP zone where controlling the fortress determined access to the Vault of Archavon raid.",
    "FACT: The Argent Tournament introduced a daily quest hub with mounted jousting combat mechanics.",
    "FACT: Trial of the Crusader was the first raid to have four difficulty modes: 10/25 Normal and Heroic.",
    "FACT: Icecrown Citadel featured the Ashen Verdict reputation ring, which could be upgraded throughout the raid tier.",
    "FACT: The Lich King encounter had a hard enrage where Frostmourne wiped the raid, followed by a Tirion Fordring rescue cutscene.",
    "FACT: Onyxia was re-released as a level 80 raid for WoW's 5th anniversary, with updated loot and achievements.",
    "FACT: Emblems of Heroism, Valor, Conquest, and Triumph created a complex currency system that confused many players.",
    "FACT: The Ruby Sanctum was a small single-boss raid added late in WotLK to bridge the gap before Cataclysm.",
    "FACT: Dual Specialization was introduced in WotLK, allowing players to switch between two talent specs for a fee.",
    "FACT: The Looking For Dungeon (LFD) tool was added in patch 3.3, revolutionizing how players formed groups.",
    "FACT: Gearscore became a controversial addon that judged players solely on their item level, creating elitism.",
    "FACT: The Plague Quarter in Naxxramas featured Heigan the Unclean's 'Safety Dance,' a mechanic requiring precise movement.",
    "FACT: Mimiron in Ulduar was a four-phase encounter where you fought his head, body, and legs separately, then all together.",
    "FACT: Yogg-Saron with 0 Keepers (Alone in the Darkness) was considered impossible for months until guilds finally defeated it.",
    
    -- === LEGENDS (Unverified or Partially True) ===
    "LEGEND: Undead players supposedly had infinite underwater breathing in early development, but this was never in the live game.",
    "LEGEND: Undead could allegedly speak Common and communicate with Alliance in early Beta, but no solid evidence exists.",
    "LEGEND: Tauren were supposed to have 'Plainsrunning' instead of mounts, ramping up speed over time, but this was never implemented.",
    "LEGEND: A legendary necklace called 'Talisman of Binding Shard' supposedly dropped once due to a bug, but there's no proof.",
    "LEGEND: Goldshire was allegedly much larger in Beta, but Blizzard shrank it because players weren't exploring—no evidence confirms this.",
    "LEGEND: Ironfoe's proc was rumored to let players speak Dwarven, but the actual effect is just an extra attack.",
    "LEGEND: Martin Fury, a developer item that killed everything, was used to clear Ulduar—though this occurred in WotLK, not Vanilla.",
}

local T_OLEDSaver = CreateFrame("Frame", "T_OLEDSaverCore", UIParent)
T_OLEDSaver:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)

local lastInputTime = GetTime()
local timeSinceLastUpdate = 0
local timeSinceLastFact = 0
local isBlackoutActive = false
local lastMouseX, lastMouseY = GetCursorPosition()
local afkStartTime = 0

local Curtain = CreateFrame("Frame", "T_OLEDSaverCurtain", UIParent)
Curtain:SetFrameStrata("TOOLTIP")
Curtain:SetAllPoints(UIParent)
Curtain:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8X8" })
Curtain:SetBackdropColor(0, 0, 0, 1)
Curtain:EnableMouse(true)
Curtain:Hide()

local Floater = Curtain:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
Floater:SetTextColor(0.5, 0.5, 0.5, 1)
Floater:SetJustifyH("CENTER")
Floater:SetWidth(600)
Floater:SetWordWrap(true)
Floater:SetSpacing(4)

local floaterPhys = {
    x = 0,
    y = 0,
    dx = 1,
    dy = 1,
    speed = 1.0,
    limitX = 0,
    limitY = 0
}

local function DebugPrint(msg)
    if CONFIG.DEBUG then DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[T_OLEDSaver]|r " .. msg) end
end

local function RefreshLimits()
    local screenWidth = UIParent:GetWidth()
    local screenHeight = UIParent:GetHeight()
    floaterPhys.limitX = (screenWidth / 2) - (Floater:GetWidth() / 2)
    floaterPhys.limitY = (screenHeight / 2) - (Floater:GetHeight() / 2)

    if floaterPhys.limitX < 0 then floaterPhys.limitX = 0 end
    if floaterPhys.limitY < 0 then floaterPhys.limitY = 0 end
end

local function PickNewFact()
    local index = math.random(1, #FACTS)
    Floater:SetText(FACTS[index])
    RefreshLimits()
end

local function UpdateFloaterPosition()
    floaterPhys.x = floaterPhys.x + (floaterPhys.dx * floaterPhys.speed)
    floaterPhys.y = floaterPhys.y + (floaterPhys.dy * floaterPhys.speed)

    if floaterPhys.x > floaterPhys.limitX then
        floaterPhys.x = floaterPhys.limitX
        floaterPhys.dx = -1
    elseif floaterPhys.x < -floaterPhys.limitX then
        floaterPhys.x = -floaterPhys.limitX
        floaterPhys.dx = 1
    end

    -- Bounce Y
    if floaterPhys.y > floaterPhys.limitY then
        floaterPhys.y = floaterPhys.limitY
        floaterPhys.dy = -1
    elseif floaterPhys.y < -floaterPhys.limitY then
        floaterPhys.y = -floaterPhys.limitY
        floaterPhys.dy = 1
    end

    Floater:SetPoint("CENTER", Curtain, "CENTER", floaterPhys.x, floaterPhys.y)
end

local function ActivateBlackout()
    if isBlackoutActive then return end
    if UnitAffectingCombat("player") then return end

    isBlackoutActive = true
    afkStartTime = GetTime()
    Curtain:Show()
    DebugPrint("Blackout Activated")

    PickNewFact()
    timeSinceLastFact = 0

    floaterPhys.x = 0
    floaterPhys.y = 0
    floaterPhys.dx = (math.random() > 0.5) and 1 or -1
    floaterPhys.dy = (math.random() > 0.5) and 1 or -1
end

local function DeactivateBlackout()
    if not isBlackoutActive then return end

    isBlackoutActive = false
    Curtain:Hide()
    lastInputTime = GetTime()
    DebugPrint("Blackout Deactivated")
end

function T_OLEDSaver:PLAYER_FLAGS_CHANGED()
    if UnitIsAFK("player") then
        ActivateBlackout()
    else
        DeactivateBlackout()
    end
end

function T_OLEDSaver:PLAYER_REGEN_DISABLED()
    DeactivateBlackout()
end

function T_OLEDSaver:PLAYER_ENTERING_WORLD()
    self:RegisterEvent("PLAYER_FLAGS_CHANGED")
    self:RegisterEvent("PLAYER_REGEN_DISABLED")

    lastInputTime = GetTime()
    local x, y = GetCursorPosition()
    lastMouseX, lastMouseY = x, y
end

T_OLEDSaver:RegisterEvent("PLAYER_ENTERING_WORLD")

local totalElapsed = 0

T_OLEDSaver:SetScript("OnUpdate", function(self, elapsed)
    local currentTime = GetTime()
    totalElapsed = totalElapsed + elapsed

    local currentX, currentY = GetCursorPosition()
    if abs(currentX - lastMouseX) > 1 or abs(currentY - lastMouseY) > 1 then
        lastInputTime = currentTime
        lastMouseX, lastMouseY = currentX, currentY
        if isBlackoutActive then DeactivateBlackout() end
    end

    if not isBlackoutActive and not UnitAffectingCombat("player") then
        if (currentTime - lastInputTime) > CONFIG.AFK_TIMEOUT then
            ActivateBlackout()
        end
    end

    if isBlackoutActive then
        timeSinceLastUpdate = timeSinceLastUpdate + elapsed
        if timeSinceLastUpdate > CONFIG.UPDATE_INTERVAL then
            UpdateFloaterPosition()
            timeSinceLastUpdate = 0
        end

        timeSinceLastFact = timeSinceLastFact + elapsed
        if timeSinceLastFact > CONFIG.FACT_DURATION then
            PickNewFact()
            timeSinceLastFact = 0
        end
    end
end)

SLASH_T_OLEDSAVER1 = "/t_oledsaver"
SlashCmdList["T_OLEDSAVER"] = function(msg)
    if msg == "test" then
        ActivateBlackout()
    else
        DEFAULT_CHAT_FRAME:AddMessage("Thormrand's OLED Saver: /t_oledsaver test")
    end
end
