stock AdminWarn(Strs[])
{
	new Astr[512],Str[64];
	format(Str, sizeof(Str), "注意:");
	strcat(Astr,Str);
	strcat(Astr,Strs);
	foreach(new i:Player)
	{
		if(GetadminLevel(i)>1)SendClientMessage(i,0xFF0000C8,Astr);
	}
	WriteWarnInLog(Astr,WARN_FILE);
	printf("%s",Astr);
    return 1;
}
stock AntiWarn(Strs[])
{
	new Astr[512],Str[64];
	format(Str, sizeof(Str), "反作弊:");
	strcat(Astr,Str);
	strcat(Astr,Strs);
	foreach(new i:Player)
	{
		if(AvailablePlayer(i))SendClientMessage(i,0xFF0000C8,Astr);
	}
	WriteWarnInLog(Astr,ANTI_FILE);
	printf("%s",Astr);
    return 1;
}
stock PublicWarn(Strs[],type)
{
	new Astr[512],Str[64];
	if(!type)format(Str, sizeof(Str), "[登陆]:");
	else format(Str, sizeof(Str), "[退出]:");
	strcat(Astr,Str);
	strcat(Astr,Strs);
	WriteWarnInLog(Astr,WARN_FILE);
	printf("%s",Astr);
    return 1;
}
stock AnnounceWarn(Strs[])
{
	new Astr[512],Str[64];
	format(Str, sizeof(Str), "公示:");
	strcat(Astr,Str);
	strcat(Astr,Strs);
	foreach(new i:Player)
	{
		if(AvailablePlayer(i))SendClientMessage(i,0xFFFF80C8,Astr);
	}
    return 1;
}
stock chackonline(uid)
{
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	    	if(PU[i]==uid)
	    	{
	        	return 1;
	    	}
	    }
	}
	return 0;
}
stock chackonlineEX(uid)
{
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	        if(PU[i]!=-1)
	        {
		    	if(PU[i]==uid)
		    	{
		    	    return i;
		    	}
	    	}
	    }
	}
	return -1;
}
CMD:lxgl(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	Dialog_Show(playerid, dl_lxgl, DIALOG_STYLE_LIST,"离线管理系统","用户管理\n其他管理", "确定", "取消");
	return 1;
}
CMD:payday(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	LiXi();
	return 1;
}
Dialog:dl_lxgl(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid, dl_lxglyh, DIALOG_STYLE_MSGBOX, "提示","请选择模式", "列表模式", "搜索模式");
	}
	return 1;
}
Dialog:dl_lxglyh(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		current_number[playerid]=1;
		new current=-1;
	  	foreach(new i:UID)
		{
	        current_idx[playerid][current_number[playerid]]=i;
	        current_number[playerid]++;
	        current++;
		}
		if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,世界没有传送", "好的", "");
		P_page[playerid]=1;
		new tm[100];
		format(tm,100,"用户列表管理 /LXGL -共计[%i]",current_number[playerid]-1);
		Dialog_Show(playerid, dl_uids, DIALOG_STYLE_LIST,tm, Showuidlist(playerid,P_page[playerid]), "确定", "取消");
	}
	else
	{
		Dialog_Show(playerid,dl_uidsearch,DIALOG_STYLE_INPUT,"请输入搜索名","最少2个字节","搜索", "取消");
	}
	return 1;
}
#define MAX_iSEARCH_RESULTS    50
enum S_DATA
{
	Results[MAX_iSEARCH_RESULTS]
}
new	Search[MAX_PLAYERS][S_DATA];
Dialog:dl_uidsearch(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strlenEx(inputtext) < 2)return Dialog_Show(playerid,dl_uidsearch,DIALOG_STYLE_INPUT,"请输入搜索名","最少2个字节","搜索", "取消");
		new ridx,result[72],endresults[74*MAX_iSEARCH_RESULTS];
	  	foreach(new oid:UID)
		{
			if(strfindEx(UID[oid][u_name],inputtext,true)!=-1)
			{
				format(result, sizeof result, "\n%s", UID[oid][u_name]);
				strcat(endresults, result, sizeof endresults);
				Search[playerid][Results][ridx] = oid;
				ridx++;
			}
			if(ridx >= MAX_iSEARCH_RESULTS) break;
		}
		if(!ridx)return  Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","没有找到类似玩家", "好的", "");
		Dialog_Show(playerid, dl_uidResults, DIALOG_STYLE_LIST, "搜索结果:", endresults, "编辑", "取消");
	}
	return 1;
}
Dialog:dl_uidResults(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	        new listid=Search[playerid][Results][listitem];
			SetPVarInt(playerid,"listIDA",listid);
			new Str[100];
			format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
			Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
stock Showuidlist(playerid,pager)
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
            if(chackonline(current_idx[playerid][i]))format(tmps,100,"UID:%i - 名字:%s - 状态:在线\n",current_idx[playerid][i],UID[current_idx[playerid][i]][u_name]);
			else format(tmps,100,"UID:%i - 名字:%s - 状态:不在线\n",current_idx[playerid][i],UID[current_idx[playerid][i]][u_name]);
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
    	strcat(tmp, "\t\t\t{FF8000}下一页\n");
    }
    return tmp;
}
Dialog:dl_uids(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_uids, DIALOG_STYLE_LIST,"用户列表管理 /LXGL", Showuidlist(playerid,P_page[playerid]), "确定","上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			new Str[100];
			format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
			Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_uids, DIALOG_STYLE_LIST,"用户列表管理 /LXGL", Showuidlist(playerid,P_page[playerid]), "确定","上一页");
			
		}
	}
	return 1;
}
Dialog:dl_uidedit(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
		new listid=GetPVarInt(playerid,"listIDA");
		if(PU[playerid]==listid)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你无法编辑自己的信息", "好的", "");
	   	if(UID[listid][u_Admin]>=UID[PU[playerid]][u_Admin])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你无法编辑管理等级比你高或等于你的管理员", "好的", "");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		switch(listitem)
		{
			case 0:
			{
				Dialog_Show(playerid,dl_uideditadmin,DIALOG_STYLE_INPUT,"修改管理员等级","请输入管理员等级","确定", "取消");
			}
			case 1:
			{
				Dialog_Show(playerid,dl_uideditskin,DIALOG_STYLE_INPUT,"修改皮肤","请输入皮肤ID","确定", "取消");
			}
			case 2:
			{
				Dialog_Show(playerid,dl_uideditlv,DIALOG_STYLE_INPUT,"修改等级","请输入等级","确定", "取消");
			}
			case 3:
			{
				Dialog_Show(playerid,dl_uideditcash,DIALOG_STYLE_INPUT,"修改金钱","请输入金钱","确定", "取消");
			}
			case 4:
			{
				Dialog_Show(playerid,dl_uideditcunkuan,DIALOG_STYLE_INPUT,"修改存款","请输入存款","确定", "取消");
			}
			case 5:
			{
				Dialog_Show(playerid,dl_uideditwds,DIALOG_STYLE_INPUT,"修改V币","请输入V币","确定", "取消");
			}
			case 6:
			{
				Dialog_Show(playerid,dl_uideditscore,DIALOG_STYLE_INPUT,"修改积分","请输入积分","确定", "取消");
			}
			case 7:
			{
				Dialog_Show(playerid,dl_uideditwanted,DIALOG_STYLE_INPUT,"修改通缉","请输入通缉","确定", "取消");
			}
			case 8:
			{
				Dialog_Show(playerid,dl_uideditruyu,DIALOG_STYLE_INPUT,"修改入狱","请输入入狱","确定", "取消");
			}
			case 9:
			{
				Dialog_Show(playerid,dl_uideditkill,DIALOG_STYLE_INPUT,"修改杀人数","请输入杀人数","确定", "取消");
			}
			case 10:
			{
				Dialog_Show(playerid,dl_uideditdeath,DIALOG_STYLE_INPUT,"修改死亡数","请输入死亡数","确定", "取消");
			}
			case 11:
			{
				Dialog_Show(playerid,dl_uideditarmour,DIALOG_STYLE_INPUT,"修改出生护甲","请输入出生护甲","确定", "取消");
			}
	    	case 12:
	    	{
				Dialog_Show(playerid,dl_uidedithealth,DIALOG_STYLE_INPUT,"修改出生生命","请输入出生生命","确定", "取消");
	    	}
	    	case 13:
	    	{
				Dialog_Show(playerid,dl_uideditin,DIALOG_STYLE_INPUT,"修改出生空间","请输入出生空间","确定", "取消");
	    	}
	    	case 14:
	    	{
				Dialog_Show(playerid,dl_uideditwl,DIALOG_STYLE_INPUT,"修改出生世界","请输入出生世界","确定", "取消");
	    	}
	    	case 15:
	    	{
				Dialog_Show(playerid,dl_uideditban,DIALOG_STYLE_INPUT,"BAN","请输入封锁时间,0为解锁","确定", "取消");
	    	}
	    	case 16:
	    	{
				Dialog_Show(playerid,dl_uidedithyd,DIALOG_STYLE_INPUT,"活跃度","请输入数值","确定", "取消");
	    	}
	   	}
	}
	return 1;
}
Dialog:dl_uideditlv(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditlv,DIALOG_STYLE_INPUT,"修改等级","输入数值错误","确定", "取消");
		UID[listid][u_Level]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditban(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditban,DIALOG_STYLE_INPUT,"BAN","请输入封锁时间[小时],0为解锁","确定", "取消");
		UID[listid][u_ban]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uidedithyd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditban,DIALOG_STYLE_INPUT,"BAN","请输入数值","确定", "取消");
		UID[listid][u_caxin]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditadmin(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)>UID[PU[playerid]][u_Admin])return Dialog_Show(playerid,dl_uideditadmin,DIALOG_STYLE_INPUT,"修改管理员等级","输入的管理员等级不能大于你","确定", "取消");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditadmin,DIALOG_STYLE_INPUT,"修改管理员等级","输入数值错误","确定", "取消");
		UID[listid][u_Admin]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditskin(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditskin,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Skin]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditcash(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditcash,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Cash]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditcunkuan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditcunkuan,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Cunkuan]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditwds(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditwds,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_wds]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditscore(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditscore,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Score]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditwanted(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditwanted,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Wanted]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditruyu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditruyu,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_JYTime]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditkill(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditkill,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Kills]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_uideditdeath(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		if(chackonline(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","此玩家正在游戏中,请使用在线管理", "好的", "");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditdeath,DIALOG_STYLE_INPUT,"修改皮肤","输入的数值错误","确定", "取消");
		UID[listid][u_Deaths]=strval(inputtext);
		Saveduid_data(listid);
		new Str[80];
		format(Str, sizeof(Str), "姓名[%s] - UID[%i] - 信息编辑",UID[listid][u_name],listid);
		Dialog_Show(playerid, dl_uidedit, DIALOG_STYLE_LIST, Str, ShowUidinfo(listid), "确定", "取消");
	}
	return 1;
}
stock ShowUidinfo(listid)
{
	new Astr[1024],Str[80];
	format(Str, sizeof(Str), "管理员[%d级]\n",UID[listid][u_Admin]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "皮肤[%i]\n",UID[listid][u_Skin]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "等级[%i]\n",UID[listid][u_Level]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "金钱[%i]\n",UID[listid][u_Cash]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "存款[%i]\n",UID[listid][u_Cunkuan]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "V币[%i]\n",UID[listid][u_wds]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "积分[%i]\n",UID[listid][u_Score]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "通缉[%i]\n",UID[listid][u_Wanted]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "入狱[%i]\n",UID[listid][u_JYTime]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "杀人数[%i]\n",UID[listid][u_Kills]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "死亡数[%i]\n",UID[listid][u_Deaths]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "护甲[%0.3f]\n",UID[listid][u_Armour]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "生命[%0.3f]\n",UID[listid][u_Health]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "空间[%i]\n",UID[listid][u_In]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "世界[%i]\n",UID[listid][u_Wl]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "BAN[%s]\n",banidlasttime(listid,1));
	strcat(Astr,Str);
	format(Str, sizeof(Str), "活跃度[%i]\n",UID[listid][u_caxin]);
	strcat(Astr,Str);
	Loop(x,13)
	{
	    if(WEAPONUID[listid][x][wpid]!=0)
		{
			format(Str, sizeof(Str), "武器[%s][%i]\n",Daoju[WEAPONUID[listid][x][wdid]][d_name],WEAPONUID[listid][x][wpid]);
		    strcat(Astr,Str);
	    }
	}
	return Astr;
}
stock banidlasttime(listid,type=0)
{
	new str[128];
	new day,hour,mins;
	ConvertTime2(UID[listid][u_ban],day,hour,mins);
	if(type==1)format(str,sizeof(str),"%i天%i小时%i分钟",day,hour,mins);
	else format(str,sizeof(str),"剩余封锁时间:%i天%i小时%i分钟",day,hour,mins);
	return str;
}
stock mutelasttime(listid,type=0)
{
	new str[128];
	new day,hour,mins;
	ConvertTime2(UID[listid][u_Sil],day,hour,mins);
	if(type==1)format(str,sizeof(str),"%i天%i小时%i分钟",day,hour,mins);
	else format(str,sizeof(str),"剩余禁言时间:%i天%i小时%i分钟",day,hour,mins);
	return str;
}
Dialog:dl_uideditbanonline(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new clickedplayerid=GetPVarInt(playerid,"cliclp");
		if(!AvailablePlayer(clickedplayerid)) return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
		if(strval(inputtext)<0)return Dialog_Show(playerid,dl_uideditban,DIALOG_STYLE_INPUT,"BAN","请输入封锁时间[小时],0为解锁","确定", "取消");
		UID[PU[clickedplayerid]][u_ban]=strval(inputtext);
		Saveduid_data(PU[clickedplayerid]);
       	new Str[128];
       	format(Str,sizeof(Str),"管理员%s把%s封禁了",Gnn(playerid),Gnn(clickedplayerid),banidlasttime(PU[clickedplayerid],1));
       	AdminWarn(Str);
       	AnnounceWarn(Str);
	    DelayKick(clickedplayerid);
	}
	return 1;
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    if(!AvailablePlayer(playerid))return SM(COLOR_TWAQUA,"请登录后再试");
    if(!AvailablePlayer(clickedplayerid))return SM(COLOR_TWAQUA,"对方没有登陆游戏");
	if(clickedplayerid==playerid)CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/stats");
	else
	{
	    new str[80];
	    format(str,80,"目标玩家%s",Gnn(clickedplayerid));
	    if(GetadminLevel(playerid)>1&&UID[PU[playerid]][u_Admin]>UID[PU[clickedplayerid]][u_Admin])
		{
			SetPVarInt(playerid,"cliclp",clickedplayerid);
			Dialog_Show(playerid,dl_admingl,DIALOG_STYLE_LIST,str,"拉TA过来\n传送到TA\n查看TA个人信息\n观察TA","确定", "取消");
        }
	    else
	    {
	        SetPVarInt(playerid,"cliclp",clickedplayerid);
	        Dialog_Show(playerid,dl_playergl,DIALOG_STYLE_LIST,str,"发信息给TA\n加TA为好友\n拉TA入伙","确定", "取消");
	    }
	}
	return 1;
}
stock Isfriend(playerid,friendid)
{
	foreach(new i:friends[PU[playerid]])
	{
		if(friends[PU[playerid]][i][fr_uid]==PU[friendid])return 1;
	}
	return 0;
}
Dialog:dl_playergl(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new clickedplayerid=GetPVarInt(playerid,"cliclp");
	    switch(listitem)
	    {
	        case 0:
	        {
	        }
	        case 1:
	        {
	            if(UID[PU[playerid]][u_Score]<100)return SM(COLOR_TWTAN,"你的积分不足100,无法加好友");
	            new tm[100];
				if(!Isfriend(playerid,clickedplayerid))
				{
				    SetPVarInt(clickedplayerid,"jiafriend",playerid);
				    format(tm,100,"%s申请加你为好友，是否允许",Gnn(playerid));
					Dialog_Show(clickedplayerid,dl_jiafriend,DIALOG_STYLE_MSGBOX,"申请加好友",tm, "允许", "NO");
                }
				else
				{
				    SM(COLOR_TWAQUA,"TA已经是你的好友了，请在我的好友里选择");
				    format(tm,100,"目标玩家%s",Gnn(clickedplayerid));
				    Dialog_Show(playerid,dl_playergl,DIALOG_STYLE_LIST,tm,"发信息给TA\n加TA为好友\n拉TA入伙","确定", "取消");
				}
	        }
	        case 2:
	        {
	        }
     	}
	}
	return 1;
}
Dialog:dl_jiafriend(playerid, response, listitem, inputtext[])
{
    new jiafriends=GetPVarInt(playerid,"jiafriend");
	if(response)
	{
		if(!AvailablePlayer(jiafriends))return  Dialog_Show(playerid,dl_msg,DIALOG_STYLE_MSGBOX,"错误","对方已下线", "额", "");
	    new i=Iter_Free(friends[PU[jiafriends]]);
	    new x=Iter_Free(friends[PU[playerid]]);
	    if(i==-1)
	    {
	        Dialog_Show(playerid,dl_msg,DIALOG_STYLE_MSGBOX,"无法加好友","对方好友已到上限", "额", "");
	        Dialog_Show(jiafriends,dl_msg,DIALOG_STYLE_MSGBOX,"无法加好友","你的好友已到上限", "额", "");
	        return 1;
	    }
	    if(x==-1)
	    {
	        Dialog_Show(jiafriends,dl_msg,DIALOG_STYLE_MSGBOX,"无法加好友","对方好友已到上限", "额", "");
	        Dialog_Show(playerid,dl_msg,DIALOG_STYLE_MSGBOX,"无法加好友","你的好友已到上限", "额", "");
	        return 1;
	    }
	    friends[PU[jiafriends]][i][fr_uid]=PU[playerid];
	    friends[PU[jiafriends]][i][fr_on]=0;
	    friends[PU[playerid]][x][fr_dipan]=0;
	    friends[PU[playerid]][x][fr_dipanid]=-1;
	    Iter_Add(friends[PU[jiafriends]],i);
	    SaveFriend(PU[jiafriends]);
	    friends[PU[playerid]][x][fr_uid]=PU[jiafriends];
	    friends[PU[playerid]][x][fr_on]=0;
	    friends[PU[playerid]][x][fr_dipanid]=0;
	    friends[PU[playerid]][x][fr_dipanid]=-1;
	    Iter_Add(friends[PU[playerid]],x);
	    SaveFriend(PU[playerid]);
     	Dialog_Show(jiafriends,dl_msg,DIALOG_STYLE_MSGBOX,"加好友","成功加入", "额", "");
     	Dialog_Show(playerid,dl_msg,DIALOG_STYLE_MSGBOX,"加好友","成功加入", "额", "");
	}
	else
	{
	    Dialog_Show(jiafriends,dl_msg,DIALOG_STYLE_MSGBOX,"加好友","对方不想加你为好友", "额", "");
	}
	return 1;
}
Dialog:dl_admingl(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new clickedplayerid=GetPVarInt(playerid,"cliclp");
	    switch(listitem)
	    {
	        case 0:
	        {
				new str[80];
				format(str,sizeof(str),"let %i",clickedplayerid);
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,str);
	        }
	        case 1:
	        {
				new str[80];
				format(str,sizeof(str),"go %i",clickedplayerid);
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,str);
	        }
	        case 2:
			{
			    Dialog_Show(playerid, dl_stats, DIALOG_STYLE_LIST, "个人信息", ShowPlayerinfo(clickedplayerid), "看完了", "");
			}
	        case 3:
	        {
				new str[80];
				format(str,sizeof(str),"spec %i",clickedplayerid);
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,str);
	        }
	    }
	}
	return 1;
}
CMD:duty(playerid, params[], help)
{
	if(!AvailablePlayer(playerid))return SM(COLOR_TWAQUA, "你没有登陆！无法使用");
	if(UID[PU[playerid]][u_Admin]<1)return SM(COLOR_TWAQUA, "你没有没有足够的权限");
	new Str[100];
	if(ADuty[playerid]==false)
	{
	    ADuty[playerid]=true;
		format(Str, sizeof(Str), "值班管理[%i级] \n 不要攻击",UID[PU[playerid]][u_Admin]);
		RegulateColor3DTextLabel(Admin3D[playerid],1,1);
		UpdateColor3DTextLabelText(Admin3D[playerid],0xFF000099,Str);
	    format(Str,sizeof(Str),"管理员%s[等级:%i]进入值班状态",Gnn(playerid),UID[PU[playerid]][u_Admin]);
	}
	else
    {
	    ADuty[playerid]=false;
	    format(Str, sizeof(Str), "管理员%s[等级:%i]离开值班状态",Gnn(playerid),UID[PU[playerid]][u_Admin]);
		RegulateColor3DTextLabel(Admin3D[playerid],0,1);
		UpdateColor3DTextLabelText(Admin3D[playerid],0xFF000099,"");
    }
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:spec(playerid, params[], help)
{
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/spec 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<1000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能观看管理等级比你高或和你一样的玩家");
	TogglePlayerSpectating(playerid, 1);
	PlayerSpectatePlayer(playerid, pid);
	SetPlayerInterior(playerid,GetPlayerInterior(pid));
	gSpectateID[playerid] = pid;
	gSpectateType[playerid] = ADMIN_SPEC_TYPE_PLAYER;
	return 1;
}
CMD:specoff(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	TogglePlayerSpectating(playerid, 0);
	gSpectateID[playerid] = INVALID_PLAYER_ID;
	gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
	return 1;
}
CMD:makeadmin(playerid, params[], help)
{
	new pid,lvv;
	if(sscanf(params, "ii",pid,lvv))return SM(COLOR_TWAQUA,"用法:/makeadmin 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<4000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<4000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	UID[PU[pid]][u_Admin]=lvv;
	Saveduid_data(PU[pid]);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s的管理等级设置为%i",Gnn(playerid),Gnn(pid),lvv);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:go(playerid, params[], help)
{
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/go 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new Float:xyza[4],Float:ran=randfloat(3);
	GetPlayerPos(pid,xyza[0],xyza[1],xyza[2]);
	GetPlayerFacingAngle(pid,xyza[3]);
	SetPlayerPosEx(playerid,xyza[0]+ran,xyza[1]+ran,xyza[2],xyza[3],GetPlayerInterior(pid),GetPlayerVirtualWorld(pid));
	new Str[128];
	format(Str,sizeof(Str),"管理员%s传送到了%s身边",Gnn(playerid),Gnn(pid));
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:let(playerid, params[], help)
{
	new pid;
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/let 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new Float:xyza[4],Float:ran=randfloat(3);
	GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
	GetPlayerFacingAngle(playerid,xyza[3]);
	SetPlayerPosEx(pid,xyza[0]+ran,xyza[1]+ran,xyza[2],xyza[3],GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s拉到了身边",Gnn(playerid),Gnn(pid));
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:setmoney(playerid, params[], help)
{
	new pid,amout,bstr[80];
	if(sscanf(params, "iis[80]",pid,amout,bstr)) return SM(COLOR_TWAQUA,"用法:/setmoney 玩家ID 数额 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	SetPlayerMoney(pid,amout);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s的钱设置为%i[理由:%s]",Gnn(playerid),Gnn(pid),amout,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:setscore(playerid, params[], help)
{
	new pid,amout,bstr[80];
	if(sscanf(params, "iis[80]",pid,amout,bstr)) return SM(COLOR_TWAQUA,"用法:/setscore 玩家ID 数额 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[pid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	UID[PU[pid]][u_Score]=amout;
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s的积分设置为%i[理由:%s]",Gnn(playerid),Gnn(pid),amout,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:setbankmoney(playerid, params[], help)
{
	new pid,amout,bstr[80];
	if(sscanf(params, "iis[80]",pid,amout,bstr)) return SM(COLOR_TWAQUA,"用法:/setmoney 玩家ID 数额 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	SetPlayerBankMoney(pid,amout);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s的银行存款设置为%i[理由:%s]",Gnn(playerid),Gnn(pid),amout,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:setv(playerid, params[], help)
{
	new pid,amout,bstr[80];
	if(sscanf(params, "iis[80]",pid,amout,bstr)) return SM(COLOR_TWAQUA,"用法:/setmoney 玩家ID 数额 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<4000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<4000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	SetPlayerV(pid,amout);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s的V币设置为%i[理由:%s]",Gnn(playerid),Gnn(pid),amout,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:pai(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/pai 玩家ID 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(pid,x,y,z);
	SetPPos(pid,x,y,z+10);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s拍了%s一下[理由:%s]",Gnn(playerid),Gnn(pid),bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:restbeibao(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/cbeibao 玩家ID 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new Stru[128];
	format(Stru,sizeof(Stru),USER_BAG_FILE,Gnn(playerid));
    fremove(Stru);
    Iter_Clear(Beibao[playerid]);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s清空了%s的背包[理由:%s]",Gnn(playerid),Gnn(pid),bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:deldipan(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/deldipan 地盘ID 理由");
	if(!Iter_Contains(DPInfo,pid))return SM(COLOR_TWAQUA, "地盘不存在");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	Removedipan(pid);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了地盘ID:%i[理由:%s]",Gnn(playerid),pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:delxd(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/delxd 小岛ID 理由");
	if(!Iter_Contains(DPInfo,pid))return SM(COLOR_TWAQUA, "小岛不存在");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	RemoveXd(pid);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了小岛ID:%i[理由:%s]",Gnn(playerid),pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:delcs(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/delcs 传送ID 理由");
	if(!Iter_Contains(Tinfo,pid))return SM(COLOR_TWAQUA, "传送ID不存在");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(fexist(Get_Path(pid,2)))
	{
	    Iter_Remove(Tinfo,pid);
	    fremove(Get_Path(pid,2));
	}
	else Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "无法找到传送文件", "好的", "");
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了传送ID:%i[理由:%s]",Gnn(playerid),pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:delaiche(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/delaiche 爱车ID 理由");
	if(!Iter_Contains(VInfo,CUID[pid]))return SM(COLOR_TWAQUA, "爱车不存在");
	if(CarTypes[pid]!=OwnerVeh)return SM(COLOR_TWAQUA, "这不是爱车");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了爱车ID:%i CID:%i[理由:%s]",Gnn(playerid),CUID[pid],pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
    foreach(new i:AvInfo[CUID[pid]])DestroyDynamicObject(AvInfo[CUID[pid]][i][av_id]);
	DeleteColor3DTextLabel(VInfo[CUID[pid]][v_text]);
	DestroyVehicle(pid);
	if(fexist(Get_Path(CUID[pid],0)))fremove(Get_Path(CUID[pid],0));
	if(fexist(Get_Path(CUID[pid],8)))fremove(Get_Path(CUID[pid],8));
 	Iter_Clear(AvInfo[CUID[pid]]);
 	Iter_Remove(VInfo,CUID[pid]);
	return 1;
}
CMD:delgg(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/delgg 广告ID 理由");
	if(!Iter_Contains(RM,pid))return SM(COLOR_TWAQUA, "广告不存在");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    fremove(Get_Path(pid,16));
	Iter_Remove(RM,pid);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了广告ID:%i[理由:%s]",Gnn(playerid),pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:delwz(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/delwz 文字ID 理由");
	if(!Iter_Contains(fonts,pid))return SM(COLOR_TWAQUA, "文字不存在");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	DeleteColor3DTextLabel(fonts[pid][f_id]);
   	if(fexist(Get_Path(pid,3)))fremove(Get_Path(pid,3));
   	if(fexist(Get_Path(pid,4)))fremove(Get_Path(pid,4));
	Iter_Remove(fonts,pid);
	Iter_Clear(fonts_line[pid]);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了文字点ID:%i[理由:%s]",Gnn(playerid),pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:delgang(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/delgang 帮派ID 理由");
	if(!Iter_Contains(GInfo,pid))return SM(COLOR_TWAQUA, "帮派不存在");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	DeleteColor3DTextLabel(GInfo[pid][g_text]);
	DestroyDynamicPickup(GInfo[pid][g_pick]);
 	foreach(new i:UID)
	{
		if(UID[i][u_gid]!=-1)
		{
			if(UID[i][u_gid]==pid)
		    {
				UID[i][u_gid]=-1;
				UID[i][u_glv]=0;
				Saveduid_data(i);
				new ips=chackonlineEX(i);
				if(ips!=-1)UpdateColor3DTextLabelText(Gang3D[ips],-1,"");
		    }
		}
	}
    Iter_Clear(GlvInfo[pid]);
    Iter_Remove(GInfo,pid);
	if(fexist(Get_Path(pid,9)))fremove(Get_Path(pid,9));
	if(fexist(Get_Path(pid,10)))fremove(Get_Path(pid,10));
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了帮派ID:%i[理由:%s]",Gnn(playerid),pid,bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:kick(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "is[80]",pid,bstr)) return SM(COLOR_TWAQUA,"用法:/kick 玩家ID 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new Str[128];
	format(Str,sizeof(Str),"管理员%s把%s T出了服务器[理由:%s]",Gnn(playerid),Gnn(pid),bstr);
	AdminWarn(Str);
	AnnounceWarn(Str);
	DelayKick(pid);
	return 1;
}
CMD:mute(playerid, params[], help)
{
	new pid,bstr[80],tim;
	if(sscanf(params, "is[80]",pid,tim,bstr)) return SM(COLOR_TWAQUA,"用法:/mute 玩家ID 时间[分钟] 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new Str[128];
    if(tim==0)
	{
		UID[PU[pid]][u_Sil]=0;
		format(Str,sizeof(Str),"管理员%s解除了禁言%s[理由:%s]",Gnn(playerid),Gnn(pid),bstr);
	}
    else
	{
		UID[PU[pid]][u_Sil]=tim;
		format(Str,sizeof(Str),"管理员%s禁言了%s%s[理由:%s]",Gnn(playerid),Gnn(pid),mutelasttime(PU[pid],1),bstr);
	}
	Saveduid_data(PU[pid]);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:setscm(playerid, params[], help)
{
	new pid,tim;
	if(sscanf(params, "ii",pid,tim)) return SM(COLOR_TWAQUA,"用法:/setscamout 食材ID 价格");
	if(pid<0||pid>=sizeof(fresh)) return SM(COLOR_TWAQUA,"无效ID");
    fresh[pid][fresh_sell]=tim;
	Savefresh();
	return 1;
}
CMD:setsca(playerid, params[], help)
{
	new pid,amouts;
	if(sscanf(params, "ii",pid,amouts)) return SM(COLOR_TWAQUA,"用法:/setscamout 食材ID 数量");
	if(pid<0||pid>=sizeof(fresh)) return SM(COLOR_TWAQUA,"无效ID");
    fresh[pid][fresh_amout]=amouts;
	Savefresh();
	return 1;
}
CMD:setscx(playerid, params[], help)
{
	new pid,Float:usefuel;
	if(sscanf(params, "if",pid,usefuel)) return SM(COLOR_TWAQUA,"用法:/setscamout 食材ID 效用");
	if(pid<0||pid>sizeof(fresh)) return SM(COLOR_TWAQUA,"无效ID");
	fresh[pid][fresh_usefuel]=usefuel;
	Savefresh();
	return 1;
}
CMD:ban(playerid, params[], help)
{
	new pid,bstr[80],tim;
	if(sscanf(params, "iis[80]",pid,tim,bstr)) return SM(COLOR_TWAQUA,"用法:/ban 玩家ID 时间[分钟] 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	UID[PU[pid]][u_ban]=tim;
	format(UID[PU[pid]][u_breason],100,bstr);
	Saveduid_data(PU[pid]);
   	new Str[128];
   	format(Str,sizeof(Str),"管理员%s把%s封禁了[理由:%s]",Gnn(playerid),Gnn(pid),banidlasttime(PU[pid],1),bstr);
   	AdminWarn(Str);
   	AnnounceWarn(Str);
    DelayKick(pid);
	return 1;
}
CMD:ckbb(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckbb 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	foreach(new i:Beibao[pid])
	{
	    format(bstr,sizeof(bstr),"ID:%i-物品:%s-数量:%i",i,Daoju[Beibao[pid][i][b_did]][d_name],Beibao[pid][i][b_amout]);
		SM(COLOR_TWAQUA,bstr);
	}
	return 1;
}
CMD:ckfz(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckfz 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:HOUSE)
	{
	    if(HOUSE[i][H_isSEL]!=NONEONE&&HOUSE[i][H_UID]==PU[pid])
	    {
	        format(bstr,sizeof(bstr),"ID:%i-房名:%s-OBJ数量:%i",i,HOUSE[i][H_NAMES],Iter_Count(HOBJ[i]));
	        SM(COLOR_TWAQUA,bstr);
	        current++;
	    }
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有房子");
	return 1;
}
CMD:ckzb(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckfz 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:att[pid])
	{
        format(bstr,sizeof(bstr),"ID:%i-装扮名:%s",i,Daoju[att[pid][i][att_did]][d_name]);
        SM(COLOR_TWAQUA,bstr);
        current++;
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有装扮");
	return 1;
}
CMD:ckcs(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckcs 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:Tinfo)
	{
		if(Tinfo[i][Tuid]==PU[pid])
		{
		    format(bstr,sizeof(bstr),"ID:%i-传送名:%s",i,Tinfo[i][Tname]);
	        SM(COLOR_TWAQUA,bstr);
	        current++;
	    }
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有传送");
	return 1;
}
CMD:ckwz(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckwz 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:fonts)
	{
		if(fonts[i][f_uid]==PU[pid])
		{
		    format(bstr,sizeof(bstr),"ID:%i-行数:%i",i,Iter_Count(fonts_line[i]));
	        SM(COLOR_TWAQUA,bstr);
	        current++;
	    }
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有文字点");
	return 1;
}
CMD:ckac(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckac 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:VInfo)
	{
		if(VInfo[i][v_uid]==PU[pid])
		{
		    format(bstr,sizeof(bstr),"ID:%i-VID:%i-模型:%i 装饰数量:%i",i,VInfo[i][v_cid],VInfo[i][v_model],Iter_Count(AvInfo[i]));
	        SM(COLOR_TWAQUA,bstr);
	        current++;
	    }
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有爱车");
	return 1;
}
CMD:ckdp(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckdp 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:DPInfo)
	{
		if(DPInfo[i][dp_uid]==PU[pid])
		{
		    format(bstr,sizeof(bstr),"ID:%i",i);
	        SM(COLOR_TWAQUA,bstr);
	        current++;
	    }
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有地盘");
	return 1;
}
CMD:ckbp(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckbp 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	if(UID[PU[playerid]][u_gid]==-1)return SM(COLOR_TWAQUA, "他没有帮派");
	foreach(new i:GInfo)
	{
		if(GInfo[i][g_uid]==PU[pid])
		{
		    format(bstr,sizeof(bstr),"ID:%i-帮派名:%s",i,GInfo[i][g_name]);
	        SM(COLOR_TWAQUA,bstr);
	    }
	}
	return 1;
}
CMD:ckgg(playerid, params[], help)
{
	new pid,bstr[80];
	if(sscanf(params, "i",pid)) return SM(COLOR_TWAQUA,"用法:/ckgg 玩家ID");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
	new current=0;
	foreach(new i:RM)
	{
		if(RM[i][r_uid]==PU[pid])
		{
		    format(bstr,sizeof(bstr),"ID:%i-广告语:%s",i,RM[i][r_msg]);
	        SM(COLOR_TWAQUA,bstr);
	        current++;
	    }
	}
	if(!current)return SM(COLOR_TWAQUA,"TA没有广告");
	return 1;
}
CMD:addsy(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new type,amout,Float:inx,Float:iny,Float:inz,Float:ina,intt;
	if(sscanf(params, "iiiffff",type,amout,intt,inx,iny,inz,ina))return SM(COLOR_TWAQUA,"用法:/addsy 类型 价格 内饰ID 内饰X 内饰Y 内饰Z 内饰A");
    new i=Iter_Free(property);
    if(i==-1)return SM(COLOR_TWAQUA,"商业已到上限");
    property[i][pro_type]=type;
    property[i][pro_stat]=NONEONE;
    property[i][pro_value]=amout;
    property[i][pro_iin]=intt;
    property[i][pro_iwl]=i+2000;
    property[i][pro_ix]=inx;
    property[i][pro_iy]=iny;
    property[i][pro_iz]=inz;
    property[i][pro_ia]=ina;
    property[i][pro_entervalue]=0;
    property[i][pro_oin]=GetPlayerInterior(playerid);
    property[i][pro_owl]=GetPlayerVirtualWorld(playerid);
    property[i][pro_icol]=0;
	property[i][pro_cunkuan]=0;
	GetPlayerPos(playerid,property[i][pro_ox],property[i][pro_oy],property[i][pro_oz]);
	GetPlayerFacingAngle(playerid,property[i][pro_oa]);
	property[i][pro_uid]=-1;
	property[i][pro_intid]=-1;
	property[i][pro_open]=0;
	format(property[i][pro_name],100,"未定义");
	Iter_Add(property,i);
	CreateProperty(i);
	Savedpropertydata(i);
	return 1;
}
CMD:delsy(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/delsy 商业ID");
	if(!Iter_Contains(property,pid))return SM(COLOR_TWAQUA,"没有此商业");
	DeleteProperty(pid);
	RemoveProperty(pid);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了商业ID:%i",Gnn(playerid),pid);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:addhouse(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/addhouse 价格");
	SetPVarInt(playerid,"hcash",pid);
    new i=Iter_Free(HOUSE);
    if(i==-1)return SM(COLOR_TWAQUA,"房子已到上限");
	current_number[playerid]=1;
	new current=-1;
  	foreach(new X:INT)
	{
        current_idx[playerid][current_number[playerid]]=X;
        current_number[playerid]++;
        current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_hsetpos, DIALOG_STYLE_MSGBOX, "提醒", "错误,没有内饰列表,是否手动添加", "确定", "取消");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"内饰列表-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_allintlist, DIALOG_STYLE_LIST,tm, Showallintlist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:delhouse(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/delhouse 房子ID");
	if(!Iter_Contains(HOUSE,pid))return SM(COLOR_TWAQUA,"没有此房子");
    foreach(new i:HOBJ[pid])
	{
		DestroyDynamicObject(HOBJ[pid][i][HO_ID]);
	}
	Iter_Clear(HOBJ[pid]);
    fremove(Get_Path(pid,17));
	DelHouse(pid);
    fremove(Get_Path(pid,1));
	Iter_Remove(HOUSE,pid);
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了房产ID:%s",Gnn(playerid),pid);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:addint(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	current_number[playerid]=1;
	foreach(new i:INT)
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"内饰列表-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_intlist, DIALOG_STYLE_LIST,tm, Showintlist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:sethouseout(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/delhouse 房子ID");
	if(!Iter_Contains(HOUSE,pid))return SM(COLOR_TWAQUA,"没有此房子");
	new Float:xyza[4];
	GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
	GetPlayerFacingAngle(playerid,xyza[3]);
	HOUSE[pid][H_oX]=xyza[0];
	HOUSE[pid][H_oY]=xyza[1];
	HOUSE[pid][H_oZ]=xyza[2];
	HOUSE[pid][H_oA]=xyza[3];
	HOUSE[pid][H_oIN]=GetPlayerInterior(playerid);
	HOUSE[pid][H_oWL]=GetPlayerVirtualWorld(playerid);
	DelHouse(pid);
	CreateHouse(pid);
	Savedhousedata(pid);
	return 1;
}
CMD:sethousein(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/delhouse 房子ID");
	if(!Iter_Contains(HOUSE,pid))return SM(COLOR_TWAQUA,"没有此房子");
	new Float:xyza[4];
	GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
	GetPlayerFacingAngle(playerid,xyza[3]);
	HOUSE[pid][H_iX]=xyza[0];
	HOUSE[pid][H_iY]=xyza[1];
	HOUSE[pid][H_iZ]=xyza[2];
	HOUSE[pid][H_iA]=xyza[3];
	HOUSE[pid][H_iIN]=123;
	HOUSE[pid][H_INTIDX]=-1;
	SetPlayerPosEx(playerid,HOUSE[pid][H_iX],HOUSE[pid][H_iY],HOUSE[pid][H_iZ],HOUSE[pid][H_iA],HOUSE[pid][H_iIN],HOUSE[pid][H_iWL],pid,0,0);
	DelHouse(pid);
	CreateHouse(pid);
	Savedhousedata(pid);
	return 1;
}
CMD:rehouse(playerid, params[], help)
{
    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/rehouse 房子ID");
	if(!Iter_Contains(HOUSE,pid))return SM(COLOR_TWAQUA,"没有此房子");
	reloadhobj(pid);
	return 1;
}
CMD:sellhouse(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/sellhouse 房子ID");
	if(!Iter_Contains(HOUSE,pid))return SM(COLOR_TWAQUA,"没有此房子");
	HOUSE[pid][H_UID]=-1;
 	HOUSE[pid][H_isSEL]=NONEONE;
 	DelHouse(pid);
	CreateHouse(pid);
	Savedhousedata(pid);
	SetPlayerPosEx(playerid,HOUSE[pid][H_oX],HOUSE[pid][H_oY],HOUSE[pid][H_oZ],HOUSE[pid][H_oA],HOUSE[pid][H_oIN],HOUSE[pid][H_oWL],pid,0,0);
	return 1;
}
CMD:fxqy(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	SetPlayerSpecialAction(playerid,2);
	return 1;
}
CMD:fxqn(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	SetPlayerSpecialAction(playerid,0);
	return 1;
}
CMD:gopos(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new Float:xyz[3];
	if(sscanf(params, "p<,>fff",xyz[0],xyz[1],xyz[2]))return SM(COLOR_TWAQUA,"用法:/gopos ");
	SetPlayerPosEx(playerid,xyz[0],xyz[1],xyz[2],0.0,0,0);
	return 1;
}
CMD:setweather(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new wid;
	if(sscanf(params, "i",wid))return SM(COLOR_TWAQUA,"用法:/setweather ");
	if(wid<0||wid>sizeof(fine_weather_ids))return SM(COLOR_TWAQUA,"数值错误");
	SetWeather(fine_weather_ids[wid][randomweather_id]);
   	new Str[128];
   	format(Str,128,"管理员%s设置天气为:%s",Gnn(playerid),fine_weather_ids[wid][randomweather_text]);
   	AdminWarn(Str);
   	AnnounceWarn(Str);
	return 1;
}
CMD:reobj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/reobj ID");
	if(!fexist(Get_Path(pid,20)))return SM(COLOR_TWAQUA,"没有此文件");
	if(!Iter_Contains(S_OBJ,pid))
	{
		Iter_Add(S_OBJ,pid);
		reloadobj(pid);
	}
	else reloadobj(pid);
	return 1;
}
CMD:delobj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"用法:/delobj ID");
	if(!fexist(Get_Path(pid,20)))return SM(COLOR_TWAQUA,"没有此文件");
	if(!Iter_Contains(S_OBJ,pid))return SM(COLOR_TWAQUA,"没有此数据");
    foreach(new i:SOBJ[pid])
	{
		if(IsValidDynamicObject(SOBJ[pid][i][SO_ID]))DestroyDynamicObject(SOBJ[pid][i][SO_ID]);
	}
	Iter_Clear(SOBJ[pid]);
	Iter_Remove(S_OBJ,pid);
	fremove(Get_Path(pid,20));
	SM(COLOR_TWAQUA,"删除成功");
	return 1;
}
CMD:matobj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pid,index,modelid,name1[32],name2[32];
	if(sscanf(params, "iiis[32]s[32]",pid,index,modelid,name1,name2))return SM(COLOR_TWAQUA,"用法:/matobj ID");
	if(!fexist(Get_Path(pid,20)))return SM(COLOR_TWAQUA,"没有此文件");
	if(Iter_Contains(S_OBJ,pid))
	{
	    foreach(new i:SOBJ[pid])
		{
			if(IsValidDynamicObject(SOBJ[pid][i][SO_ID]))
			{
				SetDynamicObjectMaterial(SOBJ[pid][i][SO_ID],index,modelid,name1,name2);
			}
		}
	}
	return 1;
}
CMD:addpng(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngname[128],from[128],Float:dis,typ;
	if(sscanf(params, "s[128]s[128]fi",pngname,from,dis,typ)) return SM(COLOR_TWAQUA,"用法:/addpng ");
	new i=Iter_Free(png),Float:xyza[4];
	format(png[i][png_name],128,pngname);
	format(png[i][png_from],128,from);
	GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
	png[i][png_dist]=dis;
	png[i][png_type]=typ;
	png[i][png_sX]=xyza[0];
	png[i][png_sY]=xyza[1];
	png[i][png_sZ]=xyza[2]+2;
	png[i][png_aX]=0.0;
	png[i][png_aY]=0.0;
	png[i][png_aZ]=0.0;
	png[i][png_WL]=GetPlayerVirtualWorld(playerid);
	png[i][png_IN]=GetPlayerInterior(playerid);
	new tmp[256];
	strcat(tmp,"D:\\");
	strcat(tmp,png[i][png_from]);
	png[i][png_id]=CreateDynamicArt(tmp,png[i][png_type],png[i][png_sX],png[i][png_sY],png[i][png_sZ],png[i][png_aX],png[i][png_aY],png[i][png_aZ],png[i][png_WL],png[i][png_IN],-1,png[i][png_dist],0.0);
	Streamer_UpdateEx(playerid,png[i][png_sX],png[i][png_sY],png[i][png_sZ],png[i][png_WL],png[i][png_IN],STREAMER_TYPE_OBJECT);
	format(tmp,256,"%s\nID:%i",png[i][png_name],i);
    png[i][png_3d]=CreateDynamic3DTextLabel(tmp,-1,png[i][png_sX],png[i][png_sY],png[i][png_sZ]-1,png[i][png_dist],INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,png[i][png_WL],png[i][png_IN],-1,png[i][png_dist]);
	printf("%i",png[i][png_id]);
	Iter_Add(png,i);
	SavedPNGdata(i);
	return 1;
}
CMD:gopng(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/gopng ");
	if(!Iter_Contains(png,pngid)) return SM(COLOR_TWAQUA,"不存在");
	SetPPos(playerid,png[pngid][png_sX]+3,png[pngid][png_sY]+3,png[pngid][png_sZ]);
	return 1;
}
CMD:editpng(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/editpng ");
	if(!Iter_Contains(png,pngid)) return SM(COLOR_TWAQUA,"不存在");
	stop Edit[playerid];
	E_dit[playerid][pngid][o_X]=png[pngid][png_sX];
	E_dit[playerid][pngid][o_Y]=png[pngid][png_sY];
	E_dit[playerid][pngid][o_Z]=png[pngid][png_sZ];
	E_dit[playerid][pngid][r_X]=png[pngid][png_aX];
	E_dit[playerid][pngid][r_Y]=png[pngid][png_aY];
	E_dit[playerid][pngid][r_Z]=png[pngid][png_aZ];
	SetPVarInt(playerid,"pngid",pngid);
	pstat[playerid]=EDIT_ATT_MODE;
	DestroyDynamic3DTextLabel(png[pngid][png_3d]);
	Edit[playerid]=repeat Editpng[50](playerid,pngid);
	return 1;
}
CMD:delpng(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/delpng ");
	if(!Iter_Contains(png,pngid)) return SM(COLOR_TWAQUA,"不存在");
	DestroyArt(png[pngid][png_id]);
	DestroyDynamic3DTextLabel(png[pngid][png_3d]);
	new string[100];
    format(string, sizeof(string),Get_Path(pngid,15));
    fremove(string);
	Iter_Remove(png,pngid);
	return 1;
}
stock Reatplayers(jids)
{
    foreach(new i:Player)
	{
		if(AvailablePlayer(i))
		{
			if(pcurrent_jj[i]==jids)pcurrent_jj[i]=-1;
		}
	}
	return 1;
}
CMD:deljj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/deljj ");
	if(!Iter_Contains(JJ,pngid)) return SM(COLOR_TWAQUA,"不存在");
	Reatplayers(pngid);
	DelJJ(pngid);
	DelJJfile(pngid);
	return 1;
}
CMD:restjj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/restjj ");
	if(!Iter_Contains(JJ,pngid)) return SM(COLOR_TWAQUA,"不存在");
	if(!IsValidDynamicObject(JJ[pngid][jid]))CreateJJ(pngid);
	if(!IsValidColor3DTextLabel(JJ[pngid][jtext]))CreateJJtext(pngid);
    JJ[pngid][jused]=false;
    JJ[pngid][jmovestat]=0;
	Reatplayers(pngid);
	return 1;
}
CMD:delyy(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/delyy ID");
	if(!Iter_Contains(MUSICS,pngid)) return SM(COLOR_TWAQUA,"不存在");
	Iter_Remove(MUSICS,pngid);
	fremove(Get_Path(pngid,34));
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了音乐ID:%i",Gnn(playerid),pngid);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:delebuy(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new pngid;
	if(sscanf(params, "i",pngid)) return SM(COLOR_TWAQUA,"用法:/delebuy ");
	if(!Iter_Contains(Ebuy,pngid)) return SM(COLOR_TWAQUA,"不存在");
	Iter_Remove(Ebuy,pngid);
	fremove(Get_Path(pngid,31));
	new Str[128];
	format(Str,sizeof(Str),"管理员%s删除了易购商品ID:%i",Gnn(playerid),pngid);
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:fjj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new Str[128];
	if(!ffdtopen)
	{
		new Float:xyz[2],amoutss;
		if(sscanf(params, "ffi",xyz[0],xyz[1],amoutss))return SM(COLOR_TWAQUA,"用法:/fjj 最小 最大 最多 ");
		if(xyz[1]<=0.0)return SM(COLOR_TWAQUA,"最小不能低于或等于0.0");
		Iter_Clear(fjjdaoju);
		new Float:Radius;
		foreach(new x:Daoju)
		{
		    Radius=GetColSphereRadius(Daoju[x][d_obj]);
		    if(Radius<xyz[1]&&Radius>xyz[0])
		    {
		        new s=Iter_Free(fjjdaoju);
		        fjjdaoju[s][fjj_did]=x;
		        Iter_Add(fjjdaoju,s);
		    }
		}
		format(Str,sizeof(Str),"管理员%s开启了家具发放,共发放%i个,请大家到/JJSC排队领取",Gnn(playerid),amoutss);
		AnnounceWarn(Str);
		foreach(new i:Player)
		{
			if(GetadminLevel(i)<2000)
			{
			    if(IsPlayerInDynamicArea(i,ffdtarea))SetPlayerPosEx(i,317.8049,1553.0446,1100.3053,0.0,0,0);
			}
		}
		ffdtopen=1;
		ffdt[ff_did]=fjjdaoju[Iter_Random(fjjdaoju)][fjj_did];
		ffdt[ff_pick]=CreateDynamicPickup(Daoju[ffdt[ff_did]][d_obj],1,318.1201,1488.4937,1106.2560,0,0);
		ffdt[ff_amout]=1;
		ffdt[ff_max]=amoutss;
		format(Str,sizeof(Str),"累计家具发放:%i个",ffdt[ff_amout]);
		ffdt[ff_3d1]=CreateDynamic3DTextLabel(Str,-1,320.1351,1484.5034,1106.2560,50.0);
		format(Str,sizeof(Str),"家具名:%s",Daoju[ffdt[ff_did]][d_name]);
		ffdt[ff_3d2]=CreateDynamic3DTextLabel(Str,-1,318.2561,1488.9417,1106.3176,50.0);
  	}
	else
	{
		format(Str,sizeof(Str),"管理员%s关闭了家具发放,请大家到自行散去吧",Gnn(playerid));
		AnnounceWarn(Str);
		ffdtopen=0;
		if(IsValidDynamicPickup(ffdt[ff_pick]))DestroyDynamicPickup(ffdt[ff_pick]);
		DestroyDynamic3DTextLabel(ffdt[ff_3d1]);
		DestroyDynamic3DTextLabel(ffdt[ff_3d2]);
	}
	return 1;
}
CMD:sel(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	SelectObject(playerid);
	return 1;
}
CMD:addrace(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	Dialog_Show(playerid, dl_race_c1, DIALOG_STYLE_INPUT, "创建赛道", "请输入比赛名", "确定", "取消");
	return 1;
}
CMD:delrace(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    new map;
	if(sscanf(params, "i",map)) return SM(COLOR_TWAQUA,"用法:/delrace 地图ID");
	if(!Iter_Contains(R_RACE,map)) return SM(COLOR_TWAQUA,"地图不存在");
	foreach(new i:RACE_ROM)
	{
	    if(RACE_ROM[i][RACE_IDX]==map)return  SM(COLOR_TWAQUA,"有比赛正在使用此地图无法删除");
	}
	DestroyDynamicMapIcon(R_RACE[map][RACE_MIC]);
	DestroyDynamicCP(R_RACE[map][RACE_PICK]);
	DeleteColor3DTextLabel(R_RACE[map][RACE_3D]);

	if(fexist(Get_Path(map,14)))fremove(Get_Path(map,14));
	if(fexist(Get_Path(map,12)))fremove(Get_Path(map,12));
	Iter_Clear(P_RACE[map]);
	if(fexist(Get_Path(map,13)))fremove(Get_Path(map,13));
	Iter_Clear(C_RACE[map]);
	if(fexist(Get_Path(map,11)))fremove(Get_Path(map,11));
	Iter_Remove(R_RACE,map);
	SM(COLOR_TWAQUA,"删除成功");
	return 1;
}
CMD:searchdj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	Dialog_Show(playerid,dl_djsearch,DIALOG_STYLE_INPUT,"请输入搜索ID","搜索ID","搜索", "取消");
	return 1;
}
CMD:add(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new i=Iter_Free(fonts);
	if(i==-1)return SM(COLOR_ORANGE,"全服道具数量已达到上限");
	Dialog_Show(playerid, dl_cdj, DIALOG_STYLE_INPUT, "创建道具", "请输入 名称,类型,模型,价格,是否售卖[0/1]", "创建", "取消");
	return 1;
}
CMD:addj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	current_number[playerid]=1;
	foreach(new i:Daoju)
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"世界道具-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_dj, DIALOG_STYLE_LIST,tm, Showdjlist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:dju(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    current_number[playerid]=1;
    new current=-1,idx=0;
	new objid[mS_CUSTOM_MAX_ITEMS],amoute[mS_CUSTOM_MAX_ITEMS][8];
	foreach(new i:Daoju)
	{
	    if(Daoju[i][d_use])
	    {
			current_idx[playerid][idx]=i;
			objid[idx]=Daoju[i][d_obj];
	        format(amoute[idx],16,"$%i",Daoju[i][d_cash]);
	       	current_number[playerid]++;
	       	current++;
	       	idx++;
	    }
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，没有道具存在", "好的", "");
	new amouts=current+1;
	new tm[100];
	format(tm,100,"~y~Dao Ju ~r~%i/%i",amouts,MAX_DAOJU);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_DAOJU_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
CMD:djj(playerid, params[], help)
{
   	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    current_number[playerid]=1;
    new current=-1,idx=0;
	new objid[mS_CUSTOM_MAX_ITEMS],amoute[mS_CUSTOM_MAX_ITEMS][8];
	foreach(new i:Daoju)
	{
	    if(Daoju[i][d_type]==DAOJU_TYPE_JIAJU)
	    {
			current_idx[playerid][idx]=i;
			objid[idx]=Daoju[i][d_obj];
	        format(amoute[idx],16,"$%i",Daoju[i][d_cash]);
	       	current_number[playerid]++;
	       	current++;
	       	idx++;
	    }
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，没有道具存在", "好的", "");
	new amouts=current+1;
	new tm[100];
	format(tm,100,"~y~Dao Ju ~r~%i/%i",amouts,MAX_DAOJU);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_DAOJU_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
CMD:djw(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    current_number[playerid]=1;
    new current=-1,idx=0;
	new objid[mS_CUSTOM_MAX_ITEMS],amoute[mS_CUSTOM_MAX_ITEMS][8];
	foreach(new i:Daoju)
	{
	    if(Daoju[i][d_type]==DAOJU_TYPE_WEAPON)
	    {
			current_idx[playerid][idx]=i;
			objid[idx]=Daoju[i][d_obj];
	        format(amoute[idx],16,"$%i",Daoju[i][d_cash]);
	       	current_number[playerid]++;
	       	current++;
	       	idx++;
       	}
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，没有道具存在", "好的", "");
	new amouts=current+1;
	new tm[100];
	format(tm,100,"~y~Dao Ju ~r~%i/%i",amouts,MAX_DAOJU);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_DAOJU_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
CMD:djc(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    current_number[playerid]=1;
    new current=-1,idx=0;
	new objid[mS_CUSTOM_MAX_ITEMS],amoute[mS_CUSTOM_MAX_ITEMS][8];
	foreach(new i:Daoju)
	{
	    if(Daoju[i][d_type]==DAOJU_TYPE_CAR)
	    {
			current_idx[playerid][idx]=i;
			objid[idx]=Daoju[i][d_obj];
	        format(amoute[idx],16,"$%i",Daoju[i][d_cash]);
	       	current_number[playerid]++;
	       	current++;
	       	idx++;
       	}
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，没有道具存在", "好的", "");
	new amouts=current+1;
	new tm[100];
	format(tm,100,"~y~Dao Ju ~r~%i/%i",amouts,MAX_DAOJU);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_DAOJU_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
CMD:gmx(playerid, params[], help)
{
	if(GetadminLevel(playerid)<4000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new tm[100];
	format(tm,100,"请注意:执行管理员%s命令,服务器即将重启",Gn(playerid));
	SendMessageToAll(0xFFFFFFC8,tm);
	foreach(new i:Player)DelayKick(i);
	defer gmx[2000]();
	return 1;
}
timer gmx[2000]()
{
	SendRconCommand("gmx");
    return 1;
}
CMD:restallcar(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	foreach(new i:VInfo)
	{
	    VInfo[i][v_uid]=-1;
	    VInfo[i][v_issel]=NONEONE;
		DeleteColor3DTextLabel(VInfo[i][v_text]);
   		SetVehicleNumberPlate(i,"00000");
		Createcar3D(i);
        SetPlayerVehSpawn(i);
		Savedveh_data(i);
	}
	return 1;
}
CMD:restallhouse(playerid, params[], help)
{
	if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	foreach(new i:HOUSE)
	{
		HOUSE[i][H_isSEL]=NONEONE;
		HOUSE[i][H_UID]=-1;
		DelHouse(i);
		CreateHouse(i);
		Savedhousedata(i);
	}
	return 1;
}
CMD:music(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	new Str[128];
	if(!ismusictime)
	{
        ismusictime=true;
        musictime=0;
        musicid=-1;
        foreach(new i:Player)if(AvailablePlayer(i))StopAudioStreamForPlayer(i);
	   	format(Str,sizeof(Str),"管理员%s开启了音悦台自由播放",Gnn(playerid));
	   	AdminWarn(Str);
	   	AnnounceWarn(Str);
	}
 	else
 	{
        ismusictime=false;
        musictime=0;
        musicid=-1;
        foreach(new i:Player)if(AvailablePlayer(i))StopAudioStreamForPlayer(i);
	   	format(Str,sizeof(Str),"管理员%s关闭了音悦台自由播放",Gnn(playerid));
	   	AdminWarn(Str);
	   	AnnounceWarn(Str);
 	}
	return 1;
}
CMD:jianjin(playerid, params[], help)
{
	new pid,timesd,bstr[80];
	if(sscanf(params, "iis[80]",pid,timesd,bstr)) return SM(COLOR_TWAQUA,"用法:/jianjin 玩家ID 分钟 理由");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登陆！无法使用");
	if(playerid==pid&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "不能设置你自己");
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	if(UID[PU[playerid]][u_Admin]<=UID[PU[pid]][u_Admin]&&GetadminLevel(playerid)<3000)return SM(COLOR_TWAQUA, "你不能设置管理等级比你高或和你一样的玩家");
    SetPlayerPosEx(pid,-2048.2932,-131.7709,35.2966,346.5033,0,0);
    UID[PU[pid]][u_JYTime]=timesd;
	Saveduid_data(PU[pid]);
   	new Str[128];
   	format(Str,sizeof(Str),"管理员%s把%s监禁了%i分钟[理由:%s]",Gnn(playerid),Gnn(pid),UID[PU[pid]][u_JYTime],bstr);
   	AdminWarn(Str);
   	AnnounceWarn(Str);
	return 1;
}
stock isplayerinveh(vidd)
{
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))
	    {
	        if(IsPlayerInVehicle(i,vidd))return 1;
	    }
	}
	return 0;
}
CMD:shuache(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	foreach(new i:Player)
	{
		if(pbrushcar[i]!=-1)
		{
			if(!IsPlayerInVehicle(i,pbrushcar[i]))
			{
				DeleteColor3DTextLabel(pbrushcartext[pbrushcar[i]]);
				DestroyVehicle(pbrushcar[i]);
				pbrushcar[i]=-1;
			}
		}
	}
	foreach(new i:VInfo)
	{
        if(!isplayerinveh(VInfo[i][v_cid]))if(GetVehicleDistanceFromPoint(VInfo[i][v_cid],VInfo[i][v_x],VInfo[i][v_y],VInfo[i][v_z])>10.0)
		{
			SetVehiclePos(VInfo[i][v_cid],VInfo[i][v_x],VInfo[i][v_y],VInfo[i][v_z]);
			SetVehicleZAngle(VInfo[i][v_cid],VInfo[i][v_a]);
		}
	}
	new Str[128];
	format(Str,sizeof(Str),"管理员%s刷新了所有的汽车",Gnn(playerid));
	AdminWarn(Str);
	AnnounceWarn(Str);
	return 1;
}
CMD:djn(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    current_number[playerid]=1;
    new current=-1,idx=0;
	new objid[mS_CUSTOM_MAX_ITEMS],amoute[mS_CUSTOM_MAX_ITEMS][8];
	foreach(new i:Daoju)
	{
	    if(Daoju[i][d_new]==1)
	    {
			current_idx[playerid][idx]=i;
			objid[idx]=Daoju[i][d_obj];
	        format(amoute[idx],16,"$%i",Daoju[i][d_cash]);
	       	current_number[playerid]++;
	       	current++;
	       	idx++;
       	}
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，没有道具存在", "好的", "");
	new amouts=current+1;
	new tm[100];
	format(tm,100,"~y~Dao Ju ~r~%i/%i",amouts,MAX_DAOJU);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_DAOJU_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}

