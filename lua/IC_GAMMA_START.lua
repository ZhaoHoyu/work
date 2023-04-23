--/******************** JC ***********************************************
--* File Name          : IC_GAMMA_START.lua
--* Author             : yinsjun
--* Version            : V1.0.0
--* Date               : 2020-04-03
--* Description        : GAMMA Tuning flow
--*********************************************************************/
require 'GammaSpec'
require 'gammaif'
require 'PowerOn'
require 'I2C'
require 'IC_ELVSS_VBLACK'
--require 'butest'
--require "PScript"
--gCSVDataFile = {{}}
--gTunningStepCSV = {{}}
--gTunningStepCSVName = ""
--gTunningIdx = 0;
gTuningRecordContentHead = 0 -- GammaTuning调节记录标题
gTuningRecordContent = '' -- GammaTuning调节记录
GAMMA.setMaxIteration(300)
local CMD = {0x10}
local Dummy = 0xFF
gCA410SyncFlag = 0
gFreq = 59.7
ELVSSTb = {}


function fre(ttdata)
    InitI2C()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001

        addr = 0x0931
        tdata = ttdata
        I2C_WRITE_CMD(addr, tdata, CMD)

        MSG.Println('read addr : 0x%04X', addr)
        buffer = I2C_READ_CMD(addr, buffer, 2, CMD)
        MSG.Println(#buffer)
    end
    I2C_DEBUG_EXIT_MODE()
end



function F_SaveCSV2PC_B12(filename, fold)
    local PcIP = GetPcIp()
    local ftpPath = string.format('ftp://%s//%s//', PcIP, fold)
    --"ftp://192.168.10.111/"

    local filepath = GetLuaFolderName()

    local FTP = require('JC_FTP')
    --通用路径
    filepath = filepath .. 'CSV/'
    --TP路径
    --filepath = filepath .. "tpdata/"
    --MSG.Println(filepath)
    FTP.SendFile2UIS(ftpPath, filename, filepath)
end





local function gtp_manual_reset()
    local chn = 1
    GPIO.SetGpioOutVol(chn, 1, 1) --3.3V
    --GPIO.MIPISET1(chn, ON);
    GPIO.MIPISET2(chn, ON)
    TIME.Delay(300)
end



-- Data remapping  ON
-- 0x13D20[3]=1
function F_Remapping_ON()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)
        --0x13D40[3]=1
        addr = 0x13D40
        tdata = 0x0008
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
    MSG.Println('Data remapping ON')
end

-- Data remapping  OFF
-- 0x13D20[3]=1
function F_Remapping_OFF()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)
        --0x13D40[3]=0
        addr = 0x13D40
        tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
    MSG.Println('Data remapping OFF')
end

function F_DCC_OFF()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)
        --0x13D40[3]=0
        addr = 0x23802
        tdata = 0xFFFF
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
    MSG.Println('DCC OFF')
end

function Demura_ON()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        -- I2C_WRITE_CMD(addr, tdata, CMD)
        --0x13102[0]=1
        addr = 0x13102
        tdata = 0x0001
        I2C_WRITE_CMD(addr, tdata, CMD)

        MSG.Println('read addr : 0x%04X', addr)
        buffer = I2C_READ_CMD(addr, buffer, 2, CMD)
        MSG.Println(#buffer)
    end
    I2C_DEBUG_EXIT_MODE()
end

function Demura_OFF()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)
        --0x13102[0]=0
        addr = 0x13102
        tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)
        TIME.Delay(1)
        local buffer = {}
        buffer = I2C_READ_CMD(addr, buffer, 2, CMD)
        TIME.Delay(550)
    end
    I2C_DEBUG_EXIT_MODE()
    MSG.Println('Demura_OFF')
end

function F_HDR_OFF()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)
        --0x13D40[3]=0
        addr = 0x23800
        tdata = 0xF6FF
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
    MSG.Println('HDR OFF')
end
function SPR_ON()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()

    addr = 0x22806
    tdata = 0x0001
    I2C_WRITE_CMD(addr, tdata, CMD)

    I2C_DEBUG_EXIT_MODE()
end
function SPR_OFF()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()

    addr = 0x22806
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    I2C_DEBUG_EXIT_MODE()
end

function CTB_ON()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()

    addr = 0x23802
    tdata = 0xBF
    I2C_WRITE_CMD(addr, tdata, CMD)

    I2C_DEBUG_EXIT_MODE()
end
function CTB_OFF()
    InitI2C()
    I2C_DEBUG_ENTER_MODE()

    addr = 0x23802
    tdata = 0xBB
    I2C_WRITE_CMD(addr, tdata, CMD)

    I2C_DEBUG_EXIT_MODE()
end

function DBI_ON()
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)

        --0x23800[8] = 0
        addr = 0x23800
        tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)

        --0x30712[15] = 1
        addr = 0x30712
        tdata = 0x0080
        I2C_WRITE_CMD(addr, tdata, CMD)

        --0x094F[10] = 0
        addr = 0x094F
        tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
end

function DBI_OFF()
    local ret = 0

    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        local addr = 0x100000
        local tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)
        -- 0x094F[10] = 1
        addr = 0x099F
        tdata = 0x0004
        I2C_WRITE_CMD(addr, tdata, CMD)
        TIME.Delay(100)
        -- Read 0x094F[11] = 0
        local buffer = {}
        local readLen = 2
        buffer = I2C_READ_CMD(addr, buffer, readLen, CMD)
        if buffer[1] & 0x08 ~= 0 then
            MSG.Error('DBI_OFF NG!')
            break
        end

        --MSG.Pringtln("0x%02X, 0x%02X,", buffer[1], buffer[2])
        --MSG.Pringtln("0x%02X, 0x%02X,", buffer[1], buffer[2])
        --0x30725[7] = 0
        addr = 0x30725
        tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)

        --0x23801[0] =  1
        addr = 0x23801
        tdata = 0x0001
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
end

function DBV_ByI2C()
    local addr = 0x100000
    local tdata = 0x0001

    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        addr = 0x100000
        tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)

        --0x0981[1]=1  By I2C控制
        addr = 0x0981
        tdata = 0x0002
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
end

function DBV_ByDPCD()
    local addr = 0x00000
    local tdata = 0x0000
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        addr = 0x100000
        tdata = 0x0001
        --I2C_WRITE_CMD(addr, tdata, CMD)

        --0x0981[1]=0  By I2C控制
        addr = 0x0981
        tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
end

function F_I2CWRITE(addr, tadta)
    --local addr = 0x00000
    --local tdata = 0x0000
    I2C_DEBUG_ENTER_MODE()
    for i = 1, 1 do
        --addr = 0x0981
        --tdata = 0x0000
        I2C_WRITE_CMD(addr, tdata, CMD)
    end
    I2C_DEBUG_EXIT_MODE()
end
function F_SPIControl()
    InitI2C()
    --I2CEnterDebug()
    I2C_DEBUG_ENTER_MODE()
    local writeData = {0x10, 0x10, 0x00, 0x00, 0x01, 0x00}
    I2C_WriteData(writeData)
    writeData = {0x10, 0x01, 0x0E, 0x78, 0xAA}
    I2C_WriteData(writeData)
    TIME.Delay(30)
    writeData = {0x10, 0x10, 0x00, 0x00, 0x01, 0x00}
    I2C_WriteData(writeData)
    writeData = {0x10, 0x01, 0x0E, 0x79, 0xAA}
    I2C_WriteData(writeData)
    TIME.Delay(30)
    I2C_DEBUG_EXIT_MODE()
end

-- [0:30Hz,1:60Hz,2:90Hz,3:120Hz]
local function F_SET_Freq(freqType)
    --pass
end

local function F_EXIT_NORMAL()
    --LOG.PRINTLN("EXIT NOR2 MODE");
    F_ENTER_MODE(10)
end

-- 2021 0507 按IC厂家的code进行设置
function F_ENTER_MODE(nbandindex)
    InitI2C()
	
	gELVSStb ={
     4095,2882, 2397, 1749, 1667, 1386, 1012, 738, 614, -- 30Hz
    --7500,7500, 6600, 5600, 4900, 4900, 4900, 4900, 4900, -- 60Hz POR
     6000,6000, 6000, 5000, 5000, 5000, 5000, 5000, 5000, -- 60Hz LLCD EN2两边	
	--7800,7800, 7000, 6100, 5300, 5300, 5300, 5300, 5300, -- 60Hz LLCD EN3 两边
	--8000,8000, 7200, 6200, 5300, 5300, 5300, 5300, 5300, -- 60Hz LLC EN3 三边
	--8000,8000, 7200, 6200, 5300, 5300, 5300, 5300, 5300, -- 60Hz LLC EN3 四边待定
	--8000,8000, 6900, 5700, 5000, 5000, 5000, 5000, 5000, -- 60Hz LLC  四边
	--6600,6600, 4900, 3300, 2700, 2700, 2700, 2700, 2700, -- 60Hz SINGLE
    4095,2882, 2397, 1749, 1667, 1386, 1012, 738, 614, -- 90Hz
    4095,2882, 2397, 1749, 1667, 1386, 1012, 738, 614, -- 120Hz
	}
	
	if nbandindex >= 10 and nbandindex <= 17 and ELVSSTb[nbandindex - 9] then
	MSG.Println("2222222 ="  )
	local elvssvol = getElvssByReg(ELVSSTb[nbandindex - 9]) * 1000
	MSG.Println("333333333333 ="  )
	gELVSStb[nbandindex] = math.abs(elvssvol)
	
	MSG.Println("set elvss vol = %s "  , gELVSStb[nbandindex])
	end
	gELVSStb[nbandindex] = math.floor(gELVSStb[nbandindex])
	local VINT2_OFFSET = 1500 ---2500
	PWR.SetRealPwrInfo(gChannel,POWER_TYPE_ELVSS,gELVSStb[nbandindex],12800,0,4000,0);
	MSG.Println("2222222 ="  )
	PWR.SetRealPwrInfo(gChannel,POWER_TYPE_VGL,gELVSStb[nbandindex]-VINT2_OFFSET,12800,0,4000,0);
	--PWR.SetRealPwrInfo(gChannel,POWER_TYPE_VGL,5000,12800,0,3000,0);
	MSG.Println("333333 ="  )
    TIME.Delay(100)
--]]
    local CMD = {0x34, 0x36, 0x45}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end

    -- enter debug
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)

    CMD = {0x51, 0x54, 0x7F, 0x80, 0x82, 0x84, 0x37, 0x35, 0x71, 0x35}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
    TIME.Delay(300)
    --
    WRITE_DATA = {0x10, 0x00, 0x00, 0x00}
    I2C_WriteData(WRITE_DATA)
    TIME.Delay(50)
    --
    local addr = 0x100000
    local addrLen = 3
    local readLen = 1
    local readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)

  
    MSG.Println('DBVtb %d, value : 0x%04X', nbandindex, gDBVtb[nbandindex])
    WRITE_DATA = {0x10, 0x09, 0x81, 0x02}
    I2C_WriteData(WRITE_DATA)

    WRITE_DATA = {0x10, 0x09, 0x80, 0x01}
    I2C_WriteData(WRITE_DATA)
    -- 0x0983 = dbv[11:8]
    WRITE_DATA = {0x10, 0x09, 0x83, (gDBVtb[nbandindex] >> 8) & 0x0F}
    I2C_WriteData(WRITE_DATA)
    -- 0x0982 = dbv[7:0]
    WRITE_DATA = {0x10, 0x09, 0x82, gDBVtb[nbandindex] & 0xFF}
    I2C_WriteData(WRITE_DATA)

    WRITE_DATA = {0x10, 0x09, 0x80, 0x03}
    I2C_WriteData(WRITE_DATA)

    TIME.Delay(300)

end

function F_ENTER_MODE_DBV(DBV_VALUE)
    --InitI2C()
	
	gELVSStb = {
    4095,2882, 2397, 1749, 1667, 1386, 1012, 738, 614, -- 30Hz
    --7800,7800, 6800, 5700, 4900, 4900, 4900, 4900, 4900, -- 60Hz LLCD两边
	7800,7800, 7000, 6100, 5300, 5300, 5300, 5300, 5300, -- 60Hz LLCD EN3 两边
	--8000,8000, 7200, 6200, 5300, 5300, 5300, 5300, 5300, -- 60Hz LLC EN3 三边
	--8000,8000, 7200, 6200, 5300, 5300, 5300, 5300, 5300, -- 60Hz LLC EN3 四边待定
	--8000,8000, 6900, 5700, 5000, 5000, 5000, 5000, 5000, -- 60Hz LLC四边
	--6600,6600, 4900, 3300, 2700, 2700, 2700, 2700, 2700, -- 60Hz SINGLE
    4095,2882, 2397, 1749, 1667, 1386, 1012, 738, 614, -- 90Hz
    4095,2882, 2397, 1749, 1667, 1386, 1012, 738, 614, -- 120Hz
    }
	local nbandindex = 10;
	
	for k = 10,18 do
	if DBV_VALUE >= gDBVtb[k] then
	  nbandindex = k-1;
	  break;
	end
	MSG.PRINTLN("BANDINDEX = "..nbandindex)
	end
	
	local VINT2_OFFSET = 1500
	PWR.SetRealPwrInfo(gChannel,POWER_TYPE_ELVSS,gELVSStb[nbandindex],12800,0,3000,0);
	PWR.SetRealPwrInfo(gChannel,POWER_TYPE_VGL,gELVSStb[nbandindex]-VINT2_OFFSET,12800,0,3000,0);
	--PWR.SetRealPwrInfo(gChannel,POWER_TYPE_VGL,5000,12800,0,3000,0);
	
    TIME.Delay(100)

    local CMD = {0x34, 0x36, 0x45}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end

    -- enter debug
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)

    CMD = {0x51, 0x54, 0x7F, 0x80, 0x82, 0x84, 0x37, 0x35, 0x71, 0x35}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
    TIME.Delay(300)
    --
    WRITE_DATA = {0x10, 0x00, 0x00, 0x00}
    I2C_WriteData(WRITE_DATA)
    TIME.Delay(50)
    --
    local addr = 0x100000
    local addrLen = 3
    local readLen = 1
    local readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)

    MSG.Println('DBVtb %d, value : 0x%04X', nbandindex, gDBVtb[nbandindex])
    WRITE_DATA = {0x10, 0x09, 0x81, 0x02}
    I2C_WriteData(WRITE_DATA)

    WRITE_DATA = {0x10, 0x09, 0x80, 0x01}
    I2C_WriteData(WRITE_DATA)
    -- 0x0983 = dbv[11:8]
    WRITE_DATA = {0x10, 0x09, 0x83, (DBV_VALUE >> 8) & 0x0F}
    I2C_WriteData(WRITE_DATA)
    -- 0x0982 = dbv[7:0]
    WRITE_DATA = {0x10, 0x09, 0x82, DBV_VALUE & 0xFF}
    I2C_WriteData(WRITE_DATA)

    WRITE_DATA = {0x10, 0x09, 0x80, 0x03}
    I2C_WriteData(WRITE_DATA)

    TIME.Delay(300)
