local addonName, AU = ...
LibStub('AceAddon-3.0'):NewAddon(AU, addonName, 'AceConsole-3.0', 'AceEvent-3.0')

function AU:OnInitialize()
    self.db = LibStub('AceDB-3.0'):New('AU_DB', {
        global = {
            DisableAutoAddSpells = true,
        },
    }, true)

    local options = self:GetSettings()

    -- Register the main Asa Suite category if it doesn't exist
    if not LibStub("AceConfigRegistry-3.0"):GetOptionsTable("|cFF047857Asa|r Suite") then
        LibStub("AceConfig-3.0"):RegisterOptionsTable("|cFF047857Asa|r Suite", {
            name = "|cFF047857Asa|r Suite",
            type = "group",
            args = {
                info = {
                    type = "description",
                    name = "Welcome to |cFF047857Asa|r Suite. Select a module from the menu on the left to configure its settings.",
                    order = 1,
                },
            },
        })
        LibStub("AceConfigDialog-3.0"):AddToBlizOptions("|cFF047857Asa|r Suite", "|cFF047857Asa|r Suite")
    end

    -- Register module's options as a sub-category
    LibStub("AceConfig-3.0"):RegisterOptionsTable("AU", options)
    self.optionsFrame, self.categoryID = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AU", "Utils", "|cFF047857Asa|r Suite")

    -- Ensure we have the parent category ID if possible
    if not self.categoryID and self.optionsFrame and self.optionsFrame.parent then
        self.categoryID = self.optionsFrame.parent
    end

    SetCVar('AutoPushSpellToActionBar', self.db.global.DisableAutoAddSpells and '0' or '1')
    _G['MAX_EQUIPMENT_SETS_PER_PLAYER'] = 100

    self:RegisterChatCommand('au', 'HandleSlashCommands')
    self:RegisterChatCommand('clearquests', function() StaticPopup_Show('ASA_CONFIRM_CLEAR_ALL_QUESTS') end)
    self:RegisterChatCommand('clearbars', function() StaticPopup_Show('ASA_CONFIRM_CLEAR_ALL_BARS') end)
end

function AU:HandleSlashCommands(input)
    if not input or input:trim() == '' then
        if Settings and Settings.OpenToCategory then
            if self.categoryID then
                Settings.OpenToCategory(self.categoryID)
            else
                Settings.OpenToCategory("|cFF047857Asa|r Suite")
            end
        elseif InterfaceOptionsFrame_OpenToCategory then
            InterfaceOptionsFrame_OpenToCategory("|cFF047857Asa|r Suite")
        end
    elseif input == 'help' then
        self:PrintHelp()
    else
        LibStub('AceConfigCmd-3.0'):HandleCommand('au', 'AU', input)
    end
end

function AU:PrintHelp()
    local commands = {
        { command = '/au help',      description = 'Displays this help message.' },
        { command = '/au',           description = 'Opens the configuration menu.' },
        { command = '/clearbars',    description = 'Clears all spells and items from your action bars.' },
        { command = '/clearquests',  description = 'Clears all quests in the quest log.' }
    }
    self:Print('Available commands:')
    for _, cmd in ipairs(commands) do
        self:Print(string.format('%s - %s', cmd.command, cmd.description))
    end
end
