local bit = require("bit")

local function desiredCodepoints()
  local codepoints = {}
  for codepoint=0x0020,0x007E do -- ASCII
    codepoints[codepoint] = true
  end
  -- for codepoint=0x00A0,0x00BF do -- ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿
  --   codepoints[codepoint] = true
  -- end
  -- codepoints[0x0401] = true -- Ё
  -- for codepoint=0x0410,0x044F do -- Cyrillic
  --   codepoints[codepoint] = true
  -- end
  -- codepoints[0x0451] = true -- ё
  return codepoints
end

local function loadCharset(codepoints)
  local charset = {}
  -- FIXME: need utf-8 support to properly load/parse CHARSET
  io.input('CHARSET')
  -- 0020 | | Space                     SPACE
  while true do
    local line = io.read()
    if line == nil then break end
    codepoint = tonumber(string.sub(line, 1, 4), 16) -- 0041 aka 65 decimal
    if codepoints[codepoint] then
      character = string.sub(line, 7, 7) -- A
      -- codename = string.match(line, '%w+', 10) -- LtCapA
      charset[codepoint] = character
    end
  end
  return charset
end

local function pivotBitmap(rows)
  local columns = {{},{}}
  for outerRowIndex=1,2 do
    for rowIndex=1,8 do
      local row = rows[(outerRowIndex - 1) * 8 + rowIndex]
      for column=1,8 do
        local previous = columns[outerRowIndex][column] or 0
        local added = bit.band(bit.rshift(row, 8 - column), 1)
        local current = bit.bor(previous, bit.lshift(added, rowIndex - 1))
        columns[outerRowIndex][column] = current
      end
    end
  end
  return columns
end

-- only supports 8x16 pixel font
local function parseChar16()
  while true do
    local line = io.read()
    if line == nil then return end
    if string.match(line, 'BITMAP') then break end
  end
  local rows = {}
  for row=1,16 do rows[row] = tonumber(io.read(), 16) end
  return pivotBitmap(rows)
end

local function loadFont(charset, codepoints)
  local bitmaps = {}
  io.input('t0-16-uni.bdf')
  while true do
    local line = io.read() -- suboptimal according to https://www.lua.org/pil/21.2.1.html
    if line == nil then break end
    if string.match(line, 'STARTCHAR') then
      -- rough assumption that an ENCODING definition follows the STARTCHAR block beginning
      line = io.read()
      local codepoint = tonumber(string.match(line, 'ENCODING (%d+)'))
      if codepoints[codepoint] then
        local bitmap = parseChar16()
        bitmaps[charset[codepoint]] = bitmap
      end
    end
  end
  return bitmaps
end

local codepoints = desiredCodepoints()
local charset = loadCharset(codepoints)
local font = loadFont(charset, codepoints)

return font
