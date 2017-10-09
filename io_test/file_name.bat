::导出文件夹，等号前后不能有空格
set p=E:\avg\game_5th_cn\trunk\br_cn_client\Documents\

dir %p% /b /s > .\file_name.txt
lua file_name.lua %p%
pause