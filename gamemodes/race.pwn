stock CreateRaceDraw(playerid)
{
	pp_race[playerid][trace] = CreatePlayerTextDraw(playerid,165.000000,370.000000,"LPAS:0           ~y~CPS:0");
	PlayerTextDrawBackgroundColor(playerid,pp_race[playerid][trace],255);
	PlayerTextDrawFont(playerid,pp_race[playerid][trace],2);
	PlayerTextDrawLetterSize(playerid,pp_race[playerid][trace],0.670000,2.099999);
	PlayerTextDrawColor(playerid,pp_race[playerid][trace], -32568);
	PlayerTextDrawSetOutline(playerid,pp_race[playerid][trace], 1);
	PlayerTextDrawSetProportional(playerid,pp_race[playerid][trace], 1);
	
	Speedids[playerid] = CreatePlayerTextDraw(playerid,590.1, 370.000000, "500  500  500");
	PlayerTextDrawBackgroundColor(playerid,Speedids[playerid],255);
	PlayerTextDrawFont(playerid,Speedids[playerid],2);
	PlayerTextDrawAlignment(playerid,Speedids[playerid],2);
	PlayerTextDrawLetterSize(playerid,Speedids[playerid],0.160000, 1.400000);
	PlayerTextDrawColor(playerid,Speedids[playerid],-1);
	PlayerTextDrawSetOutline(playerid,Speedids[playerid],1);
	PlayerTextDrawSetProportional(playerid,Speedids[playerid],0);

	Preview[playerid] = CreatePlayerTextDraw(playerid, 554, 285.500000, "_");
    PlayerTextDrawFont(playerid, Preview[playerid], TEXT_DRAW_FONT_MODEL_PREVIEW);
   	PlayerTextDrawBackgroundColor(playerid,Preview[playerid], 0);
    PlayerTextDrawTextSize(playerid, Preview[playerid], 75, 40.0);
    PlayerTextDrawSetPreviewModel(playerid, Preview[playerid], 65533);
	PlayerTextDrawSetPreviewRot(playerid,Preview[playerid],-20.0, 0.0, -55.0,1.0);
	return 1;
}
stock DestoryRaceDraw(playerid)
{
	PlayerTextDrawDestroy(playerid,pp_race[playerid][trace]);
	return 1;
}
stock DestroyRaceDraw(playerid)return PlayerTextDrawDestroy(playerid,pp_race[playerid][trace]);
CMD:crace(playerid, params[], help)
{
    Dialog_Show(playerid, dl_racerom_name, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛名", "确定", "取消");
	return 1;
}
CMD:llsd(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
	foreach(new x:R_RACE)
	{
		current_idx[playerid][current_number[playerid]]=x;
		current_number[playerid]++;
		current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,世界没有赛道", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"赛道列表，共计赛道[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_llsd, DIALOG_STYLE_LIST,tm, Showracelist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
Dialog:dl_llsd(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_llsd, DIALOG_STYLE_LIST,"赛道列表", Showtelelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPlayerPosEx(playerid,R_RACE[listid][RACE_X],R_RACE[listid][RACE_Y],R_RACE[listid][RACE_Z],0.0,R_RACE[listid][RACE_IN],R_RACE[listid][RACE_WL]);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_llsd, DIALOG_STYLE_LIST,"赛道列表", Showtelelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	}
	return 1;
}
Dialog:dl_racerom_car(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new cids=strval(inputtext);
	    new i=GetPVarInt(playerid,"romid");
	    if(cids==0)RACE_ROM[i][RACE_CAR]=cids;
	    else
	    {
	        if(!IsValidVehicleModel(cids))return Dialog_Show(playerid, dl_racerom_car, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛用车ID", "确定", "取消");
			else RACE_ROM[i][RACE_CAR]=cids;
	    }
		current_number[playerid]=1;
		new current=-1;
  		foreach(new x:R_RACE)
		{
	        current_idx[playerid][current_number[playerid]]=x;
	        current_number[playerid]++;
	        current++;
		}
		if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,世界没有赛道", "好的", "");
		P_page[playerid]=1;
		new tm[100];
		format(tm,100,"赛道列表，共计赛道[%i]",current_number[playerid]-1);
		Dialog_Show(playerid, dl_racermo_create, DIALOG_STYLE_LIST,tm, Showracelist(playerid,P_page[playerid]), "确定", "取消");
	}
    else Dialog_Show(playerid, dl_racerom_car, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛用车ID", "确定", "取消");
	return 1;
}
Dialog:dl_racerom_name(playerid, response, listitem, inputtext[])
{
	if(response)
	{
    	new i=Iter_Free(RACE_ROM);
		if(i==-1)return SM(COLOR_TWAQUA, "比赛已经到到最大数");
		format(RACE_ROM[i][RACE_NAMES],100,inputtext);
		RACE_ROM[i][RACE_ID]=i;
		RACE_ROM[i][RACE_UID]=PU[playerid];
		RACE_ROM[i][RACE_STAT]=RACE_NULL;
		RACE_ROM[i][RACE_TOP]=1;
		pp_race[playerid][romid]=RACE_ROM[i][RACE_ID];
		Itter_Add(RACE_ROM,i);
		SetPVarInt(playerid,"romid",i);
		Dialog_Show(playerid, dl_racerom_car, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛用车ID", "确定", "取消");
    }
	return 1;
}
CMD:join(playerid, params[], help)
{
	current_number[playerid]=0;
	new objid[MAX_RACE_ROM],amoute[MAX_RACE_ROM][8],current=-1,idx=0;
	foreach(new i:RACE_ROM)
	{
		if(RACE_ROM[i][RACE_STAT]!=RACE_NULL)
		{
			current_idx[playerid][idx]=i;
			if(!RACE_ROM[i][RACE_CAR])objid[i]=UID[RACE_ROM[i][RACE_UID]][u_Skin];
			else objid[i]=RACE_ROM[i][RACE_CAR];
			switch(RACE_ROM[i][RACE_STAT])
			{
				case RACE_WAIT:format(amoute[idx],64,"WAITING~n~%i/%i",GRRPS(i),R_RACE[RACE_ROM[i][RACE_IDX]][RACE_PLAYERS]);
				case RACE_START:format(amoute[idx],64,"STARTED~n~%i/%i",GRRPS(i),R_RACE[RACE_ROM[i][RACE_IDX]][RACE_PLAYERS]);
				case RACE_COUNTS:format(amoute[idx],64,"COUNTING~n~%i/%i",GRRPS(i),R_RACE[RACE_ROM[i][RACE_IDX]][RACE_PLAYERS]);
			}
	       	current_number[playerid]++;
	       	current++;
	       	idx++;
       	}
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误，没有正在进行的比赛", "好的", "");
	new amouts=Iter_Count(RACE_ROM);
	new tm[100];
	format(tm,100,"~w~RACES ~r~%i/%i ",amouts,MAX_RACE_ROM);
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_RACE_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
    return 1;
}
CMD:join1(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
  	foreach(new i:RACE_ROM)
	{
        current_idx[playerid][current_number[playerid]]=i;
        current_number[playerid]++;
        current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "错误,世界没有赛道", "好的", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"比赛列表，共计比赛[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_racerom_list, DIALOG_STYLE_LIST,tm, Showraceromlist(playerid,P_page[playerid]), "确定", "取消");
    return 1;
}
stock RaceShowCp(playerid,rom,cpid1,cpid2)
{
    if(IsValidDynamicRaceCP(pp_race[playerid][pcp]))DestroyDynamicRaceCP(pp_race[playerid][pcp]);
	new romidx=RACE_ROM[rom][RACE_IDX];
	if(pp_race[playerid][laps]>=R_RACE[romidx][RACE_LAPS]&&!Itter_Contains(C_RACE[romidx],Iter_Next(C_RACE[romidx],cpid1)))
	pp_race[playerid][pcp]=CreateDynamicRaceCP(R_RACE[romidx][RACE_TYPE]+1,C_RACE[romidx][cpid1][CRACE_X],C_RACE[romidx][cpid1][CRACE_Y],C_RACE[romidx][cpid1][CRACE_Z],0.0,0.0,0.0,R_RACE[romidx][RACE_SIZE],R_RACE[romidx][RACE_WL],R_RACE[romidx][RACE_IN],playerid,5000.0);
    else
	pp_race[playerid][pcp]=CreateDynamicRaceCP(R_RACE[romidx][RACE_TYPE],C_RACE[romidx][cpid1][CRACE_X],C_RACE[romidx][cpid1][CRACE_Y],C_RACE[romidx][cpid1][CRACE_Z],C_RACE[romidx][cpid2][CRACE_X],C_RACE[romidx][cpid2][CRACE_Y],C_RACE[romidx][cpid2][CRACE_Z],R_RACE[romidx][RACE_SIZE],R_RACE[romidx][RACE_WL],R_RACE[romidx][RACE_IN],playerid,5000.0);
    return 1;
}
public OnPlayerEnterDynamicRaceCP(playerid, checkpointid)
{
	if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
	{
	    new rom=pp_race[playerid][romid];
	    new romidx=RACE_ROM[pp_race[playerid][romid]][RACE_IDX];
		if(rom!=-1)
		{
			new cps1,cps2;
			if(RACE_ROM[rom][RACE_STAT]==RACE_START)
			{
				if(R_RACE[romidx][RACE_LAPS]==1)
				{
                    cps1=pp_race[playerid][romcp]+1;
					cps2=Iter_Next(C_RACE[romidx],pp_race[playerid][romcp]+1);
					if(pp_race[playerid][romcp]==Iter_Last(C_RACE[romidx]))
					{
						new tims=GetTickCount()-pp_race[playerid][times];
		        		new	tm[128],Hour,Min,Sec,MS;
		        		ConvertTime(tims,Hour,Min,Sec,MS);
		        		format(tm,sizeof(tm),"[比赛]玩家%s[%i]在%s比赛中到达终点,耗时:%i时%i分%i秒%i毫秒[%i人小组第%i]",Gnn(playerid),playerid,RACE_ROM[rom][RACE_NAMES],Hour,Min,Sec,MS,GRRPS(rom),RACE_ROM[rom][RACE_TOP]);
						SendClientMessageToAll(0xFFFF00C8,tm);
	                    if(IsValidDynamicRaceCP(pp_race[playerid][pcp]))DestroyDynamicRaceCP(pp_race[playerid][pcp]);
						RACE_ROM[rom][RACE_TOP]++;
						new top=RaceGameEnd(playerid,romidx,tims);
						if(top!=-1)
						{
							format(tm,sizeof(tm),"[比赛]恭喜 %s 登上了赛道 %s 的排行榜 No.%i!",Gnn(playerid),R_RACE[romidx][RACE_NAME],top+1);
							SendClientMessageToAll(0xff1f88,tm);
						}
						RaceRomQuit(playerid,rom);
					}
					else
					{
	        			RaceShowCp(playerid,rom,cps1,cps2);
						pp_race[playerid][romcp]++;
						RaceTextdraw(playerid,romidx);
	        		}
				}
				else
				{
				    //printf("plap-%i,lap-%i,pcp-%i,cp-%i",pp_race[playerid][laps],R_RACE[romidx][RACE_LAPS],pp_race[playerid][romcp],(Iter_Count(C_RACE[romidx]))*R_RACE[romidx][RACE_LAPS]);
	                if(pp_race[playerid][laps]<R_RACE[romidx][RACE_LAPS])
		        	{
		        	    if(pp_race[playerid][romcp]>=Iter_Last(C_RACE[romidx]))
		        	    {
                    		cps1=Iter_First(C_RACE[romidx]);
							cps2=Iter_Next(C_RACE[romidx],cps1);
							pp_race[playerid][romcp]++;
							RaceShowCp(playerid,rom,cps1,cps2);
							RaceTextdraw(playerid,romidx);
							pp_race[playerid][romcp]=0;
							pp_race[playerid][laps]++;
						}
						else
						{
                    	    cps1=pp_race[playerid][romcp]+1;
						    cps2=Iter_Next(C_RACE[romidx],pp_race[playerid][romcp]+1);
						    if(!Itter_Contains(C_RACE[romidx],cps2))cps2=0;
				        	RaceShowCp(playerid,rom,cps1,cps2);
		        		    pp_race[playerid][romcp]++;
						    RaceTextdraw(playerid,romidx);
						}
		        	}
		        	else
		        	{
	                	if(pp_race[playerid][laps]>=R_RACE[romidx][RACE_LAPS])
		        		{
		        		    if(pp_race[playerid][romcp]>=Iter_Last(C_RACE[romidx]))
		        		    {
		        		        new tims=GetTickCount()-pp_race[playerid][times];
		        		        new	tm[128],Hour,Min,Sec,MS;
		        		        ConvertTime(tims,Hour,Min,Sec,MS);
		        		        format(tm,sizeof(tm),"[比赛]玩家%s[%i]在%s比赛中到达终点,耗时:%i时%i分%i秒%i毫秒[%i人小组第%i]",Gnn(playerid),playerid,RACE_ROM[rom][RACE_NAMES],Hour,Min,Sec,MS,GRRPS(rom),RACE_ROM[rom][RACE_TOP]);
								SendClientMessageToAll(0xFFFF00C8,tm);
	                            if(IsValidDynamicRaceCP(pp_race[playerid][pcp]))DestroyDynamicRaceCP(pp_race[playerid][pcp]);
								RACE_ROM[rom][RACE_TOP]++;
								new top=RaceGameEnd(playerid,romidx,tims);
								if(top!=-1)
								{
									format(tm,sizeof(tm),"[比赛]恭喜 %s 登上了赛道 %s 的排行榜 No.%i!",Gnn(playerid),R_RACE[romidx][RACE_NAME],top+1);
									SendClientMessageToAll(0xff1f88,tm);
								}
								RaceRomQuit(playerid,rom);
		        		    }
		        		    else
		        		    {
                    			cps1=pp_race[playerid][romcp]+1;
								cps2=Iter_Next(C_RACE[romidx],pp_race[playerid][romcp]+1);
		        		        RaceShowCp(playerid,rom,cps1,cps2);
		        		        pp_race[playerid][romcp]++;
								RaceTextdraw(playerid,romidx);
								new la=Iter_Last(C_RACE[romidx]);
								DestroyDynamicMapIcon(pp_race[playerid][pmic]);
								pp_race[playerid][pmic]=CreateDynamicMapIcon(C_RACE[romidx][la][CRACE_X],C_RACE[romidx][la][CRACE_Y],C_RACE[romidx][la][CRACE_Z],33,-1,R_RACE[romidx][RACE_WL],R_RACE[romidx][RACE_IN],playerid,2000.0,MAPICON_LOCAL);
		        		    }
		        		}
		        		else
		        		{
                    		cps1=pp_race[playerid][romcp]+1;
							cps2=Iter_Next(C_RACE[romidx],pp_race[playerid][romcp]+1);
	        		        RaceShowCp(playerid,rom,cps1,cps2);
	        		        pp_race[playerid][romcp]++;
							RaceTextdraw(playerid,romidx);
		        		}
		        	}
		        }
			}
		}
	}
	return 1;
}
stock RaceTextdraw(playerid,romidx)
{
	new tm[100];
	format(tm,100,"LPAS:%i/%i           ~y~CPS:%i/%i",pp_race[playerid][laps],R_RACE[romidx][RACE_LAPS],(Iter_Count(C_RACE[romidx]))*(pp_race[playerid][laps]-1)+pp_race[playerid][romcp],(Iter_Count(C_RACE[romidx]))*R_RACE[romidx][RACE_LAPS]);
	PlayerTextDrawSetString(playerid,pp_race[playerid][trace],tm);
	return 1;
}
stock RaceRomDelete(rom)
{
    stop RACE_ROM[rom][RACE_COUNT_TIME];
    stop RACE_ROM[rom][RACE_CHACK];
    foreach(new i:Player)
	{
	    if(pp_race[i][romid]!=-1)
	    {
	        if(pp_race[i][romid]==rom)
	        {
				if(RACE_ROM[rom][RACE_CAR]!=0)
				{
					DestroyVehicle(pp_race[i][pcar]);
					DeleteColor3DTextLabel(pp_race[i][pcartext]);
				}
				if(IsValidDynamicRaceCP(pp_race[i][pcp]))DestroyDynamicRaceCP(pp_race[i][pcp]);
				PlayerTextDrawHide(i,pp_race[i][trace]);
				pp_race[i][romid]=-1;
				pp_race[i][romcp]=0;
				pp_race[i][laps]=1;
				pp_race[i][times]=0;
	        }
        }
	}
	if(Itter_Contains(RACE_ROM,rom))
	{
	    Iter_Remove(RACE_ROM,rom);
	}
	return 1;
}
stock RaceRomQuit(playerid,rom)
{
	if(RACE_ROM[rom][RACE_CAR]!=0)
	{
		RemovePlayerFromVehicle(playerid);
		DestroyVehicle(pp_race[playerid][pcar]);
		DeleteColor3DTextLabel(pp_race[playerid][pcartext]);
	}
	if(IsValidDynamicRaceCP(pp_race[playerid][pcp]))DestroyDynamicRaceCP(pp_race[playerid][pcp]);
	if(IsValidDynamicMapIcon(pp_race[playerid][pmic]))DestroyDynamicMapIcon(pp_race[playerid][pmic]);
	PlayerTextDrawHide(playerid,pp_race[playerid][trace]);
	pp_race[playerid][romid]=-1;
	pp_race[playerid][romcp]=0;
	pp_race[playerid][laps]=1;
	pp_race[playerid][times]=0;
	if(GRRPS(rom)==0&&RACE_ROM[rom][RACE_STAT]==RACE_START)
	{
			new tm[100];
			format(tm,100,"[比赛]%s比赛结束",RACE_ROM[rom][RACE_NAMES]);
	        SendClientMessageToAll(0xff1f88,tm);
	        RaceRomDelete(rom);
	        return 1;
	}
	if(PU[playerid]==RACE_ROM[rom][RACE_UID]&&RACE_ROM[rom][RACE_STAT]!=RACE_START)
	{
			new tm[100];
			format(tm,100,"[比赛]因比赛发起者%s离开比赛,%s比赛结束",Gnn(playerid),RACE_ROM[rom][RACE_NAMES]);
	        SendClientMessageToAll(0xff1f88,tm);
	        RaceRomDelete(rom);
	        return 1;
	}
	return 1;
}
stock RaceGameEnd(playerid,race,time)
{
	new ttime,id=-1;
	for(new i=0;i<10;i++)
	{
		if(RANK_RACE[race][i][RANK_RACE_RESULT]==-1)
		{
	 		ttime=999999999;
		}
		else
 		{
  			ttime=RANK_RACE[race][i][RANK_RACE_RESULT];
 		}
		if(time<ttime)
 		{
 			id=i;
 			i=MAX_RACESS_RANK+1;
 		}
	}
	if(id==-1) return id;
	for(new i=MAX_RACESS_RANK-1;i>id;i--)
	{
	    RANK_RACE[race][i][RANK_RACE_RESULT]=RANK_RACE[race][i-1][RANK_RACE_RESULT];
		RANK_RACE[race][i][RANK_RACE_UID]=RANK_RACE[race][i-1][RANK_RACE_UID];
	}
	RANK_RACE[race][id][RANK_RACE_RESULT]=time;
	RANK_RACE[race][id][RANK_RACE_UID]=PU[playerid];
	Saveracerank(race);
	new tms[2048],tmr[100],Hour,Min,Sec,MS,ids=1;
	format(tmr,sizeof(tmr), "{FF0000}【%s】比赛地图\n{FFFFFF}〓〓〓〓〓〓成绩表〓〓〓〓〓〓\n{FFD700}",R_RACE[race][RACE_NAME]);
    strcat(tms,tmr);
	Loop(i,MAX_RACESS_RANK)
	{
	    if(RANK_RACE[race][i][RANK_RACE_UID]!=-1)
	    {
			ConvertTime(RANK_RACE[race][i][RANK_RACE_RESULT],Hour,Min,Sec,MS);
        	format(tmr, sizeof(tmr), "第%i名 - %s - 用时:%i:%i:%i\n",ids,UID[RANK_RACE[race][i][RANK_RACE_UID]][u_name],Hour,Min,Sec);
        	strcat(tms,tmr);
        	ids++;
        }
	}
	format(tmr,sizeof(tmr), "{FFFFFF}〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓\nID:%i",race);
    strcat(tms,tmr);
	UpdateColor3DTextLabelText(R_RACE[race][RACE_3D],-1,tms);
	return id;
}
stock Showraceromlist(playerid,pager)
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
		new idx=current_idx[playerid][i];
        if(i<current_number[playerid])
        {
            switch(RACE_ROM[idx][RACE_STAT])
            {
				case RACE_WAIT:
				{
					format(tmps,128,"√[%i/%i]%s[发起者:%s 赛道:%s 创建者:%s]\n",GRRPS(idx),R_RACE[RACE_ROM[idx][RACE_IDX]][RACE_PLAYERS],RACE_ROM[idx][RACE_NAMES],UID[RACE_ROM[idx][RACE_UID]][u_name],R_RACE[RACE_ROM[idx][RACE_IDX]][RACE_NAME],UID[R_RACE[RACE_ROM[idx][RACE_IDX]][RACE_UID]][u_name]);
				}
				case RACE_START:
				{
					format(tmps,128,"×[%i/%i]%s[发起者:%s 赛道:%s 创建者:%s]\n",GRRPS(idx),R_RACE[RACE_ROM[idx][RACE_IDX]][RACE_PLAYERS],RACE_ROM[idx][RACE_NAMES],UID[RACE_ROM[idx][RACE_UID]][u_name],R_RACE[RACE_ROM[idx][RACE_IDX]][RACE_NAME],UID[R_RACE[RACE_ROM[idx][RACE_IDX]][RACE_UID]][u_name]);
				}
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
Dialog:dl_racerom_list(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_racermo_create, DIALOG_STYLE_LIST,"赛道列表", Showtelelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			if(!Itter_Contains(RACE_ROM,listid))return SM(COLOR_TWAQUA,"错误比赛已不存在");
			if(pp_race[playerid][romid]!=-1) return SM(COLOR_TWAQUA, "你正在比赛中,无法使用");
            if(RACE_ROM[listid][RACE_STAT]!=RACE_WAIT) return SM(COLOR_TWAQUA, "此比赛已开始了，无法加入");
            if(GRRPS(listid)<R_RACE[RACE_ROM[listid][RACE_IDX]][RACE_PLAYERS])
            {
            	pp_race[playerid][romid]=listid;
            	new tm[128];
				format(tm,sizeof(tm),"[比赛加入]你加入了比赛%s,请耐心等待比赛开始.",RACE_ROM[listid][RACE_NAMES]);
				SM(COLOR_GAINSBORO, tm);
				format(tm,sizeof(tm),"[比赛加入]%s加入了本比赛%s,当前比赛人数%i/%i[比赛满员后将自动开始比赛]",Gnn(playerid),RACE_ROM[listid][RACE_NAMES],GRRPS(listid),R_RACE[RACE_ROM[listid][RACE_IDX]][RACE_PLAYERS]);
				SendRomMessage(listid,tm);
				if(GRRPS(listid)>=R_RACE[RACE_ROM[listid][RACE_IDX]][RACE_PLAYERS])
				{
					StartRace(listid);
				}
			}
			else
			{
				new tm[128];
				format(tm,sizeof(tm),"[对不起]你加入的比赛%s已满员，无法加入.",RACE_ROM[listid][RACE_NAMES]);
				SM(COLOR_GAINSBORO, tm);
			}
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_racermo_create, DIALOG_STYLE_LIST,"赛道列表", Showtelelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	}
	return 1;
}
CMD:joinrace(playerid, params[], help)
{
	new rid;
	if(sscanf(params, "i",rid)) return SM(COLOR_TWAQUA,"用法:/joinrace 比赛ID");
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
    return 1;
}
stock SendRomMessage(idx,msgg[])
{
	foreach(new i:Player)
	{
	    if(pp_race[i][romid]!=-1)
	    {
	        if(pp_race[i][romid]==idx)
	        {
	        	SendClientMessage(i,COLOR_ORANGE,msgg);
	        }
	    }
	}
	return 1;
}
stock GRRPS(idx)
{
    new amout=0;
	foreach(new i:Player)
	{
	    if(pp_race[i][romid]!=-1)
	    {
	        if(pp_race[i][romid]==idx)
	        {
	            amout++;
	        }
	    }
	}
	return amout;
}

stock Showracelist(playerid,pager)
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
			format(tmps,128,"[%i][%s]\n",R_RACE[current_idx[playerid][i]][RACE_ID],R_RACE[current_idx[playerid][i]][RACE_NAME]);
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
Dialog:dl_racermo_create(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_racermo_create, DIALOG_STYLE_LIST,"赛道列表", Showtelelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			new i=GetPVarInt(playerid,"romid");
			RACE_ROM[i][RACE_IDX]=listid;
			RACE_ROM[i][RACE_COUNT]=R_RACE[listid][RACE_COUNT];
			RACE_ROM[i][RACE_STAT]=RACE_WAIT;
			new tm[128];
			format(tm,sizeof(tm),"[比赛]%s发起了一个比赛%s 地图[%s],如想加入请/joinrace %i或/join查看现有比赛!",Gnn(playerid),RACE_ROM[i][RACE_NAMES],R_RACE[listid][RACE_NAME],i);
			SendClientMessageToAll(0xff1f88,tm);
			SM(COLOR_TWAQUA, "参赛者正在招募中,按鼠标中键即可开始比赛,人满也可自动开始比赛");
			if(GRRPS(pp_race[playerid][romid])>=R_RACE[RACE_ROM[pp_race[playerid][romid]][RACE_IDX]][RACE_PLAYERS])
			{
			    StartRace(pp_race[playerid][romid]);
			}
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_racermo_create, DIALOG_STYLE_LIST,"赛道列表", Showtelelist(playerid,P_page[playerid]), "确定", "上一页");
	    }
	}
	return 1;
}
stock R_onplayerkey(playerid, newkeys, oldkeys)
{
    new idx=GetPVarInt(playerid,"crid");
	new Float:xyza[4];
	new Carid=GetPlayerVehicleID(playerid);
	GetVehiclePos(Carid,xyza[0],xyza[1],xyza[2]);
	GetVehicleZAngle(Carid,xyza[3]);
	if(pstat[playerid]==EDIT_RACE_MODE_DW)
	{
     	if(PRESSED(KEY_CROUCH))
		{
            new i=Iter_Free(P_RACE[idx]);
            if(i==-1)
			{
 				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "创建赛道", "玩家出发点已完成创建,请继续创建检查点", "恩", "");
				pstat[playerid]=EDIT_RACE_MODE_CH;
			}
            if(i>=R_RACE[idx][RACE_PLAYERS])
            {
 				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "创建赛道", "玩家出发点已完成创建,请继续创建检查点", "恩", "");
				pstat[playerid]=EDIT_RACE_MODE_CH;
            }
            else
            {
                P_RACE[idx][i][PRACE_X]=xyza[0];
                P_RACE[idx][i][PRACE_Y]=xyza[1];
                P_RACE[idx][i][PRACE_Z]=xyza[2];
                P_RACE[idx][i][PRACE_A]=xyza[3];
				P_RACE[idx][i][PRACE_CP]=CreateDynamicPickup(1314,1,xyza[0],xyza[1],xyza[2],GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),playerid,5000.0);
				new tm[64];
				format(tm,64,"%i号起始点",i+1);
				P_RACE[idx][i][PRACE_3D]=CreateDynamic3DTextLabel(tm,COLOR_MAGENTA,xyza[0],xyza[1],xyza[2],300,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),playerid,5000.0);
                Iter_Add(P_RACE[idx],i);
                format(tm,64,"你创建了%i号起始点",i+1);
                SM(COLOR_ROSYBROWN, tm);
	            new x=Iter_Free(P_RACE[idx]);
	            if(x>=R_RACE[idx][RACE_PLAYERS])
				{
	 				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "创建赛道", "玩家出发点已完成创建,请继续创建检查点", "恩", "");
					pstat[playerid]=EDIT_RACE_MODE_CH;
				}
			}
	    }
     	if(PRESSED(KEY_ACTION))
		{
		    if(!Iter_Count(P_RACE[idx]))return SM(COLOR_ROSYBROWN, "你还没有创建起始点");
		    new left=Iter_Last(P_RACE[idx]);
            DestroyDynamicPickup(P_RACE[idx][left][PRACE_CP]);
            DestroyDynamic3DTextLabel(P_RACE[idx][left][PRACE_3D]);
            Iter_Remove(P_RACE[idx],left);
            new tm[64];
			format(tm,64,"你删除了%i号起始点",left+1);
			SM(COLOR_ROSYBROWN, tm);
		}
		return 1;
    }
	if(pstat[playerid]==EDIT_RACE_MODE_CH)
	{
     	if(PRESSED(KEY_CROUCH))
		{
 			new i=Iter_Free(C_RACE[idx]);
		    if(i==-1)return Dialog_Show(playerid, dl_race_wc, DIALOG_STYLE_MSGBOX, "创建检查点", "检查点已到最大数,是否完成", "是", "否");
 			C_RACE[idx][i][CRACE_X]=xyza[0];
 			C_RACE[idx][i][CRACE_Y]=xyza[1];
 			C_RACE[idx][i][CRACE_Z]=xyza[2];
 			C_RACE[idx][i][CRACE_CP]=CreateDynamicPickup(1318,1,xyza[0],xyza[1],xyza[2],GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),playerid,5000.0);
			new tm[64];
			format(tm,64,"%i号检查点",i+1);
			C_RACE[idx][i][CRACE_3D]=CreateDynamic3DTextLabel(tm,COLOR_MAGENTA,xyza[0],xyza[1],xyza[2],300,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),playerid,5000.0);
 			Iter_Add(C_RACE[idx],i);
 			format(tm,64,"你创建了%i号检查点",i+1);
 			SM(COLOR_ROSYBROWN,tm);
		    new x=Iter_Free(C_RACE[idx]);
		    if(x==-1)Dialog_Show(playerid, dl_race_wc, DIALOG_STYLE_MSGBOX, "创建检查点", "检查点已到最大数,是否完成", "是", "否");
		}
     	if(PRESSED(KEY_ACTION))
		{
		    if(!Iter_Count(C_RACE[idx]))return SM(COLOR_ROSYBROWN, "你还没有创建检查点");
		    new left=Iter_Last(C_RACE[idx]);
            DestroyDynamicPickup(C_RACE[idx][left][CRACE_CP]);
            DestroyDynamic3DTextLabel(C_RACE[idx][left][CRACE_3D]);
            Iter_Remove(C_RACE[idx],left);
            new tm[64];
			format(tm,64,"你删除了%i号检查点",left+1);
			SM(COLOR_ROSYBROWN, tm);
		}
		if(PRESSED(KEY_LOOK_LEFT))
		{
			Dialog_Show(playerid, dl_race_wc, DIALOG_STYLE_MSGBOX, "创建检查点", "是否完成", "是", "否");
		}
		return 1;
	}
    return 1;
}
stock StartRace(rom)
{
	new sps=0,tm[128],cos[2];
    cos[0]=random(255);
    cos[1]=random(255);
	foreach(new i:Player)
	{
		if(rom!=-1)
 		{
  			if(pp_race[i][romid]==rom)
    		{
				TogglePlayerControllable(i,0);
    		    if(RACE_ROM[rom][RACE_CAR]!=0)
    		    {
	    		    if(IsPlayerInAnyVehicle(i))RemovePlayerFromVehicle(i);
					SetPlayerInterior(i,R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_IN]);
					SetPlayerVirtualWorld(i,R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_WL]);
					pp_race[i][pcar]=AddStaticVehicleEx(RACE_ROM[rom][RACE_CAR],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_X],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_Y],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_Z],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_A],cos[0],cos[1],99999999);
					format(tm,sizeof(tm),"比赛%i号车",sps+1);
        			SetVehicleNumberPlate(pp_race[i][pcar],tm);
                    CarTypes[pp_race[i][pcar]]=RaceVeh;
	            	format(tm,sizeof(tm),"%s比赛用车\n%s所属\n%s",RACE_ROM[rom][RACE_NAMES],Gnn(i),VehName[GetVehicleModel(pp_race[i][pcar])-400]);
    				pp_race[i][pcartext]=CreateColor3DTextLabel(tm,COLOR_TWYELLOW,0.0,0.0,0.0,20,INVALID_PLAYER_ID,pp_race[i][pcar],1,R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_WL],R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_IN],-1,20.0,0,0);
        			LinkVehicleToInterior(pp_race[i][pcar],R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_IN]);
    				SetVehicleVirtualWorld(pp_race[i][pcar],R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_WL]);
    				PutPInVehicle(i,pp_race[i][pcar],0);
    				new romidx=RACE_ROM[rom][RACE_IDX];
    				new la=Iter_Last(C_RACE[romidx]);
    				if(R_RACE[romidx][RACE_LAPS]==1)pp_race[i][pmic]=CreateDynamicMapIcon(C_RACE[romidx][la][CRACE_X],C_RACE[romidx][la][CRACE_Y],C_RACE[romidx][la][CRACE_Z],33,-1,R_RACE[romidx][RACE_WL],R_RACE[romidx][RACE_IN],i,2000.0,MAPICON_LOCAL);
					else pp_race[i][pmic]=CreateDynamicMapIcon(C_RACE[romidx][la][CRACE_X],C_RACE[romidx][la][CRACE_Y],C_RACE[romidx][la][CRACE_Z],34,-1,R_RACE[romidx][RACE_WL],R_RACE[romidx][RACE_IN],i,2000.0,MAPICON_LOCAL);
			    }
				else
				{
				    SetPlayerPosEx(i,P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_X],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_Y],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_Z],P_RACE[RACE_ROM[rom][RACE_IDX]][sps][PRACE_A],R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_IN],R_RACE[RACE_ROM[rom][RACE_IDX]][RACE_WL],-1,1);
				}
				SetCameraBehindPlayer(i);
				sps++;
 			}
    	}
	}
	format(tm,sizeof(tm),"[比赛]%s比赛即将开始,正在倒计时!",RACE_ROM[rom][RACE_NAMES]);
	SendClientMessageToAll(0xff1f88,tm);
	RACE_ROM[rom][RACE_STAT]=RACE_COUNTS;
	RACE_ROM[rom][RACE_COUNT_TIME]=repeat RaceCount[1000](rom);
    return 1;
}
stock SetPlayerPosEx(playerid,Float:x,Float:y,Float:z,Float:a,ins,wld,home=-1,irace=0,incar=1)
{
	if(IsPlayerInAnyVehicle(playerid)&&GetPlayerVehicleSeat(playerid)==0&&incar==1)
	{
         new caid=GetPlayerVehicleID(playerid);
	     SetPPos(playerid,x+randfloatEx(0.5),y+randfloatEx(0.5),z);
	     SetPlayerFacingAngle(playerid,a);
		 SetPlayerInterior(playerid,ins);
		 SetPlayerVirtualWorld(playerid,wld);
		 SetVehiclePos(caid,x+randfloatEx(0.5),y+randfloatEx(0.5),z+3);
		 SetVehicleZAngle(caid,a);
         LinkVehicleToInterior(caid,ins);
    	 SetVehicleVirtualWorld(caid,ins);
		 PutPInVehicle(playerid,caid,0);
	}
	else
	{
		 SetPPos(playerid,x+randfloatEx(0.5),y+randfloatEx(0.5),z);
	     SetPlayerFacingAngle(playerid,a);
		 SetPlayerInterior(playerid,ins);
		 SetPlayerVirtualWorld(playerid,wld);
	}
	unpick[playerid]=false;
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid ,0);
	if(!irace)defer waitmonent1[1000](playerid,home);
    return 1;
}
timer waitmonent1[1000](playerid,home)
{
    TogglePlayerControllable(playerid ,1);
    unpick[playerid]=true;
    if(home!=-1)ppicks[playerid]=HOUSE[home][H_iPIC];
    return 1;
}

