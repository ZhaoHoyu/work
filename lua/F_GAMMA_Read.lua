
function Tranbin2REG_line(color_index,gray_value,bin_table)-- 列 16*102行//(34*3)
local gamma_reg_table = {};
local RGB_Index ={};
local gray_index = {};

	table.insert(gamma_reg_table,color_index)
	table.insert(gamma_reg_table,gray_value)
	
   for m = 3, #bin_table,3 do 
	
	 if m == 15 then
		table.insert(gamma_reg_table,((bin_table[m] << 4 )& 0xFF0)+((bin_table[m-1]>> 4) & 0x0F));

		else
		table.insert(gamma_reg_table,((bin_table[m] << 4 )& 0xFF0)+((bin_table[m-1]>> 4) & 0x0F));
		table.insert(gamma_reg_table,(bin_table[m+1] & 0xFF)+((bin_table[m+2]<< 8) & 0xF00));
		end

   end
   
    ------------add vdata------------------
	local VGMP_V = 6.6;
	local VGSP_V = 0.25;
	for k = 3,#gamma_reg_table do
	table.insert(gamma_reg_table,VGMP_V-(VGMP_V-VGSP_V)/4096*gamma_reg_table[k])
	end
	
	---------------------------------------------------------------
	--[[
	  ----存16进制
   for k = 3,11 do
   gamma_reg_table[k] = string.format('%x', gamma_reg_table[k])
   end
   --]]
   

    return gamma_reg_table;
end

function F_OTPReadGammaHEX_GRAY()
   
    local ret = 0
    local chn = 1
    local readData = {}
    local writeData = {}
    local readLen = 0
	local FolderName = GetLuaFolderName()
	local band_num = 34;
	local filename =
        string.format('Gamma_READ_PANEL_%s.CSV',  os.date('%Y%m%d%H%M%S'))
 local gray_index =  {255, 247, 239, 231, 223, 215, 207, 199, 191, 183, 175, 159, 143, 127, 111, 95, 79, 63, 55, 47, 39, 31, 23, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1, 0}

        local tContent_final = {
        {
            'Color',
            'Gray'
   
        }
    }
	for i = 18,10,-1 do
	table.insert(tContent_final[1],"REG_band"..i)
	end
	for i = 18,10,-1 do
	table.insert(tContent_final[1],"Vdata_band"..i)
	end
	
	
	--InitSPI()
    MSG.Println("F_OTPReadGamma ... start")
    F_SPIControl()
    TIME.Delay(100);
    
    GPIO.SetGpioOutOnOff(chn, 4, ON)
    
    local gammaAddr = 0x20000
    
    -- 0: spi init
    InitSPI()
	MSG.Println("WAIT 500 !")
     TIME.Delay(500);
    -- 1: read Flash ID 0x9F
    writeData = {0x9F}
    readLen = 3
    local FlashID = SPI.Read(chn, writeData, readLen)
    --MSG.Println("Flash ID : %s", ADDP.Array2Hexstr(FlashID))
    if FlashID[1] == 0 or FlashID[1] == 0xFF then
        MSG.Error("read FlashID NG !")
        return 1
    end
    
    -- 2 : read status
    local data_05 = SPI.Read(1, {0x05}, 2);
    local data_35 = SPI.Read(1, {0x35}, 2);
   -- MSG.Println("falsh status 05 : %s", ADDP.Array2Hexstr(data_05))
   -- MSG.Println("falsh status 35 : %s", ADDP.Array2Hexstr(data_35))
    TIME.Delay(5)
   --
    -- 3 : read Gamma
    -- write enable
    writeData = {0x06}
    SPI.Write(chn, writeData)
    TIME.Delay(5)
    local tContent={}
	local offset = {0,4480,8960}--4480*16*35*8--index for R G B
	local color_index = {"R","G","B"}
	for m = 1,3 do
	
    for i = 1, band_num do
	    local readLen = 0x10
        local addr = gammaAddr + offset[m]+(i - 1) * readLen
        local buf = {}
        local cmd = 0x6B
        local addrLen = 3
    
		--MSG.Println("read Data-----------------R")

		local readBuf = FlashRead(chn, addr, readLen)
		local readBuf_hex ={};

		readBuf_hex = Tranbin2REG_line(color_index[m],gray_index[35-i],readBuf)

		table.insert(tContent,readBuf_hex)
    end
    end
