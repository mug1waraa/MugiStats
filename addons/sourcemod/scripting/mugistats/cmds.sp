public Action Cmd_Stats(int iClient, int iArgs)
{
	if (IsValidClient(iClient))
		Menu_Stats(iClient);
	
	return Plugin_Handled;
}

public Action Cmd_StatsMe(int iClient, int iArgs)
{
	if (IsValidClient(iClient))
		PrintToChat(iClient, "%t", "Stats Me", g_iKills[iClient], g_iDeaths[iClient], float(g_iKills[iClient] / g_iDeaths[iClient]), g_iScore[iClient], g_iHeadShots[iClient], g_iAssists[iClient]);
	
	return Plugin_Handled;
}

public Action Cmd_Rank(int iClient, int iArgs)
{
	if (IsValidClient(iClient))
		g_hDatabase.Query(SQL_Rank, "SELECT * mugistats ORDER BY score DESC", GetClientUserId(iClient));
	
	return Plugin_Handled;
}