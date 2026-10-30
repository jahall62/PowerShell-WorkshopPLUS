<#
    M10 - Scripts
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 6 - Simple Script Example
Write-Host 'Start of script' -BackgroundColor Green
Write-Host 'Display the % CPU Time utilization by the ISE' -BackgroundColor Green
Get-Counter '\Process(powershell_ise)\% Processor Time'
C:\scripts\Sample.ps1
#endregion

#region Slide 8 - Running Powershell Scripts
c:\scripts\script.ps1
.\script.ps1
& 'c:\scripts\my script.ps1'
Script.ps1
#endregion

#region Slide 9 - Script Parameters
.\ScriptParamExample.ps1 -ComputerName localhost
.\ScriptParamExample.ps1 -ComputerName DoesNotExist
#endregion

#region Slide 15 - Setting / Determining Execution Policy
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
Get-ExecutionPolicy -List
Get-ExecutionPolicy
#endregion

#region Slide 19 - Certificates
New-SelfSignedCertificate -Subject 'CN=PS Code Signing Cert' -Type 'CodeSigning' -CertStoreLocation 'Cert:\CurrentUser\My'
$cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert
Export-Certificate -FilePath PowerShell_Cert.cer -Cert $Cert
Import-Certificate -FilePath PowerShell_Cert.cer -CertStoreLocation Cert:\LocalMachine\Root
Import-Certificate -FilePath PowerShell_Cert.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
#endregion

#region Slide 20 - Signing a script
.\Temp.ps1
$cert = Get-ChildItem -Path Cert:\CurrentUser\My -CodeSigningCert
Set-AuthenticodeSignature -FilePath .\temp.ps1 -Certificate $cert
#endregion

#region Slide 21 - Script After Signing
Write-Host 'Start of script' -BackgroundColor Green
Write-Host 'Display the % CPU Time utilization by the ISE' -BackgroundColor Green
Get-Counter '\Process(powershell_ise)\% Processor Time'
#endregion

#region Slide 23 - Review - Comments
param ($Computername)
<#
    This is a block comment
    Testing connectivity to remote computers
    Write Boolean output in Green
#>
$result = Test-Connection -ComputerName $Computername -Quiet -Count 1
# This is a single line comment
Write-Host $result -ForegroundColor Green # Inline comment
#endregion

#region Slide 24 - Requires Statement
# #Requires -Version <N>[.<n>]
# #Requires -Modules { <Module-Name> | <Hashtable> }
# #Requires -PSEdition <Core or Desktop>
# #Requires -RunAsAdministrator
# #Requires -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
# #Requires -ShellId <ShellId> -PSSnapin <PSSnapin-Name> [-Version <N>[.<n>]]
#endregion

#region Slide 25 - Requires Statement - Examples
# #requires -Version 3
Get-ChildItem c:\ -Hidden
# #requires -RunAsAdministrator
Get-ChildItem c:\ -Hidden
#endregion

#region Slide 29 - Alias Overriding External Command
ping MS
New-Alias -Name ping -Value Test-Connection
ping MS
#endregion

#region Slide 30 - Module Qualify Command Name
#Run normal cmdlet
Get-Process System
#Create function with same name
Function Get-Process {"This isn't the Get-Process cmdlet"}
#Command precedence runs function instead of Cmdlet
Get-Process
#Module qualify command name
Microsoft.PowerShell.Management\Get-Process -Name System
#endregion
