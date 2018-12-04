Function Loadhouse_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_HOUSE)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,1), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,1), "LoadhouseData", false, true, i, true, false);
            LoadDynamicObjectsFrom(i);
            //printf("%i",LoadDynamicObjectsFrom(i));
			CreateHouse(i);
  			Iter_Add(HOUSE,i);
 			idx++;
        }
    }
    return idx;
}
stock CreateHouse(idx)
{
    HOUSE[idx][H_ID]=idx;
	new tm[100];
	switch(HOUSE[idx][H_isSEL])
	{
	    case NONEONE:
		{
			format(tm,100,"%s\nδ���۷���\n�ۼ�:$%i\nID:%i",HOUSE[idx][H_NAMES],HOUSE[idx][H_Value],idx);
			HOUSE[idx][H_MIC]=CreateDynamicMapIcon(HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ],31,-1,HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,500.0,MAPICON_LOCAL);
			HOUSE[idx][H_oPIC]=CreateDynamicPickup(1273,1,HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ],HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,100.0);
		}
	    case OWNERS:
		{
			format(tm,100,"%s\n����:%s\nID:%i",HOUSE[idx][H_NAMES],UID[HOUSE[idx][H_UID]][u_name],idx);
			HOUSE[idx][H_MIC]=CreateDynamicMapIcon(HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ],32,-1,HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,500.0,MAPICON_LOCAL);
			HOUSE[idx][H_oPIC]=CreateDynamicPickup(1272,1,HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ],HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,100.0);
		}
		case SELLING:
		{
			format(tm,100,"ת����\n%s\n����:%s\n�ۼ�:$%i\nID:%i",HOUSE[idx][H_NAMES],UID[HOUSE[idx][H_UID]][u_name],HOUSE[idx][H_Value],idx);
			HOUSE[idx][H_MIC]=CreateDynamicMapIcon(HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ],HOUSE[idx][H_isSEL]+31,-1,HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,500.0,MAPICON_LOCAL);
			HOUSE[idx][H_oPIC]=CreateDynamicPickup(1274,1,HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ],HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,100.0);
		}
	}
	HOUSE[idx][H_3D]=CreateColor3DTextLabel(tm,-1,HOUSE[idx][H_oX],HOUSE[idx][H_oY],HOUSE[idx][H_oZ]-0.1,20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,HOUSE[idx][H_oWL],HOUSE[idx][H_oIN],-1,20.0,HOUSE[idx][H_isCOL],1);
	HOUSE[idx][H_3DI]=CreateColor3DTextLabel("����",-1,HOUSE[idx][H_iX],HOUSE[idx][H_iY],HOUSE[idx][H_iZ]-0.1,20,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,HOUSE[idx][H_iWL],HOUSE[idx][H_iIN],-1,20.0,HOUSE[idx][H_isCOL],1);
	HOUSE[idx][H_iPIC]=CreateDynamicPickup(1318,1,HOUSE[idx][H_iX],HOUSE[idx][H_iY],HOUSE[idx][H_iZ],HOUSE[idx][H_iWL],HOUSE[idx][H_iIN],-1,50.0);
	return 1;
}
timer isinrang[800](playerid)
{
	if(IsPlayerInRangeOfPoint(playerid,8,318.2561,1488.9417,1106.3176))OnPlayerCheat(playerid,Ffdt_Garbage);
	new tm[100];
	ffdt[ff_did]=fjjdaoju[Iter_Random(fjjdaoju)][fjj_did];
	ffdt[ff_pick]=CreateDynamicPickup(Daoju[ffdt[ff_did]][d_obj],1,318.2561,1488.9417,1106.3176,0,0);
	ffdt[ff_amout]++;
	if(ffdt[ff_amout]>=ffdt[ff_max]+1)
	{
		format(tm,sizeof(tm),"�Ҿ߷������,���ҵ�����ɢȥ��");
		AnnounceWarn(tm);
		ffdtopen=0;
		if(IsValidDynamicPickup(ffdt[ff_pick]))DestroyDynamicPickup(ffdt[ff_pick]);
		DestroyDynamic3DTextLabel(ffdt[ff_3d1]);
		DestroyDynamic3DTextLabel(ffdt[ff_3d2]);
	}
	else
	{
		format(tm,sizeof(tm),"�ۼƼҾ߷���:%i��",ffdt[ff_amout]);
		if(IsValidDynamic3DTextLabel(ffdt[ff_3d1]))UpdateDynamic3DTextLabelText(ffdt[ff_3d1],-1,tm);
		format(tm,sizeof(tm),"�Ҿ���:%s",Daoju[ffdt[ff_did]][d_name]);
		if(IsValidDynamic3DTextLabel(ffdt[ff_3d2]))UpdateDynamic3DTextLabelText(ffdt[ff_3d2],-1,tm);
		if(!ffdtopen)DestroyDynamicPickup(ffdt[ff_pick]);
	}
	return 1;
}
Dialog:dl_guaji(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new idx=GetPVarInt(playerid,"listA");
		if(guaji[idx][g_playerid]!=-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","�Ĺһ����ѱ���ռ��", "��", "");
	    SetPPos(playerid,guaji[idx][g_xx],guaji[idx][g_yy],guaji[idx][g_zz]);
	    SetPlayerFacingAngle(playerid,346.5033);
		SetPlayerInterior(playerid,0);
		SetPlayerVirtualWorld(playerid,0);
        guaji[idx][g_playerid]=playerid;
        pstat[playerid]=GUAJI;
		new tm[100];
		format(tm,100,"%i�Źһ�λ\nÿ����$%i\nռλ��:%s",idx,guaji[idx][g_level]*1000,Gn(guaji[idx][g_playerid]));
        UpdateDynamic3DTextLabelText(guaji[idx][g_text],-1,tm);
        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","���ѿ�ʼ�һ�", "��", "");
        TogglePlayerControllable(playerid ,0);
        SetCameraBehindPlayer(playerid);
	}
	return 1;
}
Dialog:dl_tcguajia(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		pstat[playerid]=NO_MODE;
		Loop(s,3)
		{
			if(guaji[s][g_playerid]==playerid)
			{
				new tm[100];
				format(tm,100,"%i�Źһ�λ\nÿ����$%i\n��ǰ����",s,guaji[s][g_level]*1000);
	        	UpdateDynamic3DTextLabelText(guaji[s][g_text],-1,tm);
				guaji[s][g_playerid]=-1;
			}
		}
		TogglePlayerControllable(playerid ,1);
		SM(0x00FFFFC8,"�����˳��һ�!");
	}
	return 1;
}
public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(IsPlayerNPC(playerid))return 1;
    if(pstat[playerid]!=GUAJI)
    {
		Loop(s,3)
		{
		    if(guaji[s][g_picks]==pickupid)
		    {
		        if(guaji[s][g_playerid]==-1)
		        {
		            new tm[100];
					format(tm,100,"��ǰ%i��λ�һ����λ,�ùһ���ÿ����$%i,�Ƿ�ʼ�һ�",s,guaji[s][g_level]*1000);
					SetPVarInt(playerid,"listA",s);
		            Dialog_Show(playerid,dl_guaji, DIALOG_STYLE_MSGBOX,"�һ�λ",tm, "�һ�", "ȡ��");
		            return 1;
		        }
		    }
		}
	}
    if(ffdtopen)
    {
	    if(pickupid==ffdt[ff_pick])
	    {
	    	if(!IsPlayerInAnyVehicle(playerid))
	    	{
				if(GetadminLevel(playerid)<1)
	   			{
			    	new tm[100];
					format(tm,100,"��ϲ��,�õ���%s,�ѷ��뱳��",Daoju[ffdt[ff_did]][d_name]);
					SM(COLOR_TWTAN, tm);
			        Addbeibao(playerid,ffdt[ff_did],1);
			        DestroyDynamicPickup(ffdt[ff_pick]);
			        format(tm,100,"��ϲ%s��ȡ���˼Ҿ�%s,���ڷ���%i���Ҿ�",Gn(playerid),Daoju[ffdt[ff_did]][d_name],ffdt[ff_amout]+1);
			        AnnounceWarn(tm);
			        new Float:ran=randfloat(2);
					SetPlayerPos(playerid,317.8049+ran,1553.0446+ran,1100.3053+ran);
					defer isinrang[800](playerid);
				}
			}
	    }
    }
	if(unpick[playerid])
	{
		if(ppicks[playerid]!=-1)
		{
			ppicks[playerid]=-1;
			return 1;
		}
	  	foreach(new i:HOUSE)
		{
		    if(pickupid==HOUSE[i][H_iPIC])
		    {
		        SetPlayerPosEx(playerid,HOUSE[i][H_oX],HOUSE[i][H_oY],HOUSE[i][H_oZ],HOUSE[i][H_oA],HOUSE[i][H_oIN],HOUSE[i][H_oWL],i,0,0);
		        return 1;
		    }
		    if(pickupid==HOUSE[i][H_oPIC])
			{
			    new tm[100];
			    switch(HOUSE[i][H_isSEL])
				{
	    			case NONEONE:
					{
				        format(tm,100,"��%s����ID:%i�ۼ�$%i,�Ƿ���",HOUSE[i][H_NAMES],i,HOUSE[i][H_Value]);
				    	Dialog_Show(playerid,dl_buyhouse, DIALOG_STYLE_MSGBOX,"������",tm, "����", "����");
				    	SetPVarInt(playerid,"houseid",i);
					}
					case OWNERS:
					{
						if(HOUSE[i][H_LOCK]==1&&HOUSE[i][H_UID]!=PU[playerid])
				    	{
							format(tm,100,"%s��%s����ID:%i������",UID[HOUSE[i][H_UID]][u_name],HOUSE[i][H_NAMES],i);
							SM(COLOR_TWTAN, tm);
				    	}
				    	else
				    	{
							SetPlayerPosEx(playerid,HOUSE[i][H_iX],HOUSE[i][H_iY],HOUSE[i][H_iZ],HOUSE[i][H_iA],HOUSE[i][H_iIN],HOUSE[i][H_iWL],i,0,0);
							if(HOUSE[i][H_UID]==PU[playerid])format(tm,100,"��ӭ�ص���ķ���",i);
							else format(tm,100,"�������%i�ŷ���%s ����:%s",i,HOUSE[i][H_NAMES],UID[HOUSE[i][H_UID]][u_name]);
							SM(COLOR_TWTAN, tm);
							if(HOUSE[i][H_ISMUSIC]&&!IsServerMusic())PlayAudioStreamForPlayer(playerid,HOUSE[i][H_MUSIC]);
				    	}
					}
					case SELLING:
					{
					    if(HOUSE[i][H_UID]!=PU[playerid])
					    {
				        	format(tm,100,"%s��%s����ID:%i�ۼ�$%i,�Ƿ���",UID[HOUSE[i][H_UID]][u_name],HOUSE[i][H_NAMES],i,HOUSE[i][H_Value]);
				    		Dialog_Show(playerid,dl_buyplayerhouse, DIALOG_STYLE_MSGBOX,"������",tm, "����", "����");
				    		SetPVarInt(playerid,"houseid",i);
				    	}
				    	else
				    	{
							SetPlayerPosEx(playerid,HOUSE[i][H_iX],HOUSE[i][H_iY],HOUSE[i][H_iZ],HOUSE[i][H_iA],HOUSE[i][H_iIN],HOUSE[i][H_iWL],i,0,0);
							if(HOUSE[i][H_UID]==PU[playerid])format(tm,100,"��ӭ�ص���ķ���",i);
							else format(tm,100,"�������%i�ŷ���",i);
							SM(COLOR_TWTAN, tm);
							if(HOUSE[i][H_ISMUSIC]&&!IsServerMusic())PlayAudioStreamForPlayer(playerid,HOUSE[i][H_MUSIC]);
				    	}
					}
				}
				return 1;
			}
		}
	}
	return 1;
}
stock Showhouseinfo(idx)
{
	new Astr[512],Str[64];
	format(Str, sizeof(Str), "����[%s]\n",HOUSE[idx][H_NAMES]);
	strcat(Astr,Str);
	if(HOUSE[idx][H_LOCK])format(Str, sizeof(Str), "����[��]\n");
	else format(Str, sizeof(Str), "����[��]\n");
	strcat(Astr,Str);
	if(HOUSE[idx][H_isCOL])format(Str, sizeof(Str), "��ɫ[��]\n");
	else format(Str, sizeof(Str), "��ɫ[��]\n");
	strcat(Astr,Str);
	if(HOUSE[idx][H_INTIDX]==-1)format(Str, sizeof(Str), "��ǰװ��[�Զ���]\n");
	else format(Str, sizeof(Str), "��ǰװ��[%s]\n",INT[HOUSE[idx][H_INTIDX]][I_NAME]);
	strcat(Astr,Str);
	if(HOUSE[idx][H_PROS]==1)format(Str, sizeof(Str), "�Ҿ߱���[��]\n");
	else format(Str, sizeof(Str), "�Ҿ߱���[��]\n");
	strcat(Astr,Str);
	if(HOUSE[idx][H_ISMUSIC]==1)format(Str, sizeof(Str), "��������[��]\n");
	else format(Str, sizeof(Str), "��������[��]\n");
	strcat(Astr,Str);
	switch(HOUSE[idx][H_isSEL])
	{
	    case OWNERS:format(Str, sizeof(Str), "����[δ]\n");
	    case SELLING:format(Str, sizeof(Str), "����[$%i]\n",HOUSE[idx][H_Value]);
	}
	strcat(Astr,Str);
	format(Str, sizeof(Str), "����");
	strcat(Astr,Str);
	return Astr;
}
Dialog:dl_buyint(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_buyint, DIALOG_STYLE_LIST,"����", ShowintlistEx(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_buyint2,DIALOG_STYLE_MSGBOX,"����ѡ��","Ԥ��ģʽ��H���ɹ���װ��","Ԥ��/����", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_buyint, DIALOG_STYLE_LIST,"����", ShowintlistEx(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
timer backhouse[5000](playerid,houseid)
{
	if(pstat[playerid]==EDIT_INT)
	{
		SetPlayerPosEx(playerid,HOUSE[houseid][H_iX],HOUSE[houseid][H_iY],HOUSE[houseid][H_iZ],HOUSE[houseid][H_iA],HOUSE[houseid][H_iIN],HOUSE[houseid][H_iWL],houseid,0,0);
		pstat[playerid]=NO_MODE;
    }
}
Dialog:dl_buyint2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new idx=GetPVarInt(playerid,"houseid");
	    new intt=GetPVarInt(playerid,"listIDA");
	    pstat[playerid]=EDIT_INT;
		SetPlayerPosEx(playerid,INT[intt][I_X],INT[intt][I_Y],INT[intt][I_Z],HOUSE[idx][H_iA],INT[intt][I_IN],HOUSE[idx][H_iWL],-1,0,0);
		defer backhouse[15000](playerid,idx);
		SM(COLOR_TWTAN,""#H_ME"15�밴N�����ɹ���");
	}
	return 1;
}
Dialog:dl_sethousemusic(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new text[128];
		if(sscanf(inputtext, "s[128]",text))return Dialog_Show(playerid, dl_sethousemusic, DIALOG_STYLE_INPUT, "��������", "��������������", "ȷ��", "ȡ��");
	    new idx=GetPVarInt(playerid,"houseid");
		HOUSE[idx][H_ISMUSIC]=1;
	    format(HOUSE[idx][H_MUSIC],128,text);
		Savedhousedata(idx);
		new	tm[100];
		format(tm,100,"����ID:%i����",idx);
    	Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
	}
	return 1;
}
stock Isownhouse(playerid)
{
    if(HOUSE[GetPlayerVirtualWorld(playerid)-500][H_isSEL]!=NONEONE&&HOUSE[GetPlayerVirtualWorld(playerid)-500][H_UID]==PU[playerid])return 1;
	return 0;
}
stock Ishousepro(playerid)
{
	if(GetPlayerVirtualWorld(playerid)-500<1)return 0;
	if(GetPlayerVirtualWorld(playerid)-500>1000)return 0;
    if(Isownhouse(playerid))return 0;
    else if(HOUSE[GetPlayerVirtualWorld(playerid)-500][H_PROS])return 1;
	return 0;
}
Dialog:dl_edithouse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new idx=GetPVarInt(playerid,"houseid");
	    if(IsFZselling(idx))return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����,�׹������ڳ��۴˷���,�����¼�����", "�õ�", "");
        switch(listitem)
        {
            case 0:
			{
				Dialog_Show(playerid, dl_sethousename, DIALOG_STYLE_INPUT, "��������", "����������", "ȷ��", "ȡ��");
			}
            case 1:
			{
				if(HOUSE[idx][H_LOCK])HOUSE[idx][H_LOCK]=0;
				else HOUSE[idx][H_LOCK]=1;
				Savedhousedata(idx);
				new tm[100];
    			format(tm,100,"����ID:%i����",idx);
    			Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
			}
            case 2:
			{
				if(HOUSE[idx][H_isCOL])HOUSE[idx][H_isCOL]=0;
				else HOUSE[idx][H_isCOL]=1;
			 	DelHouse(idx);
				CreateHouse(idx);
				Savedhousedata(idx);
				new tm[100];
    			format(tm,100,"����ID:%i����",idx);
    			Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
			}
            case 3:
			{
				current_number[playerid]=1;
				foreach(new i:INT)
				{
					current_idx[playerid][current_number[playerid]]=i;
			       	current_number[playerid]++;
				}
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"���������б�-����[%i]",current_number[playerid]-1);
				Dialog_Show(playerid, dl_buyint, DIALOG_STYLE_LIST,tm, ShowintlistEx(playerid,P_page[playerid]), "ȷ��", "ȡ��");
			}
            case 4:
			{
                if(HOUSE[idx][H_PROS])HOUSE[idx][H_PROS]=0;
                else HOUSE[idx][H_PROS]=1;
                Savedhousedata(idx);
				new tm[100];
    			format(tm,100,"����ID:%i����",idx);
    			Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
			}
            case 5:
			{
                if(HOUSE[idx][H_ISMUSIC])
				{
					HOUSE[idx][H_ISMUSIC]=0;
					Savedhousedata(idx);
					new tm[100];
	    			format(tm,100,"����ID:%i����",idx);
	    			Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
				}
                else Dialog_Show(playerid, dl_sethousemusic, DIALOG_STYLE_INPUT, "��������", "��������������", "ȷ��", "ȡ��");
			}
            case 6:
			{
			    if(HOUSE[idx][H_isSEL]==OWNERS)
				{
					Dialog_Show(playerid, dl_sellhouse, DIALOG_STYLE_INPUT, "�����ۼ�", "�������ۼ�", "ȷ��", "ȡ��");
				}
			    else
				{
					HOUSE[idx][H_isSEL]=OWNERS;
				 	DelHouse(idx);
					CreateHouse(idx);
					Savedhousedata(idx);
					new tm[100];
	    			format(tm,100,"����ID:%i����",idx);
	    			Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
				}
			}
            case 7:
			{
				new tm[100];
    			format(tm,100,"/sellhouse %i",idx);
			    CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,tm);
			}
		}
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_sethousename(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new text[100];
	    ReStr(inputtext);
		if(sscanf(inputtext, "s[100]",text))return Dialog_Show(playerid, dl_sethousename, DIALOG_STYLE_INPUT, "��������", "����������", "ȷ��", "ȡ��");
	    new idx=GetPVarInt(playerid,"houseid");
	    format(HOUSE[idx][H_NAMES],100,text);
 	    DelHouse(idx);
		CreateHouse(idx);
		Savedhousedata(idx);
		new	tm[100];
		format(tm,100,"����ID:%i����",idx);
    	Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_sethousename, DIALOG_STYLE_INPUT, "��������", "���ƹ���,����������", "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_sellhouse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_sellhouse, DIALOG_STYLE_INPUT, "�����ۼ�", "�������ۼۣ�����0", "ȷ��", "ȡ��");
	    if(strval(inputtext)>100000000)return Dialog_Show(playerid, dl_sellhouse, DIALOG_STYLE_INPUT, "�����ۼ�", "�������ۼ�,���ܳ���һ��", "ȷ��", "ȡ��");
	    new idx=GetPVarInt(playerid,"houseid");
		HOUSE[idx][H_isSEL]=SELLING;
	    HOUSE[idx][H_Value]=strval(inputtext);
 	    DelHouse(idx);
		CreateHouse(idx);
		Savedhousedata(idx);
		new	tm[100];
		format(tm,100,"����ID:%i����",idx);
    	Dialog_Show(playerid,dl_edithouse, DIALOG_STYLE_LIST,tm,Showhouseinfo(idx), "ѡ��", "ȡ��");
	}
	else Dialog_Show(playerid, dl_sellhouse, DIALOG_STYLE_INPUT, "�޸�������", "������", "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_buyplayerhouse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(getplayerhouse(PU[playerid])>=3)return SM(COLOR_TWTAN,"���Ѿ�����3��������");
	    if(UID[PU[playerid]][u_Score]<200)return SM(COLOR_TWTAN,"��Ļ��ֲ���200,����");
	    if(HOUSE[GetPVarInt(playerid,"houseid")][H_isSEL]==OWNERS)return SM(COLOR_TWAQUA,"�÷����ѱ�����");
	    EnoughMoney(playerid,HOUSE[GetPVarInt(playerid,"houseid")][H_Value]);
		Moneyhandle(PU[playerid],-HOUSE[GetPVarInt(playerid,"houseid")][H_Value]);
		Moneyhandle(HOUSE[GetPVarInt(playerid,"houseid")][H_UID],HOUSE[GetPVarInt(playerid,"houseid")][H_Value]);
		HOUSE[GetPVarInt(playerid,"houseid")][H_UID]=PU[playerid];
        HOUSE[GetPVarInt(playerid,"houseid")][H_isSEL]=1;
        DelHouse(GetPVarInt(playerid,"houseid"));
		CreateHouse(GetPVarInt(playerid,"houseid"));
		Savedhousedata(GetPVarInt(playerid,"houseid"));
		DeletePVar(playerid,"houseid");
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}
Dialog:dl_buyhouse(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(getplayerhouse(PU[playerid])>=3)return SM(COLOR_TWTAN,"���Ѿ�����3��������");
	    if(UID[PU[playerid]][u_Score]<200)return SM(COLOR_TWTAN,"��Ļ��ֲ���200,����");
	    if(HOUSE[GetPVarInt(playerid,"houseid")][H_isSEL]==OWNERS)return SM(COLOR_TWAQUA,"�÷����ѱ�����");
	    EnoughMoney(playerid,HOUSE[GetPVarInt(playerid,"houseid")][H_Value]);
		Moneyhandle(PU[playerid],-HOUSE[GetPVarInt(playerid,"houseid")][H_Value]);
		HOUSE[GetPVarInt(playerid,"houseid")][H_UID]=PU[playerid];
        HOUSE[GetPVarInt(playerid,"houseid")][H_isSEL]=OWNERS;
        DelHouse(GetPVarInt(playerid,"houseid"));
		CreateHouse(GetPVarInt(playerid,"houseid"));
		Savedhousedata(GetPVarInt(playerid,"houseid"));
		DeletePVar(playerid,"houseid");
	}
	else DeletePVar(playerid,"houseid");
	return 1;
}

