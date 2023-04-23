tRetResp = {strResult ="OK"}
require("IC_GAMMA_START")


local DemuraBinData = {}
local DemuraBinDataLen = 0
local DemuraBinCrc = {}
local DemuraAddr = 0X100000
local DemuraFilePath = "//opt//program//demura//Demura_File_Pg_1.bin"
local filePath = "//opt//program//demura//Demura_File_Pg_1.bin"

local MAX_WRITELEN = 512
local MAX_READLEN = 512
-------------- SPI init config --------------
--SPI enable
local gSPIEN = 1
--CS
local gSPICS = 1
--Read-write data bit width
local gSPIBits = 8
--SPI clock

local gSPIClock = 5000000 --5M
--gSPIClock = 10000000
--SPI IP output channel(1:not 2832, 2:2832A, 4:2832B)
local gIPChnSel = 1
--not 2832 data channel setting(E058A and E059A have different definitions)0~3
local gDataChnSel = 3
--serial bus setting, "4-wire" or "3-wire"
local gWireMode = 0
-- SPI Four working modes of SPI bus (SP0, SP1, SP2, SP3)
-- Mode 0: CPOL=0, CPHA=0
-- Mode 1: CPOL=0, CPHA=1
-- Mode 2: CPOL=1, CPHA=0
-- Mode 2: CPOL=1, CPHA=0
-- Mode 3: CPOL=1, CPHA=1
local gFourWireSubMode = 0
--SPI IP 3-wire Signal transmission direction(0:3-wire in, 1:3-wire out)
local gThreeWireMode = 0
--SpiConfig(1, 1, 8, 10000000, 1, channel, 0, 3, 0)


-------------- SPI init config end--------------
local function InitSPI()
        
   local chn = 1
	--Switch I2C/SPI (1 : i2c, 0 : spi)
	SPI.I2CSPISwitch(chn, 0);
	-- E058A  1-mipi c-phy ;2-mipi d-phy 1.5G; 3-dp, 4-flash E059A  1-ttl flash ;2-d-phy 2.5G; 3-lvds;4-dp
	SPI.SetSPIChannel(chn, gDataChnSel)
	MSG.Println("SetSPIChannel : %d", gDataChnSel)
	--  0:1.8 or 1:3.3v
	SPI.SetSPILevel(chn, 1)
	SPI.SetI2cPullUp(chn, 1)

	SPI.SpiConfig(chn, gSPIEN, gSPICS, gSPIBits, gSPIClock, gIPChnSel, gDataChnSel, gWireMode, gFourWireSubMode, gThreeWireMode)
	-- set CS Mode 0
	SPI.SpiSetCsMode(chn, 0)
	
	PWR.SetPwrOnOff(chn, POWER_TYPE_VDDIO, ON);--SPI
	
end

local function GetFileCRCData(filePath)
    
    local str
    local block = 8
    local CRCData = {}
    
    local fread = io.open(filePath, "rb");
    --local current = fread:seek();
    local size = fread:seek("end");
    fread:seek("end", -4)
    --fread:seek("set", current);
    --local content = fread:read("*a")
    
    
    while true do
		local bytes = fread:read(block)

		if not bytes then
			break
		end

		for b in string.gmatch(bytes, ".") do
			--io.write(string.format("%02X ", string.byte(b)))
			str = string.format("%02X ", string.byte(b))
			table.insert(CRCData, tonumber(str,16))
		end

	end
    fread.close()
    return CRCData;
end


local function GetFileSize(filePath)
    
    local fread = io.open(filePath, "rb");
    local size = fread:seek("end");
    fread.close()
    return size;
end

local function ReadBinaryFile(binPath)

	local f
	local block = 8
	local BinaryFileTb = {nil}
    local str

	f = assert(io.open(binPath, "rb"))

	while true do
		local bytes = f:read(block)

		if not bytes then
			break
		end

		for b in string.gmatch(bytes, ".") do
			--io.write(string.format("%02X ", string.byte(b)))
			str = string.format("%02X ", string.byte(b))
			table.insert(BinaryFileTb, tonumber(str,16))
		end

	end
	--FlowPause(2000)
	f:close()
	--g_pImageFile =  BinaryFileTb
	--g_imageFileSize = #BinaryFileTb

	return BinaryFileTb

end

-- 64KB Block Erase
local function BlockErase64K(chn, addr)
    
    local writeData = {0x06}
    SPI.Write(chn, writeData)
    TIME.Delay(5)
    
    writeData = {}
    writeData[1] = 0xD8
    writeData[2] = (addr >> 16)& 0xFF
    writeData[3] = (addr >> 8)& 0xFF
    writeData[4] = addr & 0xFF
    
    SPI.Write(chn, writeData)
    
