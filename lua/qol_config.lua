AddCSLuaFile()
QoL = QoL or {} -- Don't touch this
QoL.Config = QoL.Config or {} -- Don't touch this

QoL.Config.ShowRole			= true	-- Print the player a message of their role in the beginning of the round

QoL.Config.RoleCount		= true	-- Print a role count in the beginning of the round

QoL.Config.BodyFound		= true	-- Announce to the chat when a player has found a body

QoL.Config.HitMarkers		= true	-- Include hitmarkers?
QoL.Config.HitMarkerTime	= 0.5	-- How long until the hitmarker is completely gone from the screen

QoL.Config.Rtv				= true	-- Include RTV system? Works on vanilla TTT, but also compatible with willox's mapvote (https://facepunch.com/showthread.php?t=1268353)
QoL.Config.RtvWaitTime		= 60	-- Time for a player to wait before voting again
QoL.Config.RtvRatio			= 0.65	-- Ratio of players that need to vote for the map to change

QoL.Config.AntiRadioSpam	= true	-- Enable anti radio (quickchat) spam?
QoL.Config.RadioSpamCount	= 3		-- How many radio uses to trigger anti-spam?
QoL.Config.RadioResetTime	= 2		-- How many seconds should pass before the spam count is reset to 0?
QoL.Config.RadioSpamTime	= 5		-- For how long should the radio be disabled?
QoL.Config.RadioSpamNotify	= true	-- Should the player get a chat message once the radio is enabled again?