-------------------------------------------------TAPPOINT_REG_IN_tContent-------------------------------------------------------------
------------------------------------------------CAL ALL THE GRAY-----------------------------------------------------------
	local gray_all_list ={};--for tContent_gray gray_index for tContent
	local tContent_gray = {};
	local low_gray =1;
	local hige_gray =3;
	local VGMP_V = 6.6;
	local VGSP_V = 0.25;
	for i = 0,255 do
	table.insert(gray_all_list,i);
	end
	
	for j = 1,256 do
	tContent_gray[j] = {}
	tContent_gray[j+256] = {}
	tContent_gray[j+512] = {}
	MSG.Println("Cal the gray of = "..gray_all_list[j])
		for k = band_num,1,-1 do
		
		   if gray_index[k] == gray_all_list[j] then
		   tContent_gray[j] = tContent[35-k];
		   tContent_gray[j+256] = tContent[35-k+34];
		   tContent_gray[j+512] = tContent[35-k+68];
		    break
		   elseif gray_index[k]>gray_all_list[j] then
		   hige_gray = gray_index[k]
		   low_gray = gray_index[k+1]

		   
		   for m = 1,#tContent[k] do

			 if m == 1 then
			    tContent_gray[j][m] =  tContent[k][m]
				tContent_gray[j+256][m] =  tContent[k+34][m]
				tContent_gray[j+512][m] =  tContent[k+68][m]
		
			 elseif m ==2 then
				tContent_gray[j][m] = j-1;
				tContent_gray[j+256][m] = j-1;
				tContent_gray[j+512][m] = j-1;
				
			  elseif m <= 11 then	
				tContent_gray[j][m] = math.ceil(tContent[35-k-1][m] +(tContent[35-k][m] -  tContent[35-k-1][m]) * (gray_all_list[j] - low_gray) /(hige_gray - low_gray) +0.5)
				tContent_gray[j+256][m] = math.ceil(tContent[35-k-1+34][m] +(tContent[35-k+34][m] -  tContent[35-k-1+34][m]) * (gray_all_list[j] - low_gray) /(hige_gray - low_gray) +0.5)
				tContent_gray[j+512][m] = math.ceil(tContent[35-k-1+68][m] +(tContent[35-k+68][m] -  tContent[35-k-1+68][m]) * (gray_all_list[j] - low_gray) /(hige_gray - low_gray) +0.5)
			 else-- cal the data voltage
				tContent_gray[j][m] = VGMP_V-(VGMP_V-VGSP_V)/4096*tContent_gray[j][m-9]
				tContent_gray[j+256][m] =VGMP_V-(VGMP_V-VGSP_V)/4096*tContent_gray[j+256][m-9]
				tContent_gray[j+512][m] =VGMP_V-(VGMP_V-VGSP_V)/4096*tContent_gray[j+512][m-9]
				end
			 
			 end
		  
		   break
		   end
		   
		end
		
	end

	for j = 1,#tContent_gray do

	table.insert(tContent_final,tContent_gray[j])
	--table.insert(tContent_final,tContent_gray[j+256])
	--table.insert(tContent_final,tContent_gray[j+512])
	
	end

    MSG.Println("F_OTPReadGamma ... end")
    WriteCsv(FolderName .. 'CSV//' .. filename, tContent_final)
    F_SaveCSV2PC(filename)
	MSG.Debug(string.format('GAMMA READ  Complete'))
    return ret
    
end
