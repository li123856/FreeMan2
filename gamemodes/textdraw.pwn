#define MAX_TOOLBAR_RESPONSES 10

enum
{
	Text: TOOLBAR_VEHICLE,
	Text: TOOLBAR_OBJECT,
	Text: TOOLBAR_PICKUP,
	Text: TOOLBAR_ATTACH,
	Text: TOOLBAR_SAVE,
	Text: TOOLBAR_OPEN,
	Text: TOOLBAR_NEW,
	Text: TOOLBAR_CAM,
	Text: TOOLBAR_INFO,
	Text: TOOLBAR_SET
}

enum
{
	Text: TOOLBAR_ICON,
	Text: TOOLBAR_TEXT
}

new Text: g_tbIconTD		[MAX_TOOLBAR_RESPONSES][2];
Function Showtab(playerid)
{
	Loop(a,MAX_TOOLBAR_RESPONSES)
	{
		Loop(b,2)TextDrawShowForPlayer(playerid, g_tbIconTD[a][b]);
	}
	return 1;
}
Function Hidetab(playerid)
{
	Loop(a,MAX_TOOLBAR_RESPONSES)
	{
		Loop(b,2)TextDrawHideForPlayer(playerid, g_tbIconTD[a][b]);
	}
	return 1;
}
stock createtab()
{
	g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON] =
	TextDrawCreate			(503.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 557);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 340.0, 0.0, 320.0, 0.8);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT] =
	TextDrawCreate			(505.0, 435.0, "Vehicle");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_VEHICLE][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON] =
	TextDrawCreate			(462.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 1273);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 335.0, 0.0, 45.0, 1.0);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT] =
	TextDrawCreate			(464.0, 435.0, "House");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_OBJECT][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON] =
	TextDrawCreate			(421.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 1976);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 330.0, 0.0, 325.0, 1.0);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT] =
	TextDrawCreate			(423.0, 435.0, "Words");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_PICKUP][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON] =
	TextDrawCreate			(380.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 1275);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 0.0, 0.0, 50.0, 0.7);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT] =
	TextDrawCreate			(382.0, 435.0, "Dress");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_ATTACH][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON] =
	TextDrawCreate			(339.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 1276);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 330.0, 0.0, 330.0, 0.80);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT] =
	TextDrawCreate			(341.0, 435.0, "Area");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_SAVE][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON] =
	TextDrawCreate			(298.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 1210);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 330.0, 0.0, 340.0, 0.8);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT] =
	TextDrawCreate			(300.0, 435.0, "Bag");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_OPEN][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON] =
	TextDrawCreate			(257.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 3111);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 90.0, 330.0, 180.0, 0.9);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT] =
	TextDrawCreate			(259.0, 435.0, "Teles");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_NEW][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON] =
	TextDrawCreate			(216.0, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 1313);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 340.0, 0.0, 50.0, 0.8);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT] =
	TextDrawCreate			(218.0, 435.0, "Gang");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_CAM][TOOLBAR_TEXT]);


	g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON] =
	TextDrawCreate			(175, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 1314);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 0.0, 0.0, 180.0, 1.0);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT] =
	TextDrawCreate			(177, 435.0, "Menu");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_INFO][TOOLBAR_TEXT]);

	g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON] =
	TextDrawCreate			(134, 396.0, "_");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 25);
	TextDrawFont			(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 5);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 0.699999, 5.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], -1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 1);
	TextDrawUseBox			(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 1);
	TextDrawBoxColor		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 0);
	TextDrawTextSize		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 40.0, 50.0);
	TextDrawSetPreviewModel	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 1277);
	TextDrawSetPreviewRot	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 0.0, 0.0, 180.0, 1.0);
	TextDrawSetSelectable	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_ICON]);

	g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT] =
	TextDrawCreate			(136, 435.0, "Set");
	TextDrawBackgroundColor	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT], 255);
	TextDrawFont			(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT], 1);
	TextDrawLetterSize		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT], 0.199999, 1.0);
	TextDrawColor			(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT], -1);
	TextDrawSetOutline		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT], 1);
	TextDrawSetProportional	(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT], 1);
	TextDrawShowForAll		(g_tbIconTD[TOOLBAR_SET][TOOLBAR_TEXT]);
	return 1;
}
CMD:llsj(playerid, params[], help)
{
	Dialog_Show(playerid, dl_zhxx, DIALOG_STYLE_LIST, "�ۺ���Ϣ","�����Ҿ�\n�׹��̳�\n���紫��\n���緿��\n���簮��\n��������\n�������\n�������\n�������\n���߹���", "ȷ��", "ȡ��");
	return 1;
}
CMD:wdsz(playerid, params[], help)
{
	Dialog_Show(playerid, dl_wdsz, DIALOG_STYLE_LIST, "�ҵ�����","{FF8000}������CDK��ֵ\n{FFFFFF}�ҵ���Ϸ��Ϣ\n�ҵ���Ϸ����", "ȷ��", "ȡ��");
	return 1;
}
CMD:cdk(playerid, params[], help)
{
	Dialog_Show(playerid, dl_cdk, DIALOG_STYLE_PASSWORD, "CDK��ֵ", "��δ����CKD���ܣ��뵽zyz2.28ka.com����,��ÿ��ܺ����ڴ˴�����\n������16λ��ֵ���", "ȷ��", "ȡ��");
	return 1;
}
stock CDKint(cds[])
{
    foreach(new i:CDK)
    {
		if(!strcmp(cds,CDK[i][cdk_cdk], false))return i;
    }
    return -1;
}
Dialog:dl_cdk(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strlen(inputtext)<15)return Dialog_Show(playerid, dl_cdk, DIALOG_STYLE_INPUT, "CDK��ֵ", "������Ŀ���λ������,����������", "ȷ��", "ȡ��");
		new idc=CDKint(inputtext);
		if(idc==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","CDK���ܲ�����", "�õ�", "");
		new str[100];
		format(str, sizeof(str),"�˿��ܼ�ֵ%0.2f�����,�ɳ�ֵ%i��V��\n��ֵ��˿��ܽ�����,�Ƿ��ֵ",CDK[idc][cdk_money],CDK[idc][cdk_vb]);
        Dialog_Show(playerid, dl_cdkok, DIALOG_STYLE_MSGBOX, "CDK",str, "��ֵ", "ȡ��");
        SetPVarInt(playerid,"cdks",idc);
	}
	return 1;
}
Dialog:dl_cdkok(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new idc=GetPVarInt(playerid,"cdks");
		if(!Iter_Contains(CDK,idc))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","CDK�����Ѳ�����", "�õ�", "");
        VBhandle(PU[playerid],CDK[idc][cdk_vb]);
		new tm[150];
		format(tm,sizeof(tm),"��ϲ��,��ɹ���ֵ��%iV��",CDK[idc][cdk_vb]);
		SM(COLOR_GAINSBORO, tm);
		format(tm,sizeof(tm),"%s��ֵ��%iV��,��ֵ�����%f,����:%s",Gn(playerid),CDK[idc][cdk_vb],CDK[idc][cdk_money],CDK[idc][cdk_cdk]);
		WriteWarnInLog(tm,CDKWARN_FILE);
		printf("%s",tm);
        Iter_Remove(CDK,idc);
        SaveCDK();
	}
	return 1;
}
CMD:wdys(playerid, params[], help)
{
	new tmp[738],Stru[64];
	Loop(x,sizeof(colorMenu)-SCOLOR)
	{
		format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
		strcat(tmp,Stru);
	}
	Dialog_Show(playerid,dl_wdyslist,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_wdyslist(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    UID[PU[playerid]][u_color]=listitem;
	    Saveduid_data(PU[playerid]);
	    SetPlayerColor(playerid,colorMenu[UID[PU[playerid]][u_color]]);
	    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","������ɫ�ɹ�", "�õ�", "");
	}
	return 1;
}
CMD:wdpf(playerid, params[], help)
{
	current_number[playerid]=0;
	new idx=0;
	new objid[TOTAL_SKIN],amoute[TOTAL_SKIN][8];
	Loop(i,sizeof(SkinList))
	{
		current_idx[playerid][idx]=i;
		objid[idx]=SkinList[i];
        format(amoute[idx],16,"%i",SkinList[i]);
       	current_number[playerid]++;
       	idx++;
	}
	new amouts=sizeof(SkinList);
	new tm[100];
	format(tm,100,"~b~SKIN SHOP");
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_SKIN_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
CMD:kill(playerid, params[], help)
{
	SetPlayerHealth(playerid,0.0);
	return 1;
}
CMD:wdms(playerid, params[], help)
{
	Dialog_Show(playerid,dl_wdms,DIALOG_STYLE_LIST,"ѡ��ģʽ","�޵�ģʽ\n��ͨģʽ","ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_wdms(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:
		    {
		        UID[PU[playerid]][u_mode]=1;
 				Saveduid_data(PU[playerid]);
 				UpdateDynamic3DTextLabelText(Mode3D[playerid],-1,"�޵�ģʽ");
		    }
		    case 1:
		    {
		        UID[PU[playerid]][u_mode]=0;
 				Saveduid_data(PU[playerid]);
 				UpdateDynamic3DTextLabelText(Mode3D[playerid],-1,"");
 				SetPlayerHealth(playerid,100);
		    }
		}
	}
	return 1;
}
CMD:wdpd(playerid, params[], help)
{
	Dialog_Show(playerid,dl_wdpd,DIALOG_STYLE_LIST,"ѡ��Ƶ��","��������\n��������\n��������","ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_wdpd(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:
		    {
				UID[PU[playerid]][u_irc]=IRC_WORLD;
 				Saveduid_data(PU[playerid]);
		    }
		    case 1:
		    {
				UID[PU[playerid]][u_irc]=IRC_LOCAL;
 				Saveduid_data(PU[playerid]);
		    }
		    case 2:
		    {
		        if(UID[PU[playerid]][u_gid]==-1)return Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "����", "��û�а����޷�ѡ�����", "�õ�", "");
				UID[PU[playerid]][u_irc]=IRC_GANG;
 				Saveduid_data(PU[playerid]);
		    }
		}
	}
	return 1;
}
CMD:wdwq(playerid, params[], help)
{
	current_number[playerid]=0;
	new idx=0;
	new objid[TOTAL_SKIN],amoute[TOTAL_SKIN][16];
	Loop(i,13)
	{
	    if(WEAPONUID[PU[playerid]][i][wpid]!=0)
	    {
			current_idx[playerid][idx]=i;
			objid[idx]=WEAPONUID[PU[playerid]][i][wmodel];
			format(amoute[idx],16,"%s",Daoju[WEAPONUID[PU[playerid]][i][wdid]][d_name]);
	       	current_number[playerid]++;
	       	idx++;
       	}
	}
	if(idx==0)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û������", "��", "");
	new amouts=idx;
	new tm[100];
	format(tm,100,"~b~MY WEAPON");
	ShowModelSelectionMenuEx(playerid,objid,amoute,amouts,tm,CUSTOM_WEAPON_MENU,-20.0, 0.0, -55.0,1.0,50,0,0xFFFF80C8);
	return 1;
}
Dialog:dl_wquisz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new list=GetPVarInt(playerid,"listIDA");
		switch(listitem)
		{
		    case 0:
		    {
		        Addbeibao(playerid,WEAPONUID[PU[playerid]][list][wdid],1);
				new Str[128];
				format(Str,sizeof(Str),"%s������%s���뱳��,��������Ʒʣ��%i",Gnn(playerid),Daoju[WEAPONUID[PU[playerid]][list][wdid]][d_name],GetBeibaoAmout(playerid,WEAPONUID[PU[playerid]][list][wdid]));
				AdminWarn(Str);
				ResetPlayerWeapons(playerid);
                WEAPONUID[PU[playerid]][list][wdid]=0;
				WEAPONUID[PU[playerid]][list][wpid]=0;
				WEAPONUID[PU[playerid]][list][wmodel]=0;
				SaveWeapon(PU[playerid]);
				GvieGun(playerid);
		    }
		    case 1:
		    {
				new Str[128];
				format(Str,sizeof(Str),"%s����������%s",Gnn(playerid),Daoju[WEAPONUID[PU[playerid]][list][wdid]][d_name]);
				AdminWarn(Str);
				ResetPlayerWeapons(playerid);
                WEAPONUID[PU[playerid]][list][wdid]=0;
				WEAPONUID[PU[playerid]][list][wpid]=0;
				WEAPONUID[PU[playerid]][list][wmodel]=0;
				SaveWeapon(PU[playerid]);
				GvieGun(playerid);
		    }
		}
	}
	return 1;
}
Dialog:dl_yxxx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/stats");
		    case 1:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdwq");
		    case 2:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdck");
		    case 3:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdgg");
		    case 4:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdxx");
		    case 5:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdhy");
		    case 6:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdmsx");
		    case 7:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdebuy");
		}
	}
	return 1;
}
Dialog:dl_yxsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/xgmm");
		    case 1:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdpf");
		    case 2:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdys");
		    case 3:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdpd");
		    case 4:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdms");
		    case 5:Dialog_Show(playerid,dl_wdzym,DIALOG_STYLE_INPUT,"�ҵ�������","������������","ȷ��", "ȡ��������");
		    case 6:Dialog_Show(playerid, dl_wdszsjtq, DIALOG_STYLE_LIST, "ʱ������","����ʱ��\n��������", "ȷ��", "ȡ��");
		    case 7:Dialog_Show(playerid, dl_wdszcsdw, DIALOG_STYLE_LIST, "������λ","��λ�˵�\nȡ����λ", "ȷ��", "ȡ��");
		    case 8:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/kgpz");
		    case 9:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/obj");
		    case 10:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/speed");
		    case 11:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/horse");
		    case 12:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/kill");
		}
	}
	return 1;
}
Dialog:dl_wdsz(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/cdk");
			case 1:Dialog_Show(playerid, dl_yxxx, DIALOG_STYLE_LIST, "�ҵ���Ϸ��Ϣ","������Ϣ\n�ҵ�����\n�ҵĲֿ�\n�ҵĹ��\n�ҵ���Ϣ\n�ҵĺ���\n�ҵ���ʳ\n�ҵ�Ebuy�˻�", "ȷ��", "ȡ��");
			case 2:Dialog_Show(playerid, dl_yxsz, DIALOG_STYLE_LIST, "�ҵ���Ϸ����","��������\n����Ƥ��\n������ɫ\n����Ƶ��\n����ģʽ\n������\nʱ������\n������λ\n������ײ\n����OBJ\n�����ٶȱ�\n���ض�̬��\n�����˶�", "ȷ��", "ȡ��");
		}
	}
	return 1;
}
CMD:xgmm(playerid, params[], help)
{
	Dialog_Show(playerid,dl_xgmm,DIALOG_STYLE_INPUT,"�޸�����","�������µ�����","ȷ��", "ȡ��");
    return 1;
}
Dialog:dl_xgmm(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strlenEx(inputtext)>20||strlenEx(inputtext)<2)return Dialog_Show(playerid,dl_xgmm,DIALOG_STYLE_INPUT,"�޸�����","�ַ����������,�������µ�����","ȷ��", "ȡ��");
		format(UID[PU[playerid]][u_Pass],129,"%s",HashPass(inputtext));
		Saveduid_data(PU[playerid]);
		new Str[100];
		format(Str,sizeof(Str),"���ѽ���������޸�Ϊ%s,���μ��������",inputtext);
		Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����",Str, "��", "");
	}
	return 1;
}
Dialog:dl_wdzym(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(strlen(UID[PU[playerid]][u_zym])<1)
	    {
		    if(UID[PU[playerid]][u_wds]<10)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "����","��û��10V��,������������", "��", "");
			ReStr(inputtext);
			if(strlenEx(inputtext)>60||strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_wdzym,DIALOG_STYLE_INPUT,"�ҵ�������","������������","ȷ��", "ȡ��������");
			format(UID[PU[playerid]][u_zym],80,inputtext);
			Saveduid_data(PU[playerid]);
			VBhandle(PU[playerid],-10);
			new tmp[738],Stru[64];
			Loop(x,sizeof(colorMenu)-SCOLOR)
			{
				format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
				strcat(tmp,Stru);
			}
			Dialog_Show(playerid,dl_wdzymcol,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
	    }
	    else
	    {
			ReStr(inputtext);
			if(strlenEx(inputtext)>60||strlenEx(inputtext)<3)return Dialog_Show(playerid,dl_wdzym,DIALOG_STYLE_INPUT,"�ҵ�������","������������","ȷ��", "ȡ��������");
			format(UID[PU[playerid]][u_zym],80,inputtext);
			Saveduid_data(PU[playerid]);
			new tmp[738],Stru[64];
			Loop(x,sizeof(colorMenu)-SCOLOR)
			{
				format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
				strcat(tmp,Stru);
			}
			Dialog_Show(playerid,dl_wdzymcol,DIALOG_STYLE_LIST,"ѡ����ɫ",tmp,"ȷ��", "ȡ��");
	    }
	}
	else Dialog_Show(playerid, dl_qxzym, DIALOG_STYLE_MSGBOX, "����","ȷ��Ҫȡ��������", "ȷ��", "ȡ��");
	return 1;
}
Dialog:dl_qxzym(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    format(UID[PU[playerid]][u_zym],80," ");
	    UID[PU[playerid]][u_zymcol]=0;
	    Saveduid_data(PU[playerid]);
	}
	return 1;
}
Dialog:dl_wdzymcol(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    UID[PU[playerid]][u_zymcol]=listitem;
	    Saveduid_data(PU[playerid]);
	}
	return 1;
}
Dialog:dl_wdszsjtq_sj(playerid, response, listitem, inputtext[])
{
	if(response)
	{
    	if(strval(inputtext)<0||strval(inputtext)>24)return Dialog_Show(playerid,dl_wdszsjtq_sj,DIALOG_STYLE_INPUT,"����ʱ��","��ֵ����ȷ,������Ҫ������ʱ��","ȷ��", "ȡ��");
        UID[PU[playerid]][u_realtime]=strval(inputtext);
        Saveduid_data(PU[playerid]);
        SetPlayerTime(playerid,UID[PU[playerid]][u_realtime],0);
	}
	else
	{
	    UID[PU[playerid]][u_realtime]=-1;
	    Saveduid_data(PU[playerid]);
	}
	return 1;
}
Dialog:dl_wdszsjtq_tq(playerid, response, listitem, inputtext[])
{
	if(response)
	{
    	if(strval(inputtext)<0||strval(inputtext)>20)return Dialog_Show(playerid,dl_wdszsjtq_tq,DIALOG_STYLE_INPUT,"��������","��ֵ����ȷ,������Ҫ����������ID","ȷ��", "ȡ��");
        UID[PU[playerid]][u_weather]=strval(inputtext);
		Saveduid_data(PU[playerid]);
        SetPlayerWeather(playerid,UID[PU[playerid]][u_weather]);
	}
	else
	{
	    UID[PU[playerid]][u_weather]=-1;
	    Saveduid_data(PU[playerid]);
	}
	return 1;
}
Dialog:dl_wdszsjtq(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:Dialog_Show(playerid,dl_wdszsjtq_sj,DIALOG_STYLE_INPUT,"����ʱ��","������Ҫ������ʱ��","ȷ������", "ȡ������");
			case 1:Dialog_Show(playerid,dl_wdszsjtq_tq,DIALOG_STYLE_INPUT,"��������","������Ҫ����������ID","ȷ������", "ȡ������");
		}
	}
	return 1;
}
Dialog:dl_wdszcsdw(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/savepos");
			case 1:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/unsavepos");
		}
	}
	return 1;
}
Dialog:dl_zhxx(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
			case 0:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/djj");
			case 1:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/ebuy");
			case 2:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llcs");
			case 3:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llfz");
			case 4:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/kzac");
			case 5:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llsd");
			case 6:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/join");
			case 7:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/lldp");
			case 8:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llbp");
			case 9:CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/lxgl");
		}
	}
	return 1;
}
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	Hidetab(playerid);
	if(clickedid==g_tbIconTD[0][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdac");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[1][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdfz");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[2][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdwz");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[3][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdzb");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[4][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wddp");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[5][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdbb");
		//CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[6][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdcs");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[7][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdbp");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[8][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/llsj");
		CancelSelectTextDraw(playerid);
	}
	if(clickedid==g_tbIconTD[9][0])
	{
		CallRemoteFunction( "OnPlayerCommandText", "ds", playerid,"/wdsz");
		CancelSelectTextDraw(playerid);
	}
    return 1;
}
