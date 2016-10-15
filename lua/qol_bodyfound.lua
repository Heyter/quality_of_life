local R, G, B, W = Color( 255, 0, 0 ), Color( 0, 255, 0 ), Color( 0, 0, 255 ), Color( 255, 255, 255 )

hook.Add( "TTTBodyFound", "BodyFound_TTTBodyFound", function( ply, body )
	if GetRoundState() ~= ROUND_ACTIVE then return end

	local Colour
	if IsValid( body ) and body:IsPlayer() then
		if body:GetTraitor() then Colour = Color( 255, 0, 0 )
		elseif body:GetDetective() then Colour = Color( 0, 0, 255 )
		else Colour = Color( 0, 255, 0 )
		end

		QoL.BroadcastMsg( Color( 128, 0, 255), ply:Nick(), Color( 255, 255, 255 ), " has found the body of ", Colour, body:Nick(), Color( 255,255,255 ), "." )
	else
		QoL.BroadcastMsg( Color( 128, 0,255), ply:Nick(), Color( 255, 255, 255 ), " has found the body of a disconnected player." )
	end
end )