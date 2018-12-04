#pragma dynamic 150000
#pragma tabsize 0
#include <a_samp>
#include <streamer>
#include <zcmd>
#include <YSI\y_iterate>
#include <YSI\y_timers>
#include <YSI\y_ini>
#include <sscanf2>
#include <easyDialog>
#include <colors>
#include <progress2>
#include <MPM>
#include <rotcam>
#include <alltextures>
#include <s-art>
#include <xd>
#include <CTime>
//**************************************************************************//
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define ADMIN_Ordinary 1
#define ADMIN_Senior 2
#define ADMIN_Duct 3
#define Owner_Veh_Str "%s\n车主:%s"
#define Temp_Veh_Str "%s\n%s"
#define Tele_Cmd_Str "{00FF80}%s[%d]  传送至%s  %s{82D900}  %s  流量:{FFFFFF}  %i  {82D900}by{FFFFFF}  %s"
#define MAX_TELE_COST_MONEY 500000
#define MAX_SERVER_PLAYERS 3000
#define MAX_USER_TELSE 500
#define NFSize 128
#define PNPC_FILE "资料/随从/%i.ini"
#define FRESH_FILE "资料/食材列表.ini"
#define MUSIC_FILE "资料/音乐/%i.ini"
#define FRESH_PLAYER_FILE "资料/食材/%i.ini"
#define FOOD_PLAYER_FILE "资料/食物/%i.ini"
#define XD_FILE "资料/小岛/%i.ini"
#define CP_FILE "资料/彩票/%i.ini"
#define CP_LIST_FILE "资料/彩票/投彩/%i.ini"
#define ZB_LIST_FILE "资料/仓库/%i.zb"
#define ZBS_LIST_FILE "资料/仓库/资源/%i.zbs"
#define USER_LIST_FILE "资料/用户/%i.db"
#define PRO_FILE "资料/商业/%i.cfg"
#define PRO_STOCK_FILE "资料/商业/存货/%i.inv"
#define USER_WEAPON_FILE "资料/武器/%i.db"
#define USER_PLAYER_LOG_FILE "资料/消息/%i.cfg"
#define USER_FRIEND_FILE "资料/好友/%i.ini"
#define USER_ZB_FILE "资料/装备/%s.ini"
#define OBJ_FILE "资料/模组/%i.pwn"
#define CARS_FILE "资料/爱车/%i.ini"
#define GROUP_FILE "资料/帮派/%i.ini"
#define GROUP_LV_FILE "资料/帮派/阶级/%i.ini"
#define JJ_FILE "资料/家具/%i.ini"
#define JJ_FONT_FILE "资料/家具/文字/%i.ini"
#define HOUSE_FILE "资料/房子/%i.ini"
#define HOUSE_OBJ_FILE "资料/房子/OBJ/%i.pwn"
#define TELES_FILE "资料/传送/%i.ini"
#define FONT_FILE "资料/文字/%i.ini"
#define DAOJU_LIST_FILE "资料/道具/%i.ini"
#define FONT_LINE_FILE "资料/文字/行/%i.ini"
#define CARS_ATT_FILE  "资料/爱车/装备/%i.ini"
#define RACE_FILE "资料/比赛/%i.ini"
#define RACE_PLAYERS_FILE "资料/比赛/玩家出生/%i.ini"
#define RACE_CHACK_FILE "资料/比赛/检查点/%i.ini"
#define RACE_RANK_FILE "资料/比赛/排行/%i.ini"
#define PNG_FILE "资料/贴图/%i.ini"
#define GG_FILE "资料/广告/%i.ini"
#define INT_FILE "资料/房子/内饰.db"
#define DP_FILE "资料/地盘/%i.ini"
#define JIANYI_FILE "资料/建议.ini"
#define CDKWARN_FILE "资料/记录/%i年%i月%i日【充值】.ini"
#define WARN_FILE "资料/记录/%i年%i月%i日【注意】.ini"
#define ANTI_FILE "资料/记录/%i年%i月%i日【反作弊】.ini"
#define Loop(%0,%1) for(new %0 = 0; %0 < %1; %0++)
#define LoopEx(%0,%1,%2) for(new %0 = %1; %0 < %2; %0++)
#define print printEx
#define Function%1(%3) \
                forward %1(%3); \
                public %1(%3)
#define IsValidVehicleModel(%0) \
    ((%0 > 399) && (%0 < 612))
#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))
#define SM(%0,%1) SendClientMessage(playerid,%0,%1)
#define PvailJJ(%0) if(pcurrent_jj[%0]==-1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","该家具已失效", "好的", "")
#define ExtremelyWeak 0
#define VeryWeak 	  1
#define Acceptable    2
#define Strong        3
#define VeryStrong    4
#define H_MOTD "{f2f931}[本地]{ffffff}"
#define H_EP "{f2f931}[广播]{ffffff}"
#define H_SER "{73ea5c}[服务器]{ffffff}"
#define H_CHAT "{00a6cb}[聊天]{ffffff}"
#define H_ME "{f98b8b}[提示]{ffffff}"
#define H_PRO "{ef1616}[商业]{ffffff}"
#define H_ORG "{00a6cb}[帮派]{ffffff}"
#define H_A "{00a6cb}[管理员公告]{ffffff}"
#define H_CP "{dc143c}[彩票]{ffffff}"
#define H_EBUY "{FBFB04}[易购网]{ffffff}"
#define H_MUSICS "{1A80E6}[音悦台]{ffffff}"

#define JJ_TEXECOLOR "{00FFFF}"
//#define ifAdmin(playerid,%0) if(GetadminLevel(playerid)>1&&playerid!=%0&&UID[PU[playerid]][u_Admin]<=UID[PU[%0]][u_Admin])return SM(COLOR_TWTAN,"你没有值班或没有足够的权限使用")
//#define OnLine(%0,%1) if(!AvailablePlayer(%0)&&%0==%1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你没有在登录状态", "好的", ""); else if(!AvailablePlayer(%0)&&%0!=%1)return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒","对方没有不在线", "好的", "")
#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2
new gSpectateID[MAX_PLAYERS];
new gSpectateType[MAX_PLAYERS];
stock Now()
{
	new
		tm <tmToday>
	;
	localtime(time(), tmToday);

	static
		szStr[64]
	;
	strftime(szStr, sizeof(szStr), "%Y%m%d", tmToday);
	return strval(szStr);
}
//**************************************************************************//
native WP_Hash(buffer[], len, const str[]);
//!"#$%&'*\/:<>?|
//**************************************************************************//
new ghour = 0;
new gminute = 0;
new gsecond = 0;
new everymin;
enum uiddate
{
	u_uid,
	u_name[100],
	u_ban,
	u_breason[100],
	u_Pass[129],
	u_zym[80],
	u_zymcol,
    u_Level,
    u_Cash,
    u_Cunkuan,
    u_Score,
    u_Kills,
    u_Deaths,
    Float:u_Armour,
    Float:u_Health,
    u_Wanted,
    u_JYTime,
    u_IsSavePos,
    Float:u_LastX,
    Float:u_LastY,
    Float:u_LastZ,
    Float:u_LastA,
    u_In,
	u_Wl,
	u_Skin,
	u_Admin,
	u_gid,
	u_glv,
	bool:u_reg,
	u_Sil,
	u_color,
	u_irc,
	u_vcoll,
	u_wds,
	u_area,
	u_mode,
	u_hrs,
	u_speed,
	u_realtime,
	u_weather,
	u_vip,
	u_caxin,
	Float:u_hunger
}
new UID[MAX_SERVER_PLAYERS][uiddate];
#define IRC_WORLD 0
#define IRC_GANG  1
#define IRC_LOCAL  3
new Iterator:UID<MAX_SERVER_PLAYERS>;
enum WEAPONINFO
{
	wdid,
	wpid,
	wmodel
}
new WEAPONUID[MAX_SERVER_PLAYERS][13][WEAPONINFO];
new PU[MAX_PLAYERS];
/*
        if(!EnoughMoneyEx(playerid,CM_TELES))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱 $10000", "好的", "");
        Moneyhandle(PU[playerid],-CM_TELES);
 */
#define CM_DIPAN  1000 //创建地盘倍率
#define CM_GANG  10000000 //创建帮派
#define CM_GANGNEMR  90000 //帮派名字
#define CM_GANGLVNEMR  10000 //帮派阶级名字
#define CM_GANGSKIN  10000 //帮派阶级皮肤
#define CM_TELES  500000 //创建传送
#define CM_TELESNAME  10000 //传送名字
#define CM_TELESCMD  10000 //传送指令
#define CM_TELESCOLOR  5000 //传送颜色
#define CM_TELESDINGWEI  10000 //传送定位
#define CM_CGG  100000 //创建广告
#define CM_CGGXF  5000 //续费广告倍率
#define CM_WENZI  1000000 //创建文字


#define EnoughMoney(%0,%1) if(%1>UID[PU[%0]][u_Cash])return SM(COLOR_TWTAN,""H_ME"你没有足够的钱")
stock EnoughMoneyEx(playerid,moneys){ if(moneys>UID[PU[playerid]][u_Cash])return 0;else return 1;}
#define GARTIME 2000
#define GARDECT 3
enum Garinfo
{
	Chatcount,
	Chatmsg[128],
	Chattime,
	Chatkickidx,
	Cmdcount,
	Cmdmsg[80],
	Cmdtime,
	Cmdkickidx,
	keycount,
	keytime,
}
new Garbage[MAX_PLAYERS][Garinfo];
enum teledate
{
	Tid,
	Tuid,
 	Tcreater[100],
 	Tcreatime[128],
 	Tname[128],
 	Float:Tcurrent_X,
 	Float:Tcurrent_Y,
 	Float:Tcurrent_Z,
 	Float:Tcurrent_A,
 	Tcurrent_In,
 	Tcurrent_Wl,
	Tmoney,
	Tpublic,
	Trate,
	Tmoneybox,
	Tcolor,
	Tcmd[100]
}
new Tinfo[MAX_USER_TELSE][teledate];
new Iterator:Tinfo<MAX_USER_TELSE>;
new bool:IsSpawn[MAX_PLAYERS];
new bool:SL[MAX_PLAYERS];
new bool:ADuty[MAX_PLAYERS];
new Admin3D[MAX_PLAYERS];
new bool:pwarn[MAX_PLAYERS];
new Gang3D[MAX_PLAYERS];
new Sell3D[MAX_PLAYERS];
#define MAX_DILOG_LIST 30
new P_page[MAX_PLAYERS];
new current_idx[MAX_PLAYERS][mS_CUSTOM_MAX_ITEMS];
new current_number[MAX_PLAYERS];
#define MAX_JJ 15000
#define MAX_COLOR_3DLABEL MAX_JJ+1000
enum C3dlabeldate
{
	Text3D:C3d_id,
	bool:C3d_isc,
	C3d_text[738],
	C3d_color,
	Float:C3d_x,
	Float:C3d_y,
	Float:C3d_z,
	Float:C3d_drawdistance,
	C3d_attachedplayer,
	C3d_attachedvehicle,
	C3d_worldid,
	C3d_interiorid,
	Float:C3d_streamdistance,
	C3d_time,
	C3d_playerid,
	C3d_testlos,
	C3d_ltime
}
new C3dlabel[MAX_COLOR_3DLABEL][C3dlabeldate];
new Iterator:C3dlabel<MAX_COLOR_3DLABEL>;

#define MAX_FONTS 300
#define MAX_FONTS_LINE 20
enum fontsdate
{
	f_uid,
    f_id,
	f_owner[100],
	Float:f_x,
	Float:f_y,
	Float:f_z,
	f_in,
	f_wl,
    f_color,
	f_iscol,
	f_coltime,
	f_LOS,
	f_Dis
}
new fonts[MAX_FONTS][fontsdate];
new Iterator:fonts<MAX_FONTS>;
enum fontslinedate
{
    fl_str[128]
}
new fonts_line[MAX_FONTS][MAX_FONTS_LINE][fontslinedate];
new Iterator:fonts_line[MAX_FONTS]<MAX_FONTS_LINE>;


#define USER_BAG_FILE "资料/背包/%s.ini"
#define MAX_PLAYER_BEIBAO 151
enum bagdate
{
	b_did,
	b_amout
}
new Beibao[MAX_PLAYERS][MAX_PLAYER_BEIBAO][bagdate];
new Iterator:Beibao[MAX_PLAYERS]<MAX_PLAYER_BEIBAO>;
#define JJ_TYPE_NONE 0
#define JJ_TYPE_TXD 1
#define JJ_TYPE_TEXT 2
#define NONE_TOP 0
#define STORE_TOP 1
#define VB_TOP 2
#define CASH_TOP 3
enum jdate
{
	jid,
	jdid,
	juid,
	Float:jx,
	Float:jy,
	Float:jz,
	Float:jrx,
	Float:jry,
	Float:jrz,
	jin,
	jwl,
	jisellstate,
	jisowner,
	jKey[32],
	bool:jused,
	jtext,
	jiscol,
	jcoltime,
	jtype,
	jtxd,
	jmsize,
	jfont,
	jsize,
	jbold,
	jfcolor,
	jfbcolor,
	jtalg,
	jrotx,
	jroty,
	jrotz,
	jrotspeed,
	jmove,
	jmovespeed,
	jmovestat,
	Float:jmovex,
	Float:jmovey,
	Float:jmovez,
	Float:jmoverx,
	Float:jmovery,
	Float:jmoverz,
	j_phb,
	j_caxin,
	j_phbtop
};
new JJ[MAX_JJ][jdate];
new Iterator:JJ<MAX_JJ>;
#define MAX_JJ_FONT 15

enum JJ_Linedate
{
    JJ_str[80]
}
new JJ_Line[MAX_JJ][MAX_JJ_FONT][JJ_Linedate];
new Iterator:JJ_Line[MAX_JJ]<MAX_JJ_FONT>;
enum sizeEnum
{
    fsize,
    fsizes[64]
}
new g_TextSizes[][sizeEnum] = {
{OBJECT_MATERIAL_SIZE_32x32,"32x32"},
{OBJECT_MATERIAL_SIZE_64x32,"64x32"},
{OBJECT_MATERIAL_SIZE_64x64,"64x64"},
{OBJECT_MATERIAL_SIZE_128x32,"128x32"},
{OBJECT_MATERIAL_SIZE_128x64,"128x64"},
{OBJECT_MATERIAL_SIZE_128x128,"128x128"},
{OBJECT_MATERIAL_SIZE_256x32,"256x32"},
{OBJECT_MATERIAL_SIZE_256x64,"256x64"},
{OBJECT_MATERIAL_SIZE_256x128,"256x128"},
{OBJECT_MATERIAL_SIZE_256x256,"256x256"},
{OBJECT_MATERIAL_SIZE_512x64,"512x64"},
{OBJECT_MATERIAL_SIZE_512x128,"512x128"},
{OBJECT_MATERIAL_SIZE_512x256,"512x256"},
{OBJECT_MATERIAL_SIZE_512x512,"512x512"}
};
new const g_Fonts[][] =
{
	"Arial","黑体","宋体","Arial Black", "Calibri", "Cambria", "Cambria Math", "Candara",
	"Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier",
	"Courier New", "Fixedsys", "Franklin Gothic Medium", "Gabriola", "Georgia",
	"GTAWEAPON3", "Impact", "Lucida Console", "Lucida Sans Unicode",
	"Microsoft Sans Serif", "Modern", "MS Sans Serif", "MS Serif",
	"Palatino Linotype", "Roman", "SampAux3", "Script", "Segoe Print",
	"Segoe Script", "Segoe UI", "Segoe UI Light", "Segoe UI Semibold",
	"Segoe UI Symbol", "Small Fonts", "Symbol", "System", "Tahoma", "Terminal",
	"Times New Roman", "Trebuchet MS", "Webdings", "Verdana", "Wingdings"
};
new pcurrent_jj[MAX_PLAYERS];
#define NO_MODE 0
#define MOVE_JJ_MODE 1
#define EDIT_JJ_MODE 2
#define EDIT_JJ_MOVE_MODE 3
#define EDIT_ATT_MODE 4
#define EDIT_PNG_MODE 5
#define EDIT_CAR_ATT_MODE 6
#define EDIT_RACE_MODE_DW 7
#define EDIT_RACE_MODE_CH 8
#define CJ_ZONE 9
#define EDIT_ZONE 10
#define EDIT_INT 11
#define BT 12
#define ACT 13
#define GUAJI 14
new pstat[MAX_PLAYERS];

enum att_enum
{
	att_did,
	att_id,
	att_type,
	att_modelid,
	att_boneid,
	Float:att_fOffsetX,
	Float:att_fOffsetY,
	Float:att_fOffsetZ,
	Float:att_fRotX,
	Float:att_fRotY,
	Float:att_fRotZ,
	Float:att_fScaleX,
	Float:att_fScaleY,
	Float:att_fScaleZ,
    att_ismater,
	att_materialcolor1,
	att_materialcolor2,
	att_iscol,
	att_jcoltime,
};
new att[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS-1][att_enum];
new Iterator:att[MAX_PLAYERS]<MAX_PLAYER_ATTACHED_OBJECTS-1>;
new AttachmentBones[][24] = {
{"脊柱"},
{"头部"},
{"左上臂"},
{"右上臂"},
{"左手"},
{"右手"},
{"左大腿"},
{"右大腿"},
{"左脚"},
{"右脚"},
{"右小腿"},
{"左小腿"},
{"左前臂"},
{"右前臂"},
{"左锁骨"},
{"右锁骨"},
{"脖子"},
{"下巴"}
};

enum satdate
{
    s_index,
    s_modelid,
    s_bone,
    Float:s_fOffsetX,
    Float:s_fOffsetY,
    Float:s_fOffsetZ,
    Float:s_fRotX,
    Float:s_fRotY,
    Float:s_fRotZ,
    Float:s_fScaleX,
    Float:s_fScaleY,
    Float:s_fScaleZ,
    s_ismater,
    s_materialcolor1,
    s_materialcolor2,
    s_iscol,
    s_time,
    s_ltime
}
new sat[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS-1][satdate];
new Iterator:sat[MAX_PLAYERS]<MAX_PLAYER_ATTACHED_OBJECTS-1>;

new
Float:spawnX[MAX_PLAYERS],
Float:spawnY[MAX_PLAYERS],
Float:spawnZ[MAX_PLAYERS],
Float:spawnA[MAX_PLAYERS];

new Timer:Edit[MAX_PLAYERS];

#define EDIT_MODE_PX		         					0
#define EDIT_MODE_PY                					1
#define EDIT_MODE_PZ		         					2
#define EDIT_MODE_RX                     				3
#define EDIT_MODE_RY                					4
#define EDIT_MODE_RZ                					5
#define EDIT_MODE_SX                					6
#define EDIT_MODE_SY                					7
#define EDIT_MODE_SZ                					8

enum editdate
{
	e_id,
	e_modelid,
	e_boneid,
	Float:o_X,
	Float:o_Y,
	Float:o_Z,

	Float:r_X,
	Float:r_Y,
	Float:r_Z,

	Float:s_X,
	Float:s_Y,
	Float:s_Z,
	editmode
};
new E_dit[MAX_PLAYERS][MAX_OBJECTS][editdate];

new grouptext[MAX_PLAYERS];
#define MAX_GROUP 100
enum gdate
{
    g_gid,
    g_name[128],
	g_uid,
	g_did,
	g_text,
	g_iscol,
	g_model,
	g_pick,
	g_color,
	Float:g_x,
	Float:g_y,
	Float:g_z,
	Float:g_a,
	g_in,
	g_wl,
	g_area
}
new GInfo[MAX_GROUP][gdate];
new Iterator:GInfo<MAX_GROUP>;
#define MAX_GROUP_LV 10
enum Glvdate
{
	g_skin,
	g_lvuname[100]
}
new GlvInfo[MAX_GROUP][MAX_GROUP_LV][Glvdate];
new Iterator:GlvInfo[MAX_GROUP]<MAX_GROUP_LV>;

#define MAX_PLAYERS_VEH 500
#define USER_CAR 0
#define MAX_COM 17
enum vehdate
{
    v_cid,
	v_uid,
	v_did,
	v_gid,
	v_text,
	v_model,
	v_color1,
	v_color2,
	Float:v_x,
	Float:v_y,
	Float:v_z,
	Float:v_a,
	v_in,
	v_wl,
	v_iscol,
	v_time,
	v_lock,
	v_issel,
	v_Value,
	v_Plate[100],
	v_comp[MAX_COM],
	v_Paintjob
}
new VInfo[MAX_PLAYERS_VEH][vehdate];
new Iterator:VInfo<MAX_PLAYERS_VEH>;
new CUID[MAX_VEHICLES];
#define BrushVeh 0
#define RaceVeh 1
#define OwnerVeh 2
new CarTypes[MAX_VEHICLES];
new pbrushcar[MAX_PLAYERS];
new pcarcolor1[MAX_PLAYERS];
new pcarcolor2[MAX_PLAYERS];
new pbrushcartext[MAX_VEHICLES];
new caruid,cardid,cargid,carmod,Float:carx,Float:cary,Float:carz,Float:cara,carwl,carin,carco1,carco2,cariscol,cartime,carlock,Value,Plate[100],issel,comps[MAX_COM],Paintjob;
#define MAX_PLAYERS_VEH_ATT 20
enum Avdate
{
    av_id,
	av_did,
	Float:v_x,
	Float:v_y,
	Float:v_z,
	Float:v_rx,
	Float:v_ry,
	Float:v_rz,
	v_txd
}
new AvInfo[MAX_PLAYERS_VEH][MAX_PLAYERS_VEH_ATT][Avdate];
new Iterator:AvInfo[MAX_PLAYERS_VEH]<MAX_PLAYERS_VEH>;

new Timer:Waittime[MAX_PLAYERS];

new Timer:Dalaytime[MAX_PLAYERS];

#define MAX_RACESS 100
enum RDATE
{
	RACE_ID,
	RACE_UID,
	RACE_NAME[100],
	RACE_PLAYERS,
	RACE_COUNT,
	RACE_TYPE,
	RACE_LAPS,
	RACE_MONEY,
	RACE_SCORE,
	RACE_IN,
	RACE_WL,
	Float:RACE_SIZE,
	RACE_3D,
	Float:RACE_X,
	Float:RACE_Y,
	Float:RACE_Z,
	RACE_MIC,
	RACE_PICK
};
new R_RACE[MAX_RACESS][RDATE];
new Iterator:R_RACE<MAX_RACESS>;
#define MAX_RACESS_PLAYERS 10
enum PRDATE
{
	PRACE_CP,
	Text3D:PRACE_3D,
	Float:PRACE_X,
	Float:PRACE_Y,
	Float:PRACE_Z,
	Float:PRACE_A
};
new P_RACE[MAX_RACESS][MAX_RACESS_PLAYERS][PRDATE];
new Iterator:P_RACE[MAX_RACESS]<MAX_RACESS_PLAYERS>;
#define MAX_RACESS_CHACK 100
enum CRDATE
{
	CRACE_CPID,
	CRACE_CP,
	Text3D:CRACE_3D,
	Float:CRACE_X,
	Float:CRACE_Y,
	Float:CRACE_Z
};
new C_RACE[MAX_RACESS][MAX_RACESS_CHACK][CRDATE];
new Iterator:C_RACE[MAX_RACESS]<MAX_RACESS_CHACK>;
#define MAX_RACESS_RANK 10
enum CRRANK_DATE
{
	RANK_RACE_UID,
	RANK_RACE_RESULT
};
new RANK_RACE[MAX_RACESS][MAX_RACESS_RANK][CRRANK_DATE];
#define MAX_RACE_ROM 50
#define RACE_NULL 0
#define RACE_WAIT 1
#define RACE_COUNTS 2
#define RACE_START 3
enum RRDATE
{
	RACE_ID,
	RACE_UID,
	RACE_IDX,
	RACE_PLAYERS,
	RACE_NAMES[100],
	RACE_STAT,
	Timer:RACE_COUNT_TIME,
	RACE_COUNT,
	RACE_TOP,
	RACE_CAR,
	Timer:RACE_CHACK
};
new RACE_ROM[MAX_RACE_ROM][RRDATE];
new Iterator:RACE_ROM<MAX_RACE_ROM>;
enum rpemu
{
	romid,
	romcp,
	laps,
	pcp,
	times,
	PlayerText:trace,
	pcar,
	pcartext,
	pcout,
	pmic,
};
new pp_race[MAX_PLAYERS][rpemu];
new PlayerBar:speedo[MAX_PLAYERS];
new PlayerBar:chealth[MAX_PLAYERS];
new PlayerBar:chigh[MAX_PLAYERS];
new Text:TDS[3];
new PlayerText:Speedids[MAX_PLAYERS];
new PlayerText:Preview[MAX_PLAYERS];
new PlayerText:Cashmoney[MAX_PLAYERS];
new PlayerText:Bankmoney[MAX_PLAYERS];
new PlayerText:vmoney[MAX_PLAYERS];
new Text:Cashback[5];
new oldcmodel[MAX_PLAYERS];
new Text:SpriteMain[3];
new hrsids[MAX_PLAYERS];
new PlayerText:hrs[MAX_PLAYERS][8];
new hrsdraw[][16] = {
{"ld_otb:hrs1"},
{"ld_otb:hrs2"},
{"ld_otb:hrs3"},
{"ld_otb:hrs4"},
{"ld_otb:hrs5"},
{"ld_otb:hrs6"},
{"ld_otb:hrs7"},
{"ld_otb:hrs8"}
};

