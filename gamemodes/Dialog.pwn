Dialog:dl_login(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (strlenEx(inputtext)>20||strlenEx(inputtext)<2)return Dialog_Show(playerid, dl_register, DIALOG_STYLE_INPUT, "登录", "请输入密码来登录[密码必须大于3个字符，小于20个字符]", "确定", "取消");
		else
		{
            if(!strcmpEx(HashPass(inputtext),UID[PU[playerid]][u_Pass], false))
			{
			    stop Dalaytime[playerid];
				if(!UID[PU[playerid]][u_IsSavePos])
				{
				    SetSpawnInfoEx(playerid, 0,UID[PU[playerid]][u_Skin],spawnX[playerid],spawnY[playerid],spawnZ[playerid],spawnA[playerid],0,0,0,0, 0, 0 );
				}
				else
				{
					SetSpawnInfoEx( playerid,0,UID[PU[playerid]][u_Skin],UID[PU[playerid]][u_LastX],UID[PU[playerid]][u_LastY],UID[PU[playerid]][u_LastZ],UID[PU[playerid]][u_LastA],0,0,0,0, 0, 0 );
					SetPlayerInterior(playerid,UID[PU[playerid]][u_In]);
					SetPlayerVirtualWorld(playerid,UID[PU[playerid]][u_Wl]);
				}
				if(UID[PU[playerid]][u_realtime]!=-1)SetPlayerTime(playerid,UID[PU[playerid]][u_realtime],0);
				if(UID[PU[playerid]][u_weather]!=-1)SetPlayerWeather(playerid,UID[PU[playerid]][u_weather]);
				IsSpawn[playerid]=true;
				UID[PU[playerid]][u_caxin]=Now();
				Saveduid_data(PU[playerid]);
				SpawnPlayer(playerid);
				//GvieGun(playerid);
				SetPlayerColor(playerid,colorMenu[UID[PU[playerid]][u_color]]);
				Loop(x,5)TextDrawShowForPlayer(playerid,Cashback[x]);
				PlayerTextDrawSetString(playerid,Cashmoney[playerid],StrlenCash(UID[PU[playerid]][u_Cash]));
				PlayerTextDrawSetString(playerid,Bankmoney[playerid],StrlenCash(UID[PU[playerid]][u_Cunkuan]));
				PlayerTextDrawSetString(playerid,vmoney[playerid],StrlenV(UID[PU[playerid]][u_wds]));
				PlayerTextDrawShow(playerid,Cashmoney[playerid]);
				PlayerTextDrawShow(playerid,Bankmoney[playerid]);
				PlayerTextDrawShow(playerid,vmoney[playerid]);
			    SL[playerid]=true;
			    StopPlayerCameraRotate(playerid);
				ComeOut(playerid,0);
				defer LoadBag[2000](playerid);
				Hidetab(playerid);
				UpdateGangP3DEx(playerid);
				foreach(new i:friends[PU[playerid]])
				{
				    if(friends[PU[playerid]][i][fr_on]==1)
				    {
				        new str[60];
						format(str,60,"%s的好友",UID[friends[PU[playerid]][i][fr_uid]][u_name]);
						UpdateDynamic3DTextLabelText(friend3D[playerid],colorMenu[UID[friends[PU[playerid]][i][fr_uid]][u_color]],str);
						break;
					}
				}
				SetPlayerScore(playerid,UID[PU[playerid]][u_Score]);
				DisableRemoteVehicleCollisions(playerid,UID[PU[playerid]][u_vcoll]);
				GivePlayerMoney(playerid,999999999);
				if(UID[PU[playerid]][u_mode])UpdateDynamic3DTextLabelText(Mode3D[playerid],-1,"无敌模式");
				SM(COLOR_DARKSEAGREEN, "登录成功!");
			}
			else
			{
			    SM(COLOR_DARKSEAGREEN, "密码错误!");
				DelayKick(playerid);
			}
		}
	}
	else DelayKick(playerid);
	return 1;
}
stock ComeOut(playerid,type)
{
	if(SL[playerid])
	{
		if(PU[playerid]!=-1)
		{
		    if(UID[PU[playerid]][u_reg]==true)
		    {
			    new str[100];
				if(type==0)
				{
					if(UID[PU[playerid]][u_gid]!=-1)
				    {
			            format(str, sizeof(str), "[%s][%s]%s%s[%i]登陆了服务器",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],colorMenuEx[UID[PU[playerid]][u_color]],UID[PU[playerid]][u_name],playerid);
			            SendMessageToAll(colorMenu[GInfo[UID[PU[playerid]][u_gid]][g_color]],str);
				    }
				    else
				    {
				        format(str,100,"%s%s[%i]登陆了服务器",colorMenuEx[UID[PU[playerid]][u_color]],UID[PU[playerid]][u_name],playerid);
				        SendMessageToAll(colorMenu[UID[PU[playerid]][u_color]],str);
				    }
				    SendDeathMessage(INVALID_PLAYER_ID,playerid,200);
					if(ismusictime)
					{
					    if(musictime>0)
					    {
					        if(musicid!=-1)
					        {
								new tmps[512];
		            			format(tmps, sizeof(tmps),""H_MUSICS"服务器目前正在广播音乐[{D96D26}%s{FFFFFF}]",MUSICS[musicid][music_name]);
		            			SendClientMessage(playerid,COLOR_LIGHTGOLDENRODYELLOW,tmps);
					            PlayAudioStreamForPlayer(playerid,MUSICS[musicid][music_str]);
					        }
					    }
					}
			    }
			    else
			    {
					if(UID[PU[playerid]][u_gid]!=-1)
				    {
			            format(str, sizeof(str), "[%s][%s]%s%s[%i]离开了服务器",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],colorMenuEx[UID[PU[playerid]][u_color]],UID[PU[playerid]][u_name],playerid);
			            SendMessageToAll(colorMenu[GInfo[UID[PU[playerid]][u_gid]][g_color]],str);
				    }
				    else
				    {
				        format(str,100,"%s[%i]离开了服务器",UID[PU[playerid]][u_name],playerid);
			       	    SendMessageToAll(colorMenu[UID[PU[playerid]][u_color]],str);
				    }
				    SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
			    }
			    PublicWarn(str,type);
			}
	    }
    }
}
stock UserBb_Gn(playerid)
{
    new string[128];
    format(string,sizeof(string),USER_BAG_FILE,Gnn(playerid));
    return string;
}
timer LoadBag[2000](playerid)
{
    LoadUserBb(playerid);
    LoadPlayerFresh(PU[playerid]);
}
Dialog:dl_register(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (strlenEx(inputtext)>20||strlenEx(inputtext)<2)return Dialog_Show(playerid, dl_register, DIALOG_STYLE_INPUT, "注册", "请输入密码来注册[密码必须大于3个字符，小于20个字符]", "确定", "取消");
		else
		{
		    stop Dalaytime[playerid];
			format(UID[PU[playerid]][u_Pass],129,"%s",HashPass(inputtext));
			format(UID[PU[playerid]][u_name],MAX_PLAYER_NAME,"%s",Gn(playerid));
			UID[PU[playerid]][u_ban]=0;
			UID[PU[playerid]][u_Level]=0;
			UID[PU[playerid]][u_Cash]=0;
			UID[PU[playerid]][u_Score]=0;
			UID[PU[playerid]][u_Kills]=0;
			UID[PU[playerid]][u_Deaths]=0;
			UID[PU[playerid]][u_Armour]=0;
			UID[PU[playerid]][u_Health]=0;
			UID[PU[playerid]][u_Wanted]=0;
			UID[PU[playerid]][u_JYTime]=0;
			UID[PU[playerid]][u_IsSavePos]=0;
			UID[PU[playerid]][u_LastX]=0;
			UID[PU[playerid]][u_LastY]=0;
			UID[PU[playerid]][u_LastZ]=0;
			UID[PU[playerid]][u_LastA]=0;
			UID[PU[playerid]][u_In]=0;
			UID[PU[playerid]][u_Wl]=0;
			UID[PU[playerid]][u_Admin]=0;
			UID[PU[playerid]][u_gid]=-1;
			UID[PU[playerid]][u_glv]=0;
			UID[PU[playerid]][u_color]=0;
			UID[PU[playerid]][u_speed]=1;
			UID[PU[playerid]][u_hrs]=1;
			UID[PU[playerid]][u_wds]=0;
			UID[PU[playerid]][u_realtime]=-1;
			UID[PU[playerid]][u_weather]=-1;
			UID[PU[playerid]][u_caxin]=Now();
 			Saveduid_data(PU[playerid]);
			SL[playerid]=true;
			StopPlayerCameraRotate(playerid);
			ResetPlayerMoney(playerid);
			SetPlayerColor(playerid,colorMenu[UID[PU[playerid]][u_color]]);
			Loop(x,5)TextDrawShowForPlayer(playerid,Cashback[x]);
			PlayerTextDrawSetString(playerid,Cashmoney[playerid],StrlenCash(UID[PU[playerid]][u_Cash]));
			PlayerTextDrawSetString(playerid,Bankmoney[playerid],StrlenCash(UID[PU[playerid]][u_Cunkuan]));
			PlayerTextDrawSetString(playerid,vmoney[playerid],StrlenV(UID[PU[playerid]][u_wds]));
			PlayerTextDrawShow(playerid,Cashmoney[playerid]);
			PlayerTextDrawShow(playerid,Bankmoney[playerid]);
			PlayerTextDrawShow(playerid,vmoney[playerid]);
			new str[100];
			format(str,100,"%s[%i]注册并登陆了服务器,第%i位玩家",Gnn(playerid),playerid,PU[playerid]+1);
			SendMessageToAll(COLOR_YELLOWGREEN,str);
			SetSpawnInfoEx(playerid, 0,UID[PU[playerid]][u_Skin],spawnX[playerid],spawnY[playerid],spawnZ[playerid],spawnA[playerid],0,0,0,0, 0, 0 );
			SpawnPlayer(playerid);
			Hidetab(playerid);
			ComeOut(playerid,0);
			IsSpawn[playerid]=true;
			UID[PU[playerid]][u_reg]=true;
			AddPlayerLog(PU[playerid],"系统","欢迎注册本服务器,在此送个你一些游戏币及道具",5000);
		}
	}
	else DelayKick(playerid);
	return 1;
}
Dialog:dl_maketele(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(UID[PU[playerid]][u_Score]<200)return SM(COLOR_TWTAN,"你的积分不足200,无法创建传送");
		if(!EnoughMoneyEx(playerid,CM_TELES))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $500000", "好的", "");
		new i=Iter_Free(Tinfo);
		if(i==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "全服传送数量已达到上限", "好的", "");
		new tname[128],tcmd[100];
        if(sscanf(inputtext, "s[128]s[100]",tname,tcmd))return Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "创建传送", "请输入传送的名称和指令\n请注意不要输入重复的系统指令，否则该指令无效\n用空格分隔 例如\n雷达站 LDZ", "创建", "取消");
		if(strlenEx(tname)<2)return Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "创建传送", "请输入传送的名称和指令\n请注意不要输入重复的系统指令，否则该指令无效\n用空格分隔 例如\n雷达站 LDZ", "创建", "取消");
		if(strlenEx(tcmd)<2)return Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "创建传送", "请输入传送的名称和指令\n请注意不要输入重复的系统指令，否则该指令无效\n用空格分隔 例如\n雷达站 LDZ", "创建", "取消");
		ReStr(tname);
		ReStr(tcmd);
		format(Tinfo[i][Tcreater],MAX_PLAYER_NAME,Gnn(playerid));
		new date[3],tstr[100];
	    getdate(date[0],date[1],date[2]);
		format(tstr, sizeof(tstr), "%d/%d/%d",date[0],date[1],date[2]);
		format(Tinfo[i][Tcreatime],128,tstr);
		format(Tinfo[i][Tname],128,tname);
		format(Tinfo[i][Tcmd],100,tcmd);
		GetPlayerPos(playerid,Tinfo[i][Tcurrent_X],Tinfo[i][Tcurrent_Y],Tinfo[i][Tcurrent_Z]);
		GetPlayerFacingAngle(playerid,Tinfo[i][Tcurrent_A]);
	    Tinfo[i][Tcurrent_In]=GetPlayerInterior(playerid);
	    Tinfo[i][Tcurrent_Wl]=GetPlayerVirtualWorld(playerid);
	    Tinfo[i][Tmoney]=0;
	    Tinfo[i][Trate]=0;
	    Tinfo[i][Tmoneybox]=0;
	    Tinfo[i][Tid]=i;
	 	Tinfo[i][Tuid]=PU[playerid];
		Tinfo[i][Tpublic]=1;
		Tinfo[i][Tcolor]=0;
		Iter_Add(Tinfo,i);
		Savedtel_data(i);
		Moneyhandle(PU[playerid],-CM_TELES);
		new tmp[738],Stru[64];
		Loop(x,sizeof(colorMenu)-SCOLOR)
		{
			format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
			strcat(tmp,Stru);
		}
		Dialog_Show(playerid,dl_telecolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
		SetPVarInt(playerid,"listIDA",i);
	}
	return 1;
}
Dialog:dl_telecolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    Tinfo[listid][Tcolor]=listitem;
	    Savedtel_data(listid);
		Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
	}
}
Dialog:dl_teles(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_teles,DIALOG_STYLE_TABLIST_HEADERS,"传送列表/LLCS",Showtelelist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			if(Tinfo[listid][Tuid]==PU[playerid])return CmdTeleportPlayer(playerid,Tinfo[listid][Tcolor],Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z],Tinfo[listid][Tcurrent_A],Tinfo[listid][Tcurrent_In],Tinfo[listid][Tcurrent_Wl],Tinfo[listid][Tname],Tinfo[listid][Tcmd],Tinfo[listid][Trate],Tinfo[listid][Tcreater]);
			if(Tinfo[listid][Tmoney]>0)
			{
			    SetPVarInt(playerid,"listIDA",listid);
			    new str[100];
			    format(str, sizeof(str),"%s需要花费$%i,确定要使用?",Tinfo[listid][Tname],Tinfo[listid][Tmoney]);
			    Dialog_Show(playerid, dl_cscostmoney, DIALOG_STYLE_MSGBOX, "提醒",str, "使用", "不了");
			    return 1;
			}
           	Tinfo[listid][Trate]++;
			CmdTeleportPlayer(playerid,Tinfo[listid][Tcolor],Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z],Tinfo[listid][Tcurrent_A],Tinfo[listid][Tcurrent_In],Tinfo[listid][Tcurrent_Wl],Tinfo[listid][Tname],Tinfo[listid][Tcmd],Tinfo[listid][Trate],Tinfo[listid][Tcreater]);
           	Savedtel_data(listid);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_teles,DIALOG_STYLE_TABLIST_HEADERS,"传送列表/LLCS",Showtelelist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_cscostmoney(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		if(UID[PU[playerid]][u_Cash]<Tinfo[listid][Tmoney])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "你的钱不够使用传送哦", "好的", "");
        Moneyhandle(PU[playerid],-Tinfo[listid][Tmoney]);
        Tinfo[listid][Trate]++;
		CmdTeleportPlayer(playerid,Tinfo[listid][Tcolor],Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z],Tinfo[listid][Tcurrent_A],Tinfo[listid][Tcurrent_In],Tinfo[listid][Tcurrent_Wl],Tinfo[listid][Tname],Tinfo[listid][Tcmd],Tinfo[listid][Trate],Tinfo[listid][Tcreater]);
	    Tinfo[listid][Tmoneybox]+=Tinfo[listid][Tmoney];
        Savedtel_data(listid);
	}
	return 1;
}
Dialog:dl_myteles(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_myteles,DIALOG_STYLE_LIST,"我的传送/WDCS",Showmytelelist(playerid,P_page[playerid]),"确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(IsPlayerInDynamicArea(playerid,ffdtarea))return SM(COLOR_TWTAN,"不能在家具市场创建传送");
		    if(UID[PU[playerid]][u_Score]<300)return SM(COLOR_TWTAN,"你的积分不足300,无法创建传送");
			new i=Iter_Free(Tinfo);
			if(i==-1)return SM(COLOR_TWAQUA,"全服传送数量已达到上限");
			Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "创建传送", "请输入传送的名称和指令\n请注意不要输入重复的系统指令，否则该指令无效\n用空格分隔 例如\n雷达站 LDZ", "创建", "取消");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid,dl_myteles,DIALOG_STYLE_LIST,"我的传送/WDCS",Showmytelelist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
