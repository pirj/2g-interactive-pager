sys.ledblink(REDLED)

local oled = require('oled')
local font = require('font')

local message = 'Hello, world!'

oled.init()

sys.ledblink(GREENLED)

local count = 0
function hello()
  local message = "Hello, world" .. count
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
  count = count + 1
end

t = timer.create(1000, hello)

sys.ledblink(GREENLED)
i2c.log('4')

-- FIXME catch and display uncatched lua errors
