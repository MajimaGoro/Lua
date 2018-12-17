#include <iostream>
using namespace std;

extern "C" 
{
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
}

static int average(lua_State* L)
{
	int n = lua_gettop(L);
	double sum = 0;
	for (int i = 1; i <= n; i++)
	{
		sum += lua_tonumber(L, i);
	}
	lua_pushnumber(L, sum/n);
	lua_pushnumber(L, sum);
	return 2;
}

int main() 
{
	lua_State* L = luaL_newstate();
	luaL_openlibs(L);

	lua_pushnumber(L, 20);
	lua_pushnumber(L, 30);
	//栈底
	cout << "bottom = " << lua_tonumber(L, 1) << endl;
	//栈顶
	cout << "top = " << lua_tonumber(L, -1) << endl;

	//注册函数
	lua_register(L, "average", average);
	//luaL_dofile(L, "script.lua");
	luaL_loadfile(L, "script.lua");
	lua_pcall(L, 0, 0, 0);

	lua_getglobal(L, "p1");
	cout << "p1 = " << lua_tonumber(L, -1) << endl;
	lua_getglobal(L, "t");
	lua_getfield(L, -1, "a");
	cout << "t.a = " << lua_tonumber(L, -1) << endl;
	lua_getfield(L, -2, "b");
	cout << "t.b = " << lua_tonumber(L, -1) << endl;
	cout << "t = " << lua_topointer(L, -3) << endl;

	//函数调用
	//举个比较简单的例子，函数调用流程是先将函数入栈，参数入栈，然后用lua_pcall调用函数，此时栈顶为参数，栈底为函数，
	//所以栈过程大致会是：参数出栈->保存参数->参数出栈->保存参数->函数出栈->调用函数->返回结果入栈。
	//类似的还有lua_setfield，设置一个表的值，肯定要先将值出栈，保存，再去找表的位置。
	lua_getglobal(L, "add");
	lua_getglobal(L, "add");
	lua_pushnumber(L, 100);
	lua_getglobal(L, "p1");
	lua_pcall(L, 2, 1, 0);
	cout << "result = " << lua_tonumber(L, -1) << endl;
	//cout << "add = " << lua_touserdata(L, -2) << endl;

	//设置值
	lua_pushnumber(L, 30);
	//将值设置到p1中，并将30出栈
	lua_setglobal(L, "p1");
	lua_getglobal(L, "p1");
	cout << "p1 = " << lua_tonumber(L, -1) << endl;
	//lua_set

	//打印堆栈信息
	int n = lua_gettop(L);
	for (int i = 1; i <= n; i++)
	{
		switch (lua_type(L, i))
		{
		case LUA_TFUNCTION:
			cout << "type = func, value = " << lua_tocfunction(L, i) << endl;
			break;
		case LUA_TBOOLEAN:
			cout << "type = bool, value = " << lua_toboolean(L, i) << endl;
			break;
		case LUA_TLIGHTUSERDATA:
			cout << "type = lightUserData, value = " << lua_touserdata(L, i) << endl;
			break;
		case LUA_TNIL:
			cout << "type = nil, value = " << lua_tostring(L, i) << endl;
			break;
		case LUA_TNONE:
			cout << "type = none, value = " << lua_tostring(L, i) << endl;
			break;
		case LUA_TNUMBER:
			cout << "type = number, value = " << lua_tonumber(L, i) << endl;
			break;
		case LUA_TSTRING:
			cout << "type = string, value = " << lua_tostring(L, i) << endl;
			break;
		case LUA_TTABLE:
			cout << "type = table, value = " << lua_touserdata(L, i) << endl;
			break;
		case LUA_TTHREAD:
			cout << "type = thread, value = " << lua_tothread(L, i) << endl;
			break;
		case LUA_TUSERDATA:
			cout << "type = userData, value = " << lua_touserdata(L, i) << endl;
			break;
		default:
			break;
		}
	}

	lua_close(L);
	system("pause");
	return 0;
}