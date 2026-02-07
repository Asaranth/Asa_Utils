local _, AU = ...
local Feature = AU:NewModule("Cleanup", "AceConsole-3.0")

function Feature:OnEnable()
    self:RegisterChatCommand('clearquests', 'ShowClearQuestsPopup')
    self:RegisterChatCommand('clearbars', 'ShowClearBarsPopup')
end

function Feature:ShowClearQuestsPopup()
    StaticPopup_Show('ASA_CONFIRM_CLEAR_ALL_QUESTS')
end

function Feature:ShowClearBarsPopup()
    StaticPopup_Show('ASA_CONFIRM_CLEAR_ALL_BARS')
end
