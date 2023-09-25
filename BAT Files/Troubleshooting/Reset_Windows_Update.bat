:: Batch script created by FreeBooter

@Echo Off & Cls


REM  --> Check for permissions
Reg query "HKU\S-1-5-19\Environment" 
REM --> If error flag set, we do not have admin.
if %errorlevel% NEQ 0 (
ECHO                 **************************************
ECHO                  Running Admin shell... Please wait...
ECHO                 **************************************

    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = "%*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B


:gotAdmin

Mode CON LINES=5 COLS=50 & Color 0E

Echo                   PLEASE WAIT... 
::Creating System Restore point 
Wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Before Resetting Windows Update Components", 100, 12 

Cls & Mode CON  LINES=30 COLS=84 & Color 0D

Cd %~dp0
Call :IsAdmin



If Exist %UserProfile%\Desktop\WinUpResetLog.txt Del %UserProfile%\Desktop\WinUpResetLog.txt
If Exist %TMP%\WinUpResetLog.txt Del %TMP%\WinUpResetLog.txt

Cls
:: Manually Reset Windows Update Components

Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...


Echo :: Stop the BITS service, the Windows Update service, and the Cryptographic service. >>%TMP%\WinUpResetLog.txt
                   Net stop bits 2>>%TMP%\WinUpResetLog.txt 
                   Net stop wuauserv 2>>%TMP%\WinUpResetLog.txt
                   Net stop appidsvc 2>>%TMP%\WinUpResetLog.txt 
                   Echo Y | Net stop cryptsvc 2>>%TMP%\WinUpResetLog.txt 
                   
Cls                   
Color 1E

Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                 PLEASE WAIT...
Echo :: Change Directory. >>%TMP%\WinUpResetLog.txt
Cd /d %Windir%\System32 1>nul

For /f "tokens=2 delims=[]" %%a in ('ver') do (set Version=%%a)
Set Version=%Version:~8,2% 
If  NOT %Version%==5 ( 

Goto New_Win

) Else (


Proxycfg.exe -d 2>>%TMP%\WinUpResetLog.txt
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG1.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAPI.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\ATL.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUCLTUI.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUPS.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUPS2.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\IUENGINE.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUWEB.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG1.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAPI.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\ATL.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUCLTUI.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUPS.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\IUENGINE.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUWEB.DLL /S
REGSVR32 VBSCRIPT.DLL /S
REGSVR32 JSCRIPT.DLL /S
REGSVR32 SCRRUN.DLL /S
REGSVR32 DISPEX.DLL /S
REGSVR32 MSSCRIPT.DLL /S
REGSVR32 SOFTPUB.DLL /S
REGSVR32 WINTRUST.DLL /S
REGSVR32 INITPKI.DLL /S
REGSVR32 URLMON.DLL /S
REGSVR32 DSSENH.DLL /S
REGSVR32 MSXML.DLL /S
REGSVR32 MSXML2.DLL /S
REGSVR32 MSXML3.DLL /S
REGSVR32 RSAENH.DLL /S
REGSVR32 GPKCSP.DLL /S
REGSVR32 SCCBASE.DLL /S
REGSVR32 SLBCSP.DLL /S
REGSVR32 CRYPTDLG.DLL /S
REGSVR32 MSSIP32.DLL /S 
)

Cls
Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                               PLEASE WAIT...


:New_Win
Echo :: Windows Automatic updates service could be missing, reinstall the component from its configuration file. >>%TMP%\WinUpResetLog.txt 
TASKKILL /F /IM rundll32.exe /T | %Windir%\System32\Rundll32.exe setupapi,InstallHinfSection DefaultInstall 132 %windir%\inf\au.inf 2>>%TMP%\WinUpResetLog.txt 
Cls

Echo :: If Background Intelligent Transfer Service is missing, then click Start, click Run, type the following command. >>%TMP%\WinUpResetLog.txt
TASKKILL /F /IM rundll32.exe /T | %Windir%\System32\rundll32.exe setupapi,InstallHinfSection DefaultInstall 132 %windir%\inf\qmgr.inf  2>>%TMP%\WinUpResetLog.txt 
Cls

Echo :: Creating the  BITS (Background Intelligent Transfer Service) Service. >>%TMP%\WinUpResetLog.txt
Sc Create BITS type= share start= delayed-auto binPath= "C:\Windows\System32\svchost.exe -k netsvcs" tag= no DisplayName= "Background Intelligent Transfer Service" 2>>%TMP%\WinUpResetLog.txt 
Cls

Echo :: Reset the content of the Catroot2 folder. >>%TMP%\WinUpResetLog.txt
  If Exist %Systemroot%\System32\catroot2.old  Rd /s /q %Systemroot%\System32\catroot2.old 2>>%TMP%\WinUpResetLog.txt 
  Md %Systemroot%\System32\catroot2.old 2>>%TMP%\WinUpResetLog.txt 
  Xcopy /y %Systemroot%\System32\catroot2 %systemroot%\system32\catroot2.old /s 2>>%TMP%\WinUpResetLog.txt 
  Ren %SystemRoot%\System32\catroot2 catroot2.bak 2>>%TMP%\WinUpResetLog.txt 

Cls  
Color 0B

Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...

Echo :: Delete the SoftareDistribution directory. >>%TMP%\WinUpResetLog.txt
  Rd /s /q %SystemRoot%\SoftwareDistribution  2>>%TMP%\WinUpResetLog.txt 
  Cls 

Echo :: Delete the qmgr*.dat files. >>%TMP%\WinUpResetLog.txt
  Del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat" /f /q 2>>%TMP%\WinUpResetLog.txt 
  Del C:\Programdata\Microsoft\Network\Downloader\qmgr*.dat /f /q 2>>%TMP%\WinUpResetLog.txt
  del /s /q /f "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat" 2>>%TMP%\WinUpResetLog.txt
  del /s /q /f "%ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr*.dat" 2>>%TMP%\WinUpResetLog.txt
  del /s /q /f "%SYSTEMROOT%\Logs\WindowsUpdate\*" 2>>%TMP%\WinUpResetLog.txt
  Cls

Echo :: Delete any incorrect values that may exist in the registry. >>%TMP%\WinUpResetLog.txt
  Reg  Delete HKEY_LOCAL_MACHINE\COMPONENTS /v PendingXmlIdentifier /f 2>>%TMP%\WinUpResetLog.txt 
  Reg  Delete HKEY_LOCAL_MACHINE\COMPONENTS /v NextQueueEntryIndex  /f 2>>%TMP%\WinUpResetLog.txt 
  Reg  Delete HKEY_LOCAL_MACHINE\COMPONENTS /v AdvancedInstallersNeedResolving /f 2>>%TMP%\WinUpResetLog.txt 
  
  :: Reset Windows Update policies
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f 2>>%TMP%\WinUpResetLog.txt
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /f 2>>%TMP%\WinUpResetLog.txt
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /f 2>>%TMP%\WinUpResetLog.txt
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\WindowsUpdate" /f 2>>%TMP%\WinUpResetLog.txt
gpupdate /force


Cls
Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...

Echo :: Rename Pending.xml file. >>%TMP%\WinUpResetLog.txt
 Takeown /f C:\Windows\Winsxs\Pending.xml 2>>%TMP%\WinUpResetLog.txt 
 Ren C:\Windows\Winsxs\Pending.xml  Pending.xml.bak 2>>%TMP%\WinUpResetLog.txt 
 Cls


Echo :: Reset the BITS service and the Windows Update service to the default security descriptor. >>%TMP%\WinUpResetLog.txt 
Sc sdset Bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU) 2>>%TMP%\WinUpResetLog.txt 
Cls
Sc sdset Wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU) 2>>%TMP%\WinUpResetLog.txt 

