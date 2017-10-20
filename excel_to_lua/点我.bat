::echo off
rd /s /q .\output
del .\file_list.txt
md .\output
dir .\data\ /b /s > .\file_list.txt
pause
lua excel_to_lua.lua .\file_list.txt .\output\
pause