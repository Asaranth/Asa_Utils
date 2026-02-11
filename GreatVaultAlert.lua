local _, AU = ...
local Feature = AU:NewModule("GreatVaultAlert", "AceEvent-3.0", "AceTimer-3.0")

local alertedThisSession = false

function Feature:OnInitialize()
    if AU.db.global.EnableGreatVaultAlert == nil then
        AU.db.global.EnableGreatVaultAlert = true
    end
end

function Feature:OnEnable()
    -- Login/reload timing can be too early for weekly rewards data; listen to PEW and updates
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "OnPlayerEnteringWorld")
    self:RegisterEvent("WEEKLY_REWARDS_UPDATE", "OnWeeklyRewardsUpdate")

    -- Also do a delayed check shortly after enable as a fallback
    self:ScheduleTimer(function() self:CheckVault() end, 5)
end

local function Alert()
    RaidNotice_AddMessage(RaidWarningFrame, "You have unclaimed Great Vault rewards!", ChatTypeInfo["RAID_WARNING"])
    if C_Sound and C_Sound.PlaySound then
        C_Sound.PlaySound(12867)
    end
end

local function EnsureWeeklyRewardsLoaded()
    if not C_WeeklyRewards then
        if C_AddOns and C_AddOns.LoadAddOn then
            C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
        elseif UIParentLoadAddOn then
            UIParentLoadAddOn("Blizzard_WeeklyRewards")
        end
    end
end

function Feature:OnPlayerEnteringWorld()
    -- Defer slightly to let the server send weekly rewards info
    self:ScheduleTimer(function() self:CheckVault() end, 3)
end

function Feature:OnWeeklyRewardsUpdate()
    self:CheckVault()
end

function Feature:CheckVault()
    if alertedThisSession then return end
    if not AU.db.global.EnableGreatVaultAlert then return end

    EnsureWeeklyRewardsLoaded()

    if C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards and C_WeeklyRewards.HasAvailableRewards() then
        alertedThisSession = true
        self:ScheduleTimer(Alert, 1)
    end
end
