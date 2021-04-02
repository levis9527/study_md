for /f %%i in ('REG QUERY "HKEY_USERS" /k /f * /s ^| findstr "\\CLSID\\.*\\Info$"') do ( reg delete "%%i" /f)


for /f %%i in ('REG QUERY "HKEY_USERS" /k /f * /s ^| findstr "NavicatPremium\\Registration15XCS$"') do ( reg delete "%%i" /f)

