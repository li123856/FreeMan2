CMD:wdhy(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:friends[PU[playerid]])
	{
	    if(chackonline(friends[PU[playerid]][i][fr_uid]))
	    {
			current_idx[playerid][current_number[playerid]]=i;
	       	current_number[playerid]++;
       	}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的在线好友-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myfriend,DIALOG_STYLE_LIST,tm, Showmyfriendlist(playerid,P_page[playerid],1), "确定", "取消");
	return 1;
}
CMD:wdlxhy(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:friends[PU[playerid]])
	{
	    if(!chackonline(friends[PU[playerid]][i][fr_uid]))
	    {
			current_idx[playerid][current_number[playerid]]=i;
	       	current_number[playerid]++;
       	}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的离线好友-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid,dl_myfriend,DIALOG_STYLE_LIST,tm, Showmyfriendlist(playerid,P_page[playerid],0), "确定", "取消");
	return 1;
}
stock Showmyfriendlist(playerid,pager,type=0)
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
			format(tmps,100,"[UID:%i]%s\n",friends[PU[playerid]][current_idx[playerid][i]][fr_uid],UID[friends[PU[playerid]][current_idx[playerid][i]][fr_uid]][u_name]);
		}
	    if(i>=current_number[playerid])
		{
		    if(type==1)
			{
			format(tmps,100,"{FF8000}查看离线好友");
		    strcat(tmp,tmps);
			}
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
Dialog:dl_myfriendfsxx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_myfriendfsxx, DIALOG_STYLE_INPUT, "请输入文字", "请输入发送的信息", "确定", "取消");
        new listid=GetPVarInt(playerid,"listIDA");
        if(PlayerSendPlayerLog(playerid,friends[PU[playerid]][listid][fr_uid],inputtext))Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "发送成功", "好的", "");
	}
    return 1;
}
Dialog:dl_myfriendfsjq(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_myfriendfsjq, DIALOG_STYLE_INPUT, "数额错误", "请输入金额", "确定", "取消");
        EnoughMoney(playerid,strval(inputtext));
        new listid=GetPVarInt(playerid,"listIDA");
        if(PlayerSendPlayerLog(playerid,friends[PU[playerid]][listid][fr_uid]," ",strval(inputtext)))
		{
			Moneyhandle(PU[playerid],-strval(inputtext));
			Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "发送成功", "好的", "");
		}
	}
    return 1;
}
Dialog:dl_myfriendfsdjsl(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_myfriendfsdjsl, DIALOG_STYLE_INPUT, "请设置上架个数", "请输入数量", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
	    new djid=GetPVarInt(playerid,"listIDB");
		if(strval(inputtext)>GetBeibaoAmout(playerid,Beibao[playerid][djid][b_did]))return Dialog_Show(playerid, dl_setprobuyamout, DIALOG_STYLE_INPUT, "你没那么多", "请输入数量", "确定", "取消");
	    if(PlayerSendPlayerLog(playerid,friends[PU[playerid]][listid][fr_uid]," ",0,Beibao[playerid][djid][b_did],strval(inputtext)))
		{
			Delbeibao(playerid,Beibao[playerid][djid][b_did],strval(inputtext));
			Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "发送成功", "好的", "");
		}
	}
    return 1;
}
Dialog:dl_myfriendszfs(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
	            Dialog_Show(playerid,dl_myfriendfsxx, DIALOG_STYLE_INPUT, "发送信息", "请输入发送的信息", "确定", "取消");
	        }
	        case 1:
	        {
	            Dialog_Show(playerid,dl_myfriendfsjq, DIALOG_STYLE_INPUT, "发送金钱", "请输入金额", "确定", "取消");
	        }
	        case 2:
	        {
				current_number[playerid]=1;
				new current=-1,idx=0;
				new objid[MAX_PLAYER_BEIBAO],amoute[MAX_PLAYER_BEIBAO][8];
				foreach(new i:Beibao[playerid])
				{
					current_idx[playerid][idx]=i;
					objid[idx]=Daoju[Beibao[playerid][i][b_did]][d_obj];
			        format(amoute[idx],64,"%i",Beibao[playerid][i][b_amout]);
			       	current_number[playerid]++;
			       	current++;
			       	idx++;
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，你的背包里没有东西", "好的", "");
				new amouts=Iter_Count(Beibao[playerid]);
				new tm[100];
				format(tm,100,"~b~My Bag ~r~%i/%i",amouts,MAX_PLAYER_BEIBAO);
				ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_FRIEND_BB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	        }
	        case 3:
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
				if(current_number[playerid]==1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"错误","你还没有制作美食", "额", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_myfriendfsms, DIALOG_STYLE_TABLIST_HEADERS,"请选择要发送的美食", Showmymslist(playerid,P_page[playerid]), "确定", "取消");
	        }
	    }
	}
    return 1;
}
Dialog:dl_myfriendfsms(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_myfriendfsms,DIALOG_STYLE_TABLIST_HEADERS,"请选择要发送的美食",Showmymslist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
		    new frids=GetPVarInt(playerid,"listIDA");
			new listid=current_idx[playerid][page+listitem];
			if(IsMSselling(listid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该美食已上架", "额", "");
			new tm[100];
			format(tm,100,"%s给你发送了[美食]%s,请/wdmsx查看",Gn(playerid),pfood[listid][pfoode_name]);
			if(PlayerSendPlayerLog(playerid,friends[PU[playerid]][frids][fr_uid],tm))
			{
				pfood[listid][pfoode_uid]=friends[PU[playerid]][frids][fr_uid];
				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "发送成功", "好的", "");
			}
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_myfriendfsms,DIALOG_STYLE_TABLIST_HEADERS,"请选择要发送的美食",Showmymslist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
stock Showfrienddplist(playerid,pager)
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
			format(tmps,100,"ID:%i地盘[%s]\n",current_idx[playerid][i],DPInfo[current_idx[playerid][i]][dp_name]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"取消共享");
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
Dialog:dl_frienddp(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_mydp, DIALOG_STYLE_LIST,"选择你需要共享的地盘", Showfrienddplist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    new fids=GetPVarInt(playerid,"listIDA");
			friends[PU[playerid]][fids][fr_dipan]=0;
			friends[PU[playerid]][fids][fr_dipanid]=-1;
			SaveFriend(PU[playerid]);
			Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "共享已取消", "好的", "");
		}
		else
		{
		    new fids=GetPVarInt(playerid,"listIDA");
			new listid=current_idx[playerid][page+listitem];
			friends[PU[playerid]][fids][fr_dipan]=1;
			friends[PU[playerid]][fids][fr_dipanid]=listid;
            SaveFriend(PU[playerid]);
			Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "对方已经可以在你的地盘操作家具了", "好的", "");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_mydp, DIALOG_STYLE_LIST,"选择你需要共享的地盘", Showfrienddplist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_myfriendsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:
	        {
                foreach(new i:friends[PU[playerid]])
				{
				    if(i==listid)
				    {
				        friends[PU[playerid]][i][fr_on]=1;
				        new str[60];
				        format(str,60,"%s的好友",UID[friends[PU[playerid]][i][fr_uid]][u_name]);
						UpdateDynamic3DTextLabelText(friend3D[playerid],colorMenu[UID[friends[PU[playerid]][i][fr_uid]][u_color]],str);
				    }
				    else friends[PU[playerid]][i][fr_on]=0;
				}
				SaveFriend(PU[playerid]);
	        }
	        case 1:Dialog_Show(playerid,dl_myfriendszfs,DIALOG_STYLE_LIST,"好友发送","发送信息\n发送金钱\n发送道具\n发送美食","选择", "取消");
	        case 2:
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
				format(tm,100,"选择你需要共享的地盘",current_number[playerid]-1);
				Dialog_Show(playerid, dl_frienddp, DIALOG_STYLE_LIST,tm, Showfrienddplist(playerid,P_page[playerid]), "选择", "取消");
	        }
	        case 3:
	        {
                new p2=chackonlineEX(friends[PU[playerid]][listid][fr_uid]);
                if(p2==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "对方没有在线,无法传送", "额", "");
				new Float:xyza[4];
				GetPlayerPos(p2,xyza[0],xyza[1],xyza[2]);
				GetPlayerFacingAngle(p2,xyza[3]);
				SetPlayerPosEx(playerid,xyza[0],xyza[1],xyza[2],xyza[3],GetPlayerInterior(p2),GetPlayerVirtualWorld(p2));
	        }
	        case 4:
	        {
	            if(friends[PU[playerid]][listid][fr_on]==1)UpdateDynamic3DTextLabelText(friend3D[playerid],-1," ");
	            if(Iter_Contains(friends[PU[playerid]],listid))Iter_Remove(friends[PU[playerid]],listid);
                SaveFriend(PU[playerid]);
                new p2=chackonlineEX(friends[PU[playerid]][listid][fr_uid]);
                if(p2!=-1)
                {
                    foreach(new i:friends[PU[p2]])
					{
					    if(friends[PU[p2]][i][fr_on]==1)
					    {
							UpdateDynamic3DTextLabelText(friend3D[p2],-1,"");
							break;
						}
					}
                }
				Iter_Remove(friends[friends[PU[playerid]][listid][fr_uid]],listid);
				SaveFriend(friends[PU[playerid]][listid][fr_uid]);
	        }
	    }
	}
	return 1;
}
Dialog:dl_myfriend(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_myfriend, DIALOG_STYLE_LIST,"我的好友", Showmyfriendlist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdlxhy");
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_myfriendsz,DIALOG_STYLE_LIST,"好友设置","设置主显\n发送消息\n共享地盘\n传送到TA\n删除好友","选择", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_myfriend, DIALOG_STYLE_LIST,"我的好友", Showmyfriendlist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Function SaveFriend(pid)
{
	new str3[4128];
    if(fexist(Get_Path(pid,22)))fremove(Get_Path(pid,22));
	new File:NameFile = fopen(Get_Path(pid,22), io_write);
    foreach(new i:friends[pid])
  	{
		format(str3,sizeof(str3),"%s %i %i %i %i\r\n",str3,friends[pid][i][fr_uid],friends[pid][i][fr_on],friends[pid][i][fr_dipan],friends[pid][i][fr_dipanid]);
	}
	fwrite(NameFile,str3);
    fclose(NameFile);
	return 1;
}
stock LoadFriend(pid)
{
	new tm1[100],ids=0;
    if(fexist(Get_Path(pid,22)))
    {
		new File:NameFile = fopen(Get_Path(pid,22), io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<13)
	        	    {
	        			sscanf(tm1, "iiii",friends[pid][ids][fr_uid],friends[pid][ids][fr_on],friends[pid][ids][fr_dipan],friends[pid][ids][fr_dipanid]);
                        Iter_Add(friends[pid],ids);
						ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
