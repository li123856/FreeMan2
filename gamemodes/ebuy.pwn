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
    if(UID[PU[playerid]][u_Score]<500)return SM(COLOR_TWTAN,"��Ļ��ֲ���500,�޷�ʹ���ҵ��̳�");
    Dialog_Show(playerid,dl_ebuyxz,DIALOG_STYLE_LIST,"�׹���","�ҵĳ���\n������Ʒ","ѡ��", "ȡ��");
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
	if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����,�׹���û����Ʒ����", "�õ�", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"�׹���/EBUY-���Ƴ���[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_ebuy, DIALOG_STYLE_TABLIST_HEADERS,tm, Showebuylist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
			if(Ebuy[current_idx[playerid][i]][e_type]==EBUY_TYPE_JJ)format(tmps,100,"%s%s   ����:%i��   �����ۼ�:$%i   ������:%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Daoju[Ebuy[current_idx[playerid][i]][e_did]][d_name],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
            else if(Ebuy[current_idx[playerid][i]][e_type]==EBUY_TYPE_VB)format(tmps,100,"%s����%i��   �����ۼ�:$%i   ������:%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
			else format(tmps,100,"%sID:%i  �����ۼ�:$%i   ������:%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_did],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
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
			Dialog_Show(playerid,dl_myebuy,DIALOG_STYLE_TABLIST,"�ҵ��׹�����",Showemybuylist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"ebuy",listid);
			SetPVarInt(playerid,"seq",Ebuy[listid][e_seq]);
            Dialog_Show(playerid,dl_myebuyxj, DIALOG_STYLE_MSGBOX, "�ҵ��׹���","�Ƿ��¼ܴ���Ʒ", "�¼�", "ȡ��");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_myebuy,DIALOG_STYLE_TABLIST,"�ҵ��׹�����",Showemybuylist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
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
	    if(!Itter_Contains(Ebuy,i))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	    if(Ebuy[i][e_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	    if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
		switch(Ebuy[i][e_type])
		{
			case EBUY_TYPE_JJ:
			{
                Addbeibao(playerid,Ebuy[i][e_did],Ebuy[i][e_amout]);
		        delebuything(i,Ebuy[i][e_amout]);
		        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��Ʒ�¼ܳɹ�,��Ʒ�ѷ���", "��", "");
			}
			case EBUY_TYPE_DP:
			{
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��Ʒ�¼ܳɹ�,�����ѿ��Բ���", "��", "");
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
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��Ʒ�¼ܳɹ�,�����ѿ��Բ���", "��", "");
		    }
		    case EBUY_TYPE_SY:
		    {
		    }
		    case EBUY_TYPE_VB:
		    {
		        VBhandle(PU[playerid],Ebuy[i][e_amout]);
		        delebuything(i,Ebuy[i][e_amout]);
		        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��Ʒ�¼ܳɹ�,V���ѷ���", "��", "");
		    }
		    case EBUY_TYPE_AC:
		    {
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��Ʒ�¼ܳɹ�,�����ѿ��Բ���", "��", "");
		    }
		    case EBUY_TYPE_MS:
		    {
			    delebuything(i,Ebuy[i][e_amout]);
			    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��Ʒ�¼ܳɹ�,��ʳ�ѿ��Բ���", "��", "");
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
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "��û����Ʒ���׹�������", "�õ�", "");
				P_page[playerid]=1;
				new tm[100];
				format(tm,100,"�ҵ��׹�����-���Ƴ���[%i]",current_number[playerid]-1);
				Dialog_Show(playerid, dl_myebuy, DIALOG_STYLE_LIST,tm, Showemybuylist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
	        }
	        case 1:
			{
				new tmp[512];
				format(tmp,512,"%s\n%s\n%s\n%s\n%s\n%s",ebuytype[EBUY_TYPE_VB],ebuytype[EBUY_TYPE_JJ],ebuytype[EBUY_TYPE_DP],ebuytype[EBUY_TYPE_FZ],ebuytype[EBUY_TYPE_AC],ebuytype[EBUY_TYPE_MS]);
				Dialog_Show(playerid,dl_ebuyxzsp,DIALOG_STYLE_LIST,"������Ʒ",tmp,"ѡ��", "ȡ��");
			}	
	    }
	}
	return 1;
}
Dialog:dl_addebuyjj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĸ���", "ȷ��", "ȡ��");
        new djid=GetPVarInt(playerid,"listIDB");
        if(strval(inputtext)>GetBeibaoAmout(playerid,Beibao[playerid][djid][b_did]))return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","��û����ô��,������Ҫ���۵ĸ���", "ȷ��", "ȡ��");
		SetPVarInt(playerid,"listIDA",strval(inputtext));
		Dialog_Show(playerid,dl_addebuyjjsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
 	}
	return 1;
}
Dialog:dl_addebuyjjsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
        new djid=GetPVarInt(playerid,"listIDB");
		new amouts=GetPVarInt(playerid,"listIDA");
		if(amouts>GetBeibaoAmout(playerid,Beibao[playerid][djid][b_did]))return Dialog_Show(playerid,dl_addebuyjj, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","��û����ô��,������Ҫ���۵ĸ���", "ȷ��", "ȡ��");
		Delbeibao(playerid,Beibao[playerid][djid][b_did],amouts);
        Addebuything(playerid,EBUY_TYPE_JJ,strval(inputtext),amouts,Beibao[playerid][djid][b_did]);
	}
	return 1;
}
Dialog:dl_ebuyxzsp(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(GetPlayerSellAmout(playerid)>=4&&GetadminLevel(playerid)<3000)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�����ֻ����Ebuy�ϼ�4����Ʒ", "��", "");
	    new current=-1;
	    switch(listitem)
	    {
	        case 0:
	        {
	            if(UID[PU[playerid]][u_wds]<1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "����,��û��V��", "�õ�", "");
				Dialog_Show(playerid,dl_addebuyvb, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĸ���", "ȷ��", "ȡ��");
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
				if(current==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "������ı�����û�ж���", "�õ�", "");
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
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��û�е���", "��", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuyselldp, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵ĵ���", Showselldplist(playerid,P_page[playerid]), "ѡ��", "ȡ��");
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
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��û�з���", "��", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuysellfz, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵ķ���", Showmyhouselist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
				if(current==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����,��û�а���", "��", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuysellac, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵İ���", Showmycarlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
				if(current==-1)return Dialog_Show(playerid,dl_msg, DIALOG_STYLE_MSGBOX,"����","�㻹û��������ʳ", "��", "");
				P_page[playerid]=1;
				Dialog_Show(playerid, dl_ebuysellms, DIALOG_STYLE_TABLIST_HEADERS,"ѡ������Ҫ���۵���ʳ", Showmymslist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
			Dialog_Show(playerid, dl_ebuysellms, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵���ʳ", Showmymslist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuysellms, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵���ʳ", Showmymslist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
			Dialog_Show(playerid, dl_ebuysellac, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵İ���", Showmycarlist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuyacbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuysellac, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵İ���", Showmycarlist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
			Dialog_Show(playerid, dl_ebuysellfz, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵ķ���", Showmyhouselist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuyfzbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuysellfz, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵ķ���", Showmyhouselist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
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
			Dialog_Show(playerid, dl_ebuyselldp, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵ĵ���", Showselldplist(playerid,P_page[playerid]), "ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDC",listid);
			Dialog_Show(playerid,dl_addebuydpbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
		}
	}
	else
	{
	    if(P_page[playerid] > 1)
	    {
	       	P_page[playerid]--;
	       	Dialog_Show(playerid, dl_ebuyselldp, DIALOG_STYLE_LIST,"ѡ������Ҫ���۵ĵ���", Showselldplist(playerid,P_page[playerid]), "ȷ��", "ȡ��");
		}
	}
	return 1;
}
Dialog:dl_addebuydpbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuydpbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuydpbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		new edids=GetPVarInt(playerid,"listIDC");
	    if(IsDPselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�õ������ϼ�", "��", "");
		if(DPInfo[edids][dp_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "���Ѳ�����ĵ�����", "��", "");
		Addebuything(playerid,EBUY_TYPE_DP,strval(inputtext),1,edids);
	}
	return 1;
}
Dialog:dl_addebuyacbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyacbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyacbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		new edids=GetPVarInt(playerid,"listIDC");
		if(VInfo[edids][v_issel]==SELLING)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�ð������ڳ���״̬", "��", "");
	    if(IsACselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�ð������ϼ�", "��", "");
		if(VInfo[edids][v_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "���Ѳ�����İ�����", "��", "");
		Addebuything(playerid,EBUY_TYPE_AC,strval(inputtext),1,edids);
	}
	return 1;
}
Dialog:dl_addebuyfzbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyfzbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyfzbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		new edids=GetPVarInt(playerid,"listIDC");
		if(HOUSE[edids][H_isSEL]==SELLING)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�÷������ڳ���״̬", "��", "");
	    if(IsFZselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�÷������ϼ�", "��", "");
		if(HOUSE[edids][H_UID]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "���Ѳ�����ķ�����", "��", "");
		Addebuything(playerid,EBUY_TYPE_FZ,strval(inputtext),1,edids);
	}
	return 1;
}
Dialog:dl_addebuymsbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuymsbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		new edids=GetPVarInt(playerid,"listIDC");
	    if(IsMSselling(edids))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����ʳ���ϼ�", "��", "");
		if(pfood[edids][pfoode_uid]!=PU[playerid])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "���Ѳ��������ʳ��", "��", "");
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
			format(tmps,100,"ID:%i����[%s]\n",current_idx[playerid][i],DPInfo[current_idx[playerid][i]][dp_name]);
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
Dialog:dl_addebuyvb(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyvb, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĸ���", "ȷ��", "ȡ��");
	    if(UID[PU[playerid]][u_wds]<strval(inputtext))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��V��", "��", "");
		SetPVarInt(playerid,"listIDA",strval(inputtext));
		Dialog_Show(playerid,dl_addebuyvbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","������Ҫ���۵ĵ���", "����", "ȡ��");
	}
	return 1;
}
Dialog:dl_addebuyvbsell(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid,dl_addebuyvbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		if(strval(inputtext)>MAX_MONEY)return Dialog_Show(playerid,dl_addebuyvbsell, DIALOG_STYLE_INPUT, "��Ʒ�ϼ�","�������˴������ֵ,������Ҫ���۵ĵ���", "����", "ȡ��");
		new amouts=GetPVarInt(playerid,"listIDA");
	    if(UID[PU[playerid]][u_wds]<amouts)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��V��", "��", "");
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
			Dialog_Show(playerid,dl_ebuy,DIALOG_STYLE_TABLIST_HEADERS,"�׹���/EBUY",Showebuylist(playerid,P_page[playerid]),"ȷ��", "��һҳ");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem],str[100];
			SetPVarInt(playerid,"ebuy",listid);
			SetPVarInt(playerid,"seq",Ebuy[listid][e_seq]);
		    if(Ebuy[listid][e_uid]==PU[playerid])return Dialog_Show(playerid,dl_myebuyxj, DIALOG_STYLE_MSGBOX, "�ҵ��׹���","�Ƿ��¼ܴ���Ʒ", "�¼�", "ȡ��");
			switch(Ebuy[listid][e_type])
			{
			    case EBUY_TYPE_JJ:
				{
					format(str,100,"[%i]-%s����%i��%s�۸�ÿ��$%i,�����빺��ĸ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_amout],Daoju[Ebuy[listid][e_did]][d_name],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyjj, DIALOG_STYLE_INPUT, "�׹�������",str, "����", "ȡ��");
				}
			    case EBUY_TYPE_DP:
			    {
					format(str,100,"%[%i]-%s���۵���ID:%i�۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuydp, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
			    }
			    case EBUY_TYPE_WZ:
			    {
					format(str,100,"[%i]-%s�������ֵ�ID:%i�۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuywzd, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
			    }
			    case EBUY_TYPE_CS:
			    {
					format(str,100,"[%i]-%s���۴���ID:%i�۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuycs, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
			    }
			    case EBUY_TYPE_XD:
			    {
					format(str,100,"[%i]-%s����С��ID:%i�۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyxd, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
			    }
			    case EBUY_TYPE_FZ:
			    {
					format(str,100,"[%i]-%s���۷���ID:%i OBJ����:%i �۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_did],Iter_Count(HOBJ[Ebuy[listid][e_did]]),Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyfz, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
			    }
			    case EBUY_TYPE_SY:
			    {
					format(str,100,"[%i]-%s������ҵ[%s]ID:%i�۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],protypestr[property[Ebuy[listid][e_did]][pro_type]],Ebuy[listid][e_did],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuysy, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
			    }
			    case EBUY_TYPE_VB:
				{
					format(str,100,"[%i]-%s����%i��V�Ҽ۸�$%i,�����빺��ĸ���",listid,UID[Ebuy[listid][e_uid]][u_name],Ebuy[listid][e_amout],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyvb, DIALOG_STYLE_INPUT, "�׹�������",str, "����", "ȡ��");
				}
			    case EBUY_TYPE_AC:
				{
					format(str,100,"[%i]-%s����ID:%i����[%s]װ����%i���۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],VInfo[Ebuy[listid][e_did]][v_cid],Daoju[VInfo[Ebuy[listid][e_did]][v_did]][d_name],Iter_Count(AvInfo[Ebuy[listid][e_did]]),Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyac, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
				}
			    case EBUY_TYPE_MS:
				{
					format(str,100,"[%i]-%s����ID:%i��ʳ[%s]Ч��[%0.2f]�۸�$%i,�Ƿ���",listid,UID[Ebuy[listid][e_uid]][u_name],listid,pfood[Ebuy[listid][e_did]][pfoode_name],pfood[Ebuy[listid][e_did]][pfoode_usefuel],Ebuy[listid][e_value]);
					Dialog_Show(playerid,dl_ebuyms, DIALOG_STYLE_MSGBOX, "�׹�������",str, "����", "ȡ��");
				}
			}
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid,dl_ebuy,DIALOG_STYLE_TABLIST_HEADERS,"�׹���/EBUY",Showebuylist(playerid,P_page[playerid]),"ȷ��", "ȡ��");
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
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��Ǯ", "��", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        pfood[Ebuy[i][e_did]][pfoode_uid]=PU[playerid];
	        SavedFood_data(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s����������۵���ʳ[%s],�۸�[$%i]",Gn(playerid),pfood[Ebuy[i][e_did]][pfoode_name],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"�׹���",str,Ebuy[i][e_value]);
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
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��Ǯ", "��", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        VInfo[Ebuy[i][e_did]][v_uid]=PU[playerid];
	        Savedveh_data(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s����������۵İ���ID:%i[%s],�۸�[$%i]",Gn(playerid),Ebuy[i][e_did],Daoju[VInfo[Ebuy[i][e_did]][v_did]][d_name],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"�׹���",str,Ebuy[i][e_value]);
	        delebuything(i,Ebuy[i][e_amout]);
	    }
 	}
	return 1;
}
Dialog:dl_ebuyfz(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(getplayerhouse(PU[playerid])>=3)return SM(COLOR_TWTAN,"���Ѿ�����3��������");
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��Ǯ", "��", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        HOUSE[Ebuy[i][e_did]][H_UID]=PU[playerid];
	        Savedhousedata(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s����������۵ķ���ID:%i,�۸�[$%i]",Gn(playerid),Ebuy[i][e_did],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"�׹���",str,Ebuy[i][e_value]);
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
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��Ǯ", "��", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]);
	        DPInfo[Ebuy[i][e_did]][dp_uid]=PU[playerid];
	        SavedDPdata(Ebuy[i][e_did]);
	        new str[100];
			format(str,100,"%s����������۵ĵ���ID:%i,�۸�[$%i]",Gn(playerid),Ebuy[i][e_did],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"�׹���",str,Ebuy[i][e_value]);
	        delebuything(i,Ebuy[i][e_amout]);
	    }
 	}
	return 1;
}
	
Dialog:dl_ebuyjj(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�������˴������ֵ", "��", "");
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
			if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]*strval(inputtext)))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��Ǯ", "��", "");
			if(strval(inputtext)>Ebuy[i][e_amout])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "û����ô����Ʒ����", "��", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]*strval(inputtext));
	        Addbeibao(playerid,Ebuy[i][e_did],strval(inputtext));
	        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ", "����Ʒ��������ı���", "��", "");
	        new str[100];
			format(str,100,"%s����������۵�%i���Ҿ�%s,����[$%i]",Gn(playerid),strval(inputtext),Daoju[Ebuy[i][e_did]][d_name],Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"�׹���",str,Ebuy[i][e_value]*strval(inputtext));
	        delebuything(i,strval(inputtext));
		}
	}
	return 1;
}
Dialog:dl_ebuyvb(playerid, response, listitem, inputtext[])
{
    if(response)
	{
	    if(strval(inputtext)<=0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "�������˴������ֵ", "��", "");
		new i=GetPVarInt(playerid,"ebuy");
		new seq=GetPVarInt(playerid,"seq");
		if(Itter_Contains(Ebuy,i))
		{
		    if(Ebuy[i][e_seq]!=seq)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
	        if(!EnoughMoneyEx(playerid,Ebuy[i][e_value]*strval(inputtext)))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "��û����ô��Ǯ", "��", "");
			if(strval(inputtext)>Ebuy[i][e_amout])return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "û����ô����Ʒ����", "��", "");
	        Moneyhandle(PU[playerid],-Ebuy[i][e_value]*strval(inputtext));
	        VBhandle(PU[playerid],strval(inputtext));
	        Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "��ʾ", "����Ʒ����������˻�", "��", "");
	        new str[100];
			format(str,100,"%s����������۵�%i��V��,����[$%i]",Gn(playerid),strval(inputtext),Ebuy[i][e_value]);
	        AddPlayerLog(Ebuy[i][e_uid],"�׹���",str,Ebuy[i][e_value]*strval(inputtext));
	        delebuything(i,strval(inputtext));
        }
        else Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����", "����Ʒ�����ѱ������ɾ��", "��", "");
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
	format(tmp,4128, "����\tID/����\t���ۼ�\t������\n");
	LoopEx(i,pager,pager+MAX_DILOG_LIST)
	{
		new tmps[300];
		if(i<current_number[playerid])
        {
            switch(Ebuy[current_idx[playerid][i]][e_type])
            {
                case EBUY_TYPE_JJ:format(tmps,256,"%s\t%s[{FF8000}%i��{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Daoju[Ebuy[current_idx[playerid][i]][e_did]][d_name],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_VB:format(tmps,256,"%s\t[{FF8000}%i��{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_amout],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_DP:format(tmps,256,"%s\tID:%i\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_did],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_AC:format(tmps,256,"%s\tID:%i[{FF8000}%s{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],VInfo[Ebuy[current_idx[playerid][i]][e_uid]][v_cid],Daoju[VInfo[Ebuy[current_idx[playerid][i]][e_did]][v_did]][d_name],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
                case EBUY_TYPE_FZ:format(tmps,256,"%s\tID:%i\t{FFFF00}$%i\t%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],Ebuy[current_idx[playerid][i]][e_did],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
				case EBUY_TYPE_MS:format(tmps,256,"%s\t%s[{FF8000}Ч��:%0.2f{FFFFFF}]\t{FFFF00}$%i\t{00FF80}%s\n",ebuytype[Ebuy[current_idx[playerid][i]][e_type]],pfood[Ebuy[current_idx[playerid][i]][e_did]][pfoode_name],pfood[Ebuy[current_idx[playerid][i]][e_did]][pfoode_usefuel],Ebuy[current_idx[playerid][i]][e_value],UID[Ebuy[current_idx[playerid][i]][e_uid]][u_name]);
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
	    case EBUY_TYPE_JJ:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}%s   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Daoju[Ebuy[i][e_did]][d_name]);
	    case EBUY_TYPE_DP:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_WZ:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_CS:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_XD:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_FZ:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_SY:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID:%i   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did]);
	    case EBUY_TYPE_VB:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}V��%i��   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_amout]);
	    case EBUY_TYPE_AC:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}ID[%i]%s   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],Ebuy[i][e_did],Daoju[VInfo[Ebuy[i][e_did]][v_did]][d_name]);
	    case EBUY_TYPE_MS:format(tmps, sizeof(tmps),""H_EBUY"%s�������µı���{80FFFF}%s{FFFFFF}[%s Ч��:%0.2f]   {2FD0D0}��Ҷ�������/ebuy",Gn(playerid),ebuytype[Ebuy[i][e_type]],pfood[Ebuy[i][e_did]][pfoode_name],pfood[Ebuy[i][e_did]][pfoode_usefuel]);
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
