echo Applying BCD Tweaks
bcdedit /set useplatformclock No
bcdedit /set useplatformtick No
bcdedit /set disabledynamictick Yes
bcdedit /set tscsyncpolicy Enhanced
bcdedit /set isolatedcontext No
bcdedit /set vsmlaunchtype Off
bcdedit /set vm No
bcdedit /set configaccesspolicy Default
bcdedit /set usefirmwarepcisettings No
bcdedit /set pae ForceEnable
bcdedit /set highestmode Yes
bcdedit /set forcefipscrypto No
bcdedit /set uselegacyapicmode No
bcdedit /set ems No
bcdedit /set debug No
bcdedit /set hypervisorlaunchtype Off
pause