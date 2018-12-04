Function LoadMUSIC_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_MUSIC)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,34), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,34), "LoadMUSICData", false, true, i, true, false);
  			Iter_Add(MUSICS,i);
 			idx++;
        }
    }
    return idx;
}
Function LoadMUSICData(i, name[], value[])
{
    INI_String("music_str",MUSICS[i][music_str],129);
    INI_String("music_name",MUSICS[i][music_name],100);
    INI_Int("music_uid",MUSICS[i][music_uid]);
    INI_Int("music_cash",MUSICS[i][music_cash]);
	return 1;
}
Function SavedMUSICdata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,34));
    INI_WriteString(File,"music_str",MUSICS[Count][music_str]);
    INI_WriteString(File,"music_name",MUSICS[Count][music_name]);
    INI_WriteInt(File,"music_uid",MUSICS[Count][music_uid]);
    INI_WriteInt(File,"music_cash",MUSICS[Count][music_cash]);
    INI_Close(File);
	return true;
}
CMD:wdyy(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:MUSICS)
	{
		if(MUSICS[i][music_uid]==PU[playerid])
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�ҵ�����-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_mymusic, DIALOG_STYLE_LIST,tm, Showmymusiclist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
CMD:llyy(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:MUSICS)
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
	}
	if(current_number[playerid]==1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��ʱû������", "��", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"��������-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_llmusic, DIALOG_STYLE_TABLIST_HEADERS,tm, Showllmusiclist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
stock Showllmusiclist(playerid,pager)
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
	format(tmp,4128, "ID\t������\t������\t�����۸�\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
		new tmps[256];
		if(i<current_number[playerid])
        {
			format(tmps,100,"ID:%i\t%s\t%s\t$%i\n",current_idx[playerid][i],MUSICS[current_idx[playerid][i]][music_name],UID[MUSICS[current_idx[playerid][i]][music_uid]][u_name],MUSICS[current_idx[playerid][i]][music_cash]);
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
    	strcat(tmp, "\t{FF8000}��һҳ\n");
    }
    return tmp;
}
Dialog:dl_llmusic(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_llmusic, DIALOG_STYLE_TABLIST_HEADERS,"��������/LLYY", Showllmusiclist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			new tmp[256];
			if(MUSICS[listid][music_uid]==PU[playerid])
			{
	            format(tmp, sizeof(tmp),""H_MUSICS"�㲥�������ղص�����[{D96D26}%s{FFFFFF}]",MUSICS[listid][music_name]);
	            SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmp);
	            PlayAudioStreamForPlayer(playerid,MUSICS[listid][music_str]);
			}
			else
			{
				SetPVarInt(playerid,"listIDA",listid);
				format(tmp,256, "�Ƿ���������[%s]������[%s],����[$%i]",MUSICS[listid][music_name],UID[MUSICS[listid][music_uid]][u_name],MUSICS[listid][music_cash]);
				Dialog_Show(playerid, dl_musicshouting, DIALOG_STYLE_MSGBOX, "��������",tmp, "����", "�ٿ���");
			}
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_llmusic, DIALOG_STYLE_TABLIST_HEADERS,"��������/LLYY", Showllmusiclist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_musicshouting(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(!EnoughMoneyEx(playerid,MUSICS[listid][music_cash]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ", "�õ�", "");
		new tmps[512];
	    format(tmps, sizeof(tmps),""H_MUSICS"�㲥����%s�ղص�����[{D96D26}%s{FFFFFF}]",UID[MUSICS[listid][music_uid]][u_name],MUSICS[listid][music_name]);
	    SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmps);
	    PlayAudioStreamForPlayer(playerid,MUSICS[listid][music_str]);
	    if(MUSICS[listid][music_cash]>0)
	    {
		    Moneyhandle(PU[playerid],-MUSICS[listid][music_cash]);
			format(tmps,100,"%s�㲥�����ղص�����[%s],����[$%i]",Gn(playerid),UID[MUSICS[listid][music_uid]][u_name],MUSICS[listid][music_cash]);
		    AddPlayerLog(MUSICS[listid][music_uid],"����̨",tmps,MUSICS[listid][music_cash]);
	    }
 	}
 	else CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llyy");
	return 1;
}

Dialog:dl_mymusic(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_mymusic, DIALOG_STYLE_LIST,"�ҵ�����/WDYY", Showmymusiclist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<100)return SM(COLOR_TWTAN,"��Ļ��ֲ���100,�޷��������");
		    if(!EnoughMoneyEx(playerid,100000))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $100000", "�õ�", "");
			new i=Iter_Free(MUSICS);
			if(i==-1)return SM(COLOR_TWAQUA,"���������Ѵﵽ����");
			Dialog_Show(playerid,dl_addyy,DIALOG_STYLE_INPUT,"�������","��������������","ȷ��", "ȡ��");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mymusicsz,DIALOG_STYLE_LIST,"��������","�Լ�����\n�㲥����[1W]\n�޸�����\n�޸�����\n���ü۸�\nɾ������","ȷ��", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_mymusic, DIALOG_STYLE_LIST,"�ҵ�����/WDYY", Showmymusiclist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_addyy(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ReStr(inputtext);
	    if(strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_addyy,DIALOG_STYLE_INPUT,"�������","��������������","ȷ��", "ȡ��");
	    if(!EnoughMoneyEx(playerid,100000))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $100000", "�õ�", "");
		new i=Iter_Free(MUSICS);
		if(i==-1)return SM(COLOR_TWAQUA,"���������Ѵﵽ����");
		MUSICS[i][music_uid]=PU[playerid];
		format(MUSICS[i][music_name],100,inputtext);
		format(MUSICS[i][music_str],129,"MUSICNONE");
		MUSICS[i][music_cash]=0;
		SavedMUSICdata(i);
		Iter_Add(MUSICS,i);
		SetPVarInt(playerid,"listIDA",i);
		Moneyhandle(PU[playerid],-100000);
		Dialog_Show(playerid,dl_addyylj,DIALOG_STYLE_INPUT,"�����������","��������������","ȷ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_addyylj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ReStr(inputtext);
	    if(strlenEx(inputtext)<10)return Dialog_Show(playerid,dl_addyylj,DIALOG_STYLE_INPUT,"�����������","��������������","ȷ��", "ȡ��");
	    new i=GetPVarInt(playerid,"listIDA");
		format(MUSICS[i][music_str],129,inputtext);
		SavedMUSICdata(i);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdyy");
	}
	return 1;
}
Dialog:dl_mymusicszmc(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext);
	    if(strlen(inputtext)<3||strlen(inputtext)>100)return Dialog_Show(playerid,dl_mymusicszmc,DIALOG_STYLE_INPUT,"�޸�����","��������������","ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
	    format(MUSICS[listid][music_name],100,inputtext);
	    SavedMUSICdata(listid);
	    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdyy");
	}
	return 1;
}
Dialog:dl_mymusicszlj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext);
	    if(strlen(inputtext)<10||strlen(inputtext)>129)return Dialog_Show(playerid,dl_mymusicszlj,DIALOG_STYLE_INPUT,"�޸�����","��������������","ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
	    format(MUSICS[listid][music_str],129,inputtext);
	    SavedMUSICdata(listid);
	    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdyy");
	}
	return 1;
}
Dialog:dl_mymusicszjg(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<0||strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_mymusicszjg,DIALOG_STYLE_INPUT,"��ֵ����","������۸�","ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
	    MUSICS[listid][music_cash]=strval(inputtext);
	    SavedMUSICdata(listid);
	    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdyy");
	}
	return 1;
}
stock IsServerMusic()
{
	if(ismusictime==false||musictime<=0)return 0;
	return 1;
}
Dialog:dl_mymusicsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:
	        {
				new tmps[512];
	            format(tmps, sizeof(tmps),""H_MUSICS"�㲥�������ղص�����[{D96D26}%s{FFFFFF}]",MUSICS[listid][music_name]);
	            SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmps);
	            PlayAudioStreamForPlayer(playerid,MUSICS[listid][music_str]);
			}
	        case 1:
	        {
	            if(!EnoughMoneyEx(playerid,10000))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000", "�õ�", "");
	            if(!ismusictime)return SM(COLOR_TWAQUA,"����Ա�ѹر����ֹ㲥");
	            if(musictime>0)return SM(COLOR_TWAQUA,"�����������ڹ㲥��,���Ժ�..");
	            if(!strcmpEx(MUSICS[listid][music_str],"MUSICNONE", false))return SM(COLOR_TWAQUA,"������û����������,�������ú��ٲ���");
	            new tmps[512];
	            format(tmps, sizeof(tmps),"ȫ���㲥:"H_MUSICS"%s�㲥�����ղص�����[{D96D26}%s{FFFFFF}]",Gn(playerid),MUSICS[listid][music_name]);
	            SendMessageToAll(COLOR_LIGHTGOLDENRODYELLOW,tmps);
	            foreach(new i:Player)if(AvailablePlayer(i))PlayAudioStreamForPlayer(i,MUSICS[listid][music_str]);
	            musictime=4;
	            musicid=listid;
	            Moneyhandle(PU[playerid],-10000);
	        }
	        case 2:Dialog_Show(playerid,dl_mymusicszmc,DIALOG_STYLE_INPUT,"�޸�����","��������������","ȷ��", "ȡ��");
	        case 3:Dialog_Show(playerid,dl_mymusicszlj,DIALOG_STYLE_INPUT,"�޸�����","��������������","ȷ��", "ȡ��");
	        case 4:Dialog_Show(playerid,dl_mymusicszjg,DIALOG_STYLE_INPUT,"���ü۸�","������۸�","ȷ��", "ȡ��");
	        case 5:
	        {
	            Iter_Remove(MUSICS,listid);
				fremove(Get_Path(listid,34));
				SM(COLOR_TWAQUA, "ɾ�����ֳɹ�");
	        }
		}
	}
	return 1;
}
stock Showmymusiclist(playerid,pager)
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
		new tmps[256];
		if(i<current_number[playerid])
        {
			format(tmps,100,"ID:%i[%s]\n",current_idx[playerid][i],MUSICS[current_idx[playerid][i]][music_name]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}����µ�����[10W]");
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
