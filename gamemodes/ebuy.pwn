stock GetPlayerSellAmout(playerid)
{
	new amouts=0;
	foreach(new i:Ebuy)if(Ebuy[i][e_uid]==PU[playerid])amouts++;
	return amouts;
}
stock IsDPselling(dpid)
{
	foreach(new i:Ebuy)
	{
	    if(Ebuy[i][e_type]==EBUY_TYPE_DP)
	    {
	        if(Ebuy[i][e_did]==dpid)return 1;
	    }
	}
	return 0;
}
stock IsFZselling(dpid)
{
	foreach(new i:Ebuy)
	{
	    if(Ebuy[i][e_type]==EBUY_TYPE_FZ)
	    {
	        if(Ebuy[i][e_did]==dpid)return 1;
	    }
	}
	return 0;
}
stock IsACselling(dpid)
{
	foreach(new i:Ebuy)
	{
	    if(Ebuy[i][e_type]==EBUY_TYPE_AC)
	    {
	        if(Ebuy[i][e_did]==dpid)return 1;
	    }
	}
	return 0;
}
stock IsMSselling(dpid)
{
	foreach(new i:Ebuy)
	{
	    if(Ebuy[i][e_type]==EBUY_TYPE_MS)
	    {
	        if(Ebuy[i][e_did]==dpid)return 1;
	    }
	}
	return 0;
}
Function LoadEbuy_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_EBUYTHINGS)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,31), i);
        if(fexist(NameFile))
        {
       		INI_ParseFile(Get_Path(i,31), "LoadEbuyData", false, true, i, true, false);
       		if(!Ebuy[i][e_seq])fremove(Get_Path(i,31));
       		else Iter_Add(Ebuy,i);
       		idx++;
       	}
    }
    return idx;
}
CMD:wdebuy(playerid, params[], help)
{
    if(UID[PU[playerid]][u_Score]<500)return SM(COLOR_TWTAN,"你的积分不足500,无法使用我的商城");
    Dialog_Show(playerid,dl_ebuyxz,DIALOG_STYLE_LIST,"易购网","我的出售\n出售商品","选择", "取消");
	return 1;
}
CMD:ebuy(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
	foreach(new i:Ebuy)
	{
		current_idx[playerid][current_number[playerid]]=i;
		current_number[playerid]++;
		current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,易购网没有物品出售", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"易购网/EBUY-共计出售[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_ebuy, DIALOG_STYLE_TABLIST_HEADERS,tm, Showebuylist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showemybuylist(playerid,pager)
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
			if(Ebuy[current_idx[playerid][i]][e_type]==EBUY_TYPE_JJ)format(tmps,100,"%s%s   数量:%i个   单个售价:$%i   出售者:%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Daoju[Ebuy[current_idx[playerid][i]][e_did]][d_name],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
            else if(Ebuy[current_idx[playerid][i]][e_type]==EBUY_TYPE_VB)format(tmps,100,"%s数量%i个   单个售价:$%i   出售者:%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
			else format(tmps,100,"%sID:%i  单个售价:$%i   出售者:%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_did],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
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
Dialog:dl_myebuy(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_myebuy,DIALOG_STYLE_TABLIST,"我的易购出售",Showemybuylist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"ebuy",listid);
			SetPVarInt(playerid,"seq",Ebuy[listid][e_seq]);
            Dialog_Show(playerid,dl_myebuyxj, DIALOG_STYLE_MSGBOX, "我的易购网","是否下架此商品", "下架", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_myebuy,DIALOG_STYLE_TABLIST,"我的易购出售",Showemybuylist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_myebuyxj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=GetPVarInt(playerid,"ebuy");
	    new seq=GetPVarInt(playerid,"seq");
	    if(!Itter_Contains(Ebuy,i))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	    if(Ebuy[i][e_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	    if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
		switch(Ebuy[i][e_type])
		{
			case EBUY_TYPE_JJ:
			{
                Addbeibao(playerid,Ebuy[i][e_did],Ebuy[i][e_amout]);
		        delebuything(i,Ebuy[i][e_amout]);
		        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "商品下架成功,商品已返还", "嗯", "");
			}
			case EBUY_TYPE_DP:
			{
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "商品下架成功,地盘已可以操作", "嗯", "");
			}
			case EBUY_TYPE_WZ:
			{
			}
		    case EBUY_TYPE_CS:
		    {
		    }
		    case EBUY_TYPE_XD:
		    {
		    }
		    case EBUY_TYPE_FZ:
		    {
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "商品下架成功,房子已可以操作", "嗯", "");
		    }
		    case EBUY_TYPE_SY:
		    {
		    }
		    case EBUY_TYPE_VB:
		    {
		        VBhandle(PU[playerid],Ebuy[i][e_amout]);
		        delebuything(i,Ebuy[i][e_amout]);
		        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "商品下架成功,V币已返还", "嗯", "");
		    }
		    case EBUY_TYPE_AC:
		    {
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "商品下架成功,爱车已可以操作", "嗯", "");
		    }
		    case EBUY_TYPE_MS:
		    {
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "商品下架成功,美食已可以操作", "嗯", "");
		    }
		}
	}
	return 1;
}
Dialog:dl_ebuyxz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    switch(listitem)
	    {
	        case 0:
	        {
				current_number[playerid]=1;
				new current=-1;
			  	foreach(new i:Ebuy)
				{
				    if(Ebuy[i][e_uid]==PU[playerid])
				    {
				        current_idx[playerid][current_number[playerid]]=i;
				        current_number[playerid]++;
				        current++;
			        }
				}
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "你没有商品在易购网出售", "好的", "");
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"我的易购出售-共计出售[%i]",current_number[playerid]-1);
				Dialog_Show(playerid, dl_myebuy, DIALOG_STYLE_LIST,tm, Showemybuylist(playerid,P_page[playerid]), "确定", "取消");
	        }
	        case 1:
			{
				new tmp[512];
				format(tmp,512,"%s\n%s\n%s\n%s\n%s\n%s",ebuytype[EBUY_TYPE_VB],ebuytype[EBUY_TYPE_JJ],ebuytype[EBUY_TYPE_DP],ebuytype[EBUY_TYPE_FZ],ebuytype[EBUY_TYPE_AC],ebuytype[EBUY_TYPE_MS]);
				Dialog_Show(playerid,dl_ebuyxzsp,DIALOG_STYLE_LIST,"出售商品",tmp,"选择", "取消");
			}	
	    }
	}
	return 1;
}
Dialog:dl_addebuyjj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的个数", "确定", "取消");
        new djid=GetPVarInt(playerid,"listIDB");
        if(strval(inputtext)>GetBeibaoAmout(playerid,Beibao[playerid][djid][b_did]))return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "商品上架","你没有那么多,请输入要出售的个数", "确定", "取消");
		SetPVarInt(playerid,"listIDA",strval(inputtext));
		Dialog_Show(playerid,dl_addebuyjjsell, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的单价", "出售", "取消");
 	}
	return 1;
}
Dialog:dl_addebuyjjsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
        new djid=GetPVarInt(playerid,"listIDB");
		new amouts=GetPVarInt(playerid,"listIDA");
		if(amouts>GetBeibaoAmout(playerid,Beibao[playerid][djid][b_did]))return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "商品上架","你没有那么多,请输入要出售的个数", "确定", "取消");
		Delbeibao(playerid,Beibao[playerid][djid][b_did],amouts);
        Addebuything(playerid,EBUY_TYPE_JJ,strval(inputtext),amouts,Beibao[playerid][djid][b_did]);
	}
	return 1;
}
Dialog:dl_ebuyxzsp(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetPlayerSellAmout(playerid)>=4&&GetadminLevel(playerid)<3000)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "你最多只能在Ebuy上架4种商品", "额", "");
	    new current=-1;
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(UID[PU[playerid]][u_wds]<1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,你没有V币", "好的", "");
				Dialog_Show(playerid,dl_addebuyvb, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的个数", "确定", "取消");
	        }
	        case 1:
	        {
				current_number[playerid]=1;
				new idx=0;
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
				ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_EBUY_BB_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	        }
	        case 2:
	        {
                current_number[playerid]=1;
				foreach(new i:DPInfo)
				{
					if(DPInfo[i][dp_uid]==PU[playerid])
					{
						current_idx[playerid][current_number[playerid]]=i;
				        current_number[playerid]++;
				        current++;
				 	}
				}
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "错误,你没有地盘", "额", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuyselldp, DIALOG_STYLE_LIST,"选择你需要出售的地盘", Showselldplist(playerid,P_page[playerid]), "选择", "取消");
	        }
	        case 3:
	        {
				current_number[playerid]=1;
			  	foreach(new i:HOUSE)
				{
				    if(HOUSE[i][H_isSEL]!=NONEONE&&HOUSE[i][H_UID]==PU[playerid])
				    {
				        current_idx[playerid][current_number[playerid]]=i;
				        current_number[playerid]++;
				        current++;
			        }
				}
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "错误,你没有房子", "额", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuysellfz, DIALOG_STYLE_LIST,"选择你需要出售的房子", Showmyhouselist(playerid,P_page[playerid]), "确定", "取消");
	        }
	        case 4:
	        {
				current_number[playerid]=1;
				foreach(new i:VInfo)
				{
					if(VInfo[i][v_uid]==PU[playerid]&&CarTypes[VInfo[i][v_cid]]==OwnerVeh)
					{
						current_idx[playerid][current_number[playerid]]=i;
			        	current_number[playerid]++;
			        	current++;
			 		}
				}
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "错误,你没有爱车", "额", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuysellac, DIALOG_STYLE_LIST,"选择你需要出售的爱车", Showmycarlist(playerid,P_page[playerid]), "确定", "取消");
	        }
	        case 5:
	        {
				current_number[playerid]=1;
				foreach(new i:pfood)
				{
				    if(pfood[i][pfoode_uid]==PU[playerid])
				    {
						current_idx[playerid][current_number[playerid]]=i;
				       	current_number[playerid]++;
				       	current++;
			       	}
				}
				if(current==-1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"错误","你还没有制作美食", "额", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuysellms, DIALOG_STYLE_TABLIST_HEADERS,"选择你需要出售的美食", Showmymslist(playerid,P_page[playerid]), "确定", "取消");
			}
		}
	}
	return 1;
}
Dialog:dl_ebuysellms(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_ebuysellms, DIALOG_STYLE_LIST,"选择你需要出售的美食", Showmymslist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的单价", "出售", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuysellms, DIALOG_STYLE_LIST,"选择你需要出售的美食", Showmymslist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_ebuysellac(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_ebuysellac, DIALOG_STYLE_LIST,"选择你需要出售的爱车", Showmycarlist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuyacbsell, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的单价", "出售", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuysellac, DIALOG_STYLE_LIST,"选择你需要出售的爱车", Showmycarlist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_ebuysellfz(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_ebuysellfz, DIALOG_STYLE_LIST,"选择你需要出售的房子", Showmyhouselist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuyfzbsell, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的单价", "出售", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuysellfz, DIALOG_STYLE_LIST,"选择你需要出售的房子", Showmyhouselist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_ebuyselldp(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_ebuyselldp, DIALOG_STYLE_LIST,"选择你需要出售的地盘", Showselldplist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuydpbsell, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的单价", "出售", "取消");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuyselldp, DIALOG_STYLE_LIST,"选择你需要出售的地盘", Showselldplist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_addebuydpbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuydpbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuydpbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		new edids=GetPVarInt(playerid,"listIDC");
	    if(IsDPselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该地盘已上架", "额", "");
		if(DPInfo[edids][dp_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "这已不是你的地盘了", "额", "");
		Addebuything(playerid,EBUY_TYPE_DP,strval(inputtext),1,edids);
	}
	return 1;
}
Dialog:dl_addebuyacbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyacbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyacbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		new edids=GetPVarInt(playerid,"listIDC");
		if(VInfo[edids][v_issel]==SELLING)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该爱车正在出售状态", "额", "");
	    if(IsACselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该爱车已上架", "额", "");
		if(VInfo[edids][v_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "这已不是你的爱车了", "额", "");
		Addebuything(playerid,EBUY_TYPE_AC,strval(inputtext),1,edids);
	}
	return 1;
}
Dialog:dl_addebuyfzbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyfzbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyfzbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		new edids=GetPVarInt(playerid,"listIDC");
		if(HOUSE[edids][H_isSEL]==SELLING)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该房子正在出售状态", "额", "");
	    if(IsFZselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该房子已上架", "额", "");
		if(HOUSE[edids][H_UID]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "这已不是你的房子了", "额", "");
		Addebuything(playerid,EBUY_TYPE_FZ,strval(inputtext),1,edids);
	}
	return 1;
}
Dialog:dl_addebuymsbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		new edids=GetPVarInt(playerid,"listIDC");
	    if(IsMSselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该美食已上架", "额", "");
		if(pfood[edids][pfoode_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "这已不是你的美食了", "额", "");
		Addebuything(playerid,EBUY_TYPE_MS,strval(inputtext),1,edids);
	}
	return 1;
}
stock Showselldplist(playerid,pager)
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
		new tmps[128];
		if(i<current_number[playerid])
        {
			format(tmps,100,"ID:%i地盘[%s]\n",current_idx[playerid][i],DPInfo[current_idx[playerid][i]][dp_name]);
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
Dialog:dl_addebuyvb(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyvb, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的个数", "确定", "取消");
	    if(UID[PU[playerid]][u_wds]<strval(inputtext))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多V币", "额", "");
		SetPVarInt(playerid,"listIDA",strval(inputtext));
		Dialog_Show(playerid,dl_addebuyvbsell, DIALOG_STYLE_INPUT, "商品上架","请输入要出售的单价", "出售", "取消");
	}
	return 1;
}
Dialog:dl_addebuyvbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyvbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyvbsell, DIALOG_STYLE_INPUT, "商品上架","你输入了错误的数值,请输入要出售的单价", "出售", "取消");
		new amouts=GetPVarInt(playerid,"listIDA");
	    if(UID[PU[playerid]][u_wds]<amouts)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多V币", "额", "");
        VBhandle(PU[playerid],-amouts);
        Addebuything(playerid,EBUY_TYPE_VB,strval(inputtext),amouts);
	}
	return 1;
}
Dialog:dl_ebuy(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_ebuy,DIALOG_STYLE_TABLIST_HEADERS,"易购网/EBUY",Showebuylist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem],str[100];
			SetPVarInt(playerid,"ebuy",listid);
			SetPVarInt(playerid,"seq",Ebuy[listid][e_seq]);
		    if(Ebuy[listid][e_uid]==PU[playerid])return Dialog_Show(playerid,dl_myebuyxj, DIALOG_STYLE_MSGBOX, "我的易购网","是否下架此商品", "下架", "取消");
			switch(Ebuy[listid][e_type])
			{
			    case EBUY_TYPE_JJ:
				{
					format(str,100,"[%i]-%s出售%i个%s价格每个$%i,请输入购买的个数",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_amout],Daoju[Ebuy[listid][e_did]][d_name],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyjj, DIALOG_STYLE_INPUT, "易购网购买",str, "购买", "取消");
				}
			    case EBUY_TYPE_DP:
			    {
					format(str,100,"%[%i]-%s出售地盘ID:%i价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuydp, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
			    }
			    case EBUY_TYPE_WZ:
			    {
					format(str,100,"[%i]-%s出售文字点ID:%i价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuywzd, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
			    }
			    case EBUY_TYPE_CS:
			    {
					format(str,100,"[%i]-%s出售传送ID:%i价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuycs, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
			    }
			    case EBUY_TYPE_XD:
			    {
					format(str,100,"[%i]-%s出售小岛ID:%i价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyxd, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
			    }
			    case EBUY_TYPE_FZ:
			    {
					format(str,100,"[%i]-%s出售房子ID:%i OBJ数量:%i 价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Iter_Count(HOBJ[Ebuy[listid][e_did]]),Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyfz, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
			    }
			    case EBUY_TYPE_SY:
			    {
					format(str,100,"[%i]-%s出售商业[%s]ID:%i价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],protypestr[property[Ebuy[listid][e_did]][pro_type]],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuysy, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
			    }
			    case EBUY_TYPE_VB:
				{
					format(str,100,"[%i]-%s出售%i个V币价格$%i,请输入购买的个数",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_amout],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyvb, DIALOG_STYLE_INPUT, "易购网购买",str, "购买", "取消");
				}
			    case EBUY_TYPE_AC:
				{
					format(str,100,"[%i]-%s出售ID:%i爱车[%s]装饰物%i个价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],VInfo[Ebuy[listid][e_did]][v_cid],Daoju[VInfo[Ebuy[listid][e_did]][v_did]][d_name],Iter_Count(AvInfo[Ebuy[listid][e_did]]),Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyac, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
				}
			    case EBUY_TYPE_MS:
				{
					format(str,100,"[%i]-%s出售ID:%i美食[%s]效用[%0.2f]价格$%i,是否购买",listid,UID[Ebuy[listid][e_uid]][u_name],listid,pfood[Ebuy[listid][e_did]][pfoode_name],pfood[Ebuy[listid][e_did]][pfoode_usefuel],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyms, DIALOG_STYLE_MSGBOX, "易购网购买",str, "购买", "取消");
				}
			}
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_ebuy,DIALOG_STYLE_TABLIST_HEADERS,"易购网/EBUY",Showebuylist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
Dialog:dl_ebuyms(playerid, response, listitem, inputtext[])
{
    if(response)
	{
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多钱", "额", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        pfood[Ebuy[i][e_did]][pfoode_uid]=PU[playerid];
	        SavedFood_data(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s购买了你出售的美食[%s],价格[$%i]",Gn(playerid),pfood[Ebuy[i][e_did]][pfoode_name],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"易购网",str,Ebuy[i][e_value]);
	        delebuything(i,Ebuy[i][e_amout]);
	    }
 	}
	return 1;
}
Dialog:dl_ebuyac(playerid, response, listitem, inputtext[])
{
    if(response)
	{
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多钱", "额", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        VInfo[Ebuy[i][e_did]][v_uid]=PU[playerid];
	        Savedveh_data(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s购买了你出售的爱车ID:%i[%s],价格[$%i]",Gn(playerid),Ebuy[i][e_did],Daoju[VInfo[Ebuy[i][e_did]][v_did]][d_name],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"易购网",str,Ebuy[i][e_value]);
	        delebuything(i,Ebuy[i][e_amout]);
	    }
 	}
	return 1;
}
Dialog:dl_ebuyfz(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(getplayerhouse(PU[playerid])>=3)return SM(COLOR_TWTAN,"你已经有了3个房子了");
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多钱", "额", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        HOUSE[Ebuy[i][e_did]][H_UID]=PU[playerid];
	        Savedhousedata(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s购买了你出售的房子ID:%i,价格[$%i]",Gn(playerid),Ebuy[i][e_did],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"易购网",str,Ebuy[i][e_value]);
	        delebuything(i,Ebuy[i][e_amout]);
	    }
 	}
	return 1;
}
Dialog:dl_ebuydp(playerid, response, listitem, inputtext[])
{
    if(response)
	{
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多钱", "额", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        DPInfo[Ebuy[i][e_did]][dp_uid]=PU[playerid];
	        SavedDPdata(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s购买了你出售的地盘ID:%i,价格[$%i]",Gn(playerid),Ebuy[i][e_did],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"易购网",str,Ebuy[i][e_value]);
	        delebuything(i,Ebuy[i][e_amout]);
	    }
 	}
	return 1;
}
	
Dialog:dl_ebuyjj(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你输入了错误的数值", "额", "");
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]*strval(inputtext)))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多钱", "额", "");
			if(strval(inputtext)>Ebuy[i][e_amout])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "没有那么多商品出售", "额", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]*strval(inputtext));
	        Addbeibao(playerid,Ebuy[i][e_did],strval(inputtext));
	        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示", "该商品已送入你的背包", "额", "");
	        new str[100];
			format(str,100,"%s购买了你出售的%i个家具%s,单价[$%i]",Gn(playerid),strval(inputtext),Daoju[Ebuy[i][e_did]][d_name],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"易购网",str,Ebuy[i][e_value]*strval(inputtext));
	        delebuything(i,strval(inputtext));
		}
	}
	return 1;
}
Dialog:dl_ebuyvb(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你输入了错误的数值", "额", "");
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
		    if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]*strval(inputtext)))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "你没有那么多钱", "额", "");
			if(strval(inputtext)>Ebuy[i][e_amout])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "没有那么多商品出售", "额", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]*strval(inputtext));
	        VBhandle(PU[playerid],strval(inputtext));
	        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示", "该商品已送入你的账户", "额", "");
	        new str[100];
			format(str,100,"%s购买了你出售的%i个V币,单价[$%i]",Gn(playerid),strval(inputtext),Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"易购网",str,Ebuy[i][e_value]*strval(inputtext));
	        delebuything(i,strval(inputtext));
        }
        else Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "错误", "该商品可能已被购买或删除", "额", "");
	}
	return 1;
}
stock Showebuylist(playerid,pager)
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
	format(tmp,4128, "类型\tID/数量\t零售价\t出售者\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
		new tmps[300];
		if(i<current_number[playerid])
        {
            switch(Ebuy[current_idx[playerid][i]][e_type])
            {
                case EBUY_TYPE_JJ:format(tmps,256,"%s\t%s[{FF8000}%i个{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Daoju[Ebuy[current_idx[playerid][i]][e_did]][d_name],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_VB:format(tmps,256,"%s\t[{FF8000}%i个{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_DP:format(tmps,256,"%s\tID:%i\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_did],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_AC:format(tmps,256,"%s\tID:%i[{FF8000}%s{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],VInfo[Ebuy[current_idx[playerid][i]][e_uid]][v_cid],Daoju[VInfo[Ebuy[current_idx[playerid][i]][e_did]][v_did]][d_name],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_FZ:format(tmps,256,"%s\tID:%i\t{FFFF00}$%i\t%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_did],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
				case EBUY_TYPE_MS:format(tmps,256,"%s\t%s[{FF8000}效用:%0.2f{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],pfood[Ebuy[current_idx[playerid][i]][e_did]][pfoode_name],pfood[Ebuy[current_idx[playerid][i]][e_did]][pfoode_usefuel],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
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
stock Addebuything(playerid,etype,evalue,eamout,edid=-1)
{
    new i=Iter_Free(Ebuy);
    if(i==-1)return 0;
    Ebuy[i][e_seq]=random(9999)+random(9999)+random(9999);
    Ebuy[i][e_uid]=PU[playerid];
    Ebuy[i][e_type]=etype;
    Ebuy[i][e_did]=edid;
    Ebuy[i][e_amout]=eamout;
    Ebuy[i][e_value]=evalue;
    Iter_Add(Ebuy,i);
    SavedEbuy_data(i);
	new tmps[256];
	switch(Ebuy[i][e_type])
	{
	    case EBUY_TYPE_JJ:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}%s   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Daoju[Ebuy[i][e_did]][d_name]);
	    case EBUY_TYPE_DP:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_WZ:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_CS:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_XD:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_FZ:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_SY:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_VB:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}V币%i个   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_amout]);
	    case EBUY_TYPE_AC:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}ID[%i]%s   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did],Daoju[VInfo[Ebuy[i][e_did]][v_did]][d_name]);
	    case EBUY_TYPE_MS:format(tmps, sizeof(tmps),""H_EBUY"%s发布了新的宝贝{80FFFF}%s{FFFFFF}[%s 效用:%0.2f]   {2FD0D0}大家都来瞧瞧/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],pfood[Ebuy[i][e_did]][pfoode_name],pfood[Ebuy[i][e_did]][pfoode_usefuel]);
	}
	SendMessageToAll(COLOR_LIGHTGOLDENRODYELLOW,tmps);
    return 1;
}
stock delebuything(eid,amout)
{
    Ebuy[eid][e_amout]-=amout;
    if(Ebuy[eid][e_amout]<1)
	{
		Iter_Remove(Ebuy,eid);
		fremove(Get_Path(eid,31));
	}
	else SavedEbuy_data(eid);
	return 1;
}
Function LoadEbuyData(i, name[], value[])
{
    INI_Int("e_seq",Ebuy[i][e_seq]);
    INI_Int("e_uid",Ebuy[i][e_uid]);
    INI_Int("e_type",Ebuy[i][e_type]);
    INI_Int("e_did",Ebuy[i][e_did]);
    INI_Int("e_amout",Ebuy[i][e_amout]);
    INI_Int("e_value",Ebuy[i][e_value]);
	return 1;
}
Function SavedEbuy_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,31));
    INI_WriteInt(File,"e_seq",Ebuy[Count][e_seq]);
    INI_WriteInt(File,"e_uid",Ebuy[Count][e_uid]);
    INI_WriteInt(File,"e_type",Ebuy[Count][e_type]);
    INI_WriteInt(File,"e_did",Ebuy[Count][e_did]);
    INI_WriteInt(File,"e_amout",Ebuy[Count][e_amout]);
    INI_WriteInt(File,"e_value",Ebuy[Count][e_value]);
    INI_Close(File);
	return true;
}
