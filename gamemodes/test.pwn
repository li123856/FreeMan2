Dialog:dl_djsearch(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(strval(inputtext)< 1)return Dialog_Show(playerid,dl_djsearch,DIALOG_STYLE_INPUT,"请输入搜索ID","搜索ID","搜索", "取消");
        new ridx=-1;
	  	foreach(new oid:Daoju)
		{
			if(Daoju[oid][d_obj]==strval(inputtext))
			{
                ridx++;
                SetPVarInt(playerid,"listIDA",oid);
				Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(oid),"选择", "取消");
				break;
			}
		}
		if(ridx==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","没有找到此道具", "好的", "");
	}
	return 1;
}
Function LoadDaoju_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_DAOJU)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,6), i);
        if(fexist(NameFile))
        {
       		INI_ParseFile(Get_Path(i,6), "LoadDaojuData", false, true, i, true, false);
       		Daoju[i][d_did]=i;
       		Iter_Add(Daoju,i);
       		idx++;
       	}
    }
    return idx;
}
Function LoadDaojuData(i, name[], value[])
{
    INI_Int("d_new",Daoju[i][d_new]);
    INI_Int("d_use",Daoju[i][d_use]);
    INI_Int("d_obj",Daoju[i][d_obj]);
    INI_Int("d_type",Daoju[i][d_type]);
    INI_Int("d_cash",Daoju[i][d_cash]);
    INI_Int("d_issell",Daoju[i][d_issell]);
    INI_String("d_name",Daoju[i][d_name],128);
	return 1;
}
Function Saveddaoju_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,6));
    INI_WriteInt(File,"d_new",Daoju[Count][d_new]);
    INI_WriteInt(File,"d_use",Daoju[Count][d_use]);
    INI_WriteInt(File,"d_obj",Daoju[Count][d_obj]);
    INI_WriteInt(File,"d_type",Daoju[Count][d_type]);
    INI_WriteInt(File,"d_cash",Daoju[Count][d_cash]);
    INI_WriteInt(File,"d_issell",Daoju[Count][d_issell]);
    INI_WriteString(File,"d_name",Daoju[Count][d_name]);
    INI_Close(File);
	return true;
}
CMD:wdbb1(playerid, params[], help)
{
	current_number[playerid]=1;
	new amout=0,current=-1;
	foreach(new i:Beibao[playerid])
	{
		current_idx[playerid][current_number[playerid]]=i;
		amout+=GetBeibaoAmout(playerid,Beibao[playerid][i][b_did]);
       	current_number[playerid]++;
       	current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，你的背包里没有东西", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的背包 - 种类共计[%i] - 数量总计:[%i]",current_number[playerid]-1,amout);
	Dialog_Show(playerid, dl_mybag, DIALOG_STYLE_LIST,tm, Showmybaglist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
CMD:wdbb(playerid, params[], help)
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
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_BB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
Dialog:dl_mybag(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_mybag, DIALOG_STYLE_LIST,"我的背包", Showmybaglist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	    else if(current_number[playerid]-1==0)return 1;
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mybagcaozuo,DIALOG_STYLE_LIST,"道具操作","拿出道具\n装备武器\n装扮上身\n装备爱车\n销毁道具","确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_mybag, DIALOG_STYLE_LIST,"我的背包", Showmybaglist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_dj(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_dj, DIALOG_STYLE_LIST,"世界道具", Showdjlist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
			new i=Iter_Free(fonts);
			if(i==-1)return SM(COLOR_ORANGE,"全服道具数量已达到上限");
			Dialog_Show(playerid, dl_cdj, DIALOG_STYLE_INPUT, "创建道具", "请输入 名称,类型,模型,价格,是否售卖[0/1]", "创建", "取消");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_dj, DIALOG_STYLE_LIST,"世界道具", Showdjlist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
djsz_Dialog_Show(listid)
{
	new tmps[512],tmp[100];
	format(tmp,100,"名称:%s\n",Daoju[listid][d_name]);
	strcat(tmps,tmp);
	format(tmp,100,"类型:%i\n",Daoju[listid][d_type]);
	strcat(tmps,tmp);
	format(tmp,100,"模型:%i\n",Daoju[listid][d_obj]);
	strcat(tmps,tmp);
	format(tmp,100,"价格:$%i\n",Daoju[listid][d_cash]);
	strcat(tmps,tmp);
	if(Daoju[listid][d_issell]==1)format(tmp,100,"是否出售:是\n");
	else format(tmp,100,"是否出售:否\n");
	strcat(tmps,tmp);
	format(tmp,100,"创建道具\n");
	strcat(tmps,tmp);
	format(tmp,100,"删除道具");
	strcat(tmps,tmp);
	return tmps;
}
Dialog:dl_cdj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new type,name[128],obj,cash,issell;
		ReColor(inputtext);
		if(sscanf(inputtext, "p<,>s[128]iiii",name,type,obj,cash,issell))return Dialog_Show(playerid, dl_cdj, DIALOG_STYLE_INPUT, "创建道具", "请输入 名称,类型,模型,价格,是否售卖[0/1]", "创建", "取消");
        if(strlenEx(name)<1)return Dialog_Show(playerid, dl_cdj, DIALOG_STYLE_INPUT, "错误", "道具名称过短,请重新输入", "创建", "取消");
        new i=Iter_Free(Daoju);
        format(Daoju[i][d_name],128,name);
        Daoju[i][d_type]=type;
        Daoju[i][d_obj]=obj;
        Daoju[i][d_cash]=cash;
		Daoju[i][d_issell]=issell;
        Daoju[i][d_did]=i;
        Iter_Add(Daoju,i);
	 	Saveddaoju_data(i);
	}
	return 1;
}
Dialog:dl_djgname(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
        new name[128];
        ReStr(inputtext);
		if(sscanf(inputtext, "s[128]",name))return Dialog_Show(playerid, dl_djgname, DIALOG_STYLE_INPUT, "修改道具名", "请输入名称", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
        if(strlenEx(name)<1)return Dialog_Show(playerid, dl_djgname, DIALOG_STYLE_INPUT, "修改道具名", "请输入名称", "确定", "取消");
        format(Daoju[listid][d_name],128,name);
	 	Saveddaoju_data(listid);
	 	Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
	}
	return 1;
}
Dialog:dl_djgleixing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
        new type;
		if(sscanf(inputtext, "i",type))return Dialog_Show(playerid, dl_djgleixing, DIALOG_STYLE_INPUT, "修改类型", "请输入类型", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
        if(type<0)return Dialog_Show(playerid, dl_djgleixing, DIALOG_STYLE_INPUT, "修改类型", "请输入类型", "确定", "取消");
        Daoju[listid][d_type]=type;
	 	Saveddaoju_data(listid);
	 	Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
	}
	return 1;
}
Dialog:dl_djgmoxing(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
        new moxing;
		if(sscanf(inputtext, "i",moxing))return Dialog_Show(playerid, dl_djgmoxing, DIALOG_STYLE_INPUT, "修改模型", "请输入模型", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
        if(moxing<0)return Dialog_Show(playerid, dl_djgmoxing, DIALOG_STYLE_INPUT, "修改模型", "请输入模型", "确定", "取消");
        Daoju[listid][d_obj]=moxing;
	 	Saveddaoju_data(listid);
	 	Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
	}
	return 1;
}
Dialog:dl_djgjiage(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
        new jiage;
		if(sscanf(inputtext, "i",jiage))return Dialog_Show(playerid, dl_djgjiage, DIALOG_STYLE_INPUT, "修改价格", "请输入价格", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
        if(jiage<0)return Dialog_Show(playerid, dl_djgjiage, DIALOG_STYLE_INPUT, "修改价格", "请输入价格", "确定", "取消");
        Daoju[listid][d_cash]=jiage;
	 	Saveddaoju_data(listid);
	 	Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
	}
	return 1;
}
Dialog:dl_djcjdj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
        new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_djcjdj, DIALOG_STYLE_INPUT, "创建道具", "请输入创建个数", "确定", "取消");
	    new listid=GetPVarInt(playerid,"listIDA");
        if(amout<0)return Dialog_Show(playerid, dl_djcjdj, DIALOG_STYLE_INPUT, "创建道具", "请输入创建个数", "确定", "取消");
        Addbeibao(playerid,Daoju[listid][d_did],amout);
        Daoju[listid][d_use]=1;
        Saveddaoju_data(listid);
        CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdbb");
		new Str[128];
		format(Str,sizeof(Str),"%s创建了%i个%s,背包该物品剩余%i",Gnn(playerid),amout,Daoju[Daoju[listid][d_did]][d_name],GetBeibaoAmout(playerid,Daoju[listid][d_did]));
		AdminWarn(Str);
	}
	return 1;
}
Dialog:dl_djsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(GetadminLevel(playerid)<3000) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
		new listid=GetPVarInt(playerid,"listIDA");
		switch(listitem)
		{
			case 0:
			{
				Dialog_Show(playerid, dl_djgname, DIALOG_STYLE_INPUT, "修改道具名", "请输入名称", "确定", "取消");
			}
            case 1:
            {
				Dialog_Show(playerid, dl_djgleixing, DIALOG_STYLE_INPUT, "修改类型", "请输入类型", "确定", "取消");
            }
            case 2:
            {
				Dialog_Show(playerid, dl_djgmoxing, DIALOG_STYLE_INPUT, "修改模型", "请输入模型", "确定", "取消");
            }
            case 3:
            {
				Dialog_Show(playerid, dl_djgjiage, DIALOG_STYLE_INPUT, "修改价格", "请输入价格", "确定", "取消");
            }
            case 4:
            {

				if(Daoju[listid][d_issell]==1)Daoju[listid][d_issell]=0;
				else Daoju[listid][d_issell]=1;
				Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
            }
            case 5:
            {
        		Dialog_Show(playerid, dl_djcjdj, DIALOG_STYLE_INPUT, "创建道具", "请输入创建个数", "确定", "取消");
            }
            case 6:
            {
				new tm[100];
				format(tm,100,"道具%i[%s]删除成功",listid,Daoju[listid][d_name]);
				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示",tm, "好的", "");
    			fremove(Get_Path(listid,6));
				Iter_Remove(Daoju,listid);
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/addj");
            }
		}
	}
	return 1;
}
stock Showdjlist(playerid,pager)
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
			format(tmps,100,"[ID:%i]道具名:%s - 点击详情\n",Daoju[current_idx[playerid][i]][d_did],Daoju[current_idx[playerid][i]][d_name]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}添加新的道具");
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


