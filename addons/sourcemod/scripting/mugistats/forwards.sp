public void OnPluginStart()
{
	HookEvent("player_death", Event_Death);
	
	LoadTranslations("mugistats.phrases");
	
	RegConsoleCmd("sm_stats", Cmd_Stats);
	RegConsoleCmd("sm_statsme", Cmd_StatsMe);
	RegConsoleCmd("sm_rank", Cmd_Rank);
}

public void OnConfigsExecuted()
{
	Database.Connect(SQL_Connection, "mugistats");
}

public void OnClientPostAdminCheck(int iClient)
{
	if (IsValidClient(iClient))
		SQL_LoadClient(iClient);
}

public void OnClientDisconnect(int iClient)
{
	if (IsValidClient(iClient))
		SQL_UpdateClient(iClient);
}