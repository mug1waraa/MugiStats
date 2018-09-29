stock bool IsValidClient(int iClient)
{
	if (!(0 < iClient <= MaxClients) || !IsClientConnected(iClient) || !IsClientInGame(iClient) || IsFakeClient(iClient))
		return false;
	
	return true;
}