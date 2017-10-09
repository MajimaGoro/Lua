--闭包

--ipairs
function ipairs_test(array)
	local key = 0;
	return function ()
		key = key + 1;
		if array[key] == nil then
			return;
		end
		return key, array[key];
	end
end

--pairs
function pairs_test(table)
	local key,value;
	return function ()
		key,value = next(table, key);
		if key == nil then
			return;
		end
		return key, value;
	end
end

local array = {11, 22, 33};
for k,v in ipairs_test(array) do
	print("key = "..k.."   value = "..v);
end

local table = {a = 11, b = 22, c = 33};
for k,v in pairs_test(table) do
	print("key = "..k.."   value = "..v);
end

--for in 实现
local fun = ipairs_test(array);
repeat
	local k,v = fun();
	if k == nil then
		fun = nil;
		break;
	end
	print("key = "..k.."   value = "..v);
until false