#define MAX_MESSAGES 100
#define MESSAGE_COLOR 0x4169E1FF
new bool:message_isopen=true;
new max_message_time=300;
new message_time=0;
enum rmdate
{
	r_uid,
	r_msg[128],
	r_last,
	r_color,
	r_system
}
new RM[MAX_MESSAGES][rmdate];
new Iterator:RM<MAX_MESSAGES>;
#define CUSTOM_BB_MENU 15000
#define CUSTOM_RACE_MENU 15001
#define CUSTOM_DAOJU_MENU 15002
#define CUSTOM_SKIN_MENU 15003
#define CUSTOM_WEAPON_MENU 15004
#define CUSTOM_PRO_SELLBB_MENU 15005
#define CUSTOM_PRO_BUYBB_MENU 15006
#define CUSTOM_PRO_PLAYER_BUYBB_MENU 15007
#define CUSTOM_PRO_PLAYER_SELLBB_MENU 15008
#define CUSTOM_FRIEND_BB_MENU 15009
#define CUSTOM_PRO_EDIT_SELLBB_MENU 15010
#define CUSTOM_PRO_EDIT_BUYBB_MENU 15011
#define CUSTOM_NEAR_JJ_MENU 15012
#define CUSTOM_EBUY_BB_MENU 15013


#define NONEONE 0
#define OWNERS 1
#define SELLING 2
new ppicks[MAX_PLAYERS];
new bool:unpick[MAX_PLAYERS];
#define MAX_INT 200
enum IDATE
{
	I_IDX,
	I_NAME[100],
	Float:I_X,
	Float:I_Y,
	Float:I_Z,
	I_IN
};
new INT[MAX_INT][IDATE];
new Iterator:INT<MAX_INT>;
#define MAX_HOUSE 500
enum HDATE
{
	H_ID,
	H_INTIDX,
	H_UID,
	H_NAMES[100],
	H_iIN,
	H_iWL,
	H_oIN,
	H_oWL,
	H_3D,
	H_3DI,
	Float:H_iX,
	Float:H_iY,
	Float:H_iZ,
	Float:H_iA,
	Float:H_oX,
	Float:H_oY,
	Float:H_oZ,
	Float:H_oA,
	H_iPIC,
	H_oPIC,
	H_MIC,
	H_isCOL,
	H_isSEL,
	H_LOCK,
	H_Value,
	H_PROS,
	H_ISMUSIC,
	H_MUSIC[128]
};
new HOUSE[MAX_HOUSE][HDATE];
new Iterator:HOUSE<MAX_HOUSE>;
#define MAX_HOUSE_OBJ 1000
enum HOBJDATE
{
	HO_ID,
	HO_MODEL,
	Float:HO_X,
	Float:HO_Y,
	Float:HO_Z,
	Float:HO_RX,
	Float:HO_RY,
	Float:HO_RZ,
	HO_IN,
	HO_WL,
	Float:HO_STRDIS,
	Float:HO_DRADIS
};
new HOBJ[MAX_HOUSE][MAX_HOUSE_OBJ][HOBJDATE];
new Iterator:HOBJ[MAX_HOUSE]<MAX_HOUSE_OBJ>;
new isobj[MAX_PLAYERS];

#define MAX_REMOVE_OBJ 2000
enum ROBJDATE
{
	RE_MODEL,
	Float:RE_FX,
	Float:RE_FY,
	Float:RE_FZ,
	Float:HO_FR
};
new ROBJ[MAX_REMOVE_OBJ][ROBJDATE];
new Iterator:ROBJ<MAX_REMOVE_OBJ>;

#define MAX_PNG 50
enum pngdate
{
	png_id,
	png_from[128],
	png_name[128],
	png_uid,
	Float:png_sX,
	Float:png_sY,
	Float:png_sZ,
	Float:png_aX,
	Float:png_aY,
	Float:png_aZ,
	png_WL,
	png_IN,
	Float:png_dist,
	png_type,
	Text3D:png_3d
}
new png[MAX_PNG][pngdate];
new Iterator:png<MAX_PNG>;
#define SCOLOR 1
new colorMenu[]=
{
	0xFFFFFFC8,
	0xFF8040C8,
	0xFFFF00C8,
	0xFFFF80C8,
	0x408080C8,
	0x000080C8,
	0x0000FFC8,
	0x004080C8,
	0x00FFFFC8,
	0x80FFFFC8,
	0x400080C8,
	0x8000FFC8,
	0xFF00FFC8,
	0xFF80FFC8,
	0x808080C8,
	0xFF0000C8,
	0xFF8000C8,
	0x00FF40C8,
	0x400040C8,
	0x800080C8,
	0xC0C0C0C8,
	0
};
new colorMenuEx[][]=
{
	"{FFFFFF}",
	"{FF8040}",
	"{FFFF00}",
	"{FFFF80}",
	"{408080}",
	"{000080}",
	"{0000FF}",
	"{004080}",
	"{00FFFF}",
	"{80FFFF}",
	"{400080}",
	"{8000FF}",
	"{FF00FF}",
	"{FF80FF}",
	"{808080}",
	"{FF0000}",
	"{FF8000}",
	"{00FF40}",
	"{400040}",
	"{800080}",
	"{C0C0C0}",
	"透明"
};

#define MAX_DP 300
enum dpate
{
    dp_name[100],
	dp_area,
	dp_zone,
	dp_uid,
	dp_gid,
	Float:dp_goX,
	Float:dp_goY,
	Float:dp_goZ,
	Float:dp_goA,
	Float:dp_minX,
	Float:dp_minY,
	Float:dp_minZ,
	Float:dp_maxX,
	Float:dp_maxY,
	Float:dp_maxZ,
	dp_isopen,
	dp_passward[100],
	dp_isflash,
	dp_jprotect,
	dp_zprotect,
	dp_wprotect,
	dp_cprotect,
	dp_color,
	dp_colorex,
	dp_mic,
	dp_wl,
	dp_in,
	dp_ismusic,
	dp_musicstr[100]
}
new DPInfo[MAX_DP][dpate];
new Iterator:DPInfo<MAX_DP>;
new playdp[MAX_PLAYERS];


#define MAX_FILE_OBJ 1500
#define MAX_OBJ_FILE 200
enum SOBJDATE
{
	SO_ID,
	SO_MODEL,
	Float:SO_X,
	Float:SO_Y,
	Float:SO_Z,
	Float:SO_RX,
	Float:SO_RY,
	Float:SO_RZ,
	SO_IN,
	SO_WL,
	Float:SO_STRDIS,
	Float:SO_DRADIS
};
new SOBJ[MAX_OBJ_FILE][MAX_FILE_OBJ][SOBJDATE];
new Iterator:SOBJ[MAX_OBJ_FILE]<MAX_FILE_OBJ>;
new S_OBJ[MAX_OBJ_FILE];
new Iterator:S_OBJ<MAX_OBJ_FILE>;

#define TOTAL_SKIN         400
new SkinList[] = {
0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,
50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,
97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,
132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,
167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,
202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,
237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,
272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311
};
new Text:txtTimeDisp;
new hourt, minute,seconds;
new timestr[32];
new last_weather_update=0;
enum weather_info
{
	randomweather_id,
	randomweather_text[18]
};
new fine_weather_ids[][weather_info] =
{
	{0,"Blue Sky"},
	{1,"Blue Sky 2"},
	{2,"Blue Sky 3"},
	{3,"Blue Sky 4"},
	{4,"Blue Sky 5"},
	{5,"Blue Sky 6"},
	{6,"Blue Sky 7"},
	{7,"Blue Sky 8"},
	{10,"Blue Sky 9"},
	{11,"Heatwave"},
	{17,"Heatwave 2"},
	{18,"Heatwave 3"},
	{12,"Dull "},
	{13,"Dull 2"},
	{14,"Dull 3"},
	{15,"Dull 4"},
	{16,"Dull & Rainy"},
	{19,"Sandstorm"},
	{20,"Smog"},
	{23,"Pale Orange"},
	{24,"Pale Orange 2"},
	{25,"Pale Orange 3"},
	{26,"Pale Orange 4"},
	{27,"Fresh Blue "},
	{28,"Fresh Blue 2"},
	{29,"Fresh Blue 3"},
	{30,"Smog"},
	{31,"Smog 2"},
	{32,"Smog 3"},
	{33,"Dark 4"},
	{35,"Dull Brown"},
	{36,"Bright & Foggy"},
	{37,"Bright & Foggy 2"},
	{38,"Bright & Foggy 3"},
//	{39,"Very Bright"},
	{40,"Blue & Cloudy"},
	{41,"Blue & Cloudy 2"}
//	{42,"Blue & Cloudy 3"},
//	{700,"Weed Effect"}
};
enum WEAPON_DATE
{
	W_WID,
	W_MODEL,
	W_SLOT
};
new WEAPON[][WEAPON_DATE] =
{
	{1,331,0},
	{2,333,1},
	{3,334,1},
	{4,335,1},
	{5,336,1},
	{6,337,1},
	{7,338,1},
	{8,339,1},
	{9,341,1},
	{10,321,10},
	{11,322,10},
	{12,323,10},
	{13,324,10},
	{14,325,10},
	{15,326,10},
	{16,342,8},
	{17,343,8},
	{18,344,8},
	{22,346,2},
	{23,347,2},
	{24,348,2},
	{25,349,3},
	{26,350,3},
	{27,351,3},
	{28,352,4},
	{29,353,4},
	{30,355,5},
	{31,356,5},
	{32,372,4},
	{33,357,6},
	{34,358,6},
	{35,359,7},
	{36,360,7},
	{37,361,7},
	{38,362,7},
	{39,363,8},
	{40,364,12},
	{41,365,9},
	{42,366,9},
	{43,367,9},
	{44,368,11},
	{45,369,11}
};

#define MAX_DAOJU 12000
#define DAOJU_TYPE_JIAJU 1
#define DAOJU_TYPE_CAR 2
#define DAOJU_TYPE_WEAPON 3
enum djdate
{
	d_use,
	d_did,
	d_type,
	d_obj,
 	d_name[128],
	d_cash,
	d_issell,
	d_new
}
new Daoju[MAX_DAOJU][djdate];
new Iterator:Daoju<MAX_DAOJU>;
Float:randfloat(max)
{
	new tmp = random(max*1000);
	new Float:result = floatdiv(float(tmp), 1000.0);
	return Float:result;
}
Float:randfloatEx(Float:max)
{
	new tmp = random(floatround(max*1000));
	new Float:result = floatdiv(float(tmp), 1000.0);
	return Float:result;
}
#define AIRBREAK_DISTANCIA 	105.0
enum posemu
{
    pos_tick,
	Float:pos_Pos[3],
	Float:pos_SetPos[3],
};

new	pos_Info[MAX_PLAYERS][posemu];

/*#define MAX_ZOM 100
#define MAX_OWNER_ZOM 200
#define MAX_NPC 1000
#define ZOMBIES 0
enum Zomdate
{
	zid,
	Text3D:z3d,
	zname[64],
	zuid,
	zskin,
}
new Zombie[MAX_ZOM][Zomdate];
new Iterator:Zombie<MAX_ZOM>;*/


#define MAX_FRIENDS 50
enum friendemu
{
	fr_uid,
	fr_on,
	fr_dipan,
	fr_dipanid
}
new friends[MAX_SERVER_PLAYERS][MAX_FRIENDS][friendemu];
new Iterator:friends[MAX_SERVER_PLAYERS]<MAX_FRIENDS>;
new Text3D:friend3D[MAX_PLAYERS];
new Text3D:Mode3D[MAX_PLAYERS];

#define MAX_DROP_ITEMS 200
enum dData
{
	DropGunid,
	DropGundid,
	DropGunweapon,
	Float:DropGunPosX,
	Float:DropGunPosY,
	Float:DropGunPosZ,
	DropGunarea,
};
new DropInfo[MAX_DROP_ITEMS][dData];
new Iterator:DropInfo<MAX_DROP_ITEMS>;

#define MAX_PRO 200
#define MAX_PRO_STOCK 100
#define PRO_SELL 0
#define PRO_BANK 1
#define PRO_RACE 2
#define PRO_AREA 3
#define SELL_TYPE 0
#define BUY_TYPE 1
enum prodate
{
	pro_name[100],
	pro_stat,
	pro_open,
	pro_intid,
	pro_uid,
	pro_type,
	pro_iwl,
	pro_iin,
	pro_owl,
	pro_oin,
	Float:pro_ix,
	Float:pro_iy,
 	Float:pro_iz,
 	Float:pro_ia,
 	Float:pro_ox,
 	Float:pro_oy,
 	Float:pro_oz,
 	Float:pro_oa,
 	pro_value,
 	pro_entervalue,
 	pro_cunkuan,
	pro_icol,
 	pro_ipic,
 	pro_opic,
 	pro_mic,
 	pro_i3d,
 	pro_o3d
}
new property[MAX_PRO][prodate];
new Iterator:property<MAX_PRO>;
enum pstockdate
{
	ps_type,
	ps_did,
	ps_amout,
	ps_value,
}
new prostock[MAX_PRO][MAX_PRO_STOCK][pstockdate];
new Iterator:prostock[MAX_PRO]<MAX_PRO_STOCK>;
new protypestr[][]=
{
	"道具店",
	"银行业",
	"赛车馆",
	"派对场所"
};

#define MAX_PLAYER_MSG 100
enum msgemu
{
	msg_see,
	msg_sender[80],
	msg_time[32],
	msg_str[150],
	msg_ismoney,
	msg_money,
	msg_isdj,
	msg_did,
	msg_amout,
	msg_istq,
}
new PMSG[MAX_SERVER_PLAYERS][MAX_PLAYER_MSG][msgemu];
new Iterator:PMSG[MAX_SERVER_PLAYERS]<MAX_PLAYER_MSG>;

#define CPSTAT_START 1
#define CPSTAT_OPEN 2
#define CPSTAT_OVER 3
#define MAX_CAIPIAO 500
enum cpdate
{
	cp_id,
	cp_name[100],
	cp_times[100],
	cp_isopen,
	cp_crash,
	cp_idx1,
	cp_idx2,
	cp_idx3,
	cp_idx4,
	cp_stat,
	cp_uid
}
new caipiao[MAX_CAIPIAO][cpdate];
new Iterator:caipiao<MAX_CAIPIAO>;
#define MAX_CAIPIAOTC 100
enum cpbuydate
{
	cb_uid,
	cb_idx1,
	cb_idx2,
	cb_idx3,
	cb_idx4,
	cb_won
}
new caipiaobuy[MAX_CAIPIAO][MAX_CAIPIAOTC][cpbuydate];
new Iterator:caipiaobuy[MAX_CAIPIAO]<MAX_CAIPIAOTC>;

enum Surfacedate
{
	surid,
	surname[100],
    suruid,
    sursize,
	surmodel,
	surlv,
	Float:surx,
	Float:sury,
	Float:surz,
	Float:surx_off,
	Float:sury_off,
	Float:sur_heightf,
	Float:surx_start,
	Float:sury_start,
	Float:surx_end,
	Float:sury_end,
	Float:surx_rot,
	Float:sury_rot,
	Float:surz_rot,
	surworld,
	surinterior,
	surm_index,
	surtxdid,
	surm_color,
	Text3D:surm_3D
}
new Surface[MAX_SURFACES][Surfacedate];
new Iterator:Surface<MAX_SURFACES>;

#define MAX_CDK 1000
#define CDK_FILE "资料/CDK/tDown.txt"
enum carddate
{
	cdk_cdk[32],
	cdk_vb,
	Float:cdk_money
}
new CDK[MAX_CDK][carddate];
new Iterator:CDK<MAX_CDK>;

#define EBUY_FILE "资料/易购网/%i.txt"
#define MAX_EBUYTHINGS 300
#define EBUY_TYPE_JJ 0
#define EBUY_TYPE_DP 1
#define EBUY_TYPE_WZ 2
#define EBUY_TYPE_CS 3
#define EBUY_TYPE_XD 4
#define EBUY_TYPE_FZ 5
#define EBUY_TYPE_SY 6
#define EBUY_TYPE_VB 7
#define EBUY_TYPE_AC 8
#define EBUY_TYPE_MS 9
new ebuytype[][]=
{
	"{80FFFF}[家具]{FFFFFF}",
	"{00FF40}[地盘]{FFFFFF}",
	"{80FF00}[文字点]{FFFFFF}",
	"{00FFFF}[传送]{FFFFFF}",
	"{00FF00}[小岛]{FFFFFF}",
	"{FFFF80}[房子]{FFFFFF}",
	"{FF8000}[商业]{FFFFFF}",
	"{80FF80}[V币]{FFFFFF}",
	"{FF80FF}[爱车]{FFFFFF}",
	"{FF8000}[美食]{FFFFFF}"
};
enum ebuydate
{
	e_seq,
	e_uid,
	e_type,
	e_did,
	e_amout,
	e_value,
}
new Ebuy[MAX_EBUYTHINGS][ebuydate];
new Iterator:Ebuy<MAX_EBUYTHINGS>;

#define MAX_AFK_TIME 			30
#define LABEL_DRAW_DISTANCE     50.0
new playerupdate[MAX_PLAYERS];
new Text3D:AFKLabel[MAX_PLAYERS];
new ffdtopen=0;
enum ffdtdate
{
	Text3D:ff_3d1,
	Text3D:ff_3d2,
	ff_did,
	ff_pick,
	ff_amout,
	ff_max
}
new ffdt[ffdtdate];
new ffdtarea;
new JYarea;
new Float:oldpos[3];

enum gujiainfo
{
	Float:g_xx,
	Float:g_yy,
	Float:g_zz,
	g_level,
	g_picks,
	g_playerid,
	Text3D:g_text
};
new guaji[][gujiainfo]=
{
	{2000.5,1538.731567,12.815936,3},
	{1998.5,1538.731567,12.815936,2},
	{2002.5,1538.731567,12.815936,1}
};
#define VERGET     0
#define MEAT       1
enum freshinfo
{
	fresh_name[18],
	fresh_type,
	fresh_sell,
	fresh_amout,
	Float:fresh_usefuel
};
new fresh[][freshinfo] =
{
	{"白菜",0},
	{"芹菜",0},
	{"韭菜",0},
	{"油麦菜",0},
	{"空心菜",0},
	{"菠菜",0},
	{"生菜",0},
	{"木耳",0},
	{"猪肉",1},
	{"羊肉",1},
	{"牛肉",1},
	{"鸡肉",1},
	{"狗肉",1},
	{"人肉",1}
};
/*new fresh[][freshinfo] =
{
	{0.1,"白菜",0},
	{0.2,"芹菜",0},
	{0.3,"韭菜",0},
	{0.4,"油麦菜",0},
	{0.5,"空心菜",0},
	{0.6,"菠菜",0},
	{0.7,"生菜",0},
	{0.8,"木耳",0},
	{2.5,"猪肉",1},
	{3.0,"羊肉",1},
	{4.0,"牛肉",1},
	{2.0,"鸡肉",1},
	{3.5,"狗肉",1},
	{5.0,"人肉",1}
};*/
#define MAX_PLAYER_FRESH 50
enum pfreshemu
{
	pfresh_did,
	pfresh_amout
}
new pfresh[MAX_SERVER_PLAYERS][MAX_PLAYER_FRESH][pfreshemu];
new Iterator:pfresh[MAX_SERVER_PLAYERS]<MAX_PLAYER_FRESH>;

#define MAX_PLAYER_FOOD 800
enum pfoodemu
{
	pfoode_name[100],
	Float:pfoode_usefuel,
	pfoode_uid
}
new pfood[MAX_PLAYER_FOOD][pfoodemu];
new Iterator:pfood<MAX_PLAYER_FOOD>;

#define MAX_CAIDAN 20
enum caidanemu
{
	caidan_did
}
new caidan[MAX_PLAYERS][MAX_CAIDAN][caidanemu];
new Iterator:caidan[MAX_PLAYERS]<MAX_CAIDAN>;
#define Speed_Hack 0
#define AirBreak_Hack 1
#define Weapon_Hack 2
#define Money_Hack 3
#define Chat_Garbage 4
#define CMD_Garbage 5
#define Version_Garbage 6
#define Dalay_Garbage 7
#define Fuck_Garbage 8
#define Ffdt_Garbage 9

#define MAX_MONEY 99999999

#define MAX_MUSIC 500
enum EMUSIC
{
	music_uid,
	music_str[129],
	music_name[100],
	music_cash
}
new MUSICS[MAX_MUSIC][EMUSIC];
new Iterator:MUSICS<MAX_MUSIC>;
new bool:ismusictime;
new musictime;
new musicid=-1;

#define MAX_FJJ 19901
enum fjjdate
{
	fjj_did,
	fjj_model
}
new fjjdaoju[MAX_FJJ][fjjdate];
new Iterator:fjjdaoju<MAX_FJJ>;

new bool:pyz[MAX_PLAYERS];
new Serveryzm[16];
new yzm[][] = { {"a"}, {"b"}, {"c"}, {"d"}, {"e"}, {"f"}, {"g"}, {"h"}, {"i"}, {"j"}, {"k"}, {"l"}, {"m"}, {"n"}, {"o"}, {"p"}, {"q"}, {"r"}, {"s"}, {"t"}, {"u"}, {"v"}, {"w"}, {"x"}, {"y"}, {"z"}, {"0"}, {"1"}, {"2"}, {"3"}, {"4"}, {"5"}, {"6"}, {"7"}, {"8"}, {"9"}};
stock YZMprint()
{
	new yz[3];
	yz[0]=RandomEx(sizeof(yzm),0);
	yz[1]=RandomEx(sizeof(yzm),0);
	yz[2]=RandomEx(sizeof(yzm),0);
	format(Serveryzm,16,"%s%s%s",yzm[yz[0]],yzm[yz[1]],yzm[yz[2]]);
	foreach(new i:Player)
	{
	    if(AvailablePlayer(i))pyz[i]=true;
	    GameTextForPlayer(i,Serveryzm,600000, 3);
	    SendClientMessage(i,COLOR_TWTAN,"请30秒内输入屏幕显示的字符,输入正确将获得$2000");
	}
	defer endyzm[30000]();
	return 1;
}
timer endyzm[30000]()
{
	foreach(new i:Player)
	{
		pyz[i]=false;
        GameTextForPlayer(i," ",1000, 3);
	}
    return 1;
}
//**************************************************************************//
#include "../include/gl_common.inc"
//#include "../include/onplayerjump.inc"
#include <WLOAD>
//#include npc.pwn
#include zb.pwn
#include anti.pwn
#include drop.pwn
#include Cmd.pwn
#include Dialog.pwn
#include race.pwn
#include test.pwn
#include gang.pwn
#include txd.pwn
#include png.pwn
#include admin.pwn
#include house.pwn
#include car.pwn
#include dipan.pwn
#include obj.pwn
#include textdraw.pwn
#include event.pwn
#include friends.pwn
#include property.pwn
#include plog.pwn
#include cp.pwn
#include xd.pwn
#include ebuy.pwn
#include hunger.pwn
#include music.pwn
//**************************************************************************//

