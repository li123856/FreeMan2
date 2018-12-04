stock reloadobj(idx)
{
    foreach(new i:SOBJ[idx])
	{
		if(IsValidDynamicObject(SOBJ[idx][i][SO_ID]))DestroyDynamicObject(SOBJ[idx][i][SO_ID]);
	}
	Iter_Clear(SOBJ[idx]);
	LoadDynamicOBJFrom(idx);
	return 1;
}
Function LoadOBJ_Data()
{
	new NameFile[NFSize],idx=0;
	Loop(i, MAX_OBJ_FILE)
	{
        format(NameFile, sizeof(NameFile), Get_Path(i,20), i);
        if(fexist(NameFile))
        {
            LoadDynamicOBJFrom(i);
  			Iter_Add(S_OBJ,i);
 			idx++;
        }
    }
    return idx;
}
stock LoadDynamicOBJFrom(idx)
{
	new loaded=0;
    if(fexist(Get_Path(idx,20)))
    {
		new string[512],index,var_from_line[64],modelid,Float:fX,Float:fY,Float:fZ,Float:fRadius,txd1[32],txd2[32],type,indexes,color;
		new File:example = fopen(Get_Path(idx,20), io_read);
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
						    if(Iter_Count(SOBJ[idx])<MAX_FILE_OBJ)
						    {
								index = 0;
								index = token_by_delim(string,var_from_line,',',index);SOBJ[idx][loaded][SO_MODEL]=strval(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_X]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_Y]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_Z]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_RX]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_RY]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_RZ]= floatstr(var_from_line);
								SOBJ[idx][loaded][SO_WL]=-1;
								SOBJ[idx][loaded][SO_IN]=-1;
								SOBJ[idx][loaded][SO_STRDIS]=300.0;
								SOBJ[idx][loaded][SO_DRADIS]=0.0;
								SOBJ[idx][loaded][SO_ID]=CreateDynamicObject(SOBJ[idx][loaded][SO_MODEL],SOBJ[idx][loaded][SO_X],SOBJ[idx][loaded][SO_Y],SOBJ[idx][loaded][SO_Z],SOBJ[idx][loaded][SO_RX],SOBJ[idx][loaded][SO_RY],SOBJ[idx][loaded][SO_RZ],SOBJ[idx][loaded][SO_WL],SOBJ[idx][loaded][SO_IN],-1,SOBJ[idx][loaded][SO_STRDIS],SOBJ[idx][loaded][SO_DRADIS]);
			                    Iter_Add(SOBJ[idx],loaded);
								loaded++;
							}
						}
					}
					case 2:
					{
						if(ClearLine(string,2))
						{
						    if(Iter_Count(SOBJ[idx])<MAX_FILE_OBJ)
						    {
								index = 0;
								index = token_by_delim(string,var_from_line,',',index);SOBJ[idx][loaded][SO_MODEL]=strval(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_X]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_Y]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_Z]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_RX]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_RY]= floatstr(var_from_line);
								index = token_by_delim(string,var_from_line,',',index+1);SOBJ[idx][loaded][SO_RZ]= floatstr(var_from_line);
								SOBJ[idx][loaded][SO_WL]=-1;
								SOBJ[idx][loaded][SO_IN]=-1;
								SOBJ[idx][loaded][SO_STRDIS]=300.0;
								SOBJ[idx][loaded][SO_DRADIS]=0.0;
								SOBJ[idx][loaded][SO_ID]=CreateDynamicObject(SOBJ[idx][loaded][SO_MODEL],SOBJ[idx][loaded][SO_X],SOBJ[idx][loaded][SO_Y],SOBJ[idx][loaded][SO_Z],SOBJ[idx][loaded][SO_RX],SOBJ[idx][loaded][SO_RY],SOBJ[idx][loaded][SO_RZ],SOBJ[idx][loaded][SO_WL],SOBJ[idx][loaded][SO_IN],-1,SOBJ[idx][loaded][SO_STRDIS],SOBJ[idx][loaded][SO_DRADIS]);
			                    Iter_Add(SOBJ[idx],loaded);
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
							    foreach(new t:SOBJ[idx])SetDynamicObjectMaterial(SOBJ[idx][t][SO_ID],indexes,modelid,txd1,txd2,color);
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
							    foreach(new t:SOBJ[idx])SetDynamicObjectMaterial(SOBJ[idx][t][SO_ID],indexes,modelid,txd1,txd2,color);
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

