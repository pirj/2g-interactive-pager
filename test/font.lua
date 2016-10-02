dofile('font.lua')

-- TESTING:

rows = { 0x00 , 0x00 , 0x00 , 0x00 , 0x00 , 0x41 , 0x49 , 0x49 , 0x49 , 0x36 , 0x22 , 0x22 , 0x00 , 0x00 , 0x00 , 0x00 }

function toBits(num)
    -- returns a table of bits, least significant first.
    local t={'.', '.', '.', '.', '.', '.', '.', '.' } -- will contain the bits
    local index = 0
    while num>0 do
        rest=math.fmod(num,2)
        index = index + 1
        if rest == 1 then
          t[index]='#'
        end
        num=(num-rest)/2
    end
    return string.reverse(table.concat(t))
end

for column=1,16 do
  print(toBits(rows[column], 1))
end

function printChar(char)
  for column=1,8 do
    print(toBits(char[2][column], 1) .. toBits(char[1][column], 1))
  end
end

pivoted = pivotBitmap(rows)
printChar(pivoted)
