public void Menu_Stats(int iClient)
{
	if (IsValidClient(iClient))
	{
		Menu hMenu = new Menu(Stats_Menu);
		
		hMenu.SetTitle("%t", "Stats Menu Title");
		
		hMenu.AddItem("", "Your Stats");
		hMenu.AddItem("", "Your Rank");
		hMenu.AddItem("score", "Top Score");
		hMenu.AddItem("kills", "Top Kills");
		hMenu.AddItem("headshots", "Top Headshots");
		hMenu.AddItem("assists", "Top Assists");
		
		hMenu.Display(iClient, MENU_TIME_FOREVER);
	}
}

public int Stats_Menu(Menu hMenu, MenuAction hAction, int iClient, int iParam)
{
	if (IsValidClient(iClient))
	{
		switch (hAction)
		{
			case MenuAction_Select:
			{
				switch (iParam)
				{
					case 0:
						Cmd_StatsMe(iClient, 0);
					
					case 1:
						Cmd_Rank(iClient, 0);
				}
				
				if (iParam != 0 | 1)
				{
					char sQuery[256];
					hMenu.GetItem(iParam, g_sColumn[iClient], sizeof(g_sColumn[]));
					
					Format(sQuery, sizeof(sQuery), "SELECT * FROM mugistats ORDER BY %s DESC", g_sColumn[iClient]);
					
					g_hDatabase.Query(SQL_Top, sQuery, GetClientUserId(iClient));
				}
			}
			
			case MenuAction_End:
				delete hMenu;
		}
	}
}