end


function F_ENTER_DBV(nDBV)
    --InitI2C()
    TIME.Delay(100)

    local CMD = {0x34, 0x36, 0x45}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end

    -- enter debug
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)

    CMD = {0x51, 0x54, 0x7F, 0x80, 0x82, 0x84, 0x37, 0x35, 0x71, 0x35}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
    TIME.Delay(300)
    --
    WRITE_DATA = {0x10, 0x00, 0x00, 0x00}
    I2C_WriteData(WRITE_DATA)
    TIME.Delay(50)
    --
    local addr = 0x200000
    local addrLen = 3
    local readLen = 1
    local readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)

    MSG.Println('DBVtb %d, value : 0x%04X', nbandindex, nDBV)
    WRITE_DATA = {0x10, 0x09, 0x81, 0x02}
    I2C_WriteData(WRITE_DATA)

    WRITE_DATA = {0x10, 0x09, 0x80, 0x01}
    I2C_WriteData(WRITE_DATA)
    -- 0x0983 = dbv[11:8]
    WRITE_DATA = {0x10, 0x09, 0x83, (nDBV >> 8) & 0x0F}
    I2C_WriteData(WRITE_DATA)
    -- 0x0982 = dbv[7:0]
    WRITE_DATA = {0x10, 0x09, 0x82, nDBV & 0xFF}
    I2C_WriteData(WRITE_DATA)

    WRITE_DATA = {0x10, 0x09, 0x80, 0x03}
    I2C_WriteData(WRITE_DATA)

    TIME.Delay(300)
end

--******************************************************************************
--* Function Name  : F_EXIT_MODE
--* Description    : 设置退出模组IC的DBV状态
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : nil
--*******************************************************************************
function F_EXIT_MODE(nbandindex)
    F_EXIT_NORMAL()
end

--******************************************************************************
--* Function Name  : F_GET_RGB_REG_ADDR_BY_BAND
--* Description    : NT系列设置band对应的wRegBF/RM系列设置band对应的page/R系列设置band对应的寄存器(IC厂家提供)
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : nil
--*******************************************************************************
--?规??and缂????峰??gamma?????ュ?瀛??ㄥ?板??
local function F_GET_RGB_REG_ADDR_BY_BAND(bandindex)
    local GammaPage = -1

    if bandindex == gGam1 then
        GammaPage = 0x02 --0x54
    elseif bandindex == gGam2 then
        GammaPage = 0x03 --0x50
    elseif bandindex == gGam3 then
        GammaPage = 0x0D --0x50
    else
    end

    return GammaPage
end

--******************************************************************************
--* Function Name  : F_WRITE_GAMMA_REG
--* Description    : 写入调节绑点的寄存器值
--* Input          : GrayColorIndex(number) (调节绑点的索引号)
--* Return         : ret(0 : OK, 1 : NG)
--*******************************************************************************
function F_WRITE_GAMMA_REG_Test(GrayColorIndex, writeValRed, writeValGreen, writeValBlue)
    local ret = 0
    --gGammaRed[GrayColorIndex - 1] = math.floor((gGammaRed[GrayColorIndex-2] + gGammaRed[GrayColorIndex])/2)
    --gGammaGreen[GrayColorIndex - 1] = math.floor((gGammaGreen[GrayColorIndex-2] + gGammaGreen[GrayColorIndex])/2)
    --gGammaBlue[GrayColorIndex - 1] = math.floor((gGammaBlue[GrayColorIndex-2] + gGammaBlue[GrayColorIndex])/2)

    -- local writeValRed = gGammaRed[GrayColorIndex]
    -- local writeValGreen = gGammaGreen[GrayColorIndex]
    -- local writeValBlue = gGammaBlue[GrayColorIndex]

    local CMD = {0x10}
    local buf = {}

    I2C_DEBUG_ENTER_MODE()
    local addr = 0x00000
    local tdata = 0x0001
    I2C_WRITE_CMD(addr, tdata, CMD)
    --I2C_READ_CMD(addr, buf, 2, CMD)
    --MSG.Debug("I2C_READ_CMD 0x%02X, 0x%02X", buf[1], buf[2])

    addr = 0x11F02
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)
    --I2C_READ_CMD(addr, buf, 2, CMD)

    addr = 0x138D8
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValRed
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0020
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0004
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValGreen
    I2C_WRITE_CMD(addr, tdata, CMD)
    --[[I2C_READ_CMD(addr, buf, 2, CMD)
	UI.PRINTLN((buf[2]<<8)+buf[1])
	UI.PRINTLN(GammaGreen[nIndex])--]]
    addr = 0x138DA
    tdata = 0x0024
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0008
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValBlue
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0028
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x1000
    I2C_WRITE_CMD(addr, tdata, CMD)

    I2C_DEBUG_EXIT_MODE()

    return ret
end
function F_WRITE_GAMMA_REG(GrayColorIndex)
    local ret = 0
    --gGammaRed[GrayColorIndex - 1] = math.floor((gGammaRed[GrayColorIndex-2] + gGammaRed[GrayColorIndex])/2)
    --gGammaGreen[GrayColorIndex - 1] = math.floor((gGammaGreen[GrayColorIndex-2] + gGammaGreen[GrayColorIndex])/2)
    --gGammaBlue[GrayColorIndex - 1] = math.floor((gGammaBlue[GrayColorIndex-2] + gGammaBlue[GrayColorIndex])/2)

    local writeValRed = gGammaRed[GrayColorIndex]
    local writeValGreen = gGammaGreen[GrayColorIndex]
    local writeValBlue = gGammaBlue[GrayColorIndex]

    local CMD = {0x10}
    local buf = {}

    I2C_DEBUG_ENTER_MODE()

    require 'socket'
    local time1 = socket.gettime()

    local addr = 0x00000
    local tdata = 0x0001
    I2C_WRITE_CMD(addr, tdata, CMD)
    --I2C_READ_CMD(addr, buf, 2, CMD)
    --MSG.Debug("I2C_READ_CMD 0x%02X, 0x%02X", buf[1], buf[2])

    addr = 0x11F02
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)
    --I2C_READ_CMD(addr, buf, 2, CMD)

    addr = 0x138D8
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValRed
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0020
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0004
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValGreen
    I2C_WRITE_CMD(addr, tdata, CMD)
    --[[I2C_READ_CMD(addr, buf, 2, CMD)
	UI.PRINTLN((buf[2]<<8)+buf[1])
	UI.PRINTLN(GammaGreen[nIndex])--]]
    addr = 0x138DA
    tdata = 0x0024
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0008
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValBlue
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0028
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x1000
    I2C_WRITE_CMD(addr, tdata, CMD)

    local time2 = socket.gettime() - time1
    --MSG.Println("I2C_WRITE_CMD time2=%f,GrayColorIndex=%d", time2,GrayColorIndex);
    --MSG.Debug("I2CWrite time2=%f", time2);

    I2C_DEBUG_EXIT_MODE()
    TIME.DELAY(gDelayAfterGammaRegWrite)

    return ret
end

--******************************************************************************
--* Function Name  : F_OTP_READ
--* Description    : 写入调节绑点的寄存器值
--* Input          : GrayColorIndex(number) (调节绑点的索引号)
--* Return         : nCount(number) NT系列gamma烧录次数
--*******************************************************************************
function F_OTP_READ()
    -- do nothing
end

--******************************************************************************
--* Function Name  : F_OTP_WRITE
--* Description    : 模组OTP
--* Return         : ret(0 : OK, 1 : NG)
--*******************************************************************************
function F_OTP_WRITE()
    --do nothing
end

--******************************************************************************
--* Function Name  : F_READ_REG_ONE_BAND
--* Description    : 读取band gamma寄存器值
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : ret(0 : OK, 1 : NG)
--*******************************************************************************
function F_READ_REG_ONE_BAND(bandindex)
    -- do nothing
end

--******************************************************************************
--* Function Name  : F_WRITTE_REG_ONE_BAND
--* Description    : 更新整个gamma band寄存器
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : ret(0 : OK, 1 : NG)
--*******************************************************************************
local function F_WRITTE_REG_ONE_BAND(bandindex)
    -- do nothing
end

--******************************************************************************
--* Function Name  : F_UPDATA_REG_ONE_BAND
--* Description    : 更新整个gamma band寄存器
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : ret(0 : OK, 1 : NG)
--*******************************************************************************
function F_UPDATA_REG_ONE_BAND(bandindex)
    -- do nothing
end

-- 璁＄���﹀��杞�
local function F_CALCULATE_REG_REVERSE(bandIndex)
    local ret = 0
    local offset = (bandIndex - 1) * gMAX_BLIND_NUM
    local index = 0xFF

    for i = 1, gMAX_BLIND_NUM - 1 do
        index = i
        if gGammaRed[offset + i] < gGammaRed[offset + i + 1] then
            ret = 1
            MSG.Warning('bindIndex %d check RegValue Reverse NG ! Red index : %d', bandIndex, index)
            break
        end
        if gGammaGreen[offset + i] < gGammaGreen[offset + i + 1] then
            MSG.Warning('bindIndex %d check RegValue Reverse NG ! Green index : %d', bandIndex, index)
            ret = 1
            break
        end
        if gGammaBlue[offset + i] < gGammaBlue[offset + i + 1] then
            MSG.Warning('bindIndex %d check RegValue Reverse NG ! Blue index : %d', bandIndex, index)
            ret = 1
            break
        end
    end
    if ret ~= 0 then
        --MSG.Warning("bindIndex %d check NG ! index : %d", bandIndex, index)
    else
        MSG.Println('bindIndex %d check RegValue Reverse OK !', bandIndex)
    end

    return ret
end