stock seachmodel(model)
{
	foreach(new i:Daoju)
	{
		if(model==Daoju[i][d_obj])return i;
	}
	return -1;
}
public OnPlayerModelSelectionEx(playerid, response, extraid, modelid,listitem)
{
    Hidetab(playerid);
	if(response)
	{
	    switch (extraid)
	    {
	        case CUSTOM_NEAR_JJ_MENU:
	        {
				if(pcurrent_jj[playerid]==-1)
				{
					if(pstat[playerid]!=NO_MODE)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你在其他模式下无法操作家具", "好的", "");
					new idx=current_idx[playerid][listitem];
					if(idx!=-1)
					{
						if(GetAreaJJprotectEx(idx,playerid)||Ishousepro(playerid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","地盘或房产已开启家具保护，无法操作家具", "好的", "");
						if(!IsPlayerInRangeOfPoint(playerid,60,JJ[idx][jx],JJ[idx][jy],JJ[idx][jz]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你不在该家具附近", "好的", "");
						if(JJ[idx][jused]==false)
					    {
							if(JJ[idx][juid]==PU[playerid])
							{
								new tm[64];
								format(tm,64,"家具:%s  操作",Daoju[JJ[idx][jdid]][d_name]);
								Dialog_Show(playerid,dl_jiajusz,DIALOG_STYLE_LIST,tm,"拿起家具\n编辑家具\n标签变色\n家具材质\n家具文字\n家具移动\n家具旋转\n装备家具\n放入背包","确定", "取消");
		                        pcurrent_jj[playerid]=idx;
							}
							else
							{
								new tm[64];
								format(tm,64,"家具:%s  操作",Daoju[JJ[idx][jdid]][d_name]);
		   						Dialog_Show(playerid,dl_jiajusz,DIALOG_STYLE_LIST,tm,"拿起家具\n编辑家具\n标签变色\n家具材质\n家具文字\n家具移动\n家具旋转\n装备家具\n放入背包","确定", "取消");
		                        pcurrent_jj[playerid]=idx;
							}
							JJ[pcurrent_jj[playerid]][j_caxin]=Now();
							UpdateJJtext(pcurrent_jj[playerid]);
							Savedjj_data(pcurrent_jj[playerid]);
						}
						else
						{
							new tm[64];
							format(tm,64,"家具:%s  正在被其他人操作",Daoju[JJ[idx][jdid]][d_name]);
						    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "好的", "");
						    pcurrent_jj[playerid]=-1;
						}
					}
					else
		        	{
		        		pcurrent_jj[playerid]=-1;
		        	}
		        }
				else Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你正忙!", "好的", "");
	        }
	        case CUSTOM_PRO_EDIT_SELLBB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid, dl_edit_selldaodu, DIALOG_STYLE_MSGBOX, "提示", "是否取消此物品的出售", "确定", "取消");
	        }
	        case CUSTOM_PRO_EDIT_BUYBB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid, dl_edit_buydaodu, DIALOG_STYLE_MSGBOX, "提示", "是否取消此物品的收购", "确定", "取消");
	        }
	        case CUSTOM_PRO_PLAYER_BUYBB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
                new hid=GetPVarInt(playerid,"houseid");
                new	tm[100];
				format(tm,100,"本店铺尚有道具%s %i个,每个出售价格为$%i,请输入购买的个数",Daoju[prostock[hid][listid][ps_did]][d_name],prostock[hid][listid][ps_amout],prostock[hid][listid][ps_value]);
				Dialog_Show(playerid, dl_player_buydaodu, DIALOG_STYLE_INPUT, "提示",tm, "确定", "取消");
	        }
	        case CUSTOM_PRO_PLAYER_SELLBB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
                new hid=GetPVarInt(playerid,"houseid");
                if(GetBeibaoAmout(playerid,prostock[hid][listid][ps_did])<1)return Dialog_Show(playerid,dl_error, DIALOG_STYLE_MSGBOX, "提示", "你的背包里没那么多此物品可以出售", "确定", "取消");
                new	tm[100];
				format(tm,100,"本店铺收购道具%s %i个,每个收购价格为$%i,你当前背包里有%i个\n请输入你要出售的个数",Daoju[prostock[hid][listid][ps_did]][d_name],prostock[hid][listid][ps_amout],prostock[hid][listid][ps_value],GetBeibaoAmout(playerid,prostock[hid][listid][ps_did]));
				Dialog_Show(playerid, dl_player_selldaodu, DIALOG_STYLE_INPUT, "提示",tm, "确定", "取消");
	        }
	        case CUSTOM_PRO_SELLBB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid, dl_setprosellamout, DIALOG_STYLE_INPUT, "请设置上架个数", "请输入数量", "确定", "取消");
	        }
	        case CUSTOM_PRO_BUYBB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid, dl_setprobuyamout, DIALOG_STYLE_INPUT, "请设置收购个数", "请输入数量", "确定", "取消");
	        }
	        case CUSTOM_FRIEND_BB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDB",listid);
				Dialog_Show(playerid,dl_myfriendfsdjsl,DIALOG_STYLE_INPUT,"发送道具","请输入道具数量","确定", "取消");
	        }
	        case CUSTOM_EBUY_BB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDB",listid);
				Dialog_Show(playerid,dl_addebuyjj,DIALOG_STYLE_INPUT,"商品上架","请输入要出售的个数","确定", "取消");
	        }
	        case CUSTOM_BB_MENU:
	        {
				new listid=current_idx[playerid][listitem];
                SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid,dl_mybagcaozuo,DIALOG_STYLE_LIST,"道具操作","拿出道具\n装备武器\n装扮上身\n装备爱车\n销毁道具","确定", "取消");
	        }
	        case CUSTOM_DAOJU_MENU:
	        {
				new listid=current_idx[playerid][listitem];
				SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid,dl_djsz,DIALOG_STYLE_LIST,"道具设置-点击设置",djsz_Dialog_Show(listid),"选择", "取消");
	        }
	        case CUSTOM_SKIN_MENU:
	        {
				new listid=current_idx[playerid][listitem];
				UID[PU[playerid]][u_Skin]=SkinList[listid];
				Saveduid_data(PU[playerid]);
                SetPlayerSkin(playerid,UID[PU[playerid]][u_Skin]);
	        }
	        case CUSTOM_WEAPON_MENU:
	        {
				new listid=current_idx[playerid][listitem];
				SetPVarInt(playerid,"listIDA",listid);
				Dialog_Show(playerid,dl_wquisz,DIALOG_STYLE_LIST,"武器设置","放入背包\n抛弃武器","选择", "取消");
	        }
			case CUSTOM_RACE_MENU:
			{
				new rid=current_idx[playerid][listitem];
				if(!Itter_Contains(RACE_ROM,rid))return SM(COLOR_TWAQUA,"错误比赛已不存在");
			    if(RACE_ROM[rid][RACE_STAT]!=RACE_WAIT) return SM(COLOR_TWAQUA, "此比赛已开始了，无法加入");
			    if(GRRPS(rid)<R_RACE[RACE_ROM[rid][RACE_IDX]][RACE_PLAYERS])
			    {
			        pp_race[playerid][romid]=rid;
			        new tm[128];
					format(tm,sizeof(tm),"[比赛加入]你加入了比赛%s,请耐心等待比赛开始.",RACE_ROM[rid][RACE_NAMES]);
					SM(COLOR_GAINSBORO, tm);
					format(tm,sizeof(tm),"[比赛加入]%s加入了本比赛%s,当前比赛人数%i/%i[比赛满员后将自动开始比赛]",Gnn(playerid),RACE_ROM[rid][RACE_NAMES],GRRPS(rid),R_RACE[RACE_ROM[rid][RACE_IDX]][RACE_PLAYERS]);
					SendRomMessage(rid,tm);
					if(GRRPS(pp_race[playerid][romid])>=R_RACE[RACE_ROM[pp_race[playerid][romid]][RACE_IDX]][RACE_PLAYERS])
					{
						StartRace(pp_race[playerid][romid]);
					}
				}
				else
				{
					new tm[128];
					format(tm,sizeof(tm),"[对不起]你加入的比赛%s已满员，无法加入.",RACE_ROM[rid][RACE_NAMES]);
					SM(COLOR_TWAQUA, tm);
				}
			}
	    }
	}
	return 1;
}
stock Showmybaglist(playerid,pager)
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
            format(tmps,100,"物品名:%s - 数量:%i - ",Daoju[Beibao[playerid][current_idx[playerid][i]][b_did]][d_name],Beibao[playerid][current_idx[playerid][i]][b_amout]);
		    strcat(tmp,tmps);
		    switch(Daoju[Beibao[playerid][current_idx[playerid][i]][b_did]][d_type])
		    {
		        case DAOJU_TYPE_JIAJU:
				{
					format(tmps,100,"类型:家具 - ");
				}
				case DAOJU_TYPE_CAR:
				{
					format(tmps,100,"类型:爱车 - ");
				}
				case DAOJU_TYPE_WEAPON:
				{
					format(tmps,100,"类型:武器 - ");
				}
		    }
            strcat(tmp,tmps);
		    if(Daoju[Beibao[playerid][current_idx[playerid][i]][b_did]][d_issell]==1)format(tmps,100,"可用:是\n");
		    else format(tmps,100,"可用:否\n");
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
stock GetPlayerFaceFrontPos(playerid,Float:distance,&Float:x,&Float:y,&Float:z)
{
	new Float:deg;GetPlayerPos(playerid,x,y,z);
	GetPlayerFacingAngle(playerid,deg);
	x+=distance*floatsin(-deg,degrees);
	y+=distance*floatcos(-deg,degrees);
}
Dialog:dl_mybagnachu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new amout;
		if(sscanf(inputtext, "i",amout))return Dialog_Show(playerid, dl_mybagnachu, DIALOG_STYLE_INPUT, "背包取出","请输入个数", "确定", "取消");
		if(amout<=0)return Dialog_Show(playerid, dl_mybagnachu, DIALOG_STYLE_INPUT, "背包取出","数值不正确，请输入个数", "确定", "取消");
		if(amout>5)return Dialog_Show(playerid, dl_mybagnachu, DIALOG_STYLE_INPUT, "背包取出","最多一次拿出5个，请输入个数", "确定", "取消");
		new listid=GetPVarInt(playerid,"listIDA");
		if(amout>GetBeibaoAmout(playerid,Beibao[playerid][listid][b_did]))return Dialog_Show(playerid, dl_mybagnachu, DIALOG_STYLE_INPUT, "背包取出","你没有那么多，请输入个数", "确定", "取消");
		switch(Daoju[Beibao[playerid][listid][b_did]][d_type])
		{
			case DAOJU_TYPE_JIAJU:
			{
		        Loop(d, amout)
				{
					new i=Iter_Free(JJ);
					new Float:x,Float:y,Float:z;
					GetPlayerFaceFrontPos(playerid,4,x,y,z);
					new Float:ran=randfloat(4);
					JJ[i][jx]=x+ran;
					JJ[i][jy]=y+ran;
					JJ[i][jz]=z;
					JJ[i][jin]=GetPlayerInterior(playerid);
					JJ[i][jwl]=GetPlayerVirtualWorld(playerid);
					format(JJ[i][jKey],32,"NULL");
					JJ[i][jisowner]=0;
					JJ[i][jisellstate]=0;
					JJ[i][juid]=-1;
					JJ[i][jdid]=Beibao[playerid][listid][b_did];
					JJ[i][jused]=false;
					JJ[i][jiscol]=0;
					JJ[i][jcoltime]=0;
					JJ[i][jtxd]=0;
					JJ[i][jtype]=JJ_TYPE_NONE;
					JJ[i][jmsize]=13;
					JJ[i][jfont]=0;
					JJ[i][jsize]=50;
					JJ[i][jbold]=0;
					JJ[i][jfcolor]=3;
					JJ[i][jfbcolor]=0;
					JJ[i][jtalg]=0;
					JJ[i][jrotx]=0;
					JJ[i][jroty]=0;
					JJ[i][jrotz]=0;
					JJ[i][jrotspeed]=0;
					JJ[i][jmove]=0;
					JJ[i][jmovespeed]=0;
					JJ[i][jmovex]=0.0;
					JJ[i][jmovey]=0.0;
					JJ[i][jmovez]=0.0;
					JJ[i][jmoverx]=0.0;
					JJ[i][jmovery]=0.0;
					JJ[i][jmoverz]=0.0;
					JJ[i][jmovestat]=0;
					JJ[i][j_caxin]=Now();
					CreateJJ(i);
					CreateJJtext(i);
					Iter_Add(JJ,i);
					Savedjj_data(i);
				}
				Delbeibao(playerid,Beibao[playerid][listid][b_did],amout);
			}
			case DAOJU_TYPE_WEAPON:
			{
		        Loop(d, amout)
				{
                    new i=Iter_Free(JJ);
					new Float:x,Float:y,Float:z;
					GetPlayerFaceFrontPos(playerid,4,x,y,z);
					new Float:ran=randfloat(4);
					JJ[i][jx]=x+ran;
					JJ[i][jy]=y+ran;
					JJ[i][jz]=z;
					JJ[i][jin]=GetPlayerInterior(playerid);
					JJ[i][jwl]=GetPlayerVirtualWorld(playerid);
					format(JJ[i][jKey],32,"NULL");
					JJ[i][jisowner]=0;
					JJ[i][jisellstate]=0;
					JJ[i][juid]=-1;
					JJ[i][jdid]=Beibao[playerid][listid][b_did];
					JJ[i][jused]=false;
					JJ[i][jiscol]=0;
					JJ[i][jcoltime]=0;
					JJ[i][jtxd]=0;
					JJ[i][jtype]=JJ_TYPE_NONE;
					JJ[i][jmsize]=13;
					JJ[i][jfont]=0;
					JJ[i][jsize]=50;
					JJ[i][jbold]=0;
					JJ[i][jfcolor]=3;
					JJ[i][jfbcolor]=0;
					JJ[i][jtalg]=0;
					JJ[i][jrotx]=0;
					JJ[i][jroty]=0;
					JJ[i][jrotz]=0;
					JJ[i][jrotspeed]=0;
					JJ[i][jmove]=0;
					JJ[i][jmovespeed]=0;
					JJ[i][jmovex]=0.0;
					JJ[i][jmovey]=0.0;
					JJ[i][jmovez]=0.0;
					JJ[i][jmoverx]=0.0;
					JJ[i][jmovery]=0.0;
					JJ[i][jmoverz]=0.0;
					JJ[i][jmovestat]=0;
					JJ[i][j_caxin]=Now();
					Iter_Add(JJ,i);
					CreateJJ(i);
					CreateJJtext(i);
					Savedjj_data(i);
				}
				Delbeibao(playerid,Beibao[playerid][listid][b_did],amout);
			}
			case DAOJU_TYPE_CAR:
			{
			    if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX,"错误","必须在大世界才能拿出爱车", "额", "");
		        Loop(d, amout)
				{
    				new i=Iter_Free(VInfo);
    				new Float:x,Float:y,Float:z;
					GetPlayerFaceFrontPos(playerid,4,x,y,z);
 					new Float:ran=randfloat(4);
					x+=ran;
					y+=ran;
    				new Carid=AddStaticVehicleEx(Daoju[Beibao[playerid][listid][b_did]][d_obj],carx,cary,carz,cara,carco1,carco2,99999999);
    				CarTypes[Carid]=OwnerVeh;
    				CUID[Carid]=i;
    				LinkVehicleToInterior(Carid,GetPlayerInterior(playerid));
    				SetVehicleVirtualWorld(Carid,GetPlayerVirtualWorld(playerid));
    				SetVehiclePos(Carid,x+d,y,z);
    				SetVehicleZAngle(Carid,0.0);
    				VInfo[CUID[Carid]][v_model]=Daoju[Beibao[playerid][listid][b_did]][d_obj];
    				if(GetadminLevel(playerid)>3)
					{
					    VInfo[CUID[Carid]][v_issel]=NONEONE;
						VInfo[CUID[Carid]][v_uid]=-1;
						format(VInfo[CUID[Carid]][v_Plate],100,"无主");
					}
					else
					{
					    VInfo[CUID[Carid]][v_issel]=OWNERS;
						VInfo[CUID[Carid]][v_uid]=PU[playerid];
						format(VInfo[CUID[Carid]][v_Plate],100,Gnn(playerid));
					}
					SetVehicleNumberPlate(Carid,VInfo[CUID[Carid]][v_Plate]);
    				VInfo[CUID[Carid]][v_did]=Beibao[playerid][listid][b_did];
    				VInfo[CUID[Carid]][v_gid]=-1;
    				VInfo[CUID[Carid]][v_x]=x+d;
    				VInfo[CUID[Carid]][v_y]=y;
    				VInfo[CUID[Carid]][v_z]=z;
    				VInfo[CUID[Carid]][v_a]=0.0;
    				VInfo[CUID[Carid]][v_color1]=0;
    				VInfo[CUID[Carid]][v_color2]=0;
    				VInfo[CUID[Carid]][v_in]=GetPlayerInterior(playerid);
    				VInfo[CUID[Carid]][v_wl]=GetPlayerVirtualWorld(playerid);
    				VInfo[CUID[Carid]][v_iscol]=0;
    				VInfo[CUID[Carid]][v_time]=0;
    				VInfo[CUID[Carid]][v_lock]=0;
					VInfo[CUID[Carid]][v_cid]=Carid;
					VInfo[CUID[Carid]][v_Value]=0;
					VInfo[CUID[Carid]][v_color1]=random(255);
    				VInfo[CUID[Carid]][v_color2]=random(255);
    				ChangeVehicleColor(Carid,VInfo[CUID[Carid]][v_color1],VInfo[CUID[Carid]][v_color2]);
					Createcar3D(Carid);
    				Iter_Add(VInfo,CUID[Carid]);
    				Savedveh_data(CUID[Carid]);
				}
				Delbeibao(playerid,Beibao[playerid][listid][b_did],amout);
			}
		}
		new Str[128];
		format(Str,sizeof(Str),"%s从背包里拿出了%i个%s,该物品剩余%i",Gnn(playerid),amout,Daoju[Beibao[playerid][listid][b_did]][d_name],GetBeibaoAmout(playerid,Beibao[playerid][listid][b_did]));
		AdminWarn(Str);
		format(Str,sizeof(Str),"%s从背包里拿出了%i个%s",Gnn(playerid),amout,Daoju[Beibao[playerid][listid][b_did]][d_name]);
		ProxDetector(20.0,playerid,Str,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
	}
	DeletePVar(playerid,"listIDA");
	return 1;
}
stock GetWeapon(dids)
{
	Loop(i,sizeof(WEAPON))
	{
	    if(dids==WEAPON[i][W_MODEL])return i;
	}
	return -1;
}
stock GvieGun(playerid)
{
	ResetPlayerWeapons(playerid);
	Loop(x,13)GivePlayerWeapon(playerid,WEAPONUID[PU[playerid]][x][wpid],99999999999);
	return 1;
}
Dialog:dl_djgiveweapon(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		new idf=GetWeapon(Daoju[Beibao[playerid][listid][b_did]][d_obj]);
		if(idf!=-1)
		{
			WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wdid]=Beibao[playerid][listid][b_did];
			WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wpid]=WEAPON[idf][W_WID];
			WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wmodel]=WEAPON[idf][W_MODEL];
			GivePlayerWeapon(playerid,WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wpid],99999999999);
			SaveWeapon(PU[playerid]);
		    Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
			new Str[128];
			format(Str,sizeof(Str),"%s把道具%s装备成武器,背包该物品剩余%i",Gnn(playerid),Daoju[Beibao[playerid][listid][b_did]][d_name],GetBeibaoAmout(playerid,Beibao[playerid][listid][b_did]));
			AdminWarn(Str);
		}
		else Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX,"错误","错误#1652", "额", "");
		DeletePVar(playerid,"listIDA");
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_mybagcaozuo(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		switch(listitem)
		{
		    case 0:
		    {
		        if(GetAreaJJprotect(playerid)||Ishousepro(playerid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX,"提示","此地盘或房子已开启已开启家具保护，无法拿出道具", "额", "");
				if(Beibao[playerid][listid][b_amout]>1)
				{
				    new tm[64];
					format(tm,64,"物品%s有%i个,请输入取出的个数",Daoju[Beibao[playerid][listid][b_did]][d_name],Beibao[playerid][listid][b_amout]);
					Dialog_Show(playerid, dl_mybagnachu, DIALOG_STYLE_INPUT, "背包取出", tm, "确定", "取消");
					SetPVarInt(playerid,"listIDA",listid);
				}
				else if(Beibao[playerid][listid][b_amout]<1)
				{
			        Iter_Remove(Beibao[playerid],listid);
	          		SavedUserBeibao(playerid);
				}
				else
				{
				    switch(Daoju[Beibao[playerid][listid][b_did]][d_type])
				    {
					    case DAOJU_TYPE_JIAJU:
					    {
		                    new i=Iter_Free(JJ);
							new Float:x,Float:y,Float:z;
							GetPlayerFaceFrontPos(playerid,2,x,y,z);
							new Float:ran=randfloat(2);
							JJ[i][jx]=x+ran;
							JJ[i][jy]=y+ran;
							JJ[i][jz]=z;
							JJ[i][jin]=GetPlayerInterior(playerid);
							JJ[i][jwl]=GetPlayerVirtualWorld(playerid);
							format(JJ[i][jKey],32,"NULL");
							JJ[i][jisowner]=0;
							JJ[i][jisellstate]=0;
							JJ[i][juid]=-1;
							JJ[i][jdid]=Beibao[playerid][listid][b_did];
							JJ[i][jused]=false;
							JJ[i][jiscol]=0;
							JJ[i][jcoltime]=0;
							JJ[i][jtxd]=0;
							JJ[i][jtype]=JJ_TYPE_NONE;
							JJ[i][jmsize]=13;
							JJ[i][jfont]=0;
							JJ[i][jsize]=50;
							JJ[i][jbold]=0;
							JJ[i][jfcolor]=3;
							JJ[i][jfbcolor]=0;
							JJ[i][jtalg]=0;
							JJ[i][jrotx]=0;
							JJ[i][jroty]=0;
							JJ[i][jrotz]=0;
							JJ[i][jrotspeed]=0;
							JJ[i][jmove]=0;
							JJ[i][jmovespeed]=0;
							JJ[i][jmovex]=0.0;
							JJ[i][jmovey]=0.0;
							JJ[i][jmovez]=0.0;
							JJ[i][jmoverx]=0.0;
							JJ[i][jmovery]=0.0;
							JJ[i][jmoverz]=0.0;
							JJ[i][jmovestat]=0;
							JJ[i][j_caxin]=Now();
							Iter_Add(JJ,i);
							CreateJJ(i);
							CreateJJtext(i);
							Savedjj_data(i);
							Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
							DeletePVar(playerid,"listIDA");
					    }
						case DAOJU_TYPE_WEAPON:
					    {
		                    new i=Iter_Free(JJ);
							new Float:x,Float:y,Float:z;
							GetPlayerFaceFrontPos(playerid,2,x,y,z);
							new Float:ran=randfloat(2);
							JJ[i][jx]=x+ran;
							JJ[i][jy]=y+ran;
							JJ[i][jz]=z;
							JJ[i][jin]=GetPlayerInterior(playerid);
							JJ[i][jwl]=GetPlayerVirtualWorld(playerid);
							format(JJ[i][jKey],32,"NULL");
							JJ[i][jisowner]=0;
							JJ[i][jisellstate]=0;
							JJ[i][juid]=-1;
							JJ[i][jdid]=Beibao[playerid][listid][b_did];
							JJ[i][jused]=false;
							JJ[i][jiscol]=0;
							JJ[i][jcoltime]=0;
							JJ[i][jtxd]=0;
							JJ[i][jtype]=JJ_TYPE_NONE;
							JJ[i][jmsize]=13;
							JJ[i][jfont]=0;
							JJ[i][jsize]=50;
							JJ[i][jbold]=0;
							JJ[i][jfcolor]=3;
							JJ[i][jfbcolor]=0;
							JJ[i][jtalg]=0;
							JJ[i][jrotx]=0;
							JJ[i][jroty]=0;
							JJ[i][jrotz]=0;
							JJ[i][jrotspeed]=0;
							JJ[i][jmove]=0;
							JJ[i][jmovespeed]=0;
							JJ[i][jmovex]=0.0;
							JJ[i][jmovey]=0.0;
							JJ[i][jmovez]=0.0;
							JJ[i][jmoverx]=0.0;
							JJ[i][jmovery]=0.0;
							JJ[i][jmoverz]=0.0;
							JJ[i][jmovestat]=0;
							JJ[i][j_caxin]=Now();
							Iter_Add(JJ,i);
							CreateJJ(i);
							CreateJJtext(i);
							Savedjj_data(i);
							Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
							DeletePVar(playerid,"listIDA");
					    }
					    case DAOJU_TYPE_CAR:
					    {
			   		 		if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX,"错误","必须在大世界才能拿出爱车", "额", "");
					        new i=Iter_Free(VInfo);
					        new Float:x,Float:y,Float:z;
							GetPlayerFaceFrontPos(playerid,2,x,y,z);
							new Float:ran=randfloat(2);
							x+=ran;
							y+=ran;
							new Carid=AddStaticVehicleEx(Daoju[Beibao[playerid][listid][b_did]][d_obj],carx,cary,carz,cara,carco1,carco2,99999999);
							CarTypes[Carid]=OwnerVeh;
				            CUID[Carid]=i;
				            LinkVehicleToInterior(Carid,GetPlayerInterior(playerid));
				            SetVehicleVirtualWorld(Carid,GetPlayerVirtualWorld(playerid));
				            SetVehiclePos(Carid,x,y,z);
				            SetVehicleZAngle(Carid,0.0);
							VInfo[CUID[Carid]][v_model]=Daoju[Beibao[playerid][listid][b_did]][d_obj];
		    				if(GetadminLevel(playerid)>3)
							{
							    VInfo[CUID[Carid]][v_issel]=NONEONE;
								VInfo[CUID[Carid]][v_uid]=-1;
								format(VInfo[CUID[Carid]][v_Plate],100,"无主");
							}
							else
							{
							    VInfo[CUID[Carid]][v_issel]=OWNERS;
								VInfo[CUID[Carid]][v_uid]=PU[playerid];
								format(VInfo[CUID[Carid]][v_Plate],100,Gnn(playerid));
							}
							SetVehicleNumberPlate(Carid,VInfo[CUID[Carid]][v_Plate]);
							VInfo[CUID[Carid]][v_did]=Beibao[playerid][listid][b_did];
							VInfo[CUID[Carid]][v_gid]=-1;
							VInfo[CUID[Carid]][v_x]=x;
							VInfo[CUID[Carid]][v_y]=y;
							VInfo[CUID[Carid]][v_z]=z;
							VInfo[CUID[Carid]][v_a]=0.0;
							VInfo[CUID[Carid]][v_color1]=0;
							VInfo[CUID[Carid]][v_color2]=0;
							VInfo[CUID[Carid]][v_in]=GetPlayerInterior(playerid);
							VInfo[CUID[Carid]][v_wl]=GetPlayerVirtualWorld(playerid);
							VInfo[CUID[Carid]][v_iscol]=0;
							VInfo[CUID[Carid]][v_time]=0;
    						VInfo[CUID[Carid]][v_lock]=0;
							VInfo[CUID[Carid]][v_cid]=Carid;
							VInfo[CUID[Carid]][v_Value]=0;
							Createcar3D(Carid);
				  			Iter_Add(VInfo,CUID[Carid]);
				 			Savedveh_data(CUID[Carid]);
				 			Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
				 			DeletePVar(playerid,"listIDA");
					    }
				    }
					new Str[128];
				    format(Str,sizeof(Str),"%s从背包里拿出了1个%s,该物品剩余%i",Gnn(playerid),Daoju[Beibao[playerid][listid][b_did]][d_name],GetBeibaoAmout(playerid,Beibao[playerid][listid][b_did]));
					AdminWarn(Str);
					format(Str,sizeof(Str),"%s从背包里拿出了1个%s",Gnn(playerid),Daoju[Beibao[playerid][listid][b_did]][d_name]);
					ProxDetector(20.0,playerid,Str,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
				}
		    }
		    case 1:
		    {
				if(Daoju[Beibao[playerid][listid][b_did]][d_type]==DAOJU_TYPE_WEAPON)
				{
					new idf=GetWeapon(Daoju[Beibao[playerid][listid][b_did]][d_obj]);
					if(idf!=-1)
					{
					    if(WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wpid]!=0)Dialog_Show(playerid, dl_djgiveweapon, DIALOG_STYLE_MSGBOX, "提醒","你的武器槽已有武器,如要装备此道具,将覆盖原来的武器，是否继续", "继续装备", "取消装备");
					    else
					    {
						    WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wdid]=Beibao[playerid][listid][b_did];
						    WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wpid]=WEAPON[idf][W_WID];
						    WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wmodel]=WEAPON[idf][W_MODEL];
							GivePlayerWeapon(playerid,WEAPONUID[PU[playerid]][WEAPON[idf][W_SLOT]][wpid],99999999999);
							SaveWeapon(PU[playerid]);
						    Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
						    DeletePVar(playerid,"listIDA");
					    }
					}
					else
					{
						Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","这不是武器类型的家具", "好的", "");
						DeletePVar(playerid,"listIDA");
					}
				}
				else
				{
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","这不是武器类型的家具", "好的", "");
					DeletePVar(playerid,"listIDA");
				}
		    }
		    case 2:
		    {
		        if(Daoju[Beibao[playerid][listid][b_did]][d_type]==DAOJU_TYPE_CAR)
				{
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","只能用家具类型及武器类型道具", "好的", "");
					DeletePVar(playerid,"listIDA");
					return 1;
				}
		        if(IsplayerHaveAttSlot(playerid))
			        {
						new attBones[256],Stru[32];
	                    Loop(i,sizeof(AttachmentBones))
						{
						    format(Stru, sizeof(Stru),"【%s】\n",AttachmentBones[i]);
							strcat(attBones,Stru);
						}
						Dialog_Show(playerid, dl_mybagzhuanbei, DIALOG_STYLE_LIST,"部位选择",attBones,"确定","取消");
					}
					else
					{
						Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你的附体已满", "好的", "");
						DeletePVar(playerid,"listIDA");
					}
		    }
		    case 3:
		    {
		        if(Daoju[Beibao[playerid][listid][b_did]][d_type]==DAOJU_TYPE_CAR)
				{
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","只能用家具类型及武器类型道具", "好的", "");
					DeletePVar(playerid,"listIDA");
					return 1;
				}
		        if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
		        {
		            new Carid=GetPlayerVehicleID(playerid);
		            if(CarTypes[Carid]==OwnerVeh&&VInfo[CUID[Carid]][v_uid]==PU[playerid])
		            {
		        		new i=Iter_Free(AvInfo[CUID[Carid]]);
		        		if(i!=-1)
		        		{
		        		    AvInfo[CUID[Carid]][i][av_id]=CreateDynamicObject(Daoju[Beibao[playerid][listid][b_did]][d_obj],0.0,0.0,0.0,0.0,0.0,0.0,-1,-1,-1,200.0,0.0);
		        		    AvInfo[CUID[Carid]][i][v_z]+=1;
                			AttachDynamicObjectToVehicle(AvInfo[CUID[Carid]][i][av_id],VInfo[CUID[Carid]][v_cid],AvInfo[CUID[Carid]][i][v_x],AvInfo[CUID[Carid]][i][v_y],AvInfo[CUID[Carid]][i][v_z],AvInfo[CUID[Carid]][i][v_rx],AvInfo[CUID[Carid]][i][v_ry],AvInfo[CUID[Carid]][i][v_rz]);
							AvInfo[CUID[Carid]][i][v_txd]=0;
							AvInfo[CUID[Carid]][i][av_did]=Beibao[playerid][listid][b_did];
	    					Iter_Add(AvInfo[CUID[Carid]],i);
	    					SaveAve(CUID[Carid]);
	    					DeletePVar(playerid,"listIDA");
	    					Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
	    					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车装扮已安装成功，请在汽车菜单中选择装扮爱车来调整", "好的", "");
		        		}
		        	}
		        	else
		        	{
		        		DeletePVar(playerid,"listIDA");
						Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","这不是你的车", "好的", "");
		        	}
		        	
		        }
		        else
				{
				    DeletePVar(playerid,"listIDA");
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","不在一辆车上", "好的", "");
				}
		    }
		    case 4:
		    {
		    	Iter_Remove(Beibao[playerid],listid);
	        	SavedUserBeibao(playerid);
	        	Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你已销毁了此道具", "好的", "");
		    }
		}
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_mybagzhuanbei(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
        new i=SetPlayerAttachedObjectEx(playerid,Daoju[Beibao[playerid][listid][b_did]][d_obj],listitem+1,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0);
		att[playerid][i][att_id]=i;
        att[playerid][i][att_type]=DAOJU_TYPE_JIAJU;
        att[playerid][i][att_did]=Beibao[playerid][listid][b_did];
        att[playerid][i][att_modelid]=Daoju[Beibao[playerid][listid][b_did]][d_obj];
        att[playerid][i][att_boneid]=listitem+1;
        att[playerid][i][att_fOffsetX]=0;
        att[playerid][i][att_fOffsetY]=0;
        att[playerid][i][att_fOffsetZ]=0;
        att[playerid][i][att_fRotX]=0;
        att[playerid][i][att_fRotY]=0;
        att[playerid][i][att_fRotZ]=0;
        att[playerid][i][att_fScaleX]=1.0;
        att[playerid][i][att_fScaleY]=1.0;
        att[playerid][i][att_fScaleZ]=1.0;
        att[playerid][i][att_materialcolor1]=0;
        att[playerid][i][att_materialcolor2]=0;
		att[playerid][i][att_iscol]=0;
		att[playerid][i][att_jcoltime]=0;
		att[playerid][i][att_ismater]=0;
        Iter_Add(att[playerid],i);
        SaveAtt(playerid);
        SM(COLOR_ORANGE,"道具已经装备可以编辑了");
		pstat[playerid]=EDIT_ATT_MODE;
		SetPVarInt(playerid,"ltd",i);
		EditAttachedObject(playerid,att[playerid][i][att_id]);
		Delbeibao(playerid,Beibao[playerid][listid][b_did],1);
		new Str[128];
		format(Str,sizeof(Str),"%s把背包里的%s装备在了身上SLOT%i,背包此物品剩余%i",Gnn(playerid),Daoju[Beibao[playerid][listid][b_did]][d_name],i,GetBeibaoAmout(playerid,att[playerid][i][att_did]));
		AdminWarn(Str);
	}
	else Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你取消了装备家具", "好的", "");
	DeletePVar(playerid,"listIDA");
	return 1;
}

