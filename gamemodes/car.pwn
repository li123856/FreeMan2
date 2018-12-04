Dialog:dl_buysyscar(playerid, response, listitem, inputtext[])
{
	new cid=GetPVarInt(playerid,"CARID");
	if(response)
	{
		if(VInfo[CUID[cid]][v_issel]!=NONEONE)return SM(COLOR_TWTAN,"该车已被别人购买");
		if(Daoju[VInfo[CUID[cid]][v_did]][d_cash]>UID[PU[playerid]][u_Cash])return SM(COLOR_TWTAN,"你没有足够的钱购买");
		Moneyhandle(PU[playerid],-Daoju[VInfo[CUID[cid]][v_did]][d_cash]);
		VInfo[CUID[cid]][v_uid]=PU[playerid];
		VInfo[CUID[cid]][v_Value]=0;
		VInfo[CUID[cid]][v_issel]=OWNERS;
   		format(VInfo[CUID[cid]][v_Plate],100,Gnn(playerid));
   		SetVehicleNumberPlate(cid,VInfo[CUID[cid]][v_Plate]);
		DeleteColor3DTextLabel(VInfo[CUID[cid]][v_text]);
		Createcar3D(cid);
        SetPlayerVehSpawn(cid);
		Savedveh_data(CUID[cid]);
		DeletePVar(playerid,"CARID");
	}
	else DeletePVar(playerid,"CARID");
	return 1;
}
Dialog:dl_buyplaycar(playerid, response, listitem, inputtext[])
{
	new cid=GetPVarInt(playerid,"CARID");
	if(response)
	{
		if(VInfo[CUID[cid]][v_issel]!=SELLING)return SM(COLOR_TWTAN,"该车已被别人购买或遗弃");
		if(VInfo[CUID[cid]][v_Value]>UID[PU[playerid]][u_Cash])return SM(COLOR_TWTAN,"你没有足够的钱购买");
		Moneyhandle(PU[playerid],-VInfo[CUID[cid]][v_Value]);
        new tm[150];
	    format(tm,150,"%s购买了你的爱车[%s]花费$%i,请提取",Gn(playerid),Daoju[VInfo[CUID[cid]][v_did]][d_name],VInfo[CUID[cid]][v_Value]);
		AddPlayerLog(VInfo[CUID[cid]][v_uid],"系统",tm,VInfo[CUID[cid]][v_Value]);
		VInfo[CUID[cid]][v_uid]=PU[playerid];
		VInfo[CUID[cid]][v_Value]=0;
		VInfo[CUID[cid]][v_issel]=OWNERS;
   		format(VInfo[CUID[cid]][v_Plate],100,Gnn(playerid));
   		SetVehicleNumberPlate(cid,VInfo[CUID[cid]][v_Plate]);
		DeleteColor3DTextLabel(VInfo[CUID[cid]][v_text]);
		Createcar3D(cid);
		Savedveh_data(CUID[cid]);
        SetPlayerVehSpawn(cid);
		DeletePVar(playerid,"CARID");
	}
	else DeletePVar(playerid,"CARID");
	return 1;
}
Dialog:dl_sellplaycar(playerid, response, listitem, inputtext[])
{
	if(response)
	{
    	new Carid=GetPlayerVehicleID(playerid);
		if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_sellplaycar, DIALOG_STYLE_INPUT, "设置售价", "请输入售价，大于0", "确定", "取消");
	    if(strval(inputtext)>100000000)return Dialog_Show(playerid, dl_sellplaycar, DIALOG_STYLE_INPUT, "设置售价", "请输入售价,不能超过一亿", "确定", "取消");
        VInfo[CUID[Carid]][v_Value]=strval(inputtext);
		VInfo[CUID[Carid]][v_issel]=SELLING;
		DeleteColor3DTextLabel(VInfo[CUID[Carid]][v_text]);
		Createcar3D(Carid);
  		Savedveh_data(CUID[Carid]);
  		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","出售价格设置成功", "好的", "");
	}
	return 1;
}
Dialog:dl_putbb(playerid, response, listitem, inputtext[])
{
	if(response)
	{
    	new Carid=GetPlayerVehicleID(playerid);
 		Addbeibao(playerid,VInfo[CUID[Carid]][v_did],1);
 		foreach(new i:AvInfo[CUID[Carid]])DestroyDynamicObject(AvInfo[CUID[Carid]][i][av_id]);
 		DeleteColor3DTextLabel(VInfo[CUID[Carid]][v_text]);
 		DestroyVehicle(Carid);
 		if(fexist(Get_Path(CUID[Carid],0)))fremove(Get_Path(CUID[Carid],0));
 		if(fexist(Get_Path(CUID[Carid],8)))fremove(Get_Path(CUID[Carid],8));
 		Iter_Clear(AvInfo[CUID[Carid]]);
 		Iter_Remove(VInfo,CUID[Carid]);
 		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","已放入背包,/wdbb查收", "好的", "");
	}
	else Dialog_Show(playerid,dl_carlist,DIALOG_STYLE_LIST,"爱车菜单","爱车定位\n爱车上锁\n装扮爱车\n标签颜色\n更改车牌\n车窗开关\n放入背包\n出售爱车\n抛弃爱车","确定", "取消");
	return 1;
}
Dialog:dl_setplayerplate(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext);
	    if(strlenEx(inputtext)<1)return Dialog_Show(playerid, dl_setplayerplate, DIALOG_STYLE_INPUT, "设置名称", "名称过短,请输入名称", "确定", "取消");
		if(strlenEx(inputtext)>100)return Dialog_Show(playerid, dl_setplayerplate, DIALOG_STYLE_INPUT, "设置名称", "名称过长,请输入名称", "确定", "取消");
		new carid=GetPlayerVehicleID(playerid);
        format(VInfo[CUID[carid]][v_Plate],100,inputtext);
        Savedveh_data(CUID[GetPlayerVehicleID(playerid)]);
        SetVehicleNumberPlate(carid,VInfo[CUID[carid]][v_Plate]);
        SetPlayerVehSpawn(carid,playerid);
	}
	return 1;
}
stock SetPlayerVehSpawn(carid,playerid=-1)
{
	new Float:x, Float: y, Float:z, Float:fa,in,wl;
    GetVehiclePos(carid, x, y, z);
	GetVehicleZAngle(carid, fa);
	in=GetPlayerInterior(carid);
	wl=GetPlayerVirtualWorld(carid);
	SetVehicleToRespawn(carid);
	SetVehiclePos(carid, x, y, z);
	SetVehicleZAngle(carid,fa);
	LinkVehicleToInterior(carid,in);
	SetVehicleVirtualWorld(carid,wl);
	if(playerid!=-1)PutPInVehicle(playerid,carid, 0);
	return 1;
}
CMD:kzac(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
  	foreach(new X:VInfo)
	{
	    if(VInfo[X][v_issel]!=OWNERS)
	    {
	        current_idx[playerid][current_number[playerid]]=X;
	        current_number[playerid]++;
	        current++;
        }
	}
	if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "错误,暂时没有空置爱车", "哦", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"空置爱车-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_kzac, DIALOG_STYLE_LIST,tm, Showkzcarslist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showkzcarslist(playerid,pager)
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
 			switch(VInfo[current_idx[playerid][i]][v_issel])
			{
				case NONEONE:format(tmps,100,"系统出售 ID:%i - 爱车名:%s - 模型:%i - 售价:%i\n",VInfo[current_idx[playerid][i]][v_cid],Daoju[VInfo[current_idx[playerid][i]][v_did]][d_name],Daoju[VInfo[current_idx[playerid][i]][v_did]][d_obj],Daoju[VInfo[current_idx[playerid][i]][v_did]][d_cash]);
				case SELLING:format(tmps,100,"玩家转让 ID:%i - 车主:%s - 爱车名:%s - 模型:%i - 售价:%i\n",VInfo[current_idx[playerid][i]][v_cid],UID[VInfo[current_idx[playerid][i]][v_uid]][u_name],Daoju[VInfo[current_idx[playerid][i]][v_did]][d_name],Daoju[VInfo[current_idx[playerid][i]][v_did]][d_obj],VInfo[current_idx[playerid][i]][v_Value]);
			}
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
Dialog:dl_kzac(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_kzac,DIALOG_STYLE_LIST,"空置爱车",Showkzcarslist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			new Float:x,Float:y,Float:z,wl;
			GetVehiclePos(VInfo[listid][v_cid],x,y,z);
			wl=GetVehicleVirtualWorld(VInfo[listid][v_cid]);
			SetPlayerPosEx(playerid,x,y,z+1,0.0,0,wl);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_kzac,DIALOG_STYLE_LIST,"空置爱车",Showkzcarslist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
new tuned;
new spoiler[20][0] = {
	{1000},
	{1001},
	{1002},
	{1003},
	{1014},
	{1015},
	{1016},
	{1023},
	{1058},
	{1060},
	{1049},
	{1050},
	{1138},
	{1139},
	{1146},
	{1147},
	{1158},
	{1162},
	{1163},
	{1164}
};

new nitro[3][0] = {
    {1008},
    {1009},
    {1010}
};

new fbumper[23][0] = {
    {1117},
    {1152},
    {1153},
    {1155},
    {1157},
    {1160},
    {1165},
    {1167},
    {1169},
    {1170},
    {1171},
    {1172},
    {1173},
    {1174},
    {1175},
    {1179},
    {1181},
    {1182},
    {1185},
    {1188},
    {1189},
    {1192},
    {1193}
};

new rbumper[22][0] = {
    {1140},
    {1141},
    {1148},
    {1149},
    {1150},
    {1151},
    {1154},
    {1156},
    {1159},
    {1161},
    {1166},
    {1168},
    {1176},
    {1177},
    {1178},
    {1180},
    {1183},
    {1184},
    {1186},
    {1187},
    {1190},
    {1191}
};

new exhaust[28][0] = {
    {1018},
    {1019},
    {1020},
    {1021},
    {1022},
    {1028},
    {1029},
    {1037},
    {1043},
    {1044},
    {1045},
    {1046},
    {1059},
    {1064},
    {1065},
    {1066},
    {1089},
    {1092},
    {1104},
    {1105},
    {1113},
    {1114},
    {1126},
    {1127},
    {1129},
    {1132},
    {1135},
    {1136}
};

new bventr[2][0] = {
    {1142},
    {1144}
};

new bventl[2][0] = {
    {1143},
    {1145}
};

new bscoop[4][0] = {
	{1004},
	{1005},
	{1011},
	{1012}
};

new rscoop[17][0] = {
    {1006},
    {1032},
    {1033},
    {1035},
    {1038},
    {1053},
    {1054},
    {1055},
    {1061},
    {1067},
    {1068},
    {1088},
    {1091},
    {1103},
    {1128},
    {1130},
    {1131}
};

new lskirt[21][0] = {
    {1007},
    {1026},
    {1031},
    {1036},
    {1039},
    {1042},
    {1047},
    {1048},
    {1056},
    {1057},
    {1069},
    {1070},
    {1090},
    {1093},
    {1106},
    {1108},
    {1118},
    {1119},
    {1133},
    {1122},
    {1134}
};

new rskirt[21][0] = {
    {1017},
    {1027},
    {1030},
    {1040},
    {1041},
    {1051},
    {1052},
    {1062},
    {1063},
    {1071},
    {1072},
    {1094},
    {1095},
    {1099},
    {1101},
    {1102},
    {1107},
    {1120},
    {1121},
    {1124},
    {1137}
};

new hydraulics[1][0] = {
    {1087}
};

new bases[1][0] = {
    {1086}
};

new rbbars[4][0] = {
    {1109},
    {1110},
    {1123},
    {1125}
};

new fbbars[2][0] = {
    {1115},
    {1116}
};

new wheels[17][0] = {
    {1025},
    {1073},
    {1074},
    {1075},
    {1076},
    {1077},
    {1078},
    {1079},
    {1080},
    {1081},
    {1082},
    {1083},
    {1084},
    {1085},
    {1096},
    {1097},
    {1098}
};

new lights[2][0] = {
	{1013},
	{1024}
};
Function SaveComponent(vehicleid,componentid)
{
	for(new s=0; s<20; s++)
	{
		if(componentid == spoiler[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][0]=componentid;
   	    }
	}
	for(new s=0; s<3; s++)
	{
     	if(componentid == nitro[s][0])
        {
       		VInfo[CUID[vehicleid]][v_comp][1]=componentid;
   	    }
	}
	for(new s=0; s<23; s++)
	{
     	if(componentid == fbumper[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][2]=componentid;
   	    }
	}
	for(new s=0; s<22; s++)
	{
     	if(componentid == rbumper[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][3]=componentid;
   	    }
	}
	for(new s=0; s<28; s++)
	{
     	if(componentid == exhaust[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][4]=componentid;
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == bventr[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][5]=componentid;
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == bventl[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][6]=componentid;
   	    }
	}
	for(new s=0; s<4; s++)
	{
     	if(componentid == bscoop[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][7]=componentid;
   	    }
	}
	for(new s=0; s<17; s++)
	{
		if(componentid == rscoop[s][0])
		{
			VInfo[CUID[vehicleid]][v_comp][8]=componentid;
		}
	}
	for(new s=0; s<21; s++)
	{
     	if(componentid == lskirt[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][9]=componentid;
   	    }
	}
	for(new s=0; s<21; s++)
	{
     	if(componentid == rskirt[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][10]=componentid;
		}
	}
	for(new s=0; s<1; s++)
	{
     	if(componentid == hydraulics[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][11]=componentid;
   	    }
	}
	for(new s=0; s<1; s++)
	{
     	if(componentid == bases[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][12]=componentid;
   	    }
	}
	for(new s=0; s<4; s++)
	{
     	if(componentid == rbbars[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][13]=componentid;
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == fbbars[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][14]=componentid;
   	    }
	}
	for(new s=0; s<17; s++)
	{
     	if(componentid == wheels[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][15]=componentid;
   	    }
	}
	for(new s=0; s<2; s++)
	{
     	if(componentid == lights[s][0])
		{
       		VInfo[CUID[vehicleid]][v_comp][16]=componentid;
   	    }
	}
	Savedveh_data(CUID[vehicleid]);
	return 1;
}


public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(CarTypes[vehicleid]==OwnerVeh)
		{
			if(VInfo[CUID[vehicleid]][v_uid]==PU[playerid])
			{
			    VInfo[CUID[vehicleid]][v_Paintjob]=paintjobid;
			    Savedveh_data(CUID[vehicleid]);
			}
		}
	}
    return 1;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(CarTypes[vehicleid]==OwnerVeh)
		{
			if(VInfo[CUID[vehicleid]][v_uid]==PU[playerid])
			{
			    VInfo[CUID[vehicleid]][v_color1]=color1;
			    VInfo[CUID[vehicleid]][v_color2]=color2;
			    Savedveh_data(CUID[vehicleid]);
			}
		}
	}
    return 1;
}
stock ModVehicle(vehicleid)
{
    new tuned2 = 0;
	if(VInfo[CUID[vehicleid]][v_comp][0]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][0]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][1]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][1]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][2]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][2]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][3]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][3]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][4]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][4]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][5]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][5]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][6]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][6]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][7]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][7]);
		tuned2 = 1;
 	}
	if(VInfo[CUID[vehicleid]][v_comp][8]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][8]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][9]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][9]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][10]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][10]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][11]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][11]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][12]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][12]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][13]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][13]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][14]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][14]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][15]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][15]);
		tuned2 = 1;
	}
	if(VInfo[CUID[vehicleid]][v_comp][16]!= 0)
	{
		AddVehicleComponent(vehicleid,VInfo[CUID[vehicleid]][v_comp][16]);
		tuned2 = 1;
	}
	if(tuned2 == 1)
	{
	    tuned++;
	}
}
stock IsVehicleComponentLegal(vehicleid, componentid) {
	new s_LegalMods[][] = {
		{54273792, 0, 16776704, 7, 0, 0},
		{35268602, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37431173, 0, 16776704, 7, 0, 0},
		{45893379, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{62531466, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{42862474, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{36767556, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{36177722, 0, 16776704, 7, 0, 0},
		{45958913, 0, 16776704, 7, 0, 0},
		{37365632, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{36177786, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{41560010, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{42084234, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37619648, 0, 16776704, 7, 0, 0},
		{57685808, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{52242293, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{46024584, 0, 16776704, 7, 245760, 0},
		{33621873, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43651022, 0, 16776704, 7, 49152, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{54011648, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37717909, 0, 16776704, 7, 0, 0},
		{43976588, 0, 16776704, 7, 245760, 0},
		{43395050, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37144450, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43917258, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, -67107785, 0, 35389440},
		{33556224, 0, 16776704, 67002375, 0, 0},
		{33556224, 0, 16776704, 7047, 1, 31457280},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{60688338, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{37537536, 0, 16776704, 7, 196608, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{59639766, 0, 16776704, 7, 245760, 0},
		{37553929, 0, 16776704, 7, 49152, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43917194, 0, 16776704, 7, 245760, 0},
		{43779962, 0, 16776704, 7, 245760, 0},
		{45942636, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, -512, 7, 0, 504},
		{33556224, 0, 16777214, 7, -1073741824, 8199},
		{-33552640, 3, 16776704, 7, 15360, 1536},
		{-838859008, -8388608, 16776705, 7, 1006632960, 0},
		{33556224, 1020, 16776704, 7, 3932160, 6144},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 8380416, 16776704, 7, 62914560, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 71, 62, 1006632960},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 7168, 16776704, 15, 0, 245760},
		{33556224, 0, 16776704, 7, 960, -1073741824},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{43386818, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{51849201, 0, 16776704, 7, 196608, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{0, 0, 0, 0, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{39200752, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{60688322, 0, 16776704, 7, 245760, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0},
		{33556224, 0, 16776704, 7, 0, 0}
	};

	// These is the only case with componentids > 1191 (saves ~1kb in the array)
	if (vehicleid == 576 && (componentid == 1192 || componentid == 1193))
		return true;

	if (1000 <= componentid <= 1191 && 400 <= vehicleid <= 611) {
		componentid -= 1000;
		vehicleid -= 400;

		return (s_LegalMods[vehicleid][componentid >>> 5] & 1 << (componentid & 31)) || false;
	}

	return false;
}
public OnVehicleMod(playerid, vehicleid, componentid)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
		if(CarTypes[vehicleid]==OwnerVeh)
		{
		    if(VInfo[CUID[vehicleid]][v_uid]==PU[playerid])
		    {
				if(IsVehicleComponentLegal(vehicleid, componentid))SaveComponent(vehicleid, componentid);
				else
				{
					RemoveVehicleComponent(vehicleid, componentid);
					return 0;
				}
			}
		}
	}
	else
	{
  		RemoveVehicleComponent(vehicleid, componentid);
		return 0;
	}
	return 1;
}
