CMD:wddp(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:DPInfo)
	{
		if(DPInfo[i][dp_uid]==PU[playerid])
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的地盘-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_mydp, DIALOG_STYLE_LIST,tm, Showmydplist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:dp(playerid, params[], help)
{
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/dp 地盘ID");
	if(!Iter_Contains(DPInfo,pid))return SM(COLOR_TWAQUA,"没有此地盘");
	SetPlayerPosEx(playerid,DPInfo[pid][dp_goX],DPInfo[pid][dp_goY],DPInfo[pid][dp_goZ],DPInfo[pid][dp_goA],0,0);
	new tmps[100];
	format(tmps, sizeof(tmps),"%s传送到了ID:%i地盘[%s]  /dp %i ",Gnn(playerid),pid,DPInfo[pid][dp_name],pid);
 	SendMessageToAll(COLOR_LIGHTCYAN,tmps);
	return 1;
}
CMD:lldp(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
	foreach(new i:DPInfo)
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
       	current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "错误,暂时没有地盘", "确定", "取消");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"世界地盘-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_lldp, DIALOG_STYLE_TABLIST_HEADERS,tm, Showlldplist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showlldplist(playerid,pager)
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
	format(tmp,4128, "ID\t地盘名\t主人\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
		new tmps[256];
		if(i<current_number[playerid])
        {
			format(tmps,100,"ID:%i\t%s\t%s\n",current_idx[playerid][i],DPInfo[current_idx[playerid][i]][dp_name],UID[DPInfo[current_idx[playerid][i]][dp_uid]][u_name]);
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
Dialog:dl_lldp(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_lldp,DIALOG_STYLE_TABLIST_HEADERS,"世界地盘",Showlldplist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPlayerPosEx(playerid,DPInfo[listid][dp_goX],DPInfo[listid][dp_goY],DPInfo[listid][dp_goZ],0.0,DPInfo[listid][dp_in],DPInfo[listid][dp_wl]);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_lldp,DIALOG_STYLE_TABLIST_HEADERS,"世界地盘",Showlldplist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_mydp(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_mydp, DIALOG_STYLE_LIST,"我的地盘/WDDP", Showmydplist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<500)return SM(COLOR_TWTAN,"你的积分不足500,无法创建地盘");
		    if(UID[PU[playerid]][u_wds]<5)return SM(COLOR_TWTAN,"创建地盘最少需要5V币,你没有那么多");
		    if(IsPlayerInAnyDynamicArea(playerid))return SM(COLOR_TWAQUA,"你在其他地盘内无法创建");
			new i=Iter_Free(DPInfo);
			if(i==-1)return SM(COLOR_TWAQUA,"地盘数量已达到上限");
			if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return SM(COLOR_TWAQUA,"你必须在大世界创建");
			Dialog_Show(playerid, dl_cjdp, DIALOG_STYLE_MSGBOX, "创建地盘", "请确定是否在此处要创建", "创建", "取消");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPlayerPosEx(playerid,DPInfo[listid][dp_goX],DPInfo[listid][dp_goY],DPInfo[listid][dp_goZ],DPInfo[listid][dp_goA],0,0);
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_mydp, DIALOG_STYLE_LIST,"我的地盘/WDDP", Showmydplist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_cjdp(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new tmp[738],Stru[64];
		Loop(x,sizeof(colorMenu)-SCOLOR)
		{
			format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
			strcat(tmp,Stru);
		}
		Dialog_Show(playerid,dl_cjdpcolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
	}
	return 1;
}
Dialog:dl_dpszmusic(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_dpszmusic,DIALOG_STYLE_INPUT,"地盘音乐","请输入地盘音乐地址","确定输入", "取消音乐");
		new idx=GetPVarInt(playerid,"listIDA");
		DPInfo[idx][dp_ismusic]=1;
		format(DPInfo[idx][dp_musicstr],100,"%s",inputtext);
		SavedDPdata(idx);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	else
	{
	    new idx=GetPVarInt(playerid,"listIDA");
	    DPInfo[idx][dp_ismusic]=0;
	    format(DPInfo[idx][dp_musicstr],100,"NONE");
	    SavedDPdata(idx);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
	    Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	return 1;
}
stock IsHereAreaOwner(playerid)
{
	if(IsPlayerInAnyDynamicArea(playerid))
	{
		foreach(new i:DPInfo)
		{
			if(IsPlayerInDynamicArea(playerid,DPInfo[i][dp_area]))
			{
				if(DPInfo[i][dp_uid]==PU[playerid])return i;
			}
		}
	}
	return -1;
}
stock GetAreaOwner(playerid)
{
	if(IsPlayerInAnyDynamicArea(playerid))
	{
		foreach(new i:DPInfo)
		{
			if(IsPlayerInDynamicArea(playerid,DPInfo[i][dp_area]))return i;
		}
	}
	return -1;
}
stock GetAreaJJprotect(playerid)
{
	if(IsPlayerInAnyDynamicArea(playerid))
	{
		foreach(new i:DPInfo)
		{
			if(IsPlayerInDynamicArea(playerid,DPInfo[i][dp_area]))
			{
			    if(DPInfo[i][dp_uid]==PU[playerid])return 0;
				else
				{
				    if(GetfriendshareDP(DPInfo[i][dp_uid],PU[playerid],i))return 0;
				    if(DPInfo[i][dp_jprotect])return 1;
				}
			}
		}
	}
	return 0;
}
stock GetfriendshareDP(fid,pid,aid)
{
    foreach(new i:friends[fid])
	{
	    if(friends[fid][i][fr_uid]==pid)
	    {
	    	if(friends[fid][i][fr_dipan])
	    	{
    	        if(friends[fid][i][fr_dipanid]==aid)return 1;
	    	}
	    }
	}
	return 0;
}
stock GetAreaJJprotectEx(jix,playerid)
{
	if(IsPointInAnyDynamicArea(JJ[jix][jx],JJ[jix][jy],JJ[jix][jz]))
	{
		foreach(new i:DPInfo)
		{
			if(IsPointInDynamicArea(DPInfo[i][dp_area],JJ[jix][jx],JJ[jix][jy],JJ[jix][jz]))
			{
			    if(DPInfo[i][dp_uid]==PU[playerid])return 0;
				else
				{
				    if(GetfriendshareDP(DPInfo[i][dp_uid],PU[playerid],i))return 0;
				    if(DPInfo[i][dp_jprotect]&&!JJ[jix][jin]&&!JJ[jix][jin])return 1;
				}
			}
		}
	}
	return 0;
}
Dialog:dl_dpszbh(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new idx=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:
	        {
				if(!DPInfo[idx][dp_jprotect])
				{
					DPInfo[idx][dp_jprotect]=1;
					SM(COLOR_TWAQUA,"地盘已开启家具保护");
				}
				else
				{
					DPInfo[idx][dp_jprotect]=0;
					SM(COLOR_TWAQUA,"地盘已关闭家具保护");
				}
	        }
	        case 1:
	        {
				if(!DPInfo[idx][dp_zprotect])
				{
					DPInfo[idx][dp_zprotect]=1;
					SM(COLOR_TWAQUA,"地盘已开启装扮保护");
				}
				else
				{
					DPInfo[idx][dp_zprotect]=0;
					SM(COLOR_TWAQUA,"地盘已关闭装扮保护");
				}
	        }
	        case 2:
	        {
				if(!DPInfo[idx][dp_wprotect])
				{
					DPInfo[idx][dp_wprotect]=1;
					SM(COLOR_TWAQUA,"地盘已开启武器保护");
				}
				else
				{
					DPInfo[idx][dp_wprotect]=0;
					SM(COLOR_TWAQUA,"地盘已关闭武器保护");
				}
	        }
	        case 3:
	        {
				if(!DPInfo[idx][dp_cprotect])
				{
					DPInfo[idx][dp_cprotect]=1;
					SM(COLOR_TWAQUA,"地盘已开启载具保护");
				}
				else
				{
					DPInfo[idx][dp_cprotect]=0;
					SM(COLOR_TWAQUA,"地盘已关闭载具保护");
				}
	        }
	    }
	    SavedDPdata(idx);
	}
	return 1;
}
Dialog:dl_dpsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new idx=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:
	        {
	        	Dialog_Show(playerid,dl_dpszname,DIALOG_STYLE_INPUT,"地盘名字","请输入名字","确定", "取消");
	        }
	        case 1:
	        {
	            Dialog_Show(playerid,dl_dpszmm,DIALOG_STYLE_INPUT,"地盘密码","请输入密码","确定密码", "取消密码");
	        }
	        case 2:
	        {
	            Dialog_Show(playerid,dl_dpszmusic,DIALOG_STYLE_INPUT,"地盘音乐","请输入地盘音乐地址","确定输入", "取消音乐");
	        }
	        case 3:
	        {
	            Dialog_Show(playerid, dl_dpszss, DIALOG_STYLE_MSGBOX, "地盘闪烁","确定要闪烁地盘吗", "闪烁", "不要");
	        }
	        case 4:
	        {
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_dpszcolor,DIALOG_STYLE_LIST,"地盘颜色",tmp,"确定", "取消");
	        }
	        case 5:
	        {
				Dialog_Show(playerid,dl_dpszbh,DIALOG_STYLE_LIST,"地盘保护","家具保护\n装扮保护\n武器保护\n汽车保护","确定", "取消");
	        }
	        case 6:
	        {
	        	if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此地盘,请先下架再试", "好的", "");
	            if(UID[PU[playerid]][u_wds]<2)return SM(COLOR_TWTAN,"编辑地盘最少需要2V币,你没有那么多");
				E_dit[playerid][idx][o_X]=DPInfo[idx][dp_minX];
				E_dit[playerid][idx][o_Y]=DPInfo[idx][dp_minY];
				E_dit[playerid][idx][r_X]=DPInfo[idx][dp_maxX];
				E_dit[playerid][idx][r_Y]=DPInfo[idx][dp_maxY];
				if(IsValidDynamicArea(DPInfo[idx][dp_area]))DestroyDynamicArea(DPInfo[idx][dp_area]);
	    		TogglePlayerControllable(playerid, 0);
				pstat[playerid]=EDIT_ZONE;
	    		Edit[playerid]=repeat Editzone[150](playerid,idx);
	    		SM(COLOR_TWAQUA,"上下键调节大小，ALT键保存或取消");
	        }
	        case 7:
	        {
	            Dialog_Show(playerid, dl_dpszsc, DIALOG_STYLE_MSGBOX, "地盘删除","确定删除你的地盘吗", "删除", "不要");
	        }
		}
	}
	return 1;
}
Dialog:dl_zfeditdp(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"ltd");
	if(response)
	{
		new area1 = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY])*CM_DIPAN);
		if(area1<0)area1=-area1;
	    new area2 = floatround((E_dit[playerid][listid][r_X] - E_dit[playerid][listid][o_X]) * (E_dit[playerid][listid][r_Y]-E_dit[playerid][listid][o_Y])*CM_DIPAN);
		if(area2<0)area2=-area2;
		new area3 = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY]));
		new wdss=area3/150+2;
		new areamoney=area1-area2;
		if(areamoney>MAX_MONEY)
		{
			Quiteditdp(playerid,listid);
			SM(COLOR_TWAQUA,"地盘过大无法创建");
			return 1;
		}
		if(areamoney>1000000)
		{
			Quiteditdp(playerid,listid);
			SM(COLOR_TWAQUA,"地盘过小无法创建");
			return 1;
		}
		if(EnoughMoneyEx(playerid,areamoney))
		{
		    if(UID[PU[playerid]][u_wds]<wdss)
		    {
				Quiteditdp(playerid,listid);
				SM(COLOR_TWAQUA,"地盘过小无法创建");
				return 1;
		    }
		    else
		    {
				Moneyhandle(PU[playerid],-areamoney);
				VBhandle(PU[playerid],-wdss);
				stop Edit[playerid];
				DPInfo[listid][dp_minX]=E_dit[playerid][listid][o_X];
				DPInfo[listid][dp_minY]=E_dit[playerid][listid][o_Y];
				DPInfo[listid][dp_maxX]=E_dit[playerid][listid][r_X];
				DPInfo[listid][dp_maxY]=E_dit[playerid][listid][r_Y];
				GangZoneDestroy(DPInfo[listid][dp_zone]);
				DPInfo[listid][dp_area]=CreateDynamicRectangle(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY],DPInfo[listid][dp_wl],DPInfo[listid][dp_in]);
				DPInfo[listid][dp_zone]=GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
				GZoneShowForALL(listid);
				SavedDPdata(listid);
				DeletePVar(playerid,"ltd");
				pstat[playerid]=NO_MODE;
				TogglePlayerControllable(playerid, true);
				new tm[128];
				format(tm,sizeof(tm),"你的地盘[ID:%i]编辑成功",listid);
				SM(COLOR_TWAQUA,tm);
				format(tm,sizeof(tm),"ID:%i地盘%s设置",listid,DPInfo[listid][dp_name]);
				Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
			}
		}
		else
		{
			Quiteditdp(playerid,listid);
			SM(COLOR_TWTAN,""H_ME"你没有足够的钱");
		}
	}
	else Quiteditdp(playerid,listid);
	return 1;
}
Dialog:dl_eidtdpwz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"ltd");
	    switch(listitem)
	    {
	        case 0:
	        {
	            new area1 = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY])*CM_DIPAN);
				if(area1<0)area1=-area1;
	            new area2 = floatround((E_dit[playerid][listid][r_X] - E_dit[playerid][listid][o_X]) * (E_dit[playerid][listid][r_Y]-E_dit[playerid][listid][o_Y])*CM_DIPAN);
				if(area2<0)area2=-area2;
				new area3 = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY]));
				new wdss=floatround(area3/150+2);
				if(area1>=area2)
				{
					stop Edit[playerid];
					DPInfo[listid][dp_minX]=E_dit[playerid][listid][o_X];
					DPInfo[listid][dp_minY]=E_dit[playerid][listid][o_Y];
					DPInfo[listid][dp_maxX]=E_dit[playerid][listid][r_X];
					DPInfo[listid][dp_maxY]=E_dit[playerid][listid][r_Y];
					GangZoneDestroy(DPInfo[listid][dp_zone]);
					DPInfo[listid][dp_area]=CreateDynamicRectangle(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY],DPInfo[listid][dp_wl],DPInfo[listid][dp_in]);
					DPInfo[listid][dp_zone]=GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
					GZoneShowForALL(listid);
					SavedDPdata(listid);
					DeletePVar(playerid,"ltd");
					pstat[playerid]=NO_MODE;
					TogglePlayerControllable(playerid, true);
					new tm[128];
					format(tm,sizeof(tm),"你的地盘[ID:%i]编辑成功",listid);
					SM(COLOR_TWAQUA,tm);
					format(tm,sizeof(tm),"ID:%i地盘%s设置",listid,DPInfo[listid][dp_name]);
					Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
				}
				else
				{
	                new tm[80];
					format(tm,sizeof(tm),"你需要支付$%i和%iV币才能使用此地盘",area2-area1,wdss);
	                Dialog_Show(playerid, dl_zfeditdp, DIALOG_STYLE_MSGBOX, "提示",tm, "支付", "不用了");
                }
	        }
	        case 1:Quiteditdp(playerid,listid);
	    }
	}
	return 1;
}
stock Quiteditdp(playerid,listid)
{
	stop Edit[playerid];
	GangZoneDestroy(DPInfo[listid][dp_zone]);
	DPInfo[listid][dp_area]=CreateDynamicRectangle(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY],DPInfo[listid][dp_wl],DPInfo[listid][dp_in]);
	DPInfo[listid][dp_zone]=GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
	GZoneShowForALL(listid);
    DeletePVar(playerid,"ltd");
	pstat[playerid]=NO_MODE;
	TogglePlayerControllable(playerid, true);
	new tm[128];
	format(tm,sizeof(tm),"你的地盘[ID:%i]已取消编辑",listid);
    SM(COLOR_TWAQUA,tm);
	format(tm,sizeof(tm),"ID:%i地盘%s设置",listid,DPInfo[listid][dp_name]);
	Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	return 1;
}
timer Editzone[150](playerid,listid)
{
	if(pstat[playerid]==EDIT_ZONE)
	{
		new Keys,UpDown,LeftRight;
	    GetPlayerKeys(playerid, Keys, UpDown, LeftRight);
        if(LeftRight == -128 && Keys == 8 )
        {
            if(E_dit[playerid][listid][o_X]>E_dit[playerid][listid][r_X])return SM(COLOR_TWAQUA,"地盘创建错误[代号1-2]");
       		E_dit[playerid][listid][o_X] += 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
         	DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
        }
        else if(LeftRight == -128)
        {
            if(E_dit[playerid][listid][o_X]>E_dit[playerid][listid][r_X])return SM(COLOR_TWAQUA,"地盘创建错误[代号1-1]");
            E_dit[playerid][listid][o_X] -= 8.0;
         	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
        }
        else if(LeftRight==128 && Keys==8 )
        {
            if(E_dit[playerid][listid][o_X]>E_dit[playerid][listid][r_X])return SM(COLOR_TWAQUA,"地盘创建错误[代号2-2]");
        	E_dit[playerid][listid][r_X] -= 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
        else if(LeftRight == 128)
        {
            if(E_dit[playerid][listid][o_X]>E_dit[playerid][listid][r_X])return SM(COLOR_TWAQUA,"地盘创建错误[代号2-1]");
        	E_dit[playerid][listid][r_X] += 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown==-128 && Keys==8 )
		{
		    if(E_dit[playerid][listid][o_Y]>E_dit[playerid][listid][r_Y])return SM(COLOR_TWAQUA,"地盘创建错误[代号3-2]");
		    E_dit[playerid][listid][o_Y] -= 8.0;
			GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown == -128)
		{
		    if(E_dit[playerid][listid][o_Y]>E_dit[playerid][listid][r_Y])return SM(COLOR_TWAQUA,"地盘创建错误[代号3-1]");
		    E_dit[playerid][listid][o_Y] += 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown == 128 && Keys==8)
		{
		    if(E_dit[playerid][listid][o_Y]>E_dit[playerid][listid][r_Y])return SM(COLOR_TWAQUA,"地盘创建错误[代号4-2]");
		    E_dit[playerid][listid][r_Y] += 8.0;
			GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown == 128)
		{
		    if(E_dit[playerid][listid][o_Y]>E_dit[playerid][listid][r_Y])return SM(COLOR_TWAQUA,"地盘创建错误[代号4-1]");
		    E_dit[playerid][listid][r_Y] -= 8.0;
			GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(Keys == KEY_WALK)
		{
			Dialog_Show(playerid,dl_eidtdpwz, DIALOG_STYLE_LIST, "完成编辑", "保存编辑\n取消编辑", "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_dpszname(playerid, response, listitem, inputtext[])
{
	new idx=GetPVarInt(playerid,"listIDA");
	if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此底盘,请先下架再试", "好的", "");
	if(response)
	{
        new mima[100];
		if(sscanf(inputtext, "s[100]",mima))return Dialog_Show(playerid,dl_dpszname,DIALOG_STYLE_INPUT,"地盘名字","请输入名字","确定", "取消");
        format(DPInfo[idx][dp_name],100,mima);
        SavedDPdata(idx);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	else
	{
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	return 1;
}
Dialog:dl_dpszmm(playerid, response, listitem, inputtext[])
{
	new idx=GetPVarInt(playerid,"listIDA");
	if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此底盘,请先下架再试", "好的", "");
	if(response)
	{
        new mima[100];
		if(sscanf(inputtext, "s[100]",mima))return Dialog_Show(playerid,dl_dpszmm,DIALOG_STYLE_INPUT,"地盘密码","请输入密码","确定密码", "取消密码");
        format(DPInfo[idx][dp_passward],100,mima);
        DPInfo[idx][dp_isopen]=1;
        SavedDPdata(idx);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	else
	{
        format(DPInfo[idx][dp_passward],100,"无");
        DPInfo[idx][dp_isopen]=0;
        SavedDPdata(idx);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	return 1;
}
Dialog:dl_dpszssxz(playerid, response, listitem, inputtext[])
{
    new idx=GetPVarInt(playerid,"listIDA");
    if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此底盘,请先下架再试", "好的", "");
	if(response)
	{
	    DPInfo[idx][dp_colorex]=listitem;
		DPInfo[idx][dp_isflash]=1;
        SavedDPdata(idx);
		GangZoneFlashForAll(DPInfo[idx][dp_zone],colorMenu[DPInfo[idx][dp_colorex]]);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	else
	{
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	return 1;
}
Dialog:dl_dpszss(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new tmp[738],Stru[64];
		Loop(x,sizeof(colorMenu)-SCOLOR)
		{
			format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
			strcat(tmp,Stru);
		}
		Dialog_Show(playerid,dl_dpszssxz,DIALOG_STYLE_LIST,"地盘颜色",tmp,"确定", "取消");
	}
	else
	{
    	new idx=GetPVarInt(playerid,"listIDA");
    	if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此底盘,请先下架再试", "好的", "");
		DPInfo[idx][dp_isflash]=0;
        SavedDPdata(idx);
		GangZoneStopFlashForAll(DPInfo[idx][dp_zone]);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	return 1;
}
Dialog:dl_dpszcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new idx=GetPVarInt(playerid,"listIDA");
		if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此底盘,请先下架再试", "好的", "");
        DPInfo[idx][dp_color]=listitem;
        GZoneShowForALL(idx);
        SavedDPdata(idx);
		new tm[80];
		format(tm,sizeof(tm),"ID:%i地盘%s设置",idx,DPInfo[idx][dp_name]);
		Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n调整地盘\n删除地盘","确定", "取消");
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_dpszsc(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new idx=GetPVarInt(playerid,"listIDA");
		if(IsDPselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此底盘,请先下架再试", "好的", "");
		GangZoneDestroy(DPInfo[idx][dp_zone]);
	    if(IsValidDynamicArea(DPInfo[idx][dp_area]))DestroyDynamicArea(DPInfo[idx][dp_area]);
  		fremove(Get_Path(idx,19));
		Iter_Remove(DPInfo,idx);
		new tm[64];
		format(tm,sizeof(tm),"你已删除你的地盘[ID:%i]",idx);
  		SM(COLOR_TWAQUA,tm);
  		DeletePVar(playerid,"listIDA");
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_cjdpcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=Iter_Free(DPInfo);
	    if(i==-1)return SM(COLOR_TWAQUA,"地盘数量已达到上限");
	    if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return SM(COLOR_TWAQUA,"你必须在大世界创建");
	    DPInfo[i][dp_color]=listitem;
		GetPlayerPos(playerid,DPInfo[i][dp_minX],DPInfo[i][dp_minY],DPInfo[i][dp_minZ]);
	    GetPlayerPos(playerid,DPInfo[i][dp_maxX],DPInfo[i][dp_maxY],DPInfo[i][dp_maxZ]);
	    GetPlayerPos(playerid,DPInfo[i][dp_goX],DPInfo[i][dp_goY],DPInfo[i][dp_goZ]);
	    GetPlayerFacingAngle(playerid,DPInfo[i][dp_goA]);
		format(DPInfo[i][dp_name],100,"未命名");
		format(DPInfo[i][dp_passward],100,"无");
		DPInfo[i][dp_minZ]-=500;
	    DPInfo[i][dp_maxZ]+=50;
		DPInfo[i][dp_isopen]=0;
		DPInfo[i][dp_jprotect]=0;
		DPInfo[i][dp_zprotect]=0;
		DPInfo[i][dp_wprotect]=0;
		DPInfo[i][dp_cprotect]=0;
		DPInfo[i][dp_isflash]=0;
		DPInfo[i][dp_uid]=PU[playerid];
		DPInfo[i][dp_wl]=GetPlayerVirtualWorld(playerid);
		DPInfo[i][dp_in]=GetPlayerInterior(playerid);
		DPInfo[i][dp_gid]=-1;
		Iter_Add(DPInfo,i);
		DPInfo[i][dp_zone] = GangZoneCreate(DPInfo[i][dp_minX],DPInfo[i][dp_minY],DPInfo[i][dp_maxX],DPInfo[i][dp_maxY]);
	    SetPVarInt(playerid,"ltd",i);
	    TogglePlayerControllable(playerid, 0);
		pstat[playerid]=CJ_ZONE;
	    Edit[playerid]=repeat CJzone[150](playerid,i);
	    SM(COLOR_TWAQUA,"上下键调节大小，ALT键保存或取消");
	}
	return 1;
}
timer CJzone[150](playerid,listid)
{
	if(pstat[playerid]==CJ_ZONE)
	{
		new Keys,UpDown,LeftRight;
	    GetPlayerKeys(playerid, Keys, UpDown, LeftRight);
        if(LeftRight == -128 && Keys == 8 )
        {
       		DPInfo[listid][dp_minX] += 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
        }
        else if(LeftRight == -128)
        {
            DPInfo[listid][dp_minX] -= 8.0;
         	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
        }
        else if(LeftRight==128 && Keys==8 )
        {
        	DPInfo[listid][dp_maxX] -= 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
        else if(LeftRight == 128)
        {
        	DPInfo[listid][dp_maxX] += 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown==-128 && Keys==8 )
		{
		    DPInfo[listid][dp_maxY] -= 8.0;
			GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown == -128)
		{
		    DPInfo[listid][dp_maxY] += 8.0;
          	GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown == 128 && Keys==8)
		{
		    DPInfo[listid][dp_minY] += 8.0;
			GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(UpDown == 128)
		{
		    DPInfo[listid][dp_minY] -= 8.0;
			GangZoneDestroy(DPInfo[listid][dp_zone]);
       		DPInfo[listid][dp_zone] = GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
         	GangZoneShowForPlayer(playerid, DPInfo[listid][dp_zone],colorMenu[DPInfo[listid][dp_color]]);
		}
		else if(Keys == KEY_WALK)
		{
			Dialog_Show(playerid,dl_cjdpwz, DIALOG_STYLE_LIST, "完成编辑", "保存编辑\n取消编辑", "确定", "取消");
		}
	}
	return 1;
}
stock GZoneShowForALL(idx)
{
	GangZoneHideForAll(DPInfo[idx][dp_zone]);
	GangZoneShowForAll(DPInfo[idx][dp_zone],colorMenu[DPInfo[idx][dp_color]]);
	if(DPInfo[idx][dp_isflash])GangZoneFlashForAll(DPInfo[idx][dp_zone],colorMenu[DPInfo[idx][dp_colorex]]);
	return 1;
}
stock GZoneShowForplayer(playerid)
{
	foreach(new i:DPInfo)
	{
		GangZoneHideForPlayer(playerid, DPInfo[i][dp_zone]);
		GangZoneShowForPlayer(playerid, DPInfo[i][dp_zone],colorMenu[DPInfo[i][dp_color]]);
		if(DPInfo[i][dp_isflash])GangZoneFlashForAll(DPInfo[i][dp_zone],colorMenu[DPInfo[i][dp_colorex]]);
	}
	return 1;
}
stock IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if (x > minx && x < maxx && y > miny && y < maxy) return 1;
	return 0;
}
Dialog:dl_zfdp(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"ltd");
	if(response)
	{
		new area = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY])*CM_DIPAN);
		new area1 = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY]));
		if(area<0)area=-area;
		new wdss=area1/150+5;
		if(area>MAX_MONEY)
		{
			Quitcjdp(playerid,listid);
			SM(COLOR_TWTAN,""H_ME"地盘过大");
			return 1;
		}
		if(area<100000)
		{
			Quitcjdp(playerid,listid);
			SM(COLOR_TWAQUA,"地盘过小无法创建");
			return 1;
		}
		if(EnoughMoneyEx(playerid,area))
		{
			if(UID[PU[playerid]][u_wds]<wdss)
			{
				Quitcjdp(playerid,listid);
				SM(COLOR_TWAQUA,"你没有足够的V币");
				return 1;
			}
			else
			{
				Moneyhandle(PU[playerid],-area);
				VBhandle(PU[playerid],-wdss);
				stop Edit[playerid];
				GangZoneDestroy(DPInfo[listid][dp_zone]);
				DPInfo[listid][dp_area]=CreateDynamicRectangle(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY],DPInfo[listid][dp_wl],DPInfo[listid][dp_in]);
				DPInfo[listid][dp_zone]=GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
				GZoneShowForALL(listid);
				SavedDPdata(listid);
				DeletePVar(playerid,"ltd");
				pstat[playerid]=NO_MODE;
				TogglePlayerControllable(playerid, true);
			}
		}
		else
		{
			Quitcjdp(playerid,listid);
			SM(COLOR_TWTAN,""H_ME"你没有足够的钱");
		}
	}
	else Quitcjdp(playerid,listid);
	return 1;
}
stock Quitcjdp(playerid,listid)
{
	stop Edit[playerid];
	GangZoneDestroy(DPInfo[listid][dp_zone]);
	if(IsValidDynamicArea(DPInfo[listid][dp_area]))DestroyDynamicArea(DPInfo[listid][dp_area]);
	fremove(Get_Path(listid,19));
	Iter_Remove(DPInfo,listid);
	DeletePVar(playerid,"ltd");
	pstat[playerid]=NO_MODE;
	TogglePlayerControllable(playerid, true);
	return 1;
}
Dialog:dl_cjdpwz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"ltd");
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(IsPlayerInArea(playerid,DPInfo[listid][dp_minX],DPInfo[listid][dp_maxX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxY]))
	            {
	                new area = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY])*CM_DIPAN);
	                new area1 = floatround((DPInfo[listid][dp_maxX] - DPInfo[listid][dp_minX]) * (DPInfo[listid][dp_maxY]-DPInfo[listid][dp_minY]));
                    if(area<0)area=-area;
					new tm[80];
					format(tm,sizeof(tm),"你需要支付$%i和%iV币才能使用此地盘",area,area1/150+5);
	                Dialog_Show(playerid, dl_zfdp, DIALOG_STYLE_MSGBOX, "提示",tm, "支付", "不用了");
				}
				else
				{
					Quitcjdp(playerid,listid);
					SM(COLOR_TWAQUA,"你的位置不在创建的地盘里");
				}
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wddp");
	        }
	        case 1:
	        {
				Quitcjdp(playerid,listid);
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wddp");
	        }
	    }
	}
	return 1;
}
stock Showmydplist(playerid,pager)
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
			format(tmps,100,"ID:%i地盘[%s]\n",current_idx[playerid][i],DPInfo[current_idx[playerid][i]][dp_name]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}创建新的地盘");
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
stock Removedipan(idx)
{
	GangZoneDestroy(DPInfo[idx][dp_zone]);
	if(IsValidDynamicArea(DPInfo[idx][dp_area]))DestroyDynamicArea(DPInfo[idx][dp_area]);
	Iter_Remove(DPInfo,idx);
	fremove(Get_Path(idx,19));
    return 1;
}
Function LoadDP_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_DP)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,19), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,19), "LoadDPData", false, true, i, true, false);
            DPInfo[i][dp_area]=CreateDynamicRectangle(DPInfo[i][dp_minX],DPInfo[i][dp_minY],DPInfo[i][dp_maxX],DPInfo[i][dp_maxY],DPInfo[i][dp_wl],DPInfo[i][dp_in]);
			DPInfo[i][dp_zone]=GangZoneCreate(DPInfo[i][dp_minX],DPInfo[i][dp_minY],DPInfo[i][dp_maxX],DPInfo[i][dp_maxY]);
  			Iter_Add(DPInfo,i);
 			idx++;
        }
    }
    return idx;
}
Function LoadDPData(i, name[], value[])
{
    INI_String("dp_name",DPInfo[i][dp_name],100);
    INI_String("dp_passward",DPInfo[i][dp_passward],100);
    INI_Int("dp_uid",DPInfo[i][dp_uid]);
    INI_Int("dp_gid",DPInfo[i][dp_gid]);
    INI_Float("dp_goX",DPInfo[i][dp_goX]);
    INI_Float("dp_goY",DPInfo[i][dp_goY]);
    INI_Float("dp_goZ",DPInfo[i][dp_goZ]);
    INI_Float("dp_goA",DPInfo[i][dp_goA]);
    INI_Float("dp_minX",DPInfo[i][dp_minX]);
    INI_Float("dp_minY",DPInfo[i][dp_minY]);
    INI_Float("dp_minZ",DPInfo[i][dp_minZ]);
    INI_Float("dp_maxX",DPInfo[i][dp_maxX]);
    INI_Float("dp_maxY",DPInfo[i][dp_maxY]);
    INI_Float("dp_maxZ",DPInfo[i][dp_maxZ]);
    INI_Int("dp_isopen",DPInfo[i][dp_isopen]);
    INI_Int("dp_isflash",DPInfo[i][dp_isflash]);
    INI_Int("dp_color",DPInfo[i][dp_color]);
    INI_Int("dp_colorex",DPInfo[i][dp_colorex]);
    INI_Int("dp_jprotect",DPInfo[i][dp_jprotect]);
    INI_Int("dp_zprotect",DPInfo[i][dp_zprotect]);
    INI_Int("dp_wprotect",DPInfo[i][dp_wprotect]);
    INI_Int("dp_cprotect",DPInfo[i][dp_cprotect]);
    INI_Int("dp_wl",DPInfo[i][dp_wl]);
    INI_Int("dp_in",DPInfo[i][dp_in]);
    INI_Int("dp_ismusic",DPInfo[i][dp_ismusic]);
    INI_String("dp_musicstr",DPInfo[i][dp_musicstr],100);
	return 1;
}
Function SavedDPdata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,19));
    INI_WriteString(File,"dp_name",DPInfo[Count][dp_name]);
    INI_WriteString(File,"dp_passward",DPInfo[Count][dp_passward]);
    INI_WriteInt(File,"dp_uid",DPInfo[Count][dp_uid]);
    INI_WriteInt(File,"dp_gid",DPInfo[Count][dp_gid]);
    INI_WriteFloat(File, "dp_goX",DPInfo[Count][dp_goX]);
    INI_WriteFloat(File, "dp_goY",DPInfo[Count][dp_goY]);
    INI_WriteFloat(File, "dp_goZ",DPInfo[Count][dp_goZ]);
    INI_WriteFloat(File, "dp_goA",DPInfo[Count][dp_goA]);
    INI_WriteFloat(File, "dp_minX",DPInfo[Count][dp_minX]);
    INI_WriteFloat(File, "dp_minY",DPInfo[Count][dp_minY]);
    INI_WriteFloat(File, "dp_minZ",DPInfo[Count][dp_minZ]);
    INI_WriteFloat(File, "dp_maxX",DPInfo[Count][dp_maxX]);
    INI_WriteFloat(File, "dp_maxY",DPInfo[Count][dp_maxY]);
    INI_WriteFloat(File, "dp_maxZ",DPInfo[Count][dp_maxZ]);
    INI_WriteInt(File, "dp_isopen",DPInfo[Count][dp_isopen]);
    INI_WriteInt(File, "dp_isflash",DPInfo[Count][dp_isflash]);
    INI_WriteInt(File, "dp_color",DPInfo[Count][dp_color]);
    INI_WriteInt(File, "dp_colorex",DPInfo[Count][dp_colorex]);
    INI_WriteInt(File, "dp_jprotect",DPInfo[Count][dp_jprotect]);
    INI_WriteInt(File, "dp_zprotect",DPInfo[Count][dp_zprotect]);
    INI_WriteInt(File, "dp_wprotect",DPInfo[Count][dp_wprotect]);
    INI_WriteInt(File, "dp_cprotect",DPInfo[Count][dp_cprotect]);
    INI_WriteInt(File, "dp_wl",DPInfo[Count][dp_wl]);
    INI_WriteInt(File, "dp_in",DPInfo[Count][dp_in]);
    INI_WriteInt(File, "dp_ismusic",DPInfo[Count][dp_ismusic]);
    INI_WriteString(File,"dp_musicstr",DPInfo[Count][dp_musicstr]);
    INI_Close(File);
	return true;
}
public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(IsPlayerNPC(playerid))return 1;
	if(!AvailablePlayer(playerid))return 1;
    if(areaid==ffdtarea)return 1;
    if(areaid==JYarea)return 1;
    foreach(new i:DPInfo)
	{
		if(areaid==DPInfo[i][dp_area])
		{
		    if(DPInfo[i][dp_uid]==PU[playerid])
		    {
	    		new tm[128];
				format(tm,sizeof(tm),"你离开了你的地盘[ID:%i]",i);
		        SM(COLOR_TWAQUA,tm);
		        if(DPInfo[i][dp_ismusic]&&!IsServerMusic())StopAudioStreamForPlayer(playerid);
		        return 1;
		    }
		    else
		    {
    			new tm[128];
				format(tm,sizeof(tm),"你离开了%s的地盘[ID:%i]",UID[DPInfo[i][dp_uid]][u_name],i);
				SM(COLOR_GAINSBORO,tm);
				if(DPInfo[i][dp_zprotect])SM(COLOR_GAINSBORO,"装备已归还");
				if(DPInfo[i][dp_wprotect])SM(COLOR_GAINSBORO,"武器已归还");
				if(DPInfo[i][dp_ismusic]&&!IsServerMusic())StopAudioStreamForPlayer(playerid);
				EnterPArea(playerid,i,0);
				return 1;
		    }
		}
	}
	foreach(new i:Player)
	{
		Loop(q,MAX_PLAYER_ATTACHED_OBJECTS-1)RemovePlayerAttachedObject(playerid, q);
	    if(areaid==UID[PU[i]][u_area])
	    {
			if(PU[i]!=PU[playerid])
			{
				foreach(new idx:att[playerid])
				{
					UpdatePlayerAttachedObjectEx(playerid,idx,att[playerid][idx][att_modelid],att[playerid][idx][att_boneid],att[playerid][idx][att_fOffsetX],
								 att[playerid][idx][att_fOffsetY],att[playerid][idx][att_fOffsetZ],att[playerid][idx][att_fRotX],att[playerid][idx][att_fRotY],att[playerid][idx][att_fRotZ],
								 att[playerid][idx][att_fScaleX],att[playerid][idx][att_fScaleY],att[playerid][idx][att_fScaleZ],att[playerid][idx][att_materialcolor1],att[playerid][idx][att_materialcolor2],att[playerid][idx][att_iscol],att[playerid][idx][att_jcoltime],att[playerid][idx][att_ismater]);
				}
			}
	    }
	}
	return 1;
}
stock EnterPArea(playerid,aid,type)
{
	if(DPInfo[aid][dp_zprotect])
	{
	    if(type)Loop(i,MAX_PLAYER_ATTACHED_OBJECTS-1)RemovePlayerAttachedObject(playerid, i);
	    else
	    {
			foreach(new idx:att[playerid])
				{
					UpdatePlayerAttachedObjectEx(playerid,idx,att[playerid][idx][att_modelid],att[playerid][idx][att_boneid],att[playerid][idx][att_fOffsetX],
							 att[playerid][idx][att_fOffsetY],att[playerid][idx][att_fOffsetZ],att[playerid][idx][att_fRotX],att[playerid][idx][att_fRotY],att[playerid][idx][att_fRotZ],
							 att[playerid][idx][att_fScaleX],att[playerid][idx][att_fScaleY],att[playerid][idx][att_fScaleZ],att[playerid][idx][att_materialcolor1],att[playerid][idx][att_materialcolor2],att[playerid][idx][att_iscol],att[playerid][idx][att_jcoltime],att[playerid][idx][att_ismater]);
				}
	    }
	}
	if(DPInfo[aid][dp_wprotect])
	{
	    if(type)ResetPlayerWeapons(playerid);
	    else  GvieGun(playerid);

	}
	if(DPInfo[aid][dp_cprotect])
	{
	    if(type)RemovePlayerFromVehicle(playerid);
	}
	return 1;
}
public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(IsPlayerNPC(playerid))return 1;
    if(!AvailablePlayer(playerid))return 1;
    if(areaid==ffdtarea)return 1;
    if(areaid==JYarea)return 1;
	if(playdp[playerid]!=areaid)
	{
	    foreach(new i:DPInfo)
		{
			if(areaid==DPInfo[i][dp_area])
			{
			    if(DPInfo[i][dp_uid]==PU[playerid])
			    {
		    		new Astr[1024],tm[128];
					format(tm,sizeof(tm),"你进入了你的地盘[ID:%i]",i);
			        SM(COLOR_TWAQUA,tm);
					if(DPInfo[i][dp_ismusic])format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[开启] ",i,DPInfo[i][dp_name]);
					else format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[关闭] ",i,DPInfo[i][dp_name]);
					strcat(Astr,tm);
					if(DPInfo[i][dp_jprotect])format(tm,sizeof(tm),"家具保护[开启] ");
					else format(tm,sizeof(tm),"家具保护[关闭] ");
					strcat(Astr,tm);
					if(DPInfo[i][dp_zprotect])format(tm,sizeof(tm),"装扮保护[开启] ");
					else format(tm,sizeof(tm),"装扮保护[关闭] ");
					strcat(Astr,tm);
					if(DPInfo[i][dp_wprotect])format(tm,sizeof(tm),"武器保护[开启] ");
					else format(tm,sizeof(tm),"武器保护[关闭] ");
					strcat(Astr,tm);
					if(DPInfo[i][dp_cprotect])format(tm,sizeof(tm),"载具保护[开启] ");
					else format(tm,sizeof(tm),"载具保护[关闭] ");
					strcat(Astr,tm);
					SM(COLOR_TWAQUA,Astr);
			        if(DPInfo[i][dp_ismusic]&&!IsServerMusic())PlayAudioStreamForPlayer(playerid,DPInfo[i][dp_musicstr]);
                    return 1;
			    }
			    else
			    {
			    	if(GetfriendshareDP(DPInfo[i][dp_uid],PU[playerid],i))
			    	{
			    		new Astr[1024],tm[128];
						format(tm,sizeof(tm),"你进入你的好友%s共享的地盘[ID:%i]%s",UID[DPInfo[i][dp_uid]][u_name],i,DPInfo[i][dp_name]);
						SM(COLOR_GAINSBORO,tm);
						if(DPInfo[i][dp_ismusic])format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[开启] ",i,DPInfo[i][dp_name]);
						else format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[关闭] ",i,DPInfo[i][dp_name]);
						strcat(Astr,tm);
						if(DPInfo[i][dp_jprotect])format(tm,sizeof(tm),"家具保护[开启] ");
						else format(tm,sizeof(tm),"家具保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_zprotect])format(tm,sizeof(tm),"装扮保护[开启] ");
						else format(tm,sizeof(tm),"装扮保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_wprotect])format(tm,sizeof(tm),"武器保护[开启] ");
						else format(tm,sizeof(tm),"武器保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_cprotect])format(tm,sizeof(tm),"载具保护[开启] ");
						else format(tm,sizeof(tm),"载具保护[关闭] ");
						strcat(Astr,tm);
						SM(COLOR_TWAQUA,Astr);
						if(DPInfo[i][dp_ismusic]&&!IsServerMusic())PlayAudioStreamForPlayer(playerid,DPInfo[i][dp_musicstr]);
						return 1;
			    	}
			        if(DPInfo[i][dp_isopen])
			        {
			            SetPVarInt(playerid,"areaid",i);
			    		new Astr[1024],tm[128];
						format(tm,sizeof(tm),"地盘[ID:%i]%s 主人:%s",i,DPInfo[i][dp_name],UID[DPInfo[i][dp_uid]][u_name]);
			        	Dialog_Show(playerid,dl_dpjrmm,DIALOG_STYLE_INPUT,"地盘密码","请输入密码","确定", "取消");
						format(tm,sizeof(tm),"你进入%s的地盘[ID:%i]%s",UID[DPInfo[i][dp_uid]][u_name],i,DPInfo[i][dp_name]);
						SM(COLOR_GAINSBORO,tm);
						if(DPInfo[i][dp_ismusic])format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[开启] ",i,DPInfo[i][dp_name]);
						else format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[关闭] ",i,DPInfo[i][dp_name]);
						strcat(Astr,tm);
						if(DPInfo[i][dp_jprotect])format(tm,sizeof(tm),"家具保护[开启] ");
						else format(tm,sizeof(tm),"家具保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_zprotect])format(tm,sizeof(tm),"装扮保护[开启] ");
						else format(tm,sizeof(tm),"装扮保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_wprotect])format(tm,sizeof(tm),"武器保护[开启] ");
						else format(tm,sizeof(tm),"武器保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_cprotect])format(tm,sizeof(tm),"载具保护[开启] ");
						else format(tm,sizeof(tm),"载具保护[关闭] ");
						strcat(Astr,tm);
						SM(COLOR_TWAQUA,Astr);
						return 1;
			        }
			        else
			        {
			    		new Astr[1024],tm[128];
						format(tm,sizeof(tm),"你进入%s的地盘[ID:%i]%s",UID[DPInfo[i][dp_uid]][u_name],i,DPInfo[i][dp_name]);
						SM(COLOR_GAINSBORO,tm);
						if(DPInfo[i][dp_ismusic])format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[开启] ",i,DPInfo[i][dp_name]);
						else format(tm,sizeof(tm),"地盘[ID:%i]%s 音乐[关闭] ",i,DPInfo[i][dp_name]);
						strcat(Astr,tm);
						if(DPInfo[i][dp_jprotect])format(tm,sizeof(tm),"家具保护[开启] ");
						else format(tm,sizeof(tm),"家具保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_zprotect])format(tm,sizeof(tm),"装扮保护[开启] ");
						else format(tm,sizeof(tm),"装扮保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_wprotect])format(tm,sizeof(tm),"武器保护[开启] ");
						else format(tm,sizeof(tm),"武器保护[关闭] ");
						strcat(Astr,tm);
						if(DPInfo[i][dp_cprotect])format(tm,sizeof(tm),"载具保护[开启] ");
						else format(tm,sizeof(tm),"载具保护[关闭] ");
						strcat(Astr,tm);
						SM(COLOR_TWAQUA,Astr);
						if(DPInfo[i][dp_ismusic]&&!IsServerMusic())PlayAudioStreamForPlayer(playerid,DPInfo[i][dp_musicstr]);
						EnterPArea(playerid,i,1);
						return 1;
					}
			    }
			}
		}
	}
	foreach(new i:DropInfo)
	{
		if(areaid==DropInfo[i][DropGunarea])
        {
            SetPVarInt(playerid,"dropid",i);
        	new tm[80];
			format(tm,sizeof(tm),"发现掉落的武器%s，是否捡起",Daoju[DropInfo[i][DropGundid]][d_name]);
            Dialog_Show(playerid, dl_dropup, DIALOG_STYLE_MSGBOX, "提醒",tm, "捡起", "不捡");
            return 1;
        }
	}
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
		    if(areaid==UID[PU[i]][u_area]&&pstat[i]==BT&&i!=playerid)
		    {
				current_number[playerid]=1;
				new current=-1;
				foreach(new x:Pzb)
				{
			        if(Pzb[x][zb_issell])
			        {
						current_idx[playerid][current_number[playerid]]=x;
				       	current_number[playerid]++;
				       	current++;
			       	}
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"%s的小摊",Gnn(i));
				Dialog_Show(playerid, dl_sellck, DIALOG_STYLE_LIST,tm, Showsellcklist(playerid,P_page[playerid]), "确定", "取消");
	        	return 1;
		    }
	    }
	}
	return 1;
}
Dialog:dl_dropup(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=GetPVarInt(playerid,"dropid");
	    if(WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wpid]!=0)return Dialog_Show(playerid, dl_dropup2, DIALOG_STYLE_MSGBOX, "提醒","你的武器槽已有武器,如要装备此武器,将覆盖原来的武器，是否继续", "继续", "取消");
		WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wdid]=DropInfo[i][DropGundid];
		WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wpid]=WEAPON[DropInfo[i][DropGunweapon]][W_WID];
		WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wmodel]=WEAPON[DropInfo[i][DropGunweapon]][W_MODEL];
		GivePlayerWeapon(playerid,WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wpid],99999999999);
		SaveWeapon(PU[playerid]);
		DestroyDynamicObject(DropInfo[i][DropGunid]);
		DestroyDynamicArea(DropInfo[i][DropGunarea]);
        Itter_Remove(DropInfo,i);
		new Str[128];
		format(Str,sizeof(Str),"%s捡起了一把武器%s装备在身上",Gnn(playerid),Daoju[DropInfo[i][DropGundid]][d_name]);
		AdminWarn(Str);
	    DeletePVar(playerid,"dropid");
	}
	else DeletePVar(playerid,"dropid");
	return 1;
}
Dialog:dl_dropup2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=GetPVarInt(playerid,"dropid");
		WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wdid]=DropInfo[i][DropGundid];
		WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wpid]=WEAPON[DropInfo[i][DropGunweapon]][W_WID];
		WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wmodel]=WEAPON[DropInfo[i][DropGunweapon]][W_MODEL];
		GivePlayerWeapon(playerid,WEAPONUID[PU[playerid]][WEAPON[DropInfo[i][DropGunweapon]][W_SLOT]][wpid],99999999999);
		SaveWeapon(PU[playerid]);
		DestroyDynamicObject(DropInfo[i][DropGunid]);
		DestroyDynamicArea(DropInfo[i][DropGunarea]);
        Itter_Remove(DropInfo,i);
		new Str[128];
		format(Str,sizeof(Str),"%s捡起了一把武器%s装备在身上【覆盖】",Gnn(playerid),Daoju[DropInfo[i][DropGundid]][d_name]);
		AdminWarn(Str);
	    DeletePVar(playerid,"dropid");
	}
	else DeletePVar(playerid,"dropid");
	return 1;
}
Dialog:dl_dpjrmm(playerid, response, listitem, inputtext[])
{
	new i=GetPVarInt(playerid,"areaid");
	if(response)
	{
		new mima[100];
		if(sscanf(inputtext, "s[100]",mima))return Dialog_Show(playerid,dl_dpjrmm,DIALOG_STYLE_INPUT,"地盘密码","请输入密码","确定", "取消");
		if(!strcmpEx(HashPass(mima),DPInfo[i][dp_passward], false))
		{
		    playdp[playerid]=-1;
		    EnterPArea(playerid,i,1);
			return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "密码正确,准许通行", "好的", "");
		}
        else SetPlayerWorldBounds(playerid,20.0, 0.0, 20.0, 0.0);
	}
	else SetPlayerWorldBounds(playerid,20.0, 0.0, 20.0, 0.0);
	playdp[playerid]=i;
	return 1;
}
stock GetDistance2D( Float:x1, Float:y1, Float:x2, Float:y2)
{
    return floatround( floatsqroot( ((x1-x2)*(x1-x2)) + ((y1-y2)*(y1-y2)) ));
}
