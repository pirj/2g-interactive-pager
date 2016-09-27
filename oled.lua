-- ssd1306 i2c oled related

local oled = {}

local function cmd(command)
  i2c.w(0x00, command) -- where 0x00 is command escape
end

-- seamlessly borrowed from https://github.com/adafruit/Adafruit_SSD1306/blob/master/Adafruit_SSD1306.cpp
-- and https://github.com/squix78/esp8266-oled-ssd1306/blob/master/OLEDDisplay.cpp
function oled.init()
  i2c.setup(0x3c, 3200) -- FIXME 3400 is the correct speed

  cmd(0xAE) -- display off

  cmd(0xD5) -- set display clock div
  -- cmd(0x80) -- the suggested ratio
  cmd(0xF0) -- max 96Hz speed

  cmd(0xA8) -- set multiplex
  cmd(63) -- to height - 1

  cmd(0xD3) -- set display offset
  cmd(0)

  cmd(0x40) -- set start line (to 0)

  cmd(0x8D) -- charge pump
  -- cmd(0x10) -- external vcc
  cmd(0x14) -- else

  cmd(0x20) -- memory mode
  cmd(0x01) -- vertical
  cmd(0xA1) -- seg remap to 1
  cmd(0xC8) -- com scan dec(reasing) (rotate 180º)

  cmd(0xDA) -- set compins ?
  cmd(0x12)

  cmd(0x81) -- set contrast
  -- cmd(0x9F) -- external vcc
  cmd(0xCF) -- else

  cmd(0xD9) -- Set precharge
  -- cmd(0x22) -- external vcc
  cmd(0xF1) -- else

  cmd(0xDB) -- set vcom detect
  cmd(0x40)
  cmd(0xA4) -- display all on resume
  cmd(0xA6) -- normal display

  cmd(0x2E) -- deactivate scroll

  cmd(0xAF) -- display on
end

function oled.pos0()
  cmd(0x21) -- column begin address range
  cmd(0)
  cmd(127)

  cmd(0x22) -- page address
  cmd(0)
  cmd(7) -- 8 pages total
end

function oled.oct8t(table)
  i2c.w(0x40, table[1], table[2], table[3], table[4])
  i2c.w(0x40, table[5], table[6], table[7], table[8])
end

return oled
