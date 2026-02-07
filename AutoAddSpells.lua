local _, AU = ...
local Feature = AU:NewModule("AutoAddSpells", "AceEvent-3.0")

function Feature:OnInitialize()
    self:UpdateCVar()
end

function Feature:UpdateCVar()
    local val = AU.db.global.DisableAutoAddSpells
    SetCVar('AutoPushSpellToActionBar', val and '0' or '1')
end
