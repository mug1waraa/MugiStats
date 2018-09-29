public Action Event_Death(Event hEvent, const char[] sName, bool bDontBroadcast)
{
	int iVictim = GetClientOfUserId(hEvent.GetInt("userid"));
	
	if (IsValidClient(iVictim))
	{
		int iAttacker = GetClientOfUserId(hEvent.GetInt("attacker"));
		
		if (IsValidClient(iAttacker))
		{
			int iAssister = GetClientOfUserId(hEvent.GetInt("assists"));
			
			if (IsValidClient(iAssister))
			{
				if (iVictim != iAttacker)
				{
					g_iScore[iAttacker] += 100;
					
					g_iKills[iAttacker]++;
					g_iDeaths[iVictim]++;
					
					if (hEvent.GetBool("headshot"))
						g_iHeadShots[iAttacker]++;
					
					g_iAssists[iAssister]++;
				}
			}
		}
	}
}