--arg[1]为文件列表txt，arg[2]为lua导出目录

for k,v in pairs(arg) do
    print(k, v);
end

require("luacom");
require("lc");

function get_value(type, value)
    if type == nil or value == nil then
        return nil;
    end
    --转化为小写
    local type = string.lower(type);
    if type == "string" then
        --lc问题，导致转换后会多一个/0，所以做了截取
        return string.sub(lc.a2u(tostring(value)), 1, -2);
    end
    if type == "integer" then
        return tonumber(value);
    end
end

function get_write_str( str )
    if type(str) == "string" then
        return "\""..str.."\"";
    end
    return tostring(str);
end

function data_to_lua( file_name, data, to)
    local file = io.open(to..file_name..".lua", "w");
    file:write(file_name.." = {\n");
    for k,v in ipairs(data) do
        local str = {};
        table.insert(str, "\t["..get_write_str( v.key ).."] = {");
        for m,n in pairs(v.value) do
            table.insert(str, m.." = "..get_write_str(n)..", ");
        end
        table.insert(str, "},\n")
        str = table.concat(str);
        file:write(str);
    end
    file:write("};");
    file:close();
    print(file_name);
end

function excel_to_lua( from, to )
    if excel == nil then
        excel = luacom.CreateObject("Excel.Application");
        excel.Visible = false;
    end

    -- local book  = excel.Workbooks:Add()
    local book = excel.Workbooks:Open(from);

    -- print(book.Worksheets.count);

    -- local file = io.open("data.lua", "w");
    -- file:write("\0");
    -- print(string.len("\0"));
    -- file:close();

    -- do return end;
    local file_name = nil;
    local data = {};
    for i = 1, book.Worksheets.count do
        local sheet = book.Worksheets(i);
        --第一个工作表的（1,1）为文件名
        if file_name == nil then
            if sheet.Cells(1, 1).Value2 == nil then
                error("file name is nil");
            end
            file_name = sheet.Cells(1, 1).Value2;
        end
        --(3, 2)和(4, 2)为每一行配置的key，如为nil则表示不需要导出客户端配置
        local key_type = sheet.Cells(3, 2).Value2;
        local key_name = sheet.Cells(4, 2).Value2;
        if key_type and key_name then
            --需要导出的列数
            local need_columns = {};
            for c = 2, sheet.Usedrange.columns.count do
                --当前列的3、4行为该字段类型与名字
                local columns_type = sheet.Cells(3, c).Value2;
                local columns_name = sheet.Cells(4, c).Value2;
                if columns_type and columns_name then
                    local columns_info = {};
                    columns_info.columns = c;
                    columns_info.columns_type = columns_type;
                    columns_info.columns_name = columns_name;
                    table.insert(need_columns, columns_info);
                end
            end
            --第7行开始为配置内容
            for r = 7, sheet.Usedrange.rows.count do
                local mark = sheet.Cells(r, 1).Value2;
                --END表示当前配置表配置结束
                if mark == "END" then
                    -- print("END");
                    break;
                end
                --###表示忽略该行
                if mark == "###" then
                    -- print("###");
                else
                    local one_data = {};
                    one_data.key = get_value(key_type, sheet.Cells(r, 2).Value2);
                    one_data.value = {};
                    for k,v in ipairs(need_columns) do
                        one_data.value[v.columns_name] = get_value(v.columns_type, sheet.Cells(r, v.columns).Value2);
                    end
                    table.insert(data, one_data);
                end
            end
        end
    end
    if #data ~= 0 then
        data_to_lua(file_name, data, to);
    end

    book:Close();
end

--arg[1]为文件列表txt，arg[2]为lua导出目录
for line in io.lines(arg[1]) do
    --判断是否为xlsx文件
    if string.find(line, ".xlsx") then
        excel_to_lua(line, arg[2]);
    end
end

if excel then
    excel:Quit();
    excel = nil;
end


-- for row=1,100 do
--   sheet.Cells(row, 1).Value2 = math.floor(math.random() * 20)
-- end

-- print(sheet.name);
-- print(sheet.Usedrange.columns.count);
-- print(sheet.Usedrange.rows.count);

-- -- local file = io.open("data.lua", "w");
-- -- file:write(lc.a2u("好好"));
-- -- file:close();

-- -- do return end;

-- local file = io.open("data.lua", "w");

-- for columns = 1, sheet.Usedrange.columns.count do
--     -- print(sheet.Cells(1, columns).Value2);
--     local value = sheet.Cells(1, columns).Value2;
--     if type(value) == "string" then
--         value = string.sub(lc.a2u(value), 1, -2);
--     end
--     print(value);
--     file:write(tostring(value).."\n");
-- end

-- file:close();

-- do return end;


-- for k,v in pairs(sheet) do
--     print(k, v);
-- end
-- for k,v in pairs(getmetatable(sheet)) do
--     print(k, v);
-- end