stock Addbeibao(playerid,did,amout)
{
	if(!amout)return 1;
	foreach(new i:Beibao[playerid])
	{
		if(Beibao[playerid][i][b_did]==did&&Beibao[playerid][i][b_amout]>0)
		{
		    Beibao[playerid][i][b_amout]+=amout;
		    SavedUserBeibao(playerid);
		    return 1;
		}
		if(Beibao[playerid][i][b_did]==did&&Beibao[playerid][i][b_amout]<0)
		{
		    Iter_Remove(Beibao[playerid],i);
		    SavedUserBeibao(playerid);
		    return 1;
		}
	}
    new x=Iter_Free(Beibao[playerid]);
    Beibao[playerid][x][b_did]=did;
    Beibao[playerid][x][b_amout]=amout;
    Iter_Add(Beibao[playerid],x);
	SavedUserBeibao(playerid);
	if(Iter_Count(Beibao[playerid])>90)
	{
		new Str[80];
		format(Str,sizeof(Str),"请注意,你的背包剩余空间不足,当前%i,请及时清理\n否则达到100个时,放入物品将无效",Iter_Count(Beibao[playerid]));
        SM(COLOR_ORANGE,Str);
	}
	return 1;
}
stock Delbeibao(playerid,did,amout)
{
	foreach(new i:Beibao[playerid])
	{
		if(Beibao[playerid][i][b_did]==did)
		{
		    Beibao[playerid][i][b_amout]-=amout;
		    if(Beibao[playerid][i][b_amout]<1)Iter_Remove(Beibao[playerid],i);
		    SavedUserBeibao(playerid);
		    return 1;
		}
	}
	return 1;
}
stock GetBeibaoAmout(playerid,did)
{
	foreach(new i:Beibao[playerid])
	{
		if(Beibao[playerid][i][b_did]==did)
		{
		    return Beibao[playerid][i][b_amout];
		}
	}
	return 0;
}
Function LoadUserBb(playerid)
{
	new strings[512],ids=0,Stru[128];
	format(Stru,sizeof(Stru),USER_BAG_FILE,Gnn(playerid));
    if(fexist(Stru))
    {
        new File:beibaofile = fopen(Stru, io_read);
        if(beibaofile)
    	{
        	while(fread(beibaofile, strings))
        	{
        	    if(strlenEx(strings)>3)
        	    {
	        	    if(ids<MAX_PLAYER_BEIBAO)
	        	    {
		        		sscanf(strings, "p<,>ii",Beibao[playerid][ids][b_did],Beibao[playerid][ids][b_amout]);
		        		Iter_Add(Beibao[playerid],ids);
		        		ids++;
        		    }
        		}
        	}
        	fclose(beibaofile);
    	}
    }
	return 1;
}
Function SavedUserBeibao(playerid)
{
	new strings[6123],Stru[128];
	format(Stru,sizeof(Stru),USER_BAG_FILE,Gnn(playerid));
	if(fexist(Stru))fremove(Stru);
	new File:beibaofile = fopen(Stru, io_write);
    foreach(new i:Beibao[playerid])
	{
		format(strings,sizeof(strings),"%s %i,%i\r\n",strings,Beibao[playerid][i][b_did],Beibao[playerid][i][b_amout]);
	}
	fwrite(beibaofile,strings);
    fclose(beibaofile);
    return 1;
}
timer juqi[1500](playerid)
{
    pstat[playerid]=MOVE_JJ_MODE;
	DelJJ(pcurrent_jj[playerid]);
	SetPlayerAttachedObject(playerid,9,Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_obj],1,0,0.6,0,0,90,0,1.000000, 1.000000, 1.000000);
	SM(0xFF8000C8,"你举起了家具!");
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	SetPPos(playerid,x,y,z);
}

