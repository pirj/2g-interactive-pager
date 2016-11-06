sys.ledblink(REDLED)

local oled = require('oled')
local font = require('font')

local message = 'Hello, world!'

oled.init()

sys.ledblink(GREENLED)

function hello()
  local gpio1 = gpio.read(1)
  local gpio2 = gpio.read(2)
  local message = "GPIO 1 and 2: " .. gpio1 .. gpio2
  oled.pos0()
  for index=1,message:len() do
    local char = message:sub(index, index)
    local bitmap = font[char]
    if bitmap then
      for i=1,8 do
        oled.oct8t({ bitmap[1][i], bitmap[2][i], bitmap[1][i], bitmap[2][i], bitmap[1][i], bitmap[2][i], bitmap[1][i], bitmap[2][i] })
      end
    end
  end
end

gpio.mode(1, INPUT_PULLUP)
gpio.mode(2, INPUT_PULLUP)

sys.ledblink(0)
i2c.log('Starting up')

global_timer = timer.create(1000, hello)

-- FIXME catch and display uncatched lua errors