Echo :: Change Directory. >>%TMP%\WinUpResetLog.txt
Cd /d %Windir%\System32 1>nul

Cls
Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...



Echo :: Re-register the BITS dynamic-link librarys and the Windows Update dynamic-link librarys. >>%TMP%\WinUpResetLog.txt 
  
  
Regsvr32.exe /s mshtml.dll   2>>%TMP%\WinUpResetLog.txt 
Regsvr32.exe /s shdocvw.dll  2>>%TMP%\WinUpResetLog.txt    
Regsvr32.exe /s browseui.dll 2>>%TMP%\WinUpResetLog.txt 
Regsvr32.exe /s msxml6.dll   2>>%TMP%\WinUpResetLog.txt
Regsvr32.exe /s actxprxy.dll 2>>%TMP%\WinUpResetLog.txt
Regsvr32.exe /s gpkcsp.dll   2>>%TMP%\WinUpResetLog.txt 
Regsvr32.exe /s oleaut32.dll 2>>%TMP%\WinUpResetLog.txt
Regsvr32.exe /s ole32.dll    2>>%TMP%\WinUpResetLog.txt 
Regsvr32.exe /s shell32.dll  2>>%TMP%\WinUpResetLog.txt 
Regsvr32.exe /s qmgr.dll     2>>%TMP%\WinUpResetLog.txt
Regsvr32.exe /s qmgrprxy.dll 2>>%TMP%\WinUpResetLog.txt
Regsvr32.exe /s wucltux.dll  2>>%TMP%\WinUpResetLog.txt   
Regsvr32.exe /s wuwebv.dll   2>>%TMP%\WinUpResetLog.txt
Regsvr32.exe /s wudriver.dll 2>>%TMP%\WinUpResetLog.txt
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG1.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAPI.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\ATL.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUCLTUI.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUPS.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUPS2.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\IUENGINE.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUWEB.DLL /U /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAUENG1.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUAPI.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\ATL.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUCLTUI.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUPS.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\IUENGINE.DLL /S
REGSVR32 C:\WINDOWS\SYSTEM32\WUWEB.DLL /S
REGSVR32 VBSCRIPT.DLL /S
REGSVR32 JSCRIPT.DLL /S
REGSVR32 SCRRUN.DLL /S
REGSVR32 DISPEX.DLL /S
REGSVR32 MSSCRIPT.DLL /S
REGSVR32 SOFTPUB.DLL /S
REGSVR32 WINTRUST.DLL /S
REGSVR32 INITPKI.DLL /S
REGSVR32 URLMON.DLL /S
REGSVR32 DSSENH.DLL /S
REGSVR32 MSXML.DLL /S
REGSVR32 MSXML2.DLL /S
REGSVR32 MSXML3.DLL /S
REGSVR32 RSAENH.DLL /S
REGSVR32 GPKCSP.DLL /S
REGSVR32 SCCBASE.DLL /S
REGSVR32 SLBCSP.DLL /S
REGSVR32 CRYPTDLG.DLL /S
REGSVR32 MSSIP32.DLL /S 
Cls

    
Color 0A

Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...