local function F_CACULATE_REGValue(nBandindex)
    -- 0 gray
    gGammaRed[nBandindex * gMAX_BLIND_NUM] = 0
    gGammaBlue[nBandindex * gMAX_BLIND_NUM] = 0
    gGammaGreen[nBandindex * gMAX_BLIND_NUM] = 0

    local GammaRed_Write_Bin = {}
    local GammaBlue_Write_Bin = {}
    local GammaGreen_Write_Bin = {}

    -- 10bit --> 12bit
    for i = 1, #GRAY_BUF do
        GammaRed_Write_Bin[GRAY_BUF[i] + 1] = gGammaRed[i + (nBandindex - 1) * gMAX_BLIND_NUM] * 4
        GammaBlue_Write_Bin[GRAY_BUF[i] + 1] = gGammaBlue[i + (nBandindex - 1) * gMAX_BLIND_NUM] * 4
        GammaGreen_Write_Bin[GRAY_BUF[i] + 1] = gGammaGreen[i + (nBandindex - 1) * gMAX_BLIND_NUM] * 4
    end

    -- Computational interpolatio
    local index_low = 1
    local index_high = 0
    for i = 1, 256 do
        if GammaRed_Write_Bin[i] == nil then
            for j = i, 256 do
                if GammaRed_Write_Bin[j] ~= nil then
                    index_high = j
                    break
                end
            end

            local step_red = (GammaRed_Write_Bin[index_high] - GammaRed_Write_Bin[index_low]) / (index_high - index_low)
            local step_Green =
                (GammaGreen_Write_Bin[index_high] - GammaGreen_Write_Bin[index_low]) / (index_high - index_low)
            local step_Blue =
                (GammaBlue_Write_Bin[index_high] - GammaBlue_Write_Bin[index_low]) / (index_high - index_low)

            for j = (index_low + 1), (index_high - 1) do
                --GammaRed_Write_Bin[j] = math.floor(GammaRed_Write_Bin[index_low] + step_red * (j - index_low))
                --GammaGreen_Write_Bin[j] = math.floor(GammaGreen_Write_Bin[index_low] + step_Green * (j - index_low))
                --GammaBlue_Write_Bin[j] = math.floor(GammaBlue_Write_Bin[index_low] +step_Blue * (j - index_low))

                GammaRed_Write_Bin[j] = math.ceil(GammaRed_Write_Bin[index_low] + step_red * (j - index_low) + 0.5)
                GammaGreen_Write_Bin[j] =
                    math.ceil(GammaGreen_Write_Bin[index_low] + step_Green * (j - index_low) + 0.5)
                GammaBlue_Write_Bin[j] = math.ceil(GammaBlue_Write_Bin[index_low] + step_Blue * (j - index_low) + 0.5)
            end
        else
            index_low = i
        end
    end

    -- Convert value to storage mode
    for i = 0, 255 do
        for j = 0, 3 do
            if i < 255 then
                GammaRed_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                    math.floor(
                    GammaRed_Write_Bin[i + 1] + ((GammaRed_Write_Bin[i + 2] - GammaRed_Write_Bin[i + 1]) / 4) * j
                )
                GammaGreen_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                    math.floor(
                    GammaGreen_Write_Bin[i + 1] + ((GammaGreen_Write_Bin[i + 2] - GammaRed_Write_Bin[i + 1]) / 4) * j
                )
                GammaBlue_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                    math.floor(
                    GammaBlue_Write_Bin[i + 1] + ((GammaBlue_Write_Bin[i + 2] - GammaBlue_Write_Bin[i + 1]) / 4) * j
                )
            else
                if math.floor(GammaBlue_Write_Bin[i + 1] + (GammaBlue_Write_Bin[i + 1] - GammaBlue_Write_Bin[i])) > 4095 then
                    GammaRed_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                        math.floor(GammaRed_Write_Bin[i + 1] + ((4095 - GammaRed_Write_Bin[i + 1]) / 4) * j)
                    GammaGreen_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                        math.floor(GammaGreen_Write_Bin[i + 1] + ((4095 - GammaRed_Write_Bin[i + 1]) / 4) * j)
                    GammaBlue_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                        math.floor(GammaBlue_Write_Bin[i + 1] + ((4095 - GammaBlue_Write_Bin[i + 1]) / 4) * j)
                else
                    GammaRed_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                        math.floor(
                        GammaRed_Write_Bin[i + 1] + ((GammaRed_Write_Bin[i + 1] - GammaRed_Write_Bin[i]) / 4) * j
                    )
                    GammaGreen_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                        math.floor(
                        GammaGreen_Write_Bin[i + 1] + ((GammaGreen_Write_Bin[i + 1] - GammaRed_Write_Bin[i]) / 4) * j
                    )
                    GammaBlue_Write_Bin_CSV[i * 4 + j + (nBandindex - 1) * 1024 + 1] =
                        math.floor(
                        GammaBlue_Write_Bin[i + 1] + ((GammaBlue_Write_Bin[i + 1] - GammaBlue_Write_Bin[i]) / 4) * j
                    )
                end
            end
        end

        Gammanomal_Write_Bin_reg_Red[i * 4 + (nBandindex - 1) * 1024 + 1] =
            ((GammaRed_Write_Bin_CSV[i * 4 + (nBandindex - 1) * 1024 + 1]) & 0xFF)
        Gammanomal_Write_Bin_reg_Red[i * 4 + 1 + (nBandindex - 1) * 1024 + 1] =
            ((GammaRed_Write_Bin_CSV[i * 4 + (nBandindex - 1) * 1024 + 1] >> 8) & 0x0F)
        Gammanomal_Write_Bin_reg_Red[i * 4 + 2 + (nBandindex - 1) * 1024 + 1] = 0x00
        Gammanomal_Write_Bin_reg_Red[i * 4 + 3 + (nBandindex - 1) * 1024 + 1] = 0x00

        Gammanomal_Write_Bin_reg_Green[i * 4 + (nBandindex - 1) * 1024 + 1] =
            ((GammaGreen_Write_Bin_CSV[i * 4 + (nBandindex - 1) * 1024 + 1]) & 0xFF)
        Gammanomal_Write_Bin_reg_Green[i * 4 + 1 + (nBandindex - 1) * 1024 + 1] =
            ((GammaGreen_Write_Bin_CSV[i * 4 + (nBandindex - 1) * 1024 + 1] >> 8) & 0x0F)
        Gammanomal_Write_Bin_reg_Green[i * 4 + 2 + (nBandindex - 1) * 1024 + 1] = 0x00
        Gammanomal_Write_Bin_reg_Green[i * 4 + 3 + (nBandindex - 1) * 1024 + 1] = 0x00

        Gammanomal_Write_Bin_reg_Blue[i * 4 + (nBandindex - 1) * 1024 + 1] =
            ((GammaBlue_Write_Bin_CSV[i * 4 + (nBandindex - 1) * 1024 + 1]) & 0xFF)
        Gammanomal_Write_Bin_reg_Blue[i * 4 + 1 + (nBandindex - 1) * 1024 + 1] =
            ((GammaBlue_Write_Bin_CSV[i * 4 + (nBandindex - 1) * 1024 + 1] >> 8) & 0x0F)
        Gammanomal_Write_Bin_reg_Blue[i * 4 + 2 + (nBandindex - 1) * 1024 + 1] = 0x00
        Gammanomal_Write_Bin_reg_Blue[i * 4 + 3 + (nBandindex - 1) * 1024 + 1] = 0x00
    end
end

local function F_Formula_Linear(tGray, tGrayLow, tGrayHigh, tValueLow, tValueHigh)
    local tGrayValue = 0
    --MSG.Error("111, tGray : %d, tGrayLow : %d,  tGrayHigh : %d", tGray, tGrayLow, tGrayHigh)
    tGrayValue = math.floor(tValueLow + (tValueHigh - tValueLow) * (tGray - tGrayLow) / (tGrayHigh - tGrayLow) + 0.5)
    --MSG.Error("tValueLowRed : %X, tValueHighRed : %X, tGrayValue : %X", tValueLow, tValueHigh, tGrayValue)
    return tGrayValue
end

local function F_Formula_lowgray(tGray, tGrayLow, tGrayHigh, tValueLow, tValueHigh)
    local tValueLow1 = tValueLow ^ 2
    local tValueHigh1 = tValueHigh ^ 2
    local tGrayValue = 0
    --MSG.Error("222, tGray : %d, tGrayLow : %d,  tGrayHigh : %d", tGray, tGrayLow, tGrayHigh)
    tGrayValue =
        math.floor((tValueLow1 + (tValueHigh1 - tValueLow1) * (tGray - tGrayLow) / (tGrayHigh - tGrayLow)) ^ 0.5 + 0.5)
    --MSG.Error("tValueLowRed : %X, tValueHighRed : %X, tGrayValue : %X", tValueLow, tValueHigh, tGrayValue)
    return tGrayValue
end

gCalGrayLine = 27
local function F_Formula_Value(tGray, tGrayLow, tGrayHigh, tValueLow, tValueHigh)
    if tGray > gCalGrayLine then
        return F_Formula_Linear(tGray, tGrayLow, tGrayHigh, tValueLow, tValueHigh)
    else
        return F_Formula_lowgray(tGray, tGrayLow, tGrayHigh, tValueLow, tValueHigh)
    end
end

local function F_CheckTableReverse(tb)
    local ret = 0
    for i = 1, 1 do
        if #tb == 0 then
            ret = 1
            break
        end

        for j = 1, #tb - 1 do
            if tb[j] < gGammaRed[j + 1] then
                ret = 1
                MSG.Warning('F_CheckTableReverse NG !  index : %d', j)
                break
            end
        end
    end

    return ret
end

function F_CACULATE_TUNING_DISABLE_REG(nBandindex)
    local bandstart = 0
    local bandend = GammaBandOffsetEnd[nBandindex]
    local LowVPos = 0
    local HigVPos = 0
    if nBandindex == 1 then
        bandstart = 1
    else
        bandstart = GammaBandOffsetEnd[nBandindex - 1] + 1
    end
    for i = bandstart, bandend - 1 do
        if gGammaTuningEnable[i] == 0 then
            for j = 1, gMAX_BLIND_NUM do
                if 1 == gGammaTuningEnable[i + j] then
                    LowVPos = i + j
                    break
                end
            end
            for j = 1, gMAX_BLIND_NUM do
                if 1 == gGammaTuningEnable[i - j] then
                    HigVPos = i - j
                    break
                end
            end
            gGammaRed[i] =
                math.ceil(
                gGammaRed[LowVPos] +
                    (gGammaRed[HigVPos] - gGammaRed[LowVPos]) * (gGammaGrayColor[i] - gGammaGrayColor[LowVPos]) /
                        (gGammaGrayColor[HigVPos] - gGammaGrayColor[LowVPos]) +
                    0.5
            )
            gGammaGreen[i] =
                math.ceil(
                gGammaGreen[LowVPos] +
                    (gGammaGreen[HigVPos] - gGammaGreen[LowVPos]) * (gGammaGrayColor[i] - gGammaGrayColor[LowVPos]) /
                        (gGammaGrayColor[HigVPos] - gGammaGrayColor[LowVPos]) +
                    0.5
            )
            gGammaBlue[i] =
                math.ceil(
                gGammaBlue[LowVPos] +
                    (gGammaBlue[HigVPos] - gGammaBlue[LowVPos]) * (gGammaGrayColor[i] - gGammaGrayColor[LowVPos]) /
                        (gGammaGrayColor[HigVPos] - gGammaGrayColor[LowVPos]) +
                    0.5
            )
        end
    end
	
	
	-----GRAY 1-------
	gGammaRed[bandend -1] =0
	gGammaGreen[bandend -1] =0
	gGammaBlue[bandend -1] =0
		-----GRAY 3-------
	
--gGammaRed[bandend -4] =math.ceil( gGammaRed[bandend -5]*0.955)
--	gGammaGreen[bandend -4] =math.ceil( gGammaGreen[bandend -5]*0.955)
--	gGammaBlue[bandend -4] =math.ceil( gGammaBlue[bandend -5]*0.945)
--	
--	
--		gGammaRed[bandend -3] =math.ceil( gGammaRed[bandend -4]*0.955)
--	gGammaGreen[bandend -3] =math.ceil( gGammaGreen[bandend -4]*0.955)
--	gGammaBlue[bandend -3] =math.ceil( gGammaBlue[bandend -4]*0.945)
--	
	
	--[[
	gGammaRed[bandend -2] =math.ceil( gGammaRed[bandend -3]*0.95)
	gGammaGreen[bandend -2] =math.ceil( gGammaGreen[bandend -3]*0.95)
	gGammaBlue[bandend -2] =math.ceil( gGammaBlue[bandend -3]*0.95)
	
	
	gGammaRed[bandend -1] =math.ceil( gGammaRed[bandend -2]*0.95)
	gGammaGreen[bandend -1] =math.ceil( gGammaGreen[bandend -2]*0.95)
	gGammaBlue[bandend -1] =math.ceil( gGammaBlue[bandend -2]*0.95)
	--]]
------------------------------------------------------------------------
--4nit 
--
  if nBandindex == NORMAL19 then
  local gray3_red =  gGammaRed[bandend -2];
  local gray3_green =  gGammaGreen[bandend -2];
  local gray3_blue =  gGammaBlue[bandend -2];
  
	gGammaRed[bandend] =math.ceil( gray3_red -130)    --gray0 = ？可修改运算规则，此处仅举例 -0.2V
	gGammaGreen[bandend] =math.ceil( gray3_green -130)
	gGammaBlue[bandend] =math.ceil( gray3_blue -130)
end
--]]

	
	
end