main()
{
	SendRconCommand("hostname ◆微光城市-维纳斯◆0.3.7-RC4");
	SendRconCommand("gamemodetext 高级休闲/自由/家具服");
	SendRconCommand("mapname 微光X30");
	SendRconCommand("weburl Q群:67125480");
	
	txtTimeDisp = TextDrawCreate(565.0,5.0,"00:00");
	TextDrawUseBox(txtTimeDisp, 0);
	TextDrawFont(txtTimeDisp, 2);
	TextDrawSetShadow(txtTimeDisp,0);
    TextDrawSetOutline(txtTimeDisp,1);
    TextDrawBackgroundColor(txtTimeDisp,0x000000C8);
    TextDrawColor(txtTimeDisp,0xC0C0C0C8);
    TextDrawAlignment(txtTimeDisp,2);
	TextDrawLetterSize(txtTimeDisp,0.7,1.5);

	TDS[0] = TextDrawCreate(555.000000, 286.5, "~n~~n~~n~");
	TextDrawBackgroundColor(TDS[0], 255);
	TextDrawFont(TDS[0], 1);
	TextDrawLetterSize(TDS[0], 1.110000, 5.6);
	TextDrawColor(TDS[0], -1);
	TextDrawSetOutline(TDS[0], 0);
	TextDrawSetProportional(TDS[0], 1);
	TextDrawSetShadow(TDS[0], 1);
	TextDrawUseBox(TDS[0], 1);
	TextDrawBoxColor(TDS[0],100);
	TextDrawTextSize(TDS[0], 628.000000, 0.000000);
	TextDrawHideForAll(TDS[0]);

	TDS[1] = TextDrawCreate(560.000000, 331.000000, "~n~~n~~n~");
	TextDrawBackgroundColor(TDS[1], 255);
	TextDrawFont(TDS[1], 1);
	TextDrawLetterSize(TDS[1], 0.670000, 3.799999);
	TextDrawColor(TDS[1], -1);
	TextDrawSetOutline(TDS[1], 0);
	TextDrawSetProportional(TDS[1], 1);
	TextDrawSetShadow(TDS[1], 1);
	TextDrawUseBox(TDS[1], 1);
	TextDrawBoxColor(TDS[1],50);
	TextDrawTextSize(TDS[1], 623, 0.000000);
	TextDrawHideForAll(TDS[1]);
	SpriteMains();
	createtab();
	Fexist();
	gettime(ghour, gminute, gsecond);
}
#undef MAX_PLAYERS
#define MAX_PLAYERS 100
new ticks[3];
stock SpriteMains()
{
	SpriteMain[0] = TextDrawCreate(-0.500, -0.500, "load0uk:load0uk");
    TextDrawFont(SpriteMain[0], 4);
    TextDrawTextSize(SpriteMain[0], 640.000, 448.000);
    TextDrawColor(SpriteMain[0], -1);
	SpriteMain[1] = TextDrawCreate(-0.500, -0.500, "loadsc0:loadsc0");
    TextDrawFont(SpriteMain[1], 4);
    TextDrawTextSize(SpriteMain[1], 640.000, 448.000);
    TextDrawColor(SpriteMain[1], -1);
	SpriteMain[2] = TextDrawCreate(-0.500, -0.500, "loadscs:eax");
    TextDrawFont(SpriteMain[2], 4);
    TextDrawTextSize(SpriteMain[2], 640.000, 448.000);
    TextDrawColor(SpriteMain[2], -1);
    
	Cashback[0] = TextDrawCreate(496.000000, 79.000000, "0000");
	TextDrawBackgroundColor(Cashback[0], 255);
	TextDrawFont(Cashback[0], 1);
	TextDrawLetterSize(Cashback[0], 0.500000, 4.099998);
	TextDrawColor(Cashback[0], 255);
	TextDrawSetOutline(Cashback[0], 0);
	TextDrawSetProportional(Cashback[0], 1);
	TextDrawSetShadow(Cashback[0], 1);
	TextDrawUseBox(Cashback[0], 1);
	TextDrawBoxColor(Cashback[0], 255);
	TextDrawTextSize(Cashback[0], 609.000000, 1.000000);

	Cashback[1] = TextDrawCreate(486.000000, 73.000000, "--------------------");
	TextDrawBackgroundColor(Cashback[1], 255);
	TextDrawFont(Cashback[1], 1);
	TextDrawLetterSize(Cashback[1], 0.450000, 1.000000);
	TextDrawColor(Cashback[1], -1);
	TextDrawSetOutline(Cashback[1], 1);
	TextDrawSetProportional(Cashback[1], 1);

	Cashback[2] = TextDrawCreate(486.000000, 123.000000, "--------------------");
	TextDrawBackgroundColor(Cashback[2], 255);
	TextDrawFont(Cashback[2], 1);
	TextDrawLetterSize(Cashback[2], 0.450000, 1.000000);
	TextDrawColor(Cashback[2], -1);
	TextDrawSetOutline(Cashback[2], 1);
	TextDrawSetProportional(Cashback[2], 1);

	Cashback[3] = TextDrawCreate(486.000000, 64.000000, "I");
	TextDrawBackgroundColor(Cashback[3], 255);
	TextDrawFont(Cashback[3], 1);
	TextDrawLetterSize(Cashback[3], 0.240000, 8.199999);
	TextDrawColor(Cashback[3], -1);
	TextDrawSetOutline(Cashback[3], 1);
	TextDrawSetProportional(Cashback[3], 1);

	Cashback[4] = TextDrawCreate(618.000000, 64.000000, "I");
	TextDrawBackgroundColor(Cashback[4], 255);
	TextDrawFont(Cashback[4], 1);
	TextDrawLetterSize(Cashback[4], 0.230000, 8.199995);
	TextDrawColor(Cashback[4], -1);
	TextDrawSetOutline(Cashback[4], 1);
	TextDrawSetProportional(Cashback[4], 1);
	
	return 1;
}
stock hrsmain(playerid)
{
    Loop(i,8)
    {
		hrs[playerid][i] = CreatePlayerTextDraw(playerid,50, 260, hrsdraw[i]);
		PlayerTextDrawLetterSize(playerid,hrs[playerid][i], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid,hrs[playerid][i], 80.579788, 80.583330);
		PlayerTextDrawAlignment(playerid,hrs[playerid][i], 1);
		PlayerTextDrawColor(playerid,hrs[playerid][i], -1);
		PlayerTextDrawSetShadow(playerid,hrs[playerid][i], 0);
		PlayerTextDrawSetOutline(playerid,hrs[playerid][i], 0);
		PlayerTextDrawFont(playerid,hrs[playerid][i], 4);
		//PlayerTextDrawSetSelectable(playerid,hrs[playerid][i], true);
    }

	Cashmoney[playerid] = CreatePlayerTextDraw(playerid,490.000000, 80.000000, "$000000000");
	PlayerTextDrawBackgroundColor(playerid,Cashmoney[playerid], 255);
	PlayerTextDrawFont(playerid,Cashmoney[playerid], 3);
	PlayerTextDrawLetterSize(playerid,Cashmoney[playerid], 0.609999, 1.700000);
	PlayerTextDrawColor(playerid,Cashmoney[playerid], -65281);
	PlayerTextDrawSetOutline(playerid,Cashmoney[playerid], 1);
	PlayerTextDrawSetProportional(playerid,Cashmoney[playerid], 1);
	
	Bankmoney[playerid] = CreatePlayerTextDraw(playerid,490.000000, 94.000000, "$000000000");
	PlayerTextDrawBackgroundColor(playerid,Bankmoney[playerid], 255);
	PlayerTextDrawFont(playerid,Bankmoney[playerid], 3);
	PlayerTextDrawLetterSize(playerid,Bankmoney[playerid], 0.609999, 1.700000);
	PlayerTextDrawColor(playerid,Bankmoney[playerid], -16711681);
	PlayerTextDrawSetOutline(playerid,Bankmoney[playerid], 1);
	PlayerTextDrawSetProportional(playerid,Bankmoney[playerid], 1);

	vmoney[playerid] = CreatePlayerTextDraw(playerid,490.000000, 108.000000, "V000000000");
	PlayerTextDrawBackgroundColor(playerid,vmoney[playerid], 255);
	PlayerTextDrawFont(playerid,vmoney[playerid], 3);
	PlayerTextDrawLetterSize(playerid,vmoney[playerid], 0.609999, 1.700000);
	PlayerTextDrawColor(playerid,vmoney[playerid], -16776961);
	PlayerTextDrawSetOutline(playerid,vmoney[playerid], 1);
	PlayerTextDrawSetProportional(playerid,vmoney[playerid], 1);
	return 1;
}
Random(min, max)//产生随机数
{
	if(min == max)return min;
	if(min > max)return min;
	new a = random(max - min) + min;
	return a;
}
RandomWeather()
{
	new newweather;
	new str[128];
	if(Random(1,10) > 7 )
	{
		newweather = Random(0,43);
		if (newweather > 24 || newweather == 13 || newweather == 14 || newweather == 15 )newweather = 0;
	}
	new weather = newweather;
	format(str,sizeof(str),"城市的天气改变了(%d)",weather);
	SendClientMessageToAll(COLOR_WHITE,str);
	SetWeather(weather);
	return 1;
}
PreLoadAnim(playerid)
{
	PreloadAnimLib(playerid,"BOMBER");
	PreloadAnimLib(playerid,"RAPPING");
	PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
	PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"PED");
}
PreloadAnimLib(playerid, animlib[])ApplyAnimation(playerid,animlib,"null",0.0,0,0,0,0,0);
stock Fexist()
{
    if(!fexist(JIANYI_FILE))
	{
		new File:log = fopen(JIANYI_FILE,io_readwrite );
		fclose(log);
	}
}
stock ClaerGarbage(playerid)
{
    Garbage[playerid][Chatcount]=GetTickCount();
    format(Garbage[playerid][Chatmsg],128,"");
    Garbage[playerid][Chattime]=0;
    Garbage[playerid][Chatkickidx]=0;
    
    Garbage[playerid][Cmdcount]=GetTickCount();
    format(Garbage[playerid][Cmdmsg],80,"");
    Garbage[playerid][Cmdtime]=0;
    Garbage[playerid][Cmdkickidx]=0;

    Garbage[playerid][keycount]=GetTickCount();
    Garbage[playerid][keytime]=0;
    return 1;
}
stock UpdateGarbage(playerid)
{
 /* Garbage[playerid][Chatcount]++;
    Garbage[playerid][Cmdcount]++;*/
}
public OnGameModeInit()
{
    wdloadInit();
	ShowPlayerMarkers(1);
	LimitPlayerMarkerRadius(99999999999999.0);
	ShowNameTags(1);
	UsePlayerPedAnims();
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
    AllowInteriorWeapons(0);
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT,1000);
	Iter_Init(JJ_Line);
 	Iter_Init(P_RACE);
 	Iter_Init(C_RACE);
 	Iter_Init(sat);
 	Iter_Init(att);
	Iter_Init(fonts_line);
	Iter_Init(Beibao);
 	Iter_Init(AvInfo);
 	Iter_Init(GlvInfo);
 	Iter_Init(HOBJ);
 	Iter_Init(SOBJ);
 	Iter_Init(friends);
 	Iter_Init(prostock);
 	Iter_Init(PMSG);
 	Iter_Init(Pzbs);
 	Iter_Init(caipiaobuy);
 	Iter_Init(pfresh);
 	Iter_Init(caidan);
 	ticks[0]=GetTickCount();
	LoadOBJ_Data();
	printf("\t载入OBJ - %i 个",CountDynamicObjects());
	printf("\t玩家总数 - %i 名",LoadUid_Data());
	printf("\t仓库总数 - %i 个",LoadZB_Data());
	printf("\t传送总数 - %i 个",LoadTel_data());
	printf("\t帮派总数 - %i 个",LoadGroup_Data());
	printf("\t文字总数 - %i 个",LoadFont_data());
	printf("\t道具总数 - %i 个",LoadDaoju_Data());
	printf("\t家具总数 - %i 个",LoadJJ_data());
	printf("\t爱车总数 - %i 个",LoadVeh_Data());
	printf("\t赛道总数 - %i 个",LoadRACE_Data());
	printf("\t贴图总数 - %i 个",LoadPNG_Data());
	printf("\t广告总数 - %i 个",LoadRandomMessage_Data());
	printf("\t内饰总数 - %i 个",LoadINT());
	printf("\t房子总数 - %i 个",Loadhouse_Data());
	printf("\t商业总数 - %i 个",Loadproperty_Data());
	printf("\t地盘总数 - %i 个",LoadDP_Data());
	printf("\t音乐总数 - %i 个",LoadMUSIC_Data());
	printf("\t小岛总数 - %i 个",Loadxd_data());
	printf("\t彩票总数 - %i 个",LoadCP_data());
	printf("\t易购商品 - %i 个",LoadEbuy_Data());
	printf("\t食材列表 - %i 个",Loadfresh());
	printf("\t食物总数 - %i 个",LoadFood_Data());
	printf("\tCDK总数 - %i 个",LoadCDK());
//	printf("\t随从总数 - %i 个",LoadPNPC_Data());
	printf("\tOBJ - %i 个",CountDynamicObjects());
	printf("\tCP - %i 个",CountDynamicCPs());
	printf("\tMAPICON - %i 个",CountDynamicMapIcons());
	printf("\tRACECP - %i 个",CountDynamicRaceCPs());
	printf("\t3Dtext - %i 个",CountDynamic3DTextLabels());
	printf("\tAREAS - %i 个",CountDynamicAreas());
	
	ticks[1]=GetTickCount();
	ticks[2]=ticks[1]-ticks[0];
	printf("\t耗时:%i小时%i分%i秒",floatround(ticks[2]/1000, floatround_ceil)/3600,floatround(ticks[2]/1000, floatround_ceil)%3600/60,floatround(ticks[2]/1000, floatround_ceil)%3600%60);
	UpdateTimeAndWeather();
	//ZombieInit();
	CreateDynamic3DTextLabel("存款\nF键",0xFFFF00C8,1435.3912,-997.8404,1639.8025,20.0);
	CreateDynamic3DTextLabel("取款\nF键",0xFFFF00C8,1431.0264,-998.0081,1639.7957,20.0);
	CreateDynamic3DTextLabel("改名\nF键",0xFF8040C8,1442.2993,-1002.8080,1639.7957,20.0);
	CreateDynamic3DTextLabel("投注站\nF键",0x80FFFFC8,1442.1156,-985.7976,1639.8025,20.0);
	CreateDynamic3DTextLabel("食材批发处\nF键",0x80FFFFC8,968.4280,-1357.8716,13.3502,20.0);
	ffdtarea=CreateDynamicRectangle(297.2796,1476.6061,338.9739,1541.7864,0,0);
	JYarea=CreateDynamicRectangle(-2195.582763,-297.458251,-2011.582763,-73.458236,0,0);
	CreateDynamic3DTextLabel("公用篝火\nF键",0x80FF00C8,2000.420288,1550.631103,12.585935,20.0);
	CreateDynamicObject(19632,2000.420288,1550.631103,12.585935,0,0,0,0,0);

    Loop(s,3)guaji[s][g_playerid]=-1;
	guaji[2][g_picks]=CreateDynamicPickup(19605,1,2002.5,1538.731567,12.815936,0,0);
	guaji[2][g_text]=CreateDynamic3DTextLabel("2号挂机位\n每分钟$1000\n当前无人",0x00FF00C8,2002.5,1538.731567,12.815936,20.0);
	guaji[0][g_picks]=CreateDynamicPickup(19606,1,2000.5,1538.731567,12.815936,0,0);
	guaji[0][g_text]=CreateDynamic3DTextLabel("0号挂机位\n每分钟$3000\n当前无人",0xFFFF00C8,2000.5,1538.731567,12.815936,20.0);
	guaji[1][g_picks]=CreateDynamicPickup(19607,1,1998.5,1538.731567,12.815936,0,0);
	guaji[1][g_text]=CreateDynamic3DTextLabel("1号挂机位\n每分钟$2000\n当前无人",0xFF8000C8,1998.5,1538.731567,12.815936,20.0);
	ismusictime=true;
	musictime=0;
	musicid=-1;
	return 1;
}

stock JJphb(JId,TYPES)
{
	new	Player_ID[50],Top_Info[50],Counts=0;
	new Astr[4128],Str[100];
	switch(TYPES)
	{
		case STORE_TOP:
		{
			foreach(new i:UID)
			{
				HighestTopList(i,UID[i][u_Score], Player_ID, Top_Info, JJ[JId][j_phbtop]);
				Counts++;
			}
			format(Str, sizeof(Str), "积分榜\n");
			if(Counts>0)
			{
				strcat(Astr,Str);
				for(new i;i<JJ[JId][j_phbtop]; i++)
				{
					if(Top_Info[i] <= 0) continue;
					format(Str, sizeof(Str), "名次:%i  姓名:%s  积分:%i\n",i+1,UID[Player_ID[i]][u_name],UID[Player_ID[i]][u_Score]);
					strcat(Astr,Str);
				}
			}
		}
		case VB_TOP:
		{
			foreach(new i:UID)
			{
				HighestTopList(i,UID[i][u_wds], Player_ID, Top_Info, JJ[JId][j_phbtop]);
				Counts++;
			}
			format(Str, sizeof(Str), "V币榜\n");
			if(Counts>0)
			{
				strcat(Astr,Str);
				for(new i;i<JJ[JId][j_phbtop]; i++)
				{
					if(Top_Info[i] <= 0) continue;
					format(Str, sizeof(Str), "名次:%i  姓名:%s  V币:%i\n",i+1,UID[Player_ID[i]][u_name],UID[Player_ID[i]][u_wds]);
					strcat(Astr,Str);
				}
			}
		}
	}
	SetDynamicObjectMaterialText(JJ[JId][jid],0,Astr,g_TextSizes[JJ[JId][jmsize]][fsize],g_Fonts[JJ[JId][jfont]],JJ[JId][jsize],JJ[JId][jbold],ARGB(colorMenu[JJ[JId][jfcolor]]),ARGB(colorMenu[JJ[JId][jfbcolor]]),JJ[JId][jtalg]);
	return 1;
}

public OnGameModeExit()
{
	foreach(new i:png)DestroyArt(png[i][png_id]);
	foreach(new i:UID)Saveduid_data(i);
	printf("UID保存完毕");
	return 1;
}
timer Dalaying[30000](playerid)if(!AvailablePlayer(playerid))OnPlayerCheat(playerid,Dalay_Garbage);
timer waitin[4000](playerid)
{
	SM(COLOR_LIGHTBLUE,"|___________________________________________________________________|\n");
	SM(COLOR_LIGHTBLUE,"SAMP指令:{FFFFFF}/fontsize [-3~5] 调整字体大小 ");
	SM(COLOR_LIGHTBLUE,"SAMP指令:{FFFFFF}/pagesize [10~20] 调整显示行数 ");
	SM(COLOR_CON,"服务器指令:{FF0000}请在步行状态下按{80FF00}H{FF0000}键,选择下方图标即可使用大部分功能");
	SM(COLOR_WHITE,"服务器指令:如果觉得游戏卡顿,请/horse开关动态马 /speed开关速度表 来减轻你的负载");
	SM(COLOR_CON,"更多指令请{FF0000}/help 查看 /cz充值");
	SM(COLOR_LIGHTBLUE,"|___________________________________________________________________|");
	Loop(i,sizeof(SpriteMain))TextDrawHideForPlayer(playerid,SpriteMain[i]);
	new Guid=Getplayeruid(playerid);
	if(Guid==-1)
	{
        new i=Iter_Free(UID);
        if(i==-1)
	    {
		    Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "服务器总人数已到上限，无法进入", "好的", "");
			DelayKick(playerid);
			return 1;
	    }
	    if(fexist(Get_Path(i,7)))
	    {
			printf("账户:%s，UID:%i  发生错误",Gnn(playerid),Guid);
			Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "未知错误,抱歉", "额..", "");
			DelayKick(playerid);
			return 1;
		}
	    Iter_Add(UID,i);
	    UID[i][u_reg]=false;
		PU[playerid]=i;
        new skin=RandomEx(299,0);
        UID[PU[playerid]][u_Skin]=skin;
		SetPlayerSkin(playerid,UID[PU[playerid]][u_Skin]);
		Dialog_Show(playerid, dl_register, DIALOG_STYLE_INPUT, "注册", "{FFFF80}===========================\n更新日志\n1.添加验证码系统,输入正确得$2000\n2.添加家具时限,超过15天不擦新将被自动删除,维修方法按Y，弹出菜单即可\n3.添加玩家时限机制,30天不登陆账户将被删除 /stats查看活跃度\n4.添加音悦台功能/wdyy /llyy\n5.添加爱车车门车窗控制\n6.升级发家具系统,可选择大小范围及个数\n7.部分功能V币降价\n===========================\n{FFFFFF}请输入密码来注册\n请在30秒内注册,否则你将被T", "确定", "取消");
		SetPlayerCameraRotatePos(playerid,spawnX[playerid],spawnY[playerid],spawnZ[playerid],20,0.3,3,1);
		Dalaytime[playerid]=defer Dalaying[30000](playerid);
	}
	else if(Guid!=-1)
	{
		UID[Guid][u_reg]=true;
		if(UID[Guid][u_ban]==0)
		{
		    PU[playerid]=Guid;
			new tm[64];
			format(tm,100,"UID[%i]请登录",Guid);
			Dialog_Show(playerid, dl_login, DIALOG_STYLE_PASSWORD, tm, "{FFFF80}===========================\n更新日志\n1.添加验证码系统,输入正确得$2000\n2.添加家具时限,超过15天不擦新将被自动删除,维修方法按Y，弹出菜单即可\n3.添加玩家时限机制,30天不登陆账户将被删除 /stats查看活跃度\n4.添加音悦台功能/wdyy /llyy\n5.添加爱车车门车窗控制\n6.升级发家具系统,可选择大小范围及个数\n7.部分功能V币降价\n===========================\n{FFFFFF}请输入密码来登录\n请在30秒内登录,否则你将被T", "确定", "取消");
			LoadWeapon(PU[playerid]);
			GvieGun(playerid);
	    	LoadAtt(playerid);
			SetPlayerSkin(playerid,UID[PU[playerid]][u_Skin]);
			SetPlayerCameraRotatePos(playerid,spawnX[playerid],spawnY[playerid],spawnZ[playerid],20,0.3,3,1);
			Dalaytime[playerid]=defer Dalaying[30000](playerid);
		}
		else
		{
			Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "你被封锁了",banidlasttime(Guid), "好的", "");
			DelayKick(playerid);
		}
	}
	else
	{
		printf("账户:%s，UID:%i  发生错误",Gnn(playerid),Guid);
		Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "错误", "未知错误,抱歉", "额..", "");
		DelayKick(playerid);
	}
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid))return 1;
	if(!AvailablePlayer(playerid))
	{
		if(spawnX[playerid]==0.0&&spawnY[playerid]==0.0&&spawnZ[playerid]==0.0)
		{
		    new ridx=RandomEx(sizeof(RandomSpawns),0);
	    	spawnX[playerid]=RandomSpawns[ridx][0];
	    	spawnY[playerid]=RandomSpawns[ridx][1];
	    	spawnZ[playerid]=RandomSpawns[ridx][2];
	    	spawnA[playerid]=RandomSpawns[ridx][3];
		    PlayerPlaySound(playerid, 1097,spawnX[playerid],spawnY[playerid],spawnZ[playerid]);
	    	SetPlayerCameraPos(playerid, spawnX[playerid], spawnY[playerid], spawnZ[playerid]);
			SetPlayerCameraLookAt(playerid, spawnX[playerid], spawnY[playerid], spawnZ[playerid]);
			SetPPos(playerid, spawnX[playerid], spawnY[playerid], spawnZ[playerid]);
			SetPlayerFacingAngle(playerid,spawnA[playerid]);
			SpeedoTd(playerid);
			CreateRaceDraw(playerid);
			Waittime[playerid]=defer waitin[2000](playerid);
		}
	}
	//else SpawnPlayer(playerid);
	return 0;
}

