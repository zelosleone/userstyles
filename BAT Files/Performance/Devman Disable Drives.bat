echo Disabling Devices

:: Install DevManView
powershell Invoke-WebRequest "https://cdn.discordapp.com/attachments/968692091716792401/1153350452080037998/DevManView.exe" -OutFile "C:\Windows\System32\DevManView.exe"

:: Disable Devices through DevManView
devmanview /disable "High Precision Event Timer"
devmanview /disable "Microsoft GS Wavetable Synth"
devmanview /disable "Microsoft RRAS Root Enumerator"
devmanview /disable "Intel Management Engine"
devmanview /disable "Intel Management Engine Interface"
devmanview /disable "Intel SMBus"
devmanview /disable "SM Bus Controller"
devmanview /disable "Composite Bus Enumerator"
devmanview /disable "Microsoft Virtual Drive Enumerator"
devmanview /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"
devmanview /disable "NDIS Virtual Network Adapter Enumerator"
devmanview /disable "Remote Desktop Device Redirector Bus"
devmanview /disable "UMBus Root Bus Enumerator"
devmanview /disable "WAN Miniport (IP)"
devmanview /disable "WAN Miniport (IKEv2)"
devmanview /disable "WAN Miniport (IPv6)"
devmanview /disable "WAN Miniport (L2TP)"
devmanview /disable "WAN Miniport (PPPOE)"
devmanview /disable "WAN Miniport (PPTP)"
devmanview /disable "WAN Miniport (SSTP)"
devmanview /disable "WAN Miniport (Network Monitor)"
pause