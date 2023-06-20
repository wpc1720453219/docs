@echo off
chcp 65001
set a= bbs. bathome. cn
echo  替换前的值: "%a%"
set var=%a: =%
echo  替换后的值: "%var%"
pause