mytelessz_Dialog_Show(teleid)
{
	new tm2[100],tm3[1024];
	format(tm2,100,"取出收益-现:$%i\n",Tinfo[teleid][Tmoneybox]);
	strcat(tm3,tm2);
	format(tm2,100,"修改名称-现:%s\n",Tinfo[teleid][Tname]);
	strcat(tm3,tm2);
	format(tm2,100,"修改指令-现:%s\n",Tinfo[teleid][Tcmd]);
	strcat(tm3,tm2);
	format(tm2,100,"修改收费-现:$%i\n",Tinfo[teleid][Tmoney]);
	strcat(tm3,tm2);
	if(Tinfo[teleid][Tpublic]==1)format(tm2,100,"是否公开-现:是\n");
	else format(tm2,100,"是否公开-现:否\n");
	strcat(tm3,tm2);
	format(tm2,100,"更换颜色\n");
	strcat(tm3,tm2);
	strcat(tm3,"修改定位\n删除传送");
	return tm3;
}
Dialog:dl_mytelessz_sy(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_mytelessz_sy,DIALOG_STYLE_INPUT,"取出收益","数值必须大于0","确定", "取消");
		if(strval(inputtext)>Tinfo[listid][Tmoneybox])return Dialog_Show(playerid,dl_mytelessz_sy,DIALOG_STYLE_INPUT,"取出收益","没有那么多收益","确定", "取消");
        Tinfo[listid][Tmoneybox]-=strval(inputtext);
        Moneyhandle(PU[playerid],strval(inputtext));
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"收益已取出\n当前传送剩余收益%i",Tinfo[listid][Tmoneybox]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
	return 1;
}
Dialog:dl_mytelessz_mc(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
        if(!EnoughMoneyEx(playerid,CM_TELESNAME))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $10000", "好的", "");
        Moneyhandle(PU[playerid],-CM_TELESNAME);
		ReColor(inputtext);
		if(strlenEx(inputtext)<1)return Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"更改名称","字符过少,请输入新的名称","确定", "取消");
		format(Tinfo[listid][Tname],128,inputtext);
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"传送名称已改为%s",Tinfo[listid][Tname]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
	return 1;
}
Dialog:dl_mytelessz_zl(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
        if(!EnoughMoneyEx(playerid,CM_TELESCMD))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $10000", "好的", "");
        Moneyhandle(PU[playerid],-CM_TELESCMD);
		ReColor(inputtext);
		if(strlenEx(inputtext)<2)return Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"更改指令","字符过少,请输入新的名称","确定", "取消");
		if(FindSameTeleCmd(inputtext))return Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"更改指令","指令已存在,请输入新的名称","确定", "取消");
		format(Tinfo[listid][Tcmd],100,inputtext);
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"传送指令已改为/%s",Tinfo[listid][Tcmd]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
	return 1;
}
Dialog:dl_mytelessz_sf(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_mytelessz_sf,DIALOG_STYLE_INPUT,"更改收费","数值错误,请输入新的收费额","确定", "取消");
		if(strval(inputtext)>MAX_TELE_COST_MONEY)return Dialog_Show(playerid,dl_mytelessz_sf,DIALOG_STYLE_INPUT,"更改收费","数值不能大于50W,请输入新的收费额","确定", "取消");
		Tinfo[listid][Tmoney]=strval(inputtext);
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"传送收费已改为$%i",Tinfo[listid][Tmoney]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
	return 1;
}
Dialog:dl_mytelessz_gk(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"传送设置",mytelessz_Dialog_Show(listid),"选择", "取消");
	return 1;
}
Isowner(playerid,idx)
{
	if(idx==PU[playerid])return true;
	else
	{
		DeletePVar(playerid,"listIDA");
	}
	return false;
}
Dialog:dl_mytelessz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	   new listid=GetPVarInt(playerid,"listIDA");
	   switch(listitem)
	   {
		   	case 0:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
		   	    new tm[100];
				format(tm,100,"当前:$%i\n请输入取出的数额",Tinfo[listid][Tmoneybox]);
		   	    Dialog_Show(playerid,dl_mytelessz_sy,DIALOG_STYLE_INPUT,"取出收益",tm,"确定", "取消");
		   	}
		   	case 1:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
		   	    Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"更改名称","请输入新的名称","确定", "取消");
		   	}
		   	case 2:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
				Dialog_Show(playerid,dl_mytelessz_zl,DIALOG_STYLE_INPUT,"更改指令","请输入新的指令","确定", "取消");
		   	}
		   	case 3:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
				Dialog_Show(playerid,dl_mytelessz_sf,DIALOG_STYLE_INPUT,"更改收费","请输入新的收费额","确定", "取消");
		   	}
		   	case 4:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
				if(Tinfo[listid][Tpublic]==1)Tinfo[listid][Tpublic]=0;
				else Tinfo[listid][Tpublic]=1;
	        	new tm[100];
				if(Tinfo[listid][Tpublic]==1)format(tm,100,"修改成功,当前状态:公开");
				else format(tm,100,"修改成功,当前状态:不公开");
				Dialog_Show(playerid,dl_mytelessz_gk,DIALOG_STYLE_MSGBOX,"更改公开状态",tm,"确定", "取消");
		   	}
		   	case 5:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_telecolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
		   	}
		   	case 6:
		   	{
				if(IsPlayerInDynamicArea(playerid,ffdtarea))return SM(COLOR_TWTAN,"不能在家具市场创建传送");
		   	    if(!EnoughMoneyEx(playerid,CM_TELESDINGWEI))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $10000", "好的", "");
        		Moneyhandle(PU[playerid],-CM_TELESDINGWEI);
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
		        GetPlayerPos(playerid,Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z]);
				GetPlayerFacingAngle(playerid,Tinfo[listid][Tcurrent_A]);
				Tinfo[listid][Tcurrent_In]=GetPlayerInterior(playerid);
			    Tinfo[listid][Tcurrent_Wl]=GetPlayerVirtualWorld(playerid);
	        	new tm[100];
				format(tm,100,"定位成功\nX轴:%0.1f,Y轴:%0.1f,Z轴:%0.1f,A轴:%0.1f\n空间:%i   世界:%i",Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z],Tinfo[listid][Tcurrent_A],Tinfo[listid][Tcurrent_In],Tinfo[listid][Tcurrent_Wl]);
				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
	            DeletePVar(playerid,"listIDA");
		   	}
		   	case 7:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "此传送已失效或不属于你了", "好的", "");
	    		if(fexist(Get_Path(listid,2)))
	    		{
	        		new tm[100];
					format(tm,100,"你的传送%s(/%s)删除成功",Tinfo[listid][Tname],Tinfo[listid][Tcmd]);
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
	        		Iter_Remove(Tinfo,listid);
	        		fremove(Get_Path(listid,2));
	    		}
	    		else Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "无法找到传送文件", "好的", "");
		   	}
	   }
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
stock Showtelelist(playerid,pager)
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
	format(tmp,4128, "传送名\t费用\t指令\t流量\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
        new tmps[256],tm[64];
        if(i<current_number[playerid])
        {
			format(tm,64,"/%s",Tinfo[current_idx[playerid][i]][Tcmd]);
			format(tmps,128,"%s%s\t{FFFF00}$%i\t{FF80C0}%s\t{ff7575}%i次\n",colorMenuEx[Tinfo[current_idx[playerid][i]][Tcolor]],Tinfo[current_idx[playerid][i]][Tname],Tinfo[current_idx[playerid][i]][Tmoney],tm,Tinfo[current_idx[playerid][i]][Trate]);
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
    	strcat(tmp, "\t\t{FF8000}下一页\n");
    }
    return tmp;
}
stock Showmytelelist(playerid,pager)
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
        new tmps[265],tm[64];
        if(i<current_number[playerid])
        {
			format(tm,64,"/%s",Tinfo[current_idx[playerid][i]][Tcmd]);
	        if(Tinfo[current_idx[playerid][i]][Tpublic]==1)
	        {
	        	strcat(tmps,"{808080}-公开");
				format(tmps,128,"%s%s{FF8000}收费:%i{FFFF00}流量:%i{FF80C0}收入:%i{ff7575}(%s)创建时间:%s\n",colorMenuEx[Tinfo[current_idx[playerid][i]][Tcolor]],Tinfo[current_idx[playerid][i]][Tname],Tinfo[current_idx[playerid][i]][Tmoney],Tinfo[current_idx[playerid][i]][Trate],Tinfo[current_idx[playerid][i]][Tmoneybox],tm,Tinfo[current_idx[playerid][i]][Tcreatime]);
			}
			else
			{
			    strcat(tmps,"{808080}-不公开");
				format(tmps,128,"%s%s{FF8000}收费:%i{FFFF00}流量:%i{FF80C0}收入:%i{ff7575}(%s)创建时间:%s\n",colorMenuEx[Tinfo[current_idx[playerid][i]][Tcolor]],Tinfo[current_idx[playerid][i]][Tname],Tinfo[current_idx[playerid][i]][Tmoney],Tinfo[current_idx[playerid][i]][Trate],Tinfo[current_idx[playerid][i]][Tmoneybox],tm,Tinfo[current_idx[playerid][i]][Tcreatime]);

			}
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}添加新的传送");
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
Dialog:dl_adxufei(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
	    if(strval(inputtext)*CM_CGGXF<=0)return Dialog_Show(playerid,dl_adxufei,DIALOG_STYLE_INPUT,"数值错误","广告续费每次$5000","确定", "取消");
        if(!EnoughMoneyEx(playerid,strval(inputtext)*CM_CGGXF))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱", "好的", "");
        Moneyhandle(PU[playerid],-strval(inputtext)*CM_CGGXF);
	    RM[listid][r_last]+=strval(inputtext);
	    SavedRandomMessage(listid);
	    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdgg");
	}
    return 1;
}
Dialog:dl_mggsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:
	        {
	            Dialog_Show(playerid,dl_adxufei,DIALOG_STYLE_INPUT,"续费广告","广告续费每次$2000","确定", "取消");
	        }
	        case 1:
	        {
	            SetPVarInt(playerid,"lisr",listid);
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_ggcolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
	        }
	        case 2:
	        {
                fremove(Get_Path(listid,16));
				Iter_Remove(RM,listid);
				SM(COLOR_TWAQUA,"你删除了广告");
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdgg");
	        }
	    }
	}
    return 1;
}
Dialog:dl_mygg(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_mygg, DIALOG_STYLE_LIST,"我的广告/WDGG", Showmygglist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<300)return SM(COLOR_TWTAN,"你的积分不足300,无法创建广告");
			new i=Iter_Free(RM);
			if(i==-1)return SM(COLOR_TWAQUA,"全服广告数量已达到上限");
			Dialog_Show(playerid,dl_addgg,DIALOG_STYLE_INPUT,"添加广告","广告信息[不少于5个字]","确定", "取消");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mggsz,DIALOG_STYLE_LIST,"广告设置","续费\n颜色\n删除","选择", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_mygg, DIALOG_STYLE_LIST,"我的广告/WDGG", Showmygglist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
