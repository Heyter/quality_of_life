local R, G, B, W = Color( 255, 0, 0 ), Color( 0, 255, 0 ), Color( 0, 0, 255 ), Color( 255, 255, 255 )

hook.Add( "TTTBeginRound", "RoleCount_TTTBeginRound", function()
	local TCount, DCount, ICount = 0, 0, 0

	for _, ply in ipairs( player.GetAll() ) do
		if ply:IsTerror() then
			if ply:GetTraitor() then TCount = TCount + 1
			elseif ply:GetDetective() then DCount = DCount + 1
			else ICount = ICount + 1
			end
		end
	end

	QoL.BroadcastMsg( W, "There ", TCount == 1 and "is " or "are ", R, tostring(TCount), " Traitor", TCount == 1 and "" or "s", W, ", " , B, tostring(DCount), " Detective", DCount == 1 and "" or "s", W, " and ", G, tostring(ICount), " Innocent", ICount == 1 and "" or "s", W, "." )
end )