--[[
function F_CACULATE_TUNING_DISABLE_REG11(nBandindex)
    
    local ret = 0
    local offset = gMAX_BLIND_NUM * (nBandindex - 1)
    
    -- 12bit data ,before CACULATE DISABLE
    local regDataRed = {}
    local regDataGreen = {}
    local regDataBlue = {}

    
    -- after CACULATE DISABLE
    local GammaRed_Write_Bin    = {} 
    local GammaGreen_Write_Bin  = {} 
    local GammaBlue_Write_Bin   = {} 
    
    MSG.Println("F_CACULATE_TUNING_DISABLE_REG ... %d", nBandindex)
    MSG.Println("gMAX_BLIND_NUM : %d", gMAX_BLIND_NUM)
    --MSG.Println("gGammaRed len : %d", #gGammaRed)
    --MSG.Println("gGammaGreen len : %d", #gGammaGreen)
    --MSG.Println("gGammaBlue len : %d", #gGammaBlue)
    -- 10bit --> 12bit
	for  i = 1, gMAX_BLIND_NUM do
        regDataRed[i]   = gGammaRed[offset + i] * 4 + 2
        regDataGreen[i] = gGammaGreen[offset + i] * 4 + 2
        regDataBlue[i]  = gGammaBlue[offset + i] * 4 + 2
	end

    -- set gray0 reg value : 0x00
    regDataRed[gMAX_BLIND_NUM] = 0;
    regDataBlue[gMAX_BLIND_NUM] = 0;
    regDataGreen[gMAX_BLIND_NUM] = 0;
    
    --MSG.Println("--------------gammdata 1 12bit---------- nBandindex : %d", nBandindex)
    --MSG.Println("RED : %d", #regDataRed)
    --MSG.Println(ADDP.Array2Hexstr(regDataRed))
    --MSG.Println("Green : %d", #regDataGreen)
    --MSG.Println(ADDP.Array2Hexstr(regDataGreen))
    --MSG.Println("Blue : %d", #regDataBlue)
    --MSG.Println(ADDP.Array2Hexstr(regDataBlue))
    --MSG.Println("--------------gammdata 1 12bit----------end")

    
    -- -- 255 gary must  be tuning
    if gGammaTuningEnable[offset + 1] ~= 1 then
        MSG.Error("must set gray 255 tuning enable 1")
        return 1
    end
    
    -- CACULATE
    local tarLowIndex   = gMAX_BLIND_NUM    -- default gray0
    local tarHighIndex  = 1                 -- default gray256
    
    for i = 1, gMAX_BLIND_NUM - 1 do
        
        local index = offset + i
        --local gray = gGammaGrayColor[i]

        --MSG.Error("index : %d, enable ：%d", index, gGammaTuningEnable[index])
        
        if gGammaTuningEnable[index] == 1 then
            tarHighIndex = index
            GammaRed_Write_Bin[i]   = regDataRed[i]
            GammaGreen_Write_Bin[i] = regDataGreen[i]
            GammaBlue_Write_Bin[i]  = regDataBlue[i]
        else
            for j = i, gMAX_BLIND_NUM - 1 do
                -- get tarLowIndex
                if gGammaTuningEnable[offset + j] == 1 then
                    tarLowIndex = offset + j
                    break
                end
            end
            
            local tGray = gGammaGrayColor[i]
            local tGrayLow = gGammaGrayColor[tarLowIndex]
            local tGrayHigh = gGammaGrayColor[tarHighIndex]
            
            local tValueLowRed      = regDataRed[tarLowIndex - offset]
            local tValueHighRed     = regDataRed[tarHighIndex - offset]
            
            local tValueLowGreen    = regDataGreen[tarLowIndex - offset]
            local tValueHighGreen   = regDataGreen[tarHighIndex - offset]
            
            local tValueLowBlue     = regDataBlue[tarLowIndex - offset]
            local tValueHighBlue    = regDataBlue[tarHighIndex - offset]

            --MSG.Error("tGray : %d, tGrayLow : %d,  tGrayHigh : %d", tGray, tGrayLow, tGrayHigh)
            --MSG.Error("tValueLowRed : %X, tValueHighRed : %X", tValueLowRed, tValueHighRed)
            
            GammaRed_Write_Bin[i]   = F_Formula_Value(tGray, tGrayLow, tGrayHigh, tValueLowRed, tValueHighRed)
            GammaGreen_Write_Bin[i] = F_Formula_Value(tGray, tGrayLow, tGrayHigh, tValueLowGreen, tValueHighGreen)
            GammaBlue_Write_Bin[i]  = F_Formula_Value(tGray, tGrayLow, tGrayHigh, tValueLowBlue, tValueHighBlue)
        
            --MSG.Println(">>>>>>>bandstart :  bandend : %d%d%d", GammaRed_Write_Bin[i], GammaRed_Write_Bin[i],GammaRed_Write_Bin[i])
		
		
		end
        
    end
    
    -- set gray0 reg value : 0x00
    GammaRed_Write_Bin[gMAX_BLIND_NUM] = 0;
    GammaGreen_Write_Bin[gMAX_BLIND_NUM] = 0;
    GammaBlue_Write_Bin[gMAX_BLIND_NUM] = 0;
    
    --MSG.Println("--------------gammdata 1 CACULATE---------- nBandindex : %d", nBandindex)
    --MSG.Println("RED : %d", #GammaRed_Write_Bin)
    --MSG.Println(ADDP.Array2Hexstr(GammaRed_Write_Bin))
    --
    --MSG.Println("Green : %d", #GammaGreen_Write_Bin)
    --MSG.Println(ADDP.Array2Hexstr(GammaGreen_Write_Bin))
    --
    --MSG.Println("Blue : %d", #GammaBlue_Write_Bin)
    --MSG.Println(ADDP.Array2Hexstr(GammaBlue_Write_Bin))
    --MSG.Println("--------------gammdata 1 CACULATE----------end")
    
    
    -- 计算反转
    ret = 0
    ret = F_CheckTableReverse(GammaRed_Write_Bin)
    if ret ~= 0 then
        MSG.Error("Gamma Red Data Check Reverse NG!")
        --return ret
    end
    
    ret = 0
    ret = F_CheckTableReverse(GammaGreen_Write_Bin)
    if ret ~= 0 then
        MSG.Error("Gamma Green Data Check Reverse NG!")
        --return ret
    end
    
    ret = 0
    ret = F_CheckTableReverse(GammaBlue_Write_Bin)
    if ret ~= 0 then
        MSG.Error("Gamma Blue Data Check Reverse NG!")
        --return ret
    end
    

    table.sort(GammaRed_Write_Bin)
    table.sort(GammaGreen_Write_Bin)
    table.sort(GammaBlue_Write_Bin)
    
    MSG.Println("--------------gammdata 1 CACULATE by sort---------- nBandindex : %d", nBandindex)
    MSG.Println("RED : %d", #GammaRed_Write_Bin)
    --MSG.Println(ADDP.Array2Hexstr(GammaRed_Write_Bin))
    
    MSG.Println("Green : %d", #GammaGreen_Write_Bin)
    --MSG.Println(ADDP.Array2Hexstr(GammaGreen_Write_Bin))
    
    MSG.Println("Blue : %d", #GammaBlue_Write_Bin)
    --MSG.Println(ADDP.Array2Hexstr(GammaBlue_Write_Bin))
    MSG.Println("--------------gammdata 1 CACULATE by sort ----------end")
    
    
    -- Convert value to storage mode, to bin
    for i = 0, 255 do
        for j = 0, 3 do
            if i < 255 then
        
                GammaRed_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaRed_Write_Bin[i+1]+((GammaRed_Write_Bin[i+2]-GammaRed_Write_Bin[i+1])/4)*j)
                GammaGreen_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaGreen_Write_Bin[i+1]+((GammaGreen_Write_Bin[i+2]-GammaRed_Write_Bin[i+1])/4)*j)
                GammaBlue_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaBlue_Write_Bin[i+1]+((GammaBlue_Write_Bin[i+2]-GammaBlue_Write_Bin[i+1])/4)*j)
    
            else
                if math.floor(GammaBlue_Write_Bin[i+1]+(GammaBlue_Write_Bin[i+1]-GammaBlue_Write_Bin[i])) > 4095 then
                    GammaRed_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaRed_Write_Bin[i+1]+((4095-GammaRed_Write_Bin[i+1])/4)*j)
                    GammaGreen_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaGreen_Write_Bin[i+1]+((4095-GammaRed_Write_Bin[i+1])/4)*j)
                    GammaBlue_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaBlue_Write_Bin[i+1]+((4095-GammaBlue_Write_Bin[i+1])/4)*j)	
                else	
                    GammaRed_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaRed_Write_Bin[i+1]+((GammaRed_Write_Bin[i+1]-GammaRed_Write_Bin[i])/4)*j)
                    GammaGreen_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaGreen_Write_Bin[i+1]+((GammaGreen_Write_Bin[i+1]-GammaRed_Write_Bin[i])/4)*j)
                    GammaBlue_Write_Bin_CSV[i*4+j+(nBandindex-1)*1024+1]=math.floor(GammaBlue_Write_Bin[i+1]+((GammaBlue_Write_Bin[i+1]-GammaBlue_Write_Bin[i])/4)*j)
                end   
            end
    
        end
	
		Gammanomal_Write_Bin_reg_Red[i*4+(nBandindex-1)*1024+1] = ((GammaRed_Write_Bin_CSV[i*4+(nBandindex-1)*1024+1])&0xFF);
		Gammanomal_Write_Bin_reg_Red[i*4+1+(nBandindex-1)*1024+1] = ((GammaRed_Write_Bin_CSV[i*4+(nBandindex-1)*1024+1]>>8)&0x0F);
		Gammanomal_Write_Bin_reg_Red[i*4+2+(nBandindex-1)*1024+1] = 0x00
		Gammanomal_Write_Bin_reg_Red[i*4+3+(nBandindex-1)*1024+1] = 0x00
    
		Gammanomal_Write_Bin_reg_Green[i*4+(nBandindex-1)*1024+1] = ((GammaGreen_Write_Bin_CSV[i*4+(nBandindex-1)*1024+1])&0xFF);
		Gammanomal_Write_Bin_reg_Green[i*4+1+(nBandindex-1)*1024+1] = ((GammaGreen_Write_Bin_CSV[i*4+(nBandindex-1)*1024+1]>>8)&0x0F);
		Gammanomal_Write_Bin_reg_Green[i*4+2+(nBandindex-1)*1024+1] = 0x00
		Gammanomal_Write_Bin_reg_Green[i*4+3+(nBandindex-1)*1024+1] = 0x00
  
		Gammanomal_Write_Bin_reg_Blue[i*4+(nBandindex-1)*1024+1]=((GammaBlue_Write_Bin_CSV[i*4+(nBandindex-1)*1024+1])&0xFF);
		Gammanomal_Write_Bin_reg_Blue[i*4+1+(nBandindex-1)*1024+1]=((GammaBlue_Write_Bin_CSV[i*4+(nBandindex-1)*1024+1]>>8)&0x0F);
		Gammanomal_Write_Bin_reg_Blue[i*4+2+(nBandindex-1)*1024+1]= 0x00
		Gammanomal_Write_Bin_reg_Blue[i*4+3+(nBandindex-1)*1024+1]= 0x00
	end
    
    return ret
end
--]]
local table_Pgamma = {
    0xE1,
    0x00,
    0x35,
    0x82,
    0xB2,
    0x82,
    0x16,
    0x81,
    0xE2,
    0x81,
    0xBC,
    0x81,
    0x9D,
    0x81,
    0x7C,
    0x81,
    0x5A,
    0x81,
    0x35,
    0x81,
    0x13,
    --R
    0x82,
    0xB2,
    0x82,
    0x14,
    0x81,
    0xDE,
    0x81,
    0xBC,
    0x81,
    0x9A,
    0x81,
    0x7A,
    0x81,
    0x51,
    0x81,
    0x31,
    0x81,
    0x06,
    --G
    0x82,
    0xB2,
    0x81,
    0xF2,
    0x81,
    0xBE,
    0x81,
    0x98,
    0x81,
    0x77,
    0x81,
    0x54,
    0x81,
    0x2E,
    0x81,
    0x06,
    0x80,
    0xE7,
    --B
    0xFF,
    0xF4,
    0x00
}

function F_UPDATA_REG_TO_PGAMMATABLE()
    for i = 1, 8 do --P Gamma ??甯?规?颁?
        if gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] < 0x14d then
            gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] = 0x14d
        end
        if gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] < 0x14d then
            gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] = 0x14d
        end
        if gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] < 0x14d then
            gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] = 0x14d
        end

        gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] =
            0x3FF - gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1]
        gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] =
            0x3FF - gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1]
        gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] =
            0x3FF - gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1]

        table_Pgamma[23 - i * 2 - 1] =
            (((gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] >> 8) & 0x83) + 0x80)
        table_Pgamma[23 - i * 2] = (gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] & 0xFF)

        table_Pgamma[41 - i * 2 - 1] =
            (((gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] >> 8) & 0x83) + 0x80)
        table_Pgamma[41 - i * 2] = (gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] & 0xFF)

        table_Pgamma[59 - i * 2 - 1] =
            (((gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] >> 8) & 0x83) + 0x80)
        table_Pgamma[59 - i * 2] = (gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] & 0xFF)
    end
end

table_PGamma = {
    --R     G      B
    {0x303, 0x2D5, 0x31E}, --255 0x3ff-目?酥?
    {0x2D5, 0x2AD, 0x2F1}, --239
    {0x2AA, 0x289, 0x2C8},
    {0x281, 0x266, 0x2A0},
    {0x258, 0x243, 0x279},
    {0x231, 0x21F, 0x252},
    {0x208, 0x1FA, 0x227},
    {0x1D5, 0x1CC, 0x1F5},
    {0x66, 0x66, 0x66}
}

local table_Pgamma_too = {
    0x80,
    0xA4,
    0x81,
    0x22,
    0x81,
    0xF6,
    0x81,
    0xD2,
    0x81,
    0xB5,
    0x81,
    0x94,
    0x81,
    0x75,
    0x82,
    0x55,
    0x81,
    0x35,
    0x80,
    0xA4,
    0x82,
    0x22,
    0x81,
    0xF6,
    0x81,
    0xD2,
    0x82,
    0xB5,
    0x81,
    0x94,
    0x81,
    0x75,
    0x81,
    0x55,
    0x81,
    0x35,
    0x80,
    0xA4,
    0x81,
    0x22,
    0x81,
    0xF6,
    0x81,
    0xD2,
    0x82,
    0xB5,
    0x81,
    0x94,
    0x81,
    0x75,
    0x81,
    0x55,
    0x81,
    0x35
}

function F_UPDATE_ININREG_TO_PGAMMATABLE()
    for i = 1, 9 do --P Gamma ??甯?规?颁?
        gGammaRed[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] = table_PGamma[i][1]

        gGammaGreen[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] = table_PGamma[i][2]

        gGammaBlue[gMAX_BLIND_NUM * (P_GAMMA_INDEX - 1) + (i - 1) * 8 + 1] = table_PGamma[i][3]

        --MSG.Println("i %x,gGammaRed %x",i,gGammaRed[gMAX_BLIND_NUM*(P_GAMMA_INDEX-1)+(i-1)*8+1])
        --MSG.Println("i %x,gGammaRed %x",i,gGammaGreen[gMAX_BLIND_NUM*(P_GAMMA_INDEX-1)+(i-1)*8+1])
        --MSG.Println("i %x,gGammaRed %x",i,gGammaBlue[gMAX_BLIND_NUM*(P_GAMMA_INDEX-1)+(i-1)*8+1])
    end
