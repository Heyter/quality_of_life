local R, G, B, W = Color( 255, 0, 0 ), Color( 0, 255, 0 ), Color( 0, 0, 255 ), Color( 255, 255, 255 )

hook.Add( "TTTBeginRound", "ShowRole_TTTBeginRound", function()
	local ply = LocalPlayer()
	local x, y, z

	if ply:IsTerror() then
		if ply:GetRole() == ROLE_TRAITOR then
			x = "Traitor"
			z = R
		elseif ply:GetRole() == ROLE_DETECTIVE then
			x = "Detective"
			z = B
		else
			x = "Innocent"
			y = "an "
			z = G
		end

		timer.Simple( 1.2, function()
			chat.AddText( W, "You are ", y or "a ", z, x, W, ".")
		end )
	end
end )