stock Finderrorname(playername[])
{
    Loop(i, sizeof(Name_error))
	{
		if(strfindEx(playername,Name_error[i], true) != -1)return false;
	}
	return true;
}
stock GetPlayerVersionEx(playerid)
{
    new string[40];
    GetPlayerVersion(playerid, string, sizeof(string));
	strdel(string,0,8);
	if(strval(string)<1)OnPlayerCheat(playerid,Version_Garbage);
}
public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
   // GetPlayerVersionEx(playerid);
 	clearstats(playerid);
	TextDrawShowForPlayer(playerid,SpriteMain[random(sizeof(SpriteMain))]);
	SM(COLOR_LIGHTBLUE,"╔═════════════════════════════════════════════════╗");
	SM(COLOR_WHITE,"                                 ★★★欢迎进入微光城市★★★");
	SM(COLOR_WHITE,"                               {FF00FF}●●本服QQ群: 67125480  欢迎 加入●●");
	SM(COLOR_WHITE,"                               {FF00FF}●●Copyright Reserved --- boom  20 15●●");
	SM(COLOR_LIGHTBLUE,"╚═════════════════════════════════════════════════╝");
	SM(COLOR_RED,"{FF0000}公告:本服支持玩家自制房子,要上传房子建筑等，请联系QQ:1223720950");
    spawnX[playerid]=0.0;
    spawnY[playerid]=0.0;
    spawnZ[playerid]=0.0;
	oldcmodel[playerid]=0;
    pp_race[playerid][romid]=-1;
    Spectate[playerid]=-1;
	playdp[playerid]=-1;
    unpick[playerid]=true;
    hrsids[playerid]=0;
	isobj[playerid]=1;
    ppicks[playerid]=-1;
    IsSpawn[playerid]=false;
	ClaerGarbage(playerid);
	DeletePVar(playerid,"listIDA");
	SL[playerid]=false;
	PU[playerid]=-1;
	pcurrent_jj[playerid]=-1;
    ADuty[playerid]=false;
    pstat[playerid]=NO_MODE;
    pwarn[playerid]=false;
	pbrushcar[playerid]=-1;
	pyz[playerid]=false;
	Loop(i,MAX_PLAYER_ATTACHED_OBJECTS)RemovePlayerAttachedObject(playerid, i);
	Gang3D[playerid]=CreateColor3DTextLabel("",-1,0.0,0.0,0.0,15.0,playerid,INVALID_VEHICLE_ID,0,-1,-1,-1,15.0,0,1);
	friend3D[playerid]=CreateDynamic3DTextLabel("",-1,0.0,0.0,-0.3,15.0,playerid,INVALID_VEHICLE_ID,0,-1,-1,-1,15.0);
	Mode3D[playerid]=CreateDynamic3DTextLabel("",-1,0.0,0.0,-0.6,15.0,playerid,INVALID_VEHICLE_ID,0,-1,-1,-1,15.0);
	Admin3D[playerid]=CreateColor3DTextLabel("",0xFF000099,0.0,0.0,0.3,15.0,playerid,INVALID_VEHICLE_ID,0,-1,-1,-1,15.0,0,0);
	Sell3D[playerid]=CreateColor3DTextLabel("",-1,0.0,0.0,0.0,15.0,playerid,INVALID_VEHICLE_ID,0,-1,-1,-1,15.0,0,1);
	AFKLabel[playerid]=CreateDynamic3DTextLabel(" ",0x000000,0.0,0.0,0.5,LABEL_DRAW_DISTANCE,playerid);
	RemovePlayerBuild(playerid);
	hrsmain(playerid);
	wdloadpint(playerid);
	GZoneShowForplayer(playerid);
    gettime(hourt, minute);
    SetPlayerTime(playerid,hourt,minute);
    DBP_Exit(playerid);
	return 1;
}
Function SpeedoTd(playerid)
{
	speedo[playerid]=CreatePlayerProgressBar(playerid,583.8,438.3,25,118.5,0xFFFF00C8,300.0,BAR_DIRECTION_UP);
    HidePlayerProgressBar(playerid,speedo[playerid]);
	chealth[playerid]=CreatePlayerProgressBar(playerid,606.0,438.3,25,118.5,0xFB041DC8,1000.0,BAR_DIRECTION_UP);
    HidePlayerProgressBar(playerid,chealth[playerid]);
	chigh[playerid]=CreatePlayerProgressBar(playerid,627.8,438.3,25,118.5,0xFF80FFC8,500.0,BAR_DIRECTION_UP);
    HidePlayerProgressBar(playerid,chigh[playerid]);
	return 1;
}
stock Gnn(playerid)
{
	new playername[100];
	GetPlayerName_fixed(playerid,playername,100);
	//strlower(playername);
	return playername;
}
stock Gn(playerid)
{
	new playername[100];
	GetPlayerName(playerid,playername,100);
	return playername;
}
strlower( dest[] )
{
    for( new i=0; dest[i]!=0; i++ )
        if( dest[i] > 0x7F ) i+=1;
        else dest[i] = tolower(dest[i]);
}
stock HashPass(text[])
{
    new buf[129];
    WP_Hash(buf, sizeof (buf), text);
    return buf;
}
GetPlayerName_fixed(playerid, name[], len)
{
        new ret = GetPlayerName( playerid, name, len );
        for( new i=0; name[i]!=0; i++ )
                if( name[i]<0 ) name[i] += 256;
        return ret;
}
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
    if(IsPlayerNPC(playerid))return 1;
	foreach(new i:Player)if(AvailablePlayer(i)&&GetPlayerState(i)==PLAYER_STATE_SPECTATING&&gSpectateID[i]==playerid&&gSpectateType[i]==ADMIN_SPEC_TYPE_PLAYER)SetPlayerInterior(i,newinteriorid);
	ClearPlayerStat(playerid,0);
    return 1;
}
stock ClearPlayerStat(playerid,type=1)
{
	switch(pstat[playerid])
	{
	    case MOVE_JJ_MODE:
	    {
	        if(type==1)
	        {
	    		if(pcurrent_jj[playerid]!=-1)
	    		{
					new Float:x,Float:y,Float:z;
					GetPlayerPos(playerid,x,y,z);
					JJ[pcurrent_jj[playerid]][jx]=x;
					JJ[pcurrent_jj[playerid]][jy]=y +0.5;
					JJ[pcurrent_jj[playerid]][jz]=z +0.5;
					JJ[pcurrent_jj[playerid]][jin]=GetPlayerInterior(playerid);
					JJ[pcurrent_jj[playerid]][jwl]=GetPlayerVirtualWorld(playerid);
			        CreateJJ(pcurrent_jj[playerid]);
			        CreateJJtext(pcurrent_jj[playerid]);
			        JJ[pcurrent_jj[playerid]][jused]=false;
			        RemovePlayerAttachedObject(playerid,9);
			        pcurrent_jj[playerid]=-1;
	    		}
	    		pstat[playerid]=NO_MODE;
    		}
	    }
	    case BT:
	    {
            ClearAnimations(playerid);
            RemovePlayerAttachedObject(playerid,9);
            if(IsValidDynamicArea(UID[PU[playerid]][u_area]))
            {
                DestroyDynamicArea(UID[PU[playerid]][u_area]);
                UID[PU[playerid]][u_area]=-1;
            }
            TogglePlayerControllable(playerid,1);
            UpdateColor3DTextLabelText(Sell3D[playerid],-1,"");
            RegulateColor3DTextLabel(Sell3D[playerid],0,1);
    		pstat[playerid]=NO_MODE;
	    }
	    case EDIT_JJ_MODE:
	    {
    		if(pcurrent_jj[playerid]!=-1)
    		{
				SetDynamicObjectPos(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jx],JJ[pcurrent_jj[playerid]][jy],JJ[pcurrent_jj[playerid]][jz]);
				SetDynamicObjectRot(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jrx],JJ[pcurrent_jj[playerid]][jry],JJ[pcurrent_jj[playerid]][jrz]);
				CreateJJtext(pcurrent_jj[playerid]);
				Savedjj_data(pcurrent_jj[playerid]);
				JJ[pcurrent_jj[playerid]][jused]=false;
				pcurrent_jj[playerid]=-1;
    		}
    		pstat[playerid]=NO_MODE;
	    }
	    case EDIT_JJ_MOVE_MODE:
	    {
    		if(pcurrent_jj[playerid]!=-1)
    		{
				SetDynamicObjectPos(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jx],JJ[pcurrent_jj[playerid]][jy],JJ[pcurrent_jj[playerid]][jz]);
				SetDynamicObjectRot(JJ[pcurrent_jj[playerid]][jid],JJ[pcurrent_jj[playerid]][jrx],JJ[pcurrent_jj[playerid]][jry],JJ[pcurrent_jj[playerid]][jrz]);
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
				JJ[pcurrent_jj[playerid]][jused]=false;
				pcurrent_jj[playerid]=-1;
    		}
    		pstat[playerid]=NO_MODE;
	    }
	    case EDIT_ATT_MODE:
	    {
	        stop Edit[playerid];
	        new listid=GetPVarInt(playerid,"ltd");
	        UpdatePlayerAttachedObjectEx(playerid,E_dit[playerid][listid][e_id],E_dit[playerid][listid][e_modelid],E_dit[playerid][listid][e_boneid],
			E_dit[playerid][listid][o_X],E_dit[playerid][listid][o_Y],E_dit[playerid][listid][o_Z],E_dit[playerid][listid][r_X],E_dit[playerid][listid][r_Y],
			E_dit[playerid][listid][r_Z],E_dit[playerid][listid][s_X],E_dit[playerid][listid][s_Y],E_dit[playerid][listid][s_Z],ARGB(colorMenu[att[playerid][listid][att_materialcolor1]]),
			ARGB(colorMenu[att[playerid][listid][att_materialcolor2]]),att[playerid][listid][att_iscol],att[playerid][listid][att_jcoltime]);
            pstat[playerid]=NO_MODE;
	    }
	    case EDIT_PNG_MODE:
	    {
	        stop Edit[playerid];
	        new listid=GetPVarInt(playerid,"ltd");
			DestroyArt(png[listid][png_id]);
			new tmp[256];
			strcat(tmp,"D:\\");
			strcat(tmp,png[listid][png_from]);
			png[listid][png_id]=CreateDynamicArt(tmp,png[listid][png_type],png[listid][png_sX],png[listid][png_sY],png[listid][png_sZ],png[listid][png_aX],png[listid][png_aY],png[listid][png_aZ],png[listid][png_WL],png[listid][png_IN],-1,png[listid][png_dist],0.0);
			format(tmp,256,"%s\nID:%i",png[listid][png_name],listid);
			png[listid][png_3d]=CreateDynamic3DTextLabel(tmp,-1,png[listid][png_sX],png[listid][png_sY],png[listid][png_sZ]-1,png[listid][png_dist],INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0,png[listid][png_WL],png[listid][png_IN],-1,png[listid][png_dist]);
			pstat[playerid]=NO_MODE;
	    }
	    case EDIT_CAR_ATT_MODE:
	    {
	        new Carid=GetPlayerVehicleID(playerid);
	    	if(Carid!=0&&VInfo[CUID[GetPlayerVehicleID(playerid)]][v_uid]==PU[playerid])
	    	{
		        stop Edit[playerid];
		        new listid=GetPVarInt(playerid,"ltd");
		        AttachDynamicObjectToVehicle(AvInfo[CUID[Carid]][listid][av_id],GetPlayerVehicleID(playerid),AvInfo[CUID[Carid]][listid][v_x],AvInfo[CUID[Carid]][listid][v_y],AvInfo[CUID[Carid]][listid][v_z],AvInfo[CUID[Carid]][listid][v_rx],AvInfo[CUID[Carid]][listid][v_ry],AvInfo[CUID[Carid]][listid][v_rz]);
			}
			pstat[playerid]=NO_MODE;
	    }
	    case EDIT_RACE_MODE_DW:
	    {
		    new racrid=GetPVarInt(playerid,"raceid");
			foreach(new i:P_RACE[racrid])
			{
	            DestroyDynamicPickup(P_RACE[racrid][i][PRACE_CP]);
	            DestroyDynamic3DTextLabel(P_RACE[racrid][i][PRACE_3D]);
			}
		    foreach(new i:C_RACE[racrid])
			{
	            DestroyDynamicPickup(C_RACE[racrid][i][CRACE_CP]);
	            DestroyDynamic3DTextLabel(C_RACE[racrid][i][CRACE_3D]);
			}
			Iter_Clear(P_RACE[racrid]);
			Iter_Clear(C_RACE[racrid]);
			Iter_Remove(R_RACE,racrid);
			pstat[playerid]=NO_MODE;
	    }
	    case EDIT_RACE_MODE_CH:
	    {
		    new racrid=GetPVarInt(playerid,"raceid");
			foreach(new i:P_RACE[racrid])
			{
	            DestroyDynamicPickup(P_RACE[racrid][i][PRACE_CP]);
	            DestroyDynamic3DTextLabel(P_RACE[racrid][i][PRACE_3D]);
			}
		    foreach(new i:C_RACE[racrid])
			{
	            DestroyDynamicPickup(C_RACE[racrid][i][CRACE_CP]);
	            DestroyDynamic3DTextLabel(C_RACE[racrid][i][CRACE_3D]);
			}
			Iter_Clear(P_RACE[racrid]);
			Iter_Clear(C_RACE[racrid]);
			Iter_Remove(R_RACE,racrid);
			pstat[playerid]=NO_MODE;
	    }
	    case EDIT_ZONE:
	    {
	        new listid=GetPVarInt(playerid,"ltd");
     		stop Edit[playerid];
     		GangZoneDestroy(DPInfo[listid][dp_zone]);
    		DPInfo[listid][dp_area]=CreateDynamicCube(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_minZ],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY],DPInfo[listid][dp_maxZ],DPInfo[listid][dp_wl],DPInfo[listid][dp_in]);
			DPInfo[listid][dp_zone]=GangZoneCreate(DPInfo[listid][dp_minX],DPInfo[listid][dp_minY],DPInfo[listid][dp_maxX],DPInfo[listid][dp_maxY]);
			GZoneShowForALL(listid);
  			DeletePVar(playerid,"ltd");
  			pstat[playerid]=NO_MODE;
 	    }
 	    case CJ_ZONE:
 	    {
	        new listid=GetPVarInt(playerid,"ltd");
 	        stop Edit[playerid];
	        GangZoneDestroy(DPInfo[listid][dp_zone]);
	        if(IsValidDynamicArea(DPInfo[listid][dp_area]))DestroyDynamicArea(DPInfo[listid][dp_area]);
	        fremove(Get_Path(listid,19));
			Iter_Remove(DPInfo,listid);
            DeletePVar(playerid,"ltd");
            pstat[playerid]=NO_MODE;
 	    }
	}
	if(pp_race[playerid][romid]!=-1)
	{
		RaceRomQuit(playerid,pp_race[playerid][romid]);
		pp_race[playerid][romid]=-1;
	}
	//ClearAnimations(playerid);
	return 1;
}
stock clearstats(playerid)
{
	Iter_Clear(Beibao[playerid]);
	Iter_Clear(sat[playerid]);
	Iter_Clear(att[playerid]);
	stop Waittime[playerid];
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
    if(IsPlayerNPC(playerid))return 1;
	Loop(s,3)
	{
		if(guaji[s][g_playerid]==playerid)
		{
			new tm[100];
			format(tm,100,"%i号挂机位\n每分钟$%i\n当前无人",s,guaji[s][g_level]*1000);
        	UpdateDynamic3DTextLabelText(guaji[s][g_text],-1,tm);
			guaji[s][g_playerid]=-1;
		}
	}
 //   Saveduid_data(PU[playerid]);
	IsSpawn[playerid]=false;
    foreach(new i:Player)if(AvailablePlayer(i)&&GetPlayerState(i)==PLAYER_STATE_SPECTATING&&gSpectateID[i]==playerid&&gSpectateType[i]==ADMIN_SPEC_TYPE_PLAYER)SpawnPlayer(i);
    DBP_Exit(playerid);
	Dialog_Close(playerid);
	stop Waittime[playerid];
    StopPlayerCameraRotate(playerid);
    Loop(i,8)PlayerTextDrawDestroy(playerid,hrs[playerid][i]);
	Loop(x,5)TextDrawHideForPlayer(playerid,Cashback[x]);
    PlayerTextDrawDestroy(playerid,Cashmoney[playerid]);
    PlayerTextDrawDestroy(playerid,Bankmoney[playerid]);
    PlayerTextDrawDestroy(playerid,vmoney[playerid]);
    DestroyRaceDraw(playerid);
    DestroyPlayerProgressBar(playerid,speedo[playerid]);
    DestroyPlayerProgressBar(playerid,chealth[playerid]);
    DestroyPlayerProgressBar(playerid,chigh[playerid]);
    PlayerTextDrawDestroy(playerid,Speedids[playerid]);
    PlayerTextDrawDestroy(playerid,Preview[playerid]);
	DestoryRaceDraw(playerid);
	destorywdload(playerid);
	Hidetab(playerid);
	ClaerGarbage(playerid);
	ClearPlayerStat(playerid);
	pcurrent_jj[playerid]=-1;
	pstat[playerid]=NO_MODE;
    ADuty[playerid]=false;
	ComeOut(playerid,1);
    SL[playerid]=false;
	DeletePVar(playerid,"listIDA");
	Iter_Clear(sat[playerid]);
	Iter_Clear(Beibao[playerid]);
	Iter_Clear(att[playerid]);
	DeleteColor3DTextLabel(Admin3D[playerid]);
	DeleteColor3DTextLabel(Gang3D[playerid]);
	DeleteColor3DTextLabel(Sell3D[playerid]);
	DestroyDynamic3DTextLabel(friend3D[playerid]);
	DestroyDynamic3DTextLabel(AFKLabel[playerid]);
	DestroyDynamic3DTextLabel(Mode3D[playerid]);
	if(pbrushcar[playerid]!=-1)
	{
		DeleteColor3DTextLabel(pbrushcartext[pbrushcar[playerid]]);
		DestroyVehicle(pbrushcar[playerid]);
		pbrushcar[playerid]=-1;
	}
	stop Dalaytime[playerid];
	if(PU[playerid]!=-1&&UID[PU[playerid]][u_reg]==false)
	{
	    UID[PU[playerid]][u_reg]=true;
		if(!fexist(Get_Path(PU[playerid],7)))Iter_Remove(UID,PU[playerid]);
	}
	DeletePVar(playerid,"makefood");
	PU[playerid]=-1;
	return 1;
}
public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid))return 1;
    GetPlayerPos(playerid,oldpos[0],oldpos[1],oldpos[2]);
    Loop(i,11)SetPlayerSkillLevel(playerid,i,0);
    PreLoadAnim(playerid);
    GvieGun(playerid);
    pos_Info[playerid][pos_Pos]=gettime()+4;
    Loop(i,MAX_PLAYER_ATTACHED_OBJECTS)RemovePlayerAttachedObject(playerid, i);
    foreach(new idx:att[playerid])
	{
		UpdatePlayerAttachedObjectEx(playerid,idx,att[playerid][idx][att_modelid],att[playerid][idx][att_boneid],att[playerid][idx][att_fOffsetX],
				 att[playerid][idx][att_fOffsetY],att[playerid][idx][att_fOffsetZ],att[playerid][idx][att_fRotX],att[playerid][idx][att_fRotY],att[playerid][idx][att_fRotZ],
				 att[playerid][idx][att_fScaleX],att[playerid][idx][att_fScaleY],att[playerid][idx][att_fScaleZ],att[playerid][idx][att_materialcolor1],att[playerid][idx][att_materialcolor2],att[playerid][idx][att_iscol],att[playerid][idx][att_jcoltime],att[playerid][idx][att_ismater]);
	}
   	PlayerPlaySound(playerid, 1098,spawnX[playerid],spawnY[playerid],spawnZ[playerid]);
	TextDrawShowForPlayer(playerid,txtTimeDisp);
	SetPlayerSkin(playerid,UID[PU[playerid]][u_Skin]);