end

--******************************************************************************
--* Function Name  : F_GAMMA_TUNING_ONE_BAND
--* Description    : TUNING ONE BAND
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : nil
--*******************************************************************************
function F_GAMMA_TUNING_ONE_BAND(bandindex)
    local chn = 1
    local gray = 0
    local tOutput = {}
    local tResult = {}

    local bandstart = (bandindex - 1) * gMAX_BLIND_NUM + 1
    local bandend = bandindex * gMAX_BLIND_NUM
    local adjRt = 0
    local adjCount = 0
    local tLastGrayInitValue = {0, 0, 0, 0} -- R,G,B,POS
    MSG.Println('>>>>>>>bandstart : %d, bandend : %d', bandstart, bandend)
    --调节结果初始化
    gRecordData.BindResult[bandindex] = 0
    gAdjustedBandCount = gAdjustedBandCount + 1
    -- 0 灰阶不调
    for i = bandstart, bandend - 1 do
        gray = gGammaGrayColor[i]
        if gray ~= 0 and gGammaTuningEnable[i] == 1 then
            if gray == 255 then
                tLastGrayInitValue[1] = gGammaRed[bandstart]
                tLastGrayInitValue[2] = gGammaGreen[bandstart]
                tLastGrayInitValue[3] = gGammaBlue[bandstart]
                tLastGrayInitValue[4] = bandstart -- pos
            else
                local tmpRGBREGValue = F_UPDATA_RGBREG_BY_OFFSET(i, tLastGrayInitValue)
                tLastGrayInitValue[1] = gGammaRed[i]
                tLastGrayInitValue[2] = gGammaGreen[i]
                tLastGrayInitValue[3] = gGammaBlue[i]
                tLastGrayInitValue[4] = i -- pos
                gGammaRed[i] = tmpRGBREGValue[1]
                gGammaGreen[i] = tmpRGBREGValue[2]
                gGammaBlue[i] = tmpRGBREGValue[3]
            end
            if (gGammaTarget_L[i] < 0.1) and (gCA410SyncFlag ~= 1) then
                CA410_SetSyncMode(gDevId, 5, tonumber(string.format('%.1f', 1000 / gFreq)) * 2)
                gCA410SyncFlag = 1
            elseif (gGammaTarget_L[i] >= 0.1) and (gCA410SyncFlag ~= 0) then
                CA410_SetSyncMode(gDevId, 5, tonumber(string.format('%.1f', 1000 / gFreq)) * 1)
                gCA410SyncFlag = 0
            end
            adjRt = GAMMA.TUNING(i)
            if adjRt ~= 0 then
                gRecordData['StopTuning'] = 1
                gRecordData.BindResult[bandindex] = 1 --band调节结果
                gRecordData.TuningResult = 1 --所有调节结果
                break
            end

            if SYS.GetResetKeyIsPressed() == 1 then
                MSG.Warning('Reset Key Is Pressed, stop to tunning Gamma.')
                break
            end
        end
    end
end
function F_UPDATA_RGBREG_BY_OFFSET(nPos,tLastGrayInitValue)

	local tRGBValue = {}
	local lastPos = tLastGrayInitValue[4];
	tRGBValue[1] = gGammaRed[nPos] + gGammaRed[lastPos] - tLastGrayInitValue[1];
	tRGBValue[2] = gGammaGreen[nPos] + gGammaGreen[lastPos] - tLastGrayInitValue[2];
	tRGBValue[3] = gGammaBlue[nPos] + gGammaBlue[lastPos] - tLastGrayInitValue[3];


	if tRGBValue[1] < 0 then
		tRGBValue[1] = 0;
	elseif tRGBValue[1] > gGammaRed[lastPos] then
		tRGBValue[1] =  gGammaRed[lastPos];
	end

	if tRGBValue[2] < 0 then
		tRGBValue[2] = 0;
	elseif tRGBValue[2] > gGammaGreen[lastPos] then
		tRGBValue[2] =  gGammaGreen[lastPos];
	end

	if tRGBValue[3] < 0 then
		tRGBValue[3] = 0;
	elseif tRGBValue[3] > gGammaBlue[lastPos] then
		tRGBValue[3] = gGammaBlue[lastPos];
	end


	return tRGBValue;

end
--******************************************************************************
--* Function Name  : F_DO_GAMMA_ONE_BAND
--* Description    : DO GAMMA ONE BAND
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : nil
--*******************************************************************************
function F_DO_GAMMA_ONE_BAND(bandindex)
    if gGammaBandTuningEnable[bandindex] == 1 then
        F_ENTER_MODE(bandindex)

        if gRecordData['StopTuning'] == 0 then
            F_GAMMA_TUNING_ONE_BAND(bandindex)
        end
        F_CACULATE_TUNING_DISABLE_REG(bandindex)
        F_EXIT_MODE(bandindex)
    end
end

--******************************************************************************
--* Function Name  : F_DO_GAMMA
--* Description    : DO GAMMA ONE BAND
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : nil
--*******************************************************************************
function F_DO_GAMMA()
    MSG.Println('***********F_DO_GAMMA_ONE_BAND()')

    -- 30Hz
    if (gRecordData['StopTuning'] == 0) then
        F_DO_GAMMA_ONE_BAND(NORMAL1)
    --F_UPDATA_INIT_REG_VALUE_BY_BAND(NORMAL1)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL2, NORMAL1, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL2)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL3, NORMAL2, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL3)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL4, NORMAL3, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL4)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL5, NORMAL4, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL5)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL6, NORMAL5, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL6)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL7, NORMAL6, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL7)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL8, NORMAL7, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL8)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL9, NORMAL8, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL9)
    end

    -- 60Hz
    CA410_SetSyncMode(gDevId, 5, tonumber(string.format('%.1f', 1000 / gFreq)))
    gCA410SyncFlag = 0
    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL11, NORMAL1, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL11)
    --F_UPDATA_INIT_REG_VALUE_BY_BAND(NORMAL1)
    end
	SYS.SwitchRGB(chn, 0, 0, 0)
    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL12, NORMAL11, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL12)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL13, NORMAL12, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL13)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL14, NORMAL13, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL14)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL15, NORMAL14, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL15)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL16, NORMAL15, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL16)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL17, NORMAL16, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL17)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL18, NORMAL17, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL18)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL19, NORMAL18, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL19)
    end

    -- 90Hz
    if (gRecordData['StopTuning'] == 0) then
        F_DO_GAMMA_ONE_BAND(NORMAL21)
    --F_UPDATA_INIT_REG_VALUE_BY_BAND(NORMAL11)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL22, NORMAL21, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL22)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL23, NORMAL22, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL23)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL24, NORMAL23, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL24)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL25, NORMAL24, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL25)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL26, NORMAL25, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL26)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL27, NORMAL26, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL27)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL28, NORMAL27, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL28)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL29, NORMAL28, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL29)
    end

    -- 120Hz
    if (gRecordData['StopTuning'] == 0) then
        F_DO_GAMMA_ONE_BAND(NORMAL31)
    --F_UPDATA_INIT_REG_VALUE_BY_BAND(NORMAL21)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL32, NORMAL31, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL32)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL33, NORMAL32, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL33)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL34, NORMAL33, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL34)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL35, NORMAL34, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL35)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL36, NORMAL35, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL36)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL37, NORMAL36, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL37)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL38, NORMAL37, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL38)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL39, NORMAL38, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL39)
    end
end

function F_DO_GAMMA111()
    MSG.Println('***********F_DO_GAMMA_ONE_BAND()')

    if (gRecordData['StopTuning'] == 0) then
        F_DO_GAMMA_ONE_BAND(NORMAL1)
        F_UPDATA_INIT_REG_VALUE_BY_BAND(NORMAL1)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL2, NORMAL1, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL2)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL3, NORMAL2, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL3)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL4, NORMAL3, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL4)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL5, NORMAL4, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL5)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL6, NORMAL5, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL6)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL7, NORMAL6, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL7)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL8, NORMAL7, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL8)
    end

    if (gRecordData['StopTuning'] == 0) then
        F_UPDATA_BandByPWMAndLikelyBand(NORMAL9, NORMAL8, 0)
        F_DO_GAMMA_ONE_BAND(NORMAL9)
    end

    F_USER_GAMMA_ALGORITHM_SQ57(NORMAL2)
    F_USER_GAMMA_ALGORITHM_SQ57(NORMAL4)
    F_USER_GAMMA_ALGORITHM_SQ57(NORMAL6)
end

--[[function F_USER_GAMMA_N4_SQ1369(NOR1, NOR3, NOR6, NOR9, Mode)

  local result = 0
  local C0, C1, C2, C3

  C0 = (81*NOR1)/40.0-(3*NOR3)/2.0+(3*NOR6)/5.0-NOR9/8.0
  C1 = (23*NOR3)/12.0-(99*NOR1)/80.0-(13*NOR6)/15.0+(3*NOR9)/16.0
  C2 = (9*NOR1)/40.0-(4*NOR3)/9.0+(13*NOR6)/45.0-(5*NOR9)/72.0
  C3 = NOR3/36.0-NOR1/80.0-NOR6/45.0+NOR9/144.0


  result = C0+C1*Mode+C2*Mode*Mode+C3*Mode*Mode*Mode+0.5

  -- // MSG.PRINTLN("READ  : %d ", result)

  return math.floor(result)
end
--]]
--[[function F_USER_GAMMA_N4_SQ1469(NOR1, NOR4, NOR7, NOR9, Mode)

  local result = 0
  local C0, C1, C2, C3

  C0 = (7*NOR1)/4.0-(7.0*NOR4)/5.0+NOR7-7*NOR9/20.0

  C1 = (79*NOR4)/45.0-(127*NOR1)/144.0-(49*NOR7)/36.0+(39*NOR9)/80.0

  C2 = (5.0*NOR1)/36.0-(17.0*NOR4)/45.0+(7.0*NOR7)/18.0-(3.0*NOR9)/20.0

  C3 = NOR4/45.0-NOR1/144.0-NOR7/36.0+NOR9/80.0

  result = C0+C1*Mode+C2*Mode*Mode+C3*Mode*Mode*Mode+0.5

  --MSG.PRINTLN("READ  : %d ", result)

  return math.floor(result)

end

--]]
function F_USER_GAMMA_N2_SQ57(NOR5, NOR7, Mode)
    local result = 0
    local C0, C1, C2, C3

    result = 1 * ((NOR5 - NOR7) / (5 - 7)) + NOR5

    -- // MSG.PRINTLN("READ  : %d ", result)

    return math.floor(result)
end