end

local function QSPIWriteFlash(chn, addr, data)
    
    local totalLen = #data
    local maxWriteLen = 0x100
    local writeLen = 0
    local writeData = {}
    local offset = 0
    local addrLen = 3
    

    --local writeData = {}
    --QspiFlashWrite(1, 0x32, 4, 0x20000, 4, writeData);
    while offset < totalLen do
        
        if totalLen - offset > maxWriteLen then
            writeLen = maxWriteLen
        else
            writeLen = totalLen - offset
        end
        -- write enable
        writeData = {0x06}
        SPI.Write(chn, writeData)
        writeData = ADDP.CarveTb(data, offset + 1, writeLen)
        --QspiFlashWrite(1, 0x32, addrLen, addr + offset, writeLen, writeData);
        MSG.Println("addr : 0x%05X, offset : 0x%05X, writeLen : %d", addr, offset, writeLen)
        SPI.QuadInputPageProgram(chn, 0x32, addr + offset, addrLen, writeData)
       
        --MSG.Println("writeData : %s", ADDP.Array2Hexstr(writeData))
        --addr = addr + writeLen
        offset = offset + writeLen
        TIME.Delay(5)
    end
    
end


local function SPIWriteFlash(chn, addr, data)
    
    local totalLen = #data
    local maxWriteLen = 0x100
    local writeLen = 0
    local writeData = {}
    local offset = 0
    local addrLen = 3


    --local writeData = {}
    --QspiFlashWrite(1, 0x32, 4, 0x20000, 4, writeData);
    while offset < totalLen do
        
        if totalLen - offset > maxWriteLen then
            writeLen = maxWriteLen
        else
            writeLen = totalLen - offset
        end
        -- write enable
        writeData = {0x06}
        SPI.Write(chn, writeData)
        writeData = ADDP.CarveTb(data, offset + 1, writeLen)
        --QspiFlashWrite(1, 0x32, addrLen, addr + offset, writeLen, writeData);
        MSG.Println("addr : 0x%05X, offset : 0x%05X, writeLen : %d", addr, offset, writeLen)
        -- MSG.Println("writeData : %s", ADDP.Array2Hexstr(writeData))
        SPI.QuadInputPageProgram(chn, 0x32, addr + offset, addrLen, writeData)

        --addr = addr + writeLen
        offset = offset + writeLen
        TIME.Delay(50)
    end
    
end


--[02][02]0009Ch,1,TURNON[03]
local function F_Third_POWER_ON(thirdCfg)
    local ret = "OK" 
    local res = {}
    local chn = 1

    MSG.Debug("F_Third_POWER_ON")
    -- F_POWER_ON();
    --F_ON_SQ_BEFORE_MTP();
    F_STEP_01()
    g_StepNo = 1;

    TIME.Delay(2000);
    GPIO.SetGpioOutOnOff(chn, 6, ON)
    GPIO.SetGpioOutOnOff(chn, 7, ON)

    testI2cWriteTcomCGpio();

    testI2cWriteTcomReg6000CGpioOff();

    --testI2cReadTcomCGpio();
    testI2cCheckQspiFlashCrcOne4937_11();

    return ret,res
end

--[02][02]0009Ch,1,TURNOFF[03]
local function F_Third_POWER_OFF(thirdCfg)
    local ret = "OK" 
    local res = {}
    MSG.Debug("F_Third_POWER_OFF")

    F_STEP_RESET()
    clearstepno()

    --GetGeneralGpioStatusAsInPut(6);
    --GetGeneralGpioStatusAsInPut(7);

    return ret,res
end




