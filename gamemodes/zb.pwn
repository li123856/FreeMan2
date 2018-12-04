#define MAX_ZB  800
enum zbdate
{
	zb_uid,
	zb_cash,
	zb_issell,
	zb_name[100],
}
new Pzb[MAX_ZB][zbdate];
new Iterator:Pzb<MAX_ZB>;

enum zbsdate
{
	zbs_did,
	zbs_type,
	zbs_modelid,
	zbs_boneid,
	Float:zbs_fOffsetX,
	Float:zbs_fOffsetY,
	Float:zbs_fOffsetZ,
	Float:zbs_fRotX,
	Float:zbs_fRotY,
	Float:zbs_fRotZ,
	Float:zbs_fScaleX,
	Float:zbs_fScaleY,
	Float:zbs_fScaleZ,
	zbs_materialcolor1,
	zbs_materialcolor2,
	zbs_iscol,
	zbs_jcoltime,
	zbs_ismater
}
new Pzbs[MAX_ZB][MAX_PLAYER_ATTACHED_OBJECTS-1][zbsdate];
new Iterator:Pzbs[MAX_ZB]<MAX_PLAYER_ATTACHED_OBJECTS-1>;
Function LoadZB_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_ZB)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,26), i);
        if(fexist(NameFile))
        {
       		INI_ParseFile(Get_Path(i,26), "LoadZBData", false, true, i, true, false);
       		LoadZBS(i);
       		Iter_Add(Pzb,i);
       		idx++;
       	}
    }
    return idx;
}
Function LoadZBData(i, name[], value[])
{
    INI_Int("zb_uid",Pzb[i][zb_uid]);
    INI_Int("zb_cash",Pzb[i][zb_cash]);
    INI_Int("zb_issell",Pzb[i][zb_issell]);
    INI_String("zb_name",Pzb[i][zb_name],100);
	return 1;
}
Function SavedZB_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,26));
    INI_WriteInt(File,"zb_uid",Pzb[Count][zb_uid]);
    INI_WriteInt(File,"zb_cash",Pzb[Count][zb_cash]);
    INI_WriteInt(File,"zb_issell",Pzb[Count][zb_issell]);
    INI_WriteString(File,"zb_name",Pzb[Count][zb_name]);
    INI_Close(File);
	return true;
}
Function LoadZBS(idx)
{
	new strings[4128],ids=0;
    if(fexist(Get_Path(idx,27)))
    {
		new File:attfile = fopen(Get_Path(idx,27), io_read);
    	if(attfile)
    	{
        	while(fread(attfile, strings))
        	{
        	    if(strlenEx(strings)>3)
        	    {
	        	    if(ids<MAX_PLAYER_ATTACHED_OBJECTS-1)
	        	    {
		        		sscanf(strings, "p<,>iiiifffffffffiiiii",
							Pzbs[idx][ids][zbs_did],
							Pzbs[idx][ids][zbs_type],
							Pzbs[idx][ids][zbs_modelid],
							Pzbs[idx][ids][zbs_boneid],
							Pzbs[idx][ids][zbs_fOffsetX],
							Pzbs[idx][ids][zbs_fOffsetY],
							Pzbs[idx][ids][zbs_fOffsetZ],
							Pzbs[idx][ids][zbs_fRotX],
							Pzbs[idx][ids][zbs_fRotY],
							Pzbs[idx][ids][zbs_fRotZ],
							Pzbs[idx][ids][zbs_fScaleX],
							Pzbs[idx][ids][zbs_fScaleY],
							Pzbs[idx][ids][zbs_fScaleZ],
							Pzbs[idx][ids][zbs_materialcolor1],
							Pzbs[idx][ids][zbs_materialcolor2],
							Pzbs[idx][ids][zbs_iscol],
							Pzbs[idx][ids][zbs_jcoltime],
							Pzbs[idx][ids][zbs_ismater]
						);
						Iter_Add(Pzbs[idx],ids);
						ids++;
					}
				}
        	}
        	fclose(attfile);
    	}
    }
	return 1;
}
Function SaveZBS(idx)
{
	new strings[4128];
    if(fexist(Get_Path(idx,27)))fremove(Get_Path(idx,27));
	new File:attfile = fopen(Get_Path(idx,27), io_write);
    foreach(new i:Pzbs[idx])
	{
		format(strings,sizeof(strings),"%s %d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d,%d,%d,%d,%d\r\n",strings,
			Pzbs[idx][i][zbs_did],
			Pzbs[idx][i][zbs_type],
			Pzbs[idx][i][zbs_modelid],
			Pzbs[idx][i][zbs_boneid],
			Pzbs[idx][i][zbs_fOffsetX],
			Pzbs[idx][i][zbs_fOffsetY],
			Pzbs[idx][i][zbs_fOffsetZ],
			Pzbs[idx][i][zbs_fRotX],
			Pzbs[idx][i][zbs_fRotY],
			Pzbs[idx][i][zbs_fRotZ],
			Pzbs[idx][i][zbs_fScaleX],
			Pzbs[idx][i][zbs_fScaleY],
			Pzbs[idx][i][zbs_fScaleZ],
			Pzbs[idx][i][zbs_materialcolor1],
			Pzbs[idx][i][zbs_materialcolor2],
			Pzbs[idx][i][zbs_iscol],
			Pzbs[idx][i][zbs_jcoltime],
			Pzbs[idx][i][zbs_ismater]
		);
	}
	fwrite(attfile,strings);
    fclose(attfile);
	return 1;
}
Dialog:dl_myzbdb(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext,1,0);
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid,dl_myzbdb, DIALOG_STYLE_INPUT, "填写错误", "请给要打包的装备命名", "确定", "取消");
		new i=Iter_Free(Pzb);
		if(i==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_INPUT, "错误", "世界仓库数量已满", "额", "");
		Pzb[i][zb_uid]=PU[playerid];
		Pzb[i][zb_cash]=0;
		Pzb[i][zb_issell]=0;
		format(Pzb[i][zb_name],100,inputtext);
		Iter_Add(Pzb,i);
		Iter_Clear(Pzbs[i]);
		foreach(new idx:att[playerid])
		{
		    new x=Iter_Free(Pzbs[i]);
		    if(x!=-1)
		    {
				Pzbs[i][x][zbs_did]=att[playerid][idx][att_did];
				Pzbs[i][x][zbs_type]=att[playerid][idx][att_type];
				Pzbs[i][x][zbs_modelid]=att[playerid][idx][att_modelid];
				Pzbs[i][x][zbs_boneid]=att[playerid][idx][att_boneid];
				Pzbs[i][x][zbs_fOffsetX]=att[playerid][idx][att_fOffsetX];
				Pzbs[i][x][zbs_fOffsetY]=att[playerid][idx][att_fOffsetY];
				Pzbs[i][x][zbs_fOffsetZ]=att[playerid][idx][att_fOffsetZ];
				Pzbs[i][x][zbs_fRotX]=att[playerid][idx][att_fRotX];
				Pzbs[i][x][zbs_fRotY]=att[playerid][idx][att_fRotY];
				Pzbs[i][x][zbs_fRotZ]=att[playerid][idx][att_fRotZ];
				Pzbs[i][x][zbs_fScaleX]=att[playerid][idx][att_fScaleX];
				Pzbs[i][x][zbs_fScaleY]=att[playerid][idx][att_fScaleY];
				Pzbs[i][x][zbs_fScaleZ]=att[playerid][idx][att_fScaleZ];
				Pzbs[i][x][zbs_materialcolor1]=att[playerid][idx][att_materialcolor1];
				Pzbs[i][x][zbs_materialcolor2]=att[playerid][idx][att_materialcolor2];
				Pzbs[i][x][zbs_iscol]=att[playerid][idx][att_iscol];
				Pzbs[i][x][zbs_jcoltime]=att[playerid][idx][att_jcoltime];
				Pzbs[i][x][zbs_ismater]=att[playerid][idx][att_ismater];
				Iter_Add(Pzbs[i],x);
		    }
		}
		SaveZBS(i);
		Iter_Clear(att[playerid]);
		Iter_Clear(sat[playerid]);
		new Stru[64];
 	    format(Stru,sizeof(Stru),USER_ZB_FILE,Gnn(playerid));
	    if(fexist(Stru))fremove(Stru);
	    Loop(q,MAX_PLAYER_ATTACHED_OBJECTS-1)RemovePlayerAttachedObject(playerid, q);
		SavedZB_data(i);
	}
	return 1;
}
stock Endbt(listid)
{
	new amou=0;
   	foreach(new x:Pzb)
	{
		if(Pzb[x][zb_uid]==listid)
		{
	   		if(Pzb[x][zb_issell])amou++;
	   	}
	}
	if(!amou)
	{
	    new idf=chackonlineEX(listid);
	    if(idf!=-1)
	    {
		    if(pstat[idf]==BT)
		    {
	            ClearAnimations(idf);
	            RemovePlayerAttachedObject(idf,9);
	            if(IsValidDynamicArea(UID[PU[idf]][u_area]))
	            {
	                DestroyDynamicArea(UID[PU[idf]][u_area]);
	                UID[PU[idf]][u_area]=-1;
	            }
	    		pstat[idf]=NO_MODE;
	    		TogglePlayerControllable(idf,1);
	    		UpdateColor3DTextLabelText(Sell3D[idf],-1,"");
	    		Dialog_Show(idf, dl_msg, DIALOG_STYLE_MSGBOX, "自动收摊","你的装扮包已销售一空", "额", "");
		    }
	    }
	}
	return 1;
}
Dialog:dl_sellcksz(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"listIDA");
    if(!Iter_Contains(Pzb,listid))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "此包已失效[售出或销毁]", "额..", "");
	if(!Pzb[listid][zb_issell])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "此包已失效[售出或销毁]", "额..", "");
	if(response)
	{
        if(!EnoughMoneyEx(playerid,Pzb[listid][zb_cash]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱", "额", "");
        Moneyhandle(PU[playerid],-Pzb[listid][zb_cash]);
        new tm[150];
	    format(tm,150,"%s购买了你出售的装扮包[%s]花费$%i,请提取",Gn(playerid),Pzb[listid][zb_name],Pzb[listid][zb_cash]);
		AddPlayerLog(Pzb[listid][zb_uid],"系统",tm,Pzb[listid][zb_cash]);
        Pzb[listid][zb_uid]=PU[playerid];
        Pzb[listid][zb_issell]=0;
        Pzb[listid][zb_cash]=0;
        SavedZB_data(listid);
		Endbt(listid);
 	}
 	else
 	{
		Loop(i,MAX_PLAYER_ATTACHED_OBJECTS-1)RemovePlayerAttachedObject(playerid, i);
		foreach(new x:Pzbs[listid])
		{
	    	SetPlayerAttachedObjectEx(playerid,
			Pzbs[listid][x][zbs_modelid],
			Pzbs[listid][x][zbs_boneid],
			Pzbs[listid][x][zbs_fOffsetX],
			Pzbs[listid][x][zbs_fOffsetY],
			Pzbs[listid][x][zbs_fOffsetZ],
			Pzbs[listid][x][zbs_fRotX],
			Pzbs[listid][x][zbs_fRotY],
			Pzbs[listid][x][zbs_fRotZ],
			Pzbs[listid][x][zbs_fScaleX],
			Pzbs[listid][x][zbs_fScaleY],
			Pzbs[listid][x][zbs_fScaleZ],
			Pzbs[listid][x][zbs_materialcolor1],
			Pzbs[listid][x][zbs_materialcolor2],
			Pzbs[listid][x][zbs_iscol],
			Pzbs[listid][x][zbs_jcoltime],
			Pzbs[listid][x][zbs_ismater]
			);
		}
 	}
	return 1;
}
Dialog:dl_sellck(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_sellck, DIALOG_STYLE_LIST,"仓库物品出售", Showsellcklist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	    else if(current_number[playerid]-1==0)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "没用东西了额", "好的", "");
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_sellcksz,DIALOG_STYLE_MSGBOX,"装扮包详情",Showzbinfo(listid),"购买", "预览");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_sellck, DIALOG_STYLE_LIST,"仓库物品出售", Showsellcklist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
stock Showsellcklist(playerid,pager)
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
            format(tmps,100,"%s $%i\n",Pzb[current_idx[playerid][i]][zb_name],Pzb[current_idx[playerid][i]][zb_cash]);
		}
		if(i>=current_number[playerid])
		{
			if(current_number[playerid]-1==0)
			{
				strcat(tmp,"无");
				return tmp;
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
stock Showmycklist(playerid,pager)
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
            if(Pzb[current_idx[playerid][i]][zb_issell])format(tmps,100,"[出售中]%s\n",Pzb[current_idx[playerid][i]][zb_name]);
            else format(tmps,100,"[未售中]%s\n",Pzb[current_idx[playerid][i]][zb_name]);
		}
		if(i>=current_number[playerid])
		{
			if(current_number[playerid]-1==0)
			{
				strcat(tmp,"无");
				return tmp;
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

CMD:wdck(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
	foreach(new i:Pzb)
	{
	    if(Pzb[i][zb_uid]==PU[playerid])
	    {
			current_idx[playerid][current_number[playerid]]=i;
	       	current_number[playerid]++;
	       	current++;
	    }
	}
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的仓库 - 共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_myck, DIALOG_STYLE_LIST,tm, Showmycklist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showzbinfo(idx)
{
	new Astr[512],Str[80];
	format(Str, sizeof(Str), "包名:%s\n",Pzb[idx][zb_name]);
	strcat(Astr,Str);
	format(Str, sizeof(Str), "家具组件数量:%i个\n",Iter_Count(Pzbs[idx]));
	strcat(Astr,Str);
	if(Pzb[idx][zb_issell])format(Str, sizeof(Str), "出售:是\n出售价格:$%i\n",Pzb[idx][zb_cash]);
	else format(Str, sizeof(Str), "出售:否",Pzb[idx][zb_name]);
	strcat(Astr,Str);
	return Astr;
}
Dialog:dl_mycksz(playerid, response, listitem, inputtext[])
{
	if(response)Dialog_Show(playerid,dl_myckszcz,DIALOG_STYLE_LIST,"装扮包操作","装扮身上\n重新命名\n设置出售\n抛弃此包","确定", "取消");
	return 1;
}
stock ZbtoAtt(playerid,idx)
{
	Iter_Clear(att[playerid]);
	Iter_Clear(sat[playerid]);
	new Stru[64];
 	format(Stru,sizeof(Stru),USER_ZB_FILE,Gnn(playerid));
	if(fexist(Stru))fremove(Stru);
	Loop(q,MAX_PLAYER_ATTACHED_OBJECTS-1)RemovePlayerAttachedObject(playerid, q);
	foreach(new x:Pzbs[idx])
	{
    	new i=SetPlayerAttachedObjectEx(playerid,0,0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0);
		att[playerid][i][att_did]=Pzbs[idx][x][zbs_did];
		att[playerid][i][att_type]=Pzbs[idx][x][zbs_type];
		att[playerid][i][att_modelid]=Pzbs[idx][x][zbs_modelid];
		att[playerid][i][att_boneid]=Pzbs[idx][x][zbs_boneid];
		att[playerid][i][att_fOffsetX]=Pzbs[idx][x][zbs_fOffsetX];
		att[playerid][i][att_fOffsetY]=Pzbs[idx][x][zbs_fOffsetY];
		att[playerid][i][att_fOffsetZ]=Pzbs[idx][x][zbs_fOffsetZ];
		att[playerid][i][att_fRotX]=Pzbs[idx][x][zbs_fRotX];
		att[playerid][i][att_fRotY]=Pzbs[idx][x][zbs_fRotY];
		att[playerid][i][att_fRotZ]=Pzbs[idx][x][zbs_fRotZ];
		att[playerid][i][att_fScaleX]=Pzbs[idx][x][zbs_fScaleX];
		att[playerid][i][att_fScaleY]=Pzbs[idx][x][zbs_fScaleY];
		att[playerid][i][att_fScaleZ]=Pzbs[idx][x][zbs_fScaleZ];
		att[playerid][i][att_materialcolor1]=Pzbs[idx][x][zbs_materialcolor1];
		att[playerid][i][att_materialcolor2]=Pzbs[idx][x][zbs_materialcolor2];
		att[playerid][i][att_iscol]=Pzbs[idx][x][zbs_iscol];
		att[playerid][i][att_jcoltime]=Pzbs[idx][x][zbs_jcoltime];
		att[playerid][i][att_ismater]=Pzbs[idx][x][zbs_ismater];
		UpdatePlayerAttachedObjectEx(playerid,i,
		att[playerid][i][att_modelid],
		att[playerid][i][att_boneid],
		att[playerid][i][att_fOffsetX],
		att[playerid][i][att_fOffsetY],
		att[playerid][i][att_fOffsetZ],
		att[playerid][i][att_fRotX],
		att[playerid][i][att_fRotY],
		att[playerid][i][att_fRotZ],
		att[playerid][i][att_fScaleX],
		att[playerid][i][att_fScaleY],
		att[playerid][i][att_fScaleZ],
		att[playerid][i][att_materialcolor1],
		att[playerid][i][att_materialcolor2],
		att[playerid][i][att_iscol],
		att[playerid][i][att_jcoltime],
		att[playerid][i][att_ismater]
		);
		Iter_Add(att[playerid],i);
	}
	Iter_Remove(Pzb,idx);
	Iter_Clear(Pzbs[idx]);
	if(fexist(Get_Path(idx,26)))fremove(Get_Path(idx,26));
	if(fexist(Get_Path(idx,27)))fremove(Get_Path(idx,27));
	SaveAtt(playerid);
	return 1;
}
Dialog:dl_myzbtx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(!Iter_Contains(Pzb,listid)||Pzb[listid][zb_uid]!=PU[playerid])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "此包已失效[售出或销毁]", "额..", "");
		ZbtoAtt(playerid,listid);
	}
	return 1;
}
Dialog:dl_myzbszjg(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext)<=0||strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid, dl_myzbszjg, DIALOG_STYLE_INPUT, "设置价格数值错误", "请输入你想要出售的价格", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(!Iter_Contains(Pzb,listid)||Pzb[listid][zb_uid]!=PU[playerid])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "此包已失效[售出或销毁]", "额..", "");
		Pzb[listid][zb_cash]=strval(inputtext);
		Pzb[listid][zb_issell]=1;
		SavedZB_data(listid);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdck");
 	}
	return 1;
}
Dialog:dl_myzbmm(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext,1,0);
		if(strlenEx(inputtext)>20||strlenEx(inputtext)<3)return Dialog_Show(playerid, dl_myzbmm, DIALOG_STYLE_INPUT, "字符错误", "请输入名称", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(!Iter_Contains(Pzb,listid)||Pzb[listid][zb_uid]!=PU[playerid])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "此包已失效[售出或销毁]", "额..", "");
		format(Pzb[listid][zb_name],100,inputtext);
		SavedZB_data(listid);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdck");
 	}
	return 1;
}
Dialog:dl_myckszcz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    if(!Iter_Contains(Pzb,listid)||Pzb[listid][zb_uid]!=PU[playerid])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "此包已失效[售出或销毁]", "额..", "");
	   	switch(listitem)
	   	{
		   	case 0:
			{
			    if(Pzb[listid][zb_issell])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "请先取消此物品出售状态", "额..", "");
			    Dialog_Show(playerid, dl_myzbtx, DIALOG_STYLE_MSGBOX, "提醒", "请确保你身上的装扮已卸下，否则被覆盖，概不赔偿", "继续操作", "取消操作");
			}
		   	case 1:
			{
			    if(Pzb[listid][zb_issell])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "请先取消此物品出售状态", "额..", "");
			    Dialog_Show(playerid, dl_myzbmm, DIALOG_STYLE_INPUT, "设置名称", "请输入名称", "确定", "取消");
			}
			case 2:
		   	{
		   	    if(Pzb[listid][zb_issell])
		   	    {
		   	        Pzb[listid][zb_cash]=0;
		   	        Pzb[listid][zb_issell]=0;
		   	        SavedZB_data(listid);
		   	        CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdck");
		   	    }
		   	    else Dialog_Show(playerid, dl_myzbszjg, DIALOG_STYLE_INPUT, "设置价格", "请输入你想要出售的价格", "确定", "取消");
		   	}
		   	case 3:
		   	{
			    if(Pzb[listid][zb_issell])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "请先取消此物品出售状态", "额..", "");
				Iter_Remove(Pzb,listid);
				Iter_Clear(Pzbs[listid]);
				if(fexist(Get_Path(listid,26)))fremove(Get_Path(listid,26));
				if(fexist(Get_Path(listid,27)))fremove(Get_Path(listid,27));
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdck");
		   	}
		}
	}
	return 1;
}