function F_USER_GAMMA_ALGORITHM_SQ57(nbandindex)
    local Count2
    local Result = 1
    local Mode

    local Pos1 = 0
    local Pos2 = gMAX_BLIND_NUM
    local Pos3 = gMAX_BLIND_NUM * 2
    local Pos4 = gMAX_BLIND_NUM * 3
    local Pos5 = gMAX_BLIND_NUM * 4
    local Pos6 = gMAX_BLIND_NUM * 5
    local Pos7 = gMAX_BLIND_NUM * 6
    local Pos8 = gMAX_BLIND_NUM * 7
    local Pos9 = gMAX_BLIND_NUM * 8

    --[[
  local Pos10 = GMAX_BLIND_NUM *11
	local Pos11 = GMAX_BLIND_NUM *12
	local Pos12 = GMAX_BLIND_NUM * 13
	local Pos13 = GMAX_BLIND_NUM * 14
	local Pos14 = GMAX_BLIND_NUM * 15
	local Pos15 = GMAX_BLIND_NUM * 16
	local Pos16 = GMAX_BLIND_NUM * 17
  local Pos17 = GMAX_BLIND_NUM * 18
  local Pos18 = GMAX_BLIND_NUM * 19
--]]
    if (nbandindex == NORMAL1) then
        return 0
    elseif (nbandindex == NORMAL2) then
        MSG.Println('N4-->NOR2')
        Mode = 3
        for Count2 = 1, 8 do
            gGammaRed[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos1], gGammaRed[Count2 + Pos3], Mode - 1) + 6
            gGammaGreen[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos1], gGammaGreen[Count2 + Pos3], Mode - 1) + 6
            gGammaBlue[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos1], gGammaBlue[Count2 + Pos3], Mode - 1) + 6
        end

        --G191-G47
        for Count2 = 9, 20 do
            gGammaRed[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos1], gGammaRed[Count2 + Pos3], Mode - 1) + 9
            gGammaGreen[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos1], gGammaGreen[Count2 + Pos3], Mode - 1) + 9
            gGammaBlue[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos1], gGammaBlue[Count2 + Pos3], Mode - 1) + 9
        end

        for Count2 = 21, gMAX_BLIND_NUM - 1 do
            gGammaRed[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos1], gGammaRed[Count2 + Pos3], Mode - 1) + 5
            gGammaGreen[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos1], gGammaGreen[Count2 + Pos3], Mode - 1) + 5
            gGammaBlue[Count2 + Pos2] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos1], gGammaBlue[Count2 + Pos3], Mode - 1) + 5
        end
        --F_ADJUST_REGS(Pos2)  --  调节
        --F_N1_RGB_DATA(Pos)	-- 打印log
        -- 写gamma 寄存器
        --F_UPDATA_REG_ONE_BAND(NORMAL2)
        return 0
    elseif (nbandindex == NORMAL4) then
        MSG.Println('N4-->NOR4')
        Mode = 5
        for Count2 = 1, 5 do
            gGammaRed[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos3], gGammaRed[Count2 + Pos5], Mode - 1) - 4
            gGammaGreen[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos3], gGammaGreen[Count2 + Pos5], Mode - 1) - 4
            gGammaBlue[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos3], gGammaBlue[Count2 + Pos5], Mode - 1) - 4
        end

        --g223-g95
        for Count2 = 6, 16 do
            gGammaRed[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos3], gGammaRed[Count2 + Pos5], Mode - 1) - 1
            gGammaGreen[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos3], gGammaGreen[Count2 + Pos5], Mode - 1) - 1
            gGammaBlue[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos3], gGammaBlue[Count2 + Pos5], Mode - 1) - 1
        end

        for Count2 = 17, gMAX_BLIND_NUM - 1 do
            gGammaRed[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos3], gGammaRed[Count2 + Pos5], Mode - 1) - 4
            gGammaGreen[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos3], gGammaGreen[Count2 + Pos5], Mode - 1) - 4
            gGammaBlue[Count2 + Pos4] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos3], gGammaBlue[Count2 + Pos5], Mode - 1) - 4
        end
        --F_ADJUST_REGS(Pos2)  --  调节
        --F_N1_RGB_DATA(Pos)	-- 打印log
        -- 写gamma 寄存器
        --F_UPDATA_REG_ONE_BAND(NORMAL2)
        return 0
    elseif (nbandindex == NORMAL6) then
        MSG.Println('N4-->NOR6')
        Mode = 7
        --高灰阶提亮
        for Count2 = 1, 17 do
            gGammaRed[Count2 + Pos6] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos5], gGammaRed[Count2 + Pos7], Mode - 1) + 1
            gGammaGreen[Count2 + Pos6] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos5], gGammaGreen[Count2 + Pos7], Mode - 1) + 1
            gGammaBlue[Count2 + Pos6] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos5], gGammaBlue[Count2 + Pos7], Mode - 1) + 1
        end

        --低灰阶变暗--g63
        for Count2 = 18, gMAX_BLIND_NUM - 1 do
            gGammaRed[Count2 + Pos6] =
                F_USER_GAMMA_N2_SQ57(gGammaRed[Count2 + Pos5], gGammaRed[Count2 + Pos7], Mode - 1) - 13
            gGammaGreen[Count2 + Pos6] =
                F_USER_GAMMA_N2_SQ57(gGammaGreen[Count2 + Pos5], gGammaGreen[Count2 + Pos7], Mode - 1) - 13
            gGammaBlue[Count2 + Pos6] =
                F_USER_GAMMA_N2_SQ57(gGammaBlue[Count2 + Pos5], gGammaBlue[Count2 + Pos7], Mode - 1) - 13
        end
        --F_ADJUST_REGS(Pos2)  --  调节
        --F_N1_RGB_DATA(Pos)	-- 打印log
        -- 写gamma 寄存器
        --F_UPDATA_REG_ONE_BAND(NORMAL2)
        return 0
    end
    return Result
end

--******************************************************************************
--* Function Name  : F_COLLECT_ONEBAND
--* Description    : 采集数据
--* Input          : nbandindex(number) (调节band的索引号 1~30)
--* Return         : nil
--*******************************************************************************
function F_COLLECT_ONEBAND(bandindex)
    local lastbandindex = bandindex - 1
    local bandstart = (bandindex - 1) * gMAX_BLIND_NUM + 1
    local bandend = bandindex * gMAX_BLIND_NUM
    local lv = 0
    local lvTarget = 0
    local x = 0
    local y = 0
    local lvmax = 0
    local lvmin = 0
    local gray = 0
    local tOutput = {}
    local nGray = 1
    local tInputMap = {}
    local bRet
    local nband = bandindex
    local tGammaCurve = GammaCurve
    local tResult = {}
    local tLvXYValue = {}
    --local StepArray  = {}
    local StepArray = {-20, -15, -10, -5, -2, 0, 2, 5, 10, 15, 20}
    local nTmpGammaRed = 0
    local nTmpGammaGreen = 0
    local nTmpGammaBlue = 0

    F_ENTER_MODE(bandindex)

    TIME.DELAY(500)

    --[[
    if bandindex <= NORMAL9 then
      --SetProbeSyncModeByOpticalCH(1, 0);
      SetProbeSyncModeByLvMode(0.001, 1);
    elseif bandindex <= NORMAL91  then
      --SetProbeSyncModeByOpticalCH(1, 0);
      SetProbeSyncModeByLvMode(0.001,2);
	   elseif bandindex <= NORMAL92  then
      --SetProbeSyncModeByOpticalCH(1, 0);
      SetProbeSyncModeByLvMode(0.001,3);
    elseif bandindex <= AOD3 then
        --SetProbeSyncModeByOpticalCH(1, 1);
        SetProbeSyncModeByLvMode(0.001,0);
    else

    end
--]]
    TIME.DELAY(100)

    -- 0 灰阶不需要采集
    for i = bandstart, (bandend - 1) do
        --GammaTarget_L
        local chn = 1
        gray = gGammaGrayColor[i]
        MSG.Println('lastbandindex : %d, gray : %3d', bandindex, gray)
        --SYS.SwitchRGB(chn, gray, gray, gray)
        --lvTarget = (GammaTarget[bandindex][4]) * ((GammaGrayColor[i]  / GammaGrayColor[bandstart]) ^ GammaCurve);

        if gGammaTarget_L[i] > 0.03 and (gGammaTuningEnable[i] == 1) then -- 0.005 -> 0.007
            StepArray = {-30, -22, -15, -10, -6, -3, -1, 0, 1, 3, 6, 10, 15, 22, 30}

            nTmpGammaRed = gGammaRed[i]
            nTmpGammaGreen = gGammaGreen[i]
            nTmpGammaBlue = gGammaBlue[i]

            for j = 1, #StepArray do
                gGammaRed[i] = nTmpGammaRed + StepArray[j]

                F_WRITE_GAMMA_REG(i)

                TIME.DELAY(40)

                tLvXYValue = READXYLV()

                F_SAVE_BP_DATA(
                    bandindex,
                    gGammaGrayColor[i],
                    gGammaRed[i],
                    gGammaGreen[i],
                    gGammaBlue[i],
                    tLvXYValue['x'],
                    tLvXYValue['y'],
                    tLvXYValue['Lv']
                )
            end

            gGammaRed[i] = nTmpGammaRed

            for j = 1, #StepArray do
                gGammaGreen[i] = nTmpGammaGreen + StepArray[j]

                F_WRITE_GAMMA_REG(i)

                TIME.DELAY(40)

                tLvXYValue = READXYLV()

                F_SAVE_BP_DATA(
                    bandindex,
                    gGammaGrayColor[i],
                    gGammaRed[i],
                    gGammaGreen[i],
                    gGammaBlue[i],
                    tLvXYValue['x'],
                    tLvXYValue['y'],
                    tLvXYValue['Lv']
                )
            end

            gGammaGreen[i] = nTmpGammaGreen

            for j = 1, #StepArray do
                gGammaBlue[i] = nTmpGammaBlue + StepArray[j]

                F_WRITE_GAMMA_REG(i)

                TIME.DELAY(40)

                tLvXYValue = READXYLV()

                F_SAVE_BP_DATA(
                    bandindex,
                    gGammaGrayColor[i],
                    gGammaRed[i],
                    gGammaGreen[i],
                    gGammaBlue[i],
                    tLvXYValue['x'],
                    tLvXYValue['y'],
                    tLvXYValue['Lv']
                )
            end

            gGammaBlue[i] = nTmpGammaBlue
        end
    end

    F_EXIT_MODE(bandindex)
end

--******************************************************************************
--* Function Name  : F_COLLECT_OPTIC
--* Description    : 采集数据探头设置
--* Return         : nil
--*******************************************************************************
function F_COLLECT_OPTIC()
    local chn = 1
    local tRes = {}

    GAMMA.INIT()

    SYS.SwitchPtn(chn, 'OPR_L0_L1.a1')
    TIME.Delay(gDelayAfterGammaPtnShow)

    CA410_SyncFreqBySelf(gDevId, 60) --切探头的频率30Hz
    --F_SET_Freq(freqType)                 --切屏的频率
    for i = NORMAL1, NORMAL9 do
        if gGammaBandTuningEnable[i] == 1 then
            F_COLLECT_ONEBAND(i)
        end
    end

    SYS.SwitchPtn(chn, '0gray.a1')
    CA410_SyncFreqBySelf(gDevId, 60) --切探头的频率60Hz
    --F_SET_Freq(freqType)                 --切屏的频率
    for i = NORMAL11, NORMAL19 do
        if gGammaBandTuningEnable[i] == 1 then
            F_COLLECT_ONEBAND(i)
        end
    end

    CA410_SyncFreqBySelf(gDevId, 60) --切探头的频率90Hz
    --F_SET_Freq(freqType)                 --切屏的频率
    for i = NORMAL21, NORMAL29 do
        if gGammaBandTuningEnable[i] == 1 then
            F_COLLECT_ONEBAND(i)
        end
    end

    CA410_SyncFreqBySelf(gDevId, 60) --切探头的频率120Hz
    --F_SET_Freq(freqType)                 --切屏的频率
    for i = NORMAL31, NORMAL39 do
        if gGammaBandTuningEnable[i] == 1 then
            F_COLLECT_ONEBAND(i)
        end
    end
end

function ProbeInitForGamma()
    local ret = 0

    OPTICAL.SetProbePath(gOPTICALPath)
    ret = OPTICAL.Init(gDevId)
    --ret = OPTICAL.SetEffectiveData()

    return ret
end

function F_Print_GammaValue()
    local GRContent = ''
    local GGContent = ''
    local GBContent = ''
    MSG.Println('**************************')
    MSG.Println('F_Print_GammaValue ....')
    MSG.Println('gGammaRed :')
    MSG.Println(ADDP.Array2Hexstr(gGammaRed))
    MSG.Println('gGammaBlue :')
    MSG.Println(ADDP.Array2Hexstr(gGammaBlue))
    MSG.Println('gGammaGreen :')
    MSG.Println(ADDP.Array2Hexstr(gGammaGreen))
    MSG.Println('**************************')
    MSG.Println('Gammanomal_Write_Bin_reg_Red :')
    MSG.Println(ADDP.Array2Hexstr(Gammanomal_Write_Bin_reg_Red))
    MSG.Println('Gammanomal_Write_Bin_reg_Green :')
    MSG.Println(ADDP.Array2Hexstr(Gammanomal_Write_Bin_reg_Green))
    MSG.Println('Gammanomal_Write_Bin_reg_Blue :')
    MSG.Println(ADDP.Array2Hexstr(Gammanomal_Write_Bin_reg_Blue))
    MSG.Println('F_Print_GammaValue .... end')
end

local function InitI2C5()
    local chn = 1
    local clkGpioPin = 6
    local sdaGpioPin = 7
    local delayCount = 10
    local GPIOVol = 0 --[0:1.8V, 1:3.3V]

    SPI.SPIPullupEn(chn, 0)

    GPIO.SetGpioOutVol(chn, 3, GPIOVol)
    --print("F_STEP_00 SetGpioOutVol out");
    GPIO.SetGpioOutOnOff(chn, 2, 1)
    GPIO.SetGpioOutOnOff(chn, 3, 0)
    TIME.Delay(200)
    GPIO.SetGpioOutOnOff(chn, clkGpioPin, 1)
    GPIO.SetGpioOutOnOff(chn, sdaGpioPin, 1)

    I2C.SetI2CChannel(1)
    GPIO.I2cInit(clkGpioPin, sdaGpioPin, delayCount)
end

function ReadDemuraCRC_old()
    InitI2C()
    TIME.Delay(100)
    local ReadCRC = {}

    local CMD = {0x34, 0x36, 0x45}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end

    -- enter debug
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)
 
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end

	--I2C_DEBUG_ENTER_MODE()
    TIME.Delay(300)


    WRITE_DATA = {0x10, 0x00, 0x00, 0x00}
    I2C_WriteData(WRITE_DATA)
    TIME.Delay(50)
    -------------------------
    local addr = 0x100000
    local addrLen = 3
    local readLen = 1
    local readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)
    MSG.Println(string.format("0x%02X", readBuf[1]))

    addr = 0x1009AC
    addrLen = 2
    readLen = 1
    readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)
    ReadCRC[1] = readBuf[1]
	MSG.Println(string.format("0x%02X", readBuf[1]))
    addr = 0x1009AD
    addrLen = 2
    readLen = 1
    readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)
    ReadCRC[2] = readBuf[1]

    addr = 0x1009AE
    addrLen = 2
    readLen = 1
    readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)
    ReadCRC[3] = readBuf[1]

    addr = 0x1009AF
    addrLen = 2
    readLen = 1
    readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)
    ReadCRC[4] = readBuf[1]

    MSG.Println('ReadCRC : %s', ADDP.Array2Hexstr(ReadCRC))
    UninteI2C()
	MSG.Println("1111")
    return ReadCRC
end

