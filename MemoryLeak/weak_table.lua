function find_object(obj, target)
    -- body
    if target == nil then
        return false;
    end
    if target == weak_table then
        return false;
    end
    -- 表明已经查找过了
    if finded_table[target] ~= nil then
        return false;
    end
    finded_table[target] = true;
    local target_type = type(target);
    if target_type == "table" then
        for k,v in pairs(target) do
            if k == obj or v == obj then
                sprint("v = "..tostring(v));
                sprint("k = "..tostring(k));
                return true;
            end
            if find_object(obj, k) == true then
                sprint("table key");
                return true;
            end
            if find_object(obj, v) == true then
                sprint("k = "..tostring(k));
                return true;
            end
        end
    elseif target_type == "function" then
        local uv_index = 1;
        while true do
            local name, value = debug.getupvalue(target, uv_index);
            if name == nil then
                break;
            end
            if find_object(obj, value) == true then
                sprint("upvalue name:["..tostring(name).."]");
                return true;
            end
            uv_index = uv_index + 1;
        end
    end
    return false;
end

function print_object(obj)
    -- body
    finded_table = {};
    find_object(obj, _G);
    finded_table = {};
end

weak_table = {};
setmetatable(weak_table, {__mode = "k",});

local fun = smanager.load_lib;
function smanager.load_lib(...)
    -- body
    local hand = fun(...);
    weak_table[hand] = true;
    return hand;
end

local fun = sbase_find;
function sbase_find(...)
    -- body
    local hand = fun(...);
    weak_table[hand] = true;
    return hand;
end

function print_all_object()
    -- body
    collectgarbage();
    sprint("print all object\n");
    for k,v in pairs(weak_table) do
        sprint(tostring(k:get_name()));
        print_object(k);
        sprint("\n");
        -- sprint(tostring(k));
    end
    sprint("print all object end");
end