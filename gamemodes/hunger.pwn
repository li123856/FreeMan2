CMD:wdsc(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:pfresh[PU[playerid]])
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
	}
	if(current_number[playerid]==1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","��û��ʳ�Ķ�", "��", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�ҵ�ʳ����-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, wdscx, DIALOG_STYLE_TABLIST_HEADERS,tm, Showmysclist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
CMD:wdmsx(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:pfood)
	{
	    if(pfood[i][pfoode_uid]==PU[playerid])
	    {
			current_idx[playerid][current_number[playerid]]=i;
	       	current_number[playerid]++;
       	}
	}
	if(current_number[playerid]==1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","�㻹û��������ʳ", "��", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�ҵ���ʳ��-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_wdmssz, DIALOG_STYLE_TABLIST_HEADERS,tm, Showmymslist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_wdmssz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new page = (P_page[playerid]-1)*MAX_DILOG_LIST;
		if(page == 0)
		{
			page = 1;
		}
		else
		{
			page++;
		}
		if(listitem == MAX_DILOG_LIST)
	  	{
	    	P_page[playerid]++;
			Dialog_Show(playerid,dl_wdmssz,DIALOG_STYLE_TABLIST_HEADERS,"�ҵ���ʳ��",Showmymslist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_wdmsxz,DIALOG_STYLE_LIST,"��ʳѡ��","�Լ�ʳ��\nEbuy����","ȷ��", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_wdmssz,DIALOG_STYLE_TABLIST_HEADERS,"�ҵ���ʳ��",Showmymslist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_wdmsxz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:Dialog_Show(playerid,dl_eatms, DIALOG_STYLE_MSGBOX,"ʳ����ʳ","ȷ��Ҫʳ�ô���ʳ", "�ǵ�", "ȡ��");
		    case 1:
		    {
				SetPVarInt(playerid,"listIDC",GetPVarInt(playerid,"listIDA"));
				Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
		    }
		}
	}
	return 1;
}
Dialog:dl_eatms(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(IsMSselling(listid))return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","�����ʳ���ڳ�����,��Ҫ͵��Ŷ", "��", "");
		UID[PU[playerid]][u_hunger]+=pfood[listid][pfoode_usefuel];
		Saveduid_data(PU[playerid]);
		new tm[128];
		format(tm,100,"��ʳ����%s,��ǰ����ֵ:%0.2f",pfood[listid][pfoode_name],UID[PU[playerid]][u_hunger]);
		SM(COLOR_TWTAN, tm);
		Iter_Remove(pfood,listid);
		if(fexist(Get_Path(listid,33)))fremove(Get_Path(listid,33));
	}
	return 1;
}
stock Showmymslist(playerid,pager)
{
    new tmp[4128];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager == 0)
	{
		pager = 1;
	}
	else
	{
	    pager++;
	}
	new isover=0;
	format(tmp,4128, "����\tЧ��\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
        new tmps[265];
        if(i<current_number[playerid])
        {
			format(tmps,128,"%s\t%0.2f\n",pfood[current_idx[playerid][i]][pfoode_name],pfood[current_idx[playerid][i]][pfoode_usefuel]);
		}
		if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
		else strcat(tmp,tmps);
	}
	if(isover==0)
	{
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
stock Showmysclist(playerid,pager)
{
    new tmp[4128];
    pager = (pager-1)*MAX_DILOG_LIST;
    if(pager == 0)
	{
		pager = 1;
	}
	else
	{
	    pager++;
	}
	new isover=0;
	format(tmp,4128, "����\t����\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
        new tmps[265];
        if(i<current_number[playerid])
        {
			format(tmps,128,"%s\t%i\n",fresh[pfresh[PU[playerid]][current_idx[playerid][i]][pfresh_did]][fresh_name],pfresh[PU[playerid]][current_idx[playerid][i]][pfresh_amout]);
		}
		if(i>=current_number[playerid])
		{
			isover=1;
			break;
		}
		else strcat(tmp,tmps);
	}
	if(isover==0)
	{
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
Dialog:dl_pengren(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        Itter_Clear(caidan[playerid]);
		Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"�ҵ���⿵�",Showxzshicailist(playerid), "ȷ��", "ȡ��");
	}
	return 1;
}
stock Showxzshicailist(playerid)
{
	new tmp[6124],Stru[128];
	format(tmp,4128, "����\n");
	foreach(new i:caidan[playerid])
	{
		format(Stru, sizeof(Stru),"%s\t%i\n",fresh[caidan[playerid][i][caidan_did]][fresh_name]);
		strcat(tmp,Stru);
	}
	format(Stru,sizeof(Stru),"{FF8000}���ʳ��\n��ʼ���");
	strcat(tmp,Stru);
	return tmp;
}
Dialog:dl_xzcaidan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	   	if(listitem==Iter_Count(caidan[playerid]))
		{
			current_number[playerid]=1;
			foreach(new i:pfresh[PU[playerid]])
			{
				current_idx[playerid][current_number[playerid]]=i;
		       	current_number[playerid]++;
			}
			if(current_number[playerid]==1)return Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"���ʳ������û�ж�����", Showxzshicailist(playerid), "ȷ��", "ȡ��");
			P_page[playerid]=1;
			Dialog_Show(playerid,dl_addcaidan, DIALOG_STYLE_TABLIST_HEADERS,"��ѡ��ʳ��", Showmysclist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	   	else if(listitem==Iter_Count(caidan[playerid])+1)
		{
		    if(!Iter_Count(caidan[playerid]))return Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"�����⿵���û�����ʳ��", Showxzshicailist(playerid), "ȷ��", "ȡ��");
			Dialog_Show(playerid,dl_makefoodname, DIALOG_STYLE_INPUT,"����","�����Ĳ�����", "ȷ��", "ȡ��");
		}
		else
		{
			new listid=listitem;
			SetPVarInt(playerid,"listIDA",listid);
		    Dialog_Show(playerid,dl_delcaidan, DIALOG_STYLE_MSGBOX,"��ʾ","�Ƿ�ɾ����ʳ��", "�ǵ�", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_delcaidan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    Iter_Remove(caidan[playerid],listid);
		Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"�ҵ���⿵�", Showxzshicailist(playerid), "ȷ��", "ȡ��");
	}
	else Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"�ҵ���⿵�", Showxzshicailist(playerid), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_makefoodname(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new text[100];
	    ReStr(inputtext);
		if(sscanf(inputtext, "s[100]",text))return Dialog_Show(playerid,dl_makefoodname, DIALOG_STYLE_INPUT,"����","�����Ĳ�����", "ȷ��", "ȡ��");
		SetPVarString(playerid,"makefood",text);
		LoadingForPlayer(playerid,2000,0xFF00FFC8);
	}
	return 1;
}
Function OnPlayerWLOADend(playerid)
{
	new text[100];
	GetPVarString(playerid,"makefood",text,100);
    if(strlenEx(text))
    {
		new i=Iter_Free(pfood);
		if(i==-1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","���Ժ�����", "��", "");
		new Float:usefuel1,Float:usefuel2;
		foreach(new x:caidan[playerid])
		{
		    usefuel1+=fresh[caidan[playerid][x][caidan_did]][fresh_usefuel];
			DelPlayerFresh(playerid,caidan[playerid][x][caidan_did],1);
		}
		usefuel2=randfloat(floatround(usefuel1*10));
		format(pfood[i][pfoode_name],100,"%s",text);
		pfood[i][pfoode_usefuel]=usefuel2;
		pfood[i][pfoode_uid]=PU[playerid];
		Iter_Add(pfood,i);
		SavedFood_data(i);
		Itter_Clear(caidan[playerid]);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdmsx");
		DeletePVar(playerid,"makefood");
    }
 	return 1;
}
Dialog:dl_addcaidan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new page = (P_page[playerid]-1)*MAX_DILOG_LIST;
		if(page == 0)
		{
			page = 1;
		}
		else
		{
			page++;
		}
		if(listitem == MAX_DILOG_LIST)
	  	{
	    	P_page[playerid]++;
			Dialog_Show(playerid,dl_addcaidan,DIALOG_STYLE_TABLIST_HEADERS,"��ѡ��ʳ��",Showmysclist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
		    new i=Iter_Free(caidan[playerid]);
		    if(i==-1)
			{
				Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"��⿵�����", Showxzshicailist(playerid), "ȷ��", "ȡ��");
				return 1;
			}
			new listid=current_idx[playerid][page+listitem];
			if(Getcaidan(playerid,pfresh[PU[playerid]][listid][pfresh_did])>=pfresh[PU[playerid]][listid][pfresh_amout])return Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"��û����ô������ʳ��", Showxzshicailist(playerid), "ȷ��", "ȡ��");
			caidan[playerid][i][caidan_did]=pfresh[PU[playerid]][listid][pfresh_did];
			Iter_Add(caidan[playerid],i);
			Dialog_Show(playerid,dl_xzcaidan, DIALOG_STYLE_TABLIST_HEADERS,"�ҵ���⿵�", Showxzshicailist(playerid), "ȷ��", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_addcaidan,DIALOG_STYLE_TABLIST_HEADERS,"��ѡ��ʳ��",Showmysclist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock Getcaidan(playerid,dids)
{
	new amouts=0;
    foreach(new i:caidan[playerid])if(caidan[playerid][i][caidan_did]==dids)amouts++;
    return amouts;
}
Dialog:dl_syssellresh(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(fresh[listitem][fresh_amout]<1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","ʳ�ĵ�û�и�ʳ�ĵĴ��", "��", "");
	    SetPVarInt(playerid,"listIDA",listitem);
	    Dialog_Show(playerid,dl_syssellreshamout, DIALOG_STYLE_INPUT,"����ʳ��","������Ҫ����ĸ���", "ȷ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_syssellreshamout(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_syssellreshamout, DIALOG_STYLE_INPUT,"�������","������Ҫ����ĸ���", "ȷ��", "ȡ��");
		if(strval(inputtext)>10)return Dialog_Show(playerid,dl_syssellreshamout, DIALOG_STYLE_INPUT,"ÿ��ֻ����10��","������Ҫ����ĸ���", "ȷ��", "ȡ��");
        new listid=GetPVarInt(playerid,"listIDA");
	    if(strval(inputtext)>fresh[listid][fresh_amout])return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","ʳ�ĵ�û����ô���ʳ�ĵĴ��", "��", "");
        EnoughMoney(playerid,fresh[listid][fresh_sell]*strval(inputtext));
        AddPlayerFresh(playerid,listid,strval(inputtext));
        fresh[listid][fresh_amout]-=strval(inputtext);
        Savefresh();
        Moneyhandle(PU[playerid],-fresh[listid][fresh_sell]*strval(inputtext));
	}
	return 1;
}
stock AddPlayerFresh(playerid,did,amout)
{
	if(amout<=0)return 1;
	foreach(new i:pfresh[PU[playerid]])
	{
		if(pfresh[PU[playerid]][i][pfresh_did]==did&&pfresh[PU[playerid]][i][pfresh_amout]>0)
		{
		    pfresh[PU[playerid]][i][pfresh_amout]+=amout;
		    SavePlayerFresh(PU[playerid]);
		    return 1;
		}
		if(pfresh[PU[playerid]][i][pfresh_did]==did&&pfresh[PU[playerid]][i][pfresh_amout]<0)
		{
		    Iter_Remove(pfresh[PU[playerid]],i);
		    SavePlayerFresh(PU[playerid]);
		    return 1;
		}
	}
    new x=Iter_Free(pfresh[PU[playerid]]);
    pfresh[PU[playerid]][x][pfresh_did]=did;
    pfresh[PU[playerid]][x][pfresh_amout]=amout;
    Iter_Add(pfresh[PU[playerid]],x);
	SavePlayerFresh(PU[playerid]);
	if(Iter_Count(pfresh[PU[playerid]])>40)
	{
		new Str[80];
		format(Str,sizeof(Str),"��ע��,���ʳ����ʣ��ռ䲻��,��ǰ%i,�뼰ʱ����\n����ﵽ50��ʱ,����ʳ�Ľ���Ч",Iter_Count(pfresh[PU[playerid]]));
        SM(COLOR_ORANGE,Str);
	}
	return 1;
}
stock DelPlayerFresh(playerid,did,amout)
{
	foreach(new i:pfresh[PU[playerid]])
	{
		if(pfresh[PU[playerid]][i][pfresh_did]==did)
		{
		    pfresh[PU[playerid]][i][pfresh_amout]-=amout;
		    if(pfresh[PU[playerid]][i][pfresh_amout]<1)Iter_Remove(pfresh[PU[playerid]],i);
			SavePlayerFresh(PU[playerid]);
			return 1;
		}
	}
	return 1;
}
Function SavePlayerFresh(pid)
{
	new str3[4128];
    if(fexist(Get_Path(pid,32)))fremove(Get_Path(pid,32));
	new File:NameFile = fopen(Get_Path(pid,32), io_write);
    foreach(new i:pfresh[pid])
  	{
		format(str3,sizeof(str3),"%s %i %i\r\n",str3,pfresh[pid][i][pfresh_did],pfresh[pid][i][pfresh_amout]);
	}
	fwrite(NameFile,str3);
    fclose(NameFile);
	return 1;
}
stock LoadPlayerFresh(pid)
{
	new tm1[100],ids=0;
    if(fexist(Get_Path(pid,32)))
    {
		new File:NameFile = fopen(Get_Path(pid,32), io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<13)
	        	    {
	        			sscanf(tm1, "ii",pfresh[pid][ids][pfresh_did],pfresh[pid][ids][pfresh_amout]);
                        Iter_Add(pfresh[pid],ids);
						ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
Function LoadFood_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_EBUYTHINGS)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,33), i);
        if(fexist(NameFile))
        {
       		INI_ParseFile(Get_Path(i,33), "LoadFoodData", false, true, i, true, false);
       		Iter_Add(pfood,i);
       		idx++;
       	}
    }
    return idx;
}
Function LoadFoodData(i, name[], value[])
{
    INI_Float("pfoode_usefuel",pfood[i][pfoode_usefuel]);
    INI_Int("pfoode_uid",pfood[i][pfoode_uid]);
    INI_String("pfoode_name",pfood[i][pfoode_name],100);
	return 1;
}
Function SavedFood_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,33));
    INI_WriteFloat(File,"pfoode_usefuel",pfood[Count][pfoode_usefuel]);
    INI_WriteInt(File,"pfoode_uid",pfood[Count][pfoode_uid]);
    INI_WriteString(File,"pfoode_name",pfood[Count][pfoode_name]);
    INI_Close(File);
	return true;
}
Function Savefresh()
{
	new str3[4128];
    if(fexist(FRESH_FILE))fremove(FRESH_FILE);
	new File:NameFile = fopen(FRESH_FILE, io_write);
    Loop(i,sizeof(fresh))
  	{
		format(str3,sizeof(str3),"%s %i %i %f\r\n",str3,fresh[i][fresh_sell],fresh[i][fresh_amout],fresh[i][fresh_usefuel]);
	}
	fwrite(NameFile,str3);
    fclose(NameFile);
	return 1;
}
stock Loadfresh()
{
	new tm1[100],ids=0;
    if(fexist(FRESH_FILE))
    {
		new File:NameFile = fopen(FRESH_FILE, io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        		sscanf(tm1, "iif",fresh[ids][fresh_sell],fresh[ids][fresh_amout],fresh[ids][fresh_usefuel]);
					ids++;
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return ids;
}
Function GetClosesthuoyan(playerid)
{
	new Float:dis, Float:dis2, jcid;
	jcid = -1;
	dis = 99999.99;
	foreach(new x:JJ)
	{
		if(JJ[x][jused]==false)
		{
			if(Daoju[JJ[x][jdid]][d_obj]==19632)
			{
				if(PlayerToPoint(3, playerid,JJ[x][jx],JJ[x][jy],JJ[x][jz],JJ[x][jin],JJ[x][jwl]))
				{
					new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
					GetPlayerPos(playerid, x1, y1, z1);
					x2=JJ[x][jx];
					y2=JJ[x][jy];
					z2=JJ[x][jz];
					dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
					if(dis2 < dis && dis2 != -1.00)
					{
						dis = dis2;
						jcid = x;
					}
				}
			}
		}
	}
	return jcid;
}