function F_TRAN2BinByMode(startBand, endBnad, gammaData)
    local tGammatable = {}
    local Dummy = 0xFF
    local pos = 0

    for i = 1, gMAX_BLIND_NUM + 1 do
        tGammatable[i] = {}
        if i == gMAX_BLIND_NUM + 1 then
            pos = 34
        else
            pos = i
        end

        for j = endBnad, startBand, -2 do
            if j == endBnad then
                table.insert(tGammatable[i], 0x00)
                table.insert(tGammatable[i], ((gammaData[j * gMAX_BLIND_NUM - pos + 1] & 0x0F) << 4) + 0x00)
                table.insert(tGammatable[i], (gammaData[j * gMAX_BLIND_NUM - pos + 1] >> 4) & 0xFF)
            else
                table.insert(tGammatable[i], gammaData[(j + 1) * gMAX_BLIND_NUM - pos + 1] & 0xFF)
                table.insert(
                    tGammatable[i],
                    ((gammaData[j * gMAX_BLIND_NUM - pos + 1] & 0x0F) << 4) +
                        ((gammaData[(j + 1) * gMAX_BLIND_NUM - pos + 1] >> 8) & 0x0F)
                )
                table.insert(tGammatable[i], (gammaData[j * gMAX_BLIND_NUM - pos + 1] >> 4) & 0xFF)
            end
        end
        table.insert(tGammatable[i], Dummy)
    end

    return tGammatable
end

function F_Create_Flashtable()
    Gamma_Flashtable = {}

    MSG.Println('F_Create_Flashtable ...')
    MSG.Println('GammaData------------')
    MSG.Println('R ------------')
    MSG.Println(ADDP.Array2Hexstr(gGammaRed))
    MSG.Println('G ------------')
    MSG.Println(ADDP.Array2Hexstr(gGammaGreen))
    MSG.Println('B ------------')
    MSG.Println(ADDP.Array2Hexstr(gGammaBlue))
    MSG.Println('GammaData------------end')

    --R 30Hz
    local tGammaRtable30L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaRed)
    Gamma_Flashtable[1] = tGammaRtable30L
    Gamma_Flashtable[3] = tGammaRtable30L
    --R 90Hz
    local tGammaRtable90L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaRed)
    Gamma_Flashtable[2] = tGammaRtable90L
    Gamma_Flashtable[4] = tGammaRtable90L
    --R 60Hz
    local tGammaRtable60L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaRed)
    Gamma_Flashtable[5] = tGammaRtable60L
    Gamma_Flashtable[7] = tGammaRtable60L
    --R 120Hz
    local tGammaRtable120L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaRed)
    Gamma_Flashtable[6] = tGammaRtable120L
    Gamma_Flashtable[8] = tGammaRtable120L

    --G 30Hz
    local tGammaGtable30L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaGreen)
    Gamma_Flashtable[9] = tGammaGtable30L
    Gamma_Flashtable[11] = tGammaGtable30L
    --G 90Hz
    local tGammaGtable90L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaGreen)
    Gamma_Flashtable[10] = tGammaGtable90L
    Gamma_Flashtable[12] = tGammaGtable90L
    --G 60Hz
    local tGammaGtable60L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaGreen)
    Gamma_Flashtable[13] = tGammaGtable60L
    Gamma_Flashtable[15] = tGammaGtable60L
    --G 120Hz
    local tGammaGtable120L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaGreen)
    Gamma_Flashtable[14] = tGammaGtable120L
    Gamma_Flashtable[16] = tGammaGtable120L

    --B 30Hz
    local tGammaBtable30L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaBlue)
    Gamma_Flashtable[17] = tGammaBtable30L
    Gamma_Flashtable[19] = tGammaBtable30L
    --B 90Hz
    local tGammaBtable90L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaBlue)
    Gamma_Flashtable[18] = tGammaBtable90L
    Gamma_Flashtable[20] = tGammaBtable90L
    --B 60Hz
    local tGammaBtable60L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaBlue)
    Gamma_Flashtable[21] = tGammaBtable60L
    Gamma_Flashtable[23] = tGammaBtable60L
    --B 120Hz
    local tGammaBtable120L = F_TRAN2BinByMode(NORMAL11, NORMAL19, gGammaBlue)
    Gamma_Flashtable[22] = tGammaBtable120L
    Gamma_Flashtable[24] = tGammaBtable120L

    MSG.Println('Gamma_Flashtable ------------')
    -- for i = 1, #Gamma_Flashtable do
    --     MSG.Println("------%d", i)
    --     for j = 1, #Gamma_Flashtable[i] do
    --         MSG.Println(string.format("------%d------%d------%d", i, j, #Gamma_Flashtable[i][j]))
    --         MSG.Println(ADDP.Array2Hexstr(Gamma_Flashtable[i][j]))
    --     end

    -- end
    -- for i =1,#Gamma_Flashtable do
    --     WriteCsv(GetLuaFolderName() .. 'CSV//' .. 'writegamma.csv', Gamma_Flashtable[i])
    -- end
end

--******************************************************************************
--* Function Name  : F_START_GAMMA
--* Description    : START_GAMMA 开始函数
--* Return         : ret(0:OK, 1:NG)
--*******************************************************************************

function F_START_Dynamic_ELVSS()
F_ELVSS_TUNING_ONE_BAND(10)
ELVSSTb = readELVSS()
end

function F_START_GAMMA()
    local rust_ret = 1
    local chn = 1
    local startTime = os.date('%Y-%m-%d %H:%M:%S')
    local tuningStart = socket.gettime()
    local endTime = 0
    local ret = 0

    --local OCAlg = nil
    --OCAlg =  require "OCAlg" -- Gamma tuning Algorithm library
   -- SYS.SwitchRGB(chn, 127, 127, 127)
    TIME.Delay(50)
    gDevId = SYS.GetPgId()
    OPTICAL.Init(gDevId)
    --  OPTICAL.SyncFreqBySelf(gDevId, 60)
    --CA410_SyncFreqBySelf(gDevId, 60)

    InitI2C()
    gLogLevel = 2 -- 2 : open (ERROR,WARNING,INFO) Log
    GAMMA.INIT()
    gLogLevel = 1 -- 1 : open all Log (ERROR,WARNING,INFO,DEBUG)
    --F_UPDATE_ININREG_TO_PGAMMATABLE()

    --ret, recstr = OPTICAL.SendCmd(gDevId, "ZRC")

    OPTICAL.SetProbePath(gOPTICALPath)
    -- Probe Init
    ret = OPTICAL.Init(gDevId)
    if ret ~= 0 then
        MSG.Error('Probe Init For Gamma NG ..')
        return ret
    end
    OPTICAL.SetEffectiveData(gDevId)
    CA410_SetProbeCH(gDevId, gProbeMemoryChanne)
    CA410_SetProbeSpeed(gDevId, 2)

    MSG.Println('F_DO_GAMMA******')
    SYS.SwitchRGB(chn, 0, 0, 0)
	--SYS.SwitchPtn(chn, "40% APL W255.a1")
    TIME.Delay(gDelayAfterGammaPtnShow)

    --Data Remapping OFF
	--
    F_Remapping_OFF()
    -- Demura OFF
    Demura_OFF()
     F_DCC_OFF()
	 
   --
    --GAMMA.setMaxIteration(1200)
    gLogLevel = 2
    -- 2 : open (ERROR,WARNING,INFO) Log
	F_GetVdata(10)
    F_DO_GAMMA()
	for i=10,18 do
		F_SetVdata(i)
	end
    --F_DO_GAMMA111();
    gLogLevel = 1 -- 1 : open all Log (ERROR,WARNING,INFO,DEBUG)
    --PrintTuningRecord2CRT()

    --OCAlg = nil
    MSG.Println('>>>>>startTime : %s', startTime)
    MSG.Println('>>>>>endTime : %s', endTime)
    --MSG.Println("....PrintTuningRecord2CRT")
    --PrintTuningRecord2CRT()
    -- F_ENTER_MODE(gGam2)
    if g_COLLECT_DATA_ENABLE == 1 and gRecordData['TuningResult'] == 0 and gRecordData['StopTuning'] == 0 then
        F_COLLECT_OPTIC()
    end
    if gOTPWriteEnable == 1 and gRecordData['TuningResult'] == 0 and gRecordData['StopTuning'] == 0 then
        require('IC_SpiFlashCom')
      --  F_EraseDBICode()
       -- F_OTPWriteDBICode()
        ret = F_OTPWriteGamma()
        if ret == 0 then
            rust_ret = 0
        else
            rust_ret = 1
        end
    elseif gRecordData['TuningResult'] == 0 and gRecordData['StopTuning'] == 0 then
        MSG.Println('GAMMA OK')
        --SYS.SwitchPtn(gChannel,"GMOK.a1")
        SYS.SwitchRGB(chn, 0, 255, 0)
        SYS.CloseRGB()

        rust_ret = 0
    else
        MSG.Error('GAMMA NG')
        --SYS.SwitchPtn(gChannel,"GMNG.a1")
        SYS.SwitchRGB(chn, 255, 0, 0)
        SYS.CloseRGB()
        rust_ret = 1
    end

    local tuningEnd = socket.gettime()
    gTuning_Time = tuningEnd - tuningStart
    WriteTuning2Csv_B12()
    endTime = os.date('%Y-%m-%d %H:%M:%S')
    MSG.Debug('Tuning Time = %.2f',gTuning_Time)
    if gRecordData['StopTuning'] == 0 then
        F_UPDATA_REFERENCE_VALUE() -- ??band???????
        F_SAVE_INIT_REG()
    end

    --F_Print_GammaValue()
    return rust_ret
end

local function escapeCSV(s)
    if string.find(s, '[,"]') then
        s = '"' .. string.gsub(s, '"', '""') .. '"'
    end
    return s
end

local function WriteCsv(strFileName, tContent)
    local file = assert(io.open(strFileName, 'a+'))

    for k, v in ipairs(tContent) do
        local line = ''
        for i, j in ipairs(v) do
            if '' == line then
                line = escapeCSV(j)
            else
                line = line .. ',' .. escapeCSV(j)
            end
        end
        file:write(line .. '\n')
    end

    file:close()
end
function F_SaveGrayDataDBV()
    local chn = 1
    local tmpdata = {}
    local filename = ''
    local filenameLvxy = ''
    local fileName = string.format('DBVData%s.csv', os.date('%Y%m%d%H%M%S'))
    local sfilename = string.format('//CSV//%s', fileName)
    gScriptFolderPath = GetLuaFolderName()
    filename = gScriptFolderPath .. sfilename
    tmpdata[1] = {'DBV', 'LV', 'x', 'y'}
    --SYS.SwitchRGB(255,255,255);
    --TIME.DELAY(1000)
    --local ret, res = OPTICAL.SendCmd(gDevId, "MVS,90")
    --MSG.Println(res)
    WriteCsv(filename, tmpdata)

    -- show rgb
    SYS.SwitchRGB(chn, 255, 255, 255)
    TIME.DELAY(50)

    -- initi2c
    InitI2C()
    TIME.Delay(100)

    F_Remapping_OFF()
    TIME.Delay(50)
    Demura_OFF()
    TIME.Delay(50)

    --local ReadCRC = {}
    local CMD = {0x34, 0x36, 0x45}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end

    -- enter debug
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)

    CMD = {0x51, 0x54, 0x7F, 0x80, 0x82, 0x84, 0x37, 0x35, 0x71, 0x35}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
    TIME.Delay(300)
    --
    WRITE_DATA = {0x10, 0x00, 0x00, 0x00}
    I2C_WriteData(WRITE_DATA)
    TIME.Delay(50)
    --
    local addr = 0x100000
    local addrLen = 3
    local readLen = 1
    local readBuf = {}
    readBuf = I2C_ReadData(addrLen, addr, readLen)

    --local DBVtb = {4095,3413, 2714, 2133, 1629, 1202, 814, 388, 1}

    --for i = 1, #DBVtb do
    --local DBVVal = DBVtb[i]
    for i = 0, 200, 1 do
        local DBVVal = i
        MSG.Println('%d --- DBV value : 0x%04X', i, DBVVal)

        if SYS.GetResetKeyIsPressed() == 1 then
            MSG.Warning('Reset Key Is Pressed, stop to tunning Gamma.')
            break
        end
        WRITE_DATA = {0x10, 0x09, 0x81, 0x02}
        I2C_WriteData(WRITE_DATA)

        WRITE_DATA = {0x10, 0x09, 0x80, 0x01}
        I2C_WriteData(WRITE_DATA)
        -- 0x0983 = dbv[11:8]
        WRITE_DATA = {0x10, 0x09, 0x83, (DBVVal >> 8) & 0x0F}
        I2C_WriteData(WRITE_DATA)
        -- 0x0982 = dbv[7:0]
        WRITE_DATA = {0x10, 0x09, 0x82, DBVVal & 0xFF}
        I2C_WriteData(WRITE_DATA)

        WRITE_DATA = {0x10, 0x09, 0x80, 0x03}
        I2C_WriteData(WRITE_DATA)

        TIME.Delay(50)

        local xylv = READXYLV()
        tmpdata = {}
        tmpdata[1] = {i, xylv['Lv'], xylv['x'], xylv['y']}
        WriteCsv(filename, tmpdata)
    end
    GAMMA.sendCSV2PC(fileName)
    UninteI2C()
    return true
end

function F_SaveGrayData()
    --setDBVI2C_ON() 	--切换DBV前，打开DBV_I2C，关闭NORMAL_I2C，关闭SPI
    TIME.Delay(300)
    local chn = 1
    local tmpdata = {}
    local filename = ''
    local filenameLvxy = ''
    local fileName = string.format('GrayData%s.csv', os.date('%Y%m%d%H%M%S'))
    local sfilename = string.format('//CSV//%s', fileName)

    gScriptFolderPath = GetLuaFolderName()
    filename = gScriptFolderPath .. sfilename
    tmpdata[1] = {'Band', 'Gray', 'LV', 'x', 'y'}
    --SYS.SwitchRGB(255,255,255);
    --TIME.DELAY(1000)
    --local ret, res = OPTICAL.SendCmd(gDevId, "MVS,90")
    --MSG.Println(res)
    WriteCsv(filename, tmpdata)

    -- show rgb
    SYS.SwitchRGB(chn, 255, 255, 255)
    TIME.DELAY(50)

    -- initi2c
    InitI2C()
    TIME.Delay(100)

    F_Remapping_OFF()
    TIME.Delay(50)
    Demura_OFF()
    TIME.Delay(50)

    local DBV = {4095, 3413, 2714, 2133, 1629, 1202, 814, 388, 1}
    --  local DBV = {0x64,0x50}
    for i = 17, 18 do
        F_ENTER_MODE(i)

        --	for j = 255, 0, -1 do
        for j = 0, 255, 1 do
            MSG.Println('band : %d, gray : %d', i, j)
            --SYS.SwitchRGB(j,j,j)
            SYS.SwitchRGB(chn, j, j, j)
            TIME.DELAY(80)
            if SYS.GetResetKeyIsPressed() == 1 then
                MSG.Warning('Reset Key Is Pressed, stop to tunning Gamma.')
                break
            end
            local xylv = READXYLV()
            tmpdata = {}
            tmpdata[1] = {i, j, xylv['Lv'], xylv['x'], xylv['y']}
            WriteCsv(filename, tmpdata)
        end
    end
    GAMMA.sendCSV2PC(fileName)
    UninteI2C()
    return true
end

function WriteTuning2Csv_B12()
    local ProName = 'BFA002_GAMMA'
    MSG.Debug('WriteTuning2Csv_B12 ... start')
    local FolderName = GetLuaFolderName()
    local filePath = string.format('%sCSV//', FolderName)
    --local filename = string.format("%sCSV//%s.CSV", FolderName, os.date("%Y%m%d%H%M%S"))
    local filename = string.format('PG%d_%s_%s_%s.CSV', SYS.GetPgId(), gPanelID, ProName, os.date('%Y%m%d%H%M%S'))
    local fullFileName = string.format('%s%s', filePath, filename)
    local Content = ''
    local ContentResult = ''
    local filenameresult = ''
    local fullFileNameresult = ''
    if gRecordData['TuningResult'] == 0 and gRecordData['StopTuning'] == 0 then
        fullFileNameresult = string.format('%s%s_OK.csv', filePath, filename)
        filenameresult = string.format('%s_OK.csv', filename)
    else
        fullFileNameresult = string.format('%s%s_NG.csv', filePath, filename)
        filenameresult = string.format('%s_NG.csv', filename)
    end
    MSG.Debug('filenameresult : %s', filenameresult)
    --MSG.Debug("gTuningRecordContentHead : %d", gTuningRecordContentHead)
    if gTuningRecordContentHead == 1 then
        Content =
            'Tuning Time \n' ..
            tostring(gTuning_Time) ..
                '\nbandindex,GRAY,GrayColorIndex,nCount,REGR,REGG,REGB,Mesure_L,Mesure_x,Mesure_y,SpecLMax,SpecLMin,SpecXMax,SpecXMin,SpecYMax,SpecYMin,LSpecIn,XSpecIn,YSpecIn,TuningTime,AlgTime,WriteTime,ReadTime \n' ..
                    gTuningRecordContent
        ContentResult =
            'Tuning Time \n' ..
            tostring(gTuning_Time) ..
                '\nbandindex,GRAY,GrayColorIndex,nCount,REGR,REGG,REGB,Mesure_L,Mesure_x,Mesure_y,SpecLMax,SpecLMin,SpecXMax,SpecXMin,SpecYMax,SpecYMin,LSpecIn,XSpecIn,YSpecIn,TuningOneRegTime,AlgAllTime,WriteAllTime,ReadAllTime \n' ..
                    gTuningResultContent
        gTuningRecordContentHead = 0
    else
        --Content = gTuningRecordContentHead
        --ContentResult = gTuningRecordContentHead
        Content = gTuningRecordContent
        ContentResult = gTuningResultContent
    end
    --MSG.Debug("gTuningRecordContentHead : %d", #gTuningRecordContent)
    local file = assert(io.open(fullFileName, 'a+b'))
    file:write(Content)
    file:close()

    file = assert(io.open(fullFileNameresult, 'a+b'))
    file:write(ContentResult)
    file:close()

    -- send to UIS/file server by ftp
    F_SaveCSV2PC_B12(filename, 'Gamma')
    F_SaveCSV2PC_B12(filenameresult, 'Gamma')

    gTuningRecordContent = ''
    gTuningResultContent = ''
    MSG.Debug('WriteTuning2Csv ... end')
end

function WRITE_GAMMA(R_value,G_value,B_value)
    local ret = 0
    --gGammaRed[GrayColorIndex - 1] = math.floor((gGammaRed[GrayColorIndex-2] + gGammaRed[GrayColorIndex])/2)
    --gGammaGreen[GrayColorIndex - 1] = math.floor((gGammaGreen[GrayColorIndex-2] + gGammaGreen[GrayColorIndex])/2)
    --gGammaBlue[GrayColorIndex - 1] = math.floor((gGammaBlue[GrayColorIndex-2] + gGammaBlue[GrayColorIndex])/2)

    local writeValRed =R_value
    local writeValGreen = G_value
    local writeValBlue = B_value

    local CMD = {0x10}
    local buf = {}
	I2C_DEBUG_ENTER_MODE()
  

    require 'socket'
    local time1 = socket.gettime()

    local addr = 0x00000
    local tdata = 0x0001
    I2C_WRITE_CMD(addr, tdata, CMD)
    --I2C_READ_CMD(addr, buf, 2, CMD)
    --MSG.Debug("I2C_READ_CMD 0x%02X, 0x%02X", buf[1], buf[2])

    addr = 0x11F02
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)
    --I2C_READ_CMD(addr, buf, 2, CMD)

    addr = 0x138D8
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0000
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValRed
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0020
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0004
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValGreen
    I2C_WRITE_CMD(addr, tdata, CMD)
    --[[I2C_READ_CMD(addr, buf, 2, CMD)
	UI.PRINTLN((buf[2]<<8)+buf[1])
	UI.PRINTLN(GammaGreen[nIndex])--]]
    addr = 0x138DA
    tdata = 0x0024
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0008
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DC
    tdata = writeValBlue
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x0028
    I2C_WRITE_CMD(addr, tdata, CMD)

    addr = 0x138DA
    tdata = 0x1000
    I2C_WRITE_CMD(addr, tdata, CMD)

    local time2 = socket.gettime() - time1
   --MSG.Println("I2C_WRITE_CMD time2=%f,GrayColorIndex=%d", time2,GrayColorIndex);
   --MSG.Debug("I2CWrite time2=%f", time2);

 --I2C_DEBUG_EXIT_MODE()
    TIME.DELAY(100)
 -- MSG.PRINTLN('111111111111 ...')
    return ret
	
--	 local ret = 0
--    local I2C_ADDR = 0x48
--    local IIC_CH = 2
--    local addrLen = 0
--    local addr = 0x00
--    local WRITE_LEN = #writeData
--    local WRITE_UNIT = #writeData

end

function CRCread()
	local DemuraTCONCrc = ReadDemuraCRC()
   --local CRCData = GetFileCRCData(filePath)
   --DemuraBinCrc = GetFileCRCData(DemuraFilePath)
   
	MSG.Println("DemuraBinCrc : %s", ADDP.Array2Hexstr(CRCData))
	MSG.Println("DemuraTCONCrc : %s", ADDP.Array2Hexstr(DemuraTCONCrc))
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

function binfileCRC()
    --local filePath = "D://CJM//JC_PC_UIS_B12_1.0.0.25//file server//demurabin//Demura_File_Pg_1.bin"   --用于产线bin档路径
	local filePath = "//opt//program//demura//Demura_File_Pg_1.bin"
    MSG.Println("Read Binary File ...")
    --local binData = ReadBinaryFile(filePath)
	--local binData = ReadBinFile(filePath)
    --local fileSize = #binData
    --local fileSize = GetFileSize(filePath)
    local CRCData = GetFileCRCData(filePath)
    MSG.Println("CRCData : %s", ADDP.Array2Hexstr(CRCData))
end

function SPI_READ_Flash(chn, addr, readLen)
	InitSPI()
    local readData = {}
    MSG.Println("addr : 0x%06X, readLen : %d, 0x%06X", addr, readLen, readLen)
	local readUnit = 256
    local Offset = 0
    while(Offset < readLen) do
        local readBufLen = 0
        local readBufAddr = addr + Offset
        local readBuf = {}
        
        if(readLen - Offset)> readUnit then
            readBufLen = readUnit
        else
            readBufLen = readLen - Offset
        end
        local writeData = {0x6}
        SPI.Write(chn, writeData) 
        --MSG.Println("----- readBufAddr : 0x%06X, readBufLen : %d, 0x%06X", readBufAddr, readBufLen, readBufLen)
        writeData = {0x03}
        writeData[2] = (readBufAddr >> 16)& 0xFF
        writeData[3] = (readBufAddr >> 8)& 0xFF
        writeData[4] = readBufAddr & 0xFF
        readBuf = SPI.Read(chn, writeData, readBufLen)
        --MSG.Println(ADDP.Array2Hexstr(readBuf))
        for i = 1, readBufLen do
            readData[Offset + i] = readBuf[i]
        end
        Offset = Offset + readBufLen
    end
	MSG.Println("SPI Read Flash Data: %s", ADDP.Array2Hexstr(readData))
    --MSG.Println("SPI Read Flash Data: %s", readData)
    return readData
end


function ReadDemuraCRC()
	InitI2C()
	local ReadCRC = {}
	--I2C enter Debug mode
	local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)
    local CMD = {0x35, 0x52, 0x54, 0x81, 0x83, 0x84, 0x7F, 0x35, 0x37}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
	
	--I2C read TCON
	for i = 1, 1 do
		local CMD = {0x10}
		--[[
        buffer = I2C_READ_CMD(addr, buffer, 2, CMD)
        MSG.Println(#buffer)
		
		--2nd way read TCON
		--]]
		--local addrr = addr | (CMD[1] << 24)
		local addrLen = 4
		local ret = 0
		local I2C_ADDR = 0x59
		local IIC_CH = 2
		local READ_LEN = 1
		local READ_UNIT = 1
		local readData = {}
		--local ReadCRC = {}
		addrlist = {0x9AC, 0x9AD, 0x9AE, 0x9AF}
		for addrress =1, #addrlist do
			addrr = addrlist[addrress] | (CMD[1] << 24)
			readData = I2C.ReadI2C(IIC_CH, I2C_ADDR, addrLen, addrr, READ_LEN, READ_UNIT)
			ReadCRC[addrress] = readData[1]
		end
		MSG.Println('Read TCON CRC Data: %s', ADDP.Array2Hexstr(ReadCRC))
    end
	
	--I2C exit Debug mode
	local CMD = {0x36,0x34,0x7E,0x45}
    for i = 1 ,#CMD do
        I2C_WriteData({CMD[i]})
    end
	return ReadCRC
end

function I2C_READ_TCON2(addr)
	InitI2C()
	MSG.Debug('Binary each time')
	local len = 2
	local ReadCRC = {}
	local buffer = {}
	--I2C enter Debug mode
	local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)
    local CMD = {0x35, 0x52, 0x54, 0x81, 0x83, 0x84, 0x7F, 0x35, 0x37}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
	
	--I2C read TCON
	for i = 1, 1 do
		local CMD = {0x10}
        buffer = I2C_READ_CMD_free(addr, buffer, len, CMD)
		MSG.Println('Read TCON Data: %s', ADDP.Array2Hexstr(buffer))
    end
	
	--I2C exit Debug mode
	local CMD = {0x36,0x34,0x7E,0x45}
    for i = 1 ,#CMD do
        I2C_WriteData({CMD[i]})
    end
