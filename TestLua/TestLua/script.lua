print("lua script");

t = {
    a = 1;
    b = 2;
};

p1 = 10;

function add(a, b)
    return a + b;
end

-- lua����c++����
local ave, sum = average(10, 55, 23, 41);
print("average = "..ave);
print("sum = "..sum);