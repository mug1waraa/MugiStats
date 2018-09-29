public void SQL_Connection(Database hDatabase, const char[] sError, int iData)
{
	if (hDatabase == null)
		ThrowError(sError);
	
	else
	{
		g_hDatabase = hDatabase;
		
		g_hDatabase.Query(SQL_Error, "CREATE TABLE IF NOT EXISTS mugistats (name VARCHAR(32) NOT NULL, steamid VARCHAR(32) NOT NULL, score INT(11), kills INT(11), deaths INT(11), headshots INT(11), assists INT(11))");
	}
}

public void SQL_Error(Database hDatabase, DBResultSet hResults, const char[] sError, int iData)
{
	if (hResults == null)
		ThrowError(sError);
}

public void SQL_LoadClient(int iClient)
{
	if (IsValidClient(iClient))
	{
		GetClientAuthId(iClient, AuthId_Steam2, g_sSteamID[iClient], sizeof(g_sSteamID[]));
		
		char sQuery[256];
		Format(sQuery, sizeof(sQuery), "SELECT * FROM mugistats WHERE steamid = \"%s\"", g_sSteamID[iClient]);
		
		g_hDatabase.Query(SQL_ClientLoad, sQuery, GetClientUserId(iClient));
	}
}

public void SQL_ClientLoad(Database hDatabase, DBResultSet hResults, const char[] sError, int iData)
{
	if (hResults == null)
		ThrowError(sError);
	
	int iClient = GetClientOfUserId(iData);
	
	if (IsValidClient(iClient))
	{
		if (hResults.RowCount != 0)
		{
			hResults.FetchRow();
			
			g_iScore[iClient] = hResults.FetchInt(2);
			g_iKills[iClient] = hResults.FetchInt(3);
			g_iDeaths[iClient] = hResults.FetchInt(4);
			g_iHeadShots[iClient] = hResults.FetchInt(5);
			g_iAssists[iClient] = hResults.FetchInt(6);
		}
		
		else
		{
			char sQuery[256];
			Format(sQuery, sizeof(sQuery), "INSERT INTO mugistats (name, steamid, score, kills, deaths, headshots, assists) VALUES (\"%N\", \"%s\", %d, %d, %d, %d, %d)", iClient, g_sSteamID[iClient], g_iScore[iClient], g_iKills[iClient], g_iDeaths[iClient], g_iHeadShots[iClient], g_iAssists[iClient]);
			
			g_hDatabase.Query(SQL_Error, sQuery);
		}
	}
}

public void SQL_UpdateClient(int iClient)
{
	if (IsValidClient(iClient))
	{
		char sQuery[256];
		Format(sQuery, sizeof(sQuery), "UPDATE mugistats SET name = \"%N\", score = %d, kills = %d, deaths = %d, headshots = %d, assists = %d WHERE steamid = \"%s\"", iClient, g_iScore[iClient], g_iKills[iClient], g_iDeaths[iClient], g_iHeadShots[iClient], g_iAssists[iClient], g_sSteamID[iClient]);
		
		g_hDatabase.Query(SQL_Error, sQuery);
	}
}

public void SQL_Top(Database hDatabase, DBResultSet hResults, const char[] sError, int iData)
{
	if (hResults == null)
		ThrowError(sError);
	
	int iClient = GetClientOfUserId(iData);
	
	if (IsValidClient(iClient))
	{
		int iRank, iColumn, iStat;
		
		char sName[32];
		
		PrintToConsole(iClient, " ");
		PrintToChat(iClient, " ");
		
		while (hResults.FetchRow())
		{
			hResults.FetchString(0, sName, sizeof(sName));
			
			hResults.FieldNameToNum(g_sColumn[iClient], iColumn);
			
			iStat = hResults.FetchInt(iColumn);
			
			if (iRank <= 3)
				PrintToChat(iClient, "%t", "Top Chat", iRank, sName, iStat);
			
			PrintToConsole(iClient, "%t", "Top Console", iRank, sName, iStat);
			
			if (iRank++ == 15)
				break;
		}
		
		PrintToChat(iClient, " ");
		PrintToConsole(iClient, " ");
		
		for (int i = 0; i < sizeof(g_sColumn[]); i++)
			g_sColumn[iClient][i] = EOS;
	}
}

public void SQL_Rank(Database hDatabase, DBResultSet hResults, const char[] sError, int iData)
{
	if (hResults == null)
		ThrowError(sError);
	
	int iClient = GetClientOfUserId(iData);
	
	if (IsValidClient(iClient))
	{
		int iRank;
		
		char sSteamID[32];
		
		PrintToChat(iClient, " ");
		
		while (hResults.FetchRow())
		{
			iRank++;
			
			hResults.FetchString(1, sSteamID, sizeof(sSteamID));
			
			if (StrEqual(g_sSteamID[iClient], sSteamID))
				break;
		}
		
		PrintToChat(iClient, "%t", "Your Rank", iRank);
		PrintToChat(iClient, " ");
	}
}