timer fangxia[1000](playerid)
{
	if(pcurrent_jj[playerid]!=-1)
	{
		RemovePlayerAttachedObject(playerid,9);
    	new Float:x,Float:y,Float:z;
		GetPlayerFaceFrontPos(playerid,2,x,y,z);
 		new Float:ran=randfloat(2);
		JJ[pcurrent_jj[playerid]][jx]=x+ran;
		JJ[pcurrent_jj[playerid]][jy]=y+ran;
		JJ[pcurrent_jj[playerid]][jz]=z-0.5;
		JJ[pcurrent_jj[playerid]][jin]=GetPlayerInterior(playerid);
		JJ[pcurrent_jj[playerid]][jwl]=GetPlayerVirtualWorld(playerid);
		CreateJJ(pcurrent_jj[playerid]);
		CreateJJtext(pcurrent_jj[playerid]);
		Savedjj_data(pcurrent_jj[playerid]);
		JJ[pcurrent_jj[playerid]][jused]=false;
		pcurrent_jj[playerid]=-1;
		pstat[playerid]=NO_MODE;
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
		SetPPos(playerid,x,y,z);
		SM(0x00FFFFC8,"你放下了家具!");
	}
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(AvailablePlayer(playerid))
	{
		if(pstat[playerid]==GUAJI)return Dialog_Show(playerid, dl_tcguajia, DIALOG_STYLE_MSGBOX, "提醒", "是否退出挂机", "退出", "取消");
		switch(GetPlayerState(playerid))
		{
			case PLAYER_STATE_ONFOOT:
		 	{
		 	    if(PRESSED(KEY_NO))
		 	    {
		 	        if(pstat[playerid]==BT)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "你正在摆摊，无法使用", "额", "");
		 	        if(pstat[playerid]!=EDIT_INT)
		 	        {
			 	        if(Iter_Contains(HOUSE,GetPlayerVirtualWorld(playerid)-500))
			 	        {
							if(Isownhouse(playerid))
							{
				 	            new tm[100];
				 	            format(tm,100,"房子ID:%i设置",GetPlayerVirtualWorld(playerid)-500);
				 	            Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(GetPlayerVirtualWorld(playerid)-500), "选择", "取消");
	                            SetPVarInt(playerid,"houseid",GetPlayerVirtualWorld(playerid)-500);
			 	            }
			 	        }
			 	        if(Iter_Contains(property,GetPlayerVirtualWorld(playerid)-2000))
			 	        {
							if(property[GetPlayerVirtualWorld(playerid)-2000][pro_stat]!=NONEONE)
							{
							    if(property[GetPlayerVirtualWorld(playerid)-2000][pro_uid]==PU[playerid])
							    {
					 	            new tm[100];
					 	            format(tm,100,""#H_PRO"[%s]商业ID:%i设置",protypestr[property[GetPlayerVirtualWorld(playerid)-2000][pro_type]],GetPlayerVirtualWorld(playerid)-2000);
					 	            Dialog_Show(playerid,dl_editpro, DIALOG_STYLE_LIST,tm,Showproinfo(GetPlayerVirtualWorld(playerid)-2000), "选择", "取消");
		                            SetPVarInt(playerid,"houseid",GetPlayerVirtualWorld(playerid)-2000);
	                            }
	                            else
	                            {
									new tm[100];
					 	            format(tm,100,""#H_PRO"[%s]商业ID:%i营业菜单",protypestr[property[GetPlayerVirtualWorld(playerid)-2000][pro_type]],GetPlayerVirtualWorld(playerid)-2000);
					 	            Dialog_Show(playerid,dl_probuy, DIALOG_STYLE_LIST,tm,"购买商铺道具\n商铺回收道具", "选择", "取消");
		                            SetPVarInt(playerid,"houseid",GetPlayerVirtualWorld(playerid)-2000);
	                            }
			 	            }
			 	        }
					    if(pstat[playerid]==NO_MODE)
					    {
						    new i=IsHereAreaOwner(playerid);
						    if(i!=-1)
						    {
					            SetPVarInt(playerid,"listIDA",i);
					            new tm[80];
								format(tm,sizeof(tm),"ID:%i地盘%s设置",i,DPInfo[i][dp_name]);
					            Dialog_Show(playerid,dl_dpsz,DIALOG_STYLE_LIST,tm,"地盘名称\n地盘密码\n地盘音乐\n地盘闪烁\n地盘颜色\n地盘保护\n调整地盘\n删除地盘","确定", "取消");
						    }
				        }
		 	        }
					else
					{
					    new intt=GetPVarInt(playerid,"listIDA");
						if(GetPlayerInterior(playerid)!=INT[intt][I_IN])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你没有在你选择的内饰里", "额", "");
						new idx=GetPVarInt(playerid,"houseid");
                        if(HOUSE[GetPlayerVirtualWorld(playerid)-500][H_UID]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你没有在你的房子里", "额", "");
						HOUSE[idx][H_iX]=INT[intt][I_X];
						HOUSE[idx][H_iY]=INT[intt][I_Y];
						HOUSE[idx][H_iZ]=INT[intt][I_Z];
						HOUSE[idx][H_iIN]=INT[intt][I_IN];
						HOUSE[idx][H_INTIDX]=intt;
						DelHouse(idx);
						CreateHouse(idx);
						Savedhousedata(idx);
						SetPlayerPosEx(playerid,HOUSE[idx][H_iX],HOUSE[idx][H_iY],HOUSE[idx][H_iZ],HOUSE[idx][H_iA],HOUSE[idx][H_iIN],HOUSE[idx][H_iWL],idx,0,0);
                        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","成功装修", "额", "");
                        pstat[playerid]=NO_MODE;
					}
		 	    }
				if(PRESSED(KEY_YES))
				{
				    if(pstat[playerid]==BT)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "你正在摆摊，无法使用", "额", "");
				    if(pcurrent_jj[playerid]==-1)
				    {
						Garbage[playerid][keycount]=GetTickCount();
						if(Garbage[playerid][keycount]-Garbage[playerid][keytime]<GARTIME)
						{
						    SM(COLOR_TWAQUA,"请稍等2秒后再按键");
							return 1;
						}
						Garbage[playerid][keytime]=Garbage[playerid][keycount];
				        if(pstat[playerid]!=NO_MODE)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你在其他模式下无法操作家具", "好的", "");
				        new idx=GetClosestjiaju(playerid);
				        if(idx!=-1)
				        {
				            if(GetAreaJJprotectEx(idx,playerid)||Ishousepro(playerid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","地盘或房产已开启家具保护，无法操作家具", "好的", "");
				            if(JJ[idx][jused]==false)
				            {
				                //if(JJ[idx][jmovestat]==0)
				                //{
									if(JJ[idx][juid]==PU[playerid])
									{
									    new tm[64];
										format(tm,64,"家具:%s  操作",Daoju[JJ[idx][jdid]][d_name]);
										Dialog_Show(playerid,dl_jiajusz,DIALOG_STYLE_LIST,tm,"拿起家具\n编辑家具\n标签变色\n家具材质\n家具文字\n家具移动\n家具旋转\n装备家具\n放入背包","确定", "取消");
	                                    pcurrent_jj[playerid]=idx;
									}
									else
									{
									    new tm[64];
										format(tm,64,"家具:%s  操作",Daoju[JJ[idx][jdid]][d_name]);
	   								    Dialog_Show(playerid,dl_jiajusz,DIALOG_STYLE_LIST,tm,"拿起家具\n编辑家具\n标签变色\n家具材质\n家具文字\n家具移动\n家具旋转\n装备家具\n放入背包","确定", "取消");
	                                    pcurrent_jj[playerid]=idx;
									}
									JJ[pcurrent_jj[playerid]][j_caxin]=Now();
									UpdateJJtext(pcurrent_jj[playerid]);
									Savedjj_data(pcurrent_jj[playerid]);
							//	}
								/*else
								{
		               				new tm[64];
									format(tm,64,"家具:%s正在移动,请稍后再试",Daoju[JJ[idx][jdid]][d_name]);
									Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "好的", "");
									pcurrent_jj[playerid]=-1;
								}*/
							}
							else
							{
								new tm[64];
								format(tm,64,"家具:%s  正在被其他人操作",Daoju[JJ[idx][jdid]][d_name]);
							    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "好的", "");
							    pcurrent_jj[playerid]=-1;
							}
						}
						else
			        	{
			        		pcurrent_jj[playerid]=-1;
			        	}
			        }
					else Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你正忙!", "好的", "");
				}
				if(PRESSED(KEY_HANDBRAKE))
				{
				    if(pstat[playerid]==BT)return Dialog_Show(playerid, dl_shoutan, DIALOG_STYLE_MSGBOX, "收摊","是否收摊", "是的", "不要");
					if(pcurrent_jj[playerid]!=-1)
					{
					    if(pstat[playerid]==MOVE_JJ_MODE)
					    {
							new tm[64];
							format(tm,64,"是否放下家具%s!",Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_name]);
					    	Dialog_Show(playerid, dl_fangxia, DIALOG_STYLE_MSGBOX, "家具",tm, "是的", "不要");
					    	return 1;
					    }
					}
					else
					{
					    new idx=GetClosestjiaju(playerid);
					    if(idx!=-1)
						{
		    				if(JJ[idx][jused]==false)
		    				{
		           			    /*if(JJ[idx][jmovestat]==0)
		           			    {*/
		                   			JJ[idx][jmovestat]=1;
									MoveDynamicObject(JJ[idx][jid],JJ[idx][jmovex],JJ[idx][jmovey],JJ[idx][jmovez],JJ[idx][jmovespeed],JJ[idx][jmoverx],JJ[idx][jmovery],JJ[idx][jmoverz]);
		               			/*}*/
		               			/*else
		               			{
		               				new tm[64];
									format(tm,64,"家具:%s正在移动,请稍后再试",Daoju[JJ[idx][jdid]][d_name]);
									Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "好的", "");
									return 1;
		                        }*/
		                    }
						}
					}
					switch(GetPlayerSpecialAction(playerid))
					{
					    case SPECIAL_ACTION_HANDSUP:
						{
							SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
							pstat[playerid]=NO_MODE;
						}
					    case SPECIAL_ACTION_DANCE1:
						{
							SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
							pstat[playerid]=NO_MODE;
						}
					    case SPECIAL_ACTION_DANCE2:
						{
							SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
							pstat[playerid]=NO_MODE;
						}
					    case SPECIAL_ACTION_DANCE3:
						{
							SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
							pstat[playerid]=NO_MODE;
						}
					}
					if(pstat[playerid]==ACT)
					{
						ClearAnimations(playerid);
						pstat[playerid]=NO_MODE;
					}
				}
/*				if(PRESSED(KEY_SPRINT))
				{

				}*/
			}
			case PLAYER_STATE_DRIVER:
		 	{
			 	new Carid=GetPlayerVehicleID(playerid);
				if(PRESSED(KEY_FIRE))
				{
					AddVehicleComponent(Carid, 1010);
					//GameTextForPlayer(playerid,"Nos Added",1000,3);
				}
				if(PRESSED(KEY_LOOK_LEFT))
				{
					new Float:X, Float:Y, Float:Z, Float:Angle;
					GetPlayerPos(playerid, X, Y, Z);
					GetVehicleZAngle(Carid, Angle);
					SetVehiclePos(Carid, X, Y, Z);
					SetVehicleZAngle(Carid, Angle);
				}
				if(PRESSED(KEY_LOOK_RIGHT))
				{
				 	RepairVehicle(Carid);
				 	//GameTextForPlayer(playerid,"Fixed",1000,3);
				}
                if(PRESSED(KEY_YES))
				{
			 		if(CarTypes[Carid]==OwnerVeh)
			 		{
			 		    if(Iter_Contains(VInfo,CUID[Carid]))
			 		    {
			 		        if(VInfo[CUID[Carid]][v_uid]==PU[playerid])
			 		        {
			 		            if(pstat[playerid]==EDIT_CAR_ATT_MODE)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你正在编辑状态,请先编辑完再使用", "好的", "");
			 		            new tm[64];
								format(tm,64,"你的爱车%s菜单",Daoju[VInfo[CUID[Carid]][v_did]][d_name]);
								Dialog_Show(playerid,dl_carlist,DIALOG_STYLE_LIST,tm,"爱车定位\n爱车上锁\n装扮爱车\n标签颜色\n更改车牌\n车窗开关\n放入背包\n出售爱车\n抛弃爱车","确定", "取消");
							}
			 		    }
			 		}
			 	}
			 	R_onplayerkey(playerid, newkeys, oldkeys);
			 	if((newkeys & KEY_NO) && (newkeys & KEY_ANALOG_LEFT))
			 	{
					switch(CarTypes[Carid])
					{
					    case BrushVeh:
					    {
    						if(pbrushcar[playerid]==Carid)
			        		{
			        		    if(pcarcolor1[playerid]>255)
								{
									pcarcolor1[playerid]=0;
									ChangeVehicleColor(Carid,pcarcolor1[playerid],pcarcolor2[playerid]);
								}
								else
								{
			        		    	pcarcolor1[playerid]++;
			        				ChangeVehicleColor(Carid,pcarcolor1[playerid],pcarcolor2[playerid]);
			        			}
			        		}
					    }
						case OwnerVeh:
						{
		        			if(VInfo[CUID[Carid]][v_uid]==PU[playerid])
		        			{
								if(VInfo[CUID[Carid]][v_color1]>255)
								{
								    VInfo[CUID[Carid]][v_color1]=0;
								    ChangeVehicleColor(Carid,VInfo[CUID[Carid]][v_color1],VInfo[CUID[Carid]][v_color2]);
								}
								else
								{
								    VInfo[CUID[Carid]][v_color1]++;
								    ChangeVehicleColor(Carid,VInfo[CUID[Carid]][v_color1],VInfo[CUID[Carid]][v_color2]);
								}
		        			}
		        			Savedveh_data(CUID[Carid]);
						}
					}
			 	}
			 	if((newkeys & KEY_NO) && (newkeys & KEY_ANALOG_RIGHT ))
			 	{
					switch(CarTypes[Carid])
					{
					    case BrushVeh:
					    {
    						if(pbrushcar[playerid]==Carid)
			        		{
			        		    if(pcarcolor2[playerid]>255)
								{
									pcarcolor2[playerid]=0;
									ChangeVehicleColor(Carid,pcarcolor1[playerid],pcarcolor2[playerid]);
								}
								else
								{
			        		    	pcarcolor2[playerid]++;
			        				ChangeVehicleColor(Carid,pcarcolor1[playerid],pcarcolor2[playerid]);
			        			}
			        		}
					    }
						case OwnerVeh:
						{
		        			if(VInfo[CUID[Carid]][v_uid]==PU[playerid])
		        			{
			        			if(VInfo[CUID[Carid]][v_uid]==PU[playerid])
			        			{
									if(VInfo[CUID[Carid]][v_color2]>255)
									{
									    VInfo[CUID[Carid]][v_color2]=0;
									    ChangeVehicleColor(Carid,VInfo[CUID[Carid]][v_color1],VInfo[CUID[Carid]][v_color2]);
									}
									else
									{
									    VInfo[CUID[Carid]][v_color2]++;
									    ChangeVehicleColor(Carid,VInfo[CUID[Carid]][v_color1],VInfo[CUID[Carid]][v_color2]);
									}
			        			}
			        			Savedveh_data(CUID[Carid]);
		        			}
						}
					}
			 	}
		 	}
		}
		if(pp_race[playerid][romid]!=-1)
		{
		    if(RACE_ROM[pp_race[playerid][romid]][RACE_UID]==PU[playerid]&&RACE_ROM[pp_race[playerid][romid]][RACE_STAT]==RACE_WAIT&&Itter_Contains(RACE_ROM,pp_race[playerid][romid]))
		    {
		    	if(RACE_ROM[pp_race[playerid][romid]][RACE_STAT]==RACE_WAIT)Dialog_Show(playerid, dl_race_start, DIALOG_STYLE_MSGBOX, "是否准备倒计时开始", "是否完成", "是", "否");
		    }
		}
		else
		{
			
		}
		if(newkeys ==KEY_CTRL_BACK&&pstat[playerid]!=EDIT_RACE_MODE_DW&&pstat[playerid]!=EDIT_RACE_MODE_CH)
    	{
    	    Showtab(playerid);
    	    mS_DestroySelectionMenu(playerid);
        	SelectTextDraw(playerid, 0xFF4040AA);
    	}
    	Pro_Onplayerkey(playerid,newkeys,oldkeys);
	}
	return 1;
}
Function GetClosestpick(playerid)
{
	new Float:dis, Float:dis2, jcid;
	jcid = -1;
	dis = 99999.99;
	foreach(new x:R_RACE)
	{
		if(PlayerToPoint(3, playerid,R_RACE[x][RACE_X],R_RACE[x][RACE_Y],R_RACE[x][RACE_Z],R_RACE[x][RACE_IN],R_RACE[x][RACE_WL]))
		{
			new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
			GetPlayerPos(playerid, x1, y1, z1);
			x2=R_RACE[x][RACE_X];
			y2=R_RACE[x][RACE_Y];
			z2=R_RACE[x][RACE_Z];
			dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
			if(dis2 < dis && dis2 != -1.00)
			{
				dis = dis2;
				jcid = x;
			}
		}
	}
	return jcid;
}
stock Showmycarzblist(playerid,pager,cid)
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
            format(tmps,100,"物品名:%s\n",Daoju[AvInfo[cid][current_idx[playerid][i]][av_did]][d_name]);
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
Dialog:dl_aicarzb(playerid, response, listitem, inputtext[])
{
	new Carid=GetPlayerVehicleID(playerid);
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
			Dialog_Show(playerid, dl_aicarzb, DIALOG_STYLE_LIST,"爱车装扮", Showmycarzblist(playerid,P_page[playerid],CUID[Carid]), "确定", "上一页");
	    }
	    if(current_number[playerid]-1==0)return 1;
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_aicarzbcz,DIALOG_STYLE_LIST,"装扮操作","调整装扮\n更换材质\n卸下装扮\n销毁装扮","确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_aicarzb, DIALOG_STYLE_LIST,"爱车装扮", Showmycarzblist(playerid,P_page[playerid],CUID[Carid]), "确定", "取消");
		}
	}
	return 1;
}
new Spectate[MAX_PLAYERS];
stock SpectateVehicle(playerid, Carid)
{
    Spectate[playerid]=Carid;
	TogglePlayerSpectating(playerid, 1);
	PlayerSpectateVehicle(playerid, Carid);
	return 1;
}
stock UnSpectateVehicle(playerid)
{
	if(Spectate[playerid]!=-1)
	{
		PutPInVehicle(playerid,Spectate[playerid],0);
		Spectate[playerid]=-1;
		return -1;
	}
	else return 1;
}
Dialog:dl_aicarzbczwz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		new Carid=GetPlayerVehicleID(playerid);
		SpectateVehicle(playerid,Carid);
		stop Edit[playerid];
	    pstat[playerid]=EDIT_CAR_ATT_MODE;
	    SetPVarInt(playerid,"ltd",listid);
	    E_dit[playerid][listid][e_id]=AvInfo[CUID[Carid]][listid][av_id];
	    E_dit[playerid][listid][o_X]=AvInfo[CUID[Carid]][listid][v_x];
		E_dit[playerid][listid][o_Y]=AvInfo[CUID[Carid]][listid][v_y];
		E_dit[playerid][listid][o_Z]=AvInfo[CUID[Carid]][listid][v_z];
		E_dit[playerid][listid][r_X]=AvInfo[CUID[Carid]][listid][v_rx];
		E_dit[playerid][listid][r_Y]=AvInfo[CUID[Carid]][listid][v_ry];
		E_dit[playerid][listid][r_Z]=AvInfo[CUID[Carid]][listid][v_rz];
		E_dit[playerid][listid][editmode]=listitem;
	    Edit[playerid]=repeat Editcaratt[50](playerid,listid);
	    SetCameraBehindPlayer(playerid);
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
stock EditValuesCATT(playerid,listid, Float:speed)
{
	new Carid=Spectate[playerid];
	if(pstat[playerid]==EDIT_CAR_ATT_MODE)
	{
		switch(E_dit[playerid][listid][editmode])
		{
  			case EDIT_MODE_PX:
  			{
    			E_dit[playerid][listid][o_X] += speed;
  			}
  			case EDIT_MODE_PY:
  			{
     			E_dit[playerid][listid][o_Y] += speed;
  			}
  			case EDIT_MODE_PZ:
  			{
     			E_dit[playerid][listid][o_Z] += speed;
  			}
  			case EDIT_MODE_RX:
  			{
     			E_dit[playerid][listid][r_X] += ((speed * 360) / 100) * 10;
  			}
  			case EDIT_MODE_RY:
  			{
     			E_dit[playerid][listid][r_Y] += ((speed * 360) / 100) * 10;
  			}
  			case EDIT_MODE_RZ:
  			{
     			E_dit[playerid][listid][r_Z] += ((speed * 360) / 100) * 10;
  			}
		}
		AttachDynamicObjectToVehicle(E_dit[playerid][listid][e_id],VInfo[CUID[Carid]][v_cid],E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y],E_dit[playerid][listid][r_Z]);
	}
}
timer Editcaratt[200](playerid,listid)
{
    new KEYS, UD, LR; GetPlayerKeys( playerid, KEYS, UD, LR );
	new Float:ModifySpeed = 0.025;

	if(KEYS & 8192) { EditValuesCATT(playerid,listid, ModifySpeed); }
	else if (KEYS & 16384) { EditValuesCATT(playerid,listid, -ModifySpeed); }
	if(KEYS & 4)Dialog_Show(playerid, dl_aicarzbend, DIALOG_STYLE_LIST,"汽车装扮编辑","更改位置调节\n保存记录装备\n取消调节装备", "确定", "继续");
	return true;
}
Dialog:dl_aicarzbczwz1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		E_dit[playerid][listid][editmode]=listitem;
	}
	return 1;
}
Dialog:dl_aicarzbend(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		new Carid=Spectate[playerid];
	    switch(listitem)
	    {
	        case 0:Dialog_Show(playerid, dl_aicarzbczwz1, DIALOG_STYLE_LIST, "选择位置", "PX\nPY\nPZ\nRX\nRY\nRZ", "确定", "取消");
	        case 1:
	        {
	        	stop Edit[playerid];
	            AvInfo[CUID[Carid]][listid][v_x]=E_dit[playerid][listid][o_X];
				AvInfo[CUID[Carid]][listid][v_y]=E_dit[playerid][listid][o_Y];
				AvInfo[CUID[Carid]][listid][v_z]=E_dit[playerid][listid][o_Z];
				AvInfo[CUID[Carid]][listid][v_rx]=E_dit[playerid][listid][r_X];
				AvInfo[CUID[Carid]][listid][v_ry]=E_dit[playerid][listid][r_Y];
				AvInfo[CUID[Carid]][listid][v_rz]=E_dit[playerid][listid][r_Z];
				SaveAve(CUID[Carid]);
        		AttachDynamicObjectToVehicle(AvInfo[CUID[Carid]][listid][av_id],VInfo[CUID[Carid]][v_cid],AvInfo[CUID[Carid]][listid][v_x],AvInfo[CUID[Carid]][listid][v_y],AvInfo[CUID[Carid]][listid][v_z],AvInfo[CUID[Carid]][listid][v_rx],AvInfo[CUID[Carid]][listid][v_ry],AvInfo[CUID[Carid]][listid][v_rz]);
   				TogglePlayerSpectating(playerid, 0);
	    		pstat[playerid]=NO_MODE;
	    		DeletePVar(playerid,"listIDA");
	        }
	        case 2:
	        {
				stop Edit[playerid];
        		AttachDynamicObjectToVehicle(AvInfo[CUID[Carid]][listid][av_id],VInfo[CUID[Carid]][v_cid],AvInfo[CUID[Carid]][listid][v_x],AvInfo[CUID[Carid]][listid][v_y],AvInfo[CUID[Carid]][listid][v_z],AvInfo[CUID[Carid]][listid][v_rx],AvInfo[CUID[Carid]][listid][v_ry],AvInfo[CUID[Carid]][listid][v_rz]);
				TogglePlayerSpectating(playerid, 0);
	    		pstat[playerid]=NO_MODE;
	    		DeletePVar(playerid,"listIDA");
	        }
	    }
	}
	return 1;
}
Dialog:dl_aicarzbcz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    new Carid=GetPlayerVehicleID(playerid);
        switch(listitem)
	    {
	        case 0:
	        {
	        	Dialog_Show(playerid,dl_aicarzbczwz, DIALOG_STYLE_LIST, "选择位置", "PX\nPY\nPZ\nRX\nRY\nRZ", "确定", "取消");
	        }
	        case 1:
	        {
	        	SetPVarInt(playerid,"caizhi",1);
	        	ShowJJtxd(playerid,0,Carid);
	        	SpectateVehicle(playerid, Carid);
	        	SM(COLOR_TWAQUA, "使用ALT+C向左翻页，ALT+N向右翻页");
	        	SM(COLOR_TWAQUA, "ALT+左右键选择材质项");
                SM(COLOR_TWAQUA, "选择完成请按空格键");
                SM(COLOR_TWAQUA, "取消选择请按Shitf键");
                SM(COLOR_TWAQUA, "恢复默认请按H键");
	        }
	        case 2:
	        {
				DestroyDynamicObject(AvInfo[CUID[Carid]][listid][av_id]);
	            Iter_Remove(AvInfo[CUID[Carid]],listid);
			    SaveAve(CUID[Carid]);
			    Addbeibao(playerid,AvInfo[CUID[Carid]][listid][av_did],1);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","已放入背包,/wdbb查收", "好的", "");
				new Str[128];
				format(Str,sizeof(Str),"%s把爱车ID%i的装扮%s放入背包,背包该物品剩余%i",Gnn(playerid),Carid,Daoju[AvInfo[CUID[Carid]][listid][av_did]][d_name],GetBeibaoAmout(playerid,AvInfo[CUID[Carid]][listid][av_did]));
				AdminWarn(Str);
	        }
	        case 3:
	        {
				new Str[128];
				format(Str,sizeof(Str),"%s把爱车ID%i的装扮%s销毁",Gnn(playerid),Carid,Daoju[AvInfo[CUID[Carid]][listid][av_did]][d_name]);
				AdminWarn(Str);
	        	DestroyDynamicObject(AvInfo[CUID[Carid]][listid][av_id]);
	            Iter_Remove(AvInfo[CUID[Carid]],listid);
			    SaveAve(CUID[Carid]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","装扮销毁成功", "好的", "");
	        }
	    }
	}
	return 1;
}
Dialog:dl_setvehcc(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new Doorscc[4],Windowscc[4];
	    new Carid=GetPlayerVehicleID(playerid);
	    GetVehicleParamsCarDoors(Carid,Doorscc[0],Doorscc[1],Doorscc[2],Doorscc[3]);
	    GetVehicleParamsCarWindows(Carid,Windowscc[0],Windowscc[1],Windowscc[2],Windowscc[3]);
        switch(listitem)
	    {
	        case 0:
	        {
	            if(!Doorscc[0])
				{
					SetVehicleParamsCarDoors(Carid,1,Doorscc[1],Doorscc[2],Doorscc[3]);
					SM(COLOR_TWAQUA, "你打开了主驾驶车门");
				}
				else
				{
					SetVehicleParamsCarDoors(Carid,0,Doorscc[1],Doorscc[2],Doorscc[3]);
					SM(COLOR_TWAQUA, "你关闭了主驾驶车门");
				}
	        }
	        case 1:
	        {
	            if(!Windowscc[0])
				{
					SetVehicleParamsCarWindows(Carid, 1,Windowscc[1],Windowscc[2],Windowscc[3]);
					SM(COLOR_TWAQUA, "你打开了主驾驶车窗");
				}
				else
				{
					SetVehicleParamsCarWindows(Carid,0,Windowscc[1],Windowscc[2],Windowscc[3]);
					SM(COLOR_TWAQUA, "你关闭了主驾驶车窗");
				}
	        }
	        case 2:
	        {
	            if(!Doorscc[1])
				{
					SetVehicleParamsCarDoors(Carid,Doorscc[0],1,Doorscc[2],Doorscc[3]);
					SM(COLOR_TWAQUA, "你打开了副驾驶车门");
				}
				else
				{
					SetVehicleParamsCarDoors(Carid,Doorscc[0],0,Doorscc[2],Doorscc[3]);
					SM(COLOR_TWAQUA, "你关闭了副驾驶车门");
				}
	        }
	        case 3:
	        {
	            if(!Windowscc[1])
				{
					SetVehicleParamsCarWindows(Carid, Windowscc[0],1,Windowscc[2],Windowscc[3]);
					SM(COLOR_TWAQUA, "你打开了副驾驶车窗");
				}
				else
				{
					SetVehicleParamsCarWindows(Carid,Windowscc[0],0,Windowscc[2],Windowscc[3]);
					SM(COLOR_TWAQUA, "你关闭了副驾驶车窗");
				}
	        }
	        case 4:
	        {
	            if(!Doorscc[2])
				{
					SetVehicleParamsCarDoors(Carid,Doorscc[0],Doorscc[1],1,Doorscc[3]);
					SM(COLOR_TWAQUA, "你打开了左后坐车门");
				}
				else
				{
					SetVehicleParamsCarDoors(Carid,Doorscc[0],Doorscc[1],0,Doorscc[3]);
					SM(COLOR_TWAQUA, "你关闭了左后坐车门");
				}
	        }
	        case 5:
	        {
	            if(!Windowscc[2])
				{
					SetVehicleParamsCarWindows(Carid, Windowscc[0],Windowscc[1],1,Windowscc[3]);
					SM(COLOR_TWAQUA, "你打开了左后坐车窗");
				}
				else
				{
					SetVehicleParamsCarWindows(Carid,Windowscc[0],Windowscc[1],0,Windowscc[3]);
					SM(COLOR_TWAQUA, "你关闭了左后坐车窗");
				}
	        }
	        case 6:
	        {
	            if(!Doorscc[3])
				{
					SetVehicleParamsCarDoors(Carid,Doorscc[0],Doorscc[1],Doorscc[2],1);
					SM(COLOR_TWAQUA, "你打开了右后坐车门");
				}
				else
				{
					SetVehicleParamsCarDoors(Carid,Doorscc[0],Doorscc[1],Doorscc[2],0);
					SM(COLOR_TWAQUA, "你关闭了右后坐车门");
				}
	        }
	        case 7:
	        {
	            if(!Windowscc[3])
				{
					SetVehicleParamsCarWindows(Carid, Windowscc[0],Windowscc[1],Windowscc[2],1);
					SM(COLOR_TWAQUA, "你打开了右后坐车窗");
				}
				else
				{
					SetVehicleParamsCarWindows(Carid,Windowscc[0],Windowscc[1],Windowscc[2],0);
					SM(COLOR_TWAQUA, "你打开了右后坐车窗");
				}
	        }
	    }
	    Dialog_Show(playerid, dl_setvehcc, DIALOG_STYLE_LIST, "车窗开关",Getcarccstr(Carid), "确定", "取消");
	}
	return 1;
}
Dialog:dl_carlist(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new Carid=GetPlayerVehicleID(playerid);
		if(IsACselling(CUID[Carid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网正在出售此爱车,请先下架再试", "好的", "");
        switch(listitem)
	    {
	        case 0:
	        {
			   if(GetPlayerInterior(playerid)!=0||GetPlayerVirtualWorld(playerid)!=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX,"错误","必须在大世界才能定位爱车", "额", "");
	           new Float:x,Float:y,Float:z,Float:a;
			   GetPlayerPos(playerid,x,y,z);
			   GetPlayerFacingAngle(playerid,a);
			   VInfo[CUID[Carid]][v_x]=x;
			   VInfo[CUID[Carid]][v_y]=y;
			   VInfo[CUID[Carid]][v_z]=z;
			   VInfo[CUID[Carid]][v_a]=a;
			   Savedveh_data(CUID[Carid]);
			   Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车定位成功", "好的", "");
	        }
	        case 1:
	        {
	            if(!VInfo[CUID[Carid]][v_lock])
	            {
	                VInfo[CUID[Carid]][v_lock]=1;
	            	Savedveh_data(CUID[Carid]);
	            	Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车已上锁", "好的", "");
	            }
	            else
	            {
	                VInfo[CUID[Carid]][v_lock]=0;
	            	Savedveh_data(CUID[Carid]);
	            	Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车已解锁", "好的", "");
	            }
	        }
	        case 2:
	        {
  				current_number[playerid]=1;
    	    	foreach(new i:AvInfo[CUID[Carid]])
  				{
                    current_idx[playerid][current_number[playerid]]=i;
        			current_number[playerid]++;
  				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"爱车装扮-共计[%i]",current_number[playerid]-1);
				Dialog_Show(playerid, dl_aicarzb, DIALOG_STYLE_LIST,tm, Showmycarzblist(playerid,P_page[playerid],CUID[Carid]), "确定", "取消");
	        }
	        case 3:
	        {
	            if(!VInfo[CUID[Carid]][v_iscol])Dialog_Show(playerid, dl_carlistbianse, DIALOG_STYLE_INPUT,"设置变色时间","请输入时间", "确定", "");
	            else
	            {
	            	VInfo[CUID[Carid]][v_iscol]=0;
					Savedveh_data(CUID[Carid]);
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车标签变色已取消", "好的", "");
	            }
	        }
	        case 4:
	        {
	            Dialog_Show(playerid, dl_setplayerplate, DIALOG_STYLE_INPUT, "设置车牌","请输入内容", "确定", "取消");
	        }
	        case 5:
	        {
	            Dialog_Show(playerid, dl_setvehcc, DIALOG_STYLE_LIST, "车窗开关",Getcarccstr(Carid), "确定", "取消");
	        }
	        case 6:
	        {
	            Dialog_Show(playerid,dl_putbb, DIALOG_STYLE_MSGBOX, "提醒","爱车即将放入背包，请确保没有装扮物品，否则吞掉概不负责", "好的", "");
	        }
	        case 7:
			{
			    if(!VInfo[CUID[Carid]][v_Value])Dialog_Show(playerid, dl_sellplaycar, DIALOG_STYLE_INPUT, "出售爱车","请输入出售的价格", "确定", "取消");
				else
				{
				    VInfo[CUID[Carid]][v_issel]=OWNERS;
				    VInfo[CUID[Carid]][v_Value]=0;
					DeleteColor3DTextLabel(VInfo[CUID[Carid]][v_text]);
					Createcar3D(Carid);
				    Savedveh_data(CUID[Carid]);
				    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车取消出售", "好的", "");
				}
			}
	        case 8:
			{
    	    	foreach(new i:AvInfo[CUID[Carid]])
  				{
  					DestroyDynamicObject(AvInfo[CUID[Carid]][i][av_id]);
  				}
    			DeleteColor3DTextLabel(VInfo[CUID[Carid]][v_text]);
	   			DestroyVehicle(Carid);
    			if(fexist(Get_Path(CUID[Carid],0)))fremove(Get_Path(CUID[Carid],0));
    			if(fexist(Get_Path(CUID[Carid],8)))fremove(Get_Path(CUID[Carid],8));
			    Iter_Clear(AvInfo[CUID[Carid]]);
			    Iter_Remove(VInfo,CUID[Carid]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车已被系统删除", "好的", "");
			}
	    }
	}
	return 1;
}
stock Getcarccstr(vcid)
{
    new Doorscc[4],Windowscc[4];
    GetVehicleParamsCarDoors(vcid,Doorscc[0],Doorscc[1],Doorscc[2],Doorscc[3]);
    GetVehicleParamsCarWindows(vcid,Windowscc[0],Windowscc[1],Windowscc[2],Windowscc[3]);
 	new Astr[1024],Str[80];
	if(!Doorscc[0])format(Str, sizeof(Str), "主驾驶车门:关闭\n");
	else format(Str, sizeof(Str), "主驾驶车门:开启\n");
	strcat(Astr,Str);
	if(!Windowscc[0])format(Str, sizeof(Str), "主驾驶车窗:关闭\n");
	else format(Str, sizeof(Str), "主驾驶车窗:开启\n");
	strcat(Astr,Str);
	if(!Doorscc[1])format(Str, sizeof(Str), "副驾驶车门:关闭\n");
	else format(Str, sizeof(Str), "副驾驶车门:开启\n");
	strcat(Astr,Str);
	if(!Windowscc[1])format(Str, sizeof(Str), "副驾驶车窗:关闭\n");
	else format(Str, sizeof(Str), "副驾驶车窗:开启\n");
	strcat(Astr,Str);
	if(!Doorscc[2])format(Str, sizeof(Str), "左后坐车门:关闭\n");
	else format(Str, sizeof(Str), "左后坐车门:开启\n");
	strcat(Astr,Str);
	if(!Windowscc[2])format(Str, sizeof(Str), "左后坐车窗:关闭\n");
	else format(Str, sizeof(Str), "左后坐车窗:开启\n");
	strcat(Astr,Str);
	if(!Doorscc[3])format(Str, sizeof(Str), "右后坐车门:关闭\n");
	else format(Str, sizeof(Str), "右后坐车门:开启\n");
	strcat(Astr,Str);
	if(!Windowscc[3])format(Str, sizeof(Str), "右后坐车窗:关闭\n");
	else format(Str, sizeof(Str), "右后坐车窗:开启\n");
	strcat(Astr,Str);
	return Astr;
}
Dialog:dl_carlistbianse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new Carid=GetPlayerVehicleID(playerid);
        if(strval(inputtext)<1||strval(inputtext)>500)return Dialog_Show(playerid, dl_carlistbianse, DIALOG_STYLE_INPUT,"设置变色时间","请输入时间", "确定", "取消");
		VInfo[CUID[Carid]][v_iscol]=1;
        VInfo[CUID[Carid]][v_time]=strval(inputtext);
		DeleteColor3DTextLabel(VInfo[CUID[Carid]][v_text]);
		Createcar3D(Carid);
		Savedveh_data(CUID[Carid]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","爱车标签变色设置成功", "好的", "");
	}
	else Dialog_Show(playerid, dl_carlistbianse, DIALOG_STYLE_INPUT,"设置变色时间","请输入时间", "确定", "");
	return 1;
}
Dialog:dl_fangxia(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ApplyAnimation(playerid,"CARRY","liftup",4,0,0,1,1,1);
        defer fangxia[1000](playerid);
	}
	return 1;
}
Function Restplayercur(playerid)
{
	foreach(new i:Player)
	{
		if(AvailablePlayer(i))
		{
		    if(pcurrent_jj[i]!=-1)
		    {
		        if(pcurrent_jj[i]==pcurrent_jj[playerid])
		        {
		            pcurrent_jj[i]=-1;
		        }
		    }
		}
	}
	return 1;
}
Function updateobj(jj)
{
 	foreach(new i:Player)
    {
		if(AvailablePlayer(i))
		{
		    if(PlayerToPoint(100,i,JJ[jj][jx],JJ[jj][jy],JJ[jj][jz],JJ[jj][jin],JJ[jj][jwl]))
		    {
				Streamer_UpdateEx(i,JJ[jj][jx],JJ[jj][jy],JJ[jj][jz],JJ[jj][jin],JJ[jj][jwl]);
			}
		}
	}
	return 1;
}
Dialog:dl_jiajubianse(playerid, response, listitem, inputtext[])
{
    PvailJJ(playerid);
	if(response)
	{
        Dialog_Show(playerid, dl_jiajubiansetime, DIALOG_STYLE_INPUT,"设置变色时间","请输入时间", "确定", "");
	}
	else
	{
		JJ[pcurrent_jj[playerid]][jiscol]=0;
		DeleteColor3DTextLabel(JJ[pcurrent_jj[playerid]][jtext]);
		CreateJJtext(pcurrent_jj[playerid]);
		Savedjj_data(pcurrent_jj[playerid]);
		JJ[pcurrent_jj[playerid]][jused]=false;
		pcurrent_jj[playerid]=-1;
	}
	return 1;
}
Dialog:dl_jiajubiansetime(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
        if(strval(inputtext)<1||strval(inputtext)>500)return Dialog_Show(playerid, dl_jiajubiansetime, DIALOG_STYLE_INPUT,"设置变色时间","请输入时间", "确定", "取消");
        JJ[pcurrent_jj[playerid]][jiscol]=1;
        JJ[pcurrent_jj[playerid]][jcoltime]=strval(inputtext);
		DeleteColor3DTextLabel(JJ[pcurrent_jj[playerid]][jtext]);
		CreateJJtext(pcurrent_jj[playerid]);
		JJ[pcurrent_jj[playerid]][jused]=false;
		Savedjj_data(pcurrent_jj[playerid]);
		pcurrent_jj[playerid]=-1;
	}
	else Dialog_Show(playerid, dl_jiajubiansetime, DIALOG_STYLE_INPUT,"设置变色时间","请输入时间", "确定", "取消");
	return 1;
}
Dialog:dl_jiajuxuanzebuwei(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
        new i=SetPlayerAttachedObjectEx(playerid,Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_obj],listitem+1,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,0,0);
		att[playerid][i][att_id]=i;
        att[playerid][i][att_type]=DAOJU_TYPE_JIAJU;
        att[playerid][i][att_did]=JJ[pcurrent_jj[playerid]][jdid];
        att[playerid][i][att_modelid]=Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_obj];
        att[playerid][i][att_boneid]=listitem+1;
        att[playerid][i][att_fOffsetX]=0;
        att[playerid][i][att_fOffsetY]=0;
        att[playerid][i][att_fOffsetZ]=0;
        att[playerid][i][att_fRotX]=0;
        att[playerid][i][att_fRotY]=0;
        att[playerid][i][att_fRotZ]=0;
        att[playerid][i][att_fScaleX]=1.0;
        att[playerid][i][att_fScaleY]=1.0;
        att[playerid][i][att_fScaleZ]=1.0;
        att[playerid][i][att_materialcolor1]=0;
        att[playerid][i][att_materialcolor2]=0;
		att[playerid][i][att_iscol]=0;
		att[playerid][i][att_jcoltime]=0;
		att[playerid][i][att_ismater]=0;
        Iter_Add(att[playerid],i);
        SaveAtt(playerid);
		JJ[pcurrent_jj[playerid]][jused]=true;
		DelJJ(pcurrent_jj[playerid]);
		DelJJfile(pcurrent_jj[playerid]);
    	Iter_Remove(JJ,pcurrent_jj[playerid]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","家具已经装备可以编辑了", "好的", "");
		new Str[128];
		format(Str,sizeof(Str),"%s把背包里的%s装备在了身上SLOT%i,背包此物品剩余%i",Gnn(playerid),Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_name],i,GetBeibaoAmout(playerid,JJ[pcurrent_jj[playerid]][jdid]));
		AdminWarn(Str);
		Restplayercur(playerid);
		pcurrent_jj[playerid]=-1;
		pstat[playerid]=EDIT_ATT_MODE;
		SetPVarInt(playerid,"ltd",i);
		EditAttachedObject(playerid,att[playerid][i][att_id]);
	}
	else
	{
		JJ[pcurrent_jj[playerid]][jused]=false;
		pcurrent_jj[playerid]=-1;
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你取消了装备家具", "好的", "");
	}
	return 1;
}
public OnPlayerEditAttachedObject( playerid, response, index, modelid, boneid,Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	if(response)
	{
		if(pstat[playerid]==EDIT_ATT_MODE)
		{
			att[playerid][index][att_fOffsetX]=fOffsetX;
			att[playerid][index][att_fOffsetY]=fOffsetY;
			att[playerid][index][att_fOffsetZ]=fOffsetZ;
			att[playerid][index][att_fRotX]=fRotX;
			att[playerid][index][att_fRotY]=fRotY;
			att[playerid][index][att_fRotZ]=fRotZ;
			att[playerid][index][att_fScaleX]=fScaleX;
			att[playerid][index][att_fScaleY]=fScaleY;
			att[playerid][index][att_fScaleZ]=fScaleZ;
			UpdatePlayerAttachedObjectEx(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ,att[playerid][index][att_materialcolor1],att[playerid][index][att_materialcolor2],att[playerid][index][att_iscol],att[playerid][index][att_jcoltime],att[playerid][index][att_ismater]);
            SaveAtt(playerid);
		}
	}
	else
	{
        	fOffsetX=att[playerid][index][att_fOffsetX];
			fOffsetY=att[playerid][index][att_fOffsetY];
			fOffsetZ=att[playerid][index][att_fOffsetZ];
			fRotX=att[playerid][index][att_fRotX];
			fRotY=att[playerid][index][att_fRotY];
			fRotZ=att[playerid][index][att_fRotZ];
			fScaleX=att[playerid][index][att_fScaleX];
			fScaleY=att[playerid][index][att_fScaleY];
			fScaleZ=att[playerid][index][att_fScaleZ];
			UpdatePlayerAttachedObjectEx(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ,att[playerid][index][att_materialcolor1],att[playerid][index][att_materialcolor2],att[playerid][index][att_iscol],att[playerid][index][att_jcoltime],att[playerid][index][att_ismater]);
	}
	pstat[playerid]=NO_MODE;
	return 1;
}
CMD:wdzb(playerid, params[], help)
{
	current_number[playerid]=1;
	foreach(new i:att[playerid])
	{
		current_idx[playerid][current_number[playerid]]=i;
       	current_number[playerid]++;
	}
	if(current_number[playerid]==1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有装扮物品", "额", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的装备[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_myatt, DIALOG_STYLE_LIST,tm, Showmyattlist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
Dialog:dl_myatt(playerid, response, listitem, inputtext[])
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
   			Dialog_Show(playerid, dl_myatt, DIALOG_STYLE_LIST,"我的装备", Showmyattlist(playerid,P_page[playerid]), "确定", "取消");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
            Dialog_Show(playerid,dl_myzbdb, DIALOG_STYLE_INPUT, "打包装备", "请给要打包的装备命名", "确定", "取消");
		}
		else
		{
		    if(GetAreaJJprotect(playerid)||Ishousepro(playerid))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","地盘或房产已开启装扮保护，无法进行此操作", "好的", "");
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
            Dialog_Show(playerid, dl_myatteidt, DIALOG_STYLE_LIST,"装备编辑","调整位置\n更改颜色\n卸下装备", "确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_myatt, DIALOG_STYLE_LIST,"我的装备", Showmyattlist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_myattbianji(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
	    pstat[playerid]=EDIT_ATT_MODE;
	    SetPVarInt(playerid,"ltd",listid);
		EditAttachedObject(playerid,listid);
		DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid, dl_myattbianjiwz, DIALOG_STYLE_LIST, "选择位置", "PX\nPY\nPZ\nRX\nRY\nRZ\nSX\nSY\nSZ", "确定", "取消");
	return 1;
}
Dialog:dl_myattbianjiwz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		stop Edit[playerid];
	    pstat[playerid]=EDIT_ATT_MODE;
	    SetPVarInt(playerid,"ltd",listid);
	    E_dit[playerid][listid][e_id]=listid;
	    E_dit[playerid][listid][e_modelid]=att[playerid][listid][att_modelid];
	    E_dit[playerid][listid][e_boneid]=att[playerid][listid][att_boneid];
	    E_dit[playerid][listid][o_X]=att[playerid][listid][att_fOffsetX];
		E_dit[playerid][listid][o_Y]=att[playerid][listid][att_fOffsetY];
		E_dit[playerid][listid][o_Z]=att[playerid][listid][att_fOffsetZ];
		E_dit[playerid][listid][r_X]=att[playerid][listid][att_fRotX];
		E_dit[playerid][listid][r_Y]=att[playerid][listid][att_fRotY];
		E_dit[playerid][listid][r_Z]=att[playerid][listid][att_fRotZ];
		E_dit[playerid][listid][s_X]=att[playerid][listid][att_fScaleX];
		E_dit[playerid][listid][s_Y]=att[playerid][listid][att_fScaleY];
		E_dit[playerid][listid][s_Z]=att[playerid][listid][att_fScaleZ];
		E_dit[playerid][listid][editmode]=listitem;
	    Edit[playerid]=repeat Editatt[50](playerid,listid);
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_myattbianjiwz1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		E_dit[playerid][listid][editmode]=listitem;
	}
	return 1;
}
stock EditValues(playerid,listid, Float:speed)
{
	if(pstat[playerid]==EDIT_ATT_MODE)
	{
		switch(E_dit[playerid][listid][editmode])
		{
		    case EDIT_MODE_PX:
		    {
		    	E_dit[playerid][listid][o_X] += speed;
		    }
		    case EDIT_MODE_PY:
		    {
		        E_dit[playerid][listid][o_Y] += speed;
		    }
		    case EDIT_MODE_PZ:
		    {
		        E_dit[playerid][listid][o_Z] += speed;
		    }
		    case EDIT_MODE_RX:
		    {
		        E_dit[playerid][listid][r_X] += ((speed * 360) / 100) * 10;
		    }
		    case EDIT_MODE_RY:
		    {
		        E_dit[playerid][listid][r_Y] += ((speed * 360) / 100) * 10;
		    }
		    case EDIT_MODE_RZ:
		    {
		        E_dit[playerid][listid][r_Z] += ((speed * 360) / 100) * 10;
		    }
		    case EDIT_MODE_SX:
		    {
		        E_dit[playerid][listid][s_X] += speed;
		    }
		    case EDIT_MODE_SY:
		    {
		        E_dit[playerid][listid][s_Y] += speed;
		    }
		    case EDIT_MODE_SZ:
		    {
		    	E_dit[playerid][listid][s_Z] += speed;
		    }
		}
		UpdatePlayerAttachedObjectEx(playerid,E_dit[playerid][listid][e_id],E_dit[playerid][listid][e_modelid],E_dit[playerid][listid][e_boneid],
		E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y],
		E_dit[playerid][listid][r_Z],E_dit[playerid][listid][s_X],E_dit[playerid][listid][s_Y],E_dit[playerid][listid][s_Z],att[playerid][listid][att_materialcolor1],
		att[playerid][listid][att_materialcolor2],att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime],att[playerid][listid][att_ismater]);
	}

}
timer Editatt[200](playerid,listid)
{
    new KEYS, UD, LR; GetPlayerKeys( playerid, KEYS, UD, LR );
	new Float:ModifySpeed = 0.025;

	if(KEYS & 8192) { EditValues(playerid,listid, ModifySpeed); }
	else if (KEYS & 16384) { EditValues(playerid,listid, -ModifySpeed); }
	if(KEYS & KEY_WALK)Dialog_Show(playerid, dl_myatteidtend, DIALOG_STYLE_LIST,"装备编辑","更改位置调节\n保存记录装备\n取消调节装备", "确定", "继续");
	return true;
}
Dialog:dl_myatteidtend(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:Dialog_Show(playerid, dl_myattbianjiwz1, DIALOG_STYLE_LIST, "选择位置", "PX\nPY\nPZ\nRX\nRY\nRZ\nSX\nSY\nSZ", "确定", "取消");
	        case 1:
	        {
	        	stop Edit[playerid];
	            att[playerid][listid][att_fOffsetX]=E_dit[playerid][listid][o_X];
				att[playerid][listid][att_fOffsetY]=E_dit[playerid][listid][o_Y];
				att[playerid][listid][att_fOffsetZ]=E_dit[playerid][listid][o_Z];
				att[playerid][listid][att_fRotX]=E_dit[playerid][listid][r_X];
				att[playerid][listid][att_fRotY]=E_dit[playerid][listid][r_Y];
				att[playerid][listid][att_fRotZ]=E_dit[playerid][listid][r_Z];
				att[playerid][listid][att_fScaleX]=E_dit[playerid][listid][s_X];
				att[playerid][listid][att_fScaleY]=E_dit[playerid][listid][s_Y];
				att[playerid][listid][att_fScaleZ]=E_dit[playerid][listid][s_Z];
	    		SaveAtt(playerid);
        		UpdatePlayerAttachedObjectEx(playerid,listid,att[playerid][listid][att_modelid],att[playerid][listid][att_boneid],att[playerid][listid][att_fOffsetX],
				 att[playerid][listid][att_fOffsetY],att[playerid][listid][att_fOffsetZ],att[playerid][listid][att_fRotX],att[playerid][listid][att_fRotY],att[playerid][listid][att_fRotZ],
				 att[playerid][listid][att_fScaleX],att[playerid][listid][att_fScaleY],att[playerid][listid][att_fScaleZ],att[playerid][listid][att_materialcolor1],att[playerid][listid][att_materialcolor2],
				 att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime],att[playerid][listid][att_ismater]);
	    		DeletePVar(playerid,"listIDA");
	    		pstat[playerid]=NO_MODE;

	        }
	        case 2:
	        {
				stop Edit[playerid];
        		UpdatePlayerAttachedObjectEx(playerid,listid,att[playerid][listid][att_modelid],att[playerid][listid][att_boneid],att[playerid][listid][att_fOffsetX],
				 att[playerid][listid][att_fOffsetY],att[playerid][listid][att_fOffsetZ],att[playerid][listid][att_fRotX],att[playerid][listid][att_fRotY],att[playerid][listid][att_fRotZ],
				 att[playerid][listid][att_fScaleX],att[playerid][listid][att_fScaleY],att[playerid][listid][att_fScaleZ],att[playerid][listid][att_materialcolor1],att[playerid][listid][att_materialcolor2],
				 att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime],att[playerid][listid][att_ismater]);
				DeletePVar(playerid,"listIDA");
				pstat[playerid]=NO_MODE;
	        }
	    }
	}
	return 1;
}
Dialog:dl_myatteidt(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(att[playerid][listid][att_iscol]==1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","请先关闭自动换色", "好的", "");
	            Dialog_Show(playerid, dl_myattbianji, DIALOG_STYLE_MSGBOX, "调整位置","请选择调整方式", "鼠标模式", "按键模式");
	        }
	        case 1:
	        {
	            Dialog_Show(playerid, dl_myattcolor, DIALOG_STYLE_LIST, "更改颜色", "更改颜色\n自动换色", "确定", "取消");
	        }
	        case 2:
	        {
	            Addbeibao(playerid,att[playerid][listid][att_did],1);
	            RemovePlayerAttachedObjectEx(playerid,listid);
	            Iter_Remove(att[playerid],listid);
	            SaveAtt(playerid);
	            DeletePVar(playerid,"listIDA");
	            Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","装备已送入你的背包", "好的", "");
	        }
	    }
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_myattcolorgg(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
	    att[playerid][listid][att_ismater]=1;
        att[playerid][listid][att_materialcolor1]=listitem;
        att[playerid][listid][att_materialcolor2]=listitem;
        UpdatePlayerAttachedObjectEx(playerid,listid,att[playerid][listid][att_modelid],att[playerid][listid][att_boneid],att[playerid][listid][att_fOffsetX],
				 att[playerid][listid][att_fOffsetY],att[playerid][listid][att_fOffsetZ],att[playerid][listid][att_fRotX],att[playerid][listid][att_fRotY],att[playerid][listid][att_fRotZ],
				 att[playerid][listid][att_fScaleX],att[playerid][listid][att_fScaleY],att[playerid][listid][att_fScaleZ],att[playerid][listid][att_materialcolor1],att[playerid][listid][att_materialcolor2],
				 att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime],att[playerid][listid][att_ismater]);
		DeletePVar(playerid,"listIDA");
	    SaveAtt(playerid);
	}
	else
	{
	    att[playerid][listid][att_ismater]=0;
        att[playerid][listid][att_materialcolor1]=0;
        att[playerid][listid][att_materialcolor2]=0;
        UpdatePlayerAttachedObjectEx(playerid,listid,att[playerid][listid][att_modelid],att[playerid][listid][att_boneid],att[playerid][listid][att_fOffsetX],
				 att[playerid][listid][att_fOffsetY],att[playerid][listid][att_fOffsetZ],att[playerid][listid][att_fRotX],att[playerid][listid][att_fRotY],att[playerid][listid][att_fRotZ],
				 att[playerid][listid][att_fScaleX],att[playerid][listid][att_fScaleY],att[playerid][listid][att_fScaleZ],att[playerid][listid][att_materialcolor1],att[playerid][listid][att_materialcolor2],
				 att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime],att[playerid][listid][att_ismater]);
		DeletePVar(playerid,"listIDA");
	    SaveAtt(playerid);
	}
	return 1;
}
Dialog:dl_myattcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_myattcolorgg,DIALOG_STYLE_LIST,"选择",tmp,"选择颜色", "取消颜色");
	        }
	        case 1:
	        {
	        	new listid=GetPVarInt(playerid,"listIDA");
	            if(att[playerid][listid][att_iscol]==0)Dialog_Show(playerid, dl_myattcolorzdbs, DIALOG_STYLE_INPUT, "请输入变色间隔", "请输入变色间隔[1-500]", "确定", "取消");
				else
				{
				    att[playerid][listid][att_iscol]=0;
				    att[playerid][listid][att_jcoltime]=0;
				    RegulatePlayerAttachedObjectEx(playerid,listid,att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime]);
				    SaveAtt(playerid);
				    DeletePVar(playerid,"listIDA");
				}
	        }
	    }
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_myattcolorzdbs(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext)<1||strval(inputtext)>500)return Dialog_Show(playerid, dl_myattcolorzdbs, DIALOG_STYLE_INPUT, "请输入变色间隔", "请输入变色间隔[1-500]", "确定", "取消");
		new listid=GetPVarInt(playerid,"listIDA");
		att[playerid][listid][att_iscol]=1;
		att[playerid][listid][att_jcoltime]=strval(inputtext);
        UpdatePlayerAttachedObjectEx(playerid,listid,att[playerid][listid][att_modelid],att[playerid][listid][att_boneid],att[playerid][listid][att_fOffsetX],
				 att[playerid][listid][att_fOffsetY],att[playerid][listid][att_fOffsetZ],att[playerid][listid][att_fRotX],att[playerid][listid][att_fRotY],att[playerid][listid][att_fRotZ],
				 att[playerid][listid][att_fScaleX],att[playerid][listid][att_fScaleY],att[playerid][listid][att_fScaleZ],att[playerid][listid][att_materialcolor1],att[playerid][listid][att_materialcolor2],
				 att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime],att[playerid][listid][att_ismater]);
		SaveAtt(playerid);
	}
	else DeletePVar(playerid,"listIDA");
	return 1;
}
stock Showmyattlist(playerid,pager)
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
        new tmps[200];
        if(i<current_number[playerid])
        {
            format(tmps,100,"装备名:%s - 位置:%s - ",Daoju[att[playerid][current_idx[playerid][i]][att_did]][d_name],AttachmentBones[att[playerid][current_idx[playerid][i]][att_boneid]-1]);
		    strcat(tmp,tmps);
		    switch(Daoju[att[playerid][current_idx[playerid][i]][att_did]][d_type])
		    {
		        case DAOJU_TYPE_JIAJU:
				{
					format(tmps,100,"类型:家具\n");
				}
		        case DAOJU_TYPE_WEAPON:
				{
					format(tmps,100,"类型:武器家具\n");
				}
		    }
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}打包装备");
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