//	Printxtcs(playerid);
//	Printacthelp(playerid);
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
//	if(UID[PU[playerid]][u_Admin]<3000)Dialog_Show(playerid, dl_givejianyi, DIALOG_STYLE_INPUT, "SORRY", "对不起，本服务器暂时不开放\n如有好的建议请在下方填写或联系QQ 1223720950  boom", "提出建议", "结束");
	IsSpawn[playerid]=true;
	SendCountUnreadMsg(playerid);
   	UnSpectateVehicle(playerid);
	return 1;
}
IsRaining()
{
	if(weather == 16 || weather == 8)return 1;
	return 0;
}
IsPlayerInWater(playerid)
{
	if( GetPlayerAnimationIndex(playerid)==1250 || (GetPlayerAnimationIndex(playerid)>=1538 && GetPlayerAnimationIndex(playerid)<=1541) )return 1;
	return 0;
}
stock WriteInLog(playerid,string[])
{
	new dateES[3];
	new timeES[3];
	new access[738];
	getdate(dateES[0], dateES[1], dateES[2]);
	gettime(timeES[0], timeES[1], timeES[2]);
	if(fexist(JIANYI_FILE))
	{
		new File:log = fopen(JIANYI_FILE, io_append);
		format(access, sizeof(access), "[%d/%d/%d] - [%02d:%02d:%02d]%s: %s\r\n", dateES[0], dateES[1], dateES[2], timeES[0], timeES[1], timeES[2],Gnn(playerid),string);
		fwrite_utf8(log, access,false);
		return fclose(log);
	}
	return printf("文件不存在");
}
stock WriteWarnInLog(string[],file[])
{
	new dateES[3];
	new timeES[3];
	new access[738];
	getdate(dateES[0], dateES[1], dateES[2]);
	gettime(timeES[0], timeES[1], timeES[2]);
    format(access,738,file,dateES[0], dateES[1], dateES[2]);
	if(fexist(access))
	{
		new File:log = fopen(access, io_append);
		format(access, sizeof(access), "[%d/%d/%d] - [%02d:%02d:%02d]%s: %s\r\n", dateES[0], dateES[1], dateES[2], timeES[0], timeES[1], timeES[2],string);
		fwrite_utf8(log, access,false);
		fclose(log);
	}
	else
	{
		new File:log = fopen(access,io_readwrite );
		format(access, sizeof(access), "[%d/%d/%d] - [%02d:%02d:%02d]%s: %s\r\n", dateES[0], dateES[1], dateES[2], timeES[0], timeES[1], timeES[2],string);
		fwrite_utf8(log, access,false);
		fclose(log);
	}
	return 1;
}
Dialog:dl_givejianyi(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlenEx(inputtext)<1)return Dialog_Show(playerid, dl_givejianyi, DIALOG_STYLE_INPUT, "请填入内容", "对不起，本服务器暂时不开放\n如有好的建议请在下方填写或联系QQ 1223720950  boom", "提出建议", "结束");
		WriteInLog(playerid,inputtext);
        Dialog_Show(playerid, dl_error, DIALOG_STYLE_MSGBOX, "提醒", "感谢您的建议，再见！！", "好的", "");
       	DelayKick(playerid);
	}
	else DelayKick(playerid);
	return 1;
}
Dialog:dl_killme(playerid, response, listitem, inputtext[])
{
	new killerid=GetPVarInt(playerid,"listIDA");
	if(!AvailablePlayer(killerid))return 1;
	if(response)
	{
		SetPlayerPosEx(killerid,-2048.2932,-131.7709,35.2966,346.5033,0,0);
		new msgs[128];
		format(msgs,128,"你杀了%s,被系统送入监狱,监禁%i分钟",Gn(playerid),UID[PU[killerid]][u_JYTime]);
		Dialog_Show(killerid,dl_msg, DIALOG_STYLE_MSGBOX,"监狱",msgs, "额", " ");
	}
	else
	{
		new msgs[128];
		format(msgs,128,"%s放过了你,感恩他吧",Gn(playerid));
		Dialog_Show(killerid,dl_msg, DIALOG_STYLE_MSGBOX,"监狱",msgs, "额", " ");
	}
	return 1;
}
public OnPlayerDeath(playerid, killerid, reason)
{
	if(!AvailablePlayer(playerid))return 1;
    if(IsPlayerNPC(playerid))return 1;
	Loop(s,3)
	{
		if(guaji[s][g_playerid]==playerid)
		{
			new tm[100];
			format(tm,100,"%i号挂机位\n每分钟$%i\n当前无人",s,guaji[s][g_level]*1000);
        	UpdateDynamic3DTextLabelText(guaji[s][g_text],-1,tm);
			guaji[s][g_playerid]=-1;
		}
	}
	foreach(new i:Player)if(AvailablePlayer(i)&&GetPlayerState(i)==PLAYER_STATE_SPECTATING&&gSpectateID[i]==playerid&&gSpectateType[i]==ADMIN_SPEC_TYPE_PLAYER)SpawnPlayer(i);
    Dialog_Close(playerid);
    DBP_Exit(playerid);
	if(killerid!=INVALID_PLAYER_ID&&AvailablePlayer(killerid))
	{
	    SendDeathMessage(killerid,playerid,reason);
        UID[PU[killerid]][u_Kills]++;
		UID[PU[killerid]][u_JYTime]+=3;
		Saveduid_data(PU[killerid]);
		new msgs[128];
		format(msgs,128,"你死亡了,是否把杀死你的%s逮捕进监狱",Gn(killerid));
		SetPVarInt(playerid,"listIDA",killerid);
		Dialog_Show(playerid,dl_killme, DIALOG_STYLE_MSGBOX,"监狱",msgs, "是", "否");
	}
	UID[PU[playerid]][u_Deaths]++;
	Saveduid_data(PU[playerid]);
	DropGun(playerid);
	UnSpectateVehicle(playerid);
	ClearPlayerStat(playerid);
	pcurrent_jj[playerid]=-1;
	pstat[playerid]=NO_MODE;
	TextDrawHideForPlayer(playerid,txtTimeDisp);
	IsSpawn[playerid]=false;
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
	ClearAnimations(playerid);
    SpawnPlayer(playerid);
	return 1;
}
public OnPlayerText(playerid, text[])
{
    if(IsPlayerNPC(playerid))return 0;
    if(!AvailablePlayer(playerid))
	{
		SM(COLOR_TWAQUA,"请登录后再试");
		return 0;
	}
	if(pyz[playerid])
	{
	    if(strlen(Serveryzm)>1)
	    {
	        strlower(text);
	        strlower(Serveryzm);
	    	if(!strcmp(text,Serveryzm, false))
	    	{
	    	    pyz[playerid]=false;
	    	    Moneyhandle(PU[playerid],3000);
	    	    GameTextForPlayer(playerid," ",30000, 4);
	    	    return 0;
	    	}
	    }
	}
	if(UID[PU[playerid]][u_Sil]==1)
	{
		SM(COLOR_TWAQUA,"你已被禁言");
		return 0;
	}
	if(strlenEx(text)<2)
	{
		SM(COLOR_TWAQUA,"字符过少");
		return 0;
	}
	if(!Finderrorname(text))
	{
		OnPlayerCheat(playerid,Fuck_Garbage);
		return 0;
	}
	new struing[256];
	Garbage[playerid][Chatcount]=GetTickCount();
	if(Garbage[playerid][Chatcount]-Garbage[playerid][Chattime]< GARTIME)
	{
	    SM(COLOR_TWAQUA,"请稍等2秒后再发言");
		return 0;
	}
	Garbage[playerid][Chattime]=Garbage[playerid][Chatcount];
	if(strlenEx(text)==strlenEx(Garbage[playerid][Chatmsg])&&!strcmpEx(Garbage[playerid][Chatmsg],text,false))
	{
	    if(Garbage[playerid][Chatkickidx]==GARDECT)
		{
			OnPlayerCheat(playerid,Chat_Garbage);
			return 0;
		}
	    else
	    {
			Garbage[playerid][Chatkickidx]++;
			format(Garbage[playerid][Chatmsg],128,"%s",text);
			format(struing, sizeof(struing), "请不要重复,重复3次,将被禁言,当前%i次",Garbage[playerid][Chatkickidx]);
			SM(COLOR_TWAQUA,struing);
			return 0;
		}
	}
	else Garbage[playerid][Chatkickidx]=0;
	format(Garbage[playerid][Chatmsg],128,"%s",text);
	ReStr(text,0);
	switch(UID[PU[playerid]][u_irc])
	{
		case IRC_WORLD:
		{
			if(UID[PU[playerid]][u_gid]==-1)format(struing, sizeof(struing), ""#H_CHAT"%s%s:%s",colorMenuEx[UID[PU[playerid]][u_color]],Gnn(playerid),text);
			else format(struing, sizeof(struing), ""#H_CHAT"%s[%s][%s]%s%s:%s",colorMenuEx[GInfo[UID[PU[playerid]][u_gid]][g_color]],GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],colorMenuEx[UID[PU[playerid]][u_color]],Gnn(playerid),text);
			if(strlen(UID[PU[playerid]][u_zym])>1)
			{
				new Astr[512],Str[100];
				strcat(Astr,struing);
				format(Str,100,"    %s%s",colorMenuEx[UID[PU[playerid]][u_zymcol]],UID[PU[playerid]][u_zym]);
				strcat(Astr,Str);
				SendMessageToAll(-1,Astr);
			}
			else SendMessageToAll(-1,struing);
		    SetPlayerChatBubble(playerid,text,colorMenu[UID[PU[playerid]][u_color]], 50.0, 5000);
		    printf( "[公屏]%s",struing);
		}
		case IRC_GANG:
		{
		    if(UID[PU[playerid]][u_gid]!=-1)
		    {
	            format(struing, sizeof(struing), ""#H_ORG"%s[%s][%s]%s:%s",colorMenuEx[GInfo[UID[PU[playerid]][u_gid]][g_color]],GInfo[UID[PU[playerid]][u_gid]][g_name],GlvInfo[UID[PU[playerid]][u_gid]][UID[PU[playerid]][u_glv]][g_lvuname],Gnn(playerid),text);
	            SendGangChat(playerid,struing);
	            printf( "[帮派]%s",struing);
            }
            else SM(COLOR_TWAQUA,"你没有帮派");
		}
		case IRC_LOCAL:
		{
			format(struing, sizeof(struing), ""#H_MOTD"%s%s说:%s",colorMenuEx[UID[PU[playerid]][u_color]],Gnn(playerid),text);
		    SetPlayerChatBubble(playerid,text,colorMenu[UID[PU[playerid]][u_color]], 50.0, 5000);
		    ProxDetector(20.0,playerid,struing,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE);
		    printf( "[本地]%s",struing);
		}
	}
	return 0;
}
public OnPlayerCommandReceived(playerid, cmdtext[])
{
    if(IsPlayerNPC(playerid))return 0;
	if(!AvailablePlayer(playerid))
	{
	    SM(COLOR_TWAQUA, "你没有登陆！无法使用");
		return 0;
	}
	Garbage[playerid][Cmdcount]=GetTickCount();
	if(Garbage[playerid][Cmdcount]-Garbage[playerid][Cmdtime]<GARTIME/2)
	{
	    SM(COLOR_TWAQUA,"请稍等1秒后再按指令");
		return 0;
	}
	Garbage[playerid][Cmdtime]=Garbage[playerid][Cmdcount];
	if(!strcmpEx(cmdtext[1],"qrace", false))
	{
	    if(pp_race[playerid][romid]==-1)
	    {
			SM(COLOR_TWAQUA, "你没有在比赛里");
		}
		else 
		{
		    RaceRomQuit(playerid,pp_race[playerid][romid]);
		}
		return 0;
	}
	if(!strcmpEx(cmdtext[1],"duty", false)||!strcmpEx(cmdtext[1],"setmoney", false)||!strcmpEx(cmdtext[1],"lxgl", false)||!strcmpEx(cmdtext[1],"addj", false))
	{
	    if(UID[PU[playerid]][u_Admin]<=0)
	    {
			SM(COLOR_TWAQUA, "你不是管理员");
			return 0;
		}
		else return 1;
	}
	if(!strcmpEx(cmdtext[1],"kill", false))return 1;
	if(pp_race[playerid][romid]!=-1)
	{
		SM(COLOR_TWAQUA, "你正在比赛中,无法使用[/qrace 退出比赛]");
		return 0;
	}
	if(pstat[playerid]>MOVE_JJ_MODE)
	{
		SM(COLOR_TWAQUA, "你正在编辑或出售状态,无法使用");
		return 0;
	}
	return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success)
{
    if(IsPlayerNPC(playerid))return 0;
	if(!success)
	{
		if(cmdtext[0] == '/'&& cmdtext[1])
		{
			if(strlenEx(cmdtext)==strlenEx(Garbage[playerid][Cmdmsg])&&!strcmpEx(Garbage[playerid][Cmdmsg],cmdtext,false))
			{
			    if(Garbage[playerid][Cmdkickidx]==GARDECT)
				{
					OnPlayerCheat(playerid,CMD_Garbage);
					return 0;
				}
				else
				{
					new struing[128];
				    Garbage[playerid][Cmdkickidx]++;
					format(Garbage[playerid][Cmdmsg],80,"%s",cmdtext);
					format(struing, sizeof(struing), "请不要重复,重复3次,将被KICK,当前%i次",Garbage[playerid][Cmdkickidx]);
					SM(COLOR_TWAQUA,struing);
				}
			}
			else Garbage[playerid][Cmdkickidx]=0;
			format(Garbage[playerid][Cmdmsg],80,"%s",cmdtext);
			new cmdtexts[128], idx;
			cmdtexts = strtok(cmdtext,idx);
	  		foreach(new i:Tinfo)
			{
				strlower(cmdtext[1]);
				strlower(Tinfo[i][Tcmd]);
				if(strlen(Tinfo[i][Tcmd])>0)
				{
					if(!strcmp(cmdtext[1],Tinfo[i][Tcmd], false))
					{
					    if(Tinfo[i][Tuid]==PU[playerid])return CmdTeleportPlayer(playerid,Tinfo[i][Tcolor],Tinfo[i][Tcurrent_X],Tinfo[i][Tcurrent_Y],Tinfo[i][Tcurrent_Z],Tinfo[i][Tcurrent_A],Tinfo[i][Tcurrent_In],Tinfo[i][Tcurrent_Wl],Tinfo[i][Tname],Tinfo[i][Tcmd],Tinfo[i][Trate],Tinfo[i][Tcreater]);
						if(Tinfo[i][Tmoney]>0)
						{
				    		SetPVarInt(playerid,"listIDA",i);
				    		new str[100];
				    		format(str, sizeof(str),"%s需要花费$%i,确定要使用?",Tinfo[i][Tname],Tinfo[i][Tmoney]);
				    		Dialog_Show(playerid, dl_cscostmoney, DIALOG_STYLE_MSGBOX, "提醒",str, "使用", "不了");
				    		return 1;
						}
		                Tinfo[i][Trate]++;
						CmdTeleportPlayer(playerid,Tinfo[i][Tcolor],Tinfo[i][Tcurrent_X],Tinfo[i][Tcurrent_Y],Tinfo[i][Tcurrent_Z],Tinfo[i][Tcurrent_A],Tinfo[i][Tcurrent_In],Tinfo[i][Tcurrent_Wl],Tinfo[i][Tname],Tinfo[i][Tcmd],Tinfo[i][Trate],Tinfo[i][Tcreater]);
		               	Savedtel_data(i);
						return 1;
					}
				}
			}
	    }
		SM(COLOR_TWAQUA, "没有此命令哦!提示:/help 玩家指令  /ahelp 管理员指令 /xtcs 系统传送 /acthelp 动作指令");
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(IsPlayerNPC(playerid))return 1;
	SetVehicleParamsForPlayer(vehicleid,playerid,0,0);
	if(!ispassenger)
	{
	    if(CarTypes[vehicleid]==OwnerVeh)
	    {
	        if(VInfo[CUID[vehicleid]][v_uid]!=PU[playerid])
	        {
		    	if(UID[PU[playerid]][u_Score]<100)
		    	{
		    	    new Float:xyz[3];
		    	    GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
		    	    SetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
		    	    SM(COLOR_TWTAN,"你的积分不足100,无法驾驶爱车,请先/c 刷车");
		    	    return 1;
		    	}
		    	switch(VInfo[CUID[vehicleid]][v_issel])
		    	{
		    	    case NONEONE:
		    	    {
			    	    new Float:xyz[3];
			    	    GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
			    	    SetPPos(playerid,xyz[0],xyz[1],xyz[2]);
			    	    SetPVarInt(playerid,"CARID",vehicleid);
						new tm[100];
						format(tm,100,"系统出售%s价格为$%i，是否购买",Daoju[VInfo[CUID[vehicleid]][v_did]][d_name],Daoju[VInfo[CUID[vehicleid]][v_did]][d_cash]);
		            	Dialog_Show(playerid, dl_buysyscar, DIALOG_STYLE_MSGBOX, "提醒",tm, "购买", "不买了");
		            	return 1;
		    	    }
		    	    case SELLING:
		    	    {
			    	    new Float:xyz[3];
			    	    GetPlayerPos(playerid,xyz[0],xyz[1],xyz[2]);
			    	    SetPPos(playerid,xyz[0],xyz[1],xyz[2]);
			    	    SetPVarInt(playerid,"CARID",vehicleid);
		            	new tm[100];
						format(tm,100,"车主%s以%i的价格出售%s，是否购买",UID[VInfo[CUID[vehicleid]][v_uid]][u_name],VInfo[CUID[vehicleid]][v_Value],Daoju[VInfo[CUID[vehicleid]][v_did]][d_name]);
		            	Dialog_Show(playerid, dl_buyplaycar, DIALOG_STYLE_MSGBOX, "提醒",tm, "购买", "不买了");
		            	return 1;
		    	    }
		    	}
	            if(VInfo[CUID[vehicleid]][v_lock])
	            {
	            	SetVehicleParamsForPlayer(vehicleid,playerid,0, 1);
	            	new tm[100];
					format(tm,100,"车主%s已给%s设置车锁，你无法上车",UID[VInfo[CUID[vehicleid]][v_uid]][u_name],Daoju[VInfo[CUID[vehicleid]][v_did]][d_name]);
	            	Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "额", "");
	            	return 1;
	            }
	        }
	    }
	}
	return 1;
}
public OnVehicleDeath(vehicleid, killerid)
{
	/*if(CarTypes[vehicleid]==OwnerVeh)
	{
		SetVehiclePos(vehicleid,VInfo[CUID[vehicleid]][v_x],VInfo[CUID[vehicleid]][v_y],VInfo[CUID[vehicleid]][v_z]);
		GetVehicleZAngle(vehicleid,VInfo[CUID[vehicleid]][v_a]);
	}*/
    return 1;

}
public OnVehicleSpawn(vehicleid)
{
	switch(CarTypes[vehicleid])
	{
	    case OwnerVeh:
	    {
			SetVehiclePos(vehicleid,VInfo[CUID[vehicleid]][v_x],VInfo[CUID[vehicleid]][v_y],VInfo[CUID[vehicleid]][v_z]);
			GetVehicleZAngle(vehicleid,VInfo[CUID[vehicleid]][v_a]);
			ChangeVehicleColor(vehicleid,VInfo[CUID[vehicleid]][v_color1],VInfo[CUID[vehicleid]][v_color2]);
            ModVehicle(vehicleid);
            if(VInfo[CUID[vehicleid]][v_Paintjob]!=-1)ChangeVehiclePaintjob(vehicleid,VInfo[CUID[vehicleid]][v_Paintjob]);
	    }
	}
	return 1;
}
public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(IsPlayerNPC(playerid))return 1;
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(IsPlayerNPC(playerid))return 1;
	if(AvailablePlayer(playerid))
	{
		if(newstate == PLAYER_STATE_DRIVER)
	    {
			if(UID[PU[playerid]][u_speed])
			{
		        TextDrawShowForPlayer(playerid,TDS[0]);
		        TextDrawShowForPlayer(playerid,TDS[1]);
		        ShowPlayerProgressBar(playerid,speedo[playerid]);
		        ShowPlayerProgressBar(playerid,chealth[playerid]);
		        ShowPlayerProgressBar(playerid,chigh[playerid]);
				PlayerTextDrawShow(playerid,Speedids[playerid]);
			}
	        new Carid=GetPlayerVehicleID(playerid);
	        switch(CarTypes[Carid])
	        {
	            case BrushVeh:
	            {
					if(pbrushcar[playerid]==Carid)
			        {
				        new tm[100];
						format(tm,100,"你进入了你刷的%s",VehName[GetVehicleModel(Carid)-400]);
						SM(COLOR_TWTAN, tm);
					}
					else
					{
						new tm[100];
						format(tm,100,"你进入了一辆%s",VehName[GetVehicleModel(Carid)-400]);
						SM(COLOR_TWTAN, tm);
					}
					SM(COLOR_TWTAN,"调颜色1-按N键+小键盘4键");
					SM(COLOR_TWTAN,"调颜色2-按N键+小键盘6键");
	            }
	            case RaceVeh:
	            {
					if(pp_race[playerid][pcar]==Carid)
			        {
						new tm[100];
						format(tm,100,"你进入了比赛用车%s",Daoju[VInfo[CUID[Carid]][v_did]][d_name]);
						SM(COLOR_TWTAN, tm);
						SM(COLOR_TWTAN,"请注意：比赛途中不要下车，否则在一定时间后自动弃权");
	                }
	            }
	            case OwnerVeh:
	            {
		        	if(VInfo[CUID[Carid]][v_uid]==PU[playerid])
		        	{
		        	    new tm[100];
						format(tm,100,"你进入了你的爱车%s",Daoju[VInfo[CUID[Carid]][v_did]][d_name]);
						SM(COLOR_TWTAN, tm);
						SM(COLOR_TWTAN,"按Y键可以设置你的爱车");
						SM(COLOR_TWTAN,"调颜色1-按N键+小键盘4键");
						SM(COLOR_TWTAN,"调颜色2-按N键+小键盘6键");
		        	}
		        	else
		        	{
		        	    if(VInfo[CUID[Carid]][v_lock])SetPlayerHealth(playerid,0.0);
		        	    else
		        	    {
			        	    new tm[100];
							format(tm,100,"你进入了%s的爱车%s",UID[VInfo[CUID[Carid]][v_uid]][u_name],Daoju[VInfo[CUID[Carid]][v_did]][d_name]);
							SM(COLOR_TWTAN, tm);
						}
		        	}
	            }
	        }
	    }
	    else
	    {
			if(UID[PU[playerid]][u_speed])
			{
		        TextDrawHideForPlayer(playerid,TDS[0]);
				TextDrawHideForPlayer(playerid,TDS[1]);
		        HidePlayerProgressBar(playerid,speedo[playerid]);
		        HidePlayerProgressBar(playerid,chealth[playerid]);
		        HidePlayerProgressBar(playerid,chigh[playerid]);
				PlayerTextDrawHide(playerid,Speedids[playerid]);
				PlayerTextDrawHide(playerid,Preview[playerid]);
				oldcmodel[playerid]=0;
			}
	    }
    }
	return 1;
}
stock StrlenV(amout)
{
	new tmps[40];
	if(amout<=999999999)
	{
	    new crashes[32];
		format(crashes,sizeof(crashes),"%i",amout);
		if(strlen(crashes)<9)
		{
		    strcat(tmps,"V");
		    for(new i;i<9-strlen(crashes);i++)
		    {
		        strcat(tmps,"0");
		    }
		    strcat(tmps,crashes);
		}
		if(strlen(crashes)==9)
		{
		    strcat(tmps,"$");
		    strcat(tmps,crashes);
		}
	}
	else
	{
	    strcat(tmps,"$");
	    strcat(tmps,"#########");
	}
	return tmps;
}
stock StrlenCash(amout)
{
	new tmps[40];
	if(amout<=999999999)
	{
	    new crashes[32];
		format(crashes,sizeof(crashes),"%i",amout);
		if(strlen(crashes)<9)
		{
		    strcat(tmps,"$");
		    for(new i;i<9-strlen(crashes);i++)
		    {
		        strcat(tmps,"0");
		    }
		    strcat(tmps,crashes);
		}
		if(strlen(crashes)==9)
		{
		    strcat(tmps,"$");
		    strcat(tmps,crashes);
		}
	}
	else
	{
	    strcat(tmps,"$");
	    strcat(tmps,"#########");
	}
	return tmps;
}
stock SetPlayerMoney(playerid,moneys)
{
	UID[PU[playerid]][u_Cash]=moneys;
	PlayerTextDrawSetString(playerid,Cashmoney[playerid],StrlenCash(UID[PU[playerid]][u_Cash]));
	Saveduid_data(PU[playerid]);
	return 1;
}
stock SetPlayerBankMoney(playerid,moneys)
{
	UID[PU[playerid]][u_Cunkuan]=moneys;
	PlayerTextDrawSetString(playerid,Bankmoney[playerid],StrlenCash(UID[PU[playerid]][u_Cunkuan]));
	Saveduid_data(PU[playerid]);
	return 1;
}
stock SetPlayerV(playerid,moneys)
{
	UID[PU[playerid]][u_wds]=moneys;
	PlayerTextDrawSetString(playerid,vmoney[playerid],StrlenV(UID[PU[playerid]][u_wds]));
	Saveduid_data(PU[playerid]);
	return 1;
}
Function Moneyhandle(PID,amout)
{
	new playr=chackonlineEX(PID);
	if(playr!=-1)
	{
		UID[PID][u_Cash]+=amout;
		PlayerTextDrawSetString(playr,Cashmoney[playr],StrlenCash(UID[PID][u_Cash]));
	}
	else
	{
	    UID[PID][u_Cash]+=amout;
	}
	Saveduid_data(PID);
	return 1;
}
Function Cunkuanhandle(PID,amout)
{
	new playr=chackonlineEX(PID);
	if(playr!=-1)
	{
		UID[PID][u_Cunkuan]+=amout;
		PlayerTextDrawSetString(playr,Bankmoney[playr],StrlenCash(UID[PID][u_Cunkuan]));
	}
	else
	{
	    UID[PID][u_Cunkuan]+=amout;
	}
	Saveduid_data(PID);
	return 1;
}
Function VBhandle(PID,amout)
{
	new playr=chackonlineEX(PID);
	if(playr!=-1)
	{
		UID[PID][u_wds]+=amout;
		PlayerTextDrawSetString(playr,vmoney[playr],StrlenV(UID[PID][u_wds]));
	}
	else
	{
	    UID[PID][u_wds]+=amout;
	}
	Saveduid_data(PID);
	return 1;
}
/*Function Moneyhandle(playerid,amout)
{
	UID[PU[playerid]][u_Cash]+=amout;
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid,UID[PU[playerid]][u_Cash]);
	return 1;
}*/
stock DelayKick(playerid, delay_ms = 1000)defer kickEx[delay_ms](playerid);
stock DelayBan(playerid, delay_ms = 1000)defer BanExE[delay_ms](playerid);
timer kickEx[500](playerid)
{
	Kick(playerid);
	pwarn[playerid]=false;
}
timer BanExE[500](playerid)
{
	Ban(playerid);
}
stock Get_Path(Pathid,type)
{
	new Paths[64];
	switch(type)
	{
		case 0:
		{
    		format(Paths, 64, CARS_FILE, Pathid);
    		return Paths;
		}
		case 1:
		{
    		format(Paths, 64, HOUSE_FILE, Pathid);
    		return Paths;
		}
		case 2:
		{
    		format(Paths, 64, TELES_FILE, Pathid);
    		return Paths;
		}
		case 3:
		{
    		format(Paths, 64, FONT_FILE, Pathid);
    		return Paths;
		}
		case 4:
		{
    		format(Paths, 64, FONT_LINE_FILE, Pathid);
    		return Paths;
		}
		case 5:
		{
    		format(Paths, 64, JJ_FILE, Pathid);
    		return Paths;
		}
		case 6:
		{
    		format(Paths, 64, DAOJU_LIST_FILE, Pathid);
    		return Paths;
		}
		case 7:
		{
    		format(Paths, 64, USER_LIST_FILE, Pathid);
    		return Paths;
		}
		case 8:
		{
    		format(Paths, 64, CARS_ATT_FILE, Pathid);
    		return Paths;
		}
		case 9:
		{
    		format(Paths, 64, GROUP_FILE, Pathid);
    		return Paths;
		}
		case 10:
		{
    		format(Paths, 64, GROUP_LV_FILE, Pathid);
    		return Paths;
		}
		case 11:
		{
    		format(Paths, 64, RACE_FILE, Pathid);
    		return Paths;
		}
		case 12:
		{
    		format(Paths, 64, RACE_PLAYERS_FILE, Pathid);
    		return Paths;
		}
		case 13:
		{
    		format(Paths, 64, RACE_CHACK_FILE, Pathid);
    		return Paths;
		}
		case 14:
		{
    		format(Paths, 64, RACE_RANK_FILE, Pathid);
    		return Paths;
		}
		case 15:
		{
    		format(Paths, 64, PNG_FILE, Pathid);
    		return Paths;
		}
		case 16:
		{
    		format(Paths, 64, GG_FILE, Pathid);
    		return Paths;
		}
		case 17:
		{
    		format(Paths, 64, HOUSE_OBJ_FILE, Pathid);
    		return Paths;
		}
		case 18:
		{
    		format(Paths, 64, JJ_FONT_FILE, Pathid);
    		return Paths;
		}
		case 19:
		{
    		format(Paths, 64, DP_FILE, Pathid);
    		return Paths;
		}
		case 20:
		{
    		format(Paths, 64, OBJ_FILE, Pathid);
    		return Paths;
		}
		case 21:
		{
    		format(Paths, 64, USER_WEAPON_FILE, Pathid);
    		return Paths;
		}
		case 22:
		{
    		format(Paths, 64, USER_FRIEND_FILE, Pathid);
    		return Paths;
		}
		case 23:
		{
    		format(Paths, 64, PRO_FILE, Pathid);
    		return Paths;
		}
		case 24:
		{
    		format(Paths, 64, PRO_STOCK_FILE, Pathid);
    		return Paths;
		}
		case 25:
		{
    		format(Paths, 64, USER_PLAYER_LOG_FILE, Pathid);
    		return Paths;
		}
		case 26:
		{
    		format(Paths, 64, ZB_LIST_FILE, Pathid);
    		return Paths;
		}
		case 27:
		{
    		format(Paths, 64, ZBS_LIST_FILE, Pathid);
    		return Paths;
		}
		case 28:
		{
    		format(Paths, 64, CP_FILE, Pathid);
    		return Paths;
		}
		case 29:
		{
    		format(Paths, 64, CP_LIST_FILE, Pathid);
    		return Paths;
		}
		case 30:
		{
    		format(Paths, 64, XD_FILE, Pathid);
    		return Paths;
		}
		case 31:
		{
    		format(Paths, 64, EBUY_FILE, Pathid);
    		return Paths;
		}
		case 32:
		{
    		format(Paths, 64, FRESH_PLAYER_FILE, Pathid);
    		return Paths;
		}
		case 33:
		{
    		format(Paths, 64, FOOD_PLAYER_FILE, Pathid);
    		return Paths;
		}
		case 34:
		{
    		format(Paths, 64, MUSIC_FILE, Pathid);
    		return Paths;
		}
		case 35:
		{
    		format(Paths, 64, PNPC_FILE, Pathid);
    		return Paths;
		}
	}
	return Paths;
}
//**************************************************************************//

Function LoadUid_Data()
{
	new NameFile[NFSize],idx;
	Loop(i, MAX_SERVER_PLAYERS)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,7), i);
        if(fexist(NameFile))
        {
			INI_ParseFile(NameFile, "LoadUidData", false, true, i, true, false);
			LoadPlayerLog(i);
			LoadFriend(i);
			UID[i][u_area]=-1;
            Iter_Add(UID,i);
            idx++;
		}
	}
    return idx;
}
/*Function LoadUid_Data()
{
	new idx=0;
	Loop(i, MAX_SERVER_PLAYERS)
	{
	    if(fexist(Get_Path(i,7)))
	    {
	    	new iniFile = ini_open (Get_Path(i,7));
	     	if(iniFile==INI_OK)
			{
			    ini_get(iniFile,"用户资料","u_name",UID[i][u_name],100);
			    ini_get_int(iniFile,"用户资料","u_ban",UID[i][u_ban]);
			    ini_get(iniFile,"用户资料","u_breason",UID[i][u_breason],100);
				ini_get(iniFile,"用户资料","u_Pass", UID[i][u_Pass],129);
				ini_get_int(iniFile,"用户资料","u_Level",UID[i][u_Level]);
				ini_get_int(iniFile,"用户资料","u_Cash", UID[i][u_Cash]);
				ini_get_int(iniFile,"用户资料","u_Cunkuan", UID[i][u_Cunkuan]);
				ini_get_int(iniFile,"用户资料","u_Score", UID[i][u_Score]);
				ini_get_int(iniFile,"用户资料","u_Kills", UID[i][u_Kills]);
				ini_get_int(iniFile,"用户资料","u_Deaths", UID[i][u_Deaths]);
				ini_get_float(iniFile,"用户资料","u_Armour", UID[i][u_Armour]);
				ini_get_float(iniFile,"用户资料","u_Health", UID[i][u_Health]);
				ini_get_int(iniFile,"用户资料","u_Wanted", UID[i][u_Wanted]);
				ini_get_int(iniFile,"用户资料","u_Time", UID[i][u_Time]);
				ini_get_int(iniFile,"用户资料","u_IsSavePos", UID[i][u_IsSavePos]);
				ini_get_float(iniFile,"用户资料","u_LastX", UID[i][u_LastX]);
				ini_get_float(iniFile,"用户资料","u_LastY", UID[i][u_LastY]);
				ini_get_float(iniFile,"用户资料","u_LastZ", UID[i][u_LastZ]);
				ini_get_float(iniFile,"用户资料","u_LastA", UID[i][u_LastA]);
				ini_get_int(iniFile,"用户资料","u_In", UID[i][u_In]);
				ini_get_int(iniFile,"用户资料","u_Wl", UID[i][u_Wl]);
				ini_get_int(iniFile,"用户资料","u_Skin", UID[i][u_Skin]);
				ini_get_int(iniFile,"用户资料","u_Admin", UID[i][u_Admin]);
				ini_get_int(iniFile,"用户资料","u_gid", UID[i][u_gid]);
				ini_get_int(iniFile,"用户资料","u_glv", UID[i][u_glv]);
				ini_get_int(iniFile,"用户资料","u_Sil", UID[i][u_Sil]);
				ini_get_int(iniFile,"用户资料","u_color", UID[i][u_color]);
				ini_get_int(iniFile,"用户资料","u_irc", UID[i][u_irc]);
				ini_get_int(iniFile,"用户资料","u_vcoll", UID[i][u_vcoll]);
				ini_get_int(iniFile,"用户资料","u_wds", UID[i][u_wds]);
				ini_get_int(iniFile,"用户资料","u_mode", UID[i][u_mode]);
				ini_get_int(iniFile,"用户资料","u_hrs", UID[i][u_hrs]);
				ini_get_int(iniFile,"用户资料","u_speed", UID[i][u_speed]);
				LoadPlayerLog(i);
				UID[i][u_area]=-1;
	            Iter_Add(UID,i);
	            idx++;
			}
			ini_close(iniFile);
		}
    }
	return idx;
}
Function Saveduid_data(Count)
{
	new iniFile=ini_open(Get_Path(Count,7));
 	ini_set(iniFile,"用户资料","u_name",UID[Count][u_name]);
    ini_set_int(iniFile,"用户资料","u_ban",UID[Count][u_ban]);
    ini_set(iniFile,"用户资料","u_breason",UID[Count][u_breason]);
    ini_set(iniFile, "用户资料","u_Pass", UID[Count][u_Pass]);
    ini_set_int(iniFile,"用户资料", "u_Level",UID[Count][u_Level]);
    ini_set_int(iniFile,"用户资料", "u_Cash", UID[Count][u_Cash]);
    ini_set_int(iniFile,"用户资料", "u_Cunkuan", UID[Count][u_Cunkuan]);
    ini_set_int(iniFile,"用户资料", "u_Score", UID[Count][u_Score]);
    ini_set_int(iniFile,"用户资料", "u_Kills", UID[Count][u_Kills]);
    ini_set_int(iniFile,"用户资料", "u_Deaths", UID[Count][u_Deaths]);
    ini_set_float(iniFile,"用户资料", "u_Armour", UID[Count][u_Armour]);
    ini_set_float(iniFile,"用户资料", "u_Health", UID[Count][u_Health]);
    ini_set_int(iniFile,"用户资料", "u_Wanted", UID[Count][u_Wanted]);
    ini_set_int(iniFile,"用户资料", "u_Time", UID[Count][u_Time]);
    ini_set_int(iniFile,"用户资料", "u_IsSavePos", UID[Count][u_IsSavePos]);
    ini_set_float(iniFile,"用户资料", "u_LastX", UID[Count][u_LastX]);
    ini_set_float(iniFile,"用户资料", "u_LastY", UID[Count][u_LastY]);
    ini_set_float(iniFile,"用户资料", "u_LastZ", UID[Count][u_LastZ]);
    ini_set_float(iniFile,"用户资料", "u_LastA", UID[Count][u_LastA]);
    ini_set_int(iniFile,"用户资料", "u_In", UID[Count][u_In]);
    ini_set_int(iniFile,"用户资料", "u_Wl", UID[Count][u_Wl]);
    ini_set_int(iniFile,"用户资料", "u_Skin", UID[Count][u_Skin]);
    ini_set_int(iniFile,"用户资料", "u_Admin", UID[Count][u_Admin]);
    ini_set_int(iniFile,"用户资料", "u_gid", UID[Count][u_gid]);
    ini_set_int(iniFile,"用户资料", "u_glv", UID[Count][u_glv]);
    ini_set_int(iniFile,"用户资料", "u_Sil", UID[Count][u_Sil]);
    ini_set_int(iniFile,"用户资料", "u_color", UID[Count][u_color]);
    ini_set_int(iniFile,"用户资料", "u_irc", UID[Count][u_irc]);
    ini_set_int(iniFile,"用户资料", "u_vcoll", UID[Count][u_vcoll]);
    ini_set_int(iniFile,"用户资料", "u_wds", UID[Count][u_vcoll]);
    ini_set_int(iniFile,"用户资料", "u_mode", UID[Count][u_mode]);
    ini_set_int(iniFile,"用户资料", "u_hrs", UID[Count][u_hrs]);
    ini_set_int(iniFile,"用户资料", "u_speed", UID[Count][u_speed]);
    ini_close(iniFile);
	return 1;
}*/
Function LoadUidData(i, name[], value[])
{
    INI_String("u_name",UID[i][u_name],100);
    INI_Int("u_ban",UID[i][u_ban]);
    INI_String("u_breason",UID[i][u_breason],100);
	INI_String("u_Pass", UID[i][u_Pass],129);
	INI_String("u_zym", UID[i][u_zym],80);
	INI_Int("u_zymcol",UID[i][u_zymcol]);
	INI_Int("u_Level",UID[i][u_Level]);
	INI_Int("u_Cash", UID[i][u_Cash]);
	INI_Int("u_Cunkuan", UID[i][u_Cunkuan]);
	INI_Int("u_Score", UID[i][u_Score]);
	INI_Int("u_Kills", UID[i][u_Kills]);
	INI_Int("u_Deaths", UID[i][u_Deaths]);
	INI_Float("u_Armour", UID[i][u_Armour]);
	INI_Float("u_Health", UID[i][u_Health]);
	INI_Int("u_Wanted", UID[i][u_Wanted]);
	INI_Int("u_JYTime", UID[i][u_JYTime]);
	INI_Int("u_IsSavePos", UID[i][u_IsSavePos]);
	INI_Float("u_LastX", UID[i][u_LastX]);
	INI_Float("u_LastY", UID[i][u_LastY]);
	INI_Float("u_LastZ", UID[i][u_LastZ]);
	INI_Float("u_LastA", UID[i][u_LastA]);
	INI_Int("u_In", UID[i][u_In]);
	INI_Int("u_Wl", UID[i][u_Wl]);
	INI_Int("u_Skin", UID[i][u_Skin]);
	INI_Int("u_Admin", UID[i][u_Admin]);
	INI_Int("u_gid", UID[i][u_gid]);
	INI_Int("u_glv", UID[i][u_glv]);
	INI_Int("u_Sil", UID[i][u_Sil]);
	INI_Int("u_color", UID[i][u_color]);
	INI_Int("u_irc", UID[i][u_irc]);
	INI_Int("u_vcoll", UID[i][u_vcoll]);
	INI_Int("u_wds", UID[i][u_wds]);
	INI_Int("u_mode", UID[i][u_mode]);
	INI_Int("u_hrs", UID[i][u_hrs]);
	INI_Int("u_speed", UID[i][u_speed]);
	INI_Int("u_realtime", UID[i][u_realtime]);
	INI_Int("u_weather", UID[i][u_weather]);
	INI_Int("u_vip", UID[i][u_vip]);
	INI_Int("u_caxin", UID[i][u_caxin]);
	INI_Float("u_hunger", UID[i][u_hunger]);
	return 1;
}
Function Saveduid_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,7));
    INI_WriteString(File,"u_name",UID[Count][u_name]);
    INI_WriteInt(File,"u_ban",UID[Count][u_ban]);
    INI_WriteString(File,"u_breason",UID[Count][u_breason]);
    INI_WriteString(File, "u_Pass", UID[Count][u_Pass]);
    INI_WriteString(File, "u_zym", UID[Count][u_zym]);
    INI_WriteInt(File, "u_zymcol", UID[Count][u_zymcol]);
    INI_WriteInt(File, "u_Level",UID[Count][u_Level]);
    INI_WriteInt(File, "u_Cash", UID[Count][u_Cash]);
    INI_WriteInt(File, "u_Cunkuan", UID[Count][u_Cunkuan]);
    INI_WriteInt(File, "u_Score", UID[Count][u_Score]);
    INI_WriteInt(File, "u_Kills", UID[Count][u_Kills]);
    INI_WriteInt(File, "u_Deaths", UID[Count][u_Deaths]);
    INI_WriteFloat(File, "u_Armour", UID[Count][u_Armour]);
    INI_WriteFloat(File, "u_Health", UID[Count][u_Health]);
    INI_WriteInt(File, "u_Wanted", UID[Count][u_Wanted]);
    INI_WriteInt(File, "u_JYTime", UID[Count][u_JYTime]);
    INI_WriteInt(File, "u_IsSavePos", UID[Count][u_IsSavePos]);
    INI_WriteFloat(File, "u_LastX", UID[Count][u_LastX]);
    INI_WriteFloat(File, "u_LastY", UID[Count][u_LastY]);
    INI_WriteFloat(File, "u_LastZ", UID[Count][u_LastZ]);
    INI_WriteFloat(File, "u_LastA", UID[Count][u_LastA]);
    INI_WriteInt(File, "u_In", UID[Count][u_In]);
    INI_WriteInt(File, "u_Wl", UID[Count][u_Wl]);
    INI_WriteInt(File, "u_Skin", UID[Count][u_Skin]);
    INI_WriteInt(File, "u_Admin", UID[Count][u_Admin]);
    INI_WriteInt(File, "u_gid", UID[Count][u_gid]);
    INI_WriteInt(File, "u_glv", UID[Count][u_glv]);
    INI_WriteInt(File, "u_Sil", UID[Count][u_Sil]);
    INI_WriteInt(File, "u_color", UID[Count][u_color]);
    INI_WriteInt(File, "u_irc", UID[Count][u_irc]);
    INI_WriteInt(File, "u_vcoll", UID[Count][u_vcoll]);
    INI_WriteInt(File, "u_wds", UID[Count][u_wds]);
    INI_WriteInt(File, "u_mode", UID[Count][u_mode]);
    INI_WriteInt(File, "u_hrs", UID[Count][u_hrs]);
    INI_WriteInt(File, "u_speed", UID[Count][u_speed]);
    INI_WriteInt(File, "u_realtime", UID[Count][u_realtime]);
    INI_WriteInt(File, "u_weather", UID[Count][u_weather]);
    INI_WriteInt(File, "u_vip", UID[Count][u_vip]);
    INI_WriteInt(File, "u_caxin", UID[Count][u_caxin]);
    INI_WriteFloat(File, "u_hunger", UID[Count][u_hunger]);
    INI_Close(File);
	return true;
}
Function Savedtel_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,2));
    INI_WriteString(File,"Tcreater",Tinfo[Count][Tcreater]);
    INI_WriteString(File,"Tcreatime",Tinfo[Count][Tcreatime]);
    INI_WriteString(File,"Tname",Tinfo[Count][Tname]);
    INI_WriteString(File,"Tcmd",Tinfo[Count][Tcmd]);
    INI_WriteFloat(File, "Tcurrent_X",Tinfo[Count][Tcurrent_X]);
    INI_WriteFloat(File, "Tcurrent_Y",Tinfo[Count][Tcurrent_Y]);
    INI_WriteFloat(File, "Tcurrent_Z",Tinfo[Count][Tcurrent_Z]);
    INI_WriteFloat(File, "Tcurrent_A",Tinfo[Count][Tcurrent_A]);
    INI_WriteInt(File, "Tcurrent_In",Tinfo[Count][Tcurrent_In]);
    INI_WriteInt(File, "Tcurrent_Wl",Tinfo[Count][Tcurrent_Wl]);
    INI_WriteInt(File,"Tmoney",Tinfo[Count][Tmoney]);
    INI_WriteInt(File,"Tpublic",Tinfo[Count][Tpublic]);
    INI_WriteInt(File,"Trate",Tinfo[Count][Trate]);
    INI_WriteInt(File,"Tmoneybox",Tinfo[Count][Tmoneybox]);
    INI_WriteInt(File,"Tuid",Tinfo[Count][Tuid]);
    INI_WriteInt(File,"Tcolor",Tinfo[Count][Tcolor]);
    INI_Close(File);
	return true;
}
Function LoadTelData(i, name[], value[])
{
    INI_String("Tcreater",Tinfo[i][Tcreater],100);
    INI_String("Tcreatime",Tinfo[i][Tcreatime],128);
    INI_String("Tname",Tinfo[i][Tname],128);
    INI_String("Tcmd",Tinfo[i][Tcmd],100);
    INI_Float("Tcurrent_X",Tinfo[i][Tcurrent_X]);
    INI_Float("Tcurrent_Y",Tinfo[i][Tcurrent_Y]);
    INI_Float("Tcurrent_Z",Tinfo[i][Tcurrent_Z]);
    INI_Float("Tcurrent_A",Tinfo[i][Tcurrent_A]);
    INI_Int("Tcurrent_In",Tinfo[i][Tcurrent_In]);
    INI_Int("Tcurrent_Wl",Tinfo[i][Tcurrent_Wl]);
    INI_Int("Tmoney",Tinfo[i][Tmoney]);
    INI_Int("Tpublic",Tinfo[i][Tpublic]);
    INI_Int("Trate",Tinfo[i][Trate]);
    INI_Int("Tmoneybox",Tinfo[i][Tmoneybox]);
    INI_Int("Tuid",Tinfo[i][Tuid]);
    INI_Int("Tcolor",Tinfo[i][Tcolor]);
	return 1;
}
Function LoadTel_data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_USER_TELSE)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,2), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,2), "LoadTelData", false, true, i, true, false);
            Tinfo[i][Tid]=i;
 			Iter_Add(Tinfo,i);
 			idx++;
        }
    }
    return idx;
}
Function LoadFont_data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_FONTS)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,3), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,3), "LoadFontData", false, true, i, true, false);
            LoadFontLine(i);
			fonts[i][f_id]=CreateColor3DTextLabel(Showmyfontline(i),colorMenu[fonts[i][f_color]],fonts[i][f_x],fonts[i][f_y],fonts[i][f_z],50,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,fonts[i][f_LOS],fonts[i][f_wl],fonts[i][f_in],-1,100.0,fonts[i][f_iscol],fonts[i][f_coltime]);
 			Iter_Add(fonts,i);
 			idx++;
        }
    }

    return idx;
}
Function SaveWeapon(pid)
{
	new str3[128];
    if(fexist(Get_Path(pid,21)))fremove(Get_Path(pid,21));
	new File:NameFile = fopen(Get_Path(pid,21), io_write);
    Loop(i,13)
  	{
		format(str3,sizeof(str3),"%s %i %i %i\r\n",str3,WEAPONUID[pid][i][wdid],WEAPONUID[pid][i][wpid],WEAPONUID[pid][i][wmodel]);
	}
	fwrite(NameFile,str3);
    fclose(NameFile);
	return 1;
}
stock LoadWeapon(pid)
{
	new tm1[80],ids=0;
    if(fexist(Get_Path(pid,21)))
    {
		new File:NameFile = fopen(Get_Path(pid,21), io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<13)
	        	    {
	        			sscanf(tm1, "iii",WEAPONUID[pid][ids][wdid],WEAPONUID[pid][ids][wpid],WEAPONUID[pid][ids][wmodel]);
						ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
stock LoadJJFONTLine(idx)
{
	new tm2[1024],tm1[80],ids=0;
    if(fexist(Get_Path(idx,18)))
    {
		new File:NameFile = fopen(Get_Path(idx,18), io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_JJ_FONT)
	        	    {
	        			sscanf(tm1, "s[80]",JJ_Line[idx][ids][JJ_str]);
						strcat(tm2,JJ_Line[idx][ids][JJ_str]);
		        		Iter_Add(JJ_Line[idx],ids);
		        		ids++;
	        		}
        		}
        	}
        	fclose(NameFile);
    	}
    }
	return tm2;
}
Function SaveJJFontLine(idx)
{
	new str3[4128];
    if(fexist(Get_Path(idx,18)))fremove(Get_Path(idx,18));
	new File:NameFile = fopen(Get_Path(idx,18), io_write);
    foreach(new i:JJ_Line[idx])
  	{
  	    ReStr(JJ_Line[idx][i][JJ_str],1,0);
		format(str3,sizeof(str3),"%s %s\r\n",str3,JJ_Line[idx][i][JJ_str]);
	}
	fwrite(NameFile,str3);
    fclose(NameFile);
	return 1;
}
Function SaveFontLine(idx)
{
	new str3[4128];
    if(fexist(Get_Path(idx,4)))fremove(Get_Path(idx,4));
	new File:NameFile = fopen(Get_Path(idx,4), io_write);
    foreach(new i:fonts_line[idx])
  	{
  	    ReStr(fonts_line[idx][i][fl_str],1,0);
		format(str3,sizeof(str3),"%s %s\r\n",str3,fonts_line[idx][i][fl_str]);
	}
	fwrite(NameFile,str3);
    fclose(NameFile);
	return 1;
}
stock LoadFontLine(idx)
{
	new ids=0;
	new tm1[128];
    if(fexist(Get_Path(idx,4)))
    {
		new File:NameFile = fopen(Get_Path(idx,4), io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile,tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_FONTS_LINE)
	        	    {
	        	        sscanf(tm1, "s[128]",fonts_line[idx][ids][fl_str]);
	        	        ReStr(fonts_line[idx][ids][fl_str],1,0);
		        		Iter_Add(fonts_line[idx],ids);
		        		ids++;
					}
				}
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}
Function LoadFontData(i, name[], value[])
{
    INI_Int("f_uid",fonts[i][f_uid]);
    INI_String("f_owner",fonts[i][f_owner],100);
    INI_Float("f_x",fonts[i][f_x]);
    INI_Float("f_y",fonts[i][f_y]);
    INI_Float("f_z",fonts[i][f_z]);
    INI_Int("f_in",fonts[i][f_in]);
    INI_Int("f_wl",fonts[i][f_wl]);
    INI_Int("f_Dis",fonts[i][f_Dis]);
    INI_Int("f_LOS",fonts[i][f_LOS]);
    INI_Int("f_color",fonts[i][f_color]);
    INI_Int("f_iscol",fonts[i][f_iscol]);
    INI_Int("f_coltime",fonts[i][f_coltime]);
	return 1;
}
Function Savedfont_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,3));
    INI_WriteInt(File,"f_uid",fonts[Count][f_uid]);
    INI_WriteString(File,"f_owner",fonts[Count][f_owner]);
    INI_WriteFloat(File, "f_x",fonts[Count][f_x]);
    INI_WriteFloat(File, "f_y",fonts[Count][f_y]);
    INI_WriteFloat(File, "f_z",fonts[Count][f_z]);
    INI_WriteInt(File, "f_in",fonts[Count][f_in]);
    INI_WriteInt(File, "f_wl",fonts[Count][f_wl]);
    INI_WriteInt(File, "f_LOS",fonts[Count][f_LOS]);
    INI_WriteInt(File, "f_Dis",fonts[Count][f_Dis]);
    INI_WriteInt(File, "f_color",fonts[Count][f_color]);
    INI_WriteInt(File, "f_iscol",fonts[Count][f_iscol]);
    INI_WriteInt(File, "f_coltime",fonts[Count][f_coltime]);
    INI_Close(File);
	return true;
}
//**************************************************************************//
stock FindSameTeleCmd(cmds[])
{
  	foreach(new i:Tinfo)
	{
		if(!strcmpEx(cmds,Tinfo[i][Tcmd], false))
		{
		    return true;
		}
	}
	return false;
}
stock CmdTeleportPlayer(playerid,color,Float:x,Float:y,Float:z,Float:a,in,wl,telename[],telecmd[],rate,telemakeman[])
{
	new tmps[256],tm[64];
	format(tm,64,"/%s",telecmd);
	format(tmps, sizeof(tmps),Tele_Cmd_Str,Gnn(playerid),playerid,colorMenuEx[color],telename,tm,rate,telemakeman);
	SendMessageToAll(COLOR_LIMEGREEN,tmps);
	SetPlayerPosEx(playerid,x,y,z,a,in,wl);
	return 1;
}
stock TeleportPlayer(playerid,telecmd[],Float:x,Float:y,Float:z,Float:a,in,wl,telename[])
{
	new tmps[128],tm[64];
	format(tm,64,"/%s",telecmd);
	format(tmps, sizeof(tmps),"[系统传送]%s传送到了%s  /%s",Gnn(playerid),telename,telecmd);
	SendMessageToAll(COLOR_PALETURQUOISE,tmps);
	SetPlayerPosEx(playerid,x,y,z,a,in,wl);
	format(tmps,128,"~b~~h~%s",telecmd);
	GameTextForPlayer(playerid,tmps, 3000, 3);
	return 1;
}

