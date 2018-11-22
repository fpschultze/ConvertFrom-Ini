# ConvertFrom-Ini
PowerShell function that returns the contents of a given ini file as pscustomobjects for further processing
(The function is based on ideas that I've found here: https://www.petri.com/managing-ini-files-with-powershell)

Usage is as simple as...

PS C:\> cat Get-Content $env:windir\win.ini
; for 16-bit app support
[fonts]
[extensions]
[mci extensions]
[files]
[Mail]
MAPI=1
CMCDLLNAME32=mapi32.dll
CMC=1
MAPIX=1
MAPIXVER=1.0.0.1
OLEMessaging=1
PS C:\> $ini = Get-Content $env:windir\win.ini | ConvertFrom-Ini
PS C:\> $ini.Mail


MAPI         : 1
CMCDLLNAME32 : mapi32.dll
CMC          : 1
MAPIX        : 1
MAPIXVER     : 1.0.0.1
OLEMessaging : 1

PS C:\>