end

function I2C_READ_TCON(addr,len)
	InitI2C()
	MSG.Debug('Binary each time')
	local readLenUnit = 2
	local ReadData = {}
	local buffer = {}
	--I2C enter Debug mode
	local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)
    local CMD = {0x35, 0x52, 0x54, 0x81, 0x83, 0x84, 0x7F, 0x35, 0x37}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
	
	--I2C read TCON
	readLen = math.ceil(len/2)
    local Offset = 0
    while(Offset < readLen) do
		local readBufLen = 0
        --local readBufAddr = addr + Offset
        local readBuf = {}
		for i = 1, 1 do
			local CMD = {0x10}
			buffer = I2C_READ_CMD_free(addr, buffer, readLenUnit, CMD)
			ReadData[Offset*2+1] = buffer[1]
			ReadData[Offset*2+2] = buffer[2]
			MSG.Println("I2C Read TCON Addr : %#X", addr)
			--MSG.Println('Read TCON Data: %s', ADDP.Array2Hexstr(buffer))
		end
		Offset = Offset + 1
		addr = string.format('%#x',(addr + 0x02))
	end
	MSG.Println('Read TCON Data: %s', ADDP.Array2Hexstr(ReadData))
	
	--I2C exit Debug mode
	local CMD = {0x36,0x34,0x7E,0x45}
    for i = 1 ,#CMD do
        I2C_WriteData({CMD[i]})
    end
end