--[02][02]0009Ch,1,FLASHERASE[03]
local function F_Third_FLASHERASE(thirdCfg)
    local chn = 1
    local ret = "OK" 
    local res = {}
    --EraseFlash()

    F_SPIControl()
    TIME.Delay(100);
    GPIO.SetGpioOutOnOff(chn, 4, ON)

    MSG.Println("Read Binary File ...")
	
    local DemuraBinDataLen = GetFileSize(DemuraFilePath)
    --local DemuraBinDataLen = 0x2EE004;
    --DemuraBinCrc = GetFileCRCData(DemuraFilePath)
    MSG.Println("--------------------------------")
    MSG.Println("DeMura bin file Size : %d, 0x%X", DemuraBinDataLen, DemuraBinDataLen)
    MSG.Println("DeMura bin CRC Data : %s", ADDP.Array2Hexstr(DemuraBinCrc))
    MSG.Println("--------------------------------")
    
    -- 0: spi init
    InitSPI()
    
    -- 1: read Flash ID 0x9F
	-- set die 0
    writeData = {0xF8}
    local dieID = SPI.Read(chn, writeData, 1)
    MSG.Println("1---read dieID 0xF8 : 0x%02X", dieID[1])
    writeData = {0xC2, 0x00}
    SPI.Write(chn, writeData)
    TIME.Delay(50)
    writeData = {0xF8}
    local dieID = SPI.Read(chn, writeData, 1)
    MSG.Println("2---read dieID 0xF8 : 0x%02X", dieID[1])

    -- software Reset
    writeData = {0x66}
    SPI.Write(chn, writeData)
    writeData = {0x99}
    SPI.Write(chn, writeData)
    local writeData = {0x9F}
    local readLen = 3
    local FlashID = SPI.Read(chn, writeData, readLen)
    MSG.Println("Flash ID : %s", ADDP.Array2Hexstr(FlashID))
    if FlashID[1] == 0 or FlashID[1] == 0xFF then
        MSG.Error("read FlashID NG !")
        return 1
    end

   -- read status
    local data_05 = SPI.Read(1, {0x05}, 2);
    local data_35 = SPI.Read(1, {0x35}, 2);
    --MSG.Println("falsh status 05 : %s", ADDP.Array2Hexstr(data_05))
    --MSG.Println("falsh status 35 : %s", ADDP.Array2Hexstr(data_35))
    TIME.Delay(5)
    
    -- erase
    MSG.Println("Erase ... start")
    local offsetAddr = 0x00000
    while(offsetAddr < DemuraBinDataLen ) do
        local eraseAddr = DemuraAddr + offsetAddr
        MSG.Println("CMD_BlockErase_64K, eraseAddr : 0x%06X", eraseAddr)
        BlockErase64K(chn, eraseAddr)
        offsetAddr = offsetAddr + 0x10000
        
        --MSG.Println("read status ")
        for i = 1, 100 do
            --MSG.Println("----- ".. i)
            data_05 = SPI.Read(1, {0x05}, 2);
            data_35 = SPI.Read(1, {0x35}, 2);
            --MSG.Println("falsh status 05 : %s", ADDP.Array2Hexstr(data_05))
            --MSG.Println("falsh status 35 : %s", ADDP.Array2Hexstr(data_35))
            if data_05[1] & 0x01 == 0x00 then
                --MSG.Println("falsh status 05 : %s", ADDP.Array2Hexstr(data_05))
                --MSG.Println("falsh status 35 : %s", ADDP.Array2Hexstr(data_35))
                break
            end
            TIME.Delay(10)
        end
    end
	
    MSG.Println("Erase ... end")
    MSG.Debug("flash  erase success")
    return ret,res;
end

--[02][02]0009Ch,1,ROMWRITE[03]
--[02][02]0009Ch,1,ROMWRITE[03]
local function F_Third_ROMWRITE(thirdCfg)
    local chn = 1
    local ret = "OK" 
    local res = {}

    MSG.Debug("demura write bin")
    
    
    ret = F_OTPWriteDemura()

    
    
    --[[
	power ON / OFF
    TIME.Delay(200)
	F_POWER_OFF()
    TIME.Delay(500)
    F_POWER_ON()
    TIME.Delay(100)
	SYS.SwitchPtn(gChannel, "W128.a1");
    TIME.Delay(200)
 

-- 5: read data
    MSG.Println("read Data-----------------3")
    -- write enable1
   -----------------------------------------------------
   
   local DemuraTCONCrc = ReadDemuraCRC()
   DemuraBinCrc = GetFileCRCData(DemuraFilePath)
   --local CRCData = GetFileCRCData(filePath)
   --DemuraBinCrc = GetFileCRCData(DemuraFilePath)
   
   MSG.Println("DemuraBinCrc : %s", ADDP.Array2Hexstr(CRCData))
	MSG.Println("DemuraTCONCrc : %s", ADDP.Array2Hexstr(DemuraTCONCrc))
    local crcret = ADDP.CompareTb(CRCData, DemuraTCONCrc, 4)
    if crcret ~= 0 then
        MSG.Error("Check Demura CRC NG!")
    else
        MSG.Println("Check Demura CRC OK!")
    end
 --]]

   return ret,res;

end


--[02][02]0009Ch,1,DEMURAON[03]
local function F_Third_DEMURAON(thirdCfg)
    local ret = "OK" 
    local res = {}
    InitI2C()
    TIME.Delay(100)
    Demura_ON()
    MSG.Debug("F_Third_DEMURAON")

    UninteI2C()
    return ret,res;

end