Echo :: Reset Winsock Catalog to a clean state. >>%TMP%\WinUpResetLog.txt
    Netsh Winsock Reset 2>>%TMP%\WinUpResetLog.txt

Cls
Echo :: Resets portproxy configuration state. >>%TMP%\WinUpResetLog.txt
   Netsh int portproxy reset 2>>%TMP%\WinUpResetLog.txt

Cls
Echo :: Reset the IP HTTPS configurations. >>%TMP%\WinUpResetLog.txt
Netsh int httpstunnel reset 2>>%TMP%\WinUpResetLog.txt



  


Cls
Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...

Echo :: Run Next command for Windows Vista and later versions of Windows OS's. >>%TMP%\WinUpResetLog.txt
For /f "tokens=2 delims=[]" %%a in ('ver') do (set Version=%%a)
Set Version=%Version:~8,2% 
If Not %Version%==5 (

Echo :: Below command executed for Windows Vista and later versions of Windows OS. >>%TMP%\WinUpResetLog.txt
Echo :: Cancels all jobs in the transfer queue that the all users owns.. >>%TMP%\WinUpResetLog.txt
    Bitsadmin.exe /reset /allusers 2>>%TMP%\WinUpResetLog.txt
    Ipconfig /flushdns 2>>%TMP%\WinUpResetLog.txt
    Cls

Echo :: If you are running versions of Windows OS other then Windows XP OS type below Netsh command to reset proxy settings. >>%TMP%\WinUpResetLog.txt
    Netsh Winhttp Reset Proxy 2>>%TMP%\WinUpResetLog.txt
)