Dialog:dl_jiajusz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
	    if(JJ[pcurrent_jj[playerid]][jused]==false)
		{
			PvailJJ(playerid);
			JJ[pcurrent_jj[playerid]][jused]=true;
	        switch(listitem)
	        {
	            case 0:
				{
			        ApplyAnimation(playerid,"CARRY","liftup",4,0,0,1,1,1);
			    	defer juqi[1500](playerid);
				}
	            case 1:
				{
					pstat[playerid]=EDIT_JJ_MODE;
					DeleteColor3DTextLabel(JJ[pcurrent_jj[playerid]][jtext]);
					EditDynamicObject(playerid,JJ[pcurrent_jj[playerid]][jid]);
				}
	            case 2:
				{
	                Dialog_Show(playerid, dl_jiajubianse, DIALOG_STYLE_MSGBOX,"设置变色","请选择", "变色", "不变色");
				}
	            case 3:
				{
			        SetPVarInt(playerid,"caizhi",0);
	                ShowJJtxd(playerid);
	                SM(COLOR_TWAQUA, "使用ALT+C向左翻页，ALT+N向右翻页");
	                SM(COLOR_TWAQUA, "选择完成请按空格键");
		            SM(COLOR_TWAQUA, "取消选择请按Shitf键");
	                SM(COLOR_TWAQUA, "恢复默认请按H键");
				}
	            case 4:
				{
	                Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
				}
	            case 5:
				{
	                if(!JJ[pcurrent_jj[playerid]][jmove])
	                {
					    pstat[playerid]=EDIT_JJ_MOVE_MODE;
					    EditDynamicObject(playerid,JJ[pcurrent_jj[playerid]][jid]);
	                }
	                else
	                {
	                    JJ[pcurrent_jj[playerid]][jmove]=0;
	                    JJ[pcurrent_jj[playerid]][jmovespeed]=0;
	                    JJ[pcurrent_jj[playerid]][jmovestat]=0;
	                    JJ[pcurrent_jj[playerid]][jmovex]=0.0;
	                    JJ[pcurrent_jj[playerid]][jmovey]=0.0;
	                    JJ[pcurrent_jj[playerid]][jmovez]=0.0;
	                    JJ[pcurrent_jj[playerid]][jmoverx]=0.0;
	                    JJ[pcurrent_jj[playerid]][jmovery]=0.0;
	                    JJ[pcurrent_jj[playerid]][jmoverz]=0.0;
	                    Savedjj_data(pcurrent_jj[playerid]);
	                    JJ[pcurrent_jj[playerid]][jused]=false;
	                    pcurrent_jj[playerid]=-1;
					}
				}
	            case 6:
				{
	                Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
				}
	            case 7:
				{
				    if(IsplayerHaveAttSlot(playerid))
				    {
					    new attBones[256],Stru[32];
					    Loop(i,sizeof(AttachmentBones))
					    {
						    format(Stru, sizeof(Stru),"【%s】\n",AttachmentBones[i]);
						    strcat(attBones,Stru);
					    }
					    Dialog_Show(playerid, dl_jiajuxuanzebuwei, DIALOG_STYLE_LIST,"部位选择",attBones,"确定","取消");
				    }
				    else
				    {
					    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你的附体已满", "好的", "");
					    JJ[pcurrent_jj[playerid]][jused]=false;
					    pcurrent_jj[playerid]=-1;
				    }
				}
	            case 8:
				{
			    	Addbeibao(playerid,JJ[pcurrent_jj[playerid]][jdid],1);
			        DelJJ(pcurrent_jj[playerid]);
			        DelJJfile(pcurrent_jj[playerid]);
	   				Iter_Remove(JJ,pcurrent_jj[playerid]);
			    	Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","已放入背包,/wdbb查收", "好的", "");
					new Str[128];
				    format(Str,sizeof(Str),"%s放入背包1个%s,背包该物品剩余%i",Gnn(playerid),Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_name],GetBeibaoAmout(playerid,JJ[pcurrent_jj[playerid]][jdid]));
					AdminWarn(Str);
				    format(Str,sizeof(Str),"%s放入背包1个%s",Gnn(playerid),Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_name]);
					ProxDetector(20.0,playerid,Str,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
					Restplayercur(playerid);
					pcurrent_jj[playerid]=-1;
				}
			}
        }
		else
		{
			new tm[64];
			format(tm,64,"家具:%s  正在被其他人操作",Daoju[JJ[pcurrent_jj[playerid]][jdid]][d_name]);
			Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "好的", "");
			pcurrent_jj[playerid]=-1;
		}
	}
	else pcurrent_jj[playerid]=-1;
	return 1;
}
Dialog:dl_jiajumovespeed(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PvailJJ(playerid);
		if(strval(inputtext)<1||strval(inputtext)>10)return Dialog_Show(playerid,dl_jiajumovespeed,DIALOG_STYLE_INPUT,"家具移动","请设置移动速度[1-10]","确定", "取消");
		JJ[pcurrent_jj[playerid]][jmove]=1;
		JJ[pcurrent_jj[playerid]][jmovespeed]=strval(inputtext);
		JJ[pcurrent_jj[playerid]][jmovestat]=0;
		Savedjj_data(pcurrent_jj[playerid]);
		JJ[pcurrent_jj[playerid]][jused]=false;
		pcurrent_jj[playerid]=-1;
		pstat[playerid]=NO_MODE;
	}
	else 
	{
		 JJ[pcurrent_jj[playerid]][jmove]=0;
		 JJ[pcurrent_jj[playerid]][jmovespeed]=0;
		 JJ[pcurrent_jj[playerid]][jmovestat]=0;
		 JJ[pcurrent_jj[playerid]][jmovex]=0.0;
		 JJ[pcurrent_jj[playerid]][jmovey]=0.0;
		 JJ[pcurrent_jj[playerid]][jmovez]=0.0;
		 JJ[pcurrent_jj[playerid]][jmoverx]=0.0;
		 JJ[pcurrent_jj[playerid]][jmovery]=0.0;
		 JJ[pcurrent_jj[playerid]][jmoverz]=0.0;
		 Savedjj_data(pcurrent_jj[playerid]);
		 JJ[pcurrent_jj[playerid]][jused]=false;
		 pcurrent_jj[playerid]=-1;
		 pstat[playerid]=NO_MODE;
	}
   	return 1;
}
Dialog:dl_jiajuxzspeed(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PvailJJ(playerid);
		if(strval(inputtext)<1||strval(inputtext)>20)return Dialog_Show(playerid,dl_jiajuxzspeed,DIALOG_STYLE_INPUT,"家具旋转","请设置旋转速度[1-20]","确定", "取消");
		JJ[pcurrent_jj[playerid]][jrotspeed]=strval(inputtext);
		Savedjj_data(pcurrent_jj[playerid]);
		Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
   	return 1;
}
Dialog:dl_jiajuxzrx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PvailJJ(playerid);
        switch(listitem)
        {
            case 0:
			{
				JJ[pcurrent_jj[playerid]][jrotx]=1;
				Savedjj_data(pcurrent_jj[playerid]);
			}
            case 1:
			{
				JJ[pcurrent_jj[playerid]][jrotx]=2;
				Savedjj_data(pcurrent_jj[playerid]);
			}
            case 2:
			{
				JJ[pcurrent_jj[playerid]][jrotx]=0;
				Savedjj_data(pcurrent_jj[playerid]);
			}
        }
        Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
   	return 1;
}
Dialog:dl_jiajuxzry(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PvailJJ(playerid);
        switch(listitem)
        {
            case 0:
			{
				JJ[pcurrent_jj[playerid]][jroty]=1;
				Savedjj_data(pcurrent_jj[playerid]);
			}
            case 1:
			{
				JJ[pcurrent_jj[playerid]][jroty]=2;
				Savedjj_data(pcurrent_jj[playerid]);
			}
            case 2:
			{
				JJ[pcurrent_jj[playerid]][jroty]=0;
				Savedjj_data(pcurrent_jj[playerid]);
			}
        }
        Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
   	return 1;
}
Dialog:dl_jiajuxzrz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PvailJJ(playerid);
        switch(listitem)
        {
            case 0:
			{
				JJ[pcurrent_jj[playerid]][jrotz]=1;
				Savedjj_data(pcurrent_jj[playerid]);
			}
            case 1:
			{
				JJ[pcurrent_jj[playerid]][jrotz]=2;
				Savedjj_data(pcurrent_jj[playerid]);
			}
            case 2:
			{
				JJ[pcurrent_jj[playerid]][jrotz]=0;
				Savedjj_data(pcurrent_jj[playerid]);
			}
        }
        Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
   	return 1;
}
Dialog:dl_jiajuxz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		PvailJJ(playerid);
        switch(listitem)
        {
            case 0:
			{
			    if(JJ[pcurrent_jj[playerid]][jrotspeed]>0)
				{
					StopRotJJ(pcurrent_jj[playerid]);
					Savedjj_data(pcurrent_jj[playerid]);
					Dialog_Show(playerid,dl_jiajuxz,DIALOG_STYLE_LIST,"家具旋转",ShowJJxuanzhuan(pcurrent_jj[playerid]),"选择", "取消");
				}
				else Dialog_Show(playerid,dl_jiajuxzspeed,DIALOG_STYLE_INPUT,"家具旋转","请设置旋转速度","确定", "取消");
			}
            case 1:Dialog_Show(playerid,dl_jiajuxzrx,DIALOG_STYLE_LIST,"家具旋转","向右\n向左\n关闭","选择", "取消");
            case 2:Dialog_Show(playerid,dl_jiajuxzry,DIALOG_STYLE_LIST,"家具旋转","向右\n向左\n关闭","选择", "取消");
            case 3:Dialog_Show(playerid,dl_jiajuxzrz,DIALOG_STYLE_LIST,"家具旋转","向右\n向左\n关闭","选择", "取消");
		}
	}
	else
	{
	    JJ[pcurrent_jj[playerid]][jused]=false;
	    pcurrent_jj[playerid]=-1;
	}
	return 1;
}
			
