require("luacom");
require("lc");

local excel = luacom.CreateObject("Excel.Application");
excel.Visible = false;

-- local book  = excel.Workbooks:Add()
local book  = excel.Workbooks:Open("C:/Users/z489/Desktop/excel/ConfigValue.xlsx");

print(book.Worksheets.count);

-- local file = io.open("data.lua", "w");
-- file:write("\0");
-- print(string.len("\0"));
-- file:close();

-- do return end;
local file_name = nil;
for i = 1, book.Worksheets.count do
    local sheet = book.Worksheets(i);
end


-- for row=1,100 do
--   sheet.Cells(row, 1).Value2 = math.floor(math.random() * 20)
-- end

-- print(sheet.name);
print(sheet.Usedrange.columns.count);
print(sheet.Usedrange.rows.count);

-- local file = io.open("data.lua", "w");
-- file:write(lc.a2u("好好"));
-- file:close();

-- do return end;

local file = io.open("data.lua", "w");

for columns = 1, sheet.Usedrange.columns.count do
    -- print(sheet.Cells(1, columns).Value2);
    local value = sheet.Cells(1, columns).Value2;
    if type(value) == "string" then
        value = string.sub(lc.a2u(value), 1, -2);
    end
    print(value);
    file:write(tostring(value).."\n");
end

file:close();

-- do return end;

book:Close();
excel:Quit();
excel = nil;
-- for k,v in pairs(sheet) do
--     print(k, v);
-- end
-- for k,v in pairs(getmetatable(sheet)) do
--     print(k, v);
-- end