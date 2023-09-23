net stop CryptSvc /y
rename c:\windows\system32\catroot2 Catroot2.bak
net start CryptSvc
pause