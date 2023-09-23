takeown /f "C:\Windows\System32\mcupdate_GenuineIntel.dll"
icacls "C:\Windows\System32\mcupdate_GenuineIntel.dll" /grant "%USERNAME%:(F)"
del "C:\Windows\System32\mcupdate_GenuineIntel.dll" /f /q

takeown /f "C:\Windows\System32\mcupdate_AuthenticAMD.dll"
icacls "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /grant "%USERNAME%:(F)"
del "C:\Windows\System32\mcupdate_AuthenticAMD.dll" /f /q

pause
