stock getplayerhouse(PID)
{
	new amoute=0;
	foreach(new i:HOUSE)if(HOUSE[i][H_isSEL]!=NONEONE&&HOUSE[i][H_UID]==PID)amoute++;
	return amoute;
}
stock ShowPlayerinfo(playerid)
{
	new Astr[1024],Str[80];
	if(UID[PU[playerid]][u_Admin]>0)
	{
		format(Str, sizeof(Str), "管理员[%d级]",UID[PU[playerid]][u_Admin]);
		strcat(Astr,Str);
		if(ADuty[playerid]==true)format(Str, sizeof(Str), " - 状态:值班\n");
		else format(Str, sizeof(Str), " - 状态:未值班\n");
		strcat(Astr,Str);
	}
	format(Str, sizeof(Str), "UID:%i\n",PU[playerid]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "姓名:%s\n",UID[PU[playerid]][u_name]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "时限:%i天\n",30-(Now()-UID[PU[playerid]][u_caxin]));
	strcat(Astr,Str);
	format(Str, sizeof(Str), "皮肤:%i\n",UID[PU[playerid]][u_Skin]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "等级:%i级\n",UID[PU[playerid]][u_Level]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "金钱:$%i\n",UID[PU[playerid]][u_Cash]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "存款:$%i\n",UID[PU[playerid]][u_Cunkuan]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "积分:%i分\n",UID[PU[playerid]][u_Score]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "V币:%i\n",UID[PU[playerid]][u_wds]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "饥饿:%0.2f\n",UID[PU[playerid]][u_hunger]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "通缉:%i次\n",UID[PU[playerid]][u_Wanted]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "入狱%i次\n",UID[PU[playerid]][u_JYTime]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "杀人数%i次\n",UID[PU[playerid]][u_Kills]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "死亡数%i次\n",UID[PU[playerid]][u_Deaths]);
	strcat(Astr,Str);
	if(UID[PU[playerid]][u_gid]!=-1)
	{
		format(Str, sizeof(Str), "帮派:%s 阶级:%s[%i]\n",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],UID[PU[playerid]][u_glv]);
		strcat(Astr,Str);
	}
	foreach(new i:HOUSE)
	{
	    if(HOUSE[i][H_isSEL]!=NONEONE&&HOUSE[i][H_UID]==PU[playerid])
	    {
	        format(Str,sizeof(Str),"房子ID:%i 名:%s OBJ数量:%i\n",i,HOUSE[i][H_NAMES],Iter_Count(HOBJ[i]));
			strcat(Astr,Str);
	    }
	}
	foreach(new i:VInfo)
	{
		if(VInfo[i][v_uid]==PU[playerid])
		{
		    format(Str,sizeof(Str),"爱车ID:%i VID:%i 模型:%i 装饰数量:%i\n",i,VInfo[i][v_cid],VInfo[i][v_model],Iter_Count(AvInfo[i]));
		    strcat(Astr,Str);
		}
	}
	Loop(x,13)
	{
	    if(WEAPONUID[PU[playerid]][x][wpid]!=0)
		{
			format(Str, sizeof(Str), "武器[%s][%i]\n",Daoju[WEAPONUID[PU[playerid]][x][wdid]][d_name],WEAPONUID[PU[playerid]][x][wpid]);
	    	strcat(Astr,Str);
	    }
	}
	return Astr;
}
CMD:inv(playerid, params[], help)
{
	if(UID[PU[playerid]][u_gid]==-1)return SM(COLOR_TWAQUA,"你不是帮派人员");
	if(UID[PU[playerid]][u_glv]<MAX_GROUP_LV-1)return SM(COLOR_TWAQUA,"你没有足够的阶级权限来操作");
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA, "用法: /inv [玩家ID]");
	if(!AvailablePlayer(pid))return SM(COLOR_TWAQUA, "对方没有登录");
	if(UID[PU[pid]][u_gid]!=-1)return SM(COLOR_TWAQUA,"对方已有帮派");
	SetPVarInt(pid,"listIDB",playerid);
	new tm[100];
	format(tm,100,"%s邀请你加入%s",Gnn(playerid),GInfo[UID[PU[playerid]][u_gid]][g_name]);
	Dialog_Show(pid, dl_joinyqbp, DIALOG_STYLE_MSGBOX,"帮派邀请",tm, "同意", "拒绝");
	return 1;
}
CMD:help(playerid, params[], help)
{
	SM(COLOR_LIGHTBLUE,"________________________________________玩家指令________________________________________________\n");
	SM(COLOR_PZL,"/wdac 我的爱车 /dbq 单边桥小游戏 /lkdbq 离开单边桥  /wdzxhy 我的在线好友 /wdlxhy 我的离线好友");
	SM(COLOR_PZL,"/llbp 世界所有帮派 /zb回到帮派总部  /wdbp我的帮派 /wdfz 我的房子  /llfz世界所有房子  /gh 去房子");
	SM(COLOR_PZL,"/kzfz 空置的房子  /wdxx 我的消息盒子 /crace 创建比赛  /llsd世界所有赛道 /join查看加入比赛[图形] ");
	SM(COLOR_PZL,"/wdcs我的传送  /wdwz 我的文字点  /wdgg我的广告  /c刷车 /join1查看加入比赛[对话框] /horse开关动态马");
	SM(COLOR_PZL,"/joinrace加入指定比赛  /startmap创建指定地图的比赛 /wdbb我的背包[图形]  /wdbb1我的背包[对话框]");
	SM(COLOR_PZL,"/wdzb我的装扮  /llsj 世界综合信息 /wdsz 我的设置  /wdys 我的颜色  /wdpf我的皮肤  /wdpd 我的频道");
	SM(COLOR_PZL,"/wdwq我的武器  /wdck 我的仓库  /bt摆摊  /help帮助  /obj开关动态OBJ显示  /llcs世界所有传送 ");
	SM(COLOR_PZL,"/wdzb我的装扮  /llsj 世界综合信息 /wdsz 我的设置  /wdys 我的颜色  /wdpf我的皮肤  /wdpd 我的频道");
	SM(COLOR_PZL,"/njj  附近的家具  /unsavepos取消出生定位  /kgpz开关碰撞  /stats个人信息  /acthelp 动作指令 /inv 邀请入帮");
	SM(COLOR_PZL,"/sendxx发送信息[玩家无法发送附件]  /savepos定位出生坐标  /wdms我的模式  /kill自杀  /speed开关速度表  /cz充值");
	SM(COLOR_LIGHTBLUE,"________________________________________________________________________________________________");
	return 1;
}
CMD:xtcs(playerid, params[], help)return Printxtcs(playerid);
CMD:horse(playerid, params[], help)
{
	if(UID[PU[playerid]][u_hrs])
	{
		UID[PU[playerid]][u_hrs]=0;
		Loop(i,8)PlayerTextDrawHide(playerid,hrs[playerid][i]);
	}
	else
	{
		UID[PU[playerid]][u_hrs]=1;
	}
	Saveduid_data(PU[playerid]);
	return 1;
}
CMD:speed(playerid, params[], help)
{
	if(UID[PU[playerid]][u_speed])
	{
		UID[PU[playerid]][u_speed]=0;
	    TextDrawHideForPlayer(playerid,TDS[0]);
		TextDrawHideForPlayer(playerid,TDS[1]);
	    HidePlayerProgressBar(playerid,speedo[playerid]);
	    HidePlayerProgressBar(playerid,chealth[playerid]);
	    HidePlayerProgressBar(playerid,chigh[playerid]);
		PlayerTextDrawHide(playerid,Speedids[playerid]);
		PlayerTextDrawHide(playerid,Preview[playerid]);
		oldcmodel[playerid]=0;
	}
	else
	{
		UID[PU[playerid]][u_speed]=1;
		if(IsPlayerInAnyVehicle(playerid)&&!GetPlayerVehicleSeat(playerid))
		{
	        TextDrawShowForPlayer(playerid,TDS[0]);
	        TextDrawShowForPlayer(playerid,TDS[1]);
	        ShowPlayerProgressBar(playerid,speedo[playerid]);
	        ShowPlayerProgressBar(playerid,chealth[playerid]);
	        ShowPlayerProgressBar(playerid,chigh[playerid]);
			PlayerTextDrawShow(playerid,Speedids[playerid]);
		}
	}
	Saveduid_data(PU[playerid]);
	return 1;
}
stock Printxtcs(playerid)
{
	SM(COLOR_LIGHTBLUE,"_________________________________系统传送_____________________________________\n");
	SM(COLOR_XCS,"/Jefferson  /aa  /motel  /carlhome  /carlhome2  /bigcarlhome  /Seville  /village  /mfa  /mfahome");
	SM(COLOR_XCS,"/mfadejia  /cc  /ls  /sf  /lv  /lc  /zyc  /café  /chiliad  /drift1  /drift2  /ldz  /bisai  /leap  /lspd");
	SM(COLOR_XCS,"/lsjj  /sfpd  /sfjj  /lvpd  /lvjj  /cs1  /cs2  /cs3  /cs4  /cs5  /cs6  /cs7  /cs  /kyzz  /ddjd  /qnsd  /hdc");
	SM(COLOR_LIGHTBLUE,"____________________________自建传送列表/LLCS_________________________________");
	return 1;
}
CMD:acthelp(playerid, params[], help)return Printacthelp(playerid);
stock Printacthelp(playerid)
{
	SM(COLOR_LIGHTBLUE,"________________________________动作指令________________________________________\n");
	SM(COLOR_ACT,"/handsup [投降]  /drunk [醉酒] /bomb [装炸弹] /arrest [抓犯人] /laugh [笑] /lookout [眺望]");
	SM(COLOR_ACT,"/rob [挑衅] /winkin [sex] /winout [sex] /coparrest[逮捕犯人] /arrested [拿枪指对方]");
	SM(COLOR_ACT,"/injured [受伤了] /slapped [向右看] /fsmoking [靠在一旁，吸烟] /look [看] /lay [享受]");
	SM(COLOR_ACT,"/cover [抱头，蹲下] /vomit [呕吐] /eat [吃] /wave [打招呼] /slapass [打PP] /death [卧倒]");
	SM(COLOR_ACT,"/deal [毒品交易] /kiss [亲嘴] /crack [装死] /piss [抚摸下方] /smoke [吸烟] /sit [坐下]");
	SM(COLOR_ACT,"/fu [打招呼] /chat [闲谈] /kill [自杀] /dance1-3 [跳舞]  {FF0000}取消动作 点击鼠标右键");
	SM(COLOR_LIGHTBLUE,"_______________________________________________________________________________");
	return 1;
}
CMD:handsup(playerid, params[], help)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
        SM(0xFF0000FF, " 你举起双手投降!");
		pstat[playerid]=ACT;
    }
    return 1;
}
CMD:drunk(playerid, params[], help)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
       ApplyAnimation(playerid,"PED", "WALK_DRUNK",4.0,0,1,0,0,0);
       SM(0xFF0000FF, " 你现在走路像喝醉了一样!");
	   pstat[playerid]=ACT;
    }
    return 1;
}
CMD:bomb(playerid, params[], help)
{
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在安装炸弹!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:arrest(playerid, params[], help)
{
	ApplyAnimation( playerid,"ped", "ARRESTgun", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在抓捕犯人！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:laugh(playerid, params[], help)
{
    ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在笑!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:lookout(playerid, params[], help)
{
    ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在眺望！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:rob(playerid, params[], help)
{
    ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你在挑衅!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:wankin(playerid, params[], help)
{
    ApplyAnimation(playerid, "PAULNMAC", "wank_loop", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在抚摸下方!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:coparrest(playerid, params[], help)
{
    ApplyAnimation(playerid, "POLICE", "crm_drgbst_01", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你拿起枪指着前方!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:injured(playerid, params[], help)
{
    ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你受伤了！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:slapped(playerid, params[], help)
{
    ApplyAnimation(playerid, "SWEET", "ho_ass_slapped", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你向右边看了看！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:fsmoking(playerid, params[], help)
{
    ApplyAnimation(playerid, "SMOKING", "F_smklean_loop", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 靠在一旁，吸烟！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:look(playerid, params[], help)
{
    ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在看!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:lay(playerid, params[], help)
{
    ApplyAnimation(playerid,"BEACH", "bather", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你躺了下来，享受阳光");
	pstat[playerid]=ACT;
    return 1;
}
CMD:cover(playerid, params[], help)
{
    ApplyAnimation(playerid, "ped", "cower", 3.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 双手抱头, 蹲下");
	pstat[playerid]=ACT;
    return 1;
}
CMD:vomit(playerid, params[], help)
{
	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 呕吐ING...");
	pstat[playerid]=ACT;
    return 1;
}
CMD:eat(playerid, params[], help)
{
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.00, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在吃东西!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:wave(playerid, params[], help)
{
	ApplyAnimation(playerid, "KISSING", "BD_GF_Wave", 3.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 转身打了个招呼!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:slapass(playerid, params[], help)
{
    ApplyAnimation(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你打了下别人的屁股！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:death(playerid, params[], help)
{
    ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 紧急情况！卧倒！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:deal(playerid, params[], help)
{
    ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 正在进行毒品交易!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:kiss(playerid, params[], help)
{
    ApplyAnimation(playerid, "KISSING", "Playa_Kiss_02", 3.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在KISS!");
	pstat[playerid]=ACT;
    return 1;
}
CMD:crack(playerid, params[], help)
{
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在装死！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:piss(playerid, params[], help)
{
    ApplyAnimation(playerid, "PAULNMAC", "Piss_in", 3.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在尿尿");
	pstat[playerid]=ACT;
    return 1;
}
CMD:smoke(playerid, params[], help)
{
    ApplyAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你正在吸烟！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:sit(playerid, params[], help)
{
    ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.0, 0, 0, 0, 0, 0);
    SM(0xFF0000FF, " 你坐了下来！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:fu(playerid, params[], help)
{
	ApplyAnimation( playerid,"ped", "fucku", 4.1, 0, 1, 1, 1, 1 );
    SM(0xFF0000FF, " 你正在打招呼！");
	pstat[playerid]=ACT;
    return 1;
}
CMD:chat(playerid, params[], help)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
    {
		ApplyAnimation(playerid,"PED","IDLE_CHAT",4.1,0,1,1,1,1);
        SM(0xFF0000FF, " 你正在和别人说话!");
		pstat[playerid]=ACT;
	}
    return 1;
}
CMD:dance1(playerid, params[], help)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
		pstat[playerid]=ACT;
	}
    return 1;
}
CMD:dance2(playerid, params[], help)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
		pstat[playerid]=ACT;
	}
    return 1;
}
CMD:dance3(playerid, params[], help)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
		pstat[playerid]=ACT;
	}
    return 1;
}
CMD:ahelp(playerid, params[], help)
{
	if(GetadminLevel(playerid)<1) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	SM(COLOR_LIGHTBLUE,"_______________________________管理员指令[后边数字为管理员等级]_________________________________\n");
	SM(COLOR_LIGHTBLUE,"/lxgl 离线管理1000 /duty管理员值班1 /spec观察1  /specoff结束观察1  /makeadmin设置管理员3000");
	SM(COLOR_LIGHTBLUE,"/go 传送到玩家1  /let拉玩家1   /setmoney设置现金 2000   /pai拍玩家 1 /restbeibao清空背包 2000 ");
	SM(COLOR_LIGHTBLUE,"/deldipan删除地盘2000  /delaiche删除爱车2000  /delgg删除广告 2000  /delgang删除帮派2000");
	SM(COLOR_LIGHTBLUE,"/kickT人1   /mute禁言1  /banBAN2000  /ckbb查看背包1  /ckfz查看房子1  /ckzb查看装扮1 ");
	SM(COLOR_LIGHTBLUE,"/ckcs查看传送1  /ckwz查看文字1  /ckac查看爱车1  /ckdp查看地盘1  /ckbp查看地盘1  /setbankmoney设置存款3000");
	SM(COLOR_LIGHTBLUE,"/ckgg 查看广告1  /addsy添加商业3000  /delsy删除商业3000  /addhouse添加房子3000  /setv设置V币3000");
	SM(COLOR_LIGHTBLUE,"/delhouse删除房子3000  /addint添加内饰3000  /sethouseout设置房子外部坐标3000 /delcs删除传送2000");
	SM(COLOR_LIGHTBLUE,"/sethousein设置房子内部坐标3000  /rehouse重载房子OBJ3000  /sellhouse强制出售房子3000 ");
	SM(COLOR_LIGHTBLUE,"/fxqy飞行器1  /fxqn取消飞行器1  /gopos去坐标1  /setweather设置天气1  /reobj重载世界OBJ3000");
	SM(COLOR_LIGHTBLUE,"/delobj删除OBJ及文件3000  /matobj渲染OBJ材质3000  /addpng添加图片3000  /gopng到达图片1");
	SM(COLOR_LIGHTBLUE,"/editpng编辑图片3000  /sel选择OBJ3000  /addrace创建赛道2000  /delrace删除赛道2000");
	SM(COLOR_LIGHTBLUE,"/searchdj搜索道具2000  /addj添加道具2000  /dju已开放的道具2000  /djj家具型道具2000  ");
	SM(COLOR_LIGHTBLUE,"/djw武器型道具2000  /djc爱车型道具2000  /djn0.3.7新家具2000  /restallcar强制初始化所有爱车2000 ");
	SM(COLOR_LIGHTBLUE,"/restallhouse强制初始化所有房子3000  /shuache刷车 1  /sendxx发送信息[发送金钱或道具]2000");
	SM(COLOR_LIGHTBLUE,"_______________________________________________________________________________________________");
	return 1;
}
CMD:obj(playerid, params[], help)
{
	if(isobj[playerid])
	{
	    isobj[playerid]=0;
		TogglePlayerDynamicObject(playerid,isobj[playerid]);
		SM(COLOR_TWAQUA,"你现在关闭了动态OBJ,要开启重复一遍指令");
	}
	else
	{
	    isobj[playerid]=1;
		TogglePlayerDynamicObject(playerid,isobj[playerid]);
		SM(COLOR_TWAQUA,"你现在开启了动态OBJ,要关闭重复一遍指令");
	}
	return 1;
}
/*
			foreach(new i:UID)
			{
				HighestTopList(i,UID[i][u_Score], Player_ID, Top_Info, JJ[JId][j_phbtop]);
				Counts++;
			}
			format(Str, sizeof(Str), "积分榜\n");
			if(Counts>0)
			{
				strcat(Astr,Str);
				for(new i;i<JJ[JId][j_phbtop]; i++)
				{
					if(Top_Info[i] <= 0) continue;
					format(Str, sizeof(Str), "名次:%i  姓名:%s  积分:%i\n",i+1,UID[Player_ID[i]][u_name],UID[Player_ID[i]][u_Score]);
					strcat(Astr,Str);
				}
			}
*/
CMD:llcs(playerid, params[], help)
{
	current_number[playerid]=1;
	new	Tele_ID[MAX_USER_TELSE],Top_Info[MAX_USER_TELSE],Counts=0,current=-1;
	foreach(new i:Tinfo)
	{
		HighestTopList(i,Tinfo[i][Trate],Tele_ID,Top_Info,Itter_Count(Tinfo));
		Counts++;
	}
	if(Counts>0)
	{
		for(new i;i<Itter_Count(Tinfo); i++)
		{
			if(Top_Info[i] <= 0) continue;
        	current_idx[playerid][current_number[playerid]]=Tele_ID[i];
        	current_number[playerid]++;
        	current++;
		}
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,世界没有传送", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"传送列表/LLCS-共计传送[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_teles, DIALOG_STYLE_TABLIST_HEADERS,tm, Showtelelist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:llcss(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
  	foreach(new i:Tinfo)
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
        current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,世界没有传送", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"传送列表/LLCS-共计传送[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_teles, DIALOG_STYLE_TABLIST_HEADERS,tm, Showtelelist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:njj(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1,idx=0;
	new objid[1024],amoute[1024][8];
	foreach(new x:JJ)
	{
		if(JJ[x][jused]==false)
		{
			if(PlayerToPoint(60, playerid,JJ[x][jx],JJ[x][jy],JJ[x][jz],JJ[x][jin],JJ[x][jwl]))
			{
				current_idx[playerid][idx]=x;
				objid[idx]=Daoju[JJ[x][jdid]][d_obj];
				format(amoute[idx],64,"%0.1fM",GetDistanceBetweenPO(playerid,JJ[x][jid]));
		       	current_number[playerid]++;
		       	current++;
		       	idx++;
			}
		}
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，你的附近没有家具", "好的", "");
	new amouts=idx;
	new tm[100];
	format(tm,100,"~b~NEAR ~r~%i",amouts);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_NEAR_JJ_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
forward Float:GetDistanceBetweenPO(playerid,objectid);
stock Float:GetDistanceBetweenPO(playerid,objectid)
{
	new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
	GetPlayerPos(playerid,x1,y1,z1);
	GetDynamicObjectPos(objectid,x2,y2,z2);
	new Float:xd=x2-x1;
	new Float:yd=y2-y1;
	new Float:zd=z2-z1;
	return floatsqroot((xd*xd)+(yd*yd)+(zd*zd));
}
CMD:unsavepos(playerid, params[], help)
{
	UID[PU[playerid]][u_IsSavePos]=0;
	Saveduid_data(PU[playerid]);
	SM(COLOR_TWAQUA,"出生点定位已取消");
	return 1;
}
CMD:kgpz(playerid, params[], help)
{
	if(!UID[PU[playerid]][u_vcoll])
	{
	    UID[PU[playerid]][u_vcoll]=1;
	    DisableRemoteVehicleCollisions(playerid,UID[PU[playerid]][u_vcoll]);
	    SM(COLOR_TWAQUA,"碰撞开启");
	}
	else
	{
	    UID[PU[playerid]][u_vcoll]=0;
	    DisableRemoteVehicleCollisions(playerid,UID[PU[playerid]][u_vcoll]);
	    SM(COLOR_TWAQUA,"碰撞关闭");
	}
	Saveduid_data(PU[playerid]);
	return 1;
}
CMD:sendxx(playerid, params[], help)
{
	new player,stt[150],money,did,amout;
    if(sscanf(params, "is[150]D(0)D(-1)D(0)",player,stt,money,did,amout))return SM(COLOR_TWAQUA,"sendxx 玩家ID 消息");
    if(money>0&&GetadminLevel(playerid)<2000)return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    if(did!=-1&&GetadminLevel(playerid)<2000)return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    if(amout>0&&GetadminLevel(playerid)<2000)return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
    if(money<0||money>MAX_MONEY) return SM(COLOR_TWAQUA,"金钱数值错误");
    if(did!=-1&&!Iter_Contains(Daoju,did)) return SM(COLOR_TWAQUA,"道具不存在");
    if(amout<0||amout>100) return SM(COLOR_TWAQUA,"个数数值错误");
	PlayerSendPlayerLog(playerid,PU[player],stt,money,did,amout);
	return 1;
}

CMD:savepos(playerid, params[], help)
{
	new Float:xyza[4];
	GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
	GetPlayerFacingAngle(playerid,xyza[3]);
	UID[PU[playerid]][u_IsSavePos]=1;
	UID[PU[playerid]][u_LastX]=xyza[0];
	UID[PU[playerid]][u_LastY]=xyza[1];
	UID[PU[playerid]][u_LastZ]=xyza[2];
	UID[PU[playerid]][u_LastA]=xyza[3];
	UID[PU[playerid]][u_In]=GetPlayerInterior(playerid);
	UID[PU[playerid]][u_Wl]=GetPlayerVirtualWorld(playerid);
	Saveduid_data(PU[playerid]);
	SM(COLOR_TWAQUA,"出生点定位成功");
	return 1;
}
CMD:stats(playerid, params[], help)
{
	Dialog_Show(playerid, dl_stats, DIALOG_STYLE_LIST, "个人信息", ShowPlayerinfo(playerid), "我的设置", "观看完毕");
	return 1;
}
Dialog:dl_stats(playerid, response, listitem, inputtext[])
{
	if(response)CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdsz");
	return 1;
}
stock isValidHexCode(code[])
{
	new checked;
	for(new i;i<6;i++)
	{
		if(isNumeric(code[i])) checked+=1;
		else if((code[i] == 'A' || code[i] == 'a') || (code[i] == 'B' || code[i] == 'b') || (code[i] == 'C' || code[i] == 'c') || (code[i] == 'D' || code[i] == 'd') || (code[i] == 'E' || code[i] == 'e') || (code[i] == 'F' || code[i] == 'f')) checked+=1;
	}

	if(checked == 6) return true;
	return false;
}
CMD:wdcs(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:Tinfo)
	{
		if(Tinfo[i][Tuid]==PU[playerid])
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的传送-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_myteles, DIALOG_STYLE_LIST,tm, Showmytelelist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:wdwz(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:fonts)
	{
		if(fonts[i][f_uid]==PU[playerid])
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的文字点-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_myfonts, DIALOG_STYLE_LIST,tm, Showmyfontlist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:wdgg(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:RM)
	{
		if(RM[i][r_uid]==PU[playerid])
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的广告-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_mygg, DIALOG_STYLE_LIST,tm, Showmygglist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:c(playerid, params[], help)
{
	if(pp_race[playerid][romid]!=-1)
	{
	    if(RACE_ROM[pp_race[playerid][romid]][RACE_CAR]!=0)return SM(COLOR_TWAQUA, "当前比赛无法使用刷车");
	}
	new Vid,col1,col2;
	if(sscanf(params, "iD(1)D(1)",Vid,col1,col2))return SM(COLOR_TWAQUA, "用法: /c [汽车ID] [颜色1] [颜色2]");
	if(!IsValidVehicleModel(Vid)) return SM(COLOR_TWAQUA,"车辆ID错误");
	new Float:xyza[4];
	if(pbrushcar[playerid]==-1)
	{
		GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
		GetPlayerFacingAngle(playerid,xyza[3]);
    	pbrushcar[playerid]=AddStaticVehicleEx(Vid,xyza[0],xyza[1],xyza[2],xyza[3],col1,col2,99999999);
    	CarTypes[pbrushcar[playerid]]=BrushVeh;
		new Stru[100];
		format(Stru,sizeof(Stru),Temp_Veh_Str,VehName[GetVehicleModel(pbrushcar[playerid])-400],UID[PU[playerid]][u_name]);
  		pbrushcartext[pbrushcar[playerid]]=CreateColor3DTextLabel(Stru,COLOR_RED,0.0,0.0,0.8,20,INVALID_PLAYER_ID,pbrushcar[playerid],1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,20.0,0,0);
		SetVehiclePos(pbrushcar[playerid],xyza[0],xyza[1],xyza[2]);
		SetVehicleZAngle(pbrushcar[playerid],xyza[3]);
        LinkVehicleToInterior(pbrushcar[playerid],GetPlayerInterior(playerid));
    	SetVehicleVirtualWorld(pbrushcar[playerid],GetPlayerVirtualWorld(playerid));
        PutPInVehicle(playerid,pbrushcar[playerid],0);
        pcarcolor1[playerid]=random(255);
    	pcarcolor2[playerid]=random(255);
    }
    else
    {
        new cids=GetPlayerVehicleID(playerid);
		if(cids!=0)
		{
			GetVehiclePos(cids,xyza[0],xyza[1],xyza[2]);
			GetVehicleZAngle(cids,xyza[3]);
		    if(cids!=pbrushcar[playerid]&&!GetPlayerVehicleSeat(playerid))SetVehicleToRespawn(cids);
      		DeleteColor3DTextLabel(pbrushcartext[pbrushcar[playerid]]);
      		DestroyVehicle(pbrushcar[playerid]);
      		pbrushcar[playerid]=AddStaticVehicleEx(Vid,xyza[0],xyza[1],xyza[2],xyza[3],col1,col2,99999999);
      		CarTypes[pbrushcar[playerid]]=BrushVeh;
      		new Stru[100];
      		format(Stru,sizeof(Stru),Temp_Veh_Str,VehName[GetVehicleModel(pbrushcar[playerid])-400],UID[PU[playerid]][u_name]);
      		pbrushcartext[pbrushcar[playerid]]=CreateColor3DTextLabel(Stru,COLOR_RED,0.0,0.0,0.8,20,INVALID_PLAYER_ID,pbrushcar[playerid],1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,20.0,0,0);
      		SetVehiclePos(pbrushcar[playerid],xyza[0],xyza[1],xyza[2]);
      		SetVehicleZAngle(pbrushcar[playerid],xyza[3]);
      		LinkVehicleToInterior(pbrushcar[playerid],GetPlayerInterior(playerid));
      		SetVehicleVirtualWorld(pbrushcar[playerid],GetPlayerVirtualWorld(playerid));
      		PutPInVehicle(playerid,pbrushcar[playerid], 0);
		}
		else
		{
			GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
			GetPlayerFacingAngle(playerid,xyza[3]);
      		DeleteColor3DTextLabel(pbrushcartext[pbrushcar[playerid]]);
      		DestroyVehicle(pbrushcar[playerid]);
      		pbrushcar[playerid]=AddStaticVehicleEx(Vid,xyza[0],xyza[1],xyza[2],xyza[3],col1,col2,99999999);
      		CarTypes[pbrushcar[playerid]]=BrushVeh;
      		new Stru[100];
      		format(Stru,sizeof(Stru),Temp_Veh_Str,VehName[GetVehicleModel(pbrushcar[playerid])-400],UID[PU[playerid]][u_name]);
      		pbrushcartext[pbrushcar[playerid]]=CreateColor3DTextLabel(Stru,COLOR_RED,0.0,0.0,0.8,20,INVALID_PLAYER_ID,pbrushcar[playerid],1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),-1,20.0,0,0);
      		SetVehiclePos(pbrushcar[playerid],xyza[0],xyza[1],xyza[2]);
      		SetVehicleZAngle(pbrushcar[playerid],xyza[3]);
      		LinkVehicleToInterior(pbrushcar[playerid],GetPlayerInterior(playerid));
      		SetVehicleVirtualWorld(pbrushcar[playerid],GetPlayerVirtualWorld(playerid));
      		PutPInVehicle(playerid,pbrushcar[playerid], 0);
		}
    }
    ChangeVehicleColor(pbrushcar[playerid],pcarcolor1[playerid],pcarcolor2[playerid]);
	return 1;
}
CMD:jefferson(playerid, params[], help)return TeleportPlayer(playerid,"jefferson",2228.5488,-1160.0876,25.5190,90.0,0,0,"Welcome to Jefferson Motel");
CMD:aa(playerid, params[], help)return TeleportPlayer(playerid,"aa",409.2281,2573.1426,16.3672,90.0,0,0,"Welcome to old airport");
CMD:motel(playerid, params[], help)return TeleportPlayer(playerid,"motel",2228.5488,-1160.0876,25.5190,90.0,0,0,"Welcome to Jefferson Motel");
CMD:carlhome(playerid, params[], help)return TeleportPlayer(playerid,"carlhome",1245.6436,-763.9819,92.1559,180.0,0,0,"Welcome to Little Carl's house");
CMD:carlhome2(playerid, params[], help)return TeleportPlayer(playerid,"carlhome2",892.4420,-1657.9996,13.2752,0.0,0,0,"Welcome to Big Carl's house");
CMD:bigcarlhome(playerid, params[], help)return TeleportPlayer(playerid,"bigcarlhome",892.4420,-1657.9996,13.2752,0.0,0,0,"Welcome to Big Carl's house");
CMD:seville(playerid, params[], help)return TeleportPlayer(playerid,"seville",2766.1255,-1979.4883,13.1039,180.0,0,0,"Welcome to fangye's house");
CMD:village(playerid, params[], help)return TeleportPlayer(playerid,"village",-436.1484,-433.3588,16.2678,310.1183,0,0,"Welcome to fangye's village");
CMD:mfa(playerid, params[], help)return TeleportPlayer(playerid,"mfa",-1077.4032,-1648.0542,75.9494,267.7598,0,0,"Welcome to MFA's village");
CMD:mfahome(playerid, params[], help)return TeleportPlayer(playerid,"mfahome",-1077.4032,-1648.0542,75.9494,267.7598,0,0,"Welcome to MFA's village");
CMD:mfadejia(playerid, params[], help)return TeleportPlayer(playerid,"mfadejia",-1077.4032,-1648.0542,75.9494,267.7598,0,0,"Welcome to MFA's village");
CMD:cc(playerid, params[], help)return TeleportPlayer(playerid,"cc",-688.9996,966.5593,11.8931,90.0,0,0,"Welcome to Ailde's house");
CMD:ls(playerid, params[], help)return TeleportPlayer(playerid,"ls",1384.4961,-2442.0063,13.5547,90.0,0,0,"Welcome to Los Angeles");
CMD:sf(playerid, params[], help)return TeleportPlayer(playerid,"sf",-1224.4486,48.1323,13.9070,135.0,0,0,"Welcome to San Fransisco");
CMD:lv(playerid, params[], help)return TeleportPlayer(playerid,"lv",1339.0537,1268.9032,10.5474,0.0,0,0,"Welcome to Las Venturas");
CMD:lc(playerid, params[], help)return TeleportPlayer(playerid,"lc",-748.0042,488.2530,1371.5521,256.7060,1,0,"Welcome to Liberty City");
CMD:zyc(playerid, params[], help)return TeleportPlayer(playerid,"zyc",-748.0042,488.2530,1371.5521,256.7060,1,0,"Welcome to Liberty City");
CMD:cafe(playerid, params[], help)return TeleportPlayer(playerid,"cafe",-781.8113,489.3232,1376.1954,256.7060,1,0,"Saint Mark's");
CMD:chilliad(playerid, params[], help)return TeleportPlayer(playerid,"chilliad",-2306.9426,-1658.9847,483.6752,29.4973,0,0,"Welcome to Chilliad");
CMD:drift1(playerid, params[], help)return TeleportPlayer(playerid,"drift1",-2409.7190,-600.5191,132.3425,270.0,0,0,"Drift 1");
CMD:drift2(playerid, params[], help)return TeleportPlayer(playerid,"drift2",-344.5910,1528.6195,75.0840,265.2350,0,0,"Drift 2");
CMD:ldz(playerid, params[], help)return TeleportPlayer(playerid,"ldz",-344.5910,1528.6195,75.0840,265.2350,0,0,"Welcome to LDZ");
CMD:bisai(playerid, params[], help)return TeleportPlayer(playerid,"bisai",-2006.2069,157.2752,27.2661,0.0,0,0,"Let's race");
CMD:leap(playerid, params[], help)return TeleportPlayer(playerid,"leap",1960.2781,1595.4114,75.7188,27.8704,0,0,"leap");
CMD:lspd(playerid, params[], help)return TeleportPlayer(playerid,"lspd",1536.1317,-1675.9449,13.1099,180.0,0,0,"Welcome to LSPD");
CMD:lsjj(playerid, params[], help)return TeleportPlayer(playerid,"lsjj",1536.1317,-1675.9449,13.1099,180.0,0,0,"Welcome to LSPD");
CMD:sfpd(playerid, params[], help)return TeleportPlayer(playerid,"sfpd",-1605.0063,729.8975,11.4600,274.2862,0,0,"Welcome to SFPD");
CMD:sfjj(playerid, params[], help)return TeleportPlayer(playerid,"sfjj",-1605.0063,729.8975,11.4600,274.2862,0,0,"Welcome to SFPD");
CMD:lvpd(playerid, params[], help)return TeleportPlayer(playerid,"lvpd",2290.0459,2417.2661,10.4761,271.4613,0,0,"Welcome to LVPD");
CMD:lvjj(playerid, params[], help)return TeleportPlayer(playerid,"lvjj",2290.0459,2417.2661,10.4761,271.4613,0,0,"Welcome to LVPD");
CMD:cs1(playerid, params[], help)return TeleportPlayer(playerid,"cs1",-3184.0950,1378.6230,39.5265,90.0,0,0,"Aircraft Carrier");
CMD:cs2(playerid, params[], help)return TeleportPlayer(playerid,"cs2",-2810.4521,-702.0084,67.3884,90.0,0,0,"Nazi Zombie FS");
CMD:cs3(playerid, params[], help)return TeleportPlayer(playerid,"cs3",914.8998,-319.2097,51.2545,90.0,0,0,"ELIMINATION");
CMD:cs4(playerid, params[], help)return TeleportPlayer(playerid,"cs4",1457.1715,-1516.4901,66.7497,90.0,0,0,"Deathmatch arena");
CMD:cs5(playerid, params[], help)return TeleportPlayer(playerid,"cs5",1702.5566,-3491.3135,20.8811,90.0,0,0,"Militia Forest");
CMD:cs6(playerid, params[], help)return TeleportPlayer(playerid,"cs6",5852.9780,-4559.7324,-45.8128,338.1001,0,0,"Sea Desert");
CMD:cs7(playerid, params[], help)return TeleportPlayer(playerid,"cs7",1729.2975,-1421.3094,218.6206,146.7231,0,0,"Super Carrier!");
CMD:cs(playerid, params[], help)return TeleportPlayer(playerid,"cs",1729.2975,-1421.3094,218.6206,146.7231,0,0,"Super Carrier!");
CMD:kyzz(playerid, params[], help)return TeleportPlayer(playerid,"kyzz",-1572.5067,-2746.2146,48.5391,0,0,0,"kyzz");
CMD:ddjd(playerid, params[], help)return TeleportPlayer(playerid,"ddjd",94.692932,1920.587402,18.082904,0,0,0,"ddjd");
CMD:qnsd(playerid, params[], help)return TeleportPlayer(playerid,"qnsd",-2237.914306,-1719.255615,480.847229,0,0,0,"qnsd");
CMD:qnsj(playerid, params[], help)return TeleportPlayer(playerid,"qnsj",-2410.1270,-2181.6501,36.6544,0,0,0,"qnsj");
CMD:sfjc(playerid, params[], help)return TeleportPlayer(playerid,"sfjc",-1711.7842,-196.4667,14.5469,0,0,0,"sfjc");
CMD:gc1(playerid, params[], help)return TeleportPlayer(playerid,"gc1",2386.630371, 1030.381347,11.0,0,0,0,"改车1");
CMD:gc2(playerid, params[], help)return TeleportPlayer(playerid,"gc2",-2691.774658, 217.704162,4,0,0,0,"改车2");
CMD:jyz(playerid, params[], help)return TeleportPlayer(playerid,"jyz",2135.2939,953.2213,10.4880,0,0,0,"jyz");
CMD:zsj(playerid, params[], help)return TeleportPlayer(playerid,"zsj",-2940.4744,-1586.0093,11.0015,0,0,0,"珠三角");
CMD:jjsc(playerid, params[], help)return TeleportPlayer(playerid,"jjsc",317.8049,1553.0446,1100.3053,0,0,0,"家具发布大厅");
CMD:csc(playerid, params[], help)return TeleportPlayer(playerid,"csc",968.4280,-1357.8716,13.3502,0,0,0,"菜市场");
CMD:gygh(playerid, params[], help)return TeleportPlayer(playerid,"gygh",2000.3889,1550.6478,13.6122,0,0,0,"公用篝火");
CMD:hdc(playerid, params[], help)return TeleportPlayer(playerid,"hdc",2026.9486, 1545.2271, 11.0330,0.0,0,0,"Welcome to hdc");

