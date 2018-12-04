#define MAX_MATERIALS 1000
#define         PREVIEW_STATE_NONE              0
#define         PREVIEW_STATE_ALLTEXTURES       1
#define         DEFAULT_TEXTURE                 1000
enum MENU3DINFO
{
    TPreviewState,
	CurrTextureIndex,
    Menus3D
}
new Menu3DData[MAX_PLAYERS][MENU3DINFO];
#include <3dmenu>
stock MenuPlayerDisconnect(playerid, reason)
{
    Menu3DData[playerid][TPreviewState] = PREVIEW_STATE_NONE;
	CancelSelect3DMenu(playerid);
	if(Menu3DData[playerid][Menus3D] != INVALID_3DMENU)
	{
        Destroy3DMenu(Menu3DData[playerid][Menus3D]);
        Menu3DData[playerid][Menus3D] = INVALID_3DMENU;
	}
	return 1;
}
stock ShowJJtxd(playerid,tog=1,vid=-1)
{
	if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
	{
		CancelSelect3DMenu(playerid);
		Destroy3DMenu(Menu3DData[playerid][Menus3D]);
		Menu3DData[playerid][TPreviewState] = PREVIEW_STATE_NONE;
		TogglePlayerControllable(playerid,1);
	}
	else
	{

		new Float:x, Float: y, Float:z, Float:fa;
        switch(GetPVarInt(playerid,"caizhi"))
	        {
	            case 0:
	            {
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, fa);
				}
				case 1:
				{
					GetVehiclePos(vid, x, y, z);
					GetVehicleZAngle(vid, fa);
				}
	            case 2:
	            {
					GetPlayerPos(playerid, x, y, z);
					GetPlayerFacingAngle(playerid, fa);
				}
			}
		x = (x + 1.75 * floatsin(-fa + -90,degrees));
		y = (y + 1.75 * floatcos(-fa + -90,degrees));
		x = (x + 2.0 * floatsin(-fa,degrees));
		y = (y + 2.0 * floatcos(-fa,degrees));
		Menu3DData[playerid][CurrTextureIndex] = 1;
		if(sizeof(ObjectTextures) - 1 - Menu3DData[playerid][CurrTextureIndex] - 16 < 0) Menu3DData[playerid][CurrTextureIndex] = sizeof(ObjectTextures) - 16 - 1;
		if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_NONE)
		{
		    Menu3DData[playerid][Menus3D] = Create3DMenu(playerid, x, y, z, fa, 16);
			Select3DMenu(playerid, Menu3DData[playerid][Menus3D]);
		    Menu3DData[playerid][TPreviewState] = PREVIEW_STATE_ALLTEXTURES;
			for(new i = 0; i < 16; i++)
			{
			    SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
			}
		}
		else if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
		{
			for(new i = 0; i < 16; i++)
			{
			    SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);

			}
		}
		SetCameraBehindPlayer(playerid);
		if(tog)TogglePlayerControllable(playerid ,0);
		Streamer_UpdateEx(playerid,x, y, z,-1,-1);
	}
	return 1;
}
forward OnPlayerKeyStateChangeMenu(playerid,newkeys,oldkeys);
public OnPlayerKeyStateChangeMenu(playerid,newkeys,oldkeys)
{
	if(Menu3DData[playerid][TPreviewState] == PREVIEW_STATE_ALLTEXTURES)
	{
		if((newkeys & KEY_NO)&&(newkeys & KEY_WALK))
		{
			Menu3DData[playerid][CurrTextureIndex] += 16;
			if(Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) Menu3DData[playerid][CurrTextureIndex] = 1;
			if(sizeof(ObjectTextures) - 1 - Menu3DData[playerid][CurrTextureIndex] - 16 < 0) Menu3DData[playerid][CurrTextureIndex] = sizeof(ObjectTextures) - 16 - 1;
			for(new i = 0; i < 16; i++)
			{
			   if(i+Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) continue;
		       SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
			}
			new tm[128];
			format(tm,sizeof(tm),"你翻到了第%i页",Menu3DData[playerid][CurrTextureIndex]/16+1);
			SM(COLOR_TWAQUA,tm);
		}
		if((newkeys & KEY_CROUCH)&&(newkeys & KEY_WALK))
		{
			Menu3DData[playerid][CurrTextureIndex] -= 16;
			if(Menu3DData[playerid][CurrTextureIndex] < 1) Menu3DData[playerid][CurrTextureIndex] = sizeof(ObjectTextures) - 1 - 16;
			if(Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) Menu3DData[playerid][CurrTextureIndex] = 1;
			for(new i = 0; i < 16; i++)
			{
				if(i+Menu3DData[playerid][CurrTextureIndex] >= sizeof(ObjectTextures) - 1) continue;
	   		    SetBoxMaterial(Menu3DData[playerid][Menus3D],i,0,ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TModel],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TXDName],ObjectTextures[i+Menu3DData[playerid][CurrTextureIndex]][TextureName], 0, 0xFF999999);
			}
			new tm[128];
			format(tm,sizeof(tm),"你翻到了第%i页",Menu3DData[playerid][CurrTextureIndex]/16+1);
			SM(COLOR_TWAQUA,tm);
		}
	}
	return 0;
}
