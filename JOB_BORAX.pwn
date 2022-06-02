
//var
#define MAX_BORAX 250

enum E_BORAX
{
    boraxPcs,
    boraxJadi,
    Text3D:UpdateMborax,
    Text3D:UpdateMrawb,
    bWork[3],
    bOne[5],
    bKurir,
    bMaterial,
    Rawborax,
    StockB

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
    pBorax[boraxid][UpdateMborax] = CreateDynamic3DTextLabel(strings1, COLOR_YELLOW, 1547.401611, 30.032892, 24.140625, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 

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
    CreateDynamic3DTextLabel(strings4, COLOR_YELLOW, 1551.513305, 11.764911, 24.161827, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
    
    new strings5[150];
    CreateDynamicPickup(1239, 23, 1553.046386, 9.510235, 23.968818, -1, -1, -1, 50);
    format(strings5, sizeof(strings5), "[Jumlah Material Saat ini]\n{ffffff}0 material\n{7fffd4}/borax put");
    pBorax[boraxid][UpdateMrawb] = CreateDynamic3DTextLabel(strings5, COLOR_YELLOW, 1553.046386, 9.510235, 23.968818, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Kurir
}

B_Refresh()
{
    new matext[200];
    format(matext, sizeof(matext), "[BORAX STORAGE]\n(%d kotak) {ffffff}Jumlah borax Saat ini\n{ffffff}gudang penyimpanan borax\n{7fffd4}/borax store", pBorax[boraxid][boraxPcs]);
    UpdateDynamic3DTextLabelText(pBorax[boraxid][UpdateMborax], COLOR_YELLOW, matext);

    new matextT[200];
    format(matextT, sizeof(matextT), "[Jumlah Material Saat ini]]\n{ffffff}%d material\n{7fffd4}/borax put", pBorax[boraxid][StockB]);
    UpdateDynamic3DTextLabelText(pBorax[boraxid][UpdateMrawb], COLOR_YELLOW, matextT);
    return 1;
}
CMD:borax(playerid, params[])
{
    if(!IsPlayerConnected(playerid))
        return Error(playerid, "anda harus login");
    
    if(isnull(params)) return Usage(playerid, "/borax [store/start/stop/make/get/menu]");
	
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
            format(info, sizeof(info), "Work at\tGaji\nPembuat Borax\t{1f631d} $100.00\nPengumpul borax\t{1f631d} $50.00\nKurir Borax\t{1f631d} (Pertempat)");
            ShowPlayerDialog(playerid, DIALOG_BORAX_MENU, DIALOG_STYLE_TABLIST_HEADERS, capt, info, "Select", "cancel");
        }
        else return Error(playerid, "anda harus Ganti pakaian dulu gunakan /borax start");
    }
	if(!strcmp(params, "store", true))
	{
        if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1547.401611, 30.032892, 24.140625))
            return Error(playerid, "Anda harus berada di gudang boraks");

        if(pBorax[boraxid][boraxJadi] < 4)
            return va_Error(playerid, "Anda harus memiliki %d/4 pcs boraks jadi!", pBorax[boraxid][boraxJadi]);
        
        new bTotal = pBorax[boraxid][boraxJadi];

