-- initial

oled = require('oled')

oled.init()

h = {
  { 0, 255 - 7, 128, 128, 128, 128, 255 - 7, 0 },
  { 0, 31, 0, 0, 0, 0, 0, 31, 0 }
}

e = {
  { 0, 255 - 7, 8 + 128, 8 + 128, 8 + 128, 8, 8, 0 },
  { 0, 31, 16, 16, 16, 16, 16, 0 }
}

l = {
  { 0, 255 - 7, 0, 0, 0, 0, 0, 0 },
  { 0, 31, 16, 16, 16, 16, 16, 0 }
}

o = {
  { 0, 255 - 15, 8, 8, 8, 8, 255 - 15, 0 },
  { 0, 15, 16, 16, 16, 16, 15, 0 }
}

chars = { h, e, l, l, o }

function hello()
  oled.pos0()
  for i, char in ipairs(chars) do
    for i=1,8 do
      oled.oct8t({ char[1][i], char[2][i], char[1][i], char[2][i], char[1][i], char[2][i], char[1][i], char[2][i] })
    end
  end
end

t = timer.create(100, hello)

-- FIXME catch and display uncatched lua errors
