stock LoadProStock(idx)
{
	new tm1[100];
    if(fexist(Get_Path(idx,24)))
    {
		new File:NameFile = fopen(Get_Path(idx,24), io_read);
    	if(NameFile)
    	{
    	    new ids=0;
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_PRO_STOCK)
	        	    {
		        		sscanf(tm1, "p<,>iiii",prostock[idx][ids][ps_type],prostock[idx][ids][ps_did],prostock[idx][ids][ps_amout],prostock[idx][ids][ps_value]);
			    		Iter_Add(prostock[idx],ids);
		        		ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
Function SaveProStock(idx)
{
	new str[512];
    if(fexist(Get_Path(idx,24)))fremove(Get_Path(idx,24));
	new File:NameFile = fopen(Get_Path(idx,24), io_write);
    foreach(new i:prostock[idx])
  	{
		format(str,sizeof(str),"%s %i,%i,%i,%i\r\n",str,prostock[idx][i][ps_type],prostock[idx][i][ps_did],prostock[idx][i][ps_amout],prostock[idx][i][ps_value]);
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}
Function LoadpropertyData(i, name[], value[])
{
    INI_String("pro_name",property[i][pro_name],100);
    INI_Int("pro_stat",property[i][pro_stat]);
    INI_Int("pro_open",property[i][pro_open]);
    INI_Int("pro_intid",property[i][pro_intid]);
    INI_Int("pro_uid",property[i][pro_uid]);
    INI_Int("pro_type",property[i][pro_type]);
    INI_Int("pro_iwl",property[i][pro_iwl]);
    INI_Int("pro_iin",property[i][pro_iin]);
    INI_Int("pro_owl",property[i][pro_owl]);
    INI_Int("pro_oin",property[i][pro_oin]);
    INI_Float("pro_ix",property[i][pro_ix]);
    INI_Float("pro_iy",property[i][pro_iy]);
    INI_Float("pro_iz",property[i][pro_iz]);
    INI_Float("pro_ia",property[i][pro_ia]);
    INI_Float("pro_ox",property[i][pro_ox]);
    INI_Float("pro_oy",property[i][pro_oy]);
    INI_Float("pro_oz",property[i][pro_oz]);
    INI_Float("pro_oa",property[i][pro_oa]);
    INI_Int("pro_value",property[i][pro_value]);
    INI_Int("pro_entervalue",property[i][pro_entervalue]);
    INI_Int("pro_cunkuan",property[i][pro_cunkuan]);
    INI_Int("pro_icol",property[i][pro_icol]);
	return 1;
}
Function Savedpropertydata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,23));
    INI_WriteString(File,"pro_name",property[Count][pro_name]);
    INI_WriteInt(File,"pro_stat",property[Count][pro_stat]);
    INI_WriteInt(File,"pro_open",property[Count][pro_open]);
    INI_WriteInt(File,"pro_intid",property[Count][pro_intid]);
    INI_WriteInt(File,"pro_uid",property[Count][pro_uid]);
    INI_WriteInt(File,"pro_type",property[Count][pro_type]);
    INI_WriteInt(File,"pro_iwl",property[Count][pro_iwl]);
    INI_WriteInt(File,"pro_iin",property[Count][pro_iin]);
    INI_WriteInt(File,"pro_owl",property[Count][pro_owl]);
    INI_WriteInt(File,"pro_oin",property[Count][pro_oin]);
    INI_WriteFloat(File,"pro_ix",property[Count][pro_ix]);
    INI_WriteFloat(File,"pro_iy",property[Count][pro_iy]);
    INI_WriteFloat(File,"pro_iz",property[Count][pro_iz]);
    INI_WriteFloat(File,"pro_ia",property[Count][pro_ia]);
    INI_WriteFloat(File,"pro_ox",property[Count][pro_ox]);
    INI_WriteFloat(File,"pro_oy",property[Count][pro_oy]);
    INI_WriteFloat(File,"pro_oz",property[Count][pro_oz]);
    INI_WriteFloat(File,"pro_oa",property[Count][pro_oa]);
    INI_WriteInt(File,"pro_value",property[Count][pro_value]);
    INI_WriteInt(File,"pro_entervalue",property[Count][pro_entervalue]);
    INI_WriteInt(File,"pro_cunkuan",property[Count][pro_cunkuan]);
    INI_WriteInt(File,"pro_icol",property[Count][pro_icol]);
    INI_Close(File);
	return true;
}
Function Loadproperty_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_PRO)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,23), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,23), "LoadpropertyData", false, true, i, true, false);
            LoadProStock(i);
			CreateProperty(i);
  			Iter_Add(property,i);
 			idx++;
        }
    }
    return idx;
}
stock DeleteProperty(idx)
{
	DeleteColor3DTextLabel(property[idx][pro_i3d]);
	DestroyDynamicMapIcon(property[idx][pro_mic]);
	DestroyDynamicPickup(property[idx][pro_ipic]);
	DestroyDynamicPickup(property[idx][pro_opic]);
	DeleteColor3DTextLabel(property[idx][pro_o3d]);
    return 1;
}
stock RemoveProperty(idx)
{
	DeleteColor3DTextLabel(property[idx][pro_i3d]);
	DestroyDynamicMapIcon(property[idx][pro_mic]);
	DestroyDynamicPickup(property[idx][pro_ipic]);
	DestroyDynamicPickup(property[idx][pro_opic]);
	DeleteColor3DTextLabel(property[idx][pro_o3d]);
	Iter_Clear(prostock[idx]);
    fremove(Get_Path(idx,23));
    fremove(Get_Path(idx,24));
	Iter_Remove(property,idx);
    return 1;
}
stock CreateProperty(idx)
{
	new tm[256];
	switch(property[idx][pro_type])
	{
	    case PRO_SELL:
		{
	    	switch(property[idx][pro_stat])
			{
	    		case NONEONE:
				{
					format(tm,100,"���ߵ�\n%s\nδ���۲�ҵ\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],44,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19133,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case OWNERS:
				{
					if(property[idx][pro_open])format(tm,100,"���ߵ�\n%s[Ӫҵ��]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					else format(tm,100,"���ߵ�\n%s[δ��ҵ]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],44,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19133,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case SELLING:
				{
					format(tm,100,"���ߵ�\n%s[ת����]\nҵ��:%s\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],UID[property[idx][pro_uid]][u_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],44,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19133,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
			}
		}
	    case PRO_BANK:
		{
	    	switch(property[idx][pro_stat])
			{
	    		case NONEONE:
				{
					format(tm,100,"����ҵ\n%s\nδ���۲�ҵ\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],52,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(1274,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case OWNERS:
				{
					if(property[idx][pro_open])format(tm,100,"����ҵ\n%s[Ӫҵ��]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					else format(tm,100,"����ҵ\n%s[δ��ҵ]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],52,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(1274,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case SELLING:
				{
					format(tm,100,"����ҵ\n%s[ת����]\nҵ��:%s\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],UID[property[idx][pro_uid]][u_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],52,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(1274,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
			}
		}
		case PRO_RACE:
		{
	    	switch(property[idx][pro_stat])
			{
	    		case NONEONE:
				{
					format(tm,100,"������\n%s\nδ���۲�ҵ\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],48,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19130,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case OWNERS:
				{
					if(property[idx][pro_open])format(tm,100,"������\n%s[Ӫҵ��]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					else format(tm,100,"������\n%s[δ��ҵ]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],48,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19130,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case SELLING:
				{
					format(tm,100,"������\n%s[ת����]\nҵ��:%s\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],UID[property[idx][pro_uid]][u_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],48,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19130,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
			}
		}
		case PRO_AREA:
		{
	    	switch(property[idx][pro_stat])
			{
	    		case NONEONE:
				{
					format(tm,100,"�ɶԳ���\n%s\nδ���۲�ҵ\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],31,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19132,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case OWNERS:
				{
					if(property[idx][pro_open])format(tm,100,"�ɶԳ���\n%s[Ӫҵ��]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					else format(tm,100,"�ɶԳ���\n%s[δ��ҵ]\n�볡��:%i\nҵ��:%s\nID:%i\nF��",property[idx][pro_name],property[idx][pro_entervalue],UID[property[idx][pro_uid]][u_name],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],31,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19132,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
	    		case SELLING:
				{
					format(tm,100,"�ɶԳ���\n%s[ת����]\nҵ��:%s\n�ۼ�:$%i\nID:%i\nF��",property[idx][pro_name],UID[property[idx][pro_uid]][u_name],property[idx][pro_value],idx);
					property[idx][pro_mic]=CreateDynamicMapIcon(property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],31,-1,property[idx][pro_owl],property[idx][pro_oin],-1,500.0,MAPICON_LOCAL);
					property[idx][pro_opic]=CreateDynamicPickup(19132,1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz],property[idx][pro_owl],property[idx][pro_oin],-1,100.0);
				}
            }
		}
	}
	property[idx][pro_o3d]=CreateColor3DTextLabel(tm,-1,property[idx][pro_ox],property[idx][pro_oy],property[idx][pro_oz]-0.1,20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,property[idx][pro_owl],property[idx][pro_oin],-1,20.0,property[idx][pro_icol],1);
	property[idx][pro_i3d]=CreateColor3DTextLabel("����\nF��",-1,property[idx][pro_ix],property[idx][pro_iy],property[idx][pro_iz]-0.1,20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,property[idx][pro_iwl],property[idx][pro_iin],-1,20.0,property[idx][pro_icol],1);
	property[idx][pro_ipic]=CreateDynamicPickup(19131,1,property[idx][pro_ix],property[idx][pro_iy],property[idx][pro_iz],property[idx][pro_iwl],property[idx][pro_iin],-1,50.0);
	return 1;
}
Function GetClosestPro(playerid,&jcid,&type)
{
	new Float:dis, Float:dis2;
	jcid = -1;
	dis = 99999.99;
	foreach(new x:property)
	{
		if(PlayerToPoint(1, playerid,property[x][pro_ix],property[x][pro_iy],property[x][pro_iz],property[x][pro_iin],property[x][pro_iwl]))
		{
			new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
			GetPlayerPos(playerid, x1, y1, z1);
			x2=property[x][pro_ix];
			y2=property[x][pro_iy];
			z2=property[x][pro_iz];
			dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				jcid = x;
			}
			type=1;
		}
		if(PlayerToPoint(1, playerid,property[x][pro_ox],property[x][pro_oy],property[x][pro_oz],property[x][pro_oin],property[x][pro_owl]))
		{
			new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
			GetPlayerPos(playerid, x1, y1, z1);
			x2=property[x][pro_ox];
			y2=property[x][pro_oy];
			z2=property[x][pro_oz];
			dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				jcid = x;
			}
			type=0;
		}
	}
	//printf("%i,%i",jcid,type);
}
Dialog:dl_progivesell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    current_number[playerid]=1;
	    new current=-1,idx=0;
		new hid=GetPVarInt(playerid,"houseid");
        switch(listitem)
        {
            case 0:
			{
			    new objidx[MAX_PRO_STOCK],amoutex[MAX_PRO_STOCK][8];
				foreach(new i:prostock[hid])
				{
				    if(prostock[hid][i][ps_type]==SELL_TYPE)
				    {
						current_idx[playerid][idx]=i;
						objidx[idx]=Daoju[prostock[hid][i][ps_did]][d_obj];
				        format(amoutex[idx],8,"$%i",prostock[hid][i][ps_value]);
				       	current_number[playerid]++;
				       	current++;
				       	idx++;
				    }
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����û�е��߳���", "�õ�", "");
				new amouts=current+1;
				new tm[100];
				format(tm,100,"~y~SELLING~r~%i/%i",amouts,MAX_PRO_STOCK);
				ShowModelSelectionMenuEx(playerid,objidx,amoutex,amouts,tm,CUSTOM_PRO_EDIT_SELLBB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
                SM(COLOR_ORANGE,"��ѡ����Ҫ�༭�����ϼܵ���Ʒ");
   			}
            case 1:
			{
			    new objidy[MAX_PRO_STOCK],amoutey[MAX_PRO_STOCK][20];
				foreach(new i:prostock[hid])
				{
				    if(prostock[hid][i][ps_type]==BUY_TYPE)
				    {
						current_idx[playerid][idx]=i;
						objidy[idx]=Daoju[prostock[hid][i][ps_did]][d_obj];
				        format(amoutey[idx],20,"$%i",prostock[hid][i][ps_value]);
				       	current_number[playerid]++;
				       	current++;
				       	idx++;
				    }
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����û�е��߳���", "�õ�", "");
				new amouts=current+1;
				new tm[100];
				format(tm,100,"~y~BUYING~r~%i/%i",amouts,MAX_PRO_STOCK);
				ShowModelSelectionMenuEx(playerid,objidy,amoutey,amouts,tm,CUSTOM_PRO_EDIT_BUYBB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
                SM(COLOR_ORANGE,"��ѡ����Ҫ�༭�����չ�����Ʒ");
   			}
            case 2:
			{
				new objid[MAX_PLAYER_BEIBAO],amoute[MAX_PLAYER_BEIBAO][8];
				foreach(new i:Beibao[playerid])
				{
					current_idx[playerid][idx]=i;
					objid[idx]=Daoju[Beibao[playerid][i][b_did]][d_obj];
			        format(amoute[idx],8,"%i",Beibao[playerid][i][b_amout]);
			       	current_number[playerid]++;
			       	current++;
			       	idx++;
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "������ı�����û�ж���", "�õ�", "");
				new amouts=Iter_Count(Beibao[playerid]);
				new tm[100];
				format(tm,100,"~b~My Bag ~r~%i/%i",amouts,MAX_PLAYER_BEIBAO);
				ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_PRO_SELLBB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
                SM(COLOR_ORANGE,"��ѡ����Ҫ�ϼܵ���Ʒ");
			}
            case 3:
			{
				new objids[mS_CUSTOM_MAX_ITEMS],amoutes[mS_CUSTOM_MAX_ITEMS][8];
				foreach(new i:Daoju)
				{
				    if(Daoju[i][d_use])
				    {
						current_idx[playerid][idx]=i;
						objids[idx]=Daoju[i][d_obj];
				        format(amoutes[idx],16,"$%i",Daoju[i][d_cash]);
				       	current_number[playerid]++;
				       	current++;
				       	idx++;
				    }
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����û�е��ߴ���", "�õ�", "");
				new amouts=current+1;
				new tm[100];
				format(tm,100,"~y~Dao Ju ~r~%i/%i",amouts,MAX_DAOJU);
				ShowModelSelectionMenuEx(playerid,objids,amoutes,amouts,tm,CUSTOM_PRO_BUYBB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
                SM(COLOR_ORANGE,"��ѡ����Ҫ�չ�����Ʒ");
			}
		}
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_setprosellamout(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_setprosellamout, DIALOG_STYLE_INPUT, "�������ϼܸ���", "����������", "ȷ��", "ȡ��");
		if(amout<=0)return Dialog_Show(playerid, dl_setprosellamout, DIALOG_STYLE_INPUT, "�������ϼܸ���", "����������", "ȷ��", "ȡ��");
		new listid=GetPVarInt(playerid,"listIDA");
		if(amout>GetBeibaoAmout(playerid,Beibao[playerid][listid][b_did]))return Dialog_Show(playerid, dl_setprosellamout, DIALOG_STYLE_INPUT, "�����ϼܸ���","��û����ô�࣬���������", "ȷ��", "ȡ��");
        Dialog_Show(playerid, dl_setprosellmoney, DIALOG_STYLE_INPUT, "�����ó��ۼ۸�", "������۸�", "ȷ��", "ȡ��");
		SetPVarInt(playerid,"amouts",amout);
	}
	return 1;
}
Dialog:dl_setprosellmoney(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new money;
		if(sscanf(inputtext, "i",money))return Dialog_Show(playerid, dl_setprosellmoney, DIALOG_STYLE_INPUT, "�����ó��ۼ۸�", "������۸�", "ȷ��", "ȡ��");
        if(money<=0||money>MAX_MONEY)return Dialog_Show(playerid, dl_setprosellmoney, DIALOG_STYLE_INPUT, "�����ó��ۼ۸�", "������۸�", "ȷ��", "ȡ��");
		new listid=GetPVarInt(playerid,"listIDA");
        new hid=GetPVarInt(playerid,"houseid");
        new amout=GetPVarInt(playerid,"amouts");
        Delbeibao(playerid,Beibao[playerid][listid][b_did],amout);
        AddSellProStock(hid,Beibao[playerid][listid][b_did],amout,money);
	}
	return 1;
}
Dialog:dl_setprobuyamout(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_setprobuyamout, DIALOG_STYLE_INPUT, "�������չ�����", "����������", "ȷ��", "ȡ��");
		if(amout<=0||amout>10000)return Dialog_Show(playerid, dl_setprobuyamout, DIALOG_STYLE_INPUT, "�������չ�����", "����������", "ȷ��", "ȡ��");
        Dialog_Show(playerid, dl_setprobuymoney, DIALOG_STYLE_INPUT, "�������չ��۸�", "������۸�", "ȷ��", "ȡ��");
        SetPVarInt(playerid,"amouts",amout);
	}
	return 1;
}
Dialog:dl_setprobuymoney(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new money;
		if(sscanf(inputtext, "i",money))return Dialog_Show(playerid, dl_setprosellmoney, DIALOG_STYLE_INPUT, "�������չ��۸�", "������۸�", "ȷ��", "ȡ��");
		if(money<=0||money>MAX_MONEY)return Dialog_Show(playerid, dl_setprosellmoney, DIALOG_STYLE_INPUT, "�������չ��۸�", "������۸�", "ȷ��", "ȡ��");
		new listid=GetPVarInt(playerid,"listIDA");
        new hid=GetPVarInt(playerid,"houseid");
        new amout=GetPVarInt(playerid,"amouts");
        AddBuyProStock(hid,Daoju[listid][d_did],amout,money);
	}
	return 1;
}
stock AddSellProStock(proid,did,amout,money)
{
	foreach(new i:prostock[proid])
	{
	    if(prostock[proid][i][ps_type]==SELL_TYPE)
	    {
			if(prostock[proid][i][ps_did]==did&&prostock[proid][i][ps_amout]>0)
			{
			    prostock[proid][i][ps_amout]+=amout;
			    prostock[proid][i][ps_value]=money;
			    SaveProStock(proid);
			    return 1;
			}
			if(prostock[proid][i][ps_did]==did&&prostock[proid][i][ps_amout]<0)
			{
			    Iter_Remove(prostock[proid],i);
			    SaveProStock(proid);
			    return 1;
			}
		}
	}
    new x=Iter_Free(prostock[proid]);
    prostock[proid][x][ps_type]=SELL_TYPE;
    prostock[proid][x][ps_value]=money;
    prostock[proid][x][ps_did]=did;
    prostock[proid][x][ps_amout]=amout;
    Iter_Add(prostock[proid],x);
	SaveProStock(proid);
	new tmps[128];
	format(tmps, sizeof(tmps),"ID:%i[%s]%s�ϼ����µ���Ʒ%i��%s,ÿ���۸�Ϊ%i,����������",proid,protypestr[property[proid][pro_type]],property[proid][pro_name],amout,Daoju[prostock[proid][x][ps_did]][d_name],prostock[proid][x][ps_value]);
	SendMessageToAll(COLOR_YELLOWLight,tmps);
	return 1;
}
stock DelSellProStock(proid,did,amout)
{
	foreach(new i:prostock[proid])
	{
	    if(prostock[proid][i][ps_type]==SELL_TYPE)
	    {
			if(prostock[proid][i][ps_did]==did)
			{
			    prostock[proid][i][ps_amout]-=amout;
			    if(prostock[proid][i][ps_amout]<1)Iter_Remove(prostock[proid],i);
			    SaveProStock(proid);
			    return 1;
			}
		}
	}
	return 1;
}
stock GetSellProStockAmout(proid,did)
{
	foreach(new i:prostock[proid])
	{
	    if(prostock[proid][i][ps_type]==SELL_TYPE)
	    {
			if(prostock[proid][i][ps_did]==did)
			{
			    return prostock[proid][i][ps_amout];
			}
		}
	}
	return 0;
}
stock AddBuyProStock(proid,did,amout,money)
{
	foreach(new i:prostock[proid])
	{
	    if(prostock[proid][i][ps_type]==BUY_TYPE)
	    {
			if(prostock[proid][i][ps_did]==did&&prostock[proid][i][ps_amout]>0)
			{
			    prostock[proid][i][ps_amout]+=amout;
			    prostock[proid][i][ps_value]=money;
			    SaveProStock(proid);
			    return 1;
			}
			if(prostock[proid][i][ps_did]==did&&prostock[proid][i][ps_amout]<0)
			{
			    Iter_Remove(prostock[proid],i);
			    SaveProStock(proid);
			    return 1;
			}
		}
	}
    new x=Iter_Free(prostock[proid]);
    prostock[proid][x][ps_type]=BUY_TYPE;
    prostock[proid][x][ps_value]=money;
    prostock[proid][x][ps_did]=did;
    prostock[proid][x][ps_amout]=amout;
    Iter_Add(prostock[proid],x);
	SaveProStock(proid);
	new tmps[128];
	format(tmps, sizeof(tmps),"ID:%i[%s]%s�����չ���Ʒ%i��%s,�չ��۸�Ϊ%i,����������",proid,protypestr[property[proid][pro_type]],property[proid][pro_name],amout,Daoju[prostock[proid][x][ps_did]][d_name],prostock[proid][x][ps_value]);
	SendMessageToAll(COLOR_LIGHTGOLDENRODYELLOW,tmps);
	return 1;
}
stock DelBuyProStock(proid,did,amout)
{
	foreach(new i:prostock[proid])
	{
	    if(prostock[proid][i][ps_type]==BUY_TYPE)
	    {
			if(prostock[proid][i][ps_did]==did)
			{
			    prostock[proid][i][ps_amout]-=amout;
			    if(prostock[proid][i][ps_amout]<1)Iter_Remove(prostock[proid],i);
			    SaveProStock(proid);
			    return 1;
			}
		}
	}
	return 1;
}
stock GetBuyProStockAmout(proid,did)
{
	foreach(new i:prostock[proid])
	{
	    if(prostock[proid][i][ps_type]==BUY_TYPE)
	    {
			if(prostock[proid][i][ps_did]==did)
			{
			    return prostock[proid][i][ps_amout];
			}
		}
	}
	return 0;
}
Dialog:dl_buypro(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(UID[PU[playerid]][u_Score]<500)return SM(COLOR_TWTAN,"��Ļ��ֲ���500,�޷�����ҵ");
	    if(property[GetPVarInt(playerid,"houseid")][pro_stat]==OWNERS)return SM(COLOR_TWAQUA,"����ҵ�ѱ�����");
	    EnoughMoney(playerid,property[GetPVarInt(playerid,"houseid")][pro_value]);
		Moneyhandle(PU[playerid],-property[GetPVarInt(playerid,"houseid")][pro_value]);
		property[GetPVarInt(playerid,"houseid")][pro_uid]=PU[playerid];
        property[GetPVarInt(playerid,"houseid")][pro_stat]=OWNERS;
        DeleteProperty(GetPVarInt(playerid,"houseid"));
		CreateProperty(GetPVarInt(playerid,"houseid"));
		Savedpropertydata(GetPVarInt(playerid,"houseid"));
		DeletePVar(playerid,"houseid");
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_buyplayerpro(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(UID[PU[playerid]][u_Score]<500)return SM(COLOR_TWTAN,"��Ļ��ֲ���500,�޷�����ҵ");
	    if(property[GetPVarInt(playerid,"houseid")][pro_stat]==OWNERS)return SM(COLOR_TWAQUA,"����ҵ�ѱ�����");
	    EnoughMoney(playerid,property[GetPVarInt(playerid,"houseid")][pro_value]);
		Moneyhandle(PU[playerid],-property[GetPVarInt(playerid,"houseid")][pro_value]);
	    Cunkuanhandle(property[GetPVarInt(playerid,"houseid")][pro_uid],property[GetPVarInt(playerid,"houseid")][pro_value]);
	    new tm[150];
	    format(tm,150,"%s�����������ҵ[%s]%s����$%i,�ʽ��ѻ�����������˻��ڡ�",Gn(playerid),protypestr[property[GetPVarInt(playerid,"houseid")][pro_type]],property[GetPVarInt(playerid,"houseid")][pro_name],property[GetPVarInt(playerid,"houseid")][pro_value]);
	    AddPlayerLog(property[GetPVarInt(playerid,"houseid")][pro_uid],"ϵͳ",tm);
		property[GetPVarInt(playerid,"houseid")][pro_uid]=PU[playerid];
        property[GetPVarInt(playerid,"houseid")][pro_stat]=OWNERS;
        DeleteProperty(GetPVarInt(playerid,"houseid"));
		CreateProperty(GetPVarInt(playerid,"houseid"));
		Savedpropertydata(GetPVarInt(playerid,"houseid"));
		DeletePVar(playerid,"houseid");
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_enterpro(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=GetPVarInt(playerid,"houseid"),tm[150];
	    EnoughMoney(playerid,property[i][pro_entervalue]);
		Moneyhandle(PU[playerid],-property[i][pro_entervalue]);
		Cunkuanhandle(property[i][pro_uid],property[i][pro_entervalue]);
	    format(tm,150,"%s�����������ҵ[%s]%s����$%i,�ʽ��Ѵ�����������˻��ڡ�",Gn(playerid),protypestr[property[i][pro_type]],property[i][pro_name],property[i][pro_entervalue]);
	    AddPlayerLog(property[i][pro_uid],"ϵͳ",tm);
		//Moneyhandle(property[i][pro_uid],property[i][pro_entervalue]);
		SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
		format(tm,100,"�������%i����ҵ%s[%s] ����:%s",i,property[i][pro_name],protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name]);
		SM(COLOR_TWTAN, tm);
		DeletePVar(playerid,"houseid");
		SM(COLOR_TWTAN, "��N�����Թ�����Ʒ");
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
stock Showproinfo(idx)
{
	new Astr[512],Str[64];
	format(Str, sizeof(Str), "����[%s]\n",property[idx][pro_name]);
	strcat(Astr,Str);
	if(property[idx][pro_open])format(Str, sizeof(Str), "��ҵ[��]\n");
	else format(Str, sizeof(Str), "��ҵ[��]\n");
	strcat(Astr,Str);
	format(Str, sizeof(Str), "��Ǯ��[$%i]\n",property[idx][pro_cunkuan]);
	strcat(Astr,Str);
	if(property[idx][pro_icol])format(Str, sizeof(Str), "��ɫ[��]\n");
	else format(Str, sizeof(Str), "��ɫ[��]\n");
	strcat(Astr,Str);
	format(Str, sizeof(Str), "����/�չ�\n");
	strcat(Astr,Str);
	format(Str, sizeof(Str), "�볡��[$%i]\n",property[idx][pro_entervalue]);
	strcat(Astr,Str);
	switch(property[idx][pro_stat])
	{
	    case OWNERS:format(Str, sizeof(Str), "����[δ]\n");
	    case SELLING:format(Str, sizeof(Str), "����[$%i]\n",property[idx][pro_value]);
	}
	strcat(Astr,Str);
	format(Str, sizeof(Str), "����");
	strcat(Astr,Str);
	return Astr;
}
Dialog:dl_setproname(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new text[100];
	    ReStr(inputtext);
		if(sscanf(inputtext, "s[100]",text))return Dialog_Show(playerid, dl_setproname, DIALOG_STYLE_INPUT, "��������", "����������", "ȷ��", "ȡ��");
	    new idx=GetPVarInt(playerid,"houseid");
	    format(property[idx][pro_name],100,text);
		Savedpropertydata(idx);
		DeleteProperty(idx);
		CreateProperty(idx);
		new	tm[100];
		format(tm,100,"��ҵID:%i����",idx);
    	Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(idx), "ѡ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_setproname, DIALOG_STYLE_INPUT, "��������", "����������", "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_setentervalue(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_setentervalue, DIALOG_STYLE_INPUT,"�����볡��", "��������", "ȷ��", "ȡ��");
	    new idx=GetPVarInt(playerid,"houseid");
		if(amout<1||amout>MAX_MONEY)return Dialog_Show(playerid, dl_setentervalue, DIALOG_STYLE_INPUT,"�����볡��", "��������", "ȷ��", "ȡ��");
	    property[idx][pro_entervalue]=amout;
		Savedpropertydata(idx);
		DeleteProperty(idx);
		CreateProperty(idx);
		new	tm[100];
		format(tm,100,"��ҵID:%i����",idx);
    	Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(idx), "ѡ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_setentervalue, DIALOG_STYLE_INPUT,"�����볡��", "��������", "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_setvalue(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_setvalue, DIALOG_STYLE_INPUT,"�����ۼ�", "��������", "ȷ��", "ȡ��");
	    if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid, dl_setvalue, DIALOG_STYLE_INPUT,"�����ۼ�", "��������", "ȷ��", "ȡ��");
	    new idx=GetPVarInt(playerid,"houseid");
		property[idx][pro_stat]=SELLING;
	    property[idx][pro_value]=strval(inputtext);
		Savedpropertydata(idx);
		DeleteProperty(idx);
		CreateProperty(idx);
		new	tm[100];
		format(tm,100,"��ҵID:%i����",idx);
    	Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(idx), "ѡ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_setvalue, DIALOG_STYLE_INPUT,"�����ۼ�", "��������", "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_probuy(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new hid=GetPVarInt(playerid,"houseid");
		new objids[MAX_PRO_STOCK],amoutes[MAX_PRO_STOCK][20];
	    current_number[playerid]=1;
	    new current=-1,idx=0;
        switch(listitem)
        {
            case 0:
			{
				foreach(new i:prostock[hid])
				{
				    if(prostock[hid][i][ps_type]==SELL_TYPE)
				    {
						current_idx[playerid][idx]=i;
						objids[idx]=Daoju[prostock[hid][i][ps_did]][d_obj];
				        format(amoutes[idx],20,"$%i",prostock[hid][i][ps_value]);
				       	current_number[playerid]++;
				       	current++;
				       	idx++;
				    }
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����û�е��߳���", "�õ�", "");
				new amouts=current+1;
				new tm[100];
				format(tm,100,"~y~SELLING~r~%i/%i",amouts,MAX_PRO_STOCK);
				ShowModelSelectionMenuEx(playerid,objids,amoutes,amouts,tm,CUSTOM_PRO_PLAYER_BUYBB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
				SM(COLOR_ORANGE,"��ѡ����Ҫ�������Ʒ");
			}
            case 1:
			{
				foreach(new i:prostock[hid])
				{
				    if(prostock[hid][i][ps_type]==BUY_TYPE)
				    {
						current_idx[playerid][idx]=i;
						objids[idx]=Daoju[prostock[hid][i][ps_did]][d_obj];
				        format(amoutes[idx],20,"$%i",prostock[hid][i][ps_value]);
				       	current_number[playerid]++;
				       	current++;
				       	idx++;
				    }
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����û�е��߳���", "�õ�", "");
				new amouts=current+1;
				new tm[100];
				format(tm,100,"~y~BUYING~r~%i/%i",amouts,MAX_PRO_STOCK);
				ShowModelSelectionMenuEx(playerid,objids,amoutes,amouts,tm,CUSTOM_PRO_PLAYER_SELLBB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
                SM(COLOR_ORANGE,"��ѡ����Ҫ���۵���Ʒ");
			}
        }
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_player_selldaodu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_player_selldaodu, DIALOG_STYLE_INPUT, "��������Ҫ���۸���", "����������", "ȷ��", "ȡ��");
		if(amout<1||amout>100)return Dialog_Show(playerid, dl_player_selldaodu, DIALOG_STYLE_INPUT, "��������Ҫ���۸���", "���������", "ȷ��", "ȡ��");
	    new hid=GetPVarInt(playerid,"houseid");
	    new i=GetPVarInt(playerid,"listIDA");
	    if(strval(inputtext)>GetBeibaoAmout(playerid,prostock[hid][i][ps_did]))return Dialog_Show(playerid,dl_player_selldaodu, DIALOG_STYLE_INPUT, "��û��ô��", "��������Ҫ��������", "ȷ��", "ȡ��");
		if(strval(inputtext)>prostock[hid][i][ps_amout])return Dialog_Show(playerid,dl_player_selldaodu, DIALOG_STYLE_INPUT, "��ʾ", "������ĳ����˱�����չ�����������������", "ȷ��", "ȡ��");
        if(prostock[hid][i][ps_value]*amout>property[hid][pro_cunkuan])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˵��ߵ�û����ô��Ǯ�����չ�", "��", "");
		property[hid][pro_cunkuan]-=prostock[hid][i][ps_value]*amout;
		Savedpropertydata(hid);
        Moneyhandle(PU[playerid],prostock[hid][i][ps_value]*amout);
	    new tm[150];
	    format(tm,150,"%s����%i���������ҵ[%s]%s���չ���%s������$%i,�����ڸ����С�",Gn(playerid),amout,protypestr[property[i][pro_type]],property[i][pro_name],Daoju[prostock[hid][i][ps_did]][d_name],prostock[hid][i][ps_value]*amout);
	    AddPlayerLog(property[hid][pro_uid],"ϵͳ",tm,0,prostock[hid][i][ps_did],amout);
	    DelBuyProStock(hid,prostock[hid][i][ps_did],amout);
	    Delbeibao(playerid,prostock[hid][i][ps_did],amout);
	}
    else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_edit_selldaodu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new hid=GetPVarInt(playerid,"houseid");
	    new i=GetPVarInt(playerid,"listIDA");
	    Addbeibao(playerid,prostock[hid][i][ps_did],GetSellProStockAmout(hid,prostock[hid][i][ps_did]));
	    DelSellProStock(hid,prostock[hid][i][ps_did],GetSellProStockAmout(hid,prostock[hid][i][ps_did]));
	}
	return 1;
}
Dialog:dl_edit_buydaodu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new hid=GetPVarInt(playerid,"houseid");
	    new i=GetPVarInt(playerid,"listIDA");
	    DelBuyProStock(hid,prostock[hid][i][ps_did],GetBuyProStockAmout(hid,prostock[hid][i][ps_did]));
	}
	return 1;
}
Dialog:dl_player_buydaodu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_player_buydaodu, DIALOG_STYLE_INPUT, "�����빺�����", "����������", "ȷ��", "ȡ��");
		if(amout<1||amout>100)return Dialog_Show(playerid, dl_player_buydaodu, DIALOG_STYLE_INPUT, "�����빺�����", "����������", "ȷ��", "ȡ��");
	    new hid=GetPVarInt(playerid,"houseid");
	    new i=GetPVarInt(playerid,"listIDA");
	    if(prostock[hid][i][ps_value]*amout>UID[PU[playerid]][u_Cash])return SM(COLOR_TWTAN,"��û���㹻��Ǯ");
		if(amout>GetSellProStockAmout(hid,prostock[hid][i][ps_did]))return Dialog_Show(playerid, dl_player_buydaodu, DIALOG_STYLE_INPUT, "�����빺�����", "����������", "ȷ��", "ȡ��");
        Moneyhandle(PU[playerid],-prostock[hid][i][ps_value]*amout);
	    new tm[150];
	    format(tm,150,"%s�����������ҵ[%s]%s��%i��%s����$%i,�ʽ��Ѵ��븽����",Gn(playerid),protypestr[property[i][pro_type]],property[i][pro_name],amout,Daoju[prostock[hid][i][ps_did]][d_name],prostock[hid][i][ps_value]*amout);
	    AddPlayerLog(property[hid][pro_uid],"ϵͳ",tm,prostock[hid][i][ps_value]*amout);
	    DelSellProStock(hid,prostock[hid][i][ps_did],amout);
	    Addbeibao(playerid,prostock[hid][i][ps_did],amout);
		SM(COLOR_TWTAN,"����ɹ�����������ı���/WDBB");
	}
    else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_setprocunkuan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        switch(listitem)
        {
            case 0:
			{
				Dialog_Show(playerid, dl_setprocunkuancr, DIALOG_STYLE_INPUT,"��ʾ", "�����������", "ȷ��", "ȡ��");
			}
            case 1:
			{
			    Dialog_Show(playerid, dl_setprocunkuanqc, DIALOG_STYLE_INPUT,"��ʾ", "������ȡ�����", "ȷ��", "ȡ��");
			}
		}
	}
	return 1;
}
Dialog:dl_setprocunkuancr(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new money;
		if(sscanf(inputtext, "i",money))return Dialog_Show(playerid, dl_setprocunkuancr, DIALOG_STYLE_INPUT,"��ʾ", "�����������", "ȷ��", "ȡ��");
		if(money<1||money>MAX_MONEY)return Dialog_Show(playerid, dl_setprocunkuancr, DIALOG_STYLE_INPUT,"��ʾ", "�����������", "ȷ��", "ȡ��");
	    new hid=GetPVarInt(playerid,"houseid");
	    EnoughMoney(playerid,money);
	    Moneyhandle(PU[playerid],-money);
	    property[hid][pro_cunkuan]+=money;
	    SM(COLOR_TWTAN,"����ɹ�");
	}
	return 1;
}
Dialog:dl_setprocunkuanqc(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new money;
		if(sscanf(inputtext, "i",money))return Dialog_Show(playerid, dl_setprocunkuanqc, DIALOG_STYLE_INPUT,"��ʾ", "������ȡ�����", "ȷ��", "ȡ��");
		if(money<1||money>MAX_MONEY)return Dialog_Show(playerid, dl_setprocunkuanqc, DIALOG_STYLE_INPUT,"��ʾ", "������ȡ�����", "ȷ��", "ȡ��");
	    new hid=GetPVarInt(playerid,"houseid");
	    if(property[hid][pro_cunkuan]<money)return Dialog_Show(playerid, dl_setprocunkuanqc, DIALOG_STYLE_INPUT,"��ʾ", "û����ô��,������ȡ�����", "ȷ��", "ȡ��");
	    Moneyhandle(PU[playerid],money);
	    property[hid][pro_cunkuan]-=money;
	    SM(COLOR_TWTAN,"ȡ���ɹ�");
	}
	return 1;
}
Dialog:dl_editpro(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=GetPVarInt(playerid,"houseid");
	    new tm[100];
        switch(listitem)
        {
            case 0:
			{
			    format(tm,100,"��ҵID:%i��������",i);
				Dialog_Show(playerid, dl_setproname, DIALOG_STYLE_INPUT, tm, "����������", "ȷ��", "ȡ��");
			}
            case 1:
			{
				if(property[i][pro_open])
				{
				    property[i][pro_open]=0;
				    Savedpropertydata(i);
				    format(tm,100,""#H_PRO"[%s]%s��%s��ҵ��",protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name],property[i][pro_name]);
					SendClientMessageToAll(MESSAGE_COLOR,tm);
				 	format(tm,100,"��ҵID:%i����",i);
				 	Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(i), "ѡ��", "ȡ��");
				}
				else
				{
				    property[i][pro_open]=1;
				    Savedpropertydata(i);
				    format(tm,100,""#H_PRO"[%s]%s��%s��ҵ��",protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name],property[i][pro_name]);
					SendClientMessageToAll(MESSAGE_COLOR,tm);
				 	format(tm,100,"��ҵID:%i����",i);
				 	Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(i), "ѡ��", "ȡ��");
				}
				DeleteProperty(i);
				CreateProperty(i);
			}
            case 2:
			{
			    format(tm,100,"��ҵID:%i��Ǯ������",i);
                Dialog_Show(playerid, dl_setprocunkuan,DIALOG_STYLE_LIST, tm, "��Ǯ\nȡǮ", "ȷ��", "ȡ��");
			}
            case 3:
			{
				if(property[i][pro_icol])
				{
				    property[i][pro_icol]=0;
				    Savedpropertydata(i);
				}
				else
				{
				    property[i][pro_icol]=1;
				    Savedpropertydata(i);
				}
				DeleteProperty(i);
				CreateProperty(i);
				format(tm,100,"��ҵID:%i����",i);
				Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(i), "ѡ��", "ȡ��");
			}
            case 4:
			{
				format(tm,100,"��ҵID:%i����/�չ�",i);
			 	Dialog_Show(playerid,dl_progivesell, DIALOG_STYLE_LIST,tm,"�鿴����\n�鿴�չ�\n���߽���\n�����չ�", "ѡ��", "ȡ��");
			}
            case 5:
			{
			    format(tm,100,"��ҵID:%i�����볡��",i);
			    Dialog_Show(playerid, dl_setentervalue, DIALOG_STYLE_INPUT, tm, "��������", "ȷ��", "ȡ��");
			}
            case 6:
			{
			    if(property[i][pro_stat]==OWNERS)
			    {
			        format(tm,100,"��ҵID:%i���ó��۷���",i);
			        Dialog_Show(playerid, dl_setvalue, DIALOG_STYLE_INPUT, tm, "��������", "ȷ��", "ȡ��");
			    }
			    else
			    {
			        property[i][pro_stat]=OWNERS;
			        Savedpropertydata(i);
					DeleteProperty(i);
					CreateProperty(i);
			    }
			}
            case 7:
			{
  				property[i][pro_stat]=NONEONE;
			    property[i][pro_uid]=-1;
			    Savedpropertydata(i);
				DeleteProperty(i);
				CreateProperty(i);
			}
        }
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_cunkuan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<1||strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_cunkuan, DIALOG_STYLE_INPUT,"���","��ֵ����,��������Ҫ����Ľ��", "ȷ��", "ȡ��");
        if(!EnoughMoneyEx(playerid,strval(inputtext)))return Dialog_Show(playerid,dl_cunkuan, DIALOG_STYLE_INPUT,"���","��û����ô��Ǯ", "ȷ��", "ȡ��");
        Moneyhandle(PU[playerid],-strval(inputtext));
        Cunkuanhandle(PU[playerid],strval(inputtext));
    	new Str[128];
		format(Str,sizeof(Str),"%s�������������$%i",Gnn(playerid),strval(inputtext));
		AdminWarn(Str);
		AnnounceWarn(Str);
 	}
	return 1;
}
Dialog:dl_qukuan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext)<1||strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_qukuan, DIALOG_STYLE_INPUT,"ȡ��","��ֵ����,��������Ҫȡ���Ľ��", "ȷ��", "ȡ��");
        if(UID[PU[playerid]][u_Cunkuan]<strval(inputtext))return Dialog_Show(playerid,dl_cunkuan, DIALOG_STYLE_INPUT,"ȡ��","����˻���û����ô��Ǯ", "ȷ��", "ȡ��");
		Cunkuanhandle(PU[playerid],-strval(inputtext));
        Moneyhandle(PU[playerid],strval(inputtext));
    	new Str[128];
		format(Str,sizeof(Str),"%s��������ȡ����$%i",Gnn(playerid),strval(inputtext));
		AdminWarn(Str);
		AnnounceWarn(Str);
 	}
	return 1;
}
new error_gname[][] =
{
    "!",
	"#",
	"$",
	"%",
	"'",
	"*",

	"/",
	":",
	"<",
	">",
	"?",
	"|"
};
stock Finderror(playername[])
{
    Loop(i, sizeof(Name_error))
	{
		if(strfindEx(playername,error_gname[i], true) != -1)return false;
	}
	return true;
}
stock fcopy(oldname[],newname[])
{
	new File:ohnd,File:nhnd;
	if (!fexist(oldname)) return false;
	ohnd=fopen(oldname,io_read);
	nhnd=fopen(newname,io_write);
	new buf2[1];
	new i;
	for (i=flength(ohnd);i>0;i--) {
		fputchar(nhnd, fgetchar(ohnd, buf2[0],false),false);
	}
	fclose(ohnd);
	fclose(nhnd);
	return true;
}
stock frename(oldname[],newname[]) {
    if (!fexist(oldname)) return false;
    fremove(newname);
    if (!fcopy(oldname,newname)) return false;
    fremove(oldname);
    return true;
}
stock Loopplayername(name[])
{
	foreach(new i:UID)
	{
		if(!strcmpEx(name,UID[i][u_name], false))return 1;
	}
	return 0;
}
Dialog:dl_gname(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!EnoughMoneyEx(playerid,5000000))return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","��û����ô��Ǯ$5000000", "����", "");
        if(UID[PU[playerid]][u_wds]<20)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","��û����ô��V��", "����", "");
	    if(Loopplayername(inputtext))return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","������ʹ�ô���", "����", "");
        VBhandle(PU[playerid],-20);
        Moneyhandle(PU[playerid],-5000000);
	    new text[100];
	    ReStr(inputtext);
		if(strlen(inputtext)<1||strlen(inputtext)>24)
		{
		    format(text,100,"�㵱ǰ����:%s\n��ע�ⲻҪ����[! # $ % ' * / : < > ? |]���������\n���������ʧ,����Ը�",UID[PU[playerid]][u_name]);
			Dialog_Show(playerid,dl_gname, DIALOG_STYLE_INPUT,"����",text, "ȷ��", "ȡ��");
			return 1;
		}
		if(sscanf(inputtext, "s[100]",text))
		{
		    format(text,100,"�㵱ǰ����:%s\n��ע�ⲻҪ����[! # $ % ' * / : < > ? |]���������\n���������ʧ,����Ը�",UID[PU[playerid]][u_name]);
			Dialog_Show(playerid,dl_gname, DIALOG_STYLE_INPUT,"����",text, "ȷ��", "ȡ��");
			return 1;
		}
		if(!Finderror(text))
		{
		    format(text,100,"�㵱ǰ����:%s\n��ע�ⲻҪ����[! # $ % ' * / : < > ? |]���������\n���������ʧ,����Ը�",UID[PU[playerid]][u_name]);
			Dialog_Show(playerid,dl_gname, DIALOG_STYLE_INPUT,"����",text, "ȷ��", "ȡ��");
			return 1;
		}
		format(UID[PU[playerid]][u_name],100,text);
		new Stru1[80],Stru2[80];
    	format(Stru1,sizeof(Stru1),USER_ZB_FILE,Gn(playerid));
    	format(Stru2,sizeof(Stru2),USER_ZB_FILE,text);
		frename(Stru1,Stru2);
		format(Stru1,sizeof(Stru1),USER_BAG_FILE,Gn(playerid));
		format(Stru2,sizeof(Stru2),USER_BAG_FILE,text);
		frename(Stru1,Stru2);
		foreach(new i:VInfo)
		{
			if(VInfo[i][v_uid]==PU[playerid]&&CarTypes[VInfo[i][v_cid]]==OwnerVeh)
			{
				DeleteColor3DTextLabel(VInfo[i][v_text]);
				Createcar3D(i);
 			}
		}
  		foreach(new i:HOUSE)
		{
	    	if(HOUSE[i][H_isSEL]!=NONEONE&&HOUSE[i][H_UID]==PU[playerid])
	    	{
			 	DelHouse(i);
				CreateHouse(i);
        	}
		}
		if(UID[PU[playerid]][u_gid]!=-1)
		{
			foreach(new i:GInfo)
			{
				if(PU[playerid]==GInfo[i][g_uid])
				{
					DeleteColor3DTextLabel(GInfo[i][g_text]);
					DestroyDynamicPickup(GInfo[i][g_pick]);
					CreateGang(i);
				}
			}
		}
		SetPlayerName(playerid,UID[PU[playerid]][u_name]);
		Saveduid_data(PU[playerid]);
	}
	return 1;
}
stock Pro_Onplayerkey(playerid, newkeys, oldkeys)
{
	if(PRESSED(KEY_SECONDARY_ATTACK))
	{
		Garbage[playerid][keycount]=GetTickCount();
		if(Garbage[playerid][keycount]-Garbage[playerid][keytime]<GARTIME)
		{
			SM(COLOR_TWAQUA,"���Ե�2����ٰ���");
			return 1;
		}
		Garbage[playerid][keytime]=Garbage[playerid][keycount];
	    new hys=GetClosesthuoyan(playerid);
	    if(hys!=-1)
	    {
			new text[100];
			GetPVarString(playerid,"makefood",text,100);
		    if(strlenEx(text))return SM(COLOR_TWTAN,"������������ʳ�����Ե���ʹ��");
	        if(GetAreaJJprotectEx(hys,playerid)||Ishousepro(playerid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","���̻򷿲��ѿ����Ҿ߱������޷������Ҿ�", "�õ�", "");
	        Dialog_Show(playerid,dl_pengren, DIALOG_STYLE_MSGBOX,"���","�Ƿ�ʹ�ø����������ʳ��", "ʹ��", "����");
	    }
	    if(IsPlayerInRangeOfPoint(playerid,2.0,2000.3889,1550.6478,13.6122))
		{
			new text[100];
			GetPVarString(playerid,"makefood",text,100);
		    if(strlenEx(text))return SM(COLOR_TWTAN,"������������ʳ�����Ե���ʹ��");
			Dialog_Show(playerid,dl_pengren, DIALOG_STYLE_MSGBOX,"������⿴�","�Ƿ�ʹ�ø����������ʳ��", "ʹ��", "����");
		}
	    if(IsPlayerInRangeOfPoint(playerid,2.0,1435.3912,-997.8404,1639.8025))
		{
		    new sms[100];
		    format(sms,100,"�㵱ǰ�ֽ�:$%i,���:$%i\n��������Ҫ����Ľ��",UID[PU[playerid]][u_Cash],UID[PU[playerid]][u_Cunkuan]);
			Dialog_Show(playerid,dl_cunkuan, DIALOG_STYLE_INPUT,"���",sms, "ȷ��", "ȡ��");
		}
	    if(IsPlayerInRangeOfPoint(playerid,2.0,1431.0264,-998.0081,1639.7957))
		{
			new sms[100];
		    format(sms,100,"�㵱ǰ�ֽ�:$%i,���:$%i\n��������Ҫȡ���Ľ��",UID[PU[playerid]][u_Cash],UID[PU[playerid]][u_Cunkuan]);
			Dialog_Show(playerid,dl_qukuan, DIALOG_STYLE_INPUT,"ȡ��",sms, "ȷ��", "ȡ��");
		}
	    if(IsPlayerInRangeOfPoint(playerid,2.0,1442.2993,-1002.8080,1639.7957))
		{
			new sms[100];
		    format(sms,100,"�㵱ǰ����:%s\n������Ҫ20V��+500W\n��ע�ⲻҪ����[! # $ % ' * / : < > ? |]���������\n���������ʧ,����Ը�",UID[PU[playerid]][u_name]);
			Dialog_Show(playerid,dl_gname, DIALOG_STYLE_INPUT,"����",sms, "ȷ��", "ȡ��");
		}
	    if(IsPlayerInRangeOfPoint(playerid,2.0,1442.1156,-985.7976,1639.8025))
		{
		    new idx=Getcaipiao();
			if(idx==-1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"�Բ���","��ǰû�в�Ʊ���л����ڿ���,���Ե�", "��", "");
			new sms[100];
		    format(sms,100,"��ǰ���в�ƱΪ%s,ÿ������8:00����\n��ѡ����Ҫ�Ĳ���",caipiao[idx][cp_name]);
			Dialog_Show(playerid,dl_cptzz, DIALOG_STYLE_MSGBOX,"Ͷעվ",sms, "Ͷע��Ʊ", "������¼");
		}
	    if(IsPlayerInRangeOfPoint(playerid,2.0,968.4280,-1357.8716,13.3502))
		{
			new tmp[4128],Stru[100];
			format(Stru,100, "����\t�ۼ�\t���\t����\n");
			strcat(tmp,Stru);
			Loop(x,sizeof(fresh))
			{
			    switch(fresh[x][fresh_type])
			    {
			        case VERGET:format(Stru, sizeof(Stru),"%s\t$%i\t%i��\t�߲�\n",fresh[x][fresh_name],fresh[x][fresh_sell],fresh[x][fresh_amout]);
			        case MEAT:format(Stru, sizeof(Stru),"%s\t$%i\t%i��\t��ʳ\n",fresh[x][fresh_name],fresh[x][fresh_sell],fresh[x][fresh_amout]);
			    }
				strcat(tmp,Stru);
			}
			Dialog_Show(playerid,dl_syssellresh,DIALOG_STYLE_TABLIST_HEADERS,"ѡ���빺���ʳ��",tmp,"ȷ��", "ȡ��");
		}
		new i,type;
		GetClosestPro(playerid,i,type);
		if(i!=-1)
		{
		    if(type)SetPlayerPosEx(playerid,property[i][pro_ox],property[i][pro_oy],property[i][pro_oz],property[i][pro_oa],property[i][pro_oin],property[i][pro_owl],-1,0,0);
		    else
		    {
			    new tm[100];
			    switch(property[i][pro_type])
				{
	    			case PRO_SELL:
					{
					    switch(property[i][pro_stat])
						{
	    					case NONEONE:
							{
						        format(tm,100,"��%s��ҵID:%i�ۼ�$%i,�Ƿ���",property[i][pro_name],i,property[i][pro_value]);
						    	Dialog_Show(playerid,dl_buypro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    	SetPVarInt(playerid,"houseid",i);
							}
	    					case OWNERS:
							{
								if(!property[i][pro_open]&&property[i][pro_uid]!=PU[playerid])
						    	{
									format(tm,100,"%s��%s��ҵID:%iû�п�ҵ",UID[property[i][pro_uid]][u_name],property[i][pro_name],i);
									SM(COLOR_TWTAN, tm);
									return 1;
						    	}
						    	else
						    	{
						    	    if(property[i][pro_uid]==PU[playerid])
						    	    {
										SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
										format(tm,100,"��ӭ�ص������ҵ",i);
										SM(COLOR_TWTAN, tm);
									}
									else
									{
                                        if(property[i][pro_entervalue]>0)
                                        {
                                            SetPVarInt(playerid,"houseid",i);
											format(tm,100,"����%s��ҵID:%i��Ҫ����%i,�Ƿ�������룿",property[i][pro_name],i,property[i][pro_entervalue]);
						    	        	Dialog_Show(playerid,dl_enterpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "������");
                                        }
                                        else
                                        {
                                            SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
											format(tm,100,"�������%i����ҵ%s[%s] ����:%s",i,property[i][pro_name],protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name]);
											SM(COLOR_TWTAN, tm);
                                        }
									}
						    	}
							}
	    					case SELLING:
							{
							    if(property[i][pro_uid]!=PU[playerid])
							    {
						        	format(tm,100,"%s��%s��ҵID:%i�ۼ�$%i,�Ƿ���",UID[property[i][pro_uid]][u_name],property[i][pro_name],i,property[i][pro_value]);
						    		Dialog_Show(playerid,dl_buyplayerpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    		SetPVarInt(playerid,"houseid",i);
						    	}
						    	else
						    	{
									SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
									if(property[i][pro_uid]==PU[playerid])format(tm,100,"��ӭ�ص������ҵ",i);
									else format(tm,100,"�������%i����ҵ",i);
									SM(COLOR_TWTAN, tm);
						    	}
							}
						}
					}
					case PRO_BANK:
					{
					    switch(property[i][pro_stat])
						{
	    					case NONEONE:
							{
						        format(tm,100,"��%s��ҵID:%i�ۼ�$%i,�Ƿ���",property[i][pro_name],i,property[i][pro_value]);
						    	Dialog_Show(playerid,dl_buypro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    	SetPVarInt(playerid,"houseid",i);
							}
	    					case OWNERS:
							{
								if(!property[i][pro_open]&&property[i][pro_uid]!=PU[playerid])
						    	{
									format(tm,100,"%s��%s��ҵID:%iû�п�ҵ",UID[property[i][pro_uid]][u_name],property[i][pro_name],i);
									SM(COLOR_TWTAN, tm);
									return 1;
						    	}
						    	else
						    	{
						    	    if(property[i][pro_uid]==PU[playerid])
						    	    {
										SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
										format(tm,100,"��ӭ�ص������ҵ",i);
										SM(COLOR_TWTAN, tm);
									}
									else
									{
                                        if(property[i][pro_entervalue]>0)
                                        {
                                            SetPVarInt(playerid,"houseid",i);
											format(tm,100,"����%s��ҵID:%i��Ҫ����%i,�Ƿ�������룿",property[i][pro_name],i,property[i][pro_entervalue]);
						    	        	Dialog_Show(playerid,dl_enterpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "������");
                                        }
                                        else
                                        {
											SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
											format(tm,100,"�������%i����ҵ%s[%s] ����:%s",i,property[i][pro_name],protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name]);
											SM(COLOR_TWTAN, tm);
                                        }
									}
						    	}
							}
	    					case SELLING:
							{
							    if(property[i][pro_uid]!=PU[playerid])
							    {
						        	format(tm,100,"%s��%s��ҵID:%i�ۼ�$%i,�Ƿ���",UID[property[i][pro_uid]][u_name],property[i][pro_name],i,property[i][pro_value]);
						    		Dialog_Show(playerid,dl_buyplayerpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    		SetPVarInt(playerid,"houseid",i);
						    	}
						    	else
						    	{
									SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
									if(property[i][pro_uid]==PU[playerid])format(tm,100,"��ӭ�ص������ҵ",i);
									else format(tm,100,"�������%i����ҵ",i);
									SM(COLOR_TWTAN, tm);
						    	}
							}
						}
					}
					case PRO_RACE:
					{
					    switch(property[i][pro_stat])
						{
	    					case NONEONE:
							{
						        format(tm,100,"��%s��ҵID:%i�ۼ�$%i,�Ƿ���",property[i][pro_name],i,property[i][pro_value]);
						    	Dialog_Show(playerid,dl_buypro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    	SetPVarInt(playerid,"houseid",i);
							}
	    					case OWNERS:
							{
								if(!property[i][pro_open]&&property[i][pro_uid]!=PU[playerid])
						    	{
									format(tm,100,"%s��%s��ҵID:%iû�п�ҵ",UID[property[i][pro_uid]][u_name],property[i][pro_name],i);
									SM(COLOR_TWTAN, tm);
									return 1;
						    	}
						    	else
						    	{
						    	    if(property[i][pro_uid]==PU[playerid])
						    	    {
										SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
										format(tm,100,"��ӭ�ص������ҵ",i);
										SM(COLOR_TWTAN, tm);
									}
									else
									{
                                        if(property[i][pro_entervalue]>0)
                                        {
                                            SetPVarInt(playerid,"houseid",i);
											format(tm,100,"����%s��ҵID:%i��Ҫ����%i,�Ƿ�������룿",property[i][pro_name],i,property[i][pro_entervalue]);
						    	        	Dialog_Show(playerid,dl_enterpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "������");
                                        }
                                        else
                                        {
                                            SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
											format(tm,100,"�������%i����ҵ%s[%s] ����:%s",i,property[i][pro_name],protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name]);
											SM(COLOR_TWTAN, tm);
                                        }
									}
						    	}
							}
	    					case SELLING:
							{
							    if(property[i][pro_uid]!=PU[playerid])
							    {
						        	format(tm,100,"%s��%s��ҵID:%i�ۼ�$%i,�Ƿ���",UID[property[i][pro_uid]][u_name],property[i][pro_name],i,property[i][pro_value]);
						    		Dialog_Show(playerid,dl_buyplayerpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    		SetPVarInt(playerid,"houseid",i);
						    	}
						    	else
						    	{
									SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
									if(property[i][pro_uid]==PU[playerid])format(tm,100,"��ӭ�ص������ҵ",i);
									else format(tm,100,"�������%i����ҵ",i);
									SM(COLOR_TWTAN, tm);
						    	}
							}
						}
					}
					case PRO_AREA:
					{
					    switch(property[i][pro_stat])
						{
	    					case NONEONE:
							{
						        format(tm,100,"��%s��ҵID:%i�ۼ�$%i,�Ƿ���",property[i][pro_name],i,property[i][pro_value]);
						    	Dialog_Show(playerid,dl_buypro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    	SetPVarInt(playerid,"houseid",i);
							}
	    					case OWNERS:
							{
								if(!property[i][pro_open]&&property[i][pro_uid]!=PU[playerid])
						    	{
									format(tm,100,"%s��%s��ҵID:%iû�п�ҵ",UID[property[i][pro_uid]][u_name],property[i][pro_name],i);
									SM(COLOR_TWTAN, tm);
									return 1;
						    	}
						    	else
						    	{
						    	    if(property[i][pro_uid]==PU[playerid])
						    	    {
										SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
										format(tm,100,"��ӭ�ص������ҵ",i);
										SM(COLOR_TWTAN, tm);
									}
									else
									{
                                        if(property[i][pro_entervalue]>0)
                                        {
                                            SetPVarInt(playerid,"houseid",i);
											format(tm,100,"����%s��ҵID:%i��Ҫ����%i,�Ƿ�������룿",property[i][pro_name],i,property[i][pro_entervalue]);
						    	        	Dialog_Show(playerid,dl_enterpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "������");
                                        }
                                        else
                                        {
                                            SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
											format(tm,100,"�������%i����ҵ%s[%s] ����:%s",i,property[i][pro_name],protypestr[property[i][pro_type]],UID[property[i][pro_uid]][u_name]);
											SM(COLOR_TWTAN, tm);
                                        }
									}
						    	}
							}
	    					case SELLING:
							{
							    if(property[i][pro_uid]!=PU[playerid])
							    {
						        	format(tm,100,"%s��%s��ҵID:%i�ۼ�$%i,�Ƿ���",UID[property[i][pro_uid]][u_name],property[i][pro_name],i,property[i][pro_value]);
						    		Dialog_Show(playerid,dl_buyplayerpro, DIALOG_STYLE_MSGBOX,"������ҵ",tm, "����", "����");
						    		SetPVarInt(playerid,"houseid",i);
						    	}
						    	else
						    	{
									SetPlayerPosEx(playerid,property[i][pro_ix],property[i][pro_iy],property[i][pro_iz],property[i][pro_ia],property[i][pro_iin],property[i][pro_iwl],-1,0,0);
									if(property[i][pro_uid]==PU[playerid])format(tm,100,"��ӭ�ص������ҵ",i);
									else format(tm,100,"�������%i����ҵ",i);
									SM(COLOR_TWTAN, tm);
						    	}
							}
						}
					}
			    }
            }
		}
    }
	return 1;
}
