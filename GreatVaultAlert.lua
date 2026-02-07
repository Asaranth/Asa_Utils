local _, AU = ...
local Feature = AU:NewModule("GreatVaultAlert", "AceEvent-3.0", "AceTimer-3.0")

function Feature:OnInitialize()
    if AU.db.global.EnableGreatVaultAlert == nil then
        AU.db.global.EnableGreatVaultAlert = true
    end
end

function Feature:OnEnable()
    self:RegisterEvent("PLAYER_LOGIN", "CheckVault")
end

local function Alert()
    RaidNotice_AddMessage(RaidWarningFrame, "You have unclaimed Great Vault rewards!", ChatTypeInfo["RAID_WARNING"])
    C_Sound.PlaySound(12867)
end

function Feature:CheckVault()
    if not AU.db.global.EnableGreatVaultAlert then return end

    if not C_WeeklyRewards then UIParentLoadAddOn("Blizzard_WeeklyRewards") end
    if C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards() then
        self:ScheduleTimer(Alert, 3)
    end
end
