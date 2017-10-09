v1 = {};
v2 = {};
array = {};
array[1] = v1;
array[2] = v2;
v1 = nil;
collectgarbage();
for k,v in pairs(array) do
    print("k = "..k.."\n".."v = "..tostring(v));
end

print("\nweak_table:");
v1 = {};
v2 = {};
array = {};
array[1] = v1;
array[2] = v2;
v1 = nil;
setmetatable(array, {__mode = "v"});
collectgarbage();
for k,v in pairs(array) do
    print("k = "..k.."\n".."v = "..tostring(v));
end

--使用
print("\nexample:");
Date = {
    year = nil;
    month = nil;
    day = nil;
    --保存所有date对象
    allDate = {};
};
setmetatable(Date.allDate, {__mode = "v"});

function Date:new(year, month, day)
    local obj = {};
    obj.year = year;
    obj.month = month;
    obj.day = day;

    setmetatable(obj, self);
    self.__index = self;

    table.insert(Date.allDate, obj);
    return obj;
end

function Date.__tostring(date)
    local t = {};
    table.insert(t, "date:");
    table.insert(t, string.format("\n%-9s", "year:")..date.year);
    table.insert(t, string.format("\n%-9s", "month:")..date.month);
    table.insert(t, string.format("\n%-9s", "day:")..date.day);
    return table.concat(t);
end

--test 测试代码
date1 = Date:new(2017, 9, 16);
date2 = Date:new(2018, 9, 16);
date3 = Date:new(2019, 9, 16);
date1 = nil;
collectgarbage();
for k,v in pairs(Date.allDate) do
    print("\nk = "..k);
    print("v = "..tostring(v));
end