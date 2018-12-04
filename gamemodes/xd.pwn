Function Loadxd_data()
{
	new NameFile[NFSize],idx=0,tm[128];
	Loop(i, MAX_SURFACES)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,30), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,30), "LoadxdData", false, true, i, true, false);
            Surface[i][surid]=CreateSurface(Surface[i][surmodel],Surface[i][surx_off],Surface[i][sury_off],Surface[i][sur_heightf],Surface[i][surx_start],Surface[i][sury_start],Surface[i][surx_end],Surface[i][sury_end]);
			SetSurfaceRot(Surface[i][surid],Surface[i][surx_rot],Surface[i][sury_rot],Surface[i][surz_rot]);
			format(tm,128,"%s\nID:%i",Surface[i][surname],i);
			Surface[i][surm_3D]=CreateDynamic3DTextLabel(tm,-1,Surface[i][surx],Surface[i][sury],Surface[i][surz],400.0,-1,-1,0,0,0);
			if(Surface[i][surtxdid]!=-1)SetSurfaceTexture(Surface[i][surid],Surface[i][surm_index],ObjectTextures[Surface[i][surtxdid]][TModel],ObjectTextures[Surface[i][surtxdid]][TXDName],ObjectTextures[Surface[i][surtxdid]][TextureName],ARGB(colorMenu[Surface[i][surm_color]]));
			Iter_Add(Surface,i);
 			idx++;
        }
    }
    return idx;
}
CMD:xd(playerid, params[], help)
{
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"�÷�:/xd С��ID");
	if(!Iter_Contains(Surface,pid))return SM(COLOR_TWAQUA,"û�д�С��");
	SetPlayerPosEx(playerid,Surface[pid][surx],Surface[pid][sury],Surface[pid][surz],0.0,0,0);
	new tmps[100];
	format(tmps, sizeof(tmps),"%s���͵���ID:%iС��[%s]  /xd %i ",Gnn(playerid),pid,Surface[pid][surname],pid);
 	SendMessageToAll(COLOR_PALEGREEN,tmps);
	return 1;
}
Function Savedxd_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,30));
    INI_WriteInt(File, "suruid",Surface[Count][suruid]);
    INI_WriteInt(File, "sursize",Surface[Count][sursize]);
    INI_WriteString(File,"surname",Surface[Count][surname]);
    INI_WriteInt(File, "surmodel",Surface[Count][surmodel]);
    INI_WriteInt(File, "surlv",Surface[Count][surlv]);
    INI_WriteFloat(File, "surx", Surface[Count][surx]);
    INI_WriteFloat(File, "sury", Surface[Count][sury]);
    INI_WriteFloat(File, "surz", Surface[Count][surz]);
    INI_WriteFloat(File, "surx_off", Surface[Count][surx_off]);
    INI_WriteFloat(File, "sury_off", Surface[Count][sury_off]);
    INI_WriteFloat(File, "sur_heightf", Surface[Count][sur_heightf]);
    INI_WriteFloat(File, "surx_start", Surface[Count][surx_start]);
    INI_WriteFloat(File, "sury_start", Surface[Count][sury_start]);
    INI_WriteFloat(File, "surx_end", Surface[Count][surx_end]);
    INI_WriteFloat(File, "sury_end", Surface[Count][sury_end]);
    INI_WriteFloat(File, "surx_rot", Surface[Count][surx_rot]);
    INI_WriteFloat(File, "sury_rot", Surface[Count][sury_rot]);
    INI_WriteFloat(File, "surz_rot", Surface[Count][surz_rot]);
    INI_WriteInt(File, "surworld",Surface[Count][surworld]);
    INI_WriteInt(File, "surinterior",Surface[Count][surinterior]);
    INI_WriteInt(File, "surm_index",Surface[Count][surm_index]);
    INI_WriteInt(File, "surtxdid",Surface[Count][surtxdid]);
    INI_WriteInt(File, "surm_color",Surface[Count][surm_color]);
    INI_Close(File);
	return true;
}
Function LoadxdData(i, name[], value[])
{
    INI_Int("suruid",Surface[i][suruid]);
    INI_String("surname",Surface[i][surname],100);
    INI_Int("surmodel",Surface[i][surmodel]);
    INI_Int("sursize",Surface[i][sursize]);
    INI_Int("surlv",Surface[i][surlv]);
    INI_Float("surx", Surface[i][surx]);
	INI_Float("sury", Surface[i][sury]);
    INI_Float("surz", Surface[i][surz]);
    INI_Float("surx_off", Surface[i][surx_off]);
	INI_Float("sury_off", Surface[i][sury_off]);
	INI_Float("sur_heightf", Surface[i][sur_heightf]);
	INI_Float("surx_start", Surface[i][surx_start]);
	INI_Float("sury_start", Surface[i][sury_start]);
	INI_Float("surx_end", Surface[i][surx_end]);
	INI_Float("sury_end", Surface[i][sury_end]);
	INI_Float("surx_rot", Surface[i][surx_rot]);
	INI_Float("sury_rot", Surface[i][sury_rot]);
	INI_Float("surz_rot", Surface[i][surz_rot]);
    INI_Int("surworld",Surface[i][surworld]);
    INI_Int("surinterior",Surface[i][surinterior]);
    INI_Int("surtxdid",Surface[i][surtxdid]);
    INI_Int("surm_color",Surface[i][surm_color]);
	return 1;
}
stock Showmyxdlist(playerid,pager)
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
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
		new tmps[100];
		if(i<current_number[playerid])
        {
			format(tmps,100,"[ID:%i]%s\n",current_idx[playerid][i],Surface[current_idx[playerid][i]][surname]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}����С��");
		    strcat(tmp,tmps);
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
CMD:wdxd(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:Surface)
	{
		if(Surface[i][suruid]==PU[playerid])
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�ҵ�С��-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_myxd, DIALOG_STYLE_LIST,tm, Showmyxdlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_addxd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext);
	    if(strlenEx(inputtext)>20||strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_addxd,DIALOG_STYLE_INPUT,"����С��","��ȷ����ǰλ��ΪС�����ĵ�\n������С������","ȷ��", "ȡ��");
	    if(!Createxd(playerid,inputtext))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","����С�����ִ���", "��", "");
	}
	return 1;
}
Dialog:dl_wdxdszname(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new srr[100];
		if(sscanf(inputtext, "s[100]",srr))return Dialog_Show(playerid,dl_wdxdszname,DIALOG_STYLE_INPUT,"��������","����������","ȷ��", "ȡ��");
        new listid=GetPVarInt(playerid,"listIDA");
		format(Surface[listid][surname],100,srr);
        Savedxd_data(listid);
		Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_wdxdszobj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new oid,Float:offx,Float:offy;
		if(sscanf(inputtext, "iff",oid,offx,offy))return Dialog_Show(playerid,dl_wdxdszobj,DIALOG_STYLE_INPUT,"����OBJ","������","ȷ��", "ȡ��");
        new listid=GetPVarInt(playerid,"listIDA");
   		Surface[listid][surmodel]=oid;
   		Surface[listid][surx_off]=offx;
   		Surface[listid][sury_off]=offy;
		SetSurfaceModel(Surface[listid][surid],Surface[listid][surmodel],Surface[listid][surx_off],Surface[listid][sury_off]);
        Savedxd_data(listid);
		Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_wdxdszdw(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new listid=GetPVarInt(playerid,"listIDA");
		new Float:xyz[3],tm[128];
		GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
   		Surface[listid][surx_start]=xyz[0]-100.0;
   		Surface[listid][sury_start]=xyz[1]-100.0;
   		Surface[listid][surx_end]=xyz[0]+100.0;
   		Surface[listid][sury_end]=xyz[1]+100.0;
 		Surface[listid][surx]=xyz[0];
		Surface[listid][sury]=xyz[1];
		Surface[listid][surz]=xyz[2]+10;
		DestroyDynamic3DTextLabel(Surface[listid][surm_3D]);
		format(tm,128,"%s\nID:%i",Surface[listid][surname],listid);
		Surface[listid][surm_3D]=CreateDynamic3DTextLabel(tm,-1,Surface[listid][surx],Surface[listid][sury],Surface[listid][surz],400.0,-1,-1,0,0,0);
	    SetSurfacePos(Surface[listid][surid],Surface[listid][surx_start],Surface[listid][sury_start],Surface[listid][surx_end],Surface[listid][sury_end]);
		Savedxd_data(listid);
	    Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_wdxdszgd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new Float:highta;
		if(sscanf(inputtext, "f",highta))return Dialog_Show(playerid,dl_wdxdszgd,DIALOG_STYLE_INPUT,"���ø߶�","�������µĸ߶�ֵ","ȷ��", "ȡ��");
        new listid=GetPVarInt(playerid,"listIDA");
   		Surface[listid][sur_heightf]=highta;
        SetSurfaceHeight(Surface[listid][surid],Surface[listid][sur_heightf]);
		new Float:xyz[3];
		GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
        SetPlayerPos(playerid,xyz[0],xyz[1],highta+10);
		Savedxd_data(listid);
	    Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_wdxdszjd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new Float:rot1,Float:rot2,Float:rot3;
		if(sscanf(inputtext, "fff",rot1,rot2,rot3))return Dialog_Show(playerid,dl_wdxdszjd,DIALOG_STYLE_INPUT,"���ýǶ�","������","ȷ��", "ȡ��");
        new listid=GetPVarInt(playerid,"listIDA");
   		Surface[listid][surx_rot]=rot1;
   		Surface[listid][sury_rot]=rot2;
   		Surface[listid][surz_rot]=rot3;
   		SetSurfaceRot(Surface[listid][surid],Surface[listid][surx_rot],Surface[listid][sury_rot],Surface[listid][surz_rot]);
		Savedxd_data(listid);
		Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_wdxdszys(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
	    Surface[listid][surm_color]=listitem;
		SetSurfaceTexture(Surface[listid][surid],Surface[listid][surm_index],ObjectTextures[Surface[listid][surtxdid]][TModel],ObjectTextures[Surface[listid][surtxdid]][TXDName],ObjectTextures[Surface[listid][surtxdid]][TextureName],ARGB(colorMenu[Surface[listid][surm_color]]));
		Savedxd_data(listid);
		Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_wdxdsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
		   	case 0:Dialog_Show(playerid,dl_wdxdszname,DIALOG_STYLE_INPUT,"��������","����������","ȷ��", "ȡ��");
		   	case 1:Dialog_Show(playerid,dl_wdxdszobj,DIALOG_STYLE_INPUT,"����OBJ","������","ȷ��", "ȡ��");
		   	case 2:
		   	{
		   	    SetPVarInt(playerid,"caizhi",2);
	            ShowJJtxd(playerid);
	            SM(COLOR_TWAQUA, "ʹ��ALT+C����ҳ��ALT+N���ҷ�ҳ");
	            SM(COLOR_TWAQUA, "ѡ������밴�ո��");
		        SM(COLOR_TWAQUA, "ȡ��ѡ���밴Shitf��");
	            SM(COLOR_TWAQUA, "�ָ�Ĭ���밴H��");
		   	}
		   	case 3:
		   	{
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu))
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_wdxdszys,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
		   	}
		   	case 4:Dialog_Show(playerid,dl_wdxdszdw,DIALOG_STYLE_MSGBOX,"��λС��","�Ƿ�����С�����ĵ��ڴ�λ��","ȷ��", "ȡ��");
		   	case 5:
		   	{
		   	    new tm[100];
				format(tm,100,"���С����ǰ�߶�Ϊ%0.2f\n�������µĸ߶�ֵ",Surface[listid][sur_heightf]);
		   	    Dialog_Show(playerid,dl_wdxdszgd,DIALOG_STYLE_INPUT,"���ø߶�",tm,"ȷ��", "ȡ��");
			}   
		   	case 6:Dialog_Show(playerid,dl_wdxdszjd,DIALOG_STYLE_INPUT,"���ýǶ�","������","ȷ��", "ȡ��");
		   	case 7:
		   	{
		   	    RemoveXd(listid);
		   	    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","С��ɾ�����", "�õ�", "");
		   	}
		}
	}
	return 1;
}
Dialog:dl_xiaodaoxz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
			case 0:
			{
			    if(UID[PU[playerid]][u_wds]<50)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û��50V��,������С��", "��", "");
            	Dialog_Show(playerid,dl_addxd,DIALOG_STYLE_INPUT,"����С��","��ȷ����ǰλ��ΪС�����ĵ�\n������С������","ȷ��", "ȡ��");
			}
			case 1:
			{
			    if(UID[PU[playerid]][u_wds]<100)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û��100V��,������С��", "��", "");
			    Dialog_Show(playerid,dl_addxd,DIALOG_STYLE_INPUT,"����С��","��ȷ����ǰλ��ΪС�����ĵ�\n������С������","ȷ��", "ȡ��");
			}
			case 2:
			{
			    if(UID[PU[playerid]][u_wds]<150)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û��150V��,������С��", "��", "");
			    Dialog_Show(playerid,dl_addxd,DIALOG_STYLE_INPUT,"����С��","��ȷ����ǰλ��ΪС�����ĵ�\n������С������","ȷ��", "ȡ��");
			}
			case 3:
			{
			    if(UID[PU[playerid]][u_wds]<200)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û��200V��,������С��", "��", "");
			    Dialog_Show(playerid,dl_addxd,DIALOG_STYLE_INPUT,"����С��","��ȷ����ǰλ��ΪС�����ĵ�\n������С������","ȷ��", "ȡ��");
			}
			case 4:
			{
			    if(UID[PU[playerid]][u_wds]<250)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û��250V��,������С��", "��", "");
			    Dialog_Show(playerid,dl_addxd,DIALOG_STYLE_INPUT,"����С��","��ȷ����ǰλ��ΪС�����ĵ�\n������С������","ȷ��", "ȡ��");
			}
	    }
	    SetPVarInt(playerid,"xdsize",listitem+1);
	}
	return 1;
}
Dialog:dl_myxd(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_myxd, DIALOG_STYLE_LIST,"�ҵ�С��/WDXD", Showmyxdlist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
			new i=Iter_Free(Surface);
			if(i==-1)return SM(COLOR_TWAQUA,"ȫ��С�������Ѵﵽ����");
			Dialog_Show(playerid,dl_xiaodaoxz,DIALOG_STYLE_LIST,"С����Сѡ��","10X10 - 50V��\n20X20 - 100V��\n30X30 - 150V��\n40X40 - 200V��\n50X50 - 250V��","ѡ��", "ȡ��");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_wdxdsz,DIALOG_STYLE_LIST,"С������","С������\n����OBJ\n���ò���\n������ɫ\n����λ��\n���ø߶�\n���ýǶ�\nɾ��С��","ѡ��", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_myxd, DIALOG_STYLE_LIST,"�ҵ�С��/WDXD", Showmyxdlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock Createxd(playerid,names[])
{
	new i=Iter_Free(Surface);
	if(i!=-1)
	{
		if(!GetPVarInt(playerid,"xdsize"))return 0;
		new Float:xyz[3];
		GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
		format(Surface[i][surname],100,names);
   		Surface[i][suruid]=PU[playerid];
   		Surface[i][surmodel]=19548;
   		Surface[i][surx_off]=125.0;
   		Surface[i][sury_off]=125.0;
   		Surface[i][sur_heightf]=xyz[2]-5;
		Surface[i][surlv]=GetPVarInt(playerid,"xdsize")*5;
   		Surface[i][surx_start]=xyz[0]-Surface[i][surlv];
   		Surface[i][sury_start]=xyz[1]-Surface[i][surlv];
   		Surface[i][surx_end]=xyz[0]+Surface[i][surlv];
   		Surface[i][sury_end]=xyz[1]+Surface[i][surlv];
   		Surface[i][surx_rot]=0.0;
   		Surface[i][sury_rot]=0.0;
   		Surface[i][surz_rot]=0.0;
   		Surface[i][surworld]=0;
   		Surface[i][surinterior]=0;
   		Surface[i][surtxdid]=-1;
   		Surface[i][surm_color]=0;
   		SetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]+10);
		Surface[i][surx]=xyz[0];
		Surface[i][sury]=xyz[1];
		Surface[i][surz]=xyz[2]+10;
   		Surface[i][surid]=CreateSurface(Surface[i][surmodel],Surface[i][surx_off],Surface[i][sury_off],Surface[i][sur_heightf],Surface[i][surx_start],Surface[i][sury_start],Surface[i][surx_end],Surface[i][sury_end]);
   		Savedxd_data(i);
   		Iter_Add(Surface,i);
   		VBhandle(PU[playerid],-GetPVarInt(playerid,"xdsize")*50);
   		Saveduid_data(PU[playerid]);
   		return 1;
   	}
   	return 0;
}
stock RemoveXd(xdid)
{
    DestroySurface(Surface[xdid][surid]);
    DestroyDynamic3DTextLabel(Surface[xdid][surm_3D]);
    if(Iter_Contains(Surface,xdid))Iter_Remove(Surface,xdid);
	if(fexist(Get_Path(xdid,30)))fremove(Get_Path(xdid,30));
}