stock ShowJJxuanzhuan(listid)
{
	new Astr[512],Str[64];
	if(JJ[listid][jrotspeed]>0)
	{
		format(Str, sizeof(Str), "旋转[开] 速度[%i]\n",JJ[listid][jrotspeed]);
		strcat(Astr,Str);
		switch(JJ[listid][jrotx])
		{
		    case 0:format(Str, sizeof(Str), "X轴[关闭]\n");
		    case 1:format(Str, sizeof(Str), "X轴[向右]\n");
		    case 2:format(Str, sizeof(Str), "X轴[向左]\n");
		}
		strcat(Astr,Str);
		switch(JJ[listid][jroty])
		{
		    case 0:format(Str, sizeof(Str), "Y轴[关闭]\n");
		    case 1:format(Str, sizeof(Str), "Y轴[向右]\n");
		    case 2:format(Str, sizeof(Str), "Y轴[向左]\n");
		}
		strcat(Astr,Str);
		switch(JJ[listid][jrotz])
		{
		    case 0:format(Str, sizeof(Str), "Z轴[关闭]\n");
		    case 1:format(Str, sizeof(Str), "Z轴[向右]\n");
		    case 2:format(Str, sizeof(Str), "Z轴[向左]\n");
		}
		strcat(Astr,Str);
	}
	else
	{
		format(Str, sizeof(Str), "旋转[关]\n",JJ[listid][jrotspeed]);
		strcat(Astr,Str);
	}
	return Astr;
}
public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	switch(pstat[playerid])
	{
	    case EDIT_JJ_MODE:
		{
			if(objectid==JJ[pcurrent_jj[playerid]][jid])
			{
				if(response ==EDIT_RESPONSE_FINAL)
				{
					JJ[pcurrent_jj[playerid]][jx]=x;
					JJ[pcurrent_jj[playerid]][jy]=y;
					JJ[pcurrent_jj[playerid]][jz]=z;
					JJ[pcurrent_jj[playerid]][jrx]=rx;
					JJ[pcurrent_jj[playerid]][jry]=ry;
					JJ[pcurrent_jj[playerid]][jrz]=rz;
					SetDynamicObjectPos(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jx],JJ[pcurrent_jj[playerid]][jy],JJ[pcurrent_jj[playerid]][jz]);
					SetDynamicObjectRot(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jrx],JJ[pcurrent_jj[playerid]][jry],JJ[pcurrent_jj[playerid]][jrz]);
					CreateJJtext(pcurrent_jj[playerid]);
					updateobj(pcurrent_jj[playerid]);
					JJ[pcurrent_jj[playerid]][jused]=false;
					Savedjj_data(pcurrent_jj[playerid]);
					pcurrent_jj[playerid]=-1;
					pstat[playerid]=NO_MODE;
				}
				if(response ==EDIT_RESPONSE_CANCEL)
				{
					SetDynamicObjectPos(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jx],JJ[pcurrent_jj[playerid]][jy],JJ[pcurrent_jj[playerid]][jz]);
					SetDynamicObjectRot(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jrx],JJ[pcurrent_jj[playerid]][jry],JJ[pcurrent_jj[playerid]][jrz]);
					CreateJJtext(pcurrent_jj[playerid]);
					updateobj(pcurrent_jj[playerid]);
					JJ[pcurrent_jj[playerid]][jused]=false;
					Savedjj_data(pcurrent_jj[playerid]);
					pcurrent_jj[playerid]=-1;
					pstat[playerid]=NO_MODE;
				}
			}
		}
		case EDIT_JJ_MOVE_MODE:
		{
			if(objectid==JJ[pcurrent_jj[playerid]][jid])
			{
				if(response ==EDIT_RESPONSE_FINAL)
				{
					JJ[pcurrent_jj[playerid]][jmovex]=x;
					JJ[pcurrent_jj[playerid]][jmovey]=y;
					JJ[pcurrent_jj[playerid]][jmovez]=z;
					JJ[pcurrent_jj[playerid]][jmoverx]=rx;
					JJ[pcurrent_jj[playerid]][jmovery]=ry;
					JJ[pcurrent_jj[playerid]][jmoverz]=rz;
					SetDynamicObjectPos(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jx],JJ[pcurrent_jj[playerid]][jy],JJ[pcurrent_jj[playerid]][jz]);
					SetDynamicObjectRot(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jrx],JJ[pcurrent_jj[playerid]][jry],JJ[pcurrent_jj[playerid]][jrz]);
					Savedjj_data(pcurrent_jj[playerid]);
					Dialog_Show(playerid,dl_jiajumovespeed,DIALOG_STYLE_INPUT,"家具移动","请设置移动速度[1-10]","确定", "取消");
				}
				if(response ==EDIT_RESPONSE_CANCEL)
				{
					SetDynamicObjectPos(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jx],JJ[pcurrent_jj[playerid]][jy],JJ[pcurrent_jj[playerid]][jz]);
					SetDynamicObjectRot(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jrx],JJ[pcurrent_jj[playerid]][jry],JJ[pcurrent_jj[playerid]][jrz]);
					JJ[pcurrent_jj[playerid]][jused]=false;
					pcurrent_jj[playerid]=-1;
					pstat[playerid]=NO_MODE;
				}
			}
		}
	}
	return 1;
}
public OnPlayerUpdate(playerid)
{
    if(!AvailablePlayer(playerid))return 1;
	SetPVarInt(playerid,"LastUpdate",GetTickCount());
	playerupdate[playerid] = 0;
	if(ffdtopen)
	{
		if(IsPlayerInDynamicArea(playerid,ffdtarea))
		{
			if(GetadminLevel(playerid)<2000)
   			{
				SetPlayerArmedWeapon(playerid,0);
				new Float:xyz[3],Float:pspeed=GetPlayerSpeed(playerid);
   				new animlib[32];
      			new animname[32];
       			GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
       			if(!strcmp(animname,"WALK_CIVI", false))SetPlayerPosEx(playerid,317.8049,1553.0446,1100.3053,0.0,0,0);
			    /*if(!strcmp(animname,"IDLE_STANCE", false))SetPlayerPos(playerid,oldpos[0],oldpos[1],oldpos[2]);
			    else GetPlayerPos(playerid,oldpos[0],oldpos[1],oldpos[2]);*/
				if(pspeed>50.0)
      			{
        			SetPlayerPosEx(playerid,317.8049,1553.0446,1100.3053,0.0,0,0);
        			Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "速度有点快", "额", "");
       			}
				GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
				if(xyz[2]<1101.5)SetPlayerPosEx(playerid,317.8049,1553.0446,1100.3053,0.0,0,0);
				if(xyz[2]>1106)if(!IsPlayerInRangeOfPoint(playerid,10,318.2561,1488.9417,1106.3176))SetPlayerPosEx(playerid,317.8049,1553.0446,1100.3053,0.0,0,0);
				if(IsPlayerInAnyVehicle(playerid))OnPlayerCheat(playerid,Ffdt_Garbage);
			}
		}
	}
	return 1;
}
Function Float:GetVehicleSpeed(vehicleid)
{
	new Float:x,Float:y,Float:z;
	GetVehicleVelocity(vehicleid,x,y,z);
	return floatpower((x * x) + (y * y) + (z * z),0.5) * 180;
}
Function Float:GetPlayerSpeed(vehicleid)
{
	new Float:x,Float:y,Float:z;
	GetPlayerVelocity(vehicleid,x,y,z);
	return floatpower((x * x) + (y * y) + (z * z),0.5) * 180;
}
Function GetClosestjiaju(playerid)
{
	new Float:dis, Float:dis2, jcid;
	jcid = -1;
	dis = 99999.99;
	foreach(new x:JJ)
	{
		if(JJ[x][jused]==false)
		{
			if(PlayerToPoint(3, playerid,JJ[x][jx],JJ[x][jy],JJ[x][jz],JJ[x][jin],JJ[x][jwl]))
			{
				new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
				GetPlayerPos(playerid, x1, y1, z1);
				x2=JJ[x][jx];
				y2=JJ[x][jy];
				z2=JJ[x][jz];
				dis2 = floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));
				if(dis2 < dis && dis2 != -1.00)
				{
					dis = dis2;
					jcid = x;
				}
			}
		}
	}
	return jcid;
}
forward PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z,inte,wold);
public PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z,inte,wold)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz,oldin,oldwl;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		oldwl=GetPlayerVirtualWorld(playerid);
		oldin=GetPlayerInterior(playerid);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))&& oldin==inte&& oldwl==wold)
		{
			return 1;
		}
	}
	return 0;
}
Function CreateJJ(idx)
{
	JJ[idx][jid]=CreateDynamicObject(Daoju[JJ[idx][jdid]][d_obj],JJ[idx][jx],JJ[idx][jy],JJ[idx][jz],JJ[idx][jrx],JJ[idx][jry],JJ[idx][jrz],JJ[idx][jwl],JJ[idx][jin],-1,100.0,0.0);
	switch(JJ[idx][jtype])
	{
	    case JJ_TYPE_NONE:SetDynamicObjectMaterial(JJ[idx][jid],-1,0,"none","none",0);
	    case JJ_TYPE_TXD:SetDynamicObjectMaterial(JJ[idx][jid],0,ObjectTextures[JJ[idx][jtxd]][TModel],ObjectTextures[JJ[idx][jtxd]][TXDName],ObjectTextures[JJ[idx][jtxd]][TextureName],0);
	    case JJ_TYPE_TEXT:
		{
		    if(JJ[idx][j_phb]!=NONE_TOP)JJphb(idx,JJ[idx][j_phb]);
		    else SetDynamicObjectMaterialText(JJ[idx][jid],0,Showjjwenziline(idx),g_TextSizes[JJ[idx][jmsize]][fsize],g_Fonts[JJ[idx][jfont]],JJ[idx][jsize],JJ[idx][jbold],ARGB(colorMenu[JJ[idx][jfcolor]]),ARGB(colorMenu[JJ[idx][jfbcolor]]),JJ[idx][jtalg]);
		}
	}
	updateobj(idx);
	return 1;
}
Function UpdateJJtext(idx)
{
	new tm1[100],tm2[512];
	strcat(tm2,"Y\n");
	format(tm1,100,"%s\nID:%i\n",Daoju[JJ[idx][jdid]][d_name],idx);
	strcat(tm2,tm1);
	format(tm1,100,"时限:%i天\n",15-(Now()-JJ[idx][j_caxin]));
	strcat(tm2,tm1);
	if(JJ[idx][jisowner]==1)
	{
		format(tm1,100,"主人:%s",UID[JJ[idx][juid]][u_name]);
		strcat(tm2,tm1);
	}
	if(JJ[idx][jiscol]==1)UpdateColor3DTextLabelText(JJ[idx][jtext],COLOR_JJ,tm2);
	else UpdateColor3DTextLabelText(JJ[idx][jtext],COLOR_JJ,tm2);
	return 1;
}
Function CreateJJtext(idx)
{
	new tm1[100],tm2[512];
	strcat(tm2,"Y\n");
	format(tm1,100,"%s\nID:%i\n",Daoju[JJ[idx][jdid]][d_name],idx);
	strcat(tm2,tm1);
	format(tm1,100,"时限:%i天\n",15-(Now()-JJ[idx][j_caxin]));
	strcat(tm2,tm1);
	if(JJ[idx][jisowner]==1)
	{
		format(tm1,100,"主人:%s",UID[JJ[idx][juid]][u_name]);
		strcat(tm2,tm1);
	}
	if(JJ[idx][jiscol]==1)JJ[idx][jtext]=CreateColor3DTextLabel(tm2,COLOR_JJ,JJ[idx][jx],JJ[idx][jy],JJ[idx][jz]+0.5,5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,JJ[idx][jwl],JJ[idx][jin],-1,5.0,JJ[idx][jiscol],JJ[idx][jcoltime]);
	else JJ[idx][jtext]=CreateColor3DTextLabel(tm2,COLOR_JJ,JJ[idx][jx],JJ[idx][jy],JJ[idx][jz]+0.5,5,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,JJ[idx][jwl],JJ[idx][jin],-1,5.0,0,0);
	return 1;
}
Function DelJJ(idx)
{
	DestroyDynamicObject(JJ[idx][jid]);
	DeleteColor3DTextLabel(JJ[idx][jtext]);
	return 1;
}
Function DelJJfile(idx)
{
	Iter_Clear(JJ_Line[idx]);
    fremove(Get_Path(idx,18));
    fremove(Get_Path(idx,5));
	return 1;
}
Function Savedjj_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,5));
    INI_WriteString(File,"jKey",JJ[Count][jKey]);
    INI_WriteFloat(File,"jx",JJ[Count][jx]);
    INI_WriteFloat(File,"jy",JJ[Count][jy]);
    INI_WriteFloat(File,"jz",JJ[Count][jz]);
    INI_WriteFloat(File,"jrx",JJ[Count][jrx]);
    INI_WriteFloat(File,"jry",JJ[Count][jry]);
    INI_WriteFloat(File,"jrz",JJ[Count][jrz]);
    INI_WriteInt(File,"jdid",JJ[Count][jdid]);
    INI_WriteInt(File,"juid",JJ[Count][juid]);
    INI_WriteInt(File,"jin",JJ[Count][jin]);
    INI_WriteInt(File,"jwl",JJ[Count][jwl]);
    INI_WriteInt(File,"jisellstate",JJ[Count][jisellstate]);
    INI_WriteInt(File,"jisowner",JJ[Count][jisowner]);
    INI_WriteInt(File,"jiscol",JJ[Count][jiscol]);
    INI_WriteInt(File,"jcoltime",JJ[Count][jcoltime]);
    INI_WriteInt(File,"jtxd",JJ[Count][jtxd]);
    INI_WriteInt(File,"jtype",JJ[Count][jtype]);
    INI_WriteInt(File,"jmsize",JJ[Count][jmsize]);
    INI_WriteInt(File,"jfont",JJ[Count][jfont]);
    INI_WriteInt(File,"jsize",JJ[Count][jsize]);
    INI_WriteInt(File,"jbold",JJ[Count][jbold]);
    INI_WriteInt(File,"jfcolor",JJ[Count][jfcolor]);
    INI_WriteInt(File,"jfbcolor",JJ[Count][jfbcolor]);
    INI_WriteInt(File,"jtalg",JJ[Count][jtalg]);
    INI_WriteInt(File,"jrotx",JJ[Count][jrotx]);
    INI_WriteInt(File,"jroty",JJ[Count][jroty]);
    INI_WriteInt(File,"jrotz",JJ[Count][jrotz]);
    INI_WriteInt(File,"jrotspeed",JJ[Count][jrotspeed]);
    INI_WriteInt(File,"jmove",JJ[Count][jmove]);
    INI_WriteInt(File,"jmovespeed",JJ[Count][jmovespeed]);
    INI_WriteFloat(File,"jmovex",JJ[Count][jmovex]);
    INI_WriteFloat(File,"jmovey",JJ[Count][jmovey]);
    INI_WriteFloat(File,"jmovez",JJ[Count][jmovez]);
    INI_WriteFloat(File,"jmoverx",JJ[Count][jmoverx]);
    INI_WriteFloat(File,"jmovery",JJ[Count][jmovery]);
    INI_WriteFloat(File,"jmoverz",JJ[Count][jmoverz]);
    INI_WriteInt(File,"j_phb",JJ[Count][j_phb]);
    INI_WriteInt(File,"j_phbtop",JJ[Count][j_phbtop]);
    INI_WriteInt(File,"j_caxin",JJ[Count][j_caxin]);
    INI_Close(File);
	return true;
}
Function LoadJJData(i, name[], value[])
{
    INI_String("jKey",JJ[i][jKey],32);
    INI_Float("jx",JJ[i][jx]);
    INI_Float("jy",JJ[i][jy]);
    INI_Float("jz",JJ[i][jz]);
    INI_Float("jrx",JJ[i][jrx]);
    INI_Float("jry",JJ[i][jry]);
    INI_Float("jrz",JJ[i][jrz]);
    INI_Int("jdid",JJ[i][jdid]);
    INI_Int("juid",JJ[i][juid]);
    INI_Int("jin",JJ[i][jin]);
    INI_Int("jwl",JJ[i][jwl]);
    INI_Int("jisellstate",JJ[i][jisellstate]);
    INI_Int("jisowner",JJ[i][jisowner]);
    INI_Int("jiscol",JJ[i][jiscol]);
    INI_Int("jcoltime",JJ[i][jcoltime]);
    INI_Int("jtxd",JJ[i][jtxd]);
    INI_Int("jtype",JJ[i][jtype]);
    INI_Int("jmsize",JJ[i][jmsize]);
    INI_Int("jfont",JJ[i][jfont]);
    INI_Int("jsize",JJ[i][jsize]);
    INI_Int("jbold",JJ[i][jbold]);
    INI_Int("jfcolor",JJ[i][jfcolor]);
    INI_Int("jfbcolor",JJ[i][jfbcolor]);
    INI_Int("jtalg",JJ[i][jtalg]);
    INI_Int("jrotx",JJ[i][jrotx]);
    INI_Int("jroty",JJ[i][jroty]);
    INI_Int("jrotz",JJ[i][jrotz]);
    INI_Int("jrotspeed",JJ[i][jrotspeed]);
    INI_Int("jmove",JJ[i][jmove]);
    INI_Int("jmovespeed",JJ[i][jmovespeed]);
    INI_Float("jmovex",JJ[i][jmovex]);
    INI_Float("jmovey",JJ[i][jmovey]);
    INI_Float("jmovez",JJ[i][jmovez]);
    INI_Float("jmoverx",JJ[i][jmoverx]);
    INI_Float("jmovery",JJ[i][jmovery]);
    INI_Float("jmoverz",JJ[i][jmoverz]);
    INI_Int("j_phb",JJ[i][j_phb]);
    INI_Int("j_phbtop",JJ[i][j_phbtop]);
    INI_Int("j_caxin",JJ[i][j_caxin]);
	return 1;
}
Function LoadJJ_data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_JJ)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,5), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,5), "LoadJJData", false, true, i, true, false);
			JJ[i][jid]=CreateDynamicObject(Daoju[JJ[i][jdid]][d_obj],JJ[i][jx],JJ[i][jy],JJ[i][jz],JJ[i][jrx],JJ[i][jry],JJ[i][jrz],JJ[i][jwl],JJ[i][jin],-1,100.0,0.0);
			switch(JJ[i][jtype])
			{
	    		case JJ_TYPE_NONE:SetDynamicObjectMaterial(JJ[i][jid],-1,0,"none","none",0);
	    		case JJ_TYPE_TXD:SetDynamicObjectMaterial(JJ[i][jid],0,ObjectTextures[JJ[i][jtxd]][TModel],ObjectTextures[JJ[i][jtxd]][TXDName],ObjectTextures[JJ[i][jtxd]][TextureName],0);
	    		case JJ_TYPE_TEXT:
	    		{
				    if(JJ[i][j_phb]!=NONE_TOP)JJphb(i,JJ[i][j_phb]);
				    else SetDynamicObjectMaterialText(JJ[i][jid],0,LoadJJFONTLine(i),g_TextSizes[JJ[i][jmsize]][fsize],g_Fonts[JJ[i][jfont]],JJ[i][jsize],JJ[i][jbold],ARGB(colorMenu[JJ[i][jfcolor]]),ARGB(colorMenu[JJ[i][jfbcolor]]),JJ[i][jtalg]);
	    		}
			}
            CreateJJtext(i);
            JJ[i][jused]=false;
            JJ[i][jmovestat]=0;
 			Iter_Add(JJ,i);
 			idx++;
        }
    }
    return idx;
}
stock Showjiajufontlist(playerid,pager)
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
		if(i<current_number[playerid])format(tmps,80,"%s\n",JJ_Line[pcurrent_jj[playerid]][current_idx[playerid][i]][JJ_str]);
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
Dialog:dl_jiajuwzmsize(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
	    JJ[pcurrent_jj[playerid]][jmsize]=listitem;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwzfont(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
	    JJ[pcurrent_jj[playerid]][jfont]=listitem;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
  		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwzfontsize(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
	    if(strval(inputtext)<0||strval(inputtext)>256)return Dialog_Show(playerid,dl_jiajuwzfontsize,DIALOG_STYLE_LIST,"文字大小","请输入文字大小[1-9]","确定", "取消");
	    JJ[pcurrent_jj[playerid]][jsize]=strval(inputtext);
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwzfontbold(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
	    JJ[pcurrent_jj[playerid]][jbold]=1;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else
	{
	    PvailJJ(playerid);
	    JJ[pcurrent_jj[playerid]][jbold]=0;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
    return 1;
}
Dialog:dl_jiajuwzfontcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
        JJ[pcurrent_jj[playerid]][jfcolor]=listitem;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
  		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwzfontbgcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
        JJ[pcurrent_jj[playerid]][jfbcolor]=listitem;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
  		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwzfontalg(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
	    JJ[pcurrent_jj[playerid]][jtalg]=listitem;
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
  		Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
       switch(listitem)
       {
            case 0:
            {
				current_number[playerid]=1;
				foreach(new i:JJ_Line[pcurrent_jj[playerid]])
				{
					current_idx[playerid][current_number[playerid]]=i;
		        	current_number[playerid]++;
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"共计[%i]行",current_number[playerid]-1);
				Dialog_Show(playerid, dl_jiajuwznr, DIALOG_STYLE_LIST,tm,Showjiajufontlist(playerid,P_page[playerid]), "确定", "取消");
			}
            case 1:
            {
                new tmp[512],Stru[50];
                Loop(x,sizeof(g_TextSizes))
                {
					format(Stru, sizeof(Stru),"%s\n",g_TextSizes[x][fsizes]);
					strcat(tmp,Stru);
                }
                Dialog_Show(playerid,dl_jiajuwzmsize,DIALOG_STYLE_LIST,"选择尺寸",tmp,"确定", "取消");
            }
            case 2:
            {
                new tmp[512],Stru[50];
                Loop(x,sizeof(g_Fonts))
                {
					format(Stru, sizeof(Stru),"%s\n",g_Fonts[x]);
					strcat(tmp,Stru);
                }
                Dialog_Show(playerid,dl_jiajuwzfont,DIALOG_STYLE_LIST,"选择字体",tmp,"确定", "取消");
            }
            case 3:
            {
                Dialog_Show(playerid,dl_jiajuwzfontsize,DIALOG_STYLE_INPUT,"文字大小","请输入文字大小","确定", "取消");
            }
            case 4:
            {
                Dialog_Show(playerid,dl_jiajuwzfontbold,DIALOG_STYLE_MSGBOX,"文字加粗","是否加粗","加粗", "不加粗");
            }
            case 5:
            {
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu))
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_jiajuwzfontcolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
            }
            case 6:
            {
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu))
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_jiajuwzfontbgcolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
            }
            case 7:
            {
                Dialog_Show(playerid,dl_jiajuwzfontalg,DIALOG_STYLE_LIST,"文字大小","左对齐\n居中\n右对齐","确定", "取消");
            }
            case 8:
            {
                if(JJ[pcurrent_jj[playerid]][jtype]!=JJ_TYPE_TEXT)return Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字未启用","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
				Dialog_Show(playerid,dl_jiajuwzphb,DIALOG_STYLE_LIST,"选择类型","积分排行\nV币排行","确定", "取消");
            }
            case 9:
            {
                PvailJJ(playerid);
                JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_NONE;
                Savedjj_data(pcurrent_jj[playerid]);
                JJ[pcurrent_jj[playerid]][jtxd]=-1;
 				JJ[pcurrent_jj[playerid]][j_phb]=NONE_TOP;
        		JJ[pcurrent_jj[playerid]][j_phbtop]=0;
                SetDynamicObjectMaterial(JJ[pcurrent_jj[playerid]][jid],0,JJ[pcurrent_jj[playerid]][jtxd],"none","none",0);
			    JJ[pcurrent_jj[playerid]][jused]=false;
			    pcurrent_jj[playerid]=-1;
            }
        }
	}
	else
	{
 		JJ[pcurrent_jj[playerid]][jused]=false;
   		pcurrent_jj[playerid]=-1;
	}
	return 1;
}
Dialog:dl_jiajuwzphb(playerid, response, listitem, inputtext[])
{
	if(response)
	{
 		PvailJJ(playerid);
       	switch(listitem)
       	{
            case 0:Dialog_Show(playerid,dl_jiajuwzphbtopjf,DIALOG_STYLE_INPUT,"家具设置","请输入行数","确定", "取消");
            case 1:Dialog_Show(playerid,dl_jiajuwzphbtopvb,DIALOG_STYLE_INPUT,"家具设置","请输入行数","确定", "取消");
       	}
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	return 1;
}
Dialog:dl_jiajuwzphbtopjf(playerid, response, listitem, inputtext[])
{
	if(response)
	{
 		PvailJJ(playerid);
	    if(strval(inputtext)< 1||strval(inputtext)>=50)Dialog_Show(playerid,dl_jiajuwzphbtop,DIALOG_STYLE_INPUT,"家具设置","请输入行数","确定", "取消");
 		JJ[pcurrent_jj[playerid]][j_phb]=STORE_TOP;
        JJ[pcurrent_jj[playerid]][j_phbtop]=strval(inputtext);
        JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
        Savedjj_data(pcurrent_jj[playerid]);
        Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	return 1;
}
Dialog:dl_jiajuwzphbtopvb(playerid, response, listitem, inputtext[])
{
	if(response)
	{
 		PvailJJ(playerid);
	    if(strval(inputtext)< 1||strval(inputtext)>=50)Dialog_Show(playerid,dl_jiajuwzphbtop,DIALOG_STYLE_INPUT,"家具设置","请输入行数","确定", "取消");
 		JJ[pcurrent_jj[playerid]][j_phb]=VB_TOP;
        JJ[pcurrent_jj[playerid]][j_phbtop]=strval(inputtext);
        JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
        Savedjj_data(pcurrent_jj[playerid]);
        Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	return 1;
}
stock Showjjwenziline(idx)
{
	new tm2[1024],tmp[80];
	foreach(new i:JJ_Line[idx])
	{
    	ReStr(JJ_Line[idx][i][JJ_str],1,0);
		format(tmp,80,"%s\n",JJ_Line[idx][i][JJ_str]);
	    strcat(tm2,tmp);
	}
	return tm2;
}
Dialog:dl_jiajuwznr(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_jiajuwznr, DIALOG_STYLE_LIST,"内容", Showjiajufontlist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		   new tm[80];
           format(tm,80,"正在添加第[%i]行",listitem+1);
		   Dialog_Show(playerid,dl_jiajuwznradd,DIALOG_STYLE_INPUT,tm,"请输入添加的内容","确定", "取消");
		}
		else
		{
			new linelistid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDB",linelistid);
			new tm[80];
           	format(tm,80,"正在编辑第[%i]行添加",listitem+1);
		   	Dialog_Show(playerid,dl_jiajuwznredit,DIALOG_STYLE_INPUT,tm,"请输入编辑的内容","确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
	    {
	        P_page[playerid]--;
            Dialog_Show(playerid, dl_jiajuwznr, DIALOG_STYLE_LIST,"内容", Showjiajufontlist(playerid,P_page[playerid]), "确定", "取消");
		}
		else
		{
	 		JJ[pcurrent_jj[playerid]][jused]=false;
	   		pcurrent_jj[playerid]=-1;
		}
	}
	return 1;
}
Dialog:dl_jiajuwznredit(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>80)return Dialog_Show(playerid,dl_jiajuwznredit,DIALOG_STYLE_INPUT,"添加内容","字符过短或过长,请重新输入添加的内容","确定", "取消");
	    new listidb=GetPVarInt(playerid,"listIDB");
		ReStr(inputtext,1,0);
		format(JJ_Line[pcurrent_jj[playerid]][listidb][JJ_str],80,inputtext);
		SaveJJFontLine(pcurrent_jj[playerid]);
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
	    Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
Dialog:dl_jiajuwznradd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    PvailJJ(playerid);
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>80)return Dialog_Show(playerid,dl_jiajuwznradd,DIALOG_STYLE_INPUT,"添加内容","字符过短或过长,请重新输入添加的内容","确定", "取消");
	    ReStr(inputtext,1,0);
	    new i=Iter_Free(JJ_Line[pcurrent_jj[playerid]]);
		if(i==-1)
		{
	 		JJ[pcurrent_jj[playerid]][jused]=false;
	   		pcurrent_jj[playerid]=-1;
			return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","该文字内容已到上限", "好的", "");
		}
		format(JJ_Line[pcurrent_jj[playerid]][i][JJ_str],80,inputtext);
		Iter_Add(JJ_Line[pcurrent_jj[playerid]],i);
		SaveJJFontLine(pcurrent_jj[playerid]);
		JJ[pcurrent_jj[playerid]][jtype]=JJ_TYPE_TEXT;
		Savedjj_data(pcurrent_jj[playerid]);
		if(JJ[pcurrent_jj[playerid]][j_phb]!=NONE_TOP)JJphb(pcurrent_jj[playerid],JJ[pcurrent_jj[playerid]][j_phb]);
		else SetDynamicObjectMaterialText(JJ[pcurrent_jj[playerid]][jid],0,Showjjwenziline(pcurrent_jj[playerid]),g_TextSizes[JJ[pcurrent_jj[playerid]][jmsize]][fsize],g_Fonts[JJ[pcurrent_jj[playerid]][jfont]],JJ[pcurrent_jj[playerid]][jsize],JJ[pcurrent_jj[playerid]][jbold],ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfcolor]]),ARGB(colorMenu[JJ[pcurrent_jj[playerid]][jfbcolor]]),JJ[pcurrent_jj[playerid]][jtalg]);
	    Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
	}
	else Dialog_Show(playerid,dl_jiajuwz,DIALOG_STYLE_LIST,"家具文字","文字内容\n画布尺寸\n文字字体\n文字大小\n文字加粗\n文字颜色\n背景颜色\n对齐方式\n排行榜\n取消文字","选择", "取消");
    return 1;
}
stock StopRotJJ(jjid)
{
    JJ[jjid][jrotspeed]=0;
    JJ[jjid][jrotx]=0;
    JJ[jjid][jroty]=0;
    JJ[jjid][jrotz]=0;
    SetDynamicObjectRot(JJ[jjid][jid],JJ[jjid][jrx],JJ[jjid][jry],JJ[jjid][jrz]);
    return 1;
}
Function Core_UpdateRotating(jjid)
{
	new Float:curX, Float:curY, Float:curZ;
	GetDynamicObjectRot(JJ[jjid][jid], curX, curY, curZ);
	if(JJ[jjid][jrotx]!=0)
	{
		if(JJ[jjid][jrotx]==1)curX+=0.07*JJ[jjid][jrotspeed];
		else curX-=0.07*JJ[jjid][jrotspeed];
	}
	if(JJ[jjid][jroty]!=0)
	{
		if(JJ[jjid][jroty]==1)curY +=0.07*JJ[jjid][jrotspeed];
		else curY-=0.07*JJ[jjid][jrotspeed];
	}
	if(JJ[jjid][jrotz]!=0)
	{
		if (JJ[jjid][jrotz]==1)curZ +=0.07*JJ[jjid][jrotspeed];
		else curZ-=0.07*JJ[jjid][jrotspeed];
	}
	if(JJ[jjid][jrotx]!=0||JJ[jjid][jroty]!=0||JJ[jjid][jrotz]!=0)SetDynamicObjectRot(JJ[jjid][jid],curX, curY, curZ);
	return 1;
}
public OnDynamicObjectMoved(objectid)
{
	foreach(new i:JJ)
	{
	    if(JJ[i][jid]==objectid)
	    {
		    if(JJ[i][jmovestat]==1)
		    {
		        MoveDynamicObject(JJ[i][jid],JJ[i][jx],JJ[i][jy],JJ[i][jz],JJ[i][jmovespeed],JJ[i][jrx],JJ[i][jry],JJ[i][jrz]);
		        JJ[i][jmovestat]=2;
		        return 1;
		    }
		    if(JJ[i][jmovestat]==2)
		    {
		        JJ[i][jmovestat]=0;
		        return 1;
		    }
	    }
	}
	return 1;
}