Cls
Echo.
Echo                      RESETING WINDOWS UPDATE COMPONENTS
Echo.
Echo.
Echo                                PLEASE WAIT...

Echo :: Restart the BITS service, the Windows Update service, and the Cryptographic service. >>%TMP%\WinUpResetLog.txt
    Net start bits         2>>%TMP%\WinUpResetLog.txt
    Net start wuauserv     2>>%TMP%\WinUpResetLog.txt
    Net start appidsvc     2>>%TMP%\WinUpResetLog.txt
    Net start cryptsvc     2>>%TMP%\WinUpResetLog.txt
    Net start EventSystem  2>>%TMP%\WinUpResetLog.txt
    Net start RpcLocator   2>>%TMP%\WinUpResetLog.txt
    Net start RpcSs        2>>%TMP%\WinUpResetLog.txt
    Net start RpcEptMapper 2>>%TMP%\WinUpResetLog.txt
    Net start DcomLaunch   2>>%TMP%\WinUpResetLog.txt
    Sc config BITS start= Auto         2>>%TMP%\WinUpResetLog.txt
    Sc config wuauserv start= Auto     2>>%TMP%\WinUpResetLog.txt
    Sc config AppIDSvc start= demand   2>>%TMP%\WinUpResetLog.txt
    Sc config cryptsvc start= Auto     2>>%TMP%\WinUpResetLog.txt
    Sc config EventSystem start= Auto  2>>%TMP%\WinUpResetLog.txt
    Sc config RpcLocator start= demand 2>>%TMP%\WinUpResetLog.txt
    
:: Check version of the Windows OS.
Reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v ProductName | find /i "Windows XP" >Nul
If Not Errorlevel 1 Goto :Reboot
    
Echo :: Rebooting >>%TMP%\WinUpResetLog.txt
Mode CON  LINES=5 COLS=48 
Cls
Echo.
Echo.
Echo.
Echo.
Echo              DO YOU WANT TO REBOOT
Echo.
Echo.
                              

Cd %~dp0

Echo :: Copying %TMP%\WinUpResetLog.txt to %UserProfile%\Desktop folder. >>%TMP%\WinUpResetLog.txt
If Exist %TMP%\WinUpResetLog.txt Copy %TMP%\WinUpResetLog.txt %UserProfile%\Desktop 2>>%TMP%\WinUpResetLog.txt
If Exist %TMP%\WinUpResetLog.txt Del %TMP%\WinUpResetLog.txt
Goto :Reboot


:IsAdmin
Reg query "HKU\S-1-5-19\Environment"
If Not %ERRORLEVEL% EQU 0 (
 Cls & Mode CON  LINES=5 COLS=48 & Color 0C & Title - WARNING -
 Echo.
 Echo. 
 Echo  YOU MUST HAVE ADMINISTRATOR RIGHTS TO CONTINUE 
 Pause >Nul & Exit
)
Cls
Goto :EOF

:Reboot
Cls & Mode CON  LINES=11 COLS=42 & Color 0E & Title FreeBooter 
Echo.
Echo.
Echo    THIS COMPUTER WILL REBOOT 
Echo.
Echo.
Echo    PLEASE SAVE ALL WORK IN PROGRESS
Echo. 
Echo.
Echo    PRESS 'ENTER' KEY TO RESTART COMPUTER
Pause >Nul

Shutdown  -r  -t 0  -c "REBOOTING SYSTEM" 2>&1 > Nul
