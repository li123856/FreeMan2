Function SaveGlv(idx)
{
	new str[738];
    if(fexist(Get_Path(idx,10)))fremove(Get_Path(idx,10));
	new File:NameFile = fopen(Get_Path(idx,10), io_write);
    foreach(new i:GlvInfo[idx])
  	{
		format(str,sizeof(str),"%s %i,%s\r\n",str,GlvInfo[idx][i][g_skin],GlvInfo[idx][i][g_lvuname]);
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}
stock LoadGlv(idx)
{
	new tm1[100];
    if(fexist(Get_Path(idx,10)))
    {
		new File:NameFile = fopen(Get_Path(idx,10), io_read);
    	if(NameFile)
    	{
    	    new ids=0;
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_GROUP_LV)
	        	    {
		        		sscanf(tm1, "p<,>is[100]",GlvInfo[idx][ids][g_skin],GlvInfo[idx][ids][g_lvuname]);
		        		ReStr(GlvInfo[idx][ids][g_lvuname]);
			    		Iter_Add(GlvInfo[idx],ids);
		        		ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
stock CreateGang(idx)
{
    new tm[100];
	format(tm,100,"%s\n����:%s\nID:%i",GInfo[idx][g_name],UID[GInfo[idx][g_uid]][u_name],idx);
   	GInfo[idx][g_text]=CreateColor3DTextLabel(tm,COLOR_CRIMSON,GInfo[idx][g_x],GInfo[idx][g_y],GInfo[idx][g_z]+1,30,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,GInfo[idx][g_wl],GInfo[idx][g_in],-1,30.0,GInfo[idx][g_iscol],1);
    GInfo[idx][g_pick]=CreateDynamicPickup(GInfo[idx][g_model],0,GInfo[idx][g_x],GInfo[idx][g_y],GInfo[idx][g_z]+3,GInfo[idx][g_wl],GInfo[idx][g_in]);
    return 1;
}
stock SendGangMsg(Gid,Color,Msg[])
{
	new Astr[512],Str[64];
	format(Str, sizeof(Str), "������Ϣ:");
	strcat(Astr,Str);
	strcat(Astr,Msg);
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	        if(UID[PU[i]][u_gid]!=-1)
	        {
		    	if(UID[PU[i]][u_gid]==Gid)
		    	{
                    SendClientMessage(i,Color,Astr);
		    	}
		    }
		}
	}
    return 1;
}
stock SendGangChat(playerid,Msg[])
{
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	        if(UID[PU[i]][u_gid]!=-1)
	        {
		    	if(UID[PU[i]][u_gid]==UID[PU[playerid]][u_gid])
		    	{
                    SendClientMessage(i,-1,Msg);
		    	}
		    }
		}
	}
    return 1;
}
stock SetGangSkin(Gid,lv,Skin)
{
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	        if(UID[PU[i]][u_gid]!=-1)
	        {
		    	if(UID[PU[i]][u_gid]==Gid)
		    	{
		    	    if(UID[PU[i]][u_glv]==lv)SetPlayerSkin(i,Skin);
		    	}
		    }
		}
	}
    return 1;
}
stock UpdateGangP3DEx(playerid)
{
	if(playerid==-1)return 1;
    if(UID[PU[playerid]][u_gid]!=-1)
    {
		new str[100];
		format(str,100,"%s\n%s",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname]);
		UpdateColor3DTextLabelText(Gang3D[playerid],colorMenu[GInfo[UID[PU[playerid]][u_gid]][g_color]],str);
	}
	else UpdateColor3DTextLabelText(Gang3D[playerid],-1,"");
    return 1;
}
stock UpdateGangP3D(Gid)
{
    if(Gid==-1)return 1;
	new str[100];
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	        if(UID[PU[i]][u_gid]!=-1)
	        {
		    	if(UID[PU[i]][u_gid]==Gid)
		    	{
					format(str,100,"%s\n%s",GInfo[UID[PU[i]][u_gid]][g_name],GlvInfo[UID[PU[i]][u_gid]][UID[PU[i]][u_glv]][g_lvuname]);
					UpdateColor3DTextLabelText(Gang3D[i],colorMenu[GInfo[UID[PU[i]][u_gid]][g_color]],str);
		    	}
		    }
		}
	}
    return 1;
}
Function LoadGroup_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_GROUP)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,9), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,9), "LoadGroupData", false, true, i, true, false);
            LoadGlv(i);
            GInfo[i][g_gid]=i;
 			CreateGang(i);
 			Iter_Add(GInfo,i);
 			idx++;
        }
    }
    return idx;
}
Function LoadGroupData(i, name[], value[])
{
    INI_String("g_name",GInfo[i][g_name],128);
    INI_Int("g_uid",GInfo[i][g_uid]);
    INI_Int("g_iscol",GInfo[i][g_iscol]);
    INI_Int("g_did",GInfo[i][g_did]);
    INI_Float("g_x",GInfo[i][g_x]);
    INI_Float("g_y",GInfo[i][g_y]);
    INI_Float("g_z",GInfo[i][g_z]);
    INI_Float("g_a",GInfo[i][g_a]);
    INI_Int("g_in",GInfo[i][g_in]);
    INI_Int("g_wl",GInfo[i][g_wl]);
    INI_Int("g_model",GInfo[i][g_model]);
    INI_Int("g_color",GInfo[i][g_color]);
	return 1;
}
Function SavedGroupdata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,9));
    INI_WriteString(File,"g_name",GInfo[Count][g_name]);
    INI_WriteInt(File,"g_uid",GInfo[Count][g_uid]);
    INI_WriteInt(File,"g_iscol",GInfo[Count][g_iscol]);
    INI_WriteInt(File,"g_did",GInfo[Count][g_did]);
    INI_WriteFloat(File, "g_x",GInfo[Count][g_x]);
    INI_WriteFloat(File, "g_y",GInfo[Count][g_y]);
    INI_WriteFloat(File, "g_z",GInfo[Count][g_z]);
    INI_WriteFloat(File, "g_a",GInfo[Count][g_a]);
    INI_WriteInt(File, "g_in",GInfo[Count][g_in]);
    INI_WriteInt(File, "g_wl",GInfo[Count][g_wl]);
    INI_WriteInt(File, "g_model",GInfo[Count][g_model]);
    INI_WriteInt(File, "g_color",GInfo[Count][g_color]);
    INI_Close(File);
	return true;
}
Dialog:dl_cgangname(playerid, response, listitem, inputtext[])
{
    if(response)
	{
		ReStr(inputtext);
	    if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid, dl_cgangname, DIALOG_STYLE_INPUT, "��ʾ","�������������", "ȷ��", "ȡ��");
        if(Iter_Count(GInfo)>=MAX_GROUP)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","�����������޷������µ�", "�õ�", "");
		if(UID[PU[playerid]][u_wds]<20)return  Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û��20V��", "�õ�", "");
        if(!EnoughMoneyEx(playerid,CM_GANG))return  Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_GANG);
        VBhandle(PU[playerid],-20);
        new i=Iter_Free(GInfo);
        if(i==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","������������޷�����", "�õ�", "");
		new Float:xyza[4];
		GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
		GetPlayerFacingAngle(playerid,xyza[3]);
		format(GInfo[i][g_name],128,inputtext);
        GInfo[i][g_gid]=i;
        GInfo[i][g_uid]=PU[playerid];
        GInfo[i][g_iscol]=0;
        GInfo[i][g_x]=xyza[0];
        GInfo[i][g_y]=xyza[1];
        GInfo[i][g_z]=xyza[2];
        GInfo[i][g_a]=xyza[3];
        GInfo[i][g_in]=GetPlayerInterior(playerid);
        GInfo[i][g_wl]=GetPlayerVirtualWorld(playerid);
        GInfo[i][g_model]=14467;
		CreateGang(i);
        UID[PU[playerid]][u_gid]=i;
        UID[PU[playerid]][u_glv]=MAX_GROUP_LV-1;
		Iter_Add(GInfo,i);
		Loop(x,MAX_GROUP_LV)
		{
		    GlvInfo[i][x][g_skin]=0;
			format(GlvInfo[i][x][g_lvuname],100,"�׼�%i",x);
			Iter_Add(GlvInfo[i],x);
		}
		SaveGlv(i);
		Saveduid_data(PU[playerid]);
		SavedGroupdata(i);
		UpdateGangP3D(UID[PU[playerid]][u_gid]);
	}
	return 1;
}
Dialog:dl_cgang(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(UID[PU[playerid]][u_Score]<1000)return SM(COLOR_TWTAN,"��Ļ��ֲ���1000,�޷���������");
	    if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return SM(COLOR_TWAQUA,"������ڴ����紴��");
        Dialog_Show(playerid, dl_cgangname, DIALOG_STYLE_INPUT, "��ʾ","�������������", "ȷ��", "ȡ��");
	}
	else
	{
	    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llbp");
	}
	return 1;
}
CMD:llbp(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
	foreach(new i:GInfo)
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
       	current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��ʱû�а���", "ȷ��", "ȡ��");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�������-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_llbp, DIALOG_STYLE_LIST,tm, Showllbplist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_joinyqbp(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"listIDB");
    new tm[100];
	if(response)
	{
		if(UID[PU[playerid]][u_gid]!=-1)return SM(COLOR_TWAQUA,"���Ѽ�����ɣ��޷�������������");
		UID[PU[playerid]][u_gid]=UID[PU[listid]][u_gid];
		UID[PU[playerid]][u_glv]=0;
		format(tm,100,"��ͬ����%s�������%s",Gnn(listid),GInfo[UID[PU[playerid]][u_gid]][g_name]);
		SM(COLOR_TWAQUA,tm);
		format(tm,100,"%s�������������",Gnn(playerid));
		SendClientMessage(listid,-1,tm);
		format(tm,100,"%s���뱾��,��һ�ӭ����",Gnn(playerid));
		SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
		UpdateGangP3D(UID[PU[playerid]][u_gid]);
	}
	else
	{
		format(tm,100,"%s�ܾ����������",Gnn(playerid));
		SendClientMessage(listid,-1,tm);
	}
	return 1;
}
Dialog:dl_joingang(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(UID[PU[playerid]][u_gid]!=-1)return SM(COLOR_TWAQUA,"�����а���,�����˳���ǰ����,�����޷�������������");
	    new listid=GetPVarInt(playerid,"listIDA"),tm[100],idxs=0;
		foreach(new i:Player)
		{
		    if(AvailablePlayer(i))
		    {
		        if(UID[PU[i]][u_gid]!=-1)
		        {
			    	if(listid==UID[PU[i]][u_gid])
			    	{
						if(UID[PU[i]][u_glv]>=MAX_GROUP_LV-1)
						{
							SetPVarInt(i,"listIDB",playerid);
							format(tm,100,"%s����������",Gnn(playerid));
							Dialog_Show(i, dl_joinbpto, DIALOG_STYLE_MSGBOX,"����",tm, "����", "ȡ��");
							idxs++;
						}
			    	}
			    }
		    }
		}
		if(!idxs)SM(COLOR_TWAQUA,"�ð���û�и߲���Ա����");
	}
	return 1;
}
Dialog:dl_joinbpto(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new pid=GetPVarInt(playerid,"listIDB");
		if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA,"����û������");
		if(UID[PU[pid]][u_gid]!=-1)return SM(COLOR_TWAQUA,"�����Ѽ�����ɣ��������������");
		UID[PU[pid]][u_gid]=UID[PU[playerid]][u_gid];
		UID[PU[pid]][u_glv]=0;
		new tm[100];
		format(tm,100,"��ͬ����%s�������",Gnn(pid));
		SM(COLOR_TWAQUA,tm);
		format(tm,100,"�㱻%sͬ��������%s",Gnn(playerid),GInfo[UID[PU[pid]][u_gid]][g_name]);
		SendClientMessage(pid,-1,tm);
		format(tm,100,"%s���뱾��,��һ�ӭ����",Gnn(pid));
		SendGangMsg(UID[PU[pid]][u_gid],COLOR_TOMATO,tm);
		UpdateGangP3D(UID[PU[pid]][u_gid]);
	}
	return 1;
}
Dialog:dl_llbp(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_llbp,DIALOG_STYLE_LIST,"�������",Showlldplist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
            SetPVarInt(playerid,"listIDA",listid);
			new tm[100];
			format(tm,100,"�Ƿ����[%s]",GInfo[listid][g_name]);
			Dialog_Show(playerid, dl_joingang, DIALOG_STYLE_MSGBOX,"�������",tm, "ȷ��", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_llbp,DIALOG_STYLE_LIST,"�������",Showlldplist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock GGANGUSER(gids)
{
    new amout=0;
	foreach(new i:UID)
	{
	    if(UID[i][u_gid]==gids)
	    {
            amout++;
	    }
	}
	return amout;
}
stock Showllbplist(playerid,pager)
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
			format(tmps,100,"ID:%i - %s - ����:%i - ��ʼ��:%s\n",current_idx[playerid][i],GInfo[current_idx[playerid][i]][g_name],GGANGUSER(GInfo[current_idx[playerid][i]][g_gid]),UID[GInfo[current_idx[playerid][i]][g_uid]][u_name]);
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
CMD:zb(playerid, params[], help)
{
	if(UID[PU[playerid]][u_gid]==-1)return	Dialog_Show(playerid, dl_cgang, DIALOG_STYLE_MSGBOX, "��ʾ","��û�а���", "��", "");
	SetPPos(playerid,GInfo[UID[PU[playerid]][u_gid]][g_x],GInfo[UID[PU[playerid]][u_gid]][g_y],GInfo[UID[PU[playerid]][u_gid]][g_z]);
	SetPlayerInterior(playerid,GInfo[UID[PU[playerid]][u_gid]][g_in]);
	SetPlayerVirtualWorld(playerid,GInfo[UID[PU[playerid]][u_gid]][g_wl]);
	return 1;
}
CMD:wdbp(playerid, params[], help)
{
	if(UID[PU[playerid]][u_gid]==-1)return	Dialog_Show(playerid, dl_cgang, DIALOG_STYLE_MSGBOX, "��ʾ","��û�а���\n��ѡ��Ѱ�Ұ���,�򴴽�����[1000W+50V��]", "��������", "Ѱ�Ұ���");
	if(PU[playerid]==GInfo[UID[PU[playerid]][u_gid]][g_uid])
	{
		new tm[100];
		format(tm,100,"����[%s]ͷ��[%s]",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname]);
		Dialog_Show(playerid, dl_mygang, DIALOG_STYLE_LIST,tm,"���ɳ�Ա\n���ɼ���\n���ɹ���\n��ս����\n��������\n���ɲ�ҵ\n���ɵ���\n��������\n�˳�����", "ȷ��", "ȡ��");
	}
	else 
	{
		new tm[100];
		format(tm,100,"����[%s]ͷ��[%s]",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname]);
		Dialog_Show(playerid, dl_mygang, DIALOG_STYLE_LIST,tm,"���ɳ�Ա\n���ɼ���\n���ɹ���\n��ս����\n��������\n���ɲ�ҵ\n���ɵ���\n��������\n�˳�����", "ȷ��", "ȡ��");
	}
	return 1;
}
stock Showgangchengyuanlist(playerid,pager)
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
			format(tmps,128,"%s - ͷ��:%s\n",UID[current_idx[playerid][i]][u_name],GlvInfo[UID[current_idx[playerid][i]][u_gid]][UID[current_idx[playerid][i]][u_glv]][g_lvuname]);
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
stock Showbptxlist(playerid,pager)
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
			format(tmps,128,"�׼�%i - ͷ��:%s\n",current_idx[playerid][i],GlvInfo[UID[PU[playerid]][u_gid]][current_idx[playerid][i]][g_lvuname]);
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
Dialog:dl_bptx(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_bptx,DIALOG_STYLE_LIST,"����ͷ��",Showbptxlist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
            SetPVarInt(playerid,"listIDB",listid);
			new tm[100];
			format(tm,100,"�׼�%iͷ������",listid);
            Dialog_Show(playerid, dl_bptxmm, DIALOG_STYLE_INPUT,tm, "������ͷ������", "ȷ��", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_bptx,DIALOG_STYLE_LIST,"����ͷ��",Showbptxlist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_bptxmm(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(strlenEx(inputtext)>50||strlenEx(inputtext)<3)return Dialog_Show(playerid, dl_bptxmm, DIALOG_STYLE_INPUT,"ͷ������", "������ͷ������,���ƹ��������", "ȷ��", "ȡ��");
        if(!EnoughMoneyEx(playerid,CM_GANGLVNEMR))return  Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_GANGLVNEMR);
		new listid=GetPVarInt(playerid,"listIDB"),tm[100];
		ReStr(inputtext);
		format(GlvInfo[UID[PU[playerid]][u_gid]][listid][g_lvuname],100,inputtext);
		SaveGlv(UID[PU[playerid]][u_gid]);
		format(tm,100,"%s%s�޸Ľ׼�%iͷ��Ϊ%s",GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],Gnn(playerid),listid,GlvInfo[UID[PU[playerid]][u_gid]][listid][g_lvuname]);
		SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
		UpdateGangP3D(UID[PU[playerid]][u_gid]);
		Dialog_Show(playerid, dl_mygangsz, DIALOG_STYLE_LIST,"��������","��������\n������ɫ\n��������\n����ͼ��\n��������\n����ͷ��\nת�ư���\n��ɢ����", "ȷ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_ggangname(playerid, response, listitem, inputtext[])
{
    if(response)
	{
		ReStr(inputtext);
	    if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid, dl_cgangname, DIALOG_STYLE_INPUT, "��ʾ","�������������", "ȷ��", "ȡ��");
        if(!EnoughMoneyEx(playerid,CM_GANGNEMR))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $90000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_GANGNEMR);
		format(GInfo[UID[PU[playerid]][u_gid]][g_name],128,inputtext);
		DeleteColor3DTextLabel(GInfo[UID[PU[playerid]][u_gid]][g_text]);
		DestroyDynamicPickup(GInfo[UID[PU[playerid]][u_gid]][g_pick]);
		CreateGang(UID[PU[playerid]][u_gid]);
		SavedGroupdata(UID[PU[playerid]][u_gid]);
		Dialog_Show(playerid, dl_mygangsz, DIALOG_STYLE_LIST,"��������","��������\n������ɫ\n��������\n����ͼ��\n��������\n����ͷ��\nת�ư���\n��ɢ����", "ȷ��", "ȡ��");
	}
	return 1;
}
stock Showbppflist(playerid,pager)
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
			format(tmps,128,"�׼�%i - Ƥ��ID:%i\n",current_idx[playerid][i],GlvInfo[UID[PU[playerid]][u_gid]][current_idx[playerid][i]][g_skin]);
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
Dialog:dl_bppf(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_bptx,DIALOG_STYLE_LIST,"����Ƥ��",Showbppflist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
            SetPVarInt(playerid,"listIDB",listid);
			new tm[100];
			format(tm,100,"�׼�%iƤ������",listid);
            Dialog_Show(playerid, dl_bppfsz, DIALOG_STYLE_INPUT,tm, "������Ƥ��ID", "ȷ��", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_bptx,DIALOG_STYLE_LIST,"����Ƥ��",Showbppflist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_bppfsz(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(UID[PU[playerid]][u_glv]<MAX_GROUP_LV-1)return SM(COLOR_TWAQUA,"��û���㹻�Ľ׼�Ȩ��������");
        if(!EnoughMoneyEx(playerid,CM_GANGSKIN))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_GANGSKIN);
	    new listid=GetPVarInt(playerid,"listIDB"),tm[100];
		if(strval(inputtext)<0||strval(inputtext)>299)return Dialog_Show(playerid, dl_bppfsz, DIALOG_STYLE_INPUT,"Ƥ������", "������Ƥ��ID", "ȷ��", "ȡ��");
		GInfo[UID[PU[playerid]][u_gid]][g_name]=strval(inputtext);
		SetGangSkin(UID[PU[playerid]][u_gid],listid,strval(inputtext));
	    SaveGlv(UID[PU[playerid]][u_gid]);
		format(tm,100,"%s%s�޸Ľ׼�%iƤ��Ϊ%i",GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],Gnn(playerid),listid,strval(inputtext));
		SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
	}
	return 1;
}
Dialog:dl_zybp(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return SM(COLOR_TWAQUA,"������ڴ�����");
        new Float:xyza[4];
		GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
		GetPlayerFacingAngle(playerid,xyza[3]);
        GInfo[UID[PU[playerid]][u_gid]][g_x]=xyza[0];
        GInfo[UID[PU[playerid]][u_gid]][g_y]=xyza[1];
        GInfo[UID[PU[playerid]][u_gid]][g_z]=xyza[2];
        GInfo[UID[PU[playerid]][u_gid]][g_a]=xyza[3];
		DeleteColor3DTextLabel(GInfo[UID[PU[playerid]][u_gid]][g_text]);
		DestroyDynamicPickup(GInfo[UID[PU[playerid]][u_gid]][g_pick]);
		CreateGang(UID[PU[playerid]][u_gid]);
		SavedGroupdata(UID[PU[playerid]][u_gid]);
	}
	return 1;
}
Dialog:dl_mygangsz(playerid, response, listitem, inputtext[])
{
    if(response)
	{
        if(UID[PU[playerid]][u_glv]<MAX_GROUP_LV-1)return SM(COLOR_TWAQUA,"��û���㹻�Ľ׼�Ȩ��������");
	    switch(listitem)
	    {
	        case 0:Dialog_Show(playerid, dl_ggangname, DIALOG_STYLE_INPUT, "���ɸ���","�������������", "ȷ��", "ȡ��");
	        case 1:
	        {
	        	new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_bpcolor,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
		    }
	        case 2:
	        {
				current_number[playerid]=1;
				foreach(new i:GlvInfo[UID[PU[playerid]][u_gid]])
				{
					current_idx[playerid][current_number[playerid]]=i;
			       	current_number[playerid]++;
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"����Ƥ��");
				Dialog_Show(playerid, dl_bppf, DIALOG_STYLE_LIST,tm, Showbppflist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	        }
	        case 3:
	        {
	        }
	        case 4:
	        {
	        }
	        case 5:
	        {
				current_number[playerid]=1;
				foreach(new i:GlvInfo[UID[PU[playerid]][u_gid]])
				{
					current_idx[playerid][current_number[playerid]]=i;
			       	current_number[playerid]++;
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"����ͷ��");
				Dialog_Show(playerid, dl_bptx, DIALOG_STYLE_LIST,tm, Showbptxlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	        }
	        case 6:Dialog_Show(playerid, dl_zybp, DIALOG_STYLE_MSGBOX, "ת�ư���","�Ƿ�ѡ��˵�Ϊ���ɳ�����", "�õ�", "ȡ��");
	        case 7:
	        {
	            if(GInfo[UID[PU[playerid]][u_gid]][g_uid]!=PU[playerid])return SM(COLOR_TWAQUA,"�㲻�Ǵ�ʼ��");
	            new tm[100];
				format(tm,100,"��ʼ��%s��ɢ�˰���",Gnn(playerid));
				SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
				foreach(new i:UID)
				{
					if(UID[i][u_gid]!=-1)
					{
						if(UID[i][u_gid]==UID[PU[playerid]][u_gid]&&i!=PU[playerid])
					    {
							UID[i][u_gid]=-1;
							UID[i][u_glv]=0;
							Saveduid_data(i);
							new ps2=chackonlineEX(i);
							if(ps2!=-1)
							{
								UpdateColor3DTextLabelText(Gang3D[ps2],-1,"");
							}
					    }
					}
				}
				DestroyDynamicPickup(GInfo[UID[PU[playerid]][u_gid]][g_pick]);
				DeleteColor3DTextLabel(GInfo[UID[PU[playerid]][u_gid]][g_text]);
                Iter_Clear(GlvInfo[UID[PU[playerid]][u_gid]]);
                Iter_Remove(GInfo,UID[PU[playerid]][u_gid]);
				if(fexist(Get_Path(UID[PU[playerid]][u_gid],9)))fremove(Get_Path(UID[PU[playerid]][u_gid],9));
				if(fexist(Get_Path(UID[PU[playerid]][u_gid],10)))fremove(Get_Path(UID[PU[playerid]][u_gid],10));
				UID[PU[playerid]][u_gid]=-1;
				UID[PU[playerid]][u_glv]=0;
				Saveduid_data(PU[playerid]);
				UpdateColor3DTextLabelText(Gang3D[playerid],-1,"");
	        }

	    }
	}
	return 1;
}
Dialog:dl_bpcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		GInfo[UID[PU[playerid]][u_gid]][g_color]=listitem;
		SavedGroupdata(UID[PU[playerid]][u_gid]);
		UpdateGangP3D(UID[PU[playerid]][u_gid]);
		Dialog_Show(playerid, dl_mygangsz, DIALOG_STYLE_LIST,"��������","��������\n������ɫ\n��������\n����ͼ��\n��������\n����ͷ��\nת�ư���\n��ɢ����", "ȷ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_gangcyszjj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDB"),tm[100];
	    if(listid==PU[playerid])return SM(COLOR_TWAQUA,"�����������Լ�");
	    UID[listid][u_glv]=listitem;
	    Saveduid_data(listid);
	    UpdateGangP3D(UID[listid][u_gid]);
	    if(chackonline(listid))UpdateGangP3DEx(chackonlineEX(listid));
	    format(tm,100,"%s����%sΪ�׼�%i %s ",Gnn(playerid),UID[listid][u_name],listitem,GlvInfo[UID[listid][u_gid]][UID[listid][u_glv]][g_lvuname]);
		SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
	}
	return 1;
}
Dialog:dl_gangcysz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(UID[PU[playerid]][u_glv]<MAX_GROUP_LV-1)return SM(COLOR_TWAQUA,"��û���㹻�Ľ׼�Ȩ��������");
        switch(listitem)
        {
            case 0:
            {
				current_number[playerid]=1;
				foreach(new i:GlvInfo[UID[PU[playerid]][u_gid]])
				{
					current_idx[playerid][current_number[playerid]]=i;
			       	current_number[playerid]++;
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"����ͷ��");
				Dialog_Show(playerid, dl_gangcyszjj, DIALOG_STYLE_LIST,tm, Showbptxlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
            }
            case 1:
            {
			    new listid=GetPVarInt(playerid,"listIDB"),tm[100];
			    if(listid==PU[playerid])return SM(COLOR_TWAQUA,"����T���Լ�");
				if(GInfo[UID[PU[playerid]][u_gid]][g_uid]==listid)return SM(COLOR_TWAQUA,"����T��ʼ��");
			    UID[listid][u_gid]=-1;
			    UID[listid][u_glv]=0;
			    Saveduid_data(listid);
			    if(chackonline(listid))
				{
					UpdateGangP3DEx(chackonlineEX(listid));
					Dialog_Close(chackonlineEX(listid));
					format(tm,100,"%s�����߳��˰���",Gnn(playerid));
                	SendClientMessage(chackonlineEX(listid),-1,tm);
				}
			    format(tm,100,"%s��%s�߳��˰���",Gnn(playerid),UID[listid][u_name],listitem,GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname]);
				SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
            }
        }
	}
	return 1;
}
Dialog:dl_gangcy(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_gangcy,DIALOG_STYLE_LIST,"���ɳ�Ա",Showgangchengyuanlist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
            SetPVarInt(playerid,"listIDB",listid);
			new tm[100];
			format(tm,100,"%s%s[�׼�%i]��������",GlvInfo[UID[listid][u_gid]][UID[listid][u_glv]][g_lvuname],UID[listid][u_name],UID[listid][u_glv]);
            Dialog_Show(playerid,dl_gangcysz,DIALOG_STYLE_LIST,tm,"�����׼�\n�߳�����","ȷ��", "��һҳ");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_gangcy,DIALOG_STYLE_LIST,"���ɳ�Ա",Showgangchengyuanlist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_mygang(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    switch(listitem)
	    {
            case 0:
            {
				current_number[playerid]=1;
				new current=-1;
				foreach(new i:UID)
				{
					if(UID[i][u_gid]!=-1)
					{
					    if(UID[i][u_gid]==UID[PU[playerid]][u_gid])
					    {
							current_idx[playerid][current_number[playerid]]=i;
			        		current_number[playerid]++;
			        		current++;
			        	}
			 		}
				}
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�Ż�û�г�Ա", "ȷ��", "ȡ��");
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"���ɳ�Ա-����[%i]",current_number[playerid]-1);
				Dialog_Show(playerid, dl_gangcy, DIALOG_STYLE_LIST,tm, Showgangchengyuanlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
            }
            case 1:
            {
            	if(UID[PU[playerid]][u_glv]<MAX_GROUP_LV-1-3)return SM(COLOR_TWAQUA,"��ļ�����");
           		new Float:xyza[4];
      			GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
				GetPlayerFacingAngle(playerid,xyza[3]);
				new in=GetPlayerInterior(playerid);
				new wl=GetPlayerVirtualWorld(playerid);
				new idxs=0;
				new tm[100];
				foreach(new i:Player)
				{
					if(UID[PU[i]][u_gid]!=-1)
					{
					    if(UID[PU[i]][u_gid]==UID[PU[playerid]][u_gid]&&PU[i]!=PU[playerid]&&UID[PU[i]][u_glv]<UID[PU[playerid]][u_glv])
					    {
                            new Float:dis=randfloat(5);
                            SetPlayerPosEx(i,xyza[0]+dis,xyza[1]+dis,xyza[2],xyza[3],in,wl);
							format(tm,100,"�㱻����������%s %s %s �ټ�",GInfo[UID[PU[i]][u_gid]][g_name],GlvInfo[UID[PU[i]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],Gnn(playerid));
							SendClientMessage(i,-1,tm);
							idxs++;
   			        	}
			 		}
				}
				if(idxs==0)return SM(COLOR_TWAQUA,"û���˱��ټ��������ܱȽ׼��͵���û������- -����");
				format(tm,100,"���ټ�����%i����",idxs);
				SM(COLOR_TWAQUA,tm);
            }
            case 2:
            {

            }
            case 3:
            {

            }
            case 4:
            {

            }
            case 5:
            {

            }
            case 6:
            {

            }
            case 7:
            {
				new tm[100];
				format(tm,100,"%i����",GInfo[UID[PU[playerid]][u_gid]][g_name]);
				Dialog_Show(playerid, dl_mygangsz, DIALOG_STYLE_LIST,"��������","��������\n������ɫ\n��������\n����ͼ��\n��������\n����ͷ��\nת�ư���\n��ɢ����", "ȷ��", "ȡ��");
            }
            case 8:
            {
	            if(PU[playerid]==GInfo[UID[PU[playerid]][u_gid]][g_uid])return SM(COLOR_TWAQUA,"���Ǵ�ʼ��,��ֻ�ܽ�ɢ����");
                new tm[100];
				format(tm,100,"�����˳�����%s",GInfo[UID[PU[playerid]][u_gid]][g_name]);
				SM(COLOR_TWAQUA,tm);
				format(tm,100,"%s�˳��˰���",Gnn(playerid));
				SendGangMsg(UID[PU[playerid]][u_gid],COLOR_TOMATO,tm);
				UID[PU[playerid]][u_gid]=-1;
				UID[PU[playerid]][u_glv]=0;
				Saveduid_data(PU[playerid]);
				UpdateColor3DTextLabelText(Gang3D[playerid],-1,"");
				Dialog_Close(playerid);
            }
	    }
	}
	return 1;
}