        if(pData[playerid][IsPborax] == 1)
        {
            pBorax[boraxid][boraxPcs]+= bTotal;
            pBorax[boraxid][boraxJadi] -= bTotal;

            AddPlayerSalary(playerid, "Borax Factory", 1000);
            Info(playerid, "Anda mendapatkan gaji $100.00 ke salary");
            InfoTD_MSG(playerid, 4000, "Borax Added to factory storage");
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
        
        if(pBorax[boraxid][StockB] < 1)
            return Error(playerid, "gudang penyimpanan sekarang masih kosong /borax menu pilih pengumpul borax untuk mengisi gudang");

        if(pBorax[boraxid][bWork][1] == 1)
        {
            Info(playerid, "Anda sedang mengambil material untuk membuat borax");
            pData[playerid][pBoraxTimer] = SetTimerEx("Boraxloading", 1000, true, "id", playerid, 1);
            SetPlayerPos(playerid, 1551.513305, 11.764911, 24.161827);
            pBorax[boraxid][StockB] -= 1;
            ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking material...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
        }
        else return Error(playerid, "Anda harus mengambil bagian kerja anda di /borax menu");
    }
    if(!strcmp(params, "pick", true))
    {
        if(!pData[playerid][IsPborax])
           return Error(playerid, "Anda belum mulai bekerja");
        
        if(pBorax[boraxid][bWork][1] == 1)
            return Error(playerid, "Anda harus mengambil bagian kerja anda di /borax menu");

        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1552.359008, -32.325199, 21.358097))
        {
            if(pBorax[boraxid][bOne][0] == 2)
                return Error(playerid,"anda sudah mengambil ini");

            Info(playerid, "Anda sedang mengambil raw borax");
            pData[playerid][pBoraxTimer] = SetTimerEx("BoraxPick", 1000, true, "id", playerid, 1);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
            TogglePlayerControllable(playerid, 0);

            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking Rawborax...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            SetPlayerCheckpoint(playerid, 1552.454711, -29.463176, 21.360610, 1.5);
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1552.454711, -29.463176, 21.360610))
        {
            if(pBorax[boraxid][bOne][1] == 1)
                return Error(playerid,"anda sudah mengambil ini");

            pData[playerid][pBoraxTimer] = SetTimerEx("BoraxPick", 1000, true, "id", playerid, 1);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
            TogglePlayerControllable(playerid, 0);

            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking Rawborax...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            SetPlayerCheckpoint(playerid, 1552.109252, -26.435869, 21.360832, 1.5);
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1552.109252, -26.435869, 21.360832))
        {
            if(pBorax[boraxid][bOne][2] == 1)
                return Error(playerid,"anda sudah mengambil ini");

            pData[playerid][pBoraxTimer] = SetTimerEx("BoraxPick", 1000, true, "id", playerid, 1);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
            TogglePlayerControllable(playerid, 0);

            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking Rawborax...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            SetPlayerCheckpoint(playerid, 1548.867675, -25.868560, 21.324766, 1.5);
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1548.867675, -25.868560, 21.324766))
        {
            if(pBorax[boraxid][bOne][3] == 1)
                return Error(playerid,"anda sudah mengambil ini");

            pData[playerid][pBoraxTimer] = SetTimerEx("BoraxPick", 1000, true, "id", playerid, 1);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
            TogglePlayerControllable(playerid, 0);

            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking Rawborax...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            SetPlayerCheckpoint(playerid, 1547.898681, -27.764528, 21.313808, 1.5);
        }
        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1547.898681, -27.764528, 21.313808))
        {
            if(pBorax[boraxid][bOne][4] == 1)
                return Error(playerid,"anda sudah mengambil ini");

            pData[playerid][pBoraxTimer] = SetTimerEx("BoraxPick", 1000, true, "id", playerid, 1);
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
            TogglePlayerControllable(playerid, 0);

            ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
            PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Taking Rawborax...");
            PlayerTextDrawShow(playerid, ActiveTD[playerid]);
            DisablePlayerCheckpoint(playerid);
        }
    }
    if(!strcmp(params, "put", true ))
    {
        new factoryStock = pBorax[boraxid][Rawborax];

        if(!pData[playerid][IsPborax])
           return Error(playerid, "Anda belum mulai bekerja");
        
        if(pBorax[boraxid][bWork][1] == 1)
            return Error(playerid, "Anda harus mengambil bagian kerja anda di /borax menu");

        if(IsPlayerInRangeOfPoint(playerid, 1.0, 1547.898681, -27.764528, 21.313808))
        {
            if(pBorax[boraxid][Rawborax] < 4)
            {
                pBorax[boraxid][StockB] += factoryStock;
                pBorax[boraxid][Rawborax] = 0;

                GivePlayerMoneyEx(playerid, 500);
                Info(playerid, "anda telah mendapatkan gaji $50.00");
            }
            else Error(playerid, "Anda harus mempunyai setidak nya 4 raw boraks");
        }
        else Error(playerid, "Anda harus berada di tempat penyimpanan pabrik yang banyak tong nya");
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
function BoraxPick(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;

	if(pData[playerid][pActivityTime] >= 100)
	{
        if(pBorax[boraxid][Rawborax] == 4)
        {
            PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
            Info(playerid, "Anda sudah mendapatkan 4 raw boraks sekarang taruh di penyimpanan pabrik /borax put");
            SetPlayerCheckpoint(playerid, 1553.046386, 9.510235, 23.968818, 1.5);
        }
        pBorax[boraxid][Rawborax] += 1;
        pBorax[boraxid][bOne][0] += 1;
		InfoTD_MSG(playerid, 2000, "You have taken 1 raw borax!");

      /*  if(pBorax[boraxid][bOne][0] == 1)
        {
            pBorax[boraxid][bOne][1] = 1;
            if(pBorax[boraxid][bOne][1] == 1)
            {
                pBorax[boraxid][bOne][2] = 1;
                if(pBorax[boraxid][bOne][2] == 1)
                {
                    pBorax[boraxid][bOne][3] = 1;
                    if(pBorax[boraxid][bOne][3] == 1)
                    {
                        pBorax[boraxid][bOne][4] = 1;
                    }              
                }              
            }              
        }*/
		TogglePlayerControllable(playerid, 1);
        ClearAnimations(playerid, 1);
		KillTimer(pData[playerid][pBoraxTimer]);

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
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
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
   /* pBorax[boraxid][Rawborax] = 3;
    pBorax[boraxid][boraxPcs] = 3;*/
    pBorax[boraxid][boraxJadi] = 3;
    return 1;
}