Dialog:dl_race_start(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    StartRace(pp_race[playerid][romid]);
	}
    return 1;
}
timer RaceChack[1000](rom)
{
	if(RACE_ROM[rom][RACE_STAT]==RACE_START)
	{
		if(RACE_ROM[rom][RACE_CAR]!=0)
		{
			foreach(new i:Player)
			{
		    	if(pp_race[i][romid]!=-1&&pp_race[i][romid]==rom)
		    	{
		        	new Carid=GetPlayerVehicleID(i);
		        	if(Carid!=0&&GetPlayerVehicleSeat(i)==0)
			        {
	            		if(Carid!=pp_race[i][pcar])
	            		{
							new tm[80];
	            		    if(pp_race[i][pcout]==0)
	            		    {
								format(tm,80,"你已自动弃权%s比赛",RACE_ROM[rom][RACE_NAMES]);
								SendClientMessage(i, 0xFFFFFFFF, tm);
								RaceRomQuit(i,pp_race[i][romid]);
	        					GameTextForPlayer(i,"YOU HAVE QUEIT RACE!!",3000,5);
	            		    }
							else
							{
								format(tm,80,"请返回你的比赛用车,否则视为自动弃权");
								SendClientMessage(i, 0xFFFFFFFF, tm);
		        				format(tm,80,"~r~%i",pp_race[i][pcout]);
		        				GameTextForPlayer(i,tm,2000,5);
		        				pp_race[i][pcout]--;
		        			}
	           		    }
	           		    else
	           		    {
	           		        pp_race[i][pcout]=10;
	           		    }
					}
					else
					{
						new tm[80];
	            		if(pp_race[i][pcout]==0)
	            		{
							format(tm,80,"你已自动弃权%s比赛",RACE_ROM[rom][RACE_NAMES]);
							SendClientMessage(i, 0xFFFFFFFF, tm);
							RaceRomQuit(i,pp_race[i][romid]);
	        				GameTextForPlayer(i,"YOU HAVE QUEIT RACE!!",3000,5);
	            		}
						else
						{
							format(tm,80,"请请驾驶你的比赛用车,否则视为自动弃权");
							SendClientMessage(i, 0xFFFFFFFF, tm);
		        			format(tm,80,"~r~%i",pp_race[i][pcout]);
		        			GameTextForPlayer(i,tm,2000,5);
		        			pp_race[i][pcout]--;
		        		}
					}
		    	}
			}
		}
		else
		{
        	foreach(new i:Player)
			{
		    	if(pp_race[i][romid]!=-1&&pp_race[i][romid]==rom)
		    	{
                    new Carid=GetPlayerVehicleID(i);
		        	if(Carid==0||GetPlayerVehicleSeat(i)!=0)
		        	{
						new tm[80];
            		    if(pp_race[i][pcout]==0)
            		    {
							format(tm,80,"你已自动弃权%s比赛",RACE_ROM[rom][RACE_NAMES]);
							SendClientMessage(i, 0xFFFFFFFF, tm);
							RaceRomQuit(i,pp_race[i][romid]);
        					GameTextForPlayer(i,"YOU HAVE QUEIT RACE!!",3000,5);
            		    }
						else
						{
							format(tm,80,"请驾驶汽车比赛,否则视为自动弃权");
							SendClientMessage(i, 0xFFFFFFFF, tm);
	        				format(tm,80,"~r~%i",pp_race[i][pcout]);
	        				GameTextForPlayer(i,tm,2000,5);
	        				pp_race[i][pcout]--;
	        			}
		        	}
		        	else
		        	{
		        	    pp_race[i][pcout]=10;
		        	}
		        }
			}
		}
	}
    return 1;
}
Function Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)return VectorSize(x1-x2, y1-y2, z1-z2);
timer RaceCount[1000](idx)
{
	if(RACE_ROM[idx][RACE_COUNT]==0)
	{
		foreach(new i:Player)
		{
	    	if(pp_race[i][romid]!=-1)
	    	{
	        	if(pp_race[i][romid]==idx)
	        	{
					stop RACE_ROM[idx][RACE_COUNT_TIME];
					pp_race[i][laps]=1;
					pp_race[i][romcp]=0;
					new cps1=pp_race[i][romcp];
					new cps2=Iter_Next(C_RACE[RACE_ROM[pp_race[i][romid]][RACE_IDX]],pp_race[i][romcp]);
	        		RaceShowCp(i,pp_race[i][romid],cps1,cps2);
	        		RaceTextdraw(i,RACE_ROM[idx][RACE_IDX]);
	       			PlayerTextDrawShow(i,pp_race[i][trace]);
	        		pp_race[i][times]=GetTickCount();
				    pp_race[i][pcout]=10;
				    GameTextForPlayer(i,"~b~GO~GO~GO!!!",850,3);
				    TogglePlayerControllable(i,1);
				    Streamer_Update(i);
				}
			}
		}
		RACE_ROM[idx][RACE_STAT]=RACE_START;
		RACE_ROM[idx][RACE_CHACK]=repeat RaceChack[1000](idx);
	}
	else
	{
	    new msg[16];
        format(msg,16,"~y~%i",RACE_ROM[idx][RACE_COUNT]);
		foreach(new i:Player)
		{
	    	if(pp_race[i][romid]!=-1)
	    	{
	        	if(pp_race[i][romid]==idx)
	        	{
	        		GameTextForPlayer(i,msg,850,6);
	        	}
	        }
		}
		RACE_ROM[idx][RACE_COUNT]--;
	}
	return 1;
}
Dialog:dl_race_c1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=Iter_Free(R_RACE);
	    if(i==-1)return SM(COLOR_TWAQUA, "赛道已经到到最大数");
	    R_RACE[i][RACE_ID]=i;
        format(R_RACE[i][RACE_NAME],128,inputtext);
        Dialog_Show(playerid, dl_race_c2, DIALOG_STYLE_INPUT, "创建赛道", "比赛圈数", "确定", "取消");
        Iter_Add(R_RACE,i);
		SetPVarInt(playerid,"crid",i);
	}
	return 1;
}
Dialog:dl_race_c2(playerid, response, listitem, inputtext[])
{
	new i=GetPVarInt(playerid,"crid");
	if(response)
	{
	    R_RACE[i][RACE_LAPS]=strval(inputtext);
		Dialog_Show(playerid, dl_race_c3, DIALOG_STYLE_INPUT, "创建赛道", "倒计时时间", "确定", "取消");
	}
	return 1;
}
Dialog:dl_race_c3(playerid, response, listitem, inputtext[])
{
    new i=GetPVarInt(playerid,"crid");
	if(response)
	{
	    R_RACE[i][RACE_COUNT]=strval(inputtext);
	    Dialog_Show(playerid, dl_race_c4, DIALOG_STYLE_INPUT, "创建赛道", "最大人数", "确定", "取消");
	}
	return 1;
}
Dialog:dl_race_c4(playerid, response, listitem, inputtext[])
{
    new i=GetPVarInt(playerid,"crid");
	if(response)
	{
	    R_RACE[i][RACE_PLAYERS]=strval(inputtext);
	    Dialog_Show(playerid, dl_race_c5, DIALOG_STYLE_INPUT, "创建赛道", "圈大小", "确定", "取消");
	}
	return 1;
}
Dialog:dl_race_c5(playerid, response, listitem, inputtext[])
{
    new i=GetPVarInt(playerid,"crid");
	if(response)
	{
		new Float:sizes;
		if(sscanf(inputtext, "f",sizes)) return Dialog_Show(playerid, dl_race_c5, DIALOG_STYLE_INPUT, "创建赛道", "圈大小", "确定", "取消");
	    R_RACE[i][RACE_SIZE]=sizes;
	    Dialog_Show(playerid, dl_race_c6, DIALOG_STYLE_MSGBOX, "创建赛道", "请选择赛道类型", "陆地", "空中");
	}
	return 1;
}
Dialog:dl_race_c6(playerid, response, listitem, inputtext[])
{
    new i=GetPVarInt(playerid,"crid");
	if(response)
	{
	    R_RACE[i][RACE_TYPE]=0;
	}
	else
	{
	    R_RACE[i][RACE_TYPE]=3;
	}
	new Float:xyz[3];
	GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
    R_RACE[i][RACE_X]=xyz[0];
    R_RACE[i][RACE_Y]=xyz[1];
    R_RACE[i][RACE_Z]=xyz[2];
    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "创建赛道", "请先定位人员起始点", "确定", "取消");
    pstat[playerid]=EDIT_RACE_MODE_DW;
	return 1;
}
Dialog:dl_race_wc(playerid, response, listitem, inputtext[])
{
    new idx=GetPVarInt(playerid,"crid");
	if(response)
	{
	    R_RACE[idx][RACE_WL]=GetPlayerVirtualWorld(playerid);
	    R_RACE[idx][RACE_IN]=GetPlayerInterior(playerid);
	    SavedRACEdata(idx);
	    foreach(new i:P_RACE[idx])
		{
            DestroyDynamicPickup(P_RACE[idx][i][PRACE_CP]);
            DestroyDynamic3DTextLabel(P_RACE[idx][i][PRACE_3D]);
		}
	    Saveraceplayers(idx);
	    foreach(new i:C_RACE[idx])
		{
            DestroyDynamicPickup(C_RACE[idx][i][CRACE_CP]);
            DestroyDynamic3DTextLabel(C_RACE[idx][i][CRACE_3D]);
		}
	    Saveracechack(idx);
		for(new t=0;t<MAX_RACESS_RANK;t++)
    	{
    		RANK_RACE[idx][t][RANK_RACE_UID]=-1;
    		RANK_RACE[idx][t][RANK_RACE_RESULT]=-1;
    	}
    	new tms[2048];
    	format(tms,sizeof(tms), "{FF0000}【%s】比赛地图\n{FFFFFF}〓〓〓〓〓〓成绩表〓〓〓〓〓〓\n{FFD700}暂无\n{FFFFFF}〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓\nID:%i",R_RACE[idx][RACE_NAME],idx);
		R_RACE[idx][RACE_3D]=CreateColor3DTextLabel(tms,-1,R_RACE[idx][RACE_X],R_RACE[idx][RACE_Y],R_RACE[idx][RACE_Z],30,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,R_RACE[idx][RACE_WL],R_RACE[idx][RACE_IN],-1,30.0,0,0);
		R_RACE[idx][RACE_MIC]=CreateDynamicMapIcon(R_RACE[idx][RACE_X],R_RACE[idx][RACE_Y],R_RACE[idx][RACE_Z],53,-1,R_RACE[idx][RACE_WL],R_RACE[idx][RACE_IN],-1,100.0,MAPICON_LOCAL);
		R_RACE[idx][RACE_PICK]=CreateDynamicCP(R_RACE[idx][RACE_X],R_RACE[idx][RACE_Y],R_RACE[idx][RACE_Z],4,R_RACE[idx][RACE_WL],R_RACE[idx][RACE_IN],-1,100.0);
		pstat[playerid]=NO_MODE;
	}
	return 1;
}
stock ConvertTime(Milliseconds,&rHour,&rMin,&rS,&rMS )
{
	rHour			=	Milliseconds 	/ 	3600000;
	Milliseconds	-=	rHour			*	3600000;
	rMin			=	Milliseconds 	/ 	60000;
	Milliseconds	-=	rMin			*	60000;
	rS				=	Milliseconds	/	1000;
	Milliseconds	-=	rS				*	1000;
	rMS				=	Milliseconds;
}
stock ConvertTime2(Min,&rDay,&rHour,&rMin)
{
	rDay			=	Min 	/ 	1440;
	Min				-=	rDay			*	1440;
	rHour			=	Min	/	60;
	Min				-=	rHour			*	60;
	rMin			=	Min;
}
Function Saveracerank(idx)
{
	new str[738];
    if(fexist(Get_Path(idx,14)))fremove(Get_Path(idx,14));
	new File:NameFile = fopen(Get_Path(idx,14), io_write);
    LoopEx(i,0,MAX_RACESS_RANK)
	{
		if(RANK_RACE[idx][i][RANK_RACE_RESULT]!=-1)
		{
			format(str,sizeof(str),"%s %i %i\r\n",str,RANK_RACE[idx][i][RANK_RACE_UID],RANK_RACE[idx][i][RANK_RACE_RESULT]);
		}
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}
stock Loadracerank(idx)
{
    for(new t=0;t<MAX_RACESS_RANK;t++)
    {
    	RANK_RACE[idx][t][RANK_RACE_UID]=-1;
    	RANK_RACE[idx][t][RANK_RACE_RESULT]=-1;
    }
	new tm1[100],tms[2048],tmr[100],Hour,Min,Sec,MS,ids=0;
	format(tmr,sizeof(tmr), "{FF0000}【%s】比赛地图\n{FFFFFF}〓〓〓〓〓〓成绩表〓〓〓〓〓〓\n{FFD700}",R_RACE[idx][RACE_NAME]);
	strcat(tms,tmr);
    if(fexist(Get_Path(idx,14)))
    {
		new File:NameFile = fopen(Get_Path(idx,14), io_read);
    	if(NameFile)
	   	{
        	while(fread(NameFile, tm1))
        	{
         	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_RACESS_RANK)
	        	    {
		        		sscanf(tm1, "ii",RANK_RACE[idx][ids][RANK_RACE_UID],RANK_RACE[idx][ids][RANK_RACE_RESULT]);
						ConvertTime(RANK_RACE[idx][ids][RANK_RACE_RESULT],Hour,Min,Sec,MS);
		        		format(tmr, sizeof(tmr), "第%i名 - %s - 用时:%i:%i:%i\n",ids+1,UID[RANK_RACE[idx][ids][RANK_RACE_UID]][u_name],Hour,Min,Sec);
		        		strcat(tms,tmr);
		        		ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
    if(ids==0)
    {
		format(tmr,sizeof(tmr), "暂无\n");
    	strcat(tms,tmr);
    }
	format(tmr,sizeof(tmr), "{FFFFFF}〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓\nID:%i",idx);
    strcat(tms,tmr);
	R_RACE[idx][RACE_3D]=R_RACE[idx][RACE_3D]=CreateColor3DTextLabel(tms,-1,R_RACE[idx][RACE_X],R_RACE[idx][RACE_Y],R_RACE[idx][RACE_Z],30,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,R_RACE[idx][RACE_WL],R_RACE[idx][RACE_IN],-1,30.0,0,0);
	return 1;
}
Function Saveraceplayers(idx)
{
	new str[738];
    if(fexist(Get_Path(idx,12)))fremove(Get_Path(idx,12));
	new File:NameFile = fopen(Get_Path(idx,12), io_write);
    foreach(new i:P_RACE[idx])
  	{
		format(str,sizeof(str),"%s %f %f %f %f\r\n",str,P_RACE[idx][i][PRACE_X],P_RACE[idx][i][PRACE_Y],P_RACE[idx][i][PRACE_Z],P_RACE[idx][i][PRACE_A]);
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}
stock Loadraceplayers(idx)
{
	new tm1[100];
    if(fexist(Get_Path(idx,12)))
    {
		new File:NameFile = fopen(Get_Path(idx,12), io_read);
    	if(NameFile)
    	{
    	    new ids=0;
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_RACESS_PLAYERS)
	        	    {
        				sscanf(tm1, "ffff",P_RACE[idx][ids][PRACE_X],P_RACE[idx][ids][PRACE_Y],P_RACE[idx][ids][PRACE_Z],P_RACE[idx][ids][PRACE_A]);
	    				Iter_Add(P_RACE[idx],ids);
        				ids++;
        		    }
				}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
Function Saveracechack(idx)
{
	new str[738];
    if(fexist(Get_Path(idx,13)))fremove(Get_Path(idx,13));
	new File:NameFile = fopen(Get_Path(idx,13), io_write);
    foreach(new i:C_RACE[idx])
  	{
		format(str,sizeof(str),"%s %f %f %f\r\n",str,C_RACE[idx][i][CRACE_X],C_RACE[idx][i][CRACE_Y],C_RACE[idx][i][CRACE_Z]);
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}
stock Loadracechack(idx)
{
	new tm1[100];
    if(fexist(Get_Path(idx,13)))
    {
		new File:NameFile = fopen(Get_Path(idx,13), io_read);
    	if(NameFile)
    	{
    	    new ids=0;
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_RACESS_CHACK)
	        	    {
		        		sscanf(tm1, "fff",C_RACE[idx][ids][CRACE_X],C_RACE[idx][ids][CRACE_Y],C_RACE[idx][ids][CRACE_Z]);
			    		Iter_Add(C_RACE[idx],ids);
		        		ids++;
        		    }
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
Function LoadRACE_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_RACESS)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,11), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,11), "LoadRACEData", false, true, i, true, false);
            R_RACE[i][RACE_ID]=i;
            Loadraceplayers(i);
            Loadracechack(i);
            Loadracerank(i);
			R_RACE[i][RACE_MIC]=CreateDynamicMapIcon(R_RACE[i][RACE_X],R_RACE[i][RACE_Y],R_RACE[i][RACE_Z],53,-1,R_RACE[i][RACE_WL],R_RACE[i][RACE_IN],-1,20.0,MAPICON_LOCAL);
			R_RACE[i][RACE_PICK]=CreateDynamicCP(R_RACE[i][RACE_X],R_RACE[i][RACE_Y],R_RACE[i][RACE_Z],4,R_RACE[i][RACE_WL],R_RACE[i][RACE_IN],-1,20.0);
 			Iter_Add(R_RACE,i);
 			idx++;
        }
    }
    return idx;
}
Function LoadRACEData(i, name[], value[])
{
    INI_String("RACE_NAME",R_RACE[i][RACE_NAME],100);
    INI_Int("RACE_PLAYERS",R_RACE[i][RACE_PLAYERS]);
    INI_Int("RACE_COUNT",R_RACE[i][RACE_COUNT]);
    INI_Int("RACE_MONEY",R_RACE[i][RACE_MONEY]);
    INI_Int("RACE_TYPE",R_RACE[i][RACE_TYPE]);
    INI_Int("RACE_IN",R_RACE[i][RACE_IN]);
    INI_Int("RACE_LAPS",R_RACE[i][RACE_LAPS]);
    INI_Int("RACE_WL",R_RACE[i][RACE_WL]);
    INI_Int("RACE_SCORE",R_RACE[i][RACE_SCORE]);
    INI_Int("RACE_UID",R_RACE[i][RACE_UID]);
    INI_Float("RACE_SIZE",R_RACE[i][RACE_SIZE]);
    INI_Float("RACE_X",R_RACE[i][RACE_X]);
    INI_Float("RACE_Y",R_RACE[i][RACE_Y]);
    INI_Float("RACE_Z",R_RACE[i][RACE_Z]);
	return 1;
}
Function SavedRACEdata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,11));
    INI_WriteString(File,"RACE_NAME",R_RACE[Count][RACE_NAME]);
    INI_WriteInt(File,"RACE_PLAYERS",R_RACE[Count][RACE_PLAYERS]);
    INI_WriteInt(File,"RACE_COUNT",R_RACE[Count][RACE_COUNT]);
    INI_WriteInt(File, "RACE_MONEY",R_RACE[Count][RACE_MONEY]);
    INI_WriteInt(File, "RACE_TYPE",R_RACE[Count][RACE_TYPE]);
    INI_WriteInt(File, "RACE_LAPS",R_RACE[Count][RACE_LAPS]);
    INI_WriteInt(File, "RACE_IN",R_RACE[Count][RACE_IN]);
    INI_WriteInt(File, "RACE_WL",R_RACE[Count][RACE_WL]);
    INI_WriteInt(File, "RACE_SCORE",R_RACE[Count][RACE_SCORE]);
    INI_WriteInt(File, "RACE_UID",R_RACE[Count][RACE_UID]);
    INI_WriteFloat(File, "RACE_SIZE",R_RACE[Count][RACE_SIZE]);
    INI_WriteFloat(File, "RACE_X",R_RACE[Count][RACE_X]);
    INI_WriteFloat(File, "RACE_Y",R_RACE[Count][RACE_Y]);
    INI_WriteFloat(File, "RACE_Z",R_RACE[Count][RACE_Z]);
    INI_Close(File);
	return true;
}
CMD:startmap(playerid, params[], help)
{
	new mid;
	if(sscanf(params, "i",mid)) return SM(COLOR_TWAQUA,"用法:/startmap 地图ID");
	if(!Itter_Contains(R_RACE,mid))return SM(COLOR_TWAQUA,"错误:比赛地图不存在");
    new i=Iter_Free(RACE_ROM);
	if(i==-1)return SM(COLOR_TWAQUA, "比赛已经到到最大数");
	RACE_ROM[i][RACE_IDX]=mid;
	RACE_ROM[i][RACE_ID]=i;
	RACE_ROM[i][RACE_UID]=PU[playerid];
	RACE_ROM[i][RACE_STAT]=RACE_NULL;
	RACE_ROM[i][RACE_COUNT]=R_RACE[mid][RACE_COUNT];
	RACE_ROM[i][RACE_TOP]=1;
	pp_race[playerid][romid]=i;
	Itter_Add(RACE_ROM,i);
	SetPVarInt(playerid,"romid",i);
    Dialog_Show(playerid, dl_racerom_nameEx, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛名", "确定", "取消");
	return 1;
}
Dialog:dl_racerom_nameEx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new i=GetPVarInt(playerid,"romid");
	    format(RACE_ROM[i][RACE_NAMES],100,inputtext);
	    Dialog_Show(playerid, dl_racerom_carEx, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛用车ID", "确定", "取消");
	}
	else return Dialog_Show(playerid, dl_racerom_nameEx, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛名", "确定", "取消");
	return 1;
}
Dialog:dl_racerom_carEx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new cids=strval(inputtext);
	    new i=GetPVarInt(playerid,"romid");
	    if(cids==0)RACE_ROM[i][RACE_CAR]=cids;
	    else
	    {
	        if(!IsValidVehicleModel(cids))return Dialog_Show(playerid, dl_racerom_car, DIALOG_STYLE_INPUT, "汽车ID错误", "请输入比赛用车ID", "确定", "取消");
			else RACE_ROM[i][RACE_CAR]=cids;
	    }
		new tm[128];
		RACE_ROM[i][RACE_STAT]=RACE_WAIT;
		format(tm,sizeof(tm),"[比赛]%s发起了一个比赛%s 地图[%s],如想加入请/joinrace %i或/join查看现有比赛!",Gnn(playerid),RACE_ROM[i][RACE_NAMES],R_RACE[RACE_ROM[i][RACE_IDX]][RACE_NAME],i);
		SendClientMessageToAll(0xff1f88,tm);
	    SM(COLOR_TWAQUA, "参赛者正在招募中,按鼠标中键即可开始比赛,人满也可自动开始比赛");
		if(GRRPS(pp_race[playerid][romid])>=R_RACE[RACE_ROM[pp_race[playerid][romid]][RACE_IDX]][RACE_PLAYERS])
		{
			StartRace(pp_race[playerid][romid]);
		}
	}
	else return Dialog_Show(playerid, dl_racerom_carEx, DIALOG_STYLE_INPUT, "创建比赛", "请输入比赛用车ID", "确定", "取消");
	return 1;
}
