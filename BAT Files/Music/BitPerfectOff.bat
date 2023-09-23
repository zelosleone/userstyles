reg add HKLM\SOFTWARE\Classes\CLSID\{d69e0717-dd4b-4b25-997a-da813833b8ac}\InProcServer32 /f /ve /t REG_EXPAND_SZ /d %%^SystemRoot%%\System32\audioeng.dll
net stop audiosrv
net start audiosrv