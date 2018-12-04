Function SetSpawnInfoEx(playerid, team, skin, Float:x, Float:y, Float:z, Float:rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo)
{
	pos_Info[playerid][pos_SetPos][0]=x;
	pos_Info[playerid][pos_SetPos][1]=y;
	pos_Info[playerid][pos_SetPos][2]=z;
	Anti_SavePos(playerid,x,y,z);
    SetSpawnInfo(playerid, team, skin,x,y,z,rotation, weapon1, weapon1_ammo, weapon2, weapon2_ammo, weapon3, weapon3_ammo);
	return 1;
}
stock SetPosFindZ(playerid, Float:x, Float:y, Float:z)
{
	pos_Info[playerid][pos_SetPos][0]=x;
	pos_Info[playerid][pos_SetPos][1]=y;
	pos_Info[playerid][pos_SetPos][2]=z;
	Anti_SavePos(playerid,x,y,z);
 	SetPlayerPosFindZ(playerid,x,y,z);
	return 1;
}
stock Anti_SavePos(playerid, Float:x, Float:y, Float:z)
{
	pos_Info[playerid][pos_Pos][0]=x;
	pos_Info[playerid][pos_Pos][1]=y;
	pos_Info[playerid][pos_Pos][2]=z;
	pos_Info[playerid][pos_tick]=gettime();
}
Function SetPPos(playerid, Float:x, Float:y, Float:z)
{
	pos_Info[playerid][pos_SetPos][0]=x;
	pos_Info[playerid][pos_SetPos][1]=y;
	pos_Info[playerid][pos_SetPos][2]=z;
	Anti_SavePos(playerid,x,y,z);
	SetPlayerPos(playerid,x,y,z);
	return 1;
}
Function PutPInVehicle(playerid, vehicleid, seatid)
{
	static Float:aB_VehiclePos[3];
	GetVehiclePos(vehicleid, aB_VehiclePos[0], aB_VehiclePos[1], aB_VehiclePos[2]);
	pos_Info[playerid][pos_SetPos][0]=aB_VehiclePos[0];
	pos_Info[playerid][pos_SetPos][1]=aB_VehiclePos[1];
	pos_Info[playerid][pos_SetPos][2]=aB_VehiclePos[2];
	Anti_SavePos(playerid, aB_VehiclePos[0], aB_VehiclePos[1], aB_VehiclePos[2]);
	PutPlayerInVehicle(playerid, vehicleid, seatid);
	return 1;
}

stock OnPlayerCheat(playerid,type)
{
	if(GetadminLevel(playerid)>1000)return 1;
	if(pwarn[playerid]==false)
	{
		pwarn[playerid]=true;
		new Str[80];
		switch(type)
		{
		    case Speed_Hack:
		    {
				format(Str,sizeof(Str),"%s被系统T出了服务器[加速]",Gnn(playerid));
				DelayKick(playerid);
				AntiWarn(Str);
		    }
		    case AirBreak_Hack:
		    {
		        SetPlayerPosEx(playerid,spawnX[playerid],spawnY[playerid],spawnZ[playerid],spawnA[playerid],0,0);
				format(Str,sizeof(Str),"%s被系统发现使用瞬移[非系统传送]",Gnn(playerid));
				AdminWarn(Str);
				pwarn[playerid]=false;
		    }
		    case Weapon_Hack:
		    {
		    	ResetPlayerWeapons(playerid);
				GvieGun(playerid);
				SetPlayerArmedWeapon(playerid,0);
				pwarn[playerid]=false;
		    }
		    case Money_Hack:
		    {
				pwarn[playerid]=false;
		    }
		    case Chat_Garbage:
		    {
				UID[PU[playerid]][u_Sil]=10;
				Saveduid_data(PU[playerid]);
				format(Str,sizeof(Str),"%s被系统禁言%s[刷公屏3次]",Gnn(playerid),mutelasttime(PU[playerid],1));
				AntiWarn(Str);
				pwarn[playerid]=false;
		    }
		    case CMD_Garbage:
		    {
				format(Str,sizeof(Str),"%s被系统T出了服务器[刷指令]",Gnn(playerid));
				DelayKick(playerid);
				AntiWarn(Str);
		    }
		    case Version_Garbage:
		    {
				format(Str,sizeof(Str),"%s被系统T出了服务器[SAMP版本过低 SA-MP R2以上]",Gnn(playerid));
				DelayKick(playerid);
				AntiWarn(Str);
		    }
		    case Dalay_Garbage:
		    {
				format(Str,sizeof(Str),"%s被系统T出了服务器[登陆超时]",Gnn(playerid));
				DelayKick(playerid);
				AntiWarn(Str);
		    }
		    case Fuck_Garbage:
		    {
				format(Str,sizeof(Str),"%s被系统T出了服务器[不文明语言/禁语]",Gnn(playerid));
				DelayKick(playerid);
				AntiWarn(Str);
		    }
		    case Ffdt_Garbage:
		    {
				format(Str,sizeof(Str),"%s被系统T出了服务器[发家具堵路/捣乱]",Gnn(playerid));
				DelayKick(playerid);
				AntiWarn(Str);
		    }
		}
	}
	return 1;
}