SendMessageToAll(colors,message[])
{
	foreach(new i:Player)
	{
		if(AvailablePlayer(i))
		{
			SendClientMessage(i,colors,message);
		}
	}
	return 1;
}
stock GetadminLevel(playerid)
{
	if(AvailablePlayer(playerid)&&UID[PU[playerid]][u_Admin]>0&&ADuty[playerid]==true)return UID[PU[playerid]][u_Admin];
	else return 0;
}
stock GnEx(playerid)
{
	new playername[100];
	GetPlayerName_fixed(playerid,playername,100);
	strlower(playername);
	return playername;
}
Getplayeruid(playerid)
{
	foreach(new i:UID)
	{
		strlower(UID[i][u_name]);
	    if(!strcmpEx(GnEx(playerid),UID[i][u_name], false))return i;
	}
	return -1;
}
stock Getvehdriver(cad)
{
    foreach(new i:Player)
    {
	    if(GetPlayerVehicleID(i)!=0)
	    {
	        if(GetPlayerVehicleID(i)==cad&&!GetPlayerVehicleSeat(i))return i;
	    }
    }
    return -1;
}
task update[50]()
{
	foreach(new i:JJ)if(IsValidDynamicObject(JJ[i][jid])&&JJ[i][jrotspeed]>0&&!JJ[i][jused])Core_UpdateRotating(i);
	foreach(new i:Player)
	{
	    if(IsPlayerNPC(i))continue;
		if(!IsPlayerConnected(i)||!SL[i])continue;
		if(GetadminLevel(i)<2000)
   		{
			if(ffdtopen)
			{
				if(IsPlayerInDynamicArea(i,ffdtarea))
				{
					if(playerupdate[i]>15)OnPlayerCheat(i,Ffdt_Garbage);
				}
			}
			if(UID[PU[i]][u_hunger]<50&&UID[PU[i]][u_Score]>100)ApplyAnimation(i,"PED","WALK_DRUNK",4.1,1,1,1,1,1,1);
		}
		if(IsPlayerInAnyVehicle(i))
		{
		    new cid=GetPlayerVehicleID(i);
			if(IsPlayerInRangeOfPoint(i,3,-748.31299, 1945.11633,15))
			{
			    new Float:xyz[3];
				if(cid==-1)
				{
				    GetPlayerVelocity(i,xyz[0],xyz[1],xyz[2]);
				    SetPlayerVelocity(i,xyz[0],xyz[1],xyz[2]+0.1);
			    }
			    else
				{
				    GetVehicleVelocity(cid,xyz[0],xyz[1],xyz[2]);
					SetPlayerVelocity(i,xyz[0],xyz[1],xyz[2]+0.1);
		    		SetVehicleVelocity(cid,xyz[0],xyz[0],xyz[2]+0.1);
	    		}
			}
			if(GetPlayerVehicleSeat(i)>0&&GetPlayerVehicleSeat(i)<5)
			{
			    if(Getvehdriver(cid)==-1)
			    {
                    new Float:spe;
			    	spe=GetVehicleSpeed(cid);
			    	if(spe>15)SetPlayerHealth(i,0.0);
			    }
			}
			if(!GetPlayerVehicleSeat(i))
			{
			    new Float:spe;
			    spe=GetVehicleSpeed(cid);
		        if(spe>300)
				{
					switch(GetVehicleModel(cid))
					{
						case 0,511,460,592,577,512,513,520,553,593,476,519:continue;
						default:
						{
							new Float:X, Float:Y, Float:Z;
							GetPlayerPos(i, X, Y, Z);
							RemovePlayerFromVehicle(i);
							SetPlayerPos(i, X, Y, Z+5);
							if(!IsPlayerInRangeOfPoint(i,50,-748.31299, 1945.11633,15))OnPlayerCheat(i,Speed_Hack);
						}
					}
				}
				if(UID[PU[i]][u_speed])
				{
				    new Float:hel,Float:xys[3],tm[64];
				    GetVehicleHealth(cid,hel);
				    GetVehiclePos(cid,xys[0],xys[1],xys[2]);
					format(tm,64,"%i  %i  %i",floatround(spe),floatround(hel),floatround(xys[2]));
					PlayerTextDrawSetString(i,Speedids[i],tm);
				    SetPlayerProgressBarValue(i,speedo[i],spe);
					SetPlayerProgressBarValue(i,chealth[i],hel);
				    SetPlayerProgressBarValue(i,chigh[i],xys[2]);
					if(!oldcmodel[i])
					{
						PlayerTextDrawSetPreviewModel(i,Preview[i],GetVehicleModel(cid));
						PlayerTextDrawSetPreviewVehCol(i,Preview[i],1,0);
						PlayerTextDrawShow(i,Preview[i]);
						oldcmodel[i]=GetVehicleModel(cid);
					}
					else if(oldcmodel[i]!=GetVehicleModel(cid))
					{
						PlayerTextDrawSetPreviewModel(i,Preview[i],GetVehicleModel(cid));
						PlayerTextDrawSetPreviewVehCol(i,Preview[i],1,0);
						PlayerTextDrawShow(i,Preview[i]);
						oldcmodel[i]=GetVehicleModel(cid);
					}
				}
			}
		}
		if(UID[PU[i]][u_hrs])
		{
			if(hrsids[i]>=7)
			{
				PlayerTextDrawHide(i,hrs[i][hrsids[i]]);
				hrsids[i]=0;
				PlayerTextDrawShow(i,hrs[i][hrsids[i]]);
			}
			else
			{
				PlayerTextDrawHide(i, hrs[i][hrsids[i]]);
				hrsids[i]++;
				PlayerTextDrawShow(i, hrs[i][hrsids[i]]);
			}
		}
	}
}
Dialog:dl_addgg(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(strlenEx(inputtext)<5)return SM(COLOR_TWAQUA,"用法:/addgg 信息[不少于5个字]");
        if(!EnoughMoneyEx(playerid,CM_CGG))return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有那么多钱$100000", "好的", "");
        Moneyhandle(PU[playerid],CM_CGG);
		new i=Iter_Free(RM);
		if(i==-1)return printf("广告语已满");
		RM[i][r_uid]=PU[playerid];
		format(RM[i][r_msg],128,inputtext);
		RM[i][r_last]=100;
		RM[i][r_color]=0;
		if(GetadminLevel(playerid)>1000)RM[i][r_system]=1;
		else RM[i][r_system]=0;
		Iter_Add(RM,i);
		SavedRandomMessage(i);
		SetPVarInt(playerid,"lisr",i);
		new tmp[738],Stru[64];
		Loop(x,sizeof(colorMenu)-SCOLOR)
		{
			format(Stru, sizeof(Stru),"%s|||||||||||||||||||||\n",colorMenuEx[x]);
			strcat(tmp,Stru);
		}
		Dialog_Show(playerid,dl_ggcolor,DIALOG_STYLE_LIST,"选择颜色",tmp,"确定", "取消");
	}
	return 1;
}
Dialog:dl_ggcolor(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		RM[GetPVarInt(playerid,"lisr")][r_color]=listitem;
		SavedRandomMessage(GetPVarInt(playerid,"lisr"));
	}
	return 1;
}
Function SendRandomMessage()
{
	if(!Iter_Count(RM))return SendClientMessageToAll(COLOR_DYELLOW,"广告招商中。。。。。。如想添加广告/WDGG");
	new idx=Iter_Random(RM),tm[150];
	format(tm,150,""#H_EP"%s%s   {808080}[%i]发布者:%s",colorMenuEx[RM[idx][r_color]],RM[idx][r_msg],idx,UID[RM[idx][r_uid]][u_name]);
	SendClientMessageToAll(MESSAGE_COLOR,tm);
	if(!RM[idx][r_system])RM[idx][r_last]--;
	SavedRandomMessage(idx);
	if(RM[idx][r_last]<=0)
	{
        fremove(Get_Path(idx,16));
		Iter_Remove(RM,idx);
	}
	return 1;
}
Function LoadRandomMessage_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_MESSAGES)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,16), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,16), "LoadRandomMessage", false, true, i, true, false);
            Iter_Add(RM,i);
 			idx++;
        }
    }
    return idx;
}
Function LoadRandomMessage(i, name[], value[])
{
    INI_String("r_msg",RM[i][r_msg],128);
    INI_Int("r_uid",RM[i][r_uid]);
    INI_Int("r_last",RM[i][r_last]);
    INI_Int("r_color",RM[i][r_color]);
    INI_Int("r_system",RM[i][r_system]);
	return 1;
}
Function SavedRandomMessage(Count)
{
    new INI:File = INI_Open(Get_Path(Count,16));
    INI_WriteString(File,"r_msg",RM[Count][r_msg]);
    INI_WriteInt(File,"r_uid",RM[Count][r_uid]);
    INI_WriteInt(File,"r_last",RM[Count][r_last]);
    INI_WriteInt(File,"r_color",RM[Count][r_color]);
    INI_WriteInt(File,"r_system",RM[Count][r_system]);
    INI_Close(File);
	return true;
}
stock AntiCheater(playerid)
{
	if(IsSpawn[playerid]==true)
	{
		new weapons,amout;
		for(new i = 0; i <= 12; i++)
		{
		    weapons=0;
		    GetPlayerWeaponData(playerid,i,weapons,amout);
		    if(weapons!=WEAPONUID[PU[playerid]][i][wpid]&&weapons!=0)OnPlayerCheat(playerid,Weapon_Hack);
		}
		/******************************************************************************************/
		new aB_SurfVehicle,aB_SurfObject,aB_State,Float:aB_AtualPos[3],Float:aB_Range;
	    GetPlayerPos(playerid,aB_AtualPos[0],aB_AtualPos[1],aB_AtualPos[2]);
	    aB_SurfVehicle=GetPlayerSurfingVehicleID(playerid);
	    aB_SurfObject=GetPlayerSurfingObjectID(playerid);
	    aB_State=GetPlayerState(playerid);
	    aB_Range=AIRBREAK_DISTANCIA;
	    if(aB_State == PLAYER_STATE_DRIVER || GetPlayerPing(playerid) > 200)aB_Range += 45.0;
	    if(aB_SurfVehicle == INVALID_VEHICLE_ID && aB_SurfObject == INVALID_OBJECT_ID && (aB_State == 1 || aB_State == 2))
		{
		    if(!IsPlayerInRangeOfPoint(playerid,aB_Range,pos_Info[playerid][pos_Pos][0],pos_Info[playerid][pos_Pos][1],pos_Info[playerid][pos_Pos][2])
			&& !IsPlayerInRangeOfPoint(playerid,10.0,pos_Info[playerid][pos_SetPos][0],pos_Info[playerid][pos_SetPos][1],pos_Info[playerid][pos_SetPos][2]))
			{
				if(gettime() > pos_Info[playerid][pos_tick]&&pstat[playerid]!=EDIT_CAR_ATT_MODE&&GetPlayerInterior(playerid)==0)OnPlayerCheat(playerid,AirBreak_Hack);
			}
		}
	    Anti_SavePos(playerid, aB_AtualPos[0], aB_AtualPos[1], aB_AtualPos[2]);
		/******************************************************************************************/
//		if(GetPlayerMoney(playerid)>UID[PU[playerid]][u_Cash])OnPlayerCheat(playerid,Money_Hack,GetPlayerMoney(playerid)-UID[PU[playerid]][u_Cash]);
		/******************************************************************************************/
	}
}
Function LiXi()
{
	new msg[100],lixis;
	foreach(new i:Player)
    {
        if(AvailablePlayer(i))
        {
            if(!CheckPausing(i))
            {
                lixis=floatround(UID[PU[i]][u_Cunkuan]*0.0005);
                UID[PU[i]][u_Cunkuan]+=lixis;
                Saveduid_data(PU[i]);
                format(msg,128,"{FF8000}【在线奖励】{00FF80}|-你获得了$%i利息-|-当前现金$%i-|-当前存款$%i-|",lixis,UID[PU[i]][u_Cash],UID[PU[i]][u_Cunkuan]);
        		SendClientMessage(i,0xFFFFFFFF,msg);
        		format(msg,128,"%s获得了$%i利息[存款:$%i,现金:$%i]",Gn(i),lixis,UID[PU[i]][u_Cunkuan],UID[PU[i]][u_Cash]);
        		AdminWarn(msg);
            }
			else
			{
                format(msg,128,"{FF8000}【在线奖励】{00FF80}由于你在挂机,无法获取利息");
        		SendClientMessage(i,0xFFFFFFFF,msg);
			}
        }
	}
}
Function UpdateTimeAndWeather()
{
    gettime(hourt, minute,seconds);
   	format(timestr,32,"%02d:%02d",hourt,minute);
   	TextDrawSetString(txtTimeDisp,timestr);
	if ((hourt > ghour) || (hourt == 0 && ghour == 23))
	{
	   	foreach(new i:Player)
		{
			if(AvailablePlayer(i))
			{
				if(UID[PU[i]][u_realtime]!=-1)SetPlayerTime(i,hourt,minute);
			}
		}
		ghour = hourt;
		LiXi();
	}
	if(last_weather_update == 0)
	{
	    if(hourt>8&&hourt<20)
		{
			new wid=random(sizeof(fine_weather_ids));
			gettime(hourt, minute,seconds);
			new tm[150];
		    foreach(new i:Player)
		    {
				if(AvailablePlayer(i))
				{
					if(UID[PU[i]][u_weather]!=-1)
					{
					    format(tm,150,"[天气预报]%02d:%02d:%02d 当前天气为:%s",hourt,minute,seconds,fine_weather_ids[wid][randomweather_text]);
						SendClientMessage(i,MESSAGE_COLOR,tm);
						SetPlayerWeather(i, fine_weather_ids[wid][randomweather_id]);
					}
				}
			}
		}
	}
	last_weather_update++;
	if(last_weather_update == 100)
	{
	    last_weather_update = 0;
	}
	if(hourt==20&&minute==0)kaiJiang();
	if(hourt==8&&minute==0)
	{
		Loop(x,sizeof(fresh))fresh[x][fresh_amout]=500;
		Savefresh();
	}
}
task everytime[1000]()
{
/*	foreach(new f:PNPC)
	{
	    if(PED_IsConnected(PNPC[f][pnpc_id]))
	    {
	        new pidd=chackonlineEX(PNPC[f][pnpc_uid]);
		    if(pidd!=-1)
			{
			    new Float:posx[3];
			    GetPlayerPos(pidd, posx[0], posx[1], posx[2]);
			    if(PED_IsInRangeOfPoint(PNPC[f][pnpc_id], 10.0, posx[0], posx[1], posx[2]))
			    {
		             PED_FollowPlayer(PNPC[f][pnpc_id],pidd);
				}
			}
		}
	}*/
	if(everymin>60)
	{
	    new rand=random(10);
        if(rand==0)YZMprint();
	    if(musictime>0)
		{
			musictime--;
			if(musictime==0)
			{
			    if(musicid!=-1)
			    {
				    new tmps[128];
				    format(tmps, sizeof(tmps),""H_MUSICS"[%s]音乐播放完毕,欢迎继续点播！！！",MUSICS[musicid][music_name]);
				    SendMessageToAll(COLOR_LIGHTGOLDENRODYELLOW,tmps);
				    musicid=-1;
			    }
			}
		}
	    foreach(new i:UID)
		{
		    new pid=chackonlineEX(i);
		    if(pid!=-1)
			{
				/*if(!CheckPausing(pid))
				{*/
				    UID[PU[pid]][u_Score]++;
					SetPlayerScore(pid,UID[PU[pid]][u_Score]);
				//}
				if(UID[PU[pid]][u_Score]>100)
				{
					if(UID[PU[pid]][u_hunger]<50)SendClientMessage(pid,0xFF8040C8,"你当前饥饿值小于50,请尽快进食");
                    if(UID[PU[pid]][u_hunger]>1&&UID[PU[pid]][u_Score]>100)UID[PU[pid]][u_hunger]=UID[PU[pid]][u_hunger]-1.0;
				}
			    if(UID[PU[pid]][u_Sil]>0)UID[PU[pid]][u_Sil]--;
			    if(UID[PU[pid]][u_JYTime]>0)
				{
					UID[PU[pid]][u_JYTime]--;
					new msgs[128];
					format(msgs,128,"你还剩监禁时间%i分钟",UID[PU[pid]][u_JYTime]);
					SendClientMessage(pid,-1,msgs);
				}
			}
			else
			{
			    if(UID[i][u_ban]>0)
			    {
		            UID[i][u_ban]--;
			    }
			    if(UID[i][u_Sil]>0)
			    {
			    	UID[i][u_Sil]--;
			    }
				if(UID[i][u_hunger]>1&&UID[i][u_Score]>100)UID[i][u_hunger]=UID[i][u_hunger]-1.0;
				/*	if(Now()-UID[i][u_caxin]>15)
					{
					    new tmpss[80];
	    				format(tmpss,sizeof(tmpss),USER_ZB_FILE,UID[i][u_name]);
	    				fremove(tmpss);
	    				format(tmpss,sizeof(tmpss),USER_BAG_FILE,UID[i][u_name]);
	    				fremove(tmpss);
	    				fremove(Get_Path(i,21));
	    				fremove(Get_Path(i,22));
	    				fremove(Get_Path(i,25));
	    				fremove(Get_Path(i,32));
	    				fremove(Get_Path(i,7));
	    				Iter_Remove(UID, i);
						printf("已删除用户UID[%i][%s]",i,UID[i][u_name]);
	    				break;
					}*/
			}
			foreach(new b:VInfo)if(!isplayerinveh(VInfo[b][v_cid]))if(GetVehicleDistanceFromPoint(VInfo[b][v_cid],VInfo[b][v_x],VInfo[b][v_y],VInfo[b][v_z])>10.0)
			{
				SetVehiclePos(VInfo[b][v_cid],VInfo[b][v_x],VInfo[b][v_y],VInfo[b][v_z]);
				SetVehicleZAngle(VInfo[b][v_cid],VInfo[b][v_a]);
			}
		}
		foreach(new i:JJ)
		{
		    if(IsValidDynamicObject(JJ[i][jid])&&!JJ[i][jused])
		    {
				if(JJ[i][jtype]==JJ_TYPE_TEXT)
				{
				    if(JJ[i][j_phb]!=NONE_TOP)JJphb(i,JJ[i][j_phb]);
				}
			/*	if(Now()-JJ[i][j_caxin]>15)
				{
				    DelJJ(i);
				    Iter_Remove(JJ,i);
				    printf("已删除家具[%i]",i);
				    break;
				}*/
			}
		}
		Loop(s,3)
		{
		    if(guaji[s][g_playerid]!=-1)
		    {
		        new tm[100];
		        if(!IsPlayerInRangeOfPoint(guaji[s][g_playerid],1,guaji[s][g_xx],guaji[s][g_yy],guaji[s][g_zz]))
				{
				    pstat[guaji[s][g_playerid]]=NO_MODE;
				    Dialog_Show(guaji[s][g_playerid], dl_msg, DIALOG_STYLE_MSGBOX, "提醒","你离开了挂机点，无法获取薪水", "额", "");
				    TogglePlayerControllable(pstat[guaji[s][g_playerid]] ,1);
					guaji[s][g_playerid]=-1;
					format(tm,100,"%i号挂机位\n每分钟$%i\n当前无人",s,guaji[s][g_level]*1000);
        			UpdateDynamic3DTextLabelText(guaji[s][g_text],-1,tm);
				}
				else
				{
					UID[PU[guaji[s][g_playerid]]][u_Cash]+=guaji[s][g_level]*1000;
					PlayerTextDrawSetString(guaji[s][g_playerid],Cashmoney[guaji[s][g_playerid]],StrlenCash(UID[PU[guaji[s][g_playerid]]][u_Cash]));
                    format(tm,100,"+ %i",guaji[s][g_level]*1000);
					GameTextForPlayer(PU[guaji[s][g_playerid]], tm, 3000, 5);
				}
		    }
		}
		UpdateTimeAndWeather();
		everymin=0;
	}
	everymin++;
	if(message_isopen)
	{
		if(message_time==max_message_time)
		{
		    SendRandomMessage();
			message_time=0;
		}
		message_time++;
	}
  	foreach(new i:C3dlabel)
	{
	    if(IsValidDynamic3DTextLabel(C3dlabel[i][C3d_id]))
	    {
			if(C3dlabel[i][C3d_isc]==true)
			{
			    if(C3dlabel[i][C3d_ltime]>=C3dlabel[i][C3d_time])
			    {
			        new ridx=random(sizeof(playerColors));
					UpdateDynamic3DTextLabelText(C3dlabel[i][C3d_id],playerColors[ridx],C3dlabel[i][C3d_text]);
					C3dlabel[i][C3d_ltime]=0;
			    }
			    C3dlabel[i][C3d_ltime]++;
			}
		}
	}
	foreach(new i:Player)
	{
		if(IsPlayerConnected(i)&&!IsPlayerNPC(i))
		{
		    if(SL[i])
		    {
		        AFKUpdate(i);
		    	AntiCheater(i);
				if(UID[PU[i]][u_mode])SetPlayerHealth(i,9999.9);
			    if(playdp[i]!=-1)
			    {
					if(!IsPlayerInDynamicArea(i,DPInfo[playdp[i]][dp_area]))
					{
						SetPlayerWorldBounds(i, 20000.0000, -20000.0000, 20000.0000, -20000.0000);
						playdp[i]=-1;
					}
				}
				if(pstat[i]==MOVE_JJ_MODE)
			    {
			        if(pcurrent_jj[i]!=-1&&GetPlayerSpecialAction(i)!=SPECIAL_ACTION_CARRY)SetPlayerSpecialAction(i,SPECIAL_ACTION_CARRY);
			    }
				else
				{
					if(pstat[i]!=BT&&pstat[i]!=ACT)SetPlayerSpecialAction(i,SPECIAL_ACTION_NONE);
				}
				if(UID[PU[i]][u_JYTime]>0)
        		{
					if(!IsPlayerInDynamicArea(i,JYarea))
					{
      					SetPlayerPosEx(i,-2048.2932,-131.7709,35.2966,346.5033,0,0);
						new msgs[128];
						format(msgs,128,"无法出狱,你还剩监禁时间%i分钟",UID[PU[i]][u_JYTime]);
						SendClientMessage(i,-1,msgs);
					}
        		}
			}
		  	foreach(new x:sat[i])
			{
				if(sat[i][x][s_iscol]==1)
				{
				    if(sat[i][x][s_ltime]>=sat[i][x][s_time])
				    {
				        new ridx1=random(sizeof(playerColors));
				        new ridx2=random(sizeof(playerColors));
				        if(IsPlayerAttachedObjectSlotUsed(i, x))RemovePlayerAttachedObject(i,x);
    					SetPlayerAttachedObject(i,sat[i][x][s_index],sat[i][x][s_modelid],sat[i][x][s_bone],sat[i][x][s_fOffsetX],sat[i][x][s_fOffsetY],
						sat[i][x][s_fOffsetZ],sat[i][x][s_fRotX],sat[i][x][s_fRotY],sat[i][x][s_fRotZ],sat[i][x][s_fScaleX],sat[i][x][s_fScaleY],sat[i][x][s_fScaleZ],
						ARGB(playerColors[ridx1]),ARGB(playerColors[ridx2]));
						sat[i][x][s_ltime]=0;
				    }
				    sat[i][x][s_ltime]++;
				}
			}
		}
	}
	DBPTimer();
}
stock CreateColor3DTextLabel(const text[],color,Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID,testlos = 0, worldid = -1, interiorid = -1,playerid = -1,Float:streamdistance = 100.0,iscol,costtime)
{
	new i=Iter_Free(C3dlabel);
	if(i==-1)return -1;
	format(C3dlabel[i][C3d_text],738,text);
	C3dlabel[i][C3d_color]=color;
	C3dlabel[i][C3d_x]=x;
	C3dlabel[i][C3d_y]=y;
	C3dlabel[i][C3d_z]=z;
	C3dlabel[i][C3d_drawdistance]=drawdistance;
	C3dlabel[i][C3d_attachedplayer]=attachedplayer;
	C3dlabel[i][C3d_attachedvehicle]=attachedvehicle;
	C3dlabel[i][C3d_worldid]=worldid;
	C3dlabel[i][C3d_interiorid]=interiorid;
	C3dlabel[i][C3d_streamdistance]=streamdistance;
	C3dlabel[i][C3d_time]=costtime;
	if(iscol==0)C3dlabel[i][C3d_isc]=false;
	if(iscol==1)C3dlabel[i][C3d_isc]=true;
	C3dlabel[i][C3d_ltime]=0;
	C3dlabel[i][C3d_playerid]=playerid;
	C3dlabel[i][C3d_testlos]=testlos;
	C3dlabel[i][C3d_id]=CreateDynamic3DTextLabel(text,color,x,y,z,drawdistance,attachedplayer,attachedvehicle,testlos,worldid,interiorid,playerid,streamdistance);
  	Iter_Add(C3dlabel,i);
	return i;
}
stock UpdateColor3DTextLabelText(idx, color, const text[])
{
	if(!IsValidDynamic3DTextLabel(C3dlabel[idx][C3d_id]))return 1;
	format(C3dlabel[idx][C3d_text],738,text);
	C3dlabel[idx][C3d_color]=color;
	UpdateDynamic3DTextLabelText(C3dlabel[idx][C3d_id],C3dlabel[idx][C3d_color],C3dlabel[idx][C3d_text]);
	return 1;
}
stock DeleteColor3DTextLabel(idx)
{
	if(!IsValidDynamic3DTextLabel(C3dlabel[idx][C3d_id]))return 1;
	DestroyDynamic3DTextLabel(C3dlabel[idx][C3d_id]);
	Iter_Remove(C3dlabel,idx);
	return 1;
}
stock RegulateColor3DTextLabel(idx,iscol,costime)
{
	if(!IsValidDynamic3DTextLabel(C3dlabel[idx][C3d_id]))return 1;
	if(iscol==0)C3dlabel[idx][C3d_isc]=false;
	if(iscol==1)C3dlabel[idx][C3d_isc]=true;
	C3dlabel[idx][C3d_time]=costime;
//	if(C3dlabel[idx][C3d_isc]==false)UpdateColor3DTextLabelText(C3dlabel[idx][C3d_id],C3dlabel[idx][C3d_color],C3dlabel[idx][C3d_text]);
	return 1;
}
stock IsValidColor3DTextLabel(idx)
{
	if(!IsValidDynamic3DTextLabel(C3dlabel[idx][C3d_id]))return 1;
	return 0;
}
stock IsplayerHaveAttSlot(playerid)
{
    if(Iter_Free(sat[playerid])==-1)return 0;
	return 1;
}
stock SetPlayerAttachedObjectEx(playerid,modelid,bone,Float:fOffsetX = 0.0,Float:fOffsetY = 0.0,Float:fOffsetZ = 0.0,Float:fRotX = 0.0,Float:fRotY = 0.0,Float:fRotZ = 0.0,Float:fScaleX = 1.0,Float:fScaleY = 1.0,Float:fScaleZ = 1.0,materialcolor1 = 0,materialcolor2 = 0,iscol=0,time=0,ismater=0)
{
    new i=Iter_Free(sat[playerid]);
    sat[playerid][i][s_index]=i;
    sat[playerid][i][s_modelid]=modelid;
    sat[playerid][i][s_bone]=bone;
    sat[playerid][i][s_fOffsetX]=fOffsetX;
    sat[playerid][i][s_fOffsetY]=fOffsetY;
    sat[playerid][i][s_fOffsetZ]=fOffsetZ;
    sat[playerid][i][s_fRotX]=fRotX;
    sat[playerid][i][s_fRotY]=fRotY;
    sat[playerid][i][s_fRotZ]=fRotZ;
    sat[playerid][i][s_fScaleX]=fScaleX;
    sat[playerid][i][s_fScaleY]=fScaleY;
    sat[playerid][i][s_fScaleZ]=fScaleZ;
    sat[playerid][i][s_materialcolor1]=materialcolor1;
    sat[playerid][i][s_materialcolor2]=materialcolor2;
    sat[playerid][i][s_ismater]=ismater;
    sat[playerid][i][s_iscol]=iscol;
    sat[playerid][i][s_time]=time;
	sat[playerid][i][s_ltime]=0;
    if(IsPlayerAttachedObjectSlotUsed(playerid, i))RemovePlayerAttachedObject(playerid,i);
    if(!ismater)SetPlayerAttachedObject(playerid,i, modelid,bone,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
	else SetPlayerAttachedObject(playerid,i, modelid,bone,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ,ARGB(colorMenu[materialcolor1]),ARGB(colorMenu[materialcolor2]));
    Iter_Add(sat[playerid],i);
    return i;
}
stock UpdatePlayerAttachedObjectEx(playerid,idx,modelid, bone, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ,materialcolor1,materialcolor2,iscol=0,time=0,ismater=0)
{
	if(Itter_Contains(sat[playerid],idx))
	{
	    sat[playerid][idx][s_modelid]=modelid;
	    sat[playerid][idx][s_bone]=bone;
	    sat[playerid][idx][s_fOffsetX]=fOffsetX;
	    sat[playerid][idx][s_fOffsetY]=fOffsetY;
	    sat[playerid][idx][s_fOffsetZ]=fOffsetZ;
	    sat[playerid][idx][s_fRotX]=fRotX;
	    sat[playerid][idx][s_fRotY]=fRotY;
	    sat[playerid][idx][s_fRotZ]=fRotZ;
	    sat[playerid][idx][s_fScaleX]=fScaleX;
	    sat[playerid][idx][s_fScaleY]=fScaleY;
	    sat[playerid][idx][s_fScaleZ]=fScaleZ;
	    sat[playerid][idx][s_materialcolor1]=materialcolor1;
	    sat[playerid][idx][s_materialcolor2]=materialcolor2;
    	sat[playerid][idx][s_ismater]=ismater;
    	sat[playerid][idx][s_iscol]=iscol;
    	sat[playerid][idx][s_time]=time;
		sat[playerid][idx][s_ltime]=0;
	    if(IsPlayerAttachedObjectSlotUsed(playerid, idx))RemovePlayerAttachedObject(playerid,idx);
    	if(!ismater)SetPlayerAttachedObject(playerid,idx, modelid,bone,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
		else SetPlayerAttachedObject(playerid,idx, modelid,bone,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ,ARGB(colorMenu[materialcolor1]),ARGB(colorMenu[materialcolor2]));
	}
	else printf("error1");
	return 1;
}
stock RegulatePlayerAttachedObjectEx(playerid,idx,iscol,costime,ismater=0)
{
	if(Itter_Contains(sat[playerid],idx))
	{
	    sat[playerid][idx][s_iscol]=iscol;
    	sat[playerid][idx][s_time]=costime;
    	sat[playerid][idx][s_ismater]=ismater;
        UpdatePlayerAttachedObjectEx(playerid,idx,att[playerid][idx][att_modelid],att[playerid][idx][att_boneid],att[playerid][idx][att_fOffsetX],
		att[playerid][idx][att_fOffsetY],att[playerid][idx][att_fOffsetZ],att[playerid][idx][att_fRotX],att[playerid][idx][att_fRotY],att[playerid][idx][att_fRotZ],
		att[playerid][idx][att_fScaleX],att[playerid][idx][att_fScaleY],att[playerid][idx][att_fScaleZ],ARGB(colorMenu[att[playerid][idx][att_materialcolor1]]),ARGB(colorMenu[att[playerid][idx][att_materialcolor2]]),sat[playerid][idx][s_iscol],sat[playerid][idx][s_time],sat[playerid][idx][s_ismater]);
	}
	else printf("error2");
	return 1;
}
stock RemovePlayerAttachedObjectEx(playerid,idx)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid,idx))RemovePlayerAttachedObject(playerid,idx);
	Iter_Remove(sat[playerid],idx);
	return 1;
}
Function LoadAtt(playerid)
{
	new strings[2048],Stru[64],ids=0;
    format(Stru,sizeof(Stru),USER_ZB_FILE,Gnn(playerid));
    if(fexist(Stru))
    {
		new File:attfile = fopen(Stru, io_read);
    	if(attfile)
    	{
        	while(fread(attfile, strings))
        	{
        	    if(strlenEx(strings)>3)
        	    {
	        	    if(ids<MAX_PLAYER_ATTACHED_OBJECTS-1)
	        	    {
		        	    new i=SetPlayerAttachedObjectEx(playerid,0,0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0);
		        		sscanf(strings, "p<,>iiiifffffffffiiiii",
							att[playerid][i][att_did],
							att[playerid][i][att_type],
							att[playerid][i][att_modelid],
							att[playerid][i][att_boneid],
							att[playerid][i][att_fOffsetX],
							att[playerid][i][att_fOffsetY],
							att[playerid][i][att_fOffsetZ],
							att[playerid][i][att_fRotX],
							att[playerid][i][att_fRotY],
							att[playerid][i][att_fRotZ],
							att[playerid][i][att_fScaleX],
							att[playerid][i][att_fScaleY],
							att[playerid][i][att_fScaleZ],
							att[playerid][i][att_materialcolor1],
							att[playerid][i][att_materialcolor2],
							att[playerid][i][att_iscol],
							att[playerid][i][att_jcoltime],
							att[playerid][i][att_ismater]
						);
						UpdatePlayerAttachedObjectEx(playerid,i,att[playerid][i][att_modelid],att[playerid][i][att_boneid],att[playerid][i][att_fOffsetX],
						 att[playerid][i][att_fOffsetY],att[playerid][i][att_fOffsetZ],att[playerid][i][att_fRotX],att[playerid][i][att_fRotY],att[playerid][i][att_fRotZ],
						 att[playerid][i][att_fScaleX],att[playerid][i][att_fScaleY],att[playerid][i][att_fScaleZ],att[playerid][i][att_materialcolor1],att[playerid][i][att_materialcolor2],att[playerid][i][att_iscol],att[playerid][i][att_jcoltime],att[playerid][i][att_ismater]);
						Iter_Add(att[playerid],i);
						ids++;
					}
				}
        	}
        	fclose(attfile);
    	}
    }
	return 1;
}
Function SaveAtt(playerid)
{
	new strings[2048],Stru[64];
    format(Stru,sizeof(Stru),USER_ZB_FILE,Gnn(playerid));
    if(fexist(Stru))fremove(Stru);
	new File:attfile = fopen(Stru, io_write);
    foreach(new i:att[playerid])
	{
		format(strings,sizeof(strings),"%s %d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f,%d,%d,%d,%d,%d\r\n",strings,
			att[playerid][i][att_did],
			att[playerid][i][att_type],
			att[playerid][i][att_modelid],
			att[playerid][i][att_boneid],
			att[playerid][i][att_fOffsetX],
			att[playerid][i][att_fOffsetY],
			att[playerid][i][att_fOffsetZ],
			att[playerid][i][att_fRotX],
			att[playerid][i][att_fRotY],
			att[playerid][i][att_fRotZ],
			att[playerid][i][att_fScaleX],
			att[playerid][i][att_fScaleY],
			att[playerid][i][att_fScaleZ],
			att[playerid][i][att_materialcolor1],
			att[playerid][i][att_materialcolor2],
			att[playerid][i][att_iscol],
			att[playerid][i][att_jcoltime],
			att[playerid][i][att_ismater]
		);
	}
	fwrite(attfile,strings);
    fclose(attfile);
	return 1;
}
Function SaveAve(idx)
{
	new str[3128];
    if(fexist(Get_Path(idx,8)))fremove(Get_Path(idx,8));
	new File:NameFile = fopen(Get_Path(idx,8), io_write);
    foreach(new i:AvInfo[idx])
  	{
		format(str,sizeof(str),"%s %i %f %f %f %f %f %f %i\r\n",str,AvInfo[idx][i][av_did],
		AvInfo[idx][i][v_x],
		AvInfo[idx][i][v_y],
		AvInfo[idx][i][v_z],
		AvInfo[idx][i][v_rx],
		AvInfo[idx][i][v_ry],
		AvInfo[idx][i][v_rz],
		AvInfo[idx][i][v_txd]
		);
	}
	fwrite(NameFile,str);
    fclose(NameFile);
	return 1;
}
stock LoadAveh(idx)
{
	new tm1[100];
    if(fexist(Get_Path(idx,8)))
    {
		new File:NameFile = fopen(Get_Path(idx,8), io_read);
    	if(NameFile)
    	{
    	    new ids=0;
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_PLAYERS_VEH_ATT)
	        	    {
		        		sscanf(tm1, "iffffffi",AvInfo[idx][ids][av_did],
						AvInfo[idx][ids][v_x],
						AvInfo[idx][ids][v_y],
						AvInfo[idx][ids][v_z],
						AvInfo[idx][ids][v_rx],
						AvInfo[idx][ids][v_ry],
						AvInfo[idx][ids][v_rz],
						AvInfo[idx][ids][v_txd]);
		                AvInfo[idx][ids][av_id]=CreateDynamicObject(Daoju[AvInfo[idx][ids][av_did]][d_obj],0.0,0.0,0.0,0.0,0.0,0.0,-1,-1,-1,200.0,0.0);
						if(AvInfo[idx][ids][v_txd]!=0)SetDynamicObjectMaterial(AvInfo[idx][ids][av_id],0,ObjectTextures[AvInfo[idx][ids][v_txd]][TModel],ObjectTextures[AvInfo[idx][ids][v_txd]][TXDName],ObjectTextures[AvInfo[idx][ids][v_txd]][TextureName],0);
		                AttachDynamicObjectToVehicle(AvInfo[idx][ids][av_id],VInfo[idx][v_cid],AvInfo[idx][ids][v_x],AvInfo[idx][ids][v_y],AvInfo[idx][ids][v_z],AvInfo[idx][ids][v_rx],AvInfo[idx][ids][v_ry],AvInfo[idx][ids][v_rz]);
			    		Iter_Add(AvInfo[idx],ids);
		        		ids++;
		        	}
		        }
        	}
        	fclose(NameFile);
    	}
    }
	return 1;
}

