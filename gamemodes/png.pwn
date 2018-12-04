#define EditTextPng "test.png"
Function LoadPNG_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_PNG)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,15), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,15), "LoadPNGData", false, true, i, true, false);
			new tmp[256];
			strcat(tmp,"C:\\");
			strcat(tmp,png[i][png_from]);
 			png[i][png_id]=CreateDynamicArt(tmp,png[i][png_type],png[i][png_sX],png[i][png_sY],png[i][png_sZ],png[i][png_aX],png[i][png_aY],png[i][png_aZ],png[i][png_WL],png[i][png_IN],-1,png[i][png_dist],0.0);
			if(png[i][png_id]>=0)
			{
				format(tmp,256,"%s\nID:%i",png[i][png_name],i);
	            png[i][png_3d]=CreateDynamic3DTextLabel(tmp,-1,png[i][png_sX],png[i][png_sY],png[i][png_sZ]-1,png[i][png_dist],INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,png[i][png_WL],png[i][png_IN],-1,png[i][png_dist]);
	 			Iter_Add(png,i);
	 			idx++;
 			}
        }
    }
    return idx;
}
stock Editpnging(playerid,listid, Float:speed)
{
	if(pstat[playerid]==EDIT_ATT_MODE)
	{
		switch(E_dit[playerid][listid][editmode])
		{
		    case EDIT_MODE_PX:
		    {
		    	E_dit[playerid][listid][o_X] += speed;
		    }
		    case EDIT_MODE_PY:
		    {
		        E_dit[playerid][listid][o_Y] += speed;
		    }
		    case EDIT_MODE_PZ:
		    {
		        E_dit[playerid][listid][o_Z] += speed;
		    }
		    case EDIT_MODE_RX:
		    {
		        E_dit[playerid][listid][r_X] += ((speed * 360) / 100) * 10;
		    }
		    case EDIT_MODE_RY:
		    {
		        E_dit[playerid][listid][r_Y] += ((speed * 360) / 100) * 10;
		    }
		    case EDIT_MODE_RZ:
		    {
		        E_dit[playerid][listid][r_Z] += ((speed * 360) / 100) * 10;
		    }
		}
		DestroyArt(png[listid][png_id]);
		new tmp[256];
		strcat(tmp,"C:\\");
		strcat(tmp,EditTextPng);
		png[listid][png_id]=CreateDynamicArt(tmp,png[listid][png_type],E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y],E_dit[playerid][listid][r_Z],png[listid][png_WL],png[listid][png_IN],playerid,png[listid][png_dist],0.0);
		Streamer_UpdateEx(playerid,E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],png[listid][png_WL],png[listid][png_IN],STREAMER_TYPE_OBJECT);
	}
	return 1;
}
timer Editpng[200](playerid,listid)
{
    new KEYS, UD, LR; GetPlayerKeys( playerid, KEYS, UD, LR );
	new Float:ModifySpeed = 0.025;
	//printf("KEYS %i,UD %i,LR %i", KEYS, UD, LR );

	if(KEYS & 8) { Editpnging(playerid,listid, ModifySpeed); }
	else if (KEYS & 128) { Editpnging(playerid,listid, -ModifySpeed); }
	if(KEYS & 4)Dialog_Show(playerid, dl_editpngxz, DIALOG_STYLE_LIST,"PNG编辑","更改位置调节\n保存PNG\n取消调节", "确定", "继续");
	return true;
}
Dialog:dl_eidtpngwz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"pngid");
		E_dit[playerid][listid][editmode]=listitem;
	}
	return 1;
}
Dialog:dl_editpngxz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"pngid");
	    switch(listitem)
	    {
	        case 0:Dialog_Show(playerid, dl_eidtpngwz, DIALOG_STYLE_LIST, "选择位置", "PX\nPY\nPZ\nRX\nRY\nRZ", "确定", "取消");
	        case 1:
	        {
	        	stop Edit[playerid];
				png[listid][png_sX]=E_dit[playerid][listid][o_X];
				png[listid][png_sY]=E_dit[playerid][listid][o_Y];
				png[listid][png_sZ]=E_dit[playerid][listid][o_Z];
				png[listid][png_aX]=E_dit[playerid][listid][r_X];
				png[listid][png_aY]=E_dit[playerid][listid][r_Y];
				png[listid][png_aZ]=E_dit[playerid][listid][r_Z];
	    		SavedPNGdata(listid);
				DestroyArt(png[listid][png_id]);
				new tmp[256];
				strcat(tmp,"C:\\");
				strcat(tmp,png[listid][png_from]);
				png[listid][png_id]=CreateDynamicArt(tmp,png[listid][png_type],E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y],E_dit[playerid][listid][r_Z],png[listid][png_WL],png[listid][png_IN],-1,png[listid][png_dist],0.0);
				format(tmp,256,"%s\nID:%i",png[listid][png_name],listid);
    			png[listid][png_3d]=CreateDynamic3DTextLabel(tmp,-1,png[listid][png_sX],png[listid][png_sY],png[listid][png_sZ]-1,png[listid][png_dist],INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,png[listid][png_WL],png[listid][png_IN],-1,png[listid][png_dist]);
				Streamer_UpdateEx(playerid,E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],png[listid][png_WL],png[listid][png_IN],STREAMER_TYPE_OBJECT);
	    		DeletePVar(playerid,"pngid");
	    		pstat[playerid]=NO_MODE;

	        }
	        case 2:
	        {
				stop Edit[playerid];
				DestroyArt(png[listid][png_id]);
				new tmp[256];
				strcat(tmp,"C:\\");
				strcat(tmp,png[listid][png_from]);
				png[listid][png_id]=CreateDynamicArt(tmp,png[listid][png_type],png[listid][png_sX],png[listid][png_sY],png[listid][png_sZ],png[listid][png_aX],png[listid][png_aY],png[listid][png_aZ],png[listid][png_WL],png[listid][png_IN],-1,png[listid][png_dist],0.0);
				format(tmp,256,"%s\nID:%i",png[listid][png_name],listid);
    			png[listid][png_3d]=CreateDynamic3DTextLabel(tmp,-1,png[listid][png_sX],png[listid][png_sY],png[listid][png_sZ]-1,png[listid][png_dist],INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,png[listid][png_WL],png[listid][png_IN],-1,png[listid][png_dist]);
				Streamer_UpdateEx(playerid,png[listid][png_sX],png[listid][png_sY],png[listid][png_sZ],png[listid][png_WL],png[listid][png_IN],STREAMER_TYPE_OBJECT);
                DeletePVar(playerid,"pngid");
				pstat[playerid]=NO_MODE;
	        }
	    }
	}
	return 1;
}
public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	return 1;
}
Function LoadPNGData(i, name[], value[])
{
    INI_String("png_name",png[i][png_name],128);
    INI_String("png_from",png[i][png_from],128);
    INI_Int("png_uid",png[i][png_uid]);
    INI_Float("png_sX",png[i][png_sX]);
    INI_Float("png_sY",png[i][png_sY]);
    INI_Float("png_sZ",png[i][png_sZ]);
    INI_Float("png_aX",png[i][png_aX]);
    INI_Float("png_aY",png[i][png_aY]);
    INI_Float("png_aZ",png[i][png_aZ]);
    INI_Int("png_WL",png[i][png_WL]);
    INI_Int("png_IN",png[i][png_IN]);
    INI_Float("png_dist",png[i][png_dist]);
    INI_Int("png_type",png[i][png_type]);
	return 1;
}
Function SavedPNGdata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,15));
    INI_WriteString(File,"png_name",png[Count][png_name]);
    INI_WriteString(File,"png_from",png[Count][png_from]);
    INI_WriteInt(File,"png_uid",png[Count][png_uid]);
    INI_WriteFloat(File, "png_sX",png[Count][png_sX]);
    INI_WriteFloat(File, "png_sY",png[Count][png_sY]);
    INI_WriteFloat(File, "png_sZ",png[Count][png_sZ]);
    INI_WriteFloat(File, "png_aX",png[Count][png_aX]);
    INI_WriteFloat(File, "png_aY",png[Count][png_aY]);
    INI_WriteFloat(File, "png_aZ",png[Count][png_aZ]);
    INI_WriteFloat(File, "png_dist",png[Count][png_dist]);
    INI_WriteInt(File,"png_WL",png[Count][png_WL]);
    INI_WriteInt(File,"png_IN",png[Count][png_IN]);
    INI_WriteInt(File, "png_type",png[Count][png_type]);
    INI_Close(File);
	return true;
}

