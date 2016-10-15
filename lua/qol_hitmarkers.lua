if SERVER then
	AddCSLuaFile()
	util.AddNetworkString( "HitMarkerNet" )
	hook.Add( "PlayerHurt", "HitMatker_PlayerHurt", function( ply, attacker )
		if IsValid( attacker ) and attacker:IsPlayer() then
			net.Start( "HitMarkerNet" )
			net.Send( attacker )
		end
	end )
else
	local x, y = ScrW()/2, ScrH()/2
	local a

	local function DrawHitMarker()
		if not LocalPlayer():Alive() then return end

		local wep = LocalPlayer():GetActiveWeapon()
		local sights = (not wep.NoSights) and ( wep.GetIronsights and wep:GetIronsights() )
		local crosshair_size = GetConVarNumber( "ttt_crosshair_size", 1 )

		local scale = ( wep.GetPrimaryCone and math.max(0.2,  10 * wep:GetPrimaryCone()) ) or 0.3
		local gap = math.floor(15 * scale * (sights and 0.8 or 1))
		local length = math.floor( math.sqrt(gap) * 2 + (25 * crosshair_size * scale) )
		surface.SetDrawColor( 255, 255, 255, a )
		surface.DrawRect( x, y, 1, 1 )

		surface.DrawLine( x - length, y - length, x - gap, y - gap )
		surface.DrawLine( x + length, y - length, x + gap, y - gap )
		surface.DrawLine( x + length, y + length, x + gap, y + gap )
		surface.DrawLine( x - length, y + length, x - gap, y + gap )
	end

	net.Receive( "HitMarkerNet", function()
		hook.Add( "HUDPaint", "HitMarker_HUDPaint", DrawHitMarker )
		a = 200
		timer.Create( "HitMarkerFade", QoL.Config.HitMarkerTime/40, 40, function()
			a = a - 5
			if a < 10 then
				hook.Remove( "HUDPaint", "HitMarker_HUDPaint" )
			end
		end )
	end )
end