## windows bat基本命令
[批处理常用DOS命令篇](https://www.w3cschool.cn/pclrmsc/tdsgnn.html)

1. echo 你要输出的信息
```shell
echo hello,world
echo i will come back
输出：
E:\系统\docs\docs\Windows>echo hello,world
hello,world
E:\系统\docs\docs\Windows>echo i will come back
i will come back

@echo hello,world
@echo i will come back

E:\系统\docs\docs\Windows>.\1.bat
hello,world
i will come back
```
@ 连续输出

打开是否不连续输出功能
格式:echo [{ on|off }]
```shell
@echo off
echo hello,world
echo i will come back
pause

执行显示：
hello,world
i will come back
```
4. 输出空行，即相当于输入一个回车  
格式: echo.     
命令中的“.”要紧跟在ECHO后面,中间不能有空格  
   
5. 答复命令中的提问
格式： ECHO 回复|命令表达式
   作用：通过管道命令 | 把“回复”作为输入传导给后面的“命令表达式”，并作为“命令表达式”的输入
```shell
@echo off
rd /s c:\abc
pause

输出：
c:\abc, Are you sure (Y/N)? 

echo Y|rd /s c:\abc
echo Y|rd /s c:\abc
```

二、注释语句：rem
rem 为注释命令，一般用来给程序加上注解，该命令后的内容不被执行,但不是连续输出的时候会出现
```shell
@echo on
chcp 65001
echo 我在写批处理教程哦
echo i will come back
rem 上面的echo 语句用于显示提示
::上面的echo 语句用于显示提示
pause

输出：
Active code page: 65001
C:\Users\wpc\Desktop>echo 我在写批处理教程哦
我在写批处理教程哦
C:\Users\wpc\Desktop>echo i will come back
i will come back
C:\Users\wpc\Desktop>rem 上面的echo 语句用于显示提示
C:\Users\wpc\Desktop>pause
Press any key to continue . . .


@echo off
chcp 65001
echo 我在写批处理教程哦
echo i will come back
rem 上面的echo 语句用于显示提示
::上面的echo 语句用于显示提示
pause

输出：
Active code page: 65001
我在写批处理教程哦
i will come back
Press any key to continue . . .
```
发现 @echo on 时候rem 会显示出来

:: 的说明：
有效标号：冒号后紧跟一个以字母数字开头的字符串，goto 语句可以识别。

无效标号：冒号后紧跟一个非字母数字的一个特殊符号，goto 无法识别的标号，可以起到注释
作用，所以 :: 常被用作注释符号，其实 : 也可起注释作用

### 切换目录
同一个分区的切换：  
cd \  切换到根路径
不同分区的切换： 加个 /d  
格式：格式:CD /d [盘符][路径]
cd /d d:\123\abc  

当前的完整路径，一般用通过 %cd% 加以引用  
```shell
@echo off
echo 当前绝对路径是 %cd%
pause
```
一、设置文件属性：attrib
显示或更改文件属性。
ATTRIB [ R | -R] [ A | -A ] [ S | -S] [ H | -H] [[drive:] [path] filename] [/S [/D]]

     设置属性。
-    清除属性。
     R   只读文件属性。
     A   存档文件属性。
     S   系统文件属性。
     H   隐藏文件属性。
     [drive:][path][filename]   指定要处理的文件属性。
     /S  处理当前文件夹及其子文件夹中的匹配文件。
     /D  也处理文件夹


1。查看文件的文件属性
格式：ATTRIB [drive:][path][filename]

例1,
attrib d:\ pagefile.sys
查看d:\ pagefile.sys文件的属性。

二、删除命令：del
基本格式：DEL [drive:][path][filename]
del d:\123\abc.txt  
删除abc.txt

/P 删除每一个文件之前提示确认。

例2,
del /p d:\123\*.*
删除d:\123目录下所有文件，如果你想让它在删除前都询问你是否删除，我们可以加上/p参数，防止误删除。

/S 从所有子目录删除指定文件。

例3,
del /s d:\123\*.*
删除d:\123目录及其子目录下所有文件。
通过使用/s参数后，del命令就会在指定目录(如未指定则在当前目录)及其子目录中搜索所有指定文件名的文件并删除。

三、复制文件：copy
Copy只能复制文件，不能复制文件夹。
三、复制文件：copy

Copy只能复制文件，不能复制文件夹。

1。单个文件的复制

格式：copy source[drive:][path][filename]  [destination [drive:][path][filename]]
即copy 要复制的源文件(包括路径和文件名)  文件复制的目标路径[\文件名]，当[destination [drive:][path]
[filename]]缺省时则为当前目录。

例1,
copy c:\123.txt d:\
把123.txt复制到d:\目录下。如果此操作成功，命令行窗口中会提示“已复制 1个文件”。

例2,
copy c:\123.txt d:\abc.bat
把123.txt复制到d:\目录下，并把它修改为abc.bat，这里修改了文件名和它的格式。

例3，
copy .\123
把当前目录下的123子目录中的文件全部拷到当前目录

三、复制文件：copy

Copy只能复制文件，不能复制文件夹。

1。单个文件的复制

格式：copy source[drive:][path][filename]  [destination [drive:][path][filename]]
即copy 要复制的源文件(包括路径和文件名)  文件复制的目标路径[\文件名]，当[destination [drive:][path]
[filename]]缺省时则为当前目录。

例1,
copy c:\123.txt d:\
把123.txt复制到d:\目录下。如果此操作成功，命令行窗口中会提示“已复制 1个文件”。

例2,
copy c:\123.txt d:\abc.bat
把123.txt复制到d:\目录下，并把它修改为abc.bat，这里修改了文件名和它的格式。

例3，
copy .\123
把当前目录下的123子目录中的文件全部拷到当前目录

四、复制文件(夹)：xcopy

复制文件和目录树

xcopy /s d:\123 e:\kkk\
复制d:\123目录下所有文件（夹）到e:\kkk，不包括空的子目录

1.创建单个文件夹
md d:\abc
在D盘下建立一个名为abc的文件夹。

创建多级目录
md d:\abc\abcd\abcde



三.重命名文件(夹)：ren
ren d:\123.txt 456.bat
把123.txt 重命名为456并把后缀名修改为bat。


四.移动文件(夹)：move

move d:\abc d:\abcd
如果把文件夹abc移到文件夹abcd内



四.开启命令：start
start http://www.baidu.com

&符号允许同时执行多条命令，当第一个命令执行失败了，也不影响后边的命令执行。这里 & 两边的命令是顺序执行
的，从前往后执行

&&符号允许同时执行多条命令，当碰到执行出错的命令后将不再执行后面的命令，如果一直没有出错则一直执行完

&&符号允许同时执行多条命令，当碰到执行出错的命令后将不再执行后面的命令，如果一直没有出错则一直执行完

一般而言，^ 以转义字符的身份出现
```shell
@echo off
echo 这是^
一个^
句子
Pause

输出：
E:\系统\docs\docs\Windows>.\1.bat
这是一个句子
Press any key to continue . . .
```

五、变量引导符 % 
```shell
@echo off
set str=abc
echo 变量 str 的值是： %str%
pause

在屏幕上将显示这样的结果：
变量 str 的值是： abc
按任意键继续...
```


一、用set 命令设置自定义变量
```shell
@echo off
set var=abcd
echo %var%
pause
```
清除变量variable 的值，使其变成未定义状态
set variable=
上面等号后面无任何符号，如果写成SET variable=""，此时变量值并不为空，而是等于两个引号，即"" 




1。判断两个字符串是否相等，if "字符串1"=="字符串2" command 语句;
2。判断两个数值是否相等，if 数值1 equ 数值2 command 语句；
3。判断判断驱动器，文件或文件夹是否存在，if exist filename command 语句;
4。判断变量是否已经定义，if defined 变量 command 语句；
5。判断上个命令的返回值，if errorlevel 数值 command 语句。






























   
   













