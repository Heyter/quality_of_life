-- Table for easier sorting
local RTV = {}

RTV.VoteShouldTakePlace = false
RTV.MapVotes = 0
RTV.VotesLeft = 0

-- Color presets
local Wcl, Ncl, Pcl, Ecl = Color( 255, 255, 255 ), Color( 231, 76, 60 ), Color( 0, 200, 0 ), Color( 255, 165, 0 )

local SubCommands = {
	"who",
	"check",
	"list",
	"left",
	"revoke",
}

local MapvoteInstalled = file.Exists( "mapvote", "LUA" )
local GetNonAFKPlayers = player.GetAll
if file.Exists( "ulx/modules/sh/aafk.lua", "LUA" ) then
	GetNonAFKPlayers = function()
		local NonAFKPlayers = player.GetAll()
		for key, ply in ipairs( NonAFKPlayers ) do
			if ply.afk then table.remove( NonAFKPlayers, key ) end
		end

		return NonAFKPlayers
	end
end

function RTV.Vote( ply )
	if ply.RTVLimit and CurTime() - ply.RTVLimit < QoL.Config.RtvWaitTime then --If the player already voted and it hasn't been 60 seconds..
		return ply:PlayerMsg( Color( 255, 165, 0 ), "You have to wait for another " .. math.ceil( QoL.Config.RtvWaitTime - (CurTime() - ply.RTVLimit) ) .. " seconds before using RTV again", true ) --Deny the vote
	elseif ply.Rocked then --If the player rocked the vote and hasn't revoked..
		return ply:PlayerMsg( Color( 255, 165, 0 ), "You have already rocked the vote", true ) --Deny the vote
	elseif RTV.VoteShouldTakePlace then --If there's a vote in progress..
		return ply:PlayerMsg( Color( 255, 165, 0 ), "There is already a vote in progress", true ) --Deny the vote
	end

	ply.RTVLimit = CurTime()
	ply.Rocked = true

	RTV.MapVotes = RTV.MapVotes + 1
	local NonAFKPlayers = GetNonAFKPlayers()
	RTV.Required = math.ceil( #NonAFKPlayers * QoL.Config.RtvRatio )
	RTV.VotesLeft = RTV.Required - RTV.MapVotes
	QoL.BroadcastMsg(  Wcl, "[", Ncl, "RTV", Wcl, "] ", Pcl, ply:Nick() .. " ", Wcl, "has rocked the vote! ", Color( 255, 255, 255 ), "(" .. RTV.VotesLeft .. " votes left)" )

	if RTV.MapVotes >= RTV.Required then
		RTV.StartVote()
	end
end

function RTV.Revoke( ply )
	if RTV.VoteShouldTakePlace then
		return ply:PlayerMsg( Color( 255, 165, 0 ), "You cannot revoke your vote as there is already a vote in progress", true )
	end

	if ply.Rocked then
		ply.Rocked = false

		RTV.MapVotes = RTV.MapVotes - 1
		local NonAFKPlayers = GetNonAFKPlayers()
		RTV.Required = math.ceil( #NonAFKPlayers * QoL.Config.RtvRatio )
		RTV.VotesLeft = RTV.Required - RTV.MapVotes
		QoL.BroadcastMsg(  Wcl, "[", Ncl, "RTV", Wcl, "] ", Pcl, ply:Nick() .. " ", Wcl, "has revoked his vote! ", Color( 255, 255, 255 ), "(" .. RTV.VotesLeft .. " votes left)" )
	else
		ply:PlayerMsg( Color( 255, 165, 0 ), "You cannot revoke your vote because you haven't voted yet.", true )
	end
end

function RTV.Check( ply )
	local NonAFKPlayers = GetNonAFKPlayers()
	RTV.Required = math.ceil( #NonAFKPlayers * QoL.Config.RtvRatio )
	RTV.VotesLeft = RTV.Required - RTV.MapVotes
	ply:PlayerMsg(  Wcl, "[", Ncl, "RTV", Wcl, "] ", Wcl, "There are " .. RTV.VotesLeft .. " votes needed to change map" )
end

function RTV.Who( ply )
	local Voted = {}
	local NotVoted = {}

	for _, ply in pairs( player.GetAll() ) do
		if ply.Rocked then
			table.insert( Voted, ply:Nick() )
		elseif not ply.afk then
			table.insert( NotVoted, ply:Nick() )
		end
	end

	local NonAFKPlayers = GetNonAFKPlayers()
	RTV.Required = math.ceil( #NonAFKPlayers * QoL.Config.RtvRatio )

	ply:PlayerMsg( Wcl, "[", Ncl, "RTV", Wcl, "] ", Wcl, RTV.Required .. " vote(s) needed to change maps." )
	ply:PlayerMsg( Wcl, "Voted (" .. #Voted .. "): " .. string.Implode( ", ", Voted ) )
	ply:PlayerMsg( Wcl, "Haven't Voted (" .. #NotVoted .. "): " .. string.Implode( ", ", NotVoted ) )
end

if MapvoteInstalled then
	RTV.DoRTV = function( skipTimer )
		LANG.Msg( "limit_vote" )

		timer.Stop( "end2prep" )
		if skipTimer then
			MapVote.Start( MapvoteSettings.Length, MapvoteSettings.AllowCurrent, MapvoteSettings.Limit, MapvoteSettings.Prefix )
		else
			timer.Simple( 3, function()
				MapVote.Start( MapvoteSettings.Length, MapvoteSettings.AllowCurrent, MapvoteSettings.Limit, MapvoteSettings.Prefix )
			end )
		end
	end
else
	RTV.DoRTV = function( skipTimer )
		local nextmap = string.upper(game.GetMapNext())
		LANG.Msg("limit_round", {mapname = nextmap})

		timer.Stop("end2prep")
		if skipTimer then
			timer.Simple(1, game.LoadNextMap)
		else
			timer.Simple(15, game.LoadNextMap)
		end
	end
end

function RTV.StartVote()
	if RTV.VoteShouldTakePlace then return end

	if #player.GetAll() == 1 then
		RTV.DoRTV( true )
		return
	end

	RTV.VoteShouldTakePlace = true
	QoL.BroadcastMsg( Wcl, "[", Ncl, "RTV", Wcl, "] A vote will take place at the end of this round" )
end

hook.Add( "PlayerDisconnect", "RemoveRTVFromDisconnectedPlayer", function( ply )
	if ply.Rocked then
		RTV.MapVotes = RTV.MapVotes - 1
	else
		local NonAFKPlayers = GetNonAFKPlayers()
		RTV.Required = math.ceil( #NonAFKPlayers * QoL.Config.RtvRatio )

		if RTV.MapVotes >= RTV.Required then
			RTV.StartVote()
		end
	end
end )

hook.Add( "PlayerSay", "RTV", function( ply, text )
	text = text:lower()
	if text == "!revoke" or text == "/revoke" then RTV.Revoke( ply ) return( "" ) end
	if text:sub( 1, 4 ) == "!rtv" or text:sub( 1, 4 ) == "/rtv" then

	local args = string.Split( text, " " )
	if not args[2] then RTV.Vote( ply ) return ""
	elseif args[2] == "who" or args[2] == "list" then RTV.Who( ply ) return ""
	elseif args[2] == "check" or args[2] == "left" then RTV.Check( ply ) return ""
	elseif args[2] == "revoke" then RTV.Revoke( ply ) return ""
	else ply:PlayerMsg( Color( 255, 165, 0 ), "'" .. args[2] .. "' is not a valid sub-command of the rtv command.\nValid: " .. string.Implode( ", ", SubCommands ) ) end
	return ""
	end
end )

hook.Add( "TTTEndRound", "RTV_Vote_End_Round", function()
	if RTV.VoteShouldTakePlace then
		RTV.DoRTV()
	end
end )