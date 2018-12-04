stock DropGun(playerid)
{
	if(GetPlayerVirtualWorld(playerid)==0&&GetPlayerInterior(playerid)==0)
	{
	    new weap=GetPlayerWeapon(playerid);
	    if(weap>0)
	    {
	        new drops=GetGunObjectID(weap);
            if(drops!=-1)
            {
            	Loop(i,13)
				{
					if(WEAPONUID[PU[playerid]][i][wpid]==WEAPON[drops][W_WID])
    				{
						new dr=Itter_Free(DropInfo);
						if(dr!=-1)
						{
						    DropInfo[dr][DropGunweapon]=drops;
						    DropInfo[dr][DropGundid]=WEAPONUID[PU[playerid]][i][wdid];
						    GetPlayerPos(playerid,DropInfo[dr][DropGunPosX],DropInfo[dr][DropGunPosY],DropInfo[dr][DropGunPosZ]);
						    DropInfo[dr][DropGunarea]=CreateDynamicSphere(DropInfo[dr][DropGunPosX],DropInfo[dr][DropGunPosY],DropInfo[dr][DropGunPosZ],1.5,0,0);
						    DropInfo[dr][DropGunid]=CreateDynamicObject(WEAPONUID[PU[playerid]][i][wmodel],DropInfo[dr][DropGunPosX],DropInfo[dr][DropGunPosY],DropInfo[dr][DropGunPosZ]-0.8,80.0, 0.0, 0.0,0,0,-1);
					        new Str[128];
							format(Str,sizeof(Str),"%sµÙ¬‰¡À“ª∞—Œ‰∆˜%s",Gnn(playerid),Daoju[WEAPONUID[PU[playerid]][i][wdid]][d_name]);
							AdminWarn(Str);
							ResetPlayerWeapons(playerid);
			                WEAPONUID[PU[playerid]][i][wdid]=0;
							WEAPONUID[PU[playerid]][i][wpid]=0;
							WEAPONUID[PU[playerid]][i][wmodel]=0;
							SaveWeapon(PU[playerid]);
							GvieGun(playerid);
							Itter_Add(DropInfo,dr);
							break;
						}
    				}
				}
			}
		}
	}
	return 1;
}
stock GetGunObjectID(WeaponID)
{
    if(WeaponID<0||WeaponID>64)return -1;
	Loop(i,sizeof(WEAPON))
	{
	    if(WeaponID==WEAPON[i][W_WID])return i;
	}
	return -1;
}

