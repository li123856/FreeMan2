Function SavePlayerLog(pid)
{
	new str3[738];
    if(fexist(Get_Path(pid,25)))fremove(Get_Path(pid,25));
	new File:NameFile = fopen(Get_Path(pid,25), io_write);
    foreach(new i:PMSG[pid])
  	{
		format(str3,sizeof(str3),"%i %i %i %i %i %i %i %s %s %s\r\n",PMSG[pid][i][msg_see],PMSG[pid][i][msg_istq],PMSG[pid][i][msg_ismoney],PMSG[pid][i][msg_money],PMSG[pid][i][msg_isdj],PMSG[pid][i][msg_did],PMSG[pid][i][msg_amout],PMSG[pid][i][msg_sender],PMSG[pid][i][msg_time],PMSG[pid][i][msg_str]);
        fwrite(NameFile,str3);
	}
    fclose(NameFile);
	return 1;
}
stock SendCountUnreadMsg(playerid)
{
	new couts=0;
    foreach(new i:PMSG[PU[playerid]])
  	{
  	    if(!PMSG[PU[playerid]][i][msg_see])couts++;
  	}
  	if(couts>0)
  	{
  	    new tm[80];
		format(tm,80,""H_SER"�㻹��%i����Ϣδ���������Ϣ���Ӳ鿴/WDXX",couts);
		SM(COLOR_TWTAN,tm);
  	}
	return 1;
}
stock RemoveMsg(PID)
{
    Iter_Clear(PMSG[PID]);
    fremove(Get_Path(PID,25));
	return 1;
}
stock CountUnreadMsg(PID)
{
	new couts=0;
    foreach(new i:PMSG[PID])
  	{
  	    if(!PMSG[PID][i][msg_see])couts++;
  	}
	return couts;
}
stock LoadPlayerLog(pid)
{
	new tm1[512],ids=0;
    if(fexist(Get_Path(pid,25)))
    {
		new File:NameFile = fopen(Get_Path(pid,25), io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
        			sscanf(tm1, "iiiiiiis[80]s[32]s[150]",PMSG[pid][ids][msg_see],PMSG[pid][ids][msg_istq],PMSG[pid][ids][msg_ismoney],PMSG[pid][ids][msg_money],PMSG[pid][ids][msg_isdj],PMSG[pid][ids][msg_did],PMSG[pid][ids][msg_amout],PMSG[pid][ids][msg_sender],PMSG[pid][ids][msg_time],PMSG[pid][ids][msg_str]);
        			Iter_Add(PMSG[pid],ids);
					ids++;
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
stock PlayerSendPlayerLog(playerid,PID,Strs[],Money=0,Did=-1,amout=0)
{
    new i=Iter_Free(PMSG[PID]);
    if(i!=-1)
    {
        AddPlayerLog(PID,Gnn(playerid),Strs,Money,Did,amout);
        return 1;
    }
    else SM(COLOR_TWAQUA,"�Է���Ϣ���������޷�����");
	return 0;
}
stock AddPlayerLog(PID,Sender[],Strs[],Money=0,Did=-1,amout=0)
{
	new i=Iter_Free(PMSG[PID]);
	if(i!=-1)
	{
	    new str[32];
		new dateES[3];
		new timeES[3];
		getdate(dateES[0], dateES[1], dateES[2]);
		gettime(timeES[0], timeES[1], timeES[2]);
    	format(str,64, "%d��%d��%d��%02dʱ%02d��%02d��",dateES[0],dateES[1],dateES[2],timeES[0],timeES[1],timeES[2]);
		PMSG[PID][i][msg_see]=0;
		if(Money>0)
		{
		    PMSG[PID][i][msg_ismoney]=1;
		    PMSG[PID][i][msg_money]=Money;
		    PMSG[PID][i][msg_istq]=0;
		}
		else
		{
		    PMSG[PID][i][msg_ismoney]=0;
		    PMSG[PID][i][msg_money]=0;
		    PMSG[PID][i][msg_istq]=0;
		}
		if(Did!=-1)
		{
		    if(amout>0)
		    {
		        PMSG[PID][i][msg_isdj]=1;
		        PMSG[PID][i][msg_did]=Did;
		        PMSG[PID][i][msg_amout]=amout;
		        PMSG[PID][i][msg_istq]=0;
		    }
		    else
		    {
		        PMSG[PID][i][msg_isdj]=0;
		        PMSG[PID][i][msg_did]=-1;
		        PMSG[PID][i][msg_amout]=0;
		        PMSG[PID][i][msg_istq]=0;
		    }
		}
		else
		{
		    PMSG[PID][i][msg_isdj]=0;
		    PMSG[PID][i][msg_did]=-1;
		    PMSG[PID][i][msg_amout]=0;
		    PMSG[PID][i][msg_istq]=0;
		}
	    format(PMSG[PID][i][msg_sender],80,Sender);
	    format(PMSG[PID][i][msg_time],32,str);
	    format(PMSG[PID][i][msg_str],150,Strs);
	    Iter_Add(PMSG[PID],i);
	    SavePlayerLog(PID);
	    new ip=chackonlineEX(PID);
	    if(ip!=-1)
	    {
			new tm[80];
			format(tm,80,""H_SER"������1���µ���Ϣδ���������Ϣ���Ӳ鿴/WDXX");
			SendClientMessage(ip,COLOR_TWTAN,tm);
	    }
	}
	else
	{
	    RemoveMsg(PID);
	    AddPlayerLog(PID,Sender,Strs,Money,Did,amout);
	}
	return 1;
}
CMD:wdxx(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
	for(new i=Iter_Last(PMSG[PU[playerid]]);i!=Iter_Begin(PMSG[PU[playerid]]);i=Iter_Prev(PMSG[PU[playerid]],i))
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
        current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����,����ʱû����Ϣ", "�õ�", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�ҵ���Ϣ����[%i],δ��[%i]",current_number[playerid]-1,CountUnreadMsg(PU[playerid]));
	Dialog_Show(playerid, dl_mymsg, DIALOG_STYLE_LIST,tm, Showmymsglist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
stock Showmymsglist(playerid,pager)
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
	        if(PMSG[PU[playerid]][current_idx[playerid][i]][msg_see])format(tmps,150,"[�Ѷ�]������:%s  ʱ��:%s[����鿴]\n",PMSG[PU[playerid]][current_idx[playerid][i]][msg_sender],PMSG[PU[playerid]][current_idx[playerid][i]][msg_time]);
			else format(tmps,100,"[δ��]������:%s  ʱ��:%s[����鿴]\n",PMSG[PU[playerid]][current_idx[playerid][i]][msg_sender],PMSG[PU[playerid]][current_idx[playerid][i]][msg_time]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}�����Ϣ����\n");
		    strcat(tmp,tmps);
		    isover=1;
			break;
		}
	    else strcat(tmp,tmps);
	}
	if(isover==0)
	{
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
Dialog:dl_lookmsg(playerid, response, listitem, inputtext[])
{
    new listid=GetPVarInt(playerid,"listIDA");
	PMSG[PU[playerid]][listid][msg_see]=1;
	SavePlayerLog(PU[playerid]);
	Dialog_Show(playerid, dl_mymsg, DIALOG_STYLE_LIST,"�ҵ���Ϣ����", Showmymsglist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_lookmsgtq(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA"),tm[100];
		if(PMSG[PU[playerid]][listid][msg_istq]==0)
		{
		    if(PMSG[PU[playerid]][listid][msg_ismoney])
		    {
                Moneyhandle(PU[playerid],PMSG[PU[playerid]][listid][msg_money]);
                format(tm,100,""H_SER"����ȡ����Ϣ�������$%i",PMSG[PU[playerid]][listid][msg_money]);
                SM(COLOR_ORANGE,tm);
 			    format(tm,sizeof(tm),"%s��ȡ����Ϣ�������$%i",Gnn(playerid),PMSG[PU[playerid]][listid][msg_money]);
			    AdminWarn(tm);
                PMSG[PU[playerid]][listid][msg_ismoney]=0;
                PMSG[PU[playerid]][listid][msg_money]=0;
		    }
		    if(PMSG[PU[playerid]][listid][msg_isdj])
		    {
               Addbeibao(playerid,PMSG[PU[playerid]][listid][msg_did],PMSG[PU[playerid]][listid][msg_amout]);
               format(tm,100,""H_SER"����ȡ����Ϣ�������%i��%s,��������ı���/WDBB",PMSG[PU[playerid]][listid][msg_amout],Daoju[PMSG[PU[playerid]][listid][msg_did]][d_name]);
               SM(COLOR_ORANGE,tm);
			   format(tm,sizeof(tm),"%s��ȡ����Ϣ�������%i��%s",Gnn(playerid),PMSG[PU[playerid]][listid][msg_amout],Daoju[PMSG[PU[playerid]][listid][msg_did]][d_name]);
			   AdminWarn(tm);
               PMSG[PU[playerid]][listid][msg_isdj]=0;
               PMSG[PU[playerid]][listid][msg_did]=-1;
               PMSG[PU[playerid]][listid][msg_amout]=0;
		    }
		}
		PMSG[PU[playerid]][listid][msg_istq]=1;
		PMSG[PU[playerid]][listid][msg_see]=1;
		SavePlayerLog(PU[playerid]);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdxx");
	}
    return 1;
}
Dialog:dl_mymsg(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_mymsg, DIALOG_STYLE_LIST,"�ҵ���Ϣ����", Showmymsglist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])RemoveMsg(PU[playerid]);
		else
		{
			new listid=current_idx[playerid][page+listitem];
			new tm[150];
			format(tm,150,"������%s ʱ��%s",PMSG[PU[playerid]][listid][msg_sender],PMSG[PU[playerid]][listid][msg_time]);
			new Astr[1024],Str[150];
			format(Str,150,"%s\n",PMSG[PU[playerid]][listid][msg_str]);
			strcat(Astr,Str);
			SetPVarInt(playerid,"listIDA",listid);
			if(PMSG[PU[playerid]][listid][msg_istq]==0&&PMSG[PU[playerid]][listid][msg_ismoney]||PMSG[PU[playerid]][listid][msg_isdj])
			{
				format(Str,150,"����\n",PMSG[PU[playerid]][listid][msg_str]);
				strcat(Astr,Str);
			    if(PMSG[PU[playerid]][listid][msg_ismoney])
			    {
			        format(Str,150,"��Ǯ:$%i\n",PMSG[PU[playerid]][listid][msg_money]);
			        strcat(Astr,Str);
			    }
			    if(PMSG[PU[playerid]][listid][msg_isdj])
			    {
					format(Str,150,"����:%i��%s",PMSG[PU[playerid]][listid][msg_amout],Daoju[PMSG[PU[playerid]][listid][msg_did]][d_name]);
					strcat(Astr,Str);
			    }
			    return Dialog_Show(playerid,dl_lookmsgtq,DIALOG_STYLE_MSGBOX,tm,Astr, "��ȡ", "ȡ��");
			}
			Dialog_Show(playerid,dl_lookmsg, DIALOG_STYLE_MSGBOX,tm,Astr, "�ر�", "");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_mymsg, DIALOG_STYLE_LIST,"�ҵ���Ϣ����", Showmymsglist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
