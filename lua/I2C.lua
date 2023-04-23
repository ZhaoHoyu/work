require 'GammaSpec'
require 'gammaif'
require 'PowerOn'


function InitI2C_GPIO()
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






function UninteI2C_gpio()
    local chn = 1
    local clkGpioPin = 6
    local sdaGpioPin = 7
    GPIO.SetGpioOutOnOff(chn, clkGpioPin, 1)
    GPIO.SetGpioOutOnOff(chn, sdaGpioPin, 1)
    TIME.Delay(20)
end


function InitI2C()----20220916
--TPVDD--MSDA/MSCL
--TPVDDIO--SDA/SCL_G
    MSG.Debug("I2C.LUA")
    local chn = 1
    I2C.SetI2CBps(2, 50)  -- 50,100,400--？？？？？  波特率
    I2C.I2CPullupEn(chn, 1);
    I2C.SetI2CLevel(chn, 0)--0 1.8V 1 3.3V-----√
 
    I2C.I2CSPISwitch(chn, 1)  ---1:12c  0:spi
    local IIC_CH = 3 ----------------20220916-√
    --CHANNEL
 -- E058A  1-mipi c-phy ;2-mipi d-phy 1.5G; 3-dp
 -- E059A  1-ttl ;2-d-phy 2.5G; 3-lvds;4-dp
    I2C.SetI2CChannel(IIC_CH)
	-- TIME.Delay(100);
	PWR.SetPwrOnOff(chn, POWER_TYPE_TPVDDIO, ON);--SDA/L_G-----√
	
	--  PWR.SetPwrOnOff(chn, POWER_TYPE_TPVDD, ON);--MSCL
   
end

function UninteI2C()
  local chn = 1
	PWR.SetPwrOnOff(chn, POWER_TYPE_TPVDDIO, OFF);--SDA/L_G
    TIME.Delay(20)
end

function I2C_WriteData(writeData)
    local ret = 0
    local I2C_ADDR = 0x59
    local IIC_CH = 2
    local addrLen = 0
    local addr = 0x00
    local WRITE_LEN = #writeData
    local WRITE_UNIT = #writeData
--MSG.Debug("I2CWrite time");
    --require 'socket'
    --local time1 = socket.gettime()
    --ret = GPIO.I2CWrite(IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT, writeData)
	ret = I2C.WriteI2C(IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT, writeData)
    --local time2 = socket.gettime() - time1;
    --MSG.Println("I2CWrite time2=%f, IIC_CH=%d, I2C_ADDR=%d, addrLen=%d, addr=%d, WRITE_LEN=%d, WRITE_UNIT=%d", time2, IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT);
    --MSG.Debug("I2CWrite time2=%f", time2);
    return ret
end


function I2C_WriteData_DAC(writeData)
    local ret = 0
    local I2C_ADDR = 0x48
    local IIC_CH = 2
    local addrLen = 0
    local addr = 0x00
    local WRITE_LEN = #writeData
    local WRITE_UNIT = #writeData

    --require 'socket'
    --local time1 = socket.gettime()
    --ret = GPIO.I2CWrite(IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT, writeData)
	ret = I2C.WriteI2C(IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT, writeData)
    --local time2 = socket.gettime() - time1;
    --MSG.Println("I2CWrite time2=%f, IIC_CH=%d, I2C_ADDR=%d, addrLen=%d, addr=%d, WRITE_LEN=%d, WRITE_UNIT=%d", time2, IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT);
    --MSG.Debug("I2CWrite DAC");
    return ret
end





function I2C_ReadData(addrLen, addr, readLen)
    local ret = 0
    local I2C_ADDR = 0x59
    local IIC_CH = 2
    --local addrLen = 0
    --local addr = 0x00
    local READ_LEN = readLen
    local READ_UNIT = readLen
    local readData = {}
    --readData = I2CUseGpioReadNoStop(IIC_CH, I2C_ADDR, addrLen, addr, READ_LEN, READ_UNIT)
    --readData = GPIO.I2CReadNoStop(IIC_CH, I2C_ADDR, addrLen, addr, READ_LEN, READ_UNIT);
    readData = I2C.ReadI2C(IIC_CH, I2C_ADDR, addrLen, addr, READ_LEN, READ_UNIT)
	return readData
end


function I2C_WRITE_CMD(addr, data, CMD)
    local ret = 0
    local writeData = {}
    writeData[1] = CMD[1] & 0xFF
    writeData[2] = (addr >> 16) & 0xFF
    writeData[3] = (addr >> 8) & 0xFF
    writeData[4] = addr & 0xFF
    writeData[5] = data & 0xFF
    writeData[6] = (data >> 8) & 0xFF

    ret = I2C_WriteData(writeData)

    return SUCCESS
end

