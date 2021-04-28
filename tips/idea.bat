@echo off&setlocal enabledelayedexpansion

set ideaPath=C:\Users\gaofei\AppData\Roaming\JetBrains\IntelliJIdea2020.3
rem 备份文件
copy /y !ideaPath!\options\other.xml !ideaPath!\options\other.xml.bak

rem 删除other文件xml内容
cd.  > !ideaPath!\options\other.xml.tmp
for /f "delims=" %%i in (!ideaPath!\options\other.xml) do (
	set "str=%%i"
	for /f "delims=" %%t in ("!str!") do (
		set tmp=%%t
		set tmp=!tmp:evlsprt=qqq!
		rem echo !tmp!
		rem echo %%t
		if "!tmp!" neq "%%t" (
			rem echo "%%t:sdf%%"
			rem echo "%%t%%"
			echo "delete line ==>!str!"
		) else (
			echo !str! >> !ideaPath!\options\other.xml.tmp
		)
	)
)
rem 把筛选过的文件重新覆盖配置
copy /y !ideaPath!\options\other.xml.tmp !ideaPath!\options\other.xml

rem 删除试用密钥文件夹
rd /s /q !ideaPath!\eval

rem 删除注册表
reg delete "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains" /f

echo "over bat"

pause