--[02][02]0009Ch,1,DEMURAOFF[03]
local function F_Third_DEMURAOFF(thirdCfg)
    local ret = "OK" 
    local res = {}

    InitI2C()
    TIME.Delay(100)
    Demura_OFF()
    MSG.Debug("F_Third_DEMURAOFF")
    UninteI2C()
    --ret = "NG" 
    return ret,res;

end

--[02][02]0015Ch,1,PTRN,PAINT,255,0,255[03]
--[02][02]0015Ch,1,PTRN,3[03]
local function F_Third_SHOWPTN(thirdCfg)
    local ret = "OK" 
    local res = {}
    local chn = 1

    if thirdCfg.param[2] == "PAINT" then
        local R = tonumber(thirdCfg.param[3])
        local G = tonumber(thirdCfg.param[4])
        local B = tonumber(thirdCfg.param[5])

        MSG.Debug("SHOWRGB")
		
        if R == 253 and G == 253 and B == 253 then
			SYS.CloseRGB()
			SYS.SwitchPtn(chn,"Locate.a1")
		elseif R == 254 and G == 254 and B == 254 then
			SYS.CloseRGB()
			SYS.SwitchPtn(chn,"Focus.a1")
		else
			SYS.SwitchRGB(chn, R, G, B)
		end

    else
        MSG.Debug("Show ptn by index")
        --MSG.Debug("11111 = " .. PatternTable[tonumber(thirdCfg.param[2],16)])
        if PatternTable[tonumber(thirdCfg.param[2],16)] == nil then
            ret = "NG"
            res = {"No Pattern"}
            MSG.Debug(ret)
            return ret,res;
        end
        SYS.CloseRGB()
        SYS.SwitchPtn(chn, PatternTable[tonumber(thirdCfg.param[2],16)])
    end

    return ret,res;

end
local function F_Third_SETPANELID(thirdCfg)
	local ret = "OK" 
	local res = {}
	MSG.Debug("F_Third_SETPANELID")
	gPanelID = ""
	gPanelID = thirdCfg.param[2]
	if gPanelID == nil or gPanelID == "" then
		ret = "NG" 
	end
	MSG.Debug(gPanelID)
	--ret = "NG" 
	return ret,res;

end

ThirdPartyMap = 
{
    ["TURNON"] = F_Third_POWER_ON,
    ["TURNOFF"] = F_Third_POWER_OFF,
    ["FLASHERASE"] = F_Third_FLASHERASE,
    ["ROMWRITE"] = F_Third_ROMWRITE,
    ["DEMURAON"] = F_Third_DEMURAON,
    ["DEMURAOFF"] = F_Third_DEMURAOFF,
    ["PTRN"] = F_Third_SHOWPTN,
	["GET_RECIPE"] = F_Third_GETRECIPE,
	["SETPANELID"] = F_Third_SETPANELID,
}

function F_THIRD_CMD_PROCESS(thirdCfg)

    local ret = "OK" -- "OK", "NG"
    local res = {} -- exp. {"test third func",2,7}
    local nRet = 0  --0 ==OK,1==NG

    MSG.Println("F_THIRD_CMD_PROCESS ... start")
    local ThirdFunc = nil
    ThirdFunc = ThirdPartyMap[thirdCfg.param[1]]
    if ThirdFunc == nil then
        MSG.Println("Unregistered!Unregistered!Unregistered!")
        ret = "NG"
        res = {"Unregistered"}
        return ret,res;
    end


    ret,res = ThirdFunc(thirdCfg)


    MSG.Println("F_THIRD_CMD_PROCESS ... end")

    -- res = {"Unregistered"}
    return ret, res
end

local function ReadBinFile(binPath)
    
    local fread = io.open(binPath, "rb");
    local size = fread:seek("end");
    fread:seek("set");
    local readdata = fread:read(size);

    local filedata = {};
    for i = 1, size do
        filedata[i] = string.byte(string.sub(readdata, i, i))
        --table.insert(filedata, string.byte(string.sub(readdata,i,i)));
    end
    fread:close();
    
    return filedata
end
function F_THIRD_CMD_REPLY(k_cmd,Para,ret)
	local factoryTestInfo = {
        cmd             = "commonluafunc",
        pg              = {1},      -- PG ID, exp:[1,2,3];[255]all PG
		channel         = {1},
		position = -1,
		['3rdcmd'] = tostring(k_cmd),
		param = {},
		--result = tostring(rst),
    }
	for i = 1, #Para do
		factoryTestInfo.param[i] = Para[i]
	end
	
	if ret ~= nil then
		factoryTestInfo.result = ret
	end
	
    factoryTestInfo.pg[1] = GetPgId()

    ReportInfo(factoryTestInfo)
end