Dialog:dl_myck(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_myck, DIALOG_STYLE_LIST,"我的仓库", Showmycklist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	    else if(current_number[playerid]-1==0)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "你的仓库里没有装扮套装\n请去/WDZB打包装备", "好的", "");
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mycksz,DIALOG_STYLE_MSGBOX,"装扮包详情",Showzbinfo(listid),"操作", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_myck, DIALOG_STYLE_LIST,"我的仓库", Showmybaglist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_shoutan(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(pstat[playerid]==BT)
	    {
            ClearAnimations(playerid);
            RemovePlayerAttachedObject(playerid,9);
            if(IsValidDynamicArea(UID[PU[playerid]][u_area]))
            {
                DestroyDynamicArea(UID[PU[playerid]][u_area]);
                UID[PU[playerid]][u_area]=-1;
            }
    		pstat[playerid]=NO_MODE;
    		TogglePlayerControllable(playerid,1);
    		UpdateColor3DTextLabelText(Sell3D[playerid],-1,"");
	    }
	}
	return 1;
}
Dialog:dl_btsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    ReStr(inputtext,1,0);
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid,dl_btsz, DIALOG_STYLE_INPUT, "字符错误", "请重新输入宣传语", "确定", "取消");
	    SetPlayerAttachedObject(playerid,9,1805,1,-0.587999,0.268999,0.194999,-47.999961,129.300018,158.399963,1.000000, 1.000000, 1.000000);
		TogglePlayerControllable(playerid,0);
		new Float:xyz[3];
		GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
		UID[PU[playerid]][u_area]=CreateDynamicCylinder(xyz[0],xyz[1],xyz[2]-2,xyz[2]+2,2,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
	    ApplyAnimation(playerid,"INT_OFFICE", "OFF_Sit_Bored_Loop", 1.800001, 1, 0, 0, 1, 600);
	    pstat[playerid]=BT;
        UpdateColor3DTextLabelText(Sell3D[playerid],-1,inputtext);
        RegulateColor3DTextLabel(Sell3D[playerid],1,2);
	}
	return 1;
}
CMD:bt(playerid, params[], help)
{
	if(pcurrent_jj[playerid]!=-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你需要先放下手中举起的家具", "额", "");
    if(GetPlayerState(playerid)!= 1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你必须步行才能摆摊", "额", "");
	new idx=0;
	foreach(new i:Pzb)
	{
	    if(Pzb[i][zb_uid]==PU[playerid])
	    {
   			if(Pzb[i][zb_issell])idx++;
	    }
	}
	if(!idx)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你没有装扮包出售,/WDCK 设置出售", "额", "");
	Dialog_Show(playerid, dl_btsz, DIALOG_STYLE_INPUT, "设置宣传语", "请输入宣传语", "确定", "取消");
	return 1;
}
