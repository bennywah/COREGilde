-- Module der Ace Library laden --
PhoenixGilde  = LibStub("AceAddon-3.0"):NewAddon("PhoenixGilde", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0");

-- Einstellunsfenster erstellen mit Ace ...
local options = {
	type = "group",
	get = function(item) return PhoenixGilde.db.profile[item[#item]] end,
	set = function(item, value) PhoenixGilde.db.profile[item[#item]] = value end,
	args = {
		name = {
			order = 1,
			type = "input",
			name = "Dein Name (Mainchar / RL)",
			desc = "Dein Namen den Du gerne im Chat anzeigen lassen möchtest (Charkatername / RL)",
		},
		aktiv = {
			order = 2,
			type = "toggle",
			name = "Aktivieren",
			desc = "Das automatische Einsetzen Deines Names durch das Phoenix Addon aktivieren!",
		},
		entwickler = {
			order = 2,
			type = "toggle",
			name = "Entwickler-Modus Aktivieren",
			desc = "Das ist der Entwickler-Modus! Ich denke Den wirst Du nicht brauchen!",
		},
	},
}

-- Standardeinstellungen festlegen via ACE --
local defaults = {
	profile = {
		aktiv = true,
		entwickler = false;
	},
}

-- Slashoptions hinzufügen --
local SlashOptions = {
	type = "group",
	handler = PhoenixGilde,
	get = function(item) return PhoenixGilde.db.profile[item[#item]] end,
	set = function(item, value) PhoenixGilde.db.profile[item[#item]] = value end,
	args = {
		name = {
			type = "input",
			name = "Dein Name (Mainchar / RL)",
			desc = "Dein Namen den Du gerne im Chat anzeigen lassen möchtest (Charkatername / RL)",
		},
		aktiv = {
			type = "toggle",
			name = "Aktivieren",
			desc = "Das automatische Einsetzen Deines Names durch das Phoenix Addon aktivieren!",
		},
		entwickler = {
			type = "toggle",
			name = "Entwickler-Modus Aktivieren",
			desc = "Das ist der Entwickler-Modus! Ich denke Den wirst Du nicht brauchen!",
		},
	},
}

local SlashCmds = {
  "phoe",
};

-- Framework inkl. Einstellungen laden --
function PhoenixGilde:OnInitialize()

	self.db = LibStub("AceDB-3.0"):New("PhoenixGildeDB", defaults, "Default")
	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	local config = LibStub("AceConfig-3.0")
	config:RegisterOptionsTable("PhoenixGilde", SlashOptions, SlashCmds)
	local registry = LibStub("AceConfigRegistry-3.0")
	registry:RegisterOptionsTable("PhoenixGilde Options", options)
	registry:RegisterOptionsTable("PhoenixGilde Profiles", profiles);
	local dialog = LibStub("AceConfigDialog-3.0");
	self.optionFrames = {
		main = dialog:AddToBlizOptions(	"PhoenixGilde Options", "PhoenixGilde"),
		profiles = dialog:AddToBlizOptions(	"PhoenixGilde Profiles", "Profiles", "PhoenixGilde");
	}

	self:RawHook("SendChatMessage", true)
	self:Safe_Print("Geladen!")
end

-- Funktion zum hinzufügen des Namens --
function PhoenixGilde:SendChatMessage(msg, chatType, language, channel)
	if self.db.profile.aktiv then
		if msg == "!keys" then
			msg = msg
		else
			if self.db.profile.name and self.db.profile.name ~= "" then
					if  (chatType == "GUILD" or chatType == "OFFICER") or
						(self.db.profile.entwickler and chatType == "SAY")
					then
						msg = "[" .. self.db.profile.name .. "]: " .. msg
					end
			end
		end
	end
	self.hooks.SendChatMessage(msg, chatType, language, channel)
end

-- ACE Funktion zum erfolgreichen laden --
function PhoenixGilde:Safe_Print(msg)
		self:Print(msg)
end
