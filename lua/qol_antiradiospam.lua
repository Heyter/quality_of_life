local W = Color( 255, 165, 0 )

hook.Add( "PlayerAuthed", "AntiRadioSpam_PlayerAuthed", function( ply )
	ply.RadioSpamCount = 0
	ply.LastRadio = 0
end )

hook.Add( "TTTPlayerRadioCommand", "AntiRadioSpam_TTTPlayerRadioCommand", function( ply )
	if ply.RadioSpam then
		ply:PlayerMsg( W, "Radio has been disabled for " .. QoL.Config.RadioSpamTime .. " seconds due to spam. " .. math.abs( math.ceil( 5 - CurTime() + ply.LastRadio )) .. " seconds left" )
		return true
	end

	if CurTime() - ply.LastRadio < QoL.Config.RadioResetTime then
		ply.RadioSpamCount = ply.RadioSpamCount + 1
		if ply.RadioSpamCount == QoL.Config.RadioSpamCount then
			timer.Simple( 0.05, function() ply:PlayerMsg( W, "You are flooding the chat!" ) end )
		elseif ply.RadioSpamCount > QoL.Config.RadioSpamCount then
			ply.RadioSpam = true
			timer.Simple( 5, function()
				if IsValid( ply ) then	-- He might've left by now
					ply.RadioSpam = false
					if QoL.Config.RadioSpamNotify then
						ply:PlayerMsg( W, "Radio has been re-enabled" )
					end
				end
			end )

			ply:PlayerMsg( W, "Radio has been disabled for " .. QoL.Config.RadioSpamTime .. " seconds due to spam. " .. math.ceil( 5 - CurTime() + ply.LastRadio ) .. " seconds left" )
			return true
		end
	else
		ply.RadioSpamCount = 1
	end

	ply.LastRadio = CurTime()
end )