stock DelHouse(idx)
{
	DeleteColor3DTextLabel(HOUSE[idx][H_3D]);
	DestroyDynamicMapIcon(HOUSE[idx][H_MIC]);
	DestroyDynamicPickup(HOUSE[idx][H_iPIC]);
	DestroyDynamicPickup(HOUSE[idx][H_oPIC]);
	DeleteColor3DTextLabel(HOUSE[idx][H_3DI]);
	return 1;
}
Function LoadhouseData(i, name[], value[])
{
    INI_String("H_NAMES",HOUSE[i][H_NAMES],100);
    INI_Int("H_UID",HOUSE[i][H_UID]);
    INI_Int("H_iIN",HOUSE[i][H_iIN]);
    INI_Int("H_iWL",HOUSE[i][H_iWL]);
    INI_Int("H_oIN",HOUSE[i][H_oIN]);
    INI_Int("H_oWL",HOUSE[i][H_oWL]);
    INI_Float("H_iX",HOUSE[i][H_iX]);
    INI_Float("H_iY",HOUSE[i][H_iY]);
    INI_Float("H_iZ",HOUSE[i][H_iZ]);
    INI_Float("H_iA",HOUSE[i][H_iA]);
    INI_Float("H_oX",HOUSE[i][H_oX]);
    INI_Float("H_oY",HOUSE[i][H_oY]);
    INI_Float("H_oZ",HOUSE[i][H_oZ]);
    INI_Float("H_oA",HOUSE[i][H_oA]);
    INI_Int("H_isCOL",HOUSE[i][H_isCOL]);
    INI_Int("H_isSEL",HOUSE[i][H_isSEL]);
    INI_Int("H_INTIDX",HOUSE[i][H_INTIDX]);
    INI_Int("H_LOCK",HOUSE[i][H_LOCK]);
    INI_Int("H_Value",HOUSE[i][H_Value]);
    INI_Int("H_PROS",HOUSE[i][H_PROS]);
    INI_Int("H_ISMUSIC",HOUSE[i][H_ISMUSIC]);
    INI_String("H_MUSIC",HOUSE[i][H_MUSIC],128);
	return 1;
}
/*#define ho_FILE "����/houses.txt"
ReadPropertyFile()
{
	new  File:file_ptr,
	    tmp[128],
		buf[256],
		idx,
		Float:enX,
		Float:enY,
		Float:enZ,
		Float:enA,
		uniqIntId,
		p_type,
		pIcon,
		ids=0;
	file_ptr = fopen(ho_FILE,io_read );

	if(!file_ptr )return 0;

 	while( fread( file_ptr, buf, 256 ) > 0)
	 {
 	    idx = 0;

 	    idx = token_by_delim( buf, tmp, ',', idx );
		if(idx == (-1)) continue;
		pIcon = strval( tmp );

 	    idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		HOUSE[ids][H_oX] = floatstr( tmp );

  		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		HOUSE[ids][H_oY] = floatstr( tmp );

		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		HOUSE[ids][H_oZ] = floatstr( tmp );

 		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		HOUSE[ids][H_oA] = floatstr( tmp );

		idx = token_by_delim( buf, tmp, ',', idx+1 );
		if(idx == (-1)) continue;
		uniqIntId = strval( tmp );

		idx = token_by_delim( buf, tmp, ';', idx+1 );
		if(idx == (-1)) continue;
		p_type = strval( tmp );
		
		HOUSE[ids][H_UID]=-1;
		format(HOUSE[ids][H_NAMES],100,"δ����");
		HOUSE[ids][H_isSEL]=NONEONE;
		HOUSE[ids][H_INTIDX]=34;
        HOUSE[ids][H_iX]=INT[34][I_X];
        HOUSE[ids][H_iY]=INT[34][I_Y];
        HOUSE[ids][H_iZ]=INT[34][I_Z];
		HOUSE[ids][H_iIN]=INT[34][I_IN];
		HOUSE[ids][H_isCOL]=0;
		HOUSE[ids][H_LOCK]=0;
		HOUSE[ids][H_iWL]=500+ids;
		HOUSE[ids][H_Value]=random(100000);
		Savedhousedata(ids);
        ids++;
	}
	fclose( file_ptr );
	return 1;
}*/
Function Savedhousedata(Count)
{
    new INI:File = INI_Open(Get_Path(Count,1));
    INI_WriteString(File,"H_NAMES",HOUSE[Count][H_NAMES]);
    INI_WriteInt(File,"H_UID",HOUSE[Count][H_UID]);
    INI_WriteInt(File,"H_iIN",HOUSE[Count][H_iIN]);
    INI_WriteInt(File,"H_iWL",HOUSE[Count][H_iWL]);
    INI_WriteInt(File,"H_oIN",HOUSE[Count][H_oIN]);
    INI_WriteInt(File,"H_oWL",HOUSE[Count][H_oWL]);
    INI_WriteFloat(File,"H_iX",HOUSE[Count][H_iX]);
    INI_WriteFloat(File,"H_iY",HOUSE[Count][H_iY]);
    INI_WriteFloat(File,"H_iZ",HOUSE[Count][H_iZ]);
    INI_WriteFloat(File,"H_iA",HOUSE[Count][H_iA]);
    INI_WriteFloat(File,"H_oX",HOUSE[Count][H_oX]);
    INI_WriteFloat(File,"H_oY",HOUSE[Count][H_oY]);
    INI_WriteFloat(File,"H_oZ",HOUSE[Count][H_oZ]);
    INI_WriteFloat(File,"H_oA",HOUSE[Count][H_oA]);
    INI_WriteInt(File,"H_isCOL",HOUSE[Count][H_isCOL]);
    INI_WriteInt(File,"H_isSEL",HOUSE[Count][H_isSEL]);
    INI_WriteInt(File,"H_INTIDX",HOUSE[Count][H_INTIDX]);
    INI_WriteInt(File,"H_LOCK",HOUSE[Count][H_LOCK]);
    INI_WriteInt(File,"H_Value",HOUSE[Count][H_Value]);
    INI_WriteInt(File,"H_PROS",HOUSE[Count][H_PROS]);
    INI_WriteInt(File,"H_ISMUSIC",HOUSE[Count][H_ISMUSIC]);
    INI_WriteString(File,"H_MUSIC",HOUSE[Count][H_MUSIC]);
    INI_Close(File);
	return true;
}
CMD:wdfz(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
  	foreach(new i:HOUSE)
	{
	    if(HOUSE[i][H_isSEL]!=NONEONE&&HOUSE[i][H_UID]==PU[playerid])
	    {
	        current_idx[playerid][current_number[playerid]]=i;
	        current_number[playerid]++;
	        current++;
        }
	}
	if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��û�з���", "��", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�ҵķ���-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_myhouse, DIALOG_STYLE_LIST,tm, Showmyhouselist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_myhouse(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_myhouse,DIALOG_STYLE_LIST,"�ҵķ���",Showmyhouselist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPlayerPosEx(playerid,HOUSE[listid][H_iX],HOUSE[listid][H_iY],HOUSE[listid][H_iZ],HOUSE[listid][H_iA],HOUSE[listid][H_iIN],HOUSE[listid][H_iWL],listid,0,0);
			new tm[100];
			format(tm,100,"�㵽������ķ���[%s]ID:%i\n�ڷ����ڲ���N������������ķ���",HOUSE[listid][H_NAMES],listid);
			SM(COLOR_TWAQUA,tm);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_myhouse,DIALOG_STYLE_LIST,"�ҵķ���",Showmyhouselist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock Showmyhouselist(playerid,pager)
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
 			switch(HOUSE[current_idx[playerid][i]][H_isSEL])
			{
				case OWNERS:format(tmps,100,"[��ӵ��]����ID:%i - %s\n",current_idx[playerid][i],HOUSE[current_idx[playerid][i]][H_NAMES]);
				case SELLING:format(tmps,100,"[ת����]����ID:%i - %s - �ۼ�:$%i\n",current_idx[playerid][i],HOUSE[current_idx[playerid][i]][H_NAMES],HOUSE[current_idx[playerid][i]][H_Value]);
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
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
CMD:llfz(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
  	foreach(new X:HOUSE)
	{
        current_idx[playerid][current_number[playerid]]=X;
        current_number[playerid]++;
        current++;
	}
	if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��ʱû�з���", "ȷ��", "ȡ��");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�����б�-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_allhouse, DIALOG_STYLE_TABLIST_HEADERS,tm, Showallhouselist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_allhouse(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_allhouse,DIALOG_STYLE_TABLIST_HEADERS,"�����б�",Showallhouselist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPlayerPosEx(playerid,HOUSE[listid][H_oX],HOUSE[listid][H_oY],HOUSE[listid][H_oZ],HOUSE[listid][H_oA],HOUSE[listid][H_oIN],HOUSE[listid][H_oWL],listid,0,0);
			new tmps[100];
			format(tmps, sizeof(tmps),"%s���͵���%i�ŷ���[%s]  /gh %i ",Gnn(playerid),listid,HOUSE[listid][H_NAMES],listid);
		 	SendMessageToAll(COLOR_PALETURQUOISE,tmps);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_allhouse,DIALOG_STYLE_TABLIST_HEADERS,"�����б�",Showallhouselist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock Showallhouselist(playerid,pager)
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
	format(tmp,4128, "״̬\t����ID\t����\t�ۼ�\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
        new tmps[100];
        if(i<current_number[playerid])
        {
 			switch(HOUSE[current_idx[playerid][i]][H_isSEL])
			{
				case NONEONE:format(tmps,100,"[δ����]\t%i\t����\t$%i\n",current_idx[playerid][i],HOUSE[current_idx[playerid][i]][H_Value]);
				case OWNERS:format(tmps,100,"[�ѳ���]\t%i\t%s\t\n",current_idx[playerid][i],UID[HOUSE[current_idx[playerid][i]][H_UID]][u_name]);
				case SELLING:format(tmps,100,"[ת����]\t%i\t%s\t$%i\n",current_idx[playerid][i],UID[HOUSE[current_idx[playerid][i]][H_UID]][u_name],HOUSE[current_idx[playerid][i]][H_Value]);
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
    	strcat(tmp, "\t{FF8000}��һҳ\n");
    }
    return tmp;
}
CMD:gh(playerid, params[], help)
{
	new pid;
	if(sscanf(params, "i",pid))return SM(COLOR_TWAQUA,"�÷�:/gh ����ID");
	if(!Iter_Contains(HOUSE,pid))return SM(COLOR_TWAQUA,"û�д˷���");
	SetPlayerPosEx(playerid,HOUSE[pid][H_oX],HOUSE[pid][H_oY],HOUSE[pid][H_oZ],HOUSE[pid][H_oA],HOUSE[pid][H_oIN],HOUSE[pid][H_oWL],pid,0,0);
	new tmps[100];
	format(tmps, sizeof(tmps),"%s���͵���%i�ŷ���[%s]  /gh %i ",Gnn(playerid),pid,HOUSE[pid][H_NAMES],pid);
 	SendMessageToAll(COLOR_PALETURQUOISE,tmps);
	return 1;
}
stock TogglePlayerDynamicObject(playerid,toggle=0)
{
	Streamer_UpdateEx(playerid,0.0,0.0,-50000.0);
	Streamer_ToggleItemUpdate(playerid,STREAMER_TYPE_OBJECT,toggle);
	return 1;
}
Dialog:dl_allintlist(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_allintlist,DIALOG_STYLE_LIST,"�����б�",Showallintlist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
    		new i=Iter_Free(HOUSE);
    		if(i==-1)return SM(COLOR_TWAQUA,"�����ѵ�����");
			new Float:xyza[4];
			GetPlayerPos(playerid,xyza[0],xyza[1],xyza[2]);
			GetPlayerFacingAngle(playerid,xyza[3]);
			HOUSE[i][H_oX]=xyza[0];
			HOUSE[i][H_oY]=xyza[1];
			HOUSE[i][H_oZ]=xyza[2];
			HOUSE[i][H_oA]=xyza[3];
			HOUSE[i][H_isSEL]=NONEONE;
			format(HOUSE[i][H_NAMES],100,"δ����");
			HOUSE[i][H_oIN]=GetPlayerInterior(playerid);
			HOUSE[i][H_oWL]=GetPlayerVirtualWorld(playerid);
			HOUSE[i][H_isCOL]=0;
			HOUSE[i][H_UID]=-1;
			HOUSE[i][H_INTIDX]=listid;
			HOUSE[i][H_iX]=INT[listid][I_X];
			HOUSE[i][H_iY]=INT[listid][I_Y];
			HOUSE[i][H_iZ]=INT[listid][I_Z];
			HOUSE[i][H_iA]=0.0;
			HOUSE[i][H_iIN]=INT[listid][I_IN];
			HOUSE[i][H_iWL]=500+i;
			HOUSE[i][H_LOCK]=0;
			HOUSE[i][H_Value]=GetPVarInt(playerid,"hcash");
   			CreateHouse(i);
 			Savedhousedata(i);
   			Iter_Add(HOUSE,i);
   			DeletePVar(playerid,"hcash");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_allintlist,DIALOG_STYLE_LIST,"�����б�",Showallintlist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock Showallintlist(playerid,pager)
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
			format(tmps,100,"[ID:%i]������:%s - �������\n",INT[current_idx[playerid][i]][I_IDX],INT[current_idx[playerid][i]][I_NAME]);
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
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
int_Dialog_Show(listid)
{
	new tmps[512],tmp[100];
	format(tmp,100,"ID:%i\n",listid);
	strcat(tmps,tmp);
	format(tmp,100,"����:%s\n",INT[listid][I_NAME]);
	strcat(tmps,tmp);
	format(tmp,100,"X:%f\n",INT[listid][I_X]);
	strcat(tmps,tmp);
	format(tmp,100,"Y:%f\n",INT[listid][I_Y]);
	strcat(tmps,tmp);
	format(tmp,100,"Z:%f\n",INT[listid][I_Z]);
	strcat(tmps,tmp);
	format(tmp,100,"����ID:%i\n",INT[listid][I_IN]);
	strcat(tmps,tmp);
	format(tmp,100,"ɾ��");
	strcat(tmps,tmp);
	return tmps;
}
Dialog:dl_intname(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new name[128];
		ReColor(inputtext);
		if(sscanf(inputtext, "s[100]",name))return Dialog_Show(playerid, dl_intname, DIALOG_STYLE_INPUT, "�޸�������", "������", "ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
        if(strlenEx(name)<1)return Dialog_Show(playerid, dl_intname, DIALOG_STYLE_INPUT, "�޸�������", "������", "ȷ��", "ȡ��");
        format(INT[listid][I_NAME],100,name);
	 	SaveINT(listid);
	 	Dialog_Show(playerid,dl_editint,DIALOG_STYLE_LIST,"��������",int_Dialog_Show(listid),"ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_intx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new Float:xxx;
		ReColor(inputtext);
		if(sscanf(inputtext, "f",xxx))return Dialog_Show(playerid, dl_intx, DIALOG_STYLE_INPUT, "�޸�����X", "������", "ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
        INT[listid][I_X]=xxx;
	 	SaveINT(listid);
	 	Dialog_Show(playerid,dl_editint,DIALOG_STYLE_LIST,"��������",int_Dialog_Show(listid),"ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_inty(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new Float:xxx;
		ReColor(inputtext);
		if(sscanf(inputtext, "f",xxx))return Dialog_Show(playerid, dl_intx, DIALOG_STYLE_INPUT, "�޸�����Y", "������", "ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
        INT[listid][I_Y]=xxx;
	 	SaveINT(listid);
	 	Dialog_Show(playerid,dl_editint,DIALOG_STYLE_LIST,"��������",int_Dialog_Show(listid),"ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_intz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new Float:xxx;
		ReColor(inputtext);
		if(sscanf(inputtext, "i",xxx))return Dialog_Show(playerid, dl_intz, DIALOG_STYLE_INPUT, "�޸�����Z", "������", "ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
        INT[listid][I_Z]=xxx;
	 	SaveINT(listid);
	 	Dialog_Show(playerid,dl_editint,DIALOG_STYLE_LIST,"��������",int_Dialog_Show(listid),"ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_intid(playerid, response, listitem, inputtext[])
{
	if(response)
	{
        new xxx;
		ReColor(inputtext);
		if(sscanf(inputtext, "i",xxx))return Dialog_Show(playerid, dl_intid, DIALOG_STYLE_INPUT, "�޸�����ID", "������", "ȷ��", "ȡ��");
	    new listid=GetPVarInt(playerid,"listIDA");
        INT[listid][I_IN]=xxx;
	 	SaveINT(listid);
	 	Dialog_Show(playerid,dl_editint,DIALOG_STYLE_LIST,"��������",int_Dialog_Show(listid),"ѡ��", "ȡ��");
	}
	return 1;
}
Dialog:dl_editint(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new listid=GetPVarInt(playerid,"listIDA");
		switch(listitem)
		{
			case 1:
			{
				Dialog_Show(playerid, dl_intname, DIALOG_STYLE_INPUT, "�޸�������", "������", "ȷ��", "ȡ��");
			}
            case 2:
            {
				Dialog_Show(playerid, dl_intx, DIALOG_STYLE_INPUT, "�޸�����X", "������", "ȷ��", "ȡ��");
            }
            case 3:
            {
				Dialog_Show(playerid, dl_inty, DIALOG_STYLE_INPUT, "�޸�����Y", "������", "ȷ��", "ȡ��");
            }
            case 4:
            {
				Dialog_Show(playerid, dl_intz, DIALOG_STYLE_INPUT, "�޸�����Z", "������", "ȷ��", "ȡ��");
            }
            case 5:
            {
				Dialog_Show(playerid, dl_intid, DIALOG_STYLE_INPUT, "�޸�����ID", "������", "ȷ��", "ȡ��");
            }
            case 6:
            {
				new tm[100];
				format(tm,100,"����%i[%s]ɾ���ɹ�",listid,INT[listid][I_NAME]);
				Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ",tm, "�õ�", "");
				Iter_Remove(INT,listid);
				SaveINT(listid);
				CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/addint");
            }
		}
	}
	return 1;
}
stock ShowintlistEx(playerid,pager)
{
    new tmp[1028];
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
			format(tmps,100,"[ID:%i]������:%s - �������\n",INT[current_idx[playerid][i]][I_IDX],INT[current_idx[playerid][i]][I_NAME]);
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
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
stock Showintlist(playerid,pager)
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
			format(tmps,100,"[ID:%i]������:%s - �������\n",INT[current_idx[playerid][i]][I_IDX],INT[current_idx[playerid][i]][I_NAME]);
		}
	    if(i>=current_number[playerid])
		{
		    format(tmps,100,"{FF8000}����µ�����");
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
Dialog:dl_intlist(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid, dl_intlist, DIALOG_STYLE_LIST,"����", Showintlist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
	   	else if(listitem+page==current_number[playerid])
		{
			new i=Iter_Free(INT);
			if(i==-1)return SM(COLOR_ORANGE,"���������Ѵﵽ����");
			Dialog_Show(playerid, dl_cint, DIALOG_STYLE_INPUT, "��������", "������ [������] [X] [Y] [Z] [����ID]", "����", "ȡ��");
		}
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			Dialog_Show(playerid,dl_editint,DIALOG_STYLE_LIST,"��������",int_Dialog_Show(listid),"ѡ��", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_intlist, DIALOG_STYLE_LIST,"����", Showintlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_cint(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		ReColor(inputtext);
	    new iname[100],Float:xyza[3],ints;
		if(sscanf(inputtext, "s[100]fffi",iname,xyza[0],xyza[1],xyza[2],ints))return Dialog_Show(playerid, dl_cint, DIALOG_STYLE_INPUT, "��������", "������ [������] [X] [Y] [Z] [����ID]", "����", "ȡ��");
        if(strlenEx(iname)<1)return Dialog_Show(playerid, dl_cint, DIALOG_STYLE_INPUT, "��������", "������ [������] [X] [Y] [Z] [����ID]", "����", "ȡ��");
	    new i=Iter_Free(INT);
	    if(i==-1)return SM(COLOR_TWAQUA,"�����ѵ�����");
	    format(INT[i][I_NAME],100,iname);
		INT[i][I_X]=xyza[0];
		INT[i][I_Y]=xyza[1];
		INT[i][I_Z]=xyza[2];
		INT[i][I_IN]=ints;
		Iter_Add(INT,i);
		SaveINT(i);
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/addint");
	}
	return 1;
}
stock LoadINT()
{
	new File:file_ptr,buf[256],tmp[64],idx,uniqId,isx=0;
	file_ptr = fopen(INT_FILE, io_read );
	if( file_ptr )
	{
		while( fread( file_ptr, buf, 256 ) > 0)
		{
		    idx = 0;

     		idx = token_by_delim( buf, tmp, ' ', idx );
			if(idx == (-1)) continue;
			uniqId = strval( tmp );
            INT[uniqId][I_IDX]=uniqId;
			if( uniqId >= MAX_INT) return 0;

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
		 	INT[uniqId][I_IN] = strval( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
			INT[uniqId][I_X] = floatstr( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;
			INT[uniqId][I_Y] = floatstr( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1);
		    if(idx == (-1)) continue;
			INT[uniqId][I_Z] = floatstr( tmp );

			idx = token_by_delim( buf, tmp, ' ', idx+1 );
		    if(idx == (-1)) continue;


			idx = token_by_delim( buf,INT[uniqId][I_NAME], ';', idx+1 );
		    if(idx == (-1)) continue;
            Iter_Add(INT,uniqId);
            isx++;
		}
		fclose( file_ptr );
		return 1;
	}
	return isx;
}
/*stock LoadINT()
{
    new ids=0;
    if(fexist(INT_FILE))
    {
		new File:NameFile = fopen(INT_FILE, io_read);
    	if(NameFile)
    	{
    	    new tm1[100];
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
        	        if(ids<MAX_INT)
	        	    {
		        		sscanf(tm1, "p<,>s[100]fffi",INT[ids][I_NAME],INT[ids][I_X],INT[ids][I_Y],INT[ids][I_Z],INT[ids][I_IN]);
		        		INT[ids][I_IDX]=ids;
			    		Iter_Add(INT,ids);
		        		ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return ids;
}*/
Function SaveINT(idx)
{
/*	new str[738];
    if(fexist(INT_FILE))fremove(INT_FILE);
	new File:NameFile = fopen(INT_FILE, io_write);
    foreach(new i:INT)
  	{
		format(str,sizeof(str),"%s %s,%f,%f,%f,%i\r\n",str,INT[i][I_NAME],INT[i][I_X],INT[i][I_Y],INT[i][I_Z],INT[i][I_IN]);
	}
	fwrite(NameFile,str);
    fclose(NameFile);*/
	return 1;
}
stock reloadhobj(idx)
{
    foreach(new i:HOBJ[idx])
	{
		if(IsValidDynamicObject(HOBJ[idx][i][HO_ID]))DestroyDynamicObject(HOBJ[idx][i][HO_ID]);
	}
	Iter_Clear(HOBJ[idx]);
	LoadDynamicObjectsFrom(idx);
	return 1;
}
stock LoadDynamicObjectsFrom(idx)
{
	new loaded=0;
    if(fexist(Get_Path(idx,17)))
    {
		new string[512],index,var_from_line[64],modelid,Float:fX,Float:fY,Float:fZ,Float:fRadius,txd1[32],txd2[32],type,indexes,color;
		new File:example = fopen(Get_Path(idx,17), io_read);
		if(example)
		{
			while(fread(example, string) > 0)
			{
			    switch(IsObjectCode(string))
			    {
			        case 1:
			        {
						if(ClearLine(string,1))
						{
						    if(Iter_Count(HOBJ[idx])<MAX_HOUSE_OBJ)
						    {
								index = 0;
								index = token_by_delim(string,var_from_line,',',index);HOBJ[idx][loaded][HO_MODEL]=strval(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_X]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_Y]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_Z]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_RX]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_RY]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_RZ]= floatstr(var_from_line);
								HOBJ[idx][loaded][HO_WL]=-1;
								HOBJ[idx][loaded][HO_IN]=-1;
								HOBJ[idx][loaded][HO_STRDIS]=300.0;
								HOBJ[idx][loaded][HO_DRADIS]=0.0;
								HOBJ[idx][loaded][HO_ID]=CreateDynamicObject(HOBJ[idx][loaded][HO_MODEL],HOBJ[idx][loaded][HO_X],HOBJ[idx][loaded][HO_Y],HOBJ[idx][loaded][HO_Z],HOBJ[idx][loaded][HO_RX],HOBJ[idx][loaded][HO_RY],HOBJ[idx][loaded][HO_RZ],HOBJ[idx][loaded][HO_WL],HOBJ[idx][loaded][HO_IN],-1,HOBJ[idx][loaded][HO_STRDIS],HOBJ[idx][loaded][HO_DRADIS]);
			                    Iter_Add(HOBJ[idx],loaded);
								loaded++;
							}
						}
					}
					case 2:
					{
						if(ClearLine(string,2))
						{
						    if(Iter_Count(HOBJ[idx])<MAX_HOUSE_OBJ)
						    {
								index = 0;
								index = token_by_delim(string,var_from_line,',',index);HOBJ[idx][loaded][HO_MODEL]=strval(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_X]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_Y]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_Z]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_RX]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_RY]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);HOBJ[idx][loaded][HO_RZ]= floatstr(var_from_line);
								HOBJ[idx][loaded][HO_WL]=-1;
								HOBJ[idx][loaded][HO_IN]=-1;
								HOBJ[idx][loaded][HO_STRDIS]=300.0;
								HOBJ[idx][loaded][HO_DRADIS]=0.0;
								HOBJ[idx][loaded][HO_ID]=CreateDynamicObject(HOBJ[idx][loaded][HO_MODEL],HOBJ[idx][loaded][HO_X],HOBJ[idx][loaded][HO_Y],HOBJ[idx][loaded][HO_Z],HOBJ[idx][loaded][HO_RX],HOBJ[idx][loaded][HO_RY],HOBJ[idx][loaded][HO_RZ],HOBJ[idx][loaded][HO_WL],HOBJ[idx][loaded][HO_IN],-1,HOBJ[idx][loaded][HO_STRDIS],HOBJ[idx][loaded][HO_DRADIS]);
			                    Iter_Add(HOBJ[idx],loaded);
								loaded++;
							}
						}
					}
					case 3:
					{
						if(ClearLine(string,3))
						{
							index = 0;
							index = token_by_delim(string,var_from_line,',',index);modelid=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);fX= floatstr(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);fY= floatstr(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);fZ= floatstr(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);fRadius= floatstr(var_from_line);
							RemoveBuild(AddRemoveBuilding(modelid,fX,fY,fZ,fRadius));
						}
					}
					case 4:
					{
						if(ClearLine(string,4))
						{
							index = 0;
							index = token_by_delim(string,var_from_line,',',index);type=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);indexes=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);modelid=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);
							format(txd1,32,var_from_line);
							strdel(txd1,0,1);
							new idc=strlen(txd1);
							strdel(txd1,idc-1,idc);
							index = token_by_delim(string,var_from_line,',',index+1);
							format(txd2,32,var_from_line);
							strdel(txd2,0,1);
							idc=strlen(txd2);
							strdel(txd2,idc-1,idc);
							index = token_by_delim(string,var_from_line,',',index+1);color=strval(var_from_line);
							if(type==1)
							{
							    foreach(new t:HOBJ[idx])SetDynamicObjectMaterial(HOBJ[idx][t][HO_ID],indexes,modelid,txd1,txd2,color);
							}
							else SetDynamicObjectMaterial(SOBJ[idx][Iter_Last(SOBJ[idx])][SO_ID],indexes,modelid,txd1,txd2,color);
						}
					}
					case 5:
					{
						if(ClearLine(string,5))
						{
							index = 0;
							index = token_by_delim(string,var_from_line,',',index);type=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);indexes=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);modelid=strval(var_from_line);
							index = token_by_delim(string,var_from_line,',',index+1);
							format(txd1,32,var_from_line);
							strdel(txd1,0,1);
							new idc=strlen(txd1);
							strdel(txd1,idc-1,idc);
							index = token_by_delim(string,var_from_line,',',index+1);
							format(txd2,32,var_from_line);
							strdel(txd2,0,1);
							idc=strlen(txd2);
							strdel(txd2,idc-1,idc);
							index = token_by_delim(string,var_from_line,',',index+1);color=strval(var_from_line);
							if(type==1)
							{
							    foreach(new t:HOBJ[idx])SetDynamicObjectMaterial(HOBJ[idx][t][HO_ID],indexes,modelid,txd1,txd2,color);
							}
							else SetDynamicObjectMaterial(SOBJ[idx][Iter_Last(SOBJ[idx])][SO_ID],indexes,modelid,txd1,txd2,color);
						}
					}
				}
			}
		}
		fclose(example);
	}
	return loaded;
}
Function IsObjectCode(line[])
{
	if(strfind(line,"CreateDynamicObject", false)!=-1)return 1;
	if(strfind(line,"CreateObject",false)!=-1)return 2;
	if(strfind(line,"RemoveBuildingForPlayer",false)!=-1)return 3;
	if(strfind(line,"SetObjectMaterial",false)!=-1)return 4;
	if(strfind(line,"SetDynamicObjectMaterial",false)!=-1)return 5;
	return 0;
}
stock ClearLine(line[],type)
{
	if(type==1)strdel(line, 0, 20);
	if(type==2)strdel(line, 0, 13);
	if(type==3)strdel(line, 0, 33);
	if(type==4)strdel(line, 0, 18);
	if(type==5)strdel(line, 0, 25);
	return 1;
}
CMD:kzfz(playerid, params[], help)
{
	current_number[playerid]=1;
	new current=-1;
  	foreach(new X:HOUSE)
	{
	    if(HOUSE[X][H_isSEL]!=OWNERS)
	    {
	        current_idx[playerid][current_number[playerid]]=X;
	        current_number[playerid]++;
	        current++;
        }
	}
	if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��ʱû�п��÷��ӻ���۷���", "Ŷ", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"���÷���/���۷���-����[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_kzfz, DIALOG_STYLE_LIST,tm, Shokzfzlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_kzfz(playerid, response, listitem, inputtext[])
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
			Dialog_Show(playerid,dl_kzfz,DIALOG_STYLE_LIST,"���÷���/���۷���",Shokzfzlist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPlayerPosEx(playerid,HOUSE[listid][H_oX],HOUSE[listid][H_oY],HOUSE[listid][H_oZ],HOUSE[listid][H_oA],HOUSE[listid][H_oIN],HOUSE[listid][H_oWL],listid,0,0);
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_kzfz,DIALOG_STYLE_LIST,"���÷���/���۷���",Shokzfzlist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
		}
	}
	return 1;
}
stock Shokzfzlist(playerid,pager)
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
 			switch(HOUSE[current_idx[playerid][i]][H_isSEL])
			{
				case NONEONE:format(tmps,100,"[δ����]����ID:%i - %s - �ۼ�:$%i\n",current_idx[playerid][i],HOUSE[current_idx[playerid][i]][H_NAMES],HOUSE[current_idx[playerid][i]][H_Value]);
				case SELLING:format(tmps,100,"[ת����]����ID:%i - %s - ����:%s - �ۼ�:$%i\n",current_idx[playerid][i],HOUSE[current_idx[playerid][i]][H_NAMES],UID[HOUSE[current_idx[playerid][i]][H_UID]][u_name],HOUSE[current_idx[playerid][i]][H_Value]);
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
    	strcat(tmp, "\t\t\t{FF8000}��һҳ\n");
    }
    return tmp;
}