Function LoadVeh_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_PLAYERS_VEH)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,0), i);
        if(fexist(NameFile))
        {
            INI_ParseFile(Get_Path(i,0), "LoadVehData", false, true, i, true, false);
            new Carid=AddStaticVehicleEx(carmod,carx,cary,carz,cara,carco1,carco2,99999999);
            CarTypes[Carid]=OwnerVeh;
            CUID[Carid]=i;
            LinkVehicleToInterior(CUID[Carid],carin);
            SetVehicleVirtualWorld(CUID[Carid],carwl);
			VInfo[CUID[Carid]][v_model]=carmod;
			VInfo[CUID[Carid]][v_uid]=caruid;
			VInfo[CUID[Carid]][v_did]=cardid;
			VInfo[CUID[Carid]][v_gid]=cargid;
			VInfo[CUID[Carid]][v_x]=carx;
			VInfo[CUID[Carid]][v_y]=cary;
			VInfo[CUID[Carid]][v_z]=carz;
			VInfo[CUID[Carid]][v_a]=cara;
			VInfo[CUID[Carid]][v_color1]=carco1;
			VInfo[CUID[Carid]][v_color2]=carco2;
			VInfo[CUID[Carid]][v_in]=carin;
			VInfo[CUID[Carid]][v_wl]=carwl;
			VInfo[CUID[Carid]][v_iscol]=cariscol;
			VInfo[CUID[Carid]][v_time]=cartime;
			VInfo[CUID[Carid]][v_lock]=carlock;
			VInfo[CUID[Carid]][v_cid]=Carid;
   			VInfo[CUID[Carid]][v_Value]=Value;
   			VInfo[CUID[Carid]][v_issel]=issel;
   			VInfo[CUID[Carid]][v_Paintjob]=Paintjob;
   			format(VInfo[CUID[Carid]][v_Plate],100,Plate);
   			Loop(x,MAX_COM)
			{
	    		VInfo[CUID[Carid]][v_comp][x]=comps[x];
			}
   			SetVehicleNumberPlate(Carid,Plate);
			ModVehicle(Carid);
			if(VInfo[CUID[Carid]][v_Paintjob]!=-1)ChangeVehiclePaintjob(Carid,VInfo[CUID[Carid]][v_Paintjob]);
			LoadAveh(CUID[Carid]);
			Createcar3D(Carid);
 			Iter_Add(VInfo,CUID[Carid]);
 			idx++;
        }
    }
    return idx;
}
Function Createcar3D(cid)
{
	new Stru[100];
	switch(VInfo[CUID[cid]][v_issel])
	{
	    case NONEONE:format(Stru,sizeof(Stru),"%s\n系统出售\n售价$%i",Daoju[VInfo[CUID[cid]][v_did]][d_name],Daoju[VInfo[CUID[cid]][v_did]][d_cash]);
		case OWNERS:format(Stru,sizeof(Stru),"%s\n车主:%s",Daoju[VInfo[CUID[cid]][v_did]][d_name],UID[VInfo[CUID[cid]][v_uid]][u_name]);
		case SELLING:format(Stru,sizeof(Stru),"%s\n出售中\n车主:%s\n售价$%i",Daoju[VInfo[CUID[cid]][v_did]][d_name],UID[VInfo[CUID[cid]][v_uid]][u_name],VInfo[CUID[cid]][v_Value]);
	}
	VInfo[CUID[cid]][v_text]=CreateColor3DTextLabel(Stru,COLOR_LIME,0.0,0.0,0.8,20,INVALID_PLAYER_ID,cid,0,VInfo[CUID[cid]][v_wl],VInfo[CUID[cid]][v_in],-1,20.0,VInfo[CUID[cid]][v_iscol],VInfo[CUID[cid]][v_time]);
	return 1;
}
Function LoadVehData(i, name[], value[])
{
    INI_Int("v_uid",caruid);
    INI_Int("v_did",cardid);
    INI_Int("v_gid",cargid);
    INI_Float("v_x",carx);
    INI_Float("v_y",cary);
    INI_Float("v_z",carz);
    INI_Float("v_a",cara);
    INI_Int("v_model",carmod);
    INI_Int("v_color1",carco1);
    INI_Int("v_color2",carco2);
    INI_Int("v_in",carin);
    INI_Int("v_wl",carwl);
    INI_Int("v_iscol",cariscol);
    INI_Int("v_lock",carlock);
    INI_Int("v_time",cartime);
    INI_Int("v_Value",Value);
    INI_Int("v_issel",issel);
    INI_Int("v_Paintjob",Paintjob);
    INI_String("v_Plate",Plate,100);
    new ns[16];
	Loop(x,MAX_COM)
	{
	    format(ns,sizeof(ns),"v_comp%i",x);
	    INI_Int(ns,comps[x]);
	}
	return 1;
}
Function Savedveh_data(Count)
{
    new INI:File = INI_Open(Get_Path(Count,0));
    INI_WriteInt(File,"v_uid",VInfo[Count][v_uid]);
    INI_WriteInt(File,"v_did",VInfo[Count][v_did]);
    INI_WriteInt(File,"v_gid",VInfo[Count][v_gid]);
    INI_WriteFloat(File, "v_x",VInfo[Count][v_x]);
    INI_WriteFloat(File, "v_y",VInfo[Count][v_y]);
    INI_WriteFloat(File, "v_z",VInfo[Count][v_z]);
    INI_WriteFloat(File, "v_a",VInfo[Count][v_a]);
    INI_WriteInt(File, "v_model",VInfo[Count][v_model]);
    INI_WriteInt(File, "v_color1",VInfo[Count][v_color1]);
    INI_WriteInt(File, "v_color2",VInfo[Count][v_color2]);
    INI_WriteInt(File,"v_in",VInfo[Count][v_in]);
    INI_WriteInt(File,"v_wl",VInfo[Count][v_wl]);
    INI_WriteInt(File,"v_iscol",VInfo[Count][v_iscol]);
    INI_WriteInt(File,"v_lock",VInfo[Count][v_lock]);
    INI_WriteInt(File,"v_time",VInfo[Count][v_time]);
    INI_WriteInt(File,"v_issel",VInfo[Count][v_issel]);
    INI_WriteInt(File,"v_Value",VInfo[Count][v_Value]);
    INI_WriteInt(File,"v_Paintjob",VInfo[Count][v_Paintjob]);
    INI_WriteString(File,"v_Plate",VInfo[Count][v_Plate]);
    new ns[16];
	Loop(x,MAX_COM)
	{
	    format(ns,sizeof(ns),"v_comp%i",x);
	    INI_WriteInt(File,ns,VInfo[Count][v_comp][x]);
	}
    INI_Close(File);
	return true;
}
CMD:wdac(playerid, params[], help)
{
	if(!AvailablePlayer(playerid)) return SM(COLOR_TWAQUA, "你没有登陆！无法使用");
	current_number[playerid]=1;
	foreach(new i:VInfo)
	{
		if(VInfo[i][v_uid]==PU[playerid]&&CarTypes[VInfo[i][v_cid]]==OwnerVeh)
		{
			current_idx[playerid][current_number[playerid]]=i;
        	current_number[playerid]++;
 		}
	}
	if(current_number[playerid]==1) return Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提示","你没有爱车", "额", "");
	P_page[playerid]=1;
	new tm[100];
	format(tm,100,"我的爱车-共计[%i]",current_number[playerid]-1);
	Dialog_Show(playerid, dl_aicar, DIALOG_STYLE_LIST,tm, Showmycarlist(playerid,P_page[playerid]), "确定", "取消");
	return 1;
}
stock Showmycarlist(playerid,pager)
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
			if(VInfo[current_idx[playerid][i]][v_gid]==-1)format(tmps,128,"%s,团伙共享:否\n",Daoju[VInfo[current_idx[playerid][i]][v_did]][d_name]);
			else format(tmps,128,"%s,隶属团伙:%i\n",Daoju[VInfo[current_idx[playerid][i]][v_did]][d_name],VInfo[current_idx[playerid][i]][v_gid]);
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
Dialog:dl_carzhaohui(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    new listid=GetPVarInt(playerid,"listIDA");
	    new Float:x,Float:y,Float:z;
    	GetPlayerPos(playerid,x,y,z);
	    SetVehiclePos(VInfo[listid][v_cid],x+1,y,z);
        LinkVehicleToInterior(VInfo[listid][v_cid],GetPlayerInterior(playerid));
        SetVehicleVirtualWorld(VInfo[listid][v_cid],GetPlayerVirtualWorld(playerid));
        PutPlayerInVehicle(playerid,VInfo[listid][v_cid],0);
		new tm[100];
		format(tm,100,"你的爱车%s已送到",Daoju[VInfo[listid][v_did]][d_name]);
	    Dialog_Show(playerid, dl_msg, DIALOG_STYLE_MSGBOX, "提醒",tm, "好的", "");
	}
	DeletePVar(playerid,"listIDA");
	return 1;
}
Dialog:dl_aicar(playerid, response, listitem, inputtext[])
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
	    	Dialog_Show(playerid, dl_aicar, DIALOG_STYLE_LIST,"我的爱车/WDAC", Showmycarlist(playerid,P_page[playerid]), "确定", "上一页");
	    }
		else
		{
			new listid=current_idx[playerid][page+listitem];
			SetPVarInt(playerid,"listIDA",listid);
			new tm[64];
			format(tm,64,"你的爱车%s",Daoju[VInfo[listid][v_did]][d_name]);
			Dialog_Show(playerid,dl_carzhaohui,DIALOG_STYLE_MSGBOX,tm,"是否召回爱车","确定", "取消");
		}
	}
	else
	{
		if(P_page[playerid] > 1)
		{
			P_page[playerid]--;
			Dialog_Show(playerid, dl_aicar, DIALOG_STYLE_LIST,"我的爱车/WDAC", Showmycarlist(playerid,P_page[playerid]), "确定", "取消");
		}
	}
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(IsPlayerNPC(playerid))return 1;
	foreach(new i:R_RACE)
	{
	    if(checkpointid==R_RACE[i][RACE_PICK]&&pp_race[playerid][romid]==-1)
	    {
	    	new tm[100];
			format(tm,64,"请输入/startmap %i 开始一场比赛",i);
	        SM(COLOR_GAINSBORO,tm);
	    }
	}
	return 1;
}
/*Function fwrite_utf8(File:handle,const string[],bool:use_utf8)
{
	new i;
	for(i = 0;string[i];i++){
		fputchar(handle, string[i],use_utf8);
	}
	return true;
}*/
/*stock fwriteEx(File:handle, string[]) {
    if(0 <= string[0] <= ucharmax) { // ispacked(string) doesn't seem to work with these characters
        for(new i; string[i]; ++i) {
            fwritechar(handle, string[i]);
        }
    } else {
        for(new i; string{i}; ++i) {
            fwritechar(handle, string{i});
        }
    }
}*/