stock Showmygglist(playerid,pager)
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
			format(tmps,100,"[ID:%i][次数:%i]%s%s\n",current_idx[playerid][i],RM[current_idx[playerid][i]][r_last],colorMenuEx[RM[current_idx[playerid][i]][r_color]],RM[current_idx[playerid][i]][r_msg]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}添加新的广告语");
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
stock Showmyfontlist(playerid,pager)
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
			format(tmps,100,"ID:%i文字点 -- 点击设置\n",current_idx[playerid][i]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}添加新的文字点");
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
Dialog:dl_makefont(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(!EnoughMoneyEx(playerid,CM_WENZI))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $1000000", "好的", "");
        Moneyhandle(PU[playerid],-CM_WENZI);
		new i=Iter_Free(fonts);
		if(i==-1)return SM(COLOR_TWAQUA,"全服文字点数量已达到上限");
		GetPlayerPos(playerid,fonts[i][f_x],fonts[i][f_y],fonts[i][f_z]);
		format(fonts[i][f_owner],MAX_PLAYER_NAME,Gnn(playerid));
		fonts[i][f_uid]=PU[playerid];
		fonts[i][f_in]=GetPlayerInterior(playerid);
		fonts[i][f_wl]=GetPlayerVirtualWorld(playerid);
		fonts[i][f_LOS]=0;
		fonts[i][f_Dis]=0;
		fonts[i][f_color]=0;
		fonts[i][f_iscol]=0;
		fonts[i][f_coltime]=0;
		fonts[i][f_id]=CreateColor3DTextLabel(Showmyfontline(i),colorMenu[fonts[i][f_color]],fonts[i][f_x],fonts[i][f_y],fonts[i][f_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[i][f_LOS],fonts[i][f_wl],fonts[i][f_in],-1,20.0,fonts[i][f_iscol],fonts[i][f_coltime]);
		Iter_Add(fonts,i);
		Savedfont_data(i);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdwz");
	}
	else CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdwz");
	return 1;
}
Dialog:dl_myfonts(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_myfonts, DIALOG_STYLE_LIST,"我的文字点/WDWZ", Showmyfontlist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<300)return SM(COLOR_TWTAN,"你的积分不足300,无法创建文字点");
			new i=Iter_Free(fonts);
			if(i==-1)return SM(COLOR_TWAQUA,"全服文字点数量已达到上限");
			Dialog_Show(playerid, dl_makefont, DIALOG_STYLE_MSGBOX, "创建文字点", "请确定是否在此处要创建", "创建", "取消");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_myfontssz,DIALOG_STYLE_LIST,"文字点设置","内容\n颜色\n间距\n墙壁\n变色\n迁移\n到达\n删除","选择", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_myfonts, DIALOG_STYLE_LIST,"我的文字点/WDWZ", Showmyfontlist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_myfontssz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	   new listid=GetPVarInt(playerid,"listIDA");
       switch(listitem)
       {
           case 0:
           {
				current_number[playerid]=1;
				foreach(new i:fonts_line[listid])
				{
					current_idx[playerid][current_number[playerid]]=i;
		        	current_number[playerid]++;
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"共计[%i]行",current_number[playerid]-1);
				Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,tm,Showmyfontlinelist(playerid,P_page[playerid]), "确定", "取消");
			}
            case 1:
            {
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_myfontscolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
            }
            case 2:
            {
				new tm[100];
				format(tm,100,"当前间距[%i]，请输入需要更改的间距",fonts[listid][f_Dis]);
				Dialog_Show(playerid, dl_myfontsjianju, DIALOG_STYLE_INPUT,"更改间距",tm, "确定", "取消");
            }
            case 3:
            {
				new tm[100];
				if(fonts[listid][f_LOS]==1)format(tm,100,"当前墙壁[是],请输入 是 或否");
				else format(tm,100,"当前墙壁[否],请输入 是 或否");
				Dialog_Show(playerid, dl_myfontsqiangbi, DIALOG_STYLE_INPUT,"更改墙壁",tm, "确定", "取消");
            }
            case 4:
            {
				new tm[100];
				if(fonts[listid][f_iscol]==0)format(tm,100,"当前变色[是],是否更改");
				else format(tm,100,"当前变色[否],是否更改");
				Dialog_Show(playerid, dl_myfontsbianse, DIALOG_STYLE_MSGBOX,"更改变色",tm, "确定", "取消");
            }
            case 5:
            {
				Dialog_Show(playerid, dl_myfontsqianyi, DIALOG_STYLE_MSGBOX,"更改位置","是否更改坐标到此为止", "确定", "取消");
            }
            case 6:
            {
				Dialog_Show(playerid, dl_myfontsdaoda, DIALOG_STYLE_MSGBOX,"到达文字点","是否到达文字点", "确定", "取消");
            }
            case 7:
            {
				Dialog_Show(playerid, dl_myfontsshanchu, DIALOG_STYLE_MSGBOX,"删除文字点","是否删除文字点", "确定", "取消");
            }
        }
	}
	return 1;
}
Dialog:dl_myfontsshanchu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		DeleteColor3DTextLabel(fonts[listid][f_id]);
    	if(fexist(Get_Path(listid,3)))fremove(Get_Path(listid,3));
    	if(fexist(Get_Path(listid,4)))fremove(Get_Path(listid,4));
        new tm[100];
		format(tm,100,"你的文字点%i删除成功",listid);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
		Iter_Remove(fonts,listid);
		Iter_Clear(fonts_line[listid]);
	}
	return 1;
}
Dialog:dl_myfontsdaoda(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    SetPPos(playerid,fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z]);
	    SetPlayerInterior(playerid,fonts[listid][f_in]);
		SetPlayerVirtualWorld(playerid,fonts[listid][f_wl]);
	}
	return 1;
}
Dialog:dl_myfontsqianyi(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		GetPlayerPos(playerid,fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z]);
		fonts[listid][f_in]=GetPlayerInterior(playerid);
		fonts[listid][f_wl]=GetPlayerVirtualWorld(playerid);
		DeleteColor3DTextLabel(fonts[listid][f_id]);
		fonts[listid][f_id]=CreateColor3DTextLabel(Showmyfontline(listid),colorMenu[fonts[listid][f_color]],fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[listid][f_LOS],fonts[listid][f_wl],fonts[listid][f_in],-1,20.0,fonts[listid][f_iscol],fonts[listid][f_coltime]);
		Savedfont_data(listid);
	}
	return 1;
}
Dialog:dl_myfontsbianse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(fonts[listid][f_iscol]==1)
	    {
			fonts[listid][f_iscol]=0;
			Savedfont_data(listid);
			DeleteColor3DTextLabel(fonts[listid][f_id]);
			fonts[listid][f_id]=CreateColor3DTextLabel(Showmyfontline(listid),colorMenu[fonts[listid][f_color]],fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[listid][f_LOS],fonts[listid][f_wl],fonts[listid][f_in],-1,20.0,fonts[listid][f_iscol],fonts[listid][f_coltime]);
			Savedfont_data(listid);
	    }
	    else
	    {
			fonts[listid][f_iscol]=1;
			fonts[listid][f_coltime]=1;
			DeleteColor3DTextLabel(fonts[listid][f_id]);
			fonts[listid][f_id]=CreateColor3DTextLabel(Showmyfontline(listid),colorMenu[fonts[listid][f_color]],fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[listid][f_LOS],fonts[listid][f_wl],fonts[listid][f_in],-1,20.0,fonts[listid][f_iscol],fonts[listid][f_coltime]);
			Savedfont_data(listid);
			Dialog_Show(playerid, dl_myfontsbiansetime, DIALOG_STYLE_INPUT,"设置变色间隔","请设置几秒内变色[1-500]", "确定", "取消");
	    }
	}
	return 1;
}
Dialog:dl_myfontsbiansetime(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		if(strval(inputtext)<1||strval(inputtext)>500)return Dialog_Show(playerid, dl_myfontsbiansetime, DIALOG_STYLE_INPUT,"设置变色间隔","请设置几秒内变色", "确定", "取消");
		fonts[listid][f_coltime]=strval(inputtext);
		DeleteColor3DTextLabel(fonts[listid][f_id]);
		fonts[listid][f_id]=CreateColor3DTextLabel(Showmyfontline(listid),colorMenu[fonts[listid][f_color]],fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[listid][f_LOS],fonts[listid][f_wl],fonts[listid][f_in],-1,20.0,fonts[listid][f_iscol],fonts[listid][f_coltime]);
		Savedfont_data(listid);
	}
	return 1;
}
Dialog:dl_myfontsqiangbi(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		if(!strcmpEx("是",inputtext, false))fonts[listid][f_Dis]=1;
		else if(!strcmpEx("否",inputtext, false))fonts[listid][f_Dis]=0;
		else Dialog_Show(playerid, dl_myfontsqiangbi, DIALOG_STYLE_INPUT,"更改墙壁","请输入 是 或否", "确定", "取消");
		DeleteColor3DTextLabel(fonts[listid][f_id]);
		fonts[listid][f_id]=CreateColor3DTextLabel(Showmyfontline(listid),colorMenu[fonts[listid][f_color]],fonts[listid][f_x],fonts[listid][f_y],fonts[listid][f_z],20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[listid][f_LOS],fonts[listid][f_wl],fonts[listid][f_in],-1,20.0,fonts[listid][f_iscol],fonts[listid][f_coltime]);
		Savedfont_data(listid);
	}
	return 1;
}
Dialog:dl_myfontsjianju(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");new color;
		if(strval(inputtext)<0||strval(inputtext)>5)return Dialog_Show(playerid, dl_myfontsjianju, DIALOG_STYLE_INPUT,"更改间距","请输入需要更改的间距", "确定", "取消");
	    if(sscanf(inputtext, "i",color))return Dialog_Show(playerid, dl_myfontsjianju, DIALOG_STYLE_INPUT,"更改间距","请输入需要更改的间距", "确定", "取消");
		fonts[listid][f_Dis]=color;
		Savedfont_data(listid);
		UpdateColor3DTextLabelText(fonts[listid][f_id],colorMenu[fonts[listid][f_color]], Showmyfontline(listid));
	}
	return 1;
}
Dialog:dl_myfontscolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		fonts[listid][f_color]=listitem;
		Savedfont_data(listid);
		UpdateColor3DTextLabelText(fonts[listid][f_id],colorMenu[fonts[listid][f_color]], Showmyfontline(listid));
	}
	return 1;
}
Dialog:dl_myfontsline(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"内容", Showmyfontlinelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		   new tm[80];
           format(tm,80,"正在添加第[%i]行",listitem+1);
		   Dialog_Show(playerid,dl_myfontlineadd,DIALOG_STYLE_INPUT,tm,"请输入添加的内容","确定", "取消");
		}
		else
		{
			new linelistid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDB",linelistid);
			new tm[80];
           	format(tm,80,"正在编辑第[%i]行添加",listitem+1);
		   	Dialog_Show(playerid,dl_myfontlineedit,DIALOG_STYLE_INPUT,tm,"请输入编辑的内容","确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
	    {
	        P_page[playerid]--;
            Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"内容", Showmyfontlinelist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_myfontlineedit(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid,dl_myfontlineedit,DIALOG_STYLE_INPUT,"添加内容","字符过长,请重新输入添加的内容","确定", "取消");
	    new listida=GetPVarInt(playerid,"listIDA");
	    new listidb=GetPVarInt(playerid,"listIDB");
	    ReStr(inputtext,1,0);
		format(fonts_line[listida][listidb][fl_str],128,inputtext);
		SaveFontLine(listida);
		UpdateColor3DTextLabelText(fonts[listida][f_id],colorMenu[fonts[listida][f_color]], Showmyfontline(listida));
		current_number[playerid]=1;
		foreach(new i:fonts_line[listida])
		{
			current_idx[playerid][current_number[playerid]]=i;
		    current_number[playerid]++;
		}
		P_page[playerid]=1;
		new tm[100];
		format(tm,100,"共计[%i]行",current_number[playerid]-1);
		Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,tm,Showmyfontlinelist(playerid,P_page[playerid]), "确定", "取消");
	}
	else Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"内容", Showmyfontlinelist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showmyfontline(idx)
{
	new tm2[1500],tmp[100],tms[64];
	foreach(new i:fonts_line[idx])
	{
		format(tmp,100,fonts_line[idx][i][fl_str]);
	    strcat(tm2,strn(tmp,idx));
	}
	format(tms,sizeof(tms),"{C0C0C0}文字点[%i]",idx);
	strcat(tm2,tms);
	return tm2;
}
stock strn(stren[],idx)
{
	new strr[128];
	strcat(strr,stren);
	new i=0;
	while(i<=fonts[idx][f_Dis])
    {
       strcat(strr,"\n");
       i++;
    }
	return strr;
}
Dialog:dl_myfontlineadd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid,dl_myfontlineadd,DIALOG_STYLE_INPUT,"添加内容","字符过长或过短,请重新输入添加的内容","确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
	    ReStr(inputtext,1,0);
	    new i=Iter_Free(fonts_line[listid]);
		if(i==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","该文字内容已到上限", "好的", "");
		format(fonts_line[listid][i][fl_str],128,inputtext);
		Iter_Add(fonts_line[listid],i);
		SaveFontLine(listid);
		UpdateColor3DTextLabelText(fonts[listid][f_id],colorMenu[fonts[listid][f_color]], Showmyfontline(listid));
		current_number[playerid]=1;
		foreach(new x:fonts_line[listid])
		{
			current_idx[playerid][current_number[playerid]]=x;
		    current_number[playerid]++;
		}
		P_page[playerid]=1;
		new tm[100];
		format(tm,100,"共计[%i]行",current_number[playerid]-1);
		Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,tm,Showmyfontlinelist(playerid,P_page[playerid]), "确定", "取消");
	}
	else Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"内容",Showmyfontlinelist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showmyfontlinelist(playerid,pager)
{
	
    new tmp[4128];
	new listid=GetPVarInt(playerid,"listIDA");
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
		if(i<current_number[playerid])format(tmps,100,"%s\n",fonts_line[listid][current_idx[playerid][i]][fl_str]);
	    if(i>=current_number[playerid])
		{
		    strcat(tmp,"{FF8000}添加新的内容");
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
stock RandomEx(max,min)
{
	new n = max - min;
	n = random(n);
	n = n + min;
	return n;
}
/*UsefulHex(hexs)
{
	if(hexs>=35&&hexs<=74000000)return 1;
	return 0;
}*/
ARGB(color_rgba)
{
	new alpha = (color_rgba & 0xff) << 24;
	new rgb = color_rgba >>> 8;
	return alpha | rgb;
}
