local _, AU = ...
local Feature = AU:NewModule("EquipmentSets")

function Feature:OnInitialize()
    _G['MAX_EQUIPMENT_SETS_PER_PLAYER'] = 100
end