/*stock freadEx(File:handle, string[], size = sizeof string, bool: pack = false) {
    if(pack) {
        size *= 4;

        for(new i; i < size; ++i) {
            if((string{i} = freadchar(handle)) == EOF) {
                string{i} = EOS;
                break;
            }
        }
    } else {
        for(new i; i < size; ++i) {
            if((string[i] = freadchar(handle)) == EOF) {
                string[i] = EOS;
                break;
            }
        }
    }
}*/
Function fwrite_utf8(File:handle, str[], bool:use_utf8)
{
	new x=0;
 	if(!handle) return 0;
	while(str[x] != EOS) {
		fputchar(handle, str[x], use_utf8);
		x++;
	}

	return x;
}
Function AddRemoveBuilding(modelid,Float:fX,Float:fY,Float:fZ,Float:fRadius)
{
    new i=Iter_Free(ROBJ);
    if(i!=-1)
    {
        ROBJ[i][RE_MODEL]=modelid;
        ROBJ[i][RE_FX]=fX;
        ROBJ[i][RE_FY]=fY;
        ROBJ[i][RE_FZ]=fZ;
        ROBJ[i][HO_FR]=fRadius;
        Iter_Add(ROBJ,i);
    }
	return i;
}
Function RemoveBuild(idx)
{
	foreach(new x:Player)
	{
		RemoveBuildingForPlayer(x,ROBJ[idx][RE_MODEL],ROBJ[idx][RE_FX],ROBJ[idx][RE_FY],ROBJ[idx][RE_FZ],ROBJ[idx][HO_FR]);
	}
	return 1;
}
Function RemovePlayerBuild(playerid)
{
    foreach(new i:ROBJ)
	{
		RemoveBuildingForPlayer(playerid,ROBJ[i][RE_MODEL],ROBJ[i][RE_FX],ROBJ[i][RE_FY],ROBJ[i][RE_FZ],ROBJ[i][HO_FR]);
	}
	return 1;
}
Function bool:IsPlayerEnteringInterior(playerid)
{
    new animlib[32];
	new animname[32];
    GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
    return (!strcmp(animname,"WALK_DOORPARTIAL",false));
}
ReStr(string[],type1=1,type2=1)
{
	if(type1)strreplace(string," ","",false,0,-1,1024);
	strreplace(string,"\n","",false,0,-1,1024);
    if(type2)strreplace(string,"{","",false,0,-1,1024);
    if(type2)strreplace(string,"}","",false,0,-1,1024);
    strreplace(string,"\r","",false,0,-1,1024);
}

stock GetPlayerSkinName(playerid)
{
	new PlayerSkinID;
	PlayerSkinID = GetPlayerSkin(playerid);
	PlayerSkinID -= 0;
	return SkinName[PlayerSkinID];
}
ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
	if(IsPlayerConnected(playerid))
	{
		new Float:posx, Float:posy, Float:posz;
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(IsPlayerConnected(i) && (GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)))
			{
				GetPlayerPos(i, posx, posy, posz);
				tempposx = (oldposx -posx);
				tempposy = (oldposy -posy);
				tempposz = (oldposz -posz);
				if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
				{
					SendClientMessage(i, col1, string);
				}
				else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
				{
					SendClientMessage(i, col2, string);
				}
				else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
				{
					SendClientMessage(i, col3, string);
				}
				else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
				{
					SendClientMessage(i, col4, string);
				}
				else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
				{
					SendClientMessage(i, col5, string);
				}
			}
		}
	}
	return 1;
}
public OnEnterExitModShop(playerid, enterexit, interiorid)
{
    if(enterexit == 0)
    {
    }
    else
    {
    }
    return 1;
}
public Streamer_OnPluginError(error[])
{
	printf("Streamer:%s",error);
    return 1;
}
public OnUnoccupiedVehicleUpdate(vehicleid, playerid, passenger_seat, Float:new_x, Float:new_y, Float:new_z, Float:vel_x, Float:vel_y, Float:vel_z)
{
    if(CarTypes[vehicleid]==OwnerVeh&&VInfo[CUID[vehicleid]][v_uid]==PU[playerid])return 1;
    new Float:dist = GetVehicleDistanceFromPoint(vehicleid, new_x, new_y, new_z);
    if(dist > 15)return 0;
	return 1;
}
stock HighestTopList(const playerid, const Values, Player_ID[], Top_Score[], Loop)
{
	new
	    t = 0,
		p = Loop-1;
	while(t < p) {
	    if(Values >= Top_Score[t]) {
			while(p > t) { Top_Score[p] = Top_Score[p - 1]; Player_ID[p] = Player_ID[p - 1]; p--; }
			Top_Score[t] = Values; Player_ID[t] = playerid;
			break;
		} t++; }
	return 1;
}
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(AvailablePlayer(playerid))SetPosFindZ(playerid,fX,fY,fZ);
	else SM(COLOR_TWTAN,"你还没有登录额");
 	return 1;
}
Function LoadCDK()
{
	new tm1[100],ids=0;
    if(fexist(CDK_FILE))
    {
		new File:NameFile = fopen(CDK_FILE, io_read);
    	if(NameFile)
    	{
        	while(fread(NameFile, tm1))
        	{
        	    if(strlenEx(tm1)>3)
        	    {
	        	    if(ids<MAX_CDK)
	        	    {
		        		sscanf(tm1, "s[32]if",CDK[ids][cdk_cdk],CDK[ids][cdk_vb],CDK[ids][cdk_money]);
			    		Iter_Add(CDK,ids);
		        		ids++;
		        	}
		        }
        	}
        	fclose(NameFile);
    	}
    }
	return ids;
}
Function SaveCDK()
{
	new str[100];
    if(fexist(CDK_FILE))fremove(CDK_FILE);
	new File:NameFile = fopen(CDK_FILE, io_write);
    foreach(new i:CDK)
	{
		format(str,sizeof(str),"%s %i %0.1f\r\n",CDK[i][cdk_cdk],CDK[i][cdk_vb],CDK[i][cdk_money]);
		if(fexist(CDK_FILE))fwrite(NameFile, str);
	}
    fclose(NameFile);
	return 1;
}
stock AFKUpdate(playerid)
{
	new string[128];
	if(GetTickCount() > (GetPVarInt(playerid,"LastUpdate") + 1000) && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)
	{
		playerupdate[playerid]++;
	    if(playerupdate[playerid] > 60)
		{
		    new mins,secs;
		    mins = playerupdate[playerid] / 60;
		    secs = playerupdate[playerid] - (mins * 60);
		    if(mins == 1) format(string,sizeof(string),"挂机离开%d分%d秒",mins,secs);
		    else format(string,sizeof(string),"挂机离开%d分%d秒",mins,secs);
		}
		else format(string,sizeof(string),"挂机离开%d秒",playerupdate[playerid]);
	    UpdateDynamic3DTextLabelText(AFKLabel[playerid], 0x00CDFFFF, string);
	}
	else UpdateDynamic3DTextLabelText(AFKLabel[playerid],0x00000000," ");
}
stock CheckPausing(playerid)
{
   if(GetTickCount() > ( GetPVarInt(playerid,"LastUpdate") + 3000 ) && GetPlayerState(playerid) != PLAYER_STATE_PASSENGER)return 1;
   return 0;
}
/*public OnPlayerJump(playerid, bool:start, Float:z, Float:dist, time)
{
	if(ffdtopen)
	{
	    if(GetadminLevel(playerid)<1)
	    {
			if(IsPlayerInDynamicArea(playerid,ffdtarea))
			{
				new Float:ran=randfloat(2);
				SetPlayerPos(playerid,317.8049+ran,1553.0446+ran,1100.3053+ran);
			}
		}
	}
	return 1;
}*/