function I2C_READ_CMD(addr, buffer, length, CMD)
    local I2C_ADDR = 0x59
    local IIC_CH = 2
    local READ_LEN = length
    local READ_UNIT = length
    --local buffer = {}
    local addrLen = 4
    local REG_ADDR = {}

    --local addrr = (addr>>16&0xFF)|(addr>>8&0xFF) <<8 |(addr&0xFF) <<16 | (CMD[1] <<24)
    local addrr = addr | (CMD[1] << 24)
    MSG.Debug('%d, 0x%08X, %d', addrLen, addrr, length)
    buffer = I2C_ReadData(addrLen, addrr, length)
    MSG.Debug('read addr : 0x%06X, data : 0x%02X, 0x%02X', addr, buffer[1], buffer[2])
    MSG.Debug(#buffer)
    return buffer
end

function I2C_READ_CMD_free(addr, buffer, length, CMD)
    local I2C_ADDR = 0x59
    local IIC_CH = 2
    local READ_LEN = length
    local READ_UNIT = length
    --local buffer = {}
    local addrLen = 4
    local REG_ADDR = {}

    --local addrr = (addr>>16&0xFF)|(addr>>8&0xFF) <<8 |(addr&0xFF) <<16 | (CMD[1] <<24)
    local addrr = addr | (CMD[1] << 24)
    --MSG.Debug('%d, 0x%08X, %d', addrLen, addrr, length)
    buffer = I2C_ReadData(addrLen, addrr, length)
	--MSG.Println('Read TCON Data: %s', ADDP.Array2Hexstr(buffer))
    --MSG.Debug('read addr : 0x%06X, data : 0x%02X, 0x%02X', addr, buffer[1], buffer[2])
    --MSG.Debug(#buffer)
    return buffer
end


function I2C_READ_CMD_free(addr, buffer, length, CMD,len)
    local I2C_ADDR = 0x59
    local IIC_CH = 2
    local READ_LEN = length
    local READ_UNIT = length
    --local buffer = {}
    local addrLen = 4
    local REG_ADDR = {}

    --local addrr = (addr>>16&0xFF)|(addr>>8&0xFF) <<8 |(addr&0xFF) <<16 | (CMD[1] <<24)
    local addrr = addr | (CMD[1] << 24)
    MSG.Debug('%d, 0x%08X, %d', addrLen, addrr, length)
    buffer = I2C_ReadData(addrLen, addrr, length)
    MSG.Debug('read addr : 0x%06X, data : 0x%02X, 0x%02X', addr, buffer[1], buffer[2])
    MSG.Debug(#buffer)
    return buffer
end

local function I2C_DEBUG_ENTER_MODE11()
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)

    local CMD = {0x35, 0x52, 0x7F, 0x35, 0x37}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
    --[[
    local I2C_ADDR = 0x59
    luaI2cWrite(I2C_ADDR, 0x5345524442, 5);
    
    TIME.Delay(10);
	local tb = {0x35,0x52,0x7F,0x35,0x37}
	
	for i = 1 ,#tb do
		luaI2cWrite(I2C_ADDR, tb[i], 1);
        TIME.Delay(10);
	end
--]]
    return SUCCESS
end

local function I2C_DEBUG_EXIT_MODE11()
    local I2C_ADDR = 0x59
    local tb = {0x36, 0x34, 0x7E, 0x45}

    for i = 1, #tb do
        luaI2cWrite(I2C_ADDR, tb[i], 1)
        TIME.Delay(10)
    end
    --[[
    local CMD = {0x36,0x34,0x7E,0x45}
    for i = 1 ,#CMD do
        I2C_WriteData({CMD[i]})
    end
    --]]
    return SUCCESS
end
function I2C_DEBUG_ENTER_MODE()
    local WRITE_DATA = {0x53, 0x45, 0x52, 0x44, 0x42}
    I2C_WriteData(WRITE_DATA)

    local CMD = {0x35, 0x52, 0x54, 0x81, 0x83, 0x84, 0x7F, 0x35, 0x37}
    for i = 1, #CMD do
        I2C_WriteData({CMD[i]})
    end
    --[[
    local I2C_ADDR = 0x59
    luaI2cWrite(I2C_ADDR, 0x5345524442, 5);
    
    TIME.Delay(10);
	local tb = {0x35,0x52,0x7F,0x35,0x37}
	
	for i = 1 ,#tb do
		luaI2cWrite(I2C_ADDR, tb[i], 1);
        TIME.Delay(10);
	end
--]]
    return SUCCESS
end

function I2C_DEBUG_EXIT_MODE()
   --[[ local I2C_ADDR = 0x59
    local tb = {0x36, 0x34, 0x7E, 0x45}

    for i = 1, #tb do
        luaI2cWrite(I2C_ADDR, tb[i], 1)
        TIME.Delay(10)
    end
	--]]
    
    local CMD = {0x36,0x34,0x7E,0x45}
    for i = 1 ,#CMD do
        I2C_WriteData({CMD[i]})
    end
    --]]
    return SUCCESS
end

local function I2C_WriteData2(writeData)
    local ret = 0
    local I2C_ADDR = 0x3E
    local IIC_CH = 2
    local addrLen = 0
    local addr = 0x00
    local WRITE_LEN = #writeData
    local WRITE_UNIT = #writeData

    ret = GPIO.I2CWrite(IIC_CH, I2C_ADDR, addrLen, addr, WRITE_LEN, WRITE_UNIT, writeData)
    return ret
end

function F_Write_I2CFree()
    local WRITE_DATA = {}

    WRITE_DATA = {0x28, 0x01, 0x2A, 0x8A, 0x32, 0xB2}
    I2C_WriteData2(WRITE_DATA)

    WRITE_DATA = {0x29, 0x01, 0x01, 0x01, 0x3C, 0x0A}
    I2C_WriteData2(WRITE_DATA)

    WRITE_DATA = {0x29, 0x01, 0x00, 0x00, 0x3C, 0x0A}
    I2C_WriteData2(WRITE_DATA)
end