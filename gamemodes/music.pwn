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
	format(tm,100,"我的音乐-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_mymusic, DIALOG_STYLE_LIST,tm, Showmymusiclist(playerid,P_page[playerid]), "确定", "取消");
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
	if(current_number[playerid]==1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "错误,暂时没有音乐", "额", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"所有音乐-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_llmusic, DIALOG_STYLE_TABLIST_HEADERS,tm, Showllmusiclist(playerid,P_page[playerid]), "确定", "取消");
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
	format(tmp,4128, "ID\t音乐名\t创建者\t收听价格\n");
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
    	strcat(tmp, "\t{FF8000}下一页\n");
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
			Dialog_Show(playerid, dl_llmusic, DIALOG_STYLE_TABLIST_HEADERS,"所有音乐/LLYY", Showllmusiclist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			new tmp[256];
			if(MUSICS[listid][music_uid]==PU[playerid])
			{
	            format(tmp, sizeof(tmp),""H_MUSICS"你播放了你收藏的音乐[{D96D26}%s{FFFFFF}]",MUSICS[listid][music_name]);
	            SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmp);
	            PlayAudioStreamForPlayer(playerid,MUSICS[listid][music_str]);
			}
			else
			{
				SetPVarInt(playerid,"listIDA",listid);
				format(tmp,256, "是否收听音乐[%s]创建者[%s],费用[$%i]",MUSICS[listid][music_name],UID[MUSICS[listid][music_uid]][u_name],MUSICS[listid][music_cash]);
				Dialog_Show(playerid, dl_musicshouting, DIALOG_STYLE_MSGBOX, "收听音乐",tmp, "收听", "再看看");
			}
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_llmusic, DIALOG_STYLE_TABLIST_HEADERS,"所有音乐/LLYY", Showllmusiclist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_musicshouting(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(!EnoughMoneyEx(playerid,MUSICS[listid][music_cash]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱", "好的", "");
		new tmps[512];
	    format(tmps, sizeof(tmps),""H_MUSICS"你播放了%s收藏的音乐[{D96D26}%s{FFFFFF}]",UID[MUSICS[listid][music_uid]][u_name],MUSICS[listid][music_name]);
	    SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmps);
	    PlayAudioStreamForPlayer(playerid,MUSICS[listid][music_str]);
	    if(MUSICS[listid][music_cash]>0)
	    {
		    Moneyhandle(PU[playerid],-MUSICS[listid][music_cash]);
			format(tmps,100,"%s点播了你收藏的音乐[%s],花费[$%i]",Gn(playerid),UID[MUSICS[listid][music_uid]][u_name],MUSICS[listid][music_cash]);
		    AddPlayerLog(MUSICS[listid][music_uid],"音悦台",tmps,MUSICS[listid][music_cash]);
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
			Dialog_Show(playerid, dl_mymusic, DIALOG_STYLE_LIST,"我的音乐/WDYY", Showmymusiclist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<100)return SM(COLOR_TWTAN,"你的积分不足100,无法添加音乐");
		    if(!EnoughMoneyEx(playerid,100000))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $100000", "好的", "");
			new i=Iter_Free(MUSICS);
			if(i==-1)return SM(COLOR_TWAQUA,"音乐数量已达到上限");
			Dialog_Show(playerid,dl_addyy,DIALOG_STYLE_INPUT,"添加音乐","请输入音乐名称","确定", "取消");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mymusicsz,DIALOG_STYLE_LIST,"音乐设置","自己播放\n广播音乐[1W]\n修改名称\n修改链接\n设置价格\n删除音乐","确定", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_mymusic, DIALOG_STYLE_LIST,"我的音乐/WDYY", Showmymusiclist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_addyy(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ReStr(inputtext);
	    if(strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_addyy,DIALOG_STYLE_INPUT,"添加音乐","请输入音乐名称","确定", "取消");
	    if(!EnoughMoneyEx(playerid,100000))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $100000", "好的", "");
		new i=Iter_Free(MUSICS);
		if(i==-1)return SM(COLOR_TWAQUA,"音乐数量已达到上限");
		MUSICS[i][music_uid]=PU[playerid];
		format(MUSICS[i][music_name],100,inputtext);
		format(MUSICS[i][music_str],129,"MUSICNONE");
		MUSICS[i][music_cash]=0;
		SavedMUSICdata(i);
		Iter_Add(MUSICS,i);
		SetPVarInt(playerid,"listIDA",i);
		Moneyhandle(PU[playerid],-100000);
		Dialog_Show(playerid,dl_addyylj,DIALOG_STYLE_INPUT,"添加音乐链接","请输入音乐链接","确定", "取消");
	}
	return 1;
}
Dialog:dl_addyylj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ReStr(inputtext);
	    if(strlenEx(inputtext)<10)return Dialog_Show(playerid,dl_addyylj,DIALOG_STYLE_INPUT,"添加音乐链接","请输入音乐链接","确定", "取消");
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
	    if(strlen(inputtext)<3||strlen(inputtext)>100)return Dialog_Show(playerid,dl_mymusicszmc,DIALOG_STYLE_INPUT,"修改名称","请输入音乐名称","确定", "取消");
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
	    if(strlen(inputtext)<10||strlen(inputtext)>129)return Dialog_Show(playerid,dl_mymusicszlj,DIALOG_STYLE_INPUT,"修改链接","请输入音乐链接","确定", "取消");
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
	    if(strval(inputtext)<0||strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_mymusicszjg,DIALOG_STYLE_INPUT,"数值错误","请输入价格","确定", "取消");
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
	            format(tmps, sizeof(tmps),""H_MUSICS"你播放了你收藏的音乐[{D96D26}%s{FFFFFF}]",MUSICS[listid][music_name]);
	            SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmps);
	            PlayAudioStreamForPlayer(playerid,MUSICS[listid][music_str]);
			}
	        case 1:
	        {
	            if(!EnoughMoneyEx(playerid,10000))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $10000", "好的", "");
	            if(!ismusictime)return SM(COLOR_TWAQUA,"管理员已关闭音乐广播");
	            if(musictime>0)return SM(COLOR_TWAQUA,"其他音乐正在广播中,请稍候..");
	            if(!strcmpEx(MUSICS[listid][music_str],"MUSICNONE", false))return SM(COLOR_TWAQUA,"此音乐没有设置链接,请先设置后再播放");
	            new tmps[512];
	            format(tmps, sizeof(tmps),"全服广播:"H_MUSICS"%s点播了他收藏的音乐[{D96D26}%s{FFFFFF}]",Gn(playerid),MUSICS[listid][music_name]);
	            SendMessageToAll(COLOR_LIGHTGOLDENRODYELLOW,tmps);
	            foreach(new i:Player)if(AvailablePlayer(i))PlayAudioStreamForPlayer(i,MUSICS[listid][music_str]);
	            musictime=4;
	            musicid=listid;
	            Moneyhandle(PU[playerid],-10000);
	        }
	        case 2:Dialog_Show(playerid,dl_mymusicszmc,DIALOG_STYLE_INPUT,"修改名称","请输入音乐名称","确定", "取消");
	        case 3:Dialog_Show(playerid,dl_mymusicszlj,DIALOG_STYLE_INPUT,"修改链接","请输入音乐链接","确定", "取消");
	        case 4:Dialog_Show(playerid,dl_mymusicszjg,DIALOG_STYLE_INPUT,"设置价格","请输入价格","确定", "取消");
	        case 5:
	        {
	            Iter_Remove(MUSICS,listid);
				fremove(Get_Path(listid,34));
				SM(COLOR_TWAQUA, "删除音乐成功");
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
		    format(tmps,100,"{FF8000}添加新的音乐[10W]");
		    strcat(tmp,tmps);
		    isover=1;
			break;
		}
	    else strcat(tmp,tmps);
	}
	if(isover==0)
	{
    	strcat(tmp, "\t\t\t{FF8000}下一页\n");
    }
    return tmp;
}
