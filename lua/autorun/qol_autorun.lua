include( "qol_config.lua" )

if SERVER then
	util.AddNetworkString( "QoL_Message" )
	QoL.BroadcastMsg = function( ... )
		net.Start( "QoL_Message" )
		net.WriteTable( { ... } )
		net.Broadcast()
	end

	local plymeta = FindMetaTable( "Player" )
	function plymeta:PlayerMsg( ... )
		net.Start( "QoL_Message" )
		net.WriteTable( { ... } )
		net.Send( self )
	end

	if QoL.Config.Rtv then include( "qol_rtv.lua" ) end
	if QoL.Config.AntiRadioSpam then include( "qol_antiradiospam.lua" ) end
	if QoL.Config.RoleCount then include( "qol_rolecount.lua" ) end
	if QoL.Config.ShowRole then AddCSLuaFile( "qol_showrole.lua" ) end
	if QoL.Config.BodyFound then include( "qol_bodyfound.lua" ) end
else
	net.Receive( "QoL_Message", function()
		chat.AddText( unpack( net.ReadTable() ) )
		chat.PlaySound()
	end )

	if QoL.Config.ShowRole then include( "qol_showrole.lua" ) end
end

if QoL.Config.HitMarkers then include( "qol_hitmarkers.lua" ) end