
//var
#define MAX_BORAX 250

enum E_BORAX
{
    boraxPcs,
    boraxJadi,
    Text3D:UpdateMatext,
    bWork[2],
    bKurir,
    bMaterial

};
new pBorax[MAX_BORAX][E_BORAX];
new boraxid;

CreateJoinBoraxPoint()
{
    //JOBS
    new strings[128];
    CreateDynamicPickup(1239, 23, 1566.516235, 23.396541, 24.164062, -1, -1, -1, 50);
    format(strings, sizeof(strings), "[Borax Factory]\n{ffffff}Jadilah Pekerja disini\n{7fffd4}/getjob /accept job");
    CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1566.516235, 23.396541, 24.164062, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

    new strings1[300];
    CreateDynamicPickup(1239, 23, 1547.401611, 30.032892, 24.140625, -1, -1, -1, 50);
    format(strings1, sizeof(strings1), "[BORAX STORAGE]\n(0 {ffffff}Jumlah borax Saat ini)\n{ffffff}gudang penyimpanan borax\n{7fffd4}/borax store");
    pBorax[boraxid][UpdateMatext] = CreateDynamic3DTextLabel(strings1, COLOR_YELLOW, 1547.401611, 30.032892, 24.140625, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

    new strings2[128];
    CreateDynamicPickup(1239, 23, 1546.742553, 32.447097, 24.140625, -1, -1, -1, 50);
    format(strings2, sizeof(strings2), "[Start job]\n{ffffff}ganti baju untuk memulai kerja\n{7fffd4}/borax start /borax stop");
    CreateDynamic3DTextLabel(strings2, COLOR_YELLOW, 1546.742553, 32.447097, 24.140625, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir

    new strings3[128];
    CreateDynamicPickup(1239, 23, 1547.558593, 17.021057, 24.143041, -1, -1, -1, 50);
    format(strings3, sizeof(strings3), "[Pembuatan Borax]\n{ffffff}untuk membuat borax\n{7fffd4}/borax make");
    CreateDynamic3DTextLabel(strings3, COLOR_YELLOW, 1547.558593, 17.021057, 24.143041, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir

    new strings4[150];
    CreateDynamicPickup(1239, 23, 1551.513305, 11.764911, 24.161827, -1, -1, -1, 50);
    format(strings4, sizeof(strings4), "[Material untuk membuat borax]\n{ffffff}Bahan² untuk membuat boraks\n{7fffd4}/borax get");
    CreateDynamic3DTextLabel(strings4, COLOR_YELLOW, 1551.513305, 11.764911, 24.161827, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir
}

B_Refresh()
{
    new matext[200];
    format(matext, sizeof(matext), "[BORAX STORAGE]\n(%d kotak) {ffffff}Jumlah borax Saat ini\n{ffffff}gudang penyimpanan borax\n{7fffd4}/borax store", pBorax[boraxid][boraxPcs]);
    UpdateDynamic3DTextLabelText(pBorax[boraxid][UpdateMatext], COLOR_YELLOW, matext);
    return 1;
}
CMD:borax(playerid, params[])
{
    if(!IsPlayerConnected(playerid))
        return Error(playerid, "anda harus login");
    
    if(isnull(params)) return Usage(playerid, "/borax [store/start/stop/make/get]");
	
    if(!strcmp(params, "start", true))
    {
        if(pData[playerid][pJob] == 11 || pData[playerid][pJob2] == 11)
        {
            if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1546.742553, 32.447097, 24.140625))
                 return Error(playerid, "anda harus berada di depak pintu kerja");

            if(pData[playerid][IsPborax] == 1)  return Error(playerid, "Anda sudah mulai kerja");

            new Myskin = GetPlayerSkin(playerid);

            pData[playerid][pLastSkin] = Myskin;

            new bQuery[4028];
            mysql_format(g_SQL, bQuery, sizeof(bQuery), "UPDATE `players` SET ");
            mysql_format(g_SQL, bQuery, sizeof(bQuery), "%s`lastSkin` = '%d', ", bQuery, pData[playerid][pLastSkin]);

            SetPlayerSkin(playerid, 268);
            RefreshPSkin(playerid);
            pData[playerid][IsPborax] = 1;
               
            return Info(playerid, "Anda telah mulai kerja, gunakan /borax menu untuk mulai bekerja");
                
        }
        else return Error(playerid, "anda bukan seorang pekerja di pabrik borax");

    }
    if(!strcmp(params, "stop", true))
    {
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1546.742553, 32.447097, 24.140625))
                return Error(playerid, "anda harus berada di depak pintu kerja");

        if(pData[playerid][IsPborax] == 1)
        {
            cache_get_value_int(0, "lastSkin", pData[playerid][pLastSkin]);
            SetPlayerSkin(playerid, pData[playerid][pLastSkin]);
            RefreshPSkin(playerid);
        }
        else {
            Error(playerid, "anda belum mulai kerja");
        } 
    }
    if(!strcmp(params, "menu", true))
    {
        if(pData[playerid][IsPborax] == 1)
        {
            new capt[200];
            format(capt, sizeof(capt), "Total Borax in factory (%d)", pBorax[playerid][boraxPcs]);

            new info[500];
            format(info, sizeof(info), "Work at\tGaji\nPembuat Borax\t{1f631d} $450.00\nPembuat borax ladang\t{1f631d} $600.00\nKurir Borax\t{1f631d} (Pertempat)");
            ShowPlayerDialog(playerid, DIALOG_BORAX_MENU, DIALOG_STYLE_TABLIST_HEADERS, capt, info, "Select", "cancel");
        }
    }
	if(!strcmp(params, "store", true))
	{
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1547.401611, 30.032892, 24.140625))
            return Error(playerid, "Anda harus berada di gudang boraks");

        if(pBorax[boraxid][boraxJadi] < 4)
            return Error(playerid, "Borax yang di store ke gudang harus minimal 4 pcs!");
        
        new bTotal = pBorax[boraxid][boraxJadi];

        if(pData[playerid][IsPborax] == 1)
        {
            pBorax[boraxid][boraxPcs]+= bTotal;

            AddPlayerSalary(playerid, "Borax Factory", 1500);
            Info(playerid, "Anda mendapatkan gaji $150.00 ke salary");
            InfoTD_MSG(playerid, 4000, "Borax Added to factory storage");
            pBorax[boraxid][boraxJadi] -= 0;
            B_Refresh();

        }
        else return Error(playerid, "anda belum mulai berkerja");

    }
    if(!strcmp(params, "make", true))
    {
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1547.558593, 17.021057, 24.143041))
            return Error(playerid, "Anda harus berada di tempat pembuatan boraks");
        
        if(!pData[playerid][IsPborax])
           return Error(playerid, "Anda belum mulai bekerja");

        if(pBorax[boraxid][bMaterial] < 3)
            return va_SendClientMessage(playerid, -1, "Anda membutuhkan 3 box material dan anda hanya mempunyai %d/3 box", pBorax[boraxid][bMaterial]);

        pData[playerid][pBoraxTimer] = SetTimerEx("BoraxMake", 1000, true, "id", playerid, 1);
        SetPlayerPos(playerid, 1547.558593, 17.021057, 24.143041);
        ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
        ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
        PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Making Borax...");
        PlayerTextDrawShow(playerid, ActiveTD[playerid]);
    }
    if(!strcmp(params, "get", true))
    {
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1551.513305, 11.764911, 24.161827))
            return Error(playerid, "Anda tidak berada di tempat pengambilan material borax");
        
        if(!pData[playerid][IsPborax])
           return Error(playerid, "Anda belum mulai bekerja");
        
        if(pBorax[boraxid][bWork][1] == 1)
        {
            Info(playerid, "Anda sedang mengambil material untuk membuat borax");
            pData[playerid][pBoraxTimer] = SetTimerEx("Boraxloading", 1000, true, "id", playerid, 1);
            SetPlayerPos(playerid, 1551.513305, 11.764911, 24.161827);
            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking material...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
        }
        else return Error(playerid, "Anda harus mengambil bagian kerja anda di /borax menu");
    }
    return 1;
}
function BoraxMake (playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	if(pData[playerid][pActivityTime] >= 100)
	{
        new rand = Random(1,4);
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Borax has been created!");
		KillTimer(pData[playerid][pBoraxTimer]);
        
		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pEnergy] -= 3;

        if(rand == 1)
        {
            pBorax[boraxid][boraxJadi] += 2;
            pBorax[boraxid][bMaterial] -= 3;
            Info(playerid, "Anda telah berhasil membuat 2pcs boraks");
            return 1;
        }
        else if(rand == 2)
        {
            pBorax[boraxid][boraxJadi] += 4;
            pBorax[boraxid][bMaterial] -= 3;
            Info(playerid, "Anda telah berhasil membuat 4pcs boraks");
            return 1;
        }
        else if(rand == 3)
        {
            pBorax[boraxid][boraxJadi] += 1;
            pBorax[boraxid][bMaterial] -= 3;
            Info(playerid, "Anda telah berhasil membuat 1pcs boraks");
            return 1;
        }
        else
        {
            Info(playerid, "Anda telah gagal membuat boraks");
            pBorax[boraxid][bMaterial] -= 1;
            return 1;
        }
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
    }
	return 1;
}
function Boraxloading (playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	if(pData[playerid][pActivityTime] >= 100)
	{
		Info(playerid, "Kamu telah berhasil Mengambil 1 box material untuk membuat borax.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Material has been taken!");
		KillTimer(pData[playerid][pBoraxTimer]);

        pBorax[boraxid][bMaterial] += 1;

		pData[playerid][pActivityTime] = 0;
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pEnergy] -= 3;
		return 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
CMD:bmat(playerid, params[])
{
    pBorax[boraxid][bMaterial] = 3;
    return 1;
}
