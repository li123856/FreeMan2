stock Loadcpbuy(idx)
{
	new tm1[128];
    if(fexist(Get_Path(idx,29)))
    {
		new File:NameFile = fopen(Get_Path(idx,29), io_read);
    	if(NameFile)
    	{
    	    new ids=0;
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_CAIPIAOTC)
	        	    {
		        		sscanf(tm1, "p<,>iiiiii",caipiaobuy[idx][ids][cb_uid],caipiaobuy[idx][ids][cb_idx1],caipiaobuy[idx][ids][cb_idx2],caipiaobuy[idx][ids][cb_idx3],caipiaobuy[idx][ids][cb_idx4],caipiaobuy[idx][ids][cb_won]);
			    		Iter_Add(caipiaobuy[idx],ids);
		        		ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
Function Savecpbuy(idx)
{
	new str[4128];
    if(fexist(Get_Path(idx,29)))fremove(Get_Path(idx,29));
	new File:NameFile = fopen(Get_Path(idx,29), io_write);
    foreach(new i:caipiaobuy[idx])
  	{
		format(str,sizeof(str),"%s %i,%i,%i,%i,%i,%i\r\n",str,caipiaobuy[idx][i][cb_uid],caipiaobuy[idx][i][cb_idx1],caipiaobuy[idx][i][cb_idx2],caipiaobuy[idx][i][cb_idx3],caipiaobuy[idx][i][cb_idx4],caipiaobuy[idx][i][cb_won]);
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}

Function LoadCP_data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_CAIPIAO)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,28), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,28), "LoadCPData", false, true, i, true, false);
            caipiao[i][cp_id]=i;
            Loadcpbuy(i);
 			Iter_Add(caipiao,i);
 			idx++;
        }
    }
    return idx;
}
Function SavedCP_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,28));
    INI_WriteString(File,"cp_name",caipiao[Count][cp_name]);
    INI_WriteString(File,"cp_times",caipiao[Count][cp_times]);
    INI_WriteInt(File, "cp_idx1",caipiao[Count][cp_idx1]);
    INI_WriteInt(File, "cp_idx2",caipiao[Count][cp_idx2]);
    INI_WriteInt(File, "cp_idx3",caipiao[Count][cp_idx3]);
    INI_WriteInt(File, "cp_idx4",caipiao[Count][cp_idx4]);
    INI_WriteInt(File, "cp_uid",caipiao[Count][cp_uid]);
    INI_WriteInt(File, "cp_stat",caipiao[Count][cp_stat]);
    INI_WriteInt(File,"cp_crash",caipiao[Count][cp_crash]);
    INI_Close(File);
	return true;
}
Function LoadCPData(i, name[], value[])
{
    INI_String("cp_name",caipiao[i][cp_name],100);
    INI_String("cp_times",caipiao[i][cp_times],100);
    INI_Int("cp_idx1",caipiao[i][cp_idx1]);
    INI_Int("cp_idx2",caipiao[i][cp_idx2]);
    INI_Int("cp_idx3",caipiao[i][cp_idx3]);
    INI_Int("cp_idx4",caipiao[i][cp_idx4]);
    INI_Int("cp_uid",caipiao[i][cp_uid]);
    INI_Int("cp_stat",caipiao[i][cp_stat]);
    INI_Int("cp_crash",caipiao[i][cp_crash]);
	return 1;
}
stock Getcaipiao()
{
	foreach(new i:caipiao)
	{
		if(caipiao[i][cp_stat]==CPSTAT_START)return i;
	}
	return -1;
}
timer cp2[10000](ids)
{
    new str[128];
	caipiao[ids][cp_idx2]=random(10);
	format(str,128,""H_CP"%s彩票,号码2摇号完毕为[%i]",caipiao[ids][cp_name],caipiao[ids][cp_idx2]);
	SendMessageToAll(COLOR_PALETURQUOISE,str);
	defer cp3[10000](ids);
    return 1;
}
timer cp3[10000](ids)
{
    new str[128];
    caipiao[ids][cp_idx3]=random(10);
	format(str,128,""H_CP"%s彩票,号码3摇号完毕为[%i]",caipiao[ids][cp_name],caipiao[ids][cp_idx3]);
	SendMessageToAll(COLOR_PALETURQUOISE,str);
	defer cp4[10000](ids);
    return 1;
}
timer cp4[10000](ids)
{
    new str[128];
	caipiao[ids][cp_idx4]=random(10);
	format(str,128,""H_CP"%s彩票,号码4摇号完毕为[%i]",caipiao[ids][cp_name],caipiao[ids][cp_idx4]);
	SendMessageToAll(COLOR_PALETURQUOISE,str);
	SendMessageToAll(COLOR_PALETURQUOISE,"请稍等,正在统计获奖数据");
	defer cp5[10000](ids);
    return 1;
}
timer cp5[10000](ids)
{
    new amout=0,str[128];
   	foreach(new i:caipiaobuy[ids])
	{
		if(caipiaobuy[ids][i][cb_idx1]==caipiao[ids][cp_idx1]&&caipiaobuy[ids][i][cb_idx2]==caipiao[ids][cp_idx2]&&caipiaobuy[ids][i][cb_idx3]==caipiao[ids][cp_idx3]&&caipiaobuy[ids][i][cb_idx4]==caipiao[ids][cp_idx4])
 		{
			caipiaobuy[ids][i][cb_won]=1;
			amout++;
		}
	}
   	format(str,128,""H_CP"%s彩票摇号完毕,号码为[%i] [%i] [%i] [%i],奖金总额:$%i,中奖人数:%i人",caipiao[ids][cp_name],caipiao[ids][cp_idx1],caipiao[ids][cp_idx2],caipiao[ids][cp_idx3],caipiao[ids][cp_idx4],caipiao[ids][cp_crash]*100,amout);
   	SendMessageToAll(COLOR_PALETURQUOISE,str);
   	caipiao[ids][cp_stat]=CPSTAT_OVER;
   	SavedCP_data(ids);
	Savecpbuy(ids);
	if(amout>0)
	{
      	new cpjiangjin=floatround(caipiao[ids][cp_crash]*100/amout);
      	if(cpjiangjin>1)
      	{
	    	foreach(new i:caipiaobuy[ids])
	  		{
				if(caipiaobuy[ids][i][cb_won])
				{
					format(str,128,"你购买的%s彩票,号码%i,%i,%i,%i获得大奖,奖金在附件",caipiao[ids][cp_name],caipiaobuy[ids][i][cb_idx1],caipiaobuy[ids][i][cb_idx2],caipiaobuy[ids][i][cb_idx3],caipiaobuy[ids][i][cb_idx4]);
					AddPlayerLog(caipiaobuy[ids][i][cb_uid],"彩票中奖",str,cpjiangjin);
      				format(str,128,""H_CP"%s购买的彩票%i中奖了,获得奖金金额%i",UID[caipiaobuy[ids][i][cb_uid]][u_name],cpjiangjin);
      				SendMessageToAll(COLOR_PALETURQUOISE,str);
				}
			}
		}
		else
		{
      		format(str,128,""H_CP"%s彩票因奖金总额过少,无法发放",caipiao[ids][cp_name]);
      		SendMessageToAll(COLOR_PALETURQUOISE,str);
		}
	}
	defer newcp[10000]();
    return 1;
}
timer newcp[10000]()
{
	Addnewcp();
    return 1;
}
Function kaiJiang()
{
	if(Iter_Count(caipiao)!=0)
	{
	    new ids=Getcaipiao(),str[128];
		if(ids!=-1)
		{
	  		if(Iter_Count(caipiaobuy[ids])==0)
	  		{
	  		    format(str,128,""H_CP"%s彩票因无人购买,此期不摇号",caipiao[ids][cp_name]);
	      		SendMessageToAll(COLOR_PALETURQUOISE,str);
	      		caipiao[ids][cp_stat]=CPSTAT_OVER;
	      		SavedCP_data(ids);
	  			Savecpbuy(ids);
	  			defer newcp[10000]();
	      		return 1;
	  		}
		    caipiao[ids][cp_idx1]=random(10);
		    caipiao[ids][cp_stat]=CPSTAT_OPEN;
	      	format(str,128,""H_CP"%s彩票,号码1摇号完毕为[%i]",caipiao[ids][cp_name],caipiao[ids][cp_idx1]);
	      	SendMessageToAll(COLOR_PALETURQUOISE,str);
			defer cp2[10000](ids);
		}
	}
	return 1;
}
stock Addnewcp()
{
    new i=Iter_Free(caipiao);
	if(i!=-1)
	{
		new dateES[3];
		new timeES[3],str[128];
		getdate(dateES[0], dateES[1], dateES[2]);
		gettime(timeES[0], timeES[1], timeES[2]);
    	format(caipiao[i][cp_name],100,"自由彩%i期",i);
		format(caipiao[i][cp_times],100,"%i.%i.%i-%i:%i:%i",dateES[0], dateES[1], dateES[2],timeES[0], timeES[1], timeES[2]);
		caipiao[i][cp_uid]=-1;
		caipiao[i][cp_stat]=CPSTAT_START;
		caipiao[i][cp_crash]=0;
		caipiao[i][cp_idx1]=-1;
		caipiao[i][cp_idx2]=-1;
		caipiao[i][cp_idx3]=-1;
		caipiao[i][cp_idx4]=-1;
		Iter_Add(caipiao,i);
		SavedCP_data(i);
	    format(str,128,""H_CP"%s彩票开始发行,欢迎购买",caipiao[i][cp_name]);
	    SendMessageToAll(COLOR_PALETURQUOISE,str);
	}
	return 1;
}
CMD:kj(playerid, params[], help)
{
	if(GetadminLevel(playerid)<2500) return SM(COLOR_TWAQUA, "你不是管理员或没有值班或没有足够的权限");
	kaiJiang();
	return 1;
}
Dialog:dl_cptzztc(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new idx1,idx2,idx3,idx4;
		if(!EnoughMoneyEx(playerid,500))return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_INPUT,"错误","你没有那么多钱$500000", "嗯嗯", "");
		if(sscanf(inputtext, "iiii",idx1,idx2,idx3,idx4))return Dialog_Show(playerid,dl_cptzztc, DIALOG_STYLE_INPUT,"投彩号码","请输入四个投彩号码[小于10]\n例如\n0 1 2 3\n", "确定", "取消");
	    new idx=Getcaipiao();
		if(idx==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "对不起,目前暂无彩票发行", "好的", "");
		new i=Iter_Free(caipiaobuy[idx]);
		if(caipiao[idx][cp_stat]!=CPSTAT_START)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "对不起,该彩票正在开奖中,请等开奖完毕再行购买","好的", "");
		if(i==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "对不起,该彩票已被销售一空", "好的", "");
		Moneyhandle(PU[playerid],-500);
		caipiaobuy[idx][i][cb_uid]=PU[playerid];
		caipiaobuy[idx][i][cb_idx1]=idx1;
		caipiaobuy[idx][i][cb_idx2]=idx2;
		caipiaobuy[idx][i][cb_idx3]=idx3;
		caipiaobuy[idx][i][cb_idx4]=idx4;
		caipiaobuy[idx][i][cb_won]=0;
		caipiao[idx][cp_crash]+=500;
		Iter_Add(caipiaobuy[idx],i);
		SavedCP_data(idx);
		Savecpbuy(idx);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒", "购买彩票成功", "好的", "");
	}
	return 1;
}
Dialog:dl_cptzz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		Dialog_Show(playerid,dl_cptzztc, DIALOG_STYLE_INPUT,"投彩号码","请输入四个投彩号码[小于10]\n例如\n0 1 2 3\n", "确定", "取消");
 	}
 	else
 	{
		current_number[playerid]=1;
		new current=-1;
		for(new i=Iter_Last(caipiao);i!=Iter_Begin(caipiao);i=Iter_Prev(caipiao,i))
		{
	        current_idx[playerid][current_number[playerid]]=i;
	        current_number[playerid]++;
	        current++;
		}
		if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,暂时没有彩票信息", "好的", "");
		P_page[playerid]=1;
		new tm[100];
		format(tm,100,"历史彩票[%i]",current_number[playerid]-1);
		Dialog_Show(playerid, dl_lscp, DIALOG_STYLE_LIST,tm, Showcplist(playerid,P_page[playerid]), "确定", "取消");
 	}
	return 1;
}
stock Showcplist(playerid,pager)
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
	        if(caipiao[current_idx[playerid][i]][cp_stat]==CPSTAT_START)format(tmps,150,"[正在发行]%s\n",caipiao[current_idx[playerid][i]][cp_name]);
			else format(tmps,100,"[历史彩票]%s\n",caipiao[current_idx[playerid][i]][cp_name]);
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
Dialog:dl_cpmsg(playerid, response, listitem, inputtext[])
{
	current_number[playerid]=1;
	new current=-1;
	for(new i=Iter_Last(caipiao);i!=Iter_Begin(caipiao);i=Iter_Prev(caipiao,i))
	{
	    current_idx[playerid][current_number[playerid]]=i;
	    current_number[playerid]++;
	    current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,暂时没有彩票信息", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"历史彩票[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_lscp, DIALOG_STYLE_LIST,tm, Showcplist(playerid,P_page[playerid]), "确定", "取消");
    return 1;
}
Dialog:dl_lscp(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_lscp,DIALOG_STYLE_LIST,"历史彩票",Showcplist(playerid,P_page[playerid]),"确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem],Astr[1024],Str[80];
			if(caipiao[listid][cp_stat]==CPSTAT_START)
			{
				format(Str, sizeof(Str), "名称:%s\n",caipiao[listid][cp_name]);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "发行时间:%s\n",caipiao[listid][cp_times]);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "当前总奖金:$%i\n",caipiao[listid][cp_crash]*100);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "中奖号码:[*][*][*][*]\n");
				strcat(Astr,Str);
				format(Str, sizeof(Str), "购票者如下\n");
				strcat(Astr,Str);
    			foreach(new i:caipiaobuy[listid])
  				{
					format(Str,sizeof(Str),"名字:%s 号码[%i][%i][%i][%i]\n",UID[caipiaobuy[listid][i][cb_uid]][u_name],caipiaobuy[listid][i][cb_idx1],caipiaobuy[listid][i][cb_idx2],caipiaobuy[listid][i][cb_idx3],caipiaobuy[listid][i][cb_idx4]);
                    strcat(Astr,Str);
				}
			}
			else
			{
				format(Str, sizeof(Str), "名称:%s\n",caipiao[listid][cp_name]);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "发行时间:%s\n",caipiao[listid][cp_times]);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "总奖金:$%i\n",caipiao[listid][cp_crash]*100);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "中奖号码:[%i][%i][%i][%i]\n",caipiao[listid][cp_idx1],caipiao[listid][cp_idx2],caipiao[listid][cp_idx3],caipiao[listid][cp_idx4]);
				strcat(Astr,Str);
				format(Str, sizeof(Str), "购票者如下\n");
				strcat(Astr,Str);
    			foreach(new i:caipiaobuy[listid])
  				{
					if(caipiaobuy[listid][i][cb_won])format(Str,sizeof(Str),"[中奖]名字:%s 号码[%i][%i][%i][%i]\n",UID[caipiaobuy[listid][i][cb_uid]][u_name],caipiaobuy[listid][i][cb_idx1],caipiaobuy[listid][i][cb_idx2],caipiaobuy[listid][i][cb_idx3],caipiaobuy[listid][i][cb_idx4]);
					else format(Str,sizeof(Str),"名字:%s 号码[%i][%i][%i][%i]\n",UID[caipiaobuy[listid][i][cb_uid]][u_name],caipiaobuy[listid][i][cb_idx1],caipiaobuy[listid][i][cb_idx2],caipiaobuy[listid][i][cb_idx3],caipiaobuy[listid][i][cb_idx4]);
                    strcat(Astr,Str);
				}
			}
			Dialog_Show(playerid,dl_cpmsg, DIALOG_STYLE_MSGBOX,"投注信息",Astr, "看完了", "");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_lscp,DIALOG_STYLE_LIST,"历史彩票",Showcplist(playerid,P_page[playerid]),"确定", "取消");
		}
	}
	return 1;
}
