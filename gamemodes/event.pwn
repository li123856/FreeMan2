
new Float:DB_Spawns[2][][] =
{
	{
		{2580.9543,-2922.2375,1003.8871},{2580.9353,-3040.3372,1003.8871},{2620.9497,-2980.4980,1003.8871},
		{2662.5625,-2922.4089,1003.8871},{2682.1228,-2959.8835,1003.8871},{2663.1399,-2999.8201,1003.8871},
		{2581.3845,-2962.0913,1003.8871},{2606.0146,-2995.0747,1003.8871},{2601.6973,-2941.1292,1003.8871},
		{2581.7783,-2959.8501,1003.8871}
	},
	{
		{3811.2156,-2453.5735,1002.5284},{3828.2717,-2437.7588,1002.5284},{3797.6394,-2471.6860,1002.5284},
		{3778.0747,-2452.8750,1002.5284},{3848.7319,-2453.9375,1002.5284},{3828.6216,-2453.9402,1015.5284},
		{3797.5637,-2453.8789,1015.5284},{3855.7751,-2472.6580,1015.5284},{3770.3140,-2436.6235,1015.5284},
		{3811.2190,-2436.3999,1015.5284}
	}
};
new DBP_Stats[MAX_PLAYERS];
CMD:dbq(playerid, params[], help)
{
	if(DBP_Stats[playerid] >= 0) return Dialog_Show(playerid,dl_dbqlk, DIALOG_STYLE_MSGBOX, "单边桥", "离开单边桥小游戏?", "离开", "不要");
    new string[128];
    Loop(i,1)
    {
        format(string,sizeof(string),"%s单边桥{FFCB77}%d号{FFFFFF}.\n",string,i);
	}
	Dialog_Show(playerid,dl_dbqjr, DIALOG_STYLE_LIST, "单边桥:", string, "加入", "离开");
	return 1;
}
CMD:lkdbq(playerid, params[], help)
{
    if(DBP_Stats[playerid] == -1) return 1;
    Dialog_Show(playerid,dl_dbqlk, DIALOG_STYLE_MSGBOX, "单边桥", "离开单边桥小游戏?", "离开", "不要");
	return 1;
}
Dialog:dl_dbqjr(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(DBP_Stats[playerid] >= 0)
		{
			ShowPlayerDialog(playerid, 15157, DIALOG_STYLE_MSGBOX, "单边桥", "你本来就在游戏里", "额", "");
			return 1;
		}
		DBP_Stats[playerid] = listitem;
 		new RandomDerby = random(sizeof(DB_Spawns));
		SetPlayerPosExE(playerid, DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2, random(360), 0, 1);
		CreatEventCar(playerid,451,DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2,0.0);
	}
	return 1;
}
Dialog:dl_dbqlk(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		DBP_Exit(playerid);
	}
	return 1;
}
Function DBPTimer()
{
	foreach(new playerid:Player)
	{
		if(DBP_Stats[playerid] >= 0)
		{
		    new Float: pPos[4];
		    new Float:vehhp;
		    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    {
				GetVehiclePos(GetPlayerVehicleID(playerid),pPos[0],pPos[1],pPos[2]);
			    GetVehicleHealth(GetPlayerVehicleID(playerid), vehhp);
			}
			if(pPos[2] <= 990 || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || vehhp < 250.0)
			{
				DBP_Spawn(playerid);
			}
		}
	}
	return 1;
}

Function DBP_Spawn(playerid)
{
    if(DBP_Stats[playerid] == -1) return 1;
	new RandomDerby = random(10);
    SetPlayerPosExE(playerid, DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2, random(360), 0, 1);
	CreatEventCar(playerid,451,DB_Spawns[DBP_Stats[playerid]][RandomDerby][0], DB_Spawns[DBP_Stats[playerid]][RandomDerby][1], DB_Spawns[DBP_Stats[playerid]][RandomDerby][2]+2,0.0);
	return 1;
}

Function DBP_Exit(playerid)
{
	if(DBP_Stats[playerid] == -1) return 1;
	if(pbrushcar[playerid]!=-1)
	{
		DeleteColor3DTextLabel(pbrushcartext[pbrushcar[playerid]]);
		DestroyVehicle(pbrushcar[playerid]);
	}
	pbrushcar[playerid]=-1;
	DBP_Stats[playerid] = -1;
	SpawnPlayer(playerid);
	return 1;
}

Function SetPlayerPosExE(playerid, Float:x, Float:y, Float:z, Float:ang, int, vw)
{
	SetPPos(playerid, x, y, z);
	SetPlayerFacingAngle(playerid, ang);
	SetPlayerInterior(playerid, int);
	SetPlayerVirtualWorld(playerid, vw);
    SetCameraBehindPlayer(playerid);
	return 1;
}
stock CreatEventCar(playerid,model,Float:x,Float:y,Float:z,Float:a)
{
	if(pbrushcar[playerid]==-1)
	{
        pcarcolor1[playerid]=random(255);
    	pcarcolor2[playerid]=random(255);
    	pbrushcar[playerid]=AddStaticVehicleEx(model,x,y,z,a,pcarcolor1[playerid],pcarcolor2[playerid],99999999);
    	CarTypes[pbrushcar[playerid]]=BrushVeh;
		new Stru[100];
		format(Stru,sizeof(Stru),Temp_Veh_Str,VehName[GetVehicleModel(pbrushcar[playerid])-400],UID[PU[playerid]][u_name]);
  		pbrushcartext[pbrushcar[playerid]]=CreateColor3DTextLabel(Stru,COLOR_LIGHTSTEELBLUE,0.0,0.0,0.8,20,INVALID_PLAYER_ID,pbrushcar[playerid],1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,20.0,0,0);
		SetVehiclePos(pbrushcar[playerid],x,y,z);
		SetVehicleZAngle(pbrushcar[playerid],a);
        LinkVehicleToInterior(pbrushcar[playerid],GetPlayerInterior(playerid));
    	SetVehicleVirtualWorld(pbrushcar[playerid],GetPlayerVirtualWorld(playerid));
       	PutPInVehicle(playerid,pbrushcar[playerid],0);
    }
    else
    {
   		DeleteColor3DTextLabel(pbrushcartext[pbrushcar[playerid]]);
   		DestroyVehicle(pbrushcar[playerid]);
   		pbrushcar[playerid]=AddStaticVehicleEx(model,x,y,z,a,pcarcolor1[playerid],pcarcolor2[playerid],99999999);
   		CarTypes[pbrushcar[playerid]]=BrushVeh;
   		new Stru[100];
   		format(Stru,sizeof(Stru),Temp_Veh_Str,VehName[GetVehicleModel(pbrushcar[playerid])-400],UID[PU[playerid]][u_name]);
   		pbrushcartext[pbrushcar[playerid]]=CreateColor3DTextLabel(Stru,COLOR_LIGHTSTEELBLUE,0.0,0.0,0.8,20,INVALID_PLAYER_ID,pbrushcar[playerid],1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,20.0,0,0);
   		SetVehiclePos(pbrushcar[playerid],x,y,z);
   		SetVehicleZAngle(pbrushcar[playerid],a);
   		LinkVehicleToInterior(pbrushcar[playerid],GetPlayerInterior(playerid));
   		SetVehicleVirtualWorld(pbrushcar[playerid],GetPlayerVirtualWorld(playerid));
   		PutPInVehicle(playerid,pbrushcar[playerid], 0);
    }
	return 1;
}
