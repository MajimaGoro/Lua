-- other_file = {
--     [1] = {file_name = "item/011_001.png",file_size = "258936",},
-- }; 
print(#arg);
for k,v in pairs(arg) do
    print(k, v);
end

-- local ignore_path = "E:\\avg\\game_5th_cn\\trunk\\br_cn_client\\Documents\\";
-- "E:\\avg\\game_5th_cn\\trunk\\br_cn_client\\appClient\\"

local file = io.open("file_list.lua", "w");
local num = 0;
file:write("file_list = {\n");
for line in io.lines("file_name.txt") do
    local source = io.open(line, "r");
    --过滤文件夹
    if source then
        num = num + 1;
        --获取文件大小
        local size = source:seek("end");
        source:close();
        local str;
        --删除目录前缀
        for k,v in ipairs(arg) do
            -- print(v);
            str = string.gsub(line, v, "");
        end
        -- local str = string.gsub(line, ignore_path, "");
        --替换反斜杠
        str = string.gsub(str, "\\", "/");
        file:write("\t["..num.."] = {file_name = \""..str.."\", file_size = \""..size.."\", },\n");
    end
end
file:write("};");
file:close();