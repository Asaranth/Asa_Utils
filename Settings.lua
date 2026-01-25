local _, AU = ...

StaticPopupDialogs['ASA_CONFIRM_CLEAR_ALL_QUESTS'] = {
    text = "Do you want to clear all quests?\nType 'CONFIRM' into the field to confirm.",
    button1 = 'Yes',
    button2 = 'No',
    OnShow = function(self) self.button1:Disable() end,
    EditBoxOnTextChanged = function(self)
        if self:GetText():lower() == 'confirm' then self:GetParent().button1:Enable() else self:GetParent().button1:Disable() end
    end,
    OnAccept = function()
        for i = 1, C_QuestLog.GetNumQuestLogEntries() do
            C_QuestLog.SetSelectedQuest(C_QuestLog.GetInfo(i).questID)
            C_QuestLog.SetAbandonQuest()
            C_QuestLog.AbandonQuest()
        end
    end,
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3
}

StaticPopupDialogs['ASA_CONFIRM_CLEAR_ALL_BARS'] = {
    text = "Do you want to clear all action bars?\nType 'CONFIRM' into the field to confirm.",
    button1 = 'Yes',
    button2 = 'No',
    OnShow = function(self) self.button1:Disable() end,
    EditBoxOnTextChanged = function(self)
        if self:GetText():lower() == 'confirm' then self:GetParent().button1:Enable() else self:GetParent().button1:Disable() end
    end,
    OnAccept = function()
        for i = 1, 120 do PickupAction(i); PutItemInBackpack(); ClearCursor() end
    end,
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true, preferredIndex = 3
}

function AU:GetSettings()
    local options = {
        name = 'Utils',
        type = 'group',
        args = {
            general = {
                type = 'group',
                name = 'General Settings',
                inline = true,
                order = 1,
                args = {
                    DisableAutoAddSpells = {
                        type = 'toggle',
                        name = 'Disable Auto Add Spells',
                        desc = 'Prevent spells from being added to the actionbars automatically.',
                        set = function(_, val)
                            self.db.global.DisableAutoAddSpells = val
                            SetCVar('AutoPushSpellToActionBar', val and '0' or '1')
                        end,
                        get = function() return self.db.global.DisableAutoAddSpells end,
                        order = 1,
                    },
                },
            },
            actions = {
                type = 'group',
                name = 'Cleanup Actions',
                inline = true,
                order = 2,
                args = {
                    ClearQuests = {
                        type = 'execute',
                        name = 'Clear All Quests',
                        desc = 'Abandons all quests in your quest log.',
                        func = function() StaticPopup_Show('ASA_CONFIRM_CLEAR_ALL_QUESTS') end,
                        order = 1,
                    },
                    ClearBars = {
                        type = 'execute',
                        name = 'Clear Action Bars',
                        desc = 'Removes all spells and items from your action bars.',
                        func = function() StaticPopup_Show('ASA_CONFIRM_CLEAR_ALL_BARS') end,
                        order = 2,
                    },
                },
            },
        },
    }
    return options
end
