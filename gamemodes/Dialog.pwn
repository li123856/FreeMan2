Dialog:dl_login(playerid, response, listitem, inputtext[])
{
	if (response)
	{
	    if (strlenEx(inputtext)>20||strlenEx(inputtext)<2)return Dialog_Show(playerid, dl_register, DIALOG_STYLE_INPUT, "��¼", "��������������¼[����������3���ַ���С��20���ַ�]", "ȷ��", "ȡ��");
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
						format(str,60,"%s�ĺ���",UID[friends[PU[playerid]][i][fr_uid]][u_name]);
						UpdateDynamic3DTextLabelText(friend3D[playerid],colorMenu[UID[friends[PU[playerid]][i][fr_uid]][u_color]],str);
						break;
					}
				}
				SetPlayerScore(playerid,UID[PU[playerid]][u_Score]);
				DisableRemoteVehicleCollisions(playerid,UID[PU[playerid]][u_vcoll]);
				GivePlayerMoney(playerid,999999999);
				if(UID[PU[playerid]][u_mode])UpdateDynamic3DTextLabelText(Mode3D[playerid],-1,"�޵�ģʽ");
				SM(COLOR_DARKSEAGREEN, "��¼�ɹ�!");
			}
			else
			{
			    SM(COLOR_DARKSEAGREEN, "�������!");
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
			            format(str, sizeof(str), "[%s][%s]%s%s[%i]��½�˷�����",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],colorMenuEx[UID[PU[playerid]][u_color]],UID[PU[playerid]][u_name],playerid);
			            SendMessageToAll(colorMenu[GInfo[UID[PU[playerid]][u_gid]][g_color]],str);
				    }
				    else
				    {
				        format(str,100,"%s%s[%i]��½�˷�����",colorMenuEx[UID[PU[playerid]][u_color]],UID[PU[playerid]][u_name],playerid);
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
		            			format(tmps, sizeof(tmps),""H_MUSICS"������Ŀǰ���ڹ㲥����[{D96D26}%s{FFFFFF}]",MUSICS[musicid][music_name]);
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
			            format(str, sizeof(str), "[%s][%s]%s%s[%i]�뿪�˷�����",GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],colorMenuEx[UID[PU[playerid]][u_color]],UID[PU[playerid]][u_name],playerid);
			            SendMessageToAll(colorMenu[GInfo[UID[PU[playerid]][u_gid]][g_color]],str);
				    }
				    else
				    {
				        format(str,100,"%s[%i]�뿪�˷�����",UID[PU[playerid]][u_name],playerid);
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
	    if (strlenEx(inputtext)>20||strlenEx(inputtext)<2)return Dialog_Show(playerid, dl_register, DIALOG_STYLE_INPUT, "ע��", "������������ע��[����������3���ַ���С��20���ַ�]", "ȷ��", "ȡ��");
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
			format(str,100,"%s[%i]ע�Ტ��½�˷�����,��%iλ���",Gnn(playerid),playerid,PU[playerid]+1);
			SendMessageToAll(COLOR_YELLOWGREEN,str);
			SetSpawnInfoEx(playerid, 0,UID[PU[playerid]][u_Skin],spawnX[playerid],spawnY[playerid],spawnZ[playerid],spawnA[playerid],0,0,0,0, 0, 0 );
			SpawnPlayer(playerid);
			Hidetab(playerid);
			ComeOut(playerid,0);
			IsSpawn[playerid]=true;
			UID[PU[playerid]][u_reg]=true;
			AddPlayerLog(PU[playerid],"ϵͳ","��ӭע�᱾������,�ڴ��͸���һЩ��Ϸ�Ҽ�����",5000);
		}
	}
	else DelayKick(playerid);
	return 1;
}
Dialog:dl_maketele(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(UID[PU[playerid]][u_Score]<200)return SM(COLOR_TWTAN,"��Ļ��ֲ���200,�޷���������");
		if(!EnoughMoneyEx(playerid,CM_TELES))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $500000", "�õ�", "");
		new i=Iter_Free(Tinfo);
		if(i==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "ȫ�����������Ѵﵽ����", "�õ�", "");
		new tname[128],tcmd[100];
        if(sscanf(inputtext, "s[128]s[100]",tname,tcmd))return Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "��������", "�����봫�͵����ƺ�ָ��\n��ע�ⲻҪ�����ظ���ϵͳָ������ָ����Ч\n�ÿո�ָ� ����\n�״�վ LDZ", "����", "ȡ��");
		if(strlenEx(tname)<2)return Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "��������", "�����봫�͵����ƺ�ָ��\n��ע�ⲻҪ�����ظ���ϵͳָ������ָ����Ч\n�ÿո�ָ� ����\n�״�վ LDZ", "����", "ȡ��");
		if(strlenEx(tcmd)<2)return Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "��������", "�����봫�͵����ƺ�ָ��\n��ע�ⲻҪ�����ظ���ϵͳָ������ָ����Ч\n�ÿո�ָ� ����\n�״�վ LDZ", "����", "ȡ��");
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
		Dialog_Show(playerid,dl_telecolor,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
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
		Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
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
			Dialog_Show(playerid,dl_teles,DIALOG_STYLE_TABLIST_HEADERS,"�����б�/LLCS",Showtelelist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			if(Tinfo[listid][Tuid]==PU[playerid])return CmdTeleportPlayer(playerid,Tinfo[listid][Tcolor],Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z],Tinfo[listid][Tcurrent_A],Tinfo[listid][Tcurrent_In],Tinfo[listid][Tcurrent_Wl],Tinfo[listid][Tname],Tinfo[listid][Tcmd],Tinfo[listid][Trate],Tinfo[listid][Tcreater]);
			if(Tinfo[listid][Tmoney]>0)
			{
			    SetPVarInt(playerid,"listIDA",listid);
			    new str[100];
			    format(str, sizeof(str),"%s��Ҫ����$%i,ȷ��Ҫʹ��?",Tinfo[listid][Tname],Tinfo[listid][Tmoney]);
			    Dialog_Show(playerid, dl_cscostmoney, DIALOG_STYLE_MSGBOX, "����",str, "ʹ��", "����");
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
			Dialog_Show(playerid,dl_teles,DIALOG_STYLE_TABLIST_HEADERS,"�����б�/LLCS",Showtelelist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_cscostmoney(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		if(UID[PU[playerid]][u_Cash]<Tinfo[listid][Tmoney])return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "���Ǯ����ʹ�ô���Ŷ", "�õ�", "");
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
			Dialog_Show(playerid,dl_myteles,DIALOG_STYLE_LIST,"�ҵĴ���/WDCS",Showmytelelist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(IsPlayerInDynamicArea(playerid,ffdtarea))return SM(COLOR_TWTAN,"�����ڼҾ��г���������");
		    if(UID[PU[playerid]][u_Score]<300)return SM(COLOR_TWTAN,"��Ļ��ֲ���300,�޷���������");
			new i=Iter_Free(Tinfo);
			if(i==-1)return SM(COLOR_TWAQUA,"ȫ�����������Ѵﵽ����");
			Dialog_Show(playerid, dl_maketele, DIALOG_STYLE_INPUT, "��������", "�����봫�͵����ƺ�ָ��\n��ע�ⲻҪ�����ظ���ϵͳָ������ָ����Ч\n�ÿո�ָ� ����\n�״�վ LDZ", "����", "ȡ��");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid,dl_myteles,DIALOG_STYLE_LIST,"�ҵĴ���/WDCS",Showmytelelist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
mytelessz_Dialog_Show(teleid)
{
	new tm2[100],tm3[1024];
	format(tm2,100,"ȡ������-��:$%i\n",Tinfo[teleid][Tmoneybox]);
	strcat(tm3,tm2);
	format(tm2,100,"�޸�����-��:%s\n",Tinfo[teleid][Tname]);
	strcat(tm3,tm2);
	format(tm2,100,"�޸�ָ��-��:%s\n",Tinfo[teleid][Tcmd]);
	strcat(tm3,tm2);
	format(tm2,100,"�޸��շ�-��:$%i\n",Tinfo[teleid][Tmoney]);
	strcat(tm3,tm2);
	if(Tinfo[teleid][Tpublic]==1)format(tm2,100,"�Ƿ񹫿�-��:��\n");
	else format(tm2,100,"�Ƿ񹫿�-��:��\n");
	strcat(tm3,tm2);
	format(tm2,100,"������ɫ\n");
	strcat(tm3,tm2);
	strcat(tm3,"�޸Ķ�λ\nɾ������");
	return tm3;
}
Dialog:dl_mytelessz_sy(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_mytelessz_sy,DIALOG_STYLE_INPUT,"ȡ������","��ֵ�������0","ȷ��", "ȡ��");
		if(strval(inputtext)>Tinfo[listid][Tmoneybox])return Dialog_Show(playerid,dl_mytelessz_sy,DIALOG_STYLE_INPUT,"ȡ������","û����ô������","ȷ��", "ȡ��");
        Tinfo[listid][Tmoneybox]-=strval(inputtext);
        Moneyhandle(PU[playerid],strval(inputtext));
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"������ȡ��\n��ǰ����ʣ������%i",Tinfo[listid][Tmoneybox]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
	return 1;
}
Dialog:dl_mytelessz_mc(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
        if(!EnoughMoneyEx(playerid,CM_TELESNAME))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_TELESNAME);
		ReColor(inputtext);
		if(strlenEx(inputtext)<1)return Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"��������","�ַ�����,�������µ�����","ȷ��", "ȡ��");
		format(Tinfo[listid][Tname],128,inputtext);
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"���������Ѹ�Ϊ%s",Tinfo[listid][Tname]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
	return 1;
}
Dialog:dl_mytelessz_zl(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
        if(!EnoughMoneyEx(playerid,CM_TELESCMD))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_TELESCMD);
		ReColor(inputtext);
		if(strlenEx(inputtext)<2)return Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"����ָ��","�ַ�����,�������µ�����","ȷ��", "ȡ��");
		if(FindSameTeleCmd(inputtext))return Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"����ָ��","ָ���Ѵ���,�������µ�����","ȷ��", "ȡ��");
		format(Tinfo[listid][Tcmd],100,inputtext);
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"����ָ���Ѹ�Ϊ/%s",Tinfo[listid][Tcmd]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
	return 1;
}
Dialog:dl_mytelessz_sf(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_mytelessz_sf,DIALOG_STYLE_INPUT,"�����շ�","��ֵ����,�������µ��շѶ�","ȷ��", "ȡ��");
		if(strval(inputtext)>MAX_TELE_COST_MONEY)return Dialog_Show(playerid,dl_mytelessz_sf,DIALOG_STYLE_INPUT,"�����շ�","��ֵ���ܴ���50W,�������µ��շѶ�","ȷ��", "ȡ��");
		Tinfo[listid][Tmoney]=strval(inputtext);
        Savedtel_data(listid);
        new tm[100];
		format(tm,100,"�����շ��Ѹ�Ϊ$%i",Tinfo[listid][Tmoney]);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
        DeletePVar(playerid,"listIDA");
	}
	else Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
	return 1;
}
Dialog:dl_mytelessz_gk(playerid, response, listitem, inputtext[])
{
	new listid=GetPVarInt(playerid,"listIDA");
	Dialog_Show(playerid,dl_mytelessz,DIALOG_STYLE_LIST,"��������",mytelessz_Dialog_Show(listid),"ѡ��", "ȡ��");
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
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
		   	    new tm[100];
				format(tm,100,"��ǰ:$%i\n������ȡ��������",Tinfo[listid][Tmoneybox]);
		   	    Dialog_Show(playerid,dl_mytelessz_sy,DIALOG_STYLE_INPUT,"ȡ������",tm,"ȷ��", "ȡ��");
		   	}
		   	case 1:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
		   	    Dialog_Show(playerid,dl_mytelessz_mc,DIALOG_STYLE_INPUT,"��������","�������µ�����","ȷ��", "ȡ��");
		   	}
		   	case 2:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
				Dialog_Show(playerid,dl_mytelessz_zl,DIALOG_STYLE_INPUT,"����ָ��","�������µ�ָ��","ȷ��", "ȡ��");
		   	}
		   	case 3:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
				Dialog_Show(playerid,dl_mytelessz_sf,DIALOG_STYLE_INPUT,"�����շ�","�������µ��շѶ�","ȷ��", "ȡ��");
		   	}
		   	case 4:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
				if(Tinfo[listid][Tpublic]==1)Tinfo[listid][Tpublic]=0;
				else Tinfo[listid][Tpublic]=1;
	        	new tm[100];
				if(Tinfo[listid][Tpublic]==1)format(tm,100,"�޸ĳɹ�,��ǰ״̬:����");
				else format(tm,100,"�޸ĳɹ�,��ǰ״̬:������");
				Dialog_Show(playerid,dl_mytelessz_gk,DIALOG_STYLE_MSGBOX,"���Ĺ���״̬",tm,"ȷ��", "ȡ��");
		   	}
		   	case 5:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_telecolor,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
		   	}
		   	case 6:
		   	{
				if(IsPlayerInDynamicArea(playerid,ffdtarea))return SM(COLOR_TWTAN,"�����ڼҾ��г���������");
		   	    if(!EnoughMoneyEx(playerid,CM_TELESDINGWEI))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $10000", "�õ�", "");
        		Moneyhandle(PU[playerid],-CM_TELESDINGWEI);
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
		        GetPlayerPos(playerid,Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z]);
				GetPlayerFacingAngle(playerid,Tinfo[listid][Tcurrent_A]);
				Tinfo[listid][Tcurrent_In]=GetPlayerInterior(playerid);
			    Tinfo[listid][Tcurrent_Wl]=GetPlayerVirtualWorld(playerid);
	        	new tm[100];
				format(tm,100,"��λ�ɹ�\nX��:%0.1f,Y��:%0.1f,Z��:%0.1f,A��:%0.1f\n�ռ�:%i   ����:%i",Tinfo[listid][Tcurrent_X],Tinfo[listid][Tcurrent_Y],Tinfo[listid][Tcurrent_Z],Tinfo[listid][Tcurrent_A],Tinfo[listid][Tcurrent_In],Tinfo[listid][Tcurrent_Wl]);
				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
	            DeletePVar(playerid,"listIDA");
		   	}
		   	case 7:
		   	{
		   	    if(!Isowner(playerid,Tinfo[listid][Tuid]))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�˴�����ʧЧ����������", "�õ�", "");
	    		if(fexist(Get_Path(listid,2)))
	    		{
	        		new tm[100];
					format(tm,100,"��Ĵ���%s(/%s)ɾ���ɹ�",Tinfo[listid][Tname],Tinfo[listid][Tcmd]);
					Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
	        		Iter_Remove(Tinfo,listid);
	        		fremove(Get_Path(listid,2));
	    		}
	    		else Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "�޷��ҵ������ļ�", "�õ�", "");
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
	format(tmp,4128, "������\t����\tָ��\t����\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
        new tmps[256],tm[64];
        if(i<current_number[playerid])
        {
			format(tm,64,"/%s",Tinfo[current_idx[playerid][i]][Tcmd]);
			format(tmps,128,"%s%s\t{FFFF00}$%i\t{FF80C0}%s\t{ff7575}%i��\n",colorMenuEx[Tinfo[current_idx[playerid][i]][Tcolor]],Tinfo[current_idx[playerid][i]][Tname],Tinfo[current_idx[playerid][i]][Tmoney],tm,Tinfo[current_idx[playerid][i]][Trate]);
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
    	strcat(tmp, "\t\t{FF8000}��һҳ\n");
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
	        	strcat(tmps,"{808080}-����");
				format(tmps,128,"%s%s{FF8000}�շ�:%i{FFFF00}����:%i{FF80C0}����:%i{ff7575}(%s)����ʱ��:%s\n",colorMenuEx[Tinfo[current_idx[playerid][i]][Tcolor]],Tinfo[current_idx[playerid][i]][Tname],Tinfo[current_idx[playerid][i]][Tmoney],Tinfo[current_idx[playerid][i]][Trate],Tinfo[current_idx[playerid][i]][Tmoneybox],tm,Tinfo[current_idx[playerid][i]][Tcreatime]);
			}
			else
			{
			    strcat(tmps,"{808080}-������");
				format(tmps,128,"%s%s{FF8000}�շ�:%i{FFFF00}����:%i{FF80C0}����:%i{ff7575}(%s)����ʱ��:%s\n",colorMenuEx[Tinfo[current_idx[playerid][i]][Tcolor]],Tinfo[current_idx[playerid][i]][Tname],Tinfo[current_idx[playerid][i]][Tmoney],Tinfo[current_idx[playerid][i]][Trate],Tinfo[current_idx[playerid][i]][Tmoneybox],tm,Tinfo[current_idx[playerid][i]][Tcreatime]);

			}
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}����µĴ���");
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
Dialog:dl_adxufei(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
	    if(strval(inputtext)*CM_CGGXF<=0)return Dialog_Show(playerid,dl_adxufei,DIALOG_STYLE_INPUT,"��ֵ����","�������ÿ��$5000","ȷ��", "ȡ��");
        if(!EnoughMoneyEx(playerid,strval(inputtext)*CM_CGGXF))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ", "�õ�", "");
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
	            Dialog_Show(playerid,dl_adxufei,DIALOG_STYLE_INPUT,"���ѹ��","�������ÿ��$2000","ȷ��", "ȡ��");
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
				Dialog_Show(playerid,dl_ggcolor,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
	        }
	        case 2:
	        {
                fremove(Get_Path(listid,16));
				Iter_Remove(RM,listid);
				SM(COLOR_TWAQUA,"��ɾ���˹��");
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
			Dialog_Show(playerid, dl_mygg, DIALOG_STYLE_LIST,"�ҵĹ��/WDGG", Showmygglist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<300)return SM(COLOR_TWTAN,"��Ļ��ֲ���300,�޷��������");
			new i=Iter_Free(RM);
			if(i==-1)return SM(COLOR_TWAQUA,"ȫ����������Ѵﵽ����");
			Dialog_Show(playerid,dl_addgg,DIALOG_STYLE_INPUT,"��ӹ��","�����Ϣ[������5����]","ȷ��", "ȡ��");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_mggsz,DIALOG_STYLE_LIST,"�������","����\n��ɫ\nɾ��","ѡ��", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_mygg, DIALOG_STYLE_LIST,"�ҵĹ��/WDGG", Showmygglist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
			format(tmps,100,"[ID:%i][����:%i]%s%s\n",current_idx[playerid][i],RM[current_idx[playerid][i]][r_last],colorMenuEx[RM[current_idx[playerid][i]][r_color]],RM[current_idx[playerid][i]][r_msg]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}����µĹ����");
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
			format(tmps,100,"ID:%i���ֵ� -- �������\n",current_idx[playerid][i]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}����µ����ֵ�");
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
Dialog:dl_makefont(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        if(!EnoughMoneyEx(playerid,CM_WENZI))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","��û����ô��Ǯ $1000000", "�õ�", "");
        Moneyhandle(PU[playerid],-CM_WENZI);
		new i=Iter_Free(fonts);
		if(i==-1)return SM(COLOR_TWAQUA,"ȫ�����ֵ������Ѵﵽ����");
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
			Dialog_Show(playerid, dl_myfonts, DIALOG_STYLE_LIST,"�ҵ����ֵ�/WDWZ", Showmyfontlist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		    if(UID[PU[playerid]][u_Score]<300)return SM(COLOR_TWTAN,"��Ļ��ֲ���300,�޷��������ֵ�");
			new i=Iter_Free(fonts);
			if(i==-1)return SM(COLOR_TWAQUA,"ȫ�����ֵ������Ѵﵽ����");
			Dialog_Show(playerid, dl_makefont, DIALOG_STYLE_MSGBOX, "�������ֵ�", "��ȷ���Ƿ��ڴ˴�Ҫ����", "����", "ȡ��");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_myfontssz,DIALOG_STYLE_LIST,"���ֵ�����","����\n��ɫ\n���\nǽ��\n��ɫ\nǨ��\n����\nɾ��","ѡ��", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_myfonts, DIALOG_STYLE_LIST,"�ҵ����ֵ�/WDWZ", Showmyfontlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
				format(tm,100,"����[%i]��",current_number[playerid]-1);
				Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,tm,Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
			}
            case 1:
            {
				new tmp[738],Stru[64];
				Loop(x,sizeof(colorMenu)-SCOLOR)
				{
					format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
					strcat(tmp,Stru);
				}
				Dialog_Show(playerid,dl_myfontscolor,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
            }
            case 2:
            {
				new tm[100];
				format(tm,100,"��ǰ���[%i]����������Ҫ���ĵļ��",fonts[listid][f_Dis]);
				Dialog_Show(playerid, dl_myfontsjianju, DIALOG_STYLE_INPUT,"���ļ��",tm, "ȷ��", "ȡ��");
            }
            case 3:
            {
				new tm[100];
				if(fonts[listid][f_LOS]==1)format(tm,100,"��ǰǽ��[��],������ �� ���");
				else format(tm,100,"��ǰǽ��[��],������ �� ���");
				Dialog_Show(playerid, dl_myfontsqiangbi, DIALOG_STYLE_INPUT,"����ǽ��",tm, "ȷ��", "ȡ��");
            }
            case 4:
            {
				new tm[100];
				if(fonts[listid][f_iscol]==0)format(tm,100,"��ǰ��ɫ[��],�Ƿ����");
				else format(tm,100,"��ǰ��ɫ[��],�Ƿ����");
				Dialog_Show(playerid, dl_myfontsbianse, DIALOG_STYLE_MSGBOX,"���ı�ɫ",tm, "ȷ��", "ȡ��");
            }
            case 5:
            {
				Dialog_Show(playerid, dl_myfontsqianyi, DIALOG_STYLE_MSGBOX,"����λ��","�Ƿ�������굽��Ϊֹ", "ȷ��", "ȡ��");
            }
            case 6:
            {
				Dialog_Show(playerid, dl_myfontsdaoda, DIALOG_STYLE_MSGBOX,"�������ֵ�","�Ƿ񵽴����ֵ�", "ȷ��", "ȡ��");
            }
            case 7:
            {
				Dialog_Show(playerid, dl_myfontsshanchu, DIALOG_STYLE_MSGBOX,"ɾ�����ֵ�","�Ƿ�ɾ�����ֵ�", "ȷ��", "ȡ��");
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
		format(tm,100,"������ֵ�%iɾ���ɹ�",listid);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
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
			Dialog_Show(playerid, dl_myfontsbiansetime, DIALOG_STYLE_INPUT,"���ñ�ɫ���","�����ü����ڱ�ɫ[1-500]", "ȷ��", "ȡ��");
	    }
	}
	return 1;
}
Dialog:dl_myfontsbiansetime(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
		if(strval(inputtext)<1||strval(inputtext)>500)return Dialog_Show(playerid, dl_myfontsbiansetime, DIALOG_STYLE_INPUT,"���ñ�ɫ���","�����ü����ڱ�ɫ", "ȷ��", "ȡ��");
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
		if(!strcmpEx("��",inputtext, false))fonts[listid][f_Dis]=1;
		else if(!strcmpEx("��",inputtext, false))fonts[listid][f_Dis]=0;
		else Dialog_Show(playerid, dl_myfontsqiangbi, DIALOG_STYLE_INPUT,"����ǽ��","������ �� ���", "ȷ��", "ȡ��");
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
		if(strval(inputtext)<0||strval(inputtext)>5)return Dialog_Show(playerid, dl_myfontsjianju, DIALOG_STYLE_INPUT,"���ļ��","��������Ҫ���ĵļ��", "ȷ��", "ȡ��");
	    if(sscanf(inputtext, "i",color))return Dialog_Show(playerid, dl_myfontsjianju, DIALOG_STYLE_INPUT,"���ļ��","��������Ҫ���ĵļ��", "ȷ��", "ȡ��");
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
			Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"����", Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
		   new tm[80];
           format(tm,80,"������ӵ�[%i]��",listitem+1);
		   Dialog_Show(playerid,dl_myfontlineadd,DIALOG_STYLE_INPUT,tm,"��������ӵ�����","ȷ��", "ȡ��");
		}
		else
		{
			new linelistid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDB",linelistid);
			new tm[80];
           	format(tm,80,"���ڱ༭��[%i]�����",listitem+1);
		   	Dialog_Show(playerid,dl_myfontlineedit,DIALOG_STYLE_INPUT,tm,"������༭������","ȷ��", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
	    {
	        P_page[playerid]--;
            Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"����", Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_myfontlineedit(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid,dl_myfontlineedit,DIALOG_STYLE_INPUT,"�������","�ַ�����,������������ӵ�����","ȷ��", "ȡ��");
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
		format(tm,100,"����[%i]��",current_number[playerid]-1);
		Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,tm,Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"����", Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
	format(tms,sizeof(tms),"{C0C0C0}���ֵ�[%i]",idx);
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
		if(strlenEx(inputtext)<3||strlenEx(inputtext)>128)return Dialog_Show(playerid,dl_myfontlineadd,DIALOG_STYLE_INPUT,"�������","�ַ����������,������������ӵ�����","ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
	    ReStr(inputtext,1,0);
	    new i=Iter_Free(fonts_line[listid]);
		if(i==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ","�����������ѵ�����", "�õ�", "");
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
		format(tm,100,"����[%i]��",current_number[playerid]-1);
		Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,tm,Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_myfontsline, DIALOG_STYLE_LIST,"����",Showmyfontlinelist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
		    strcat(tmp,"{FF8000}����µ�����");
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
