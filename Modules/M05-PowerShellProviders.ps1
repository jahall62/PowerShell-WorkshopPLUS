<#
    M05 - PowerShell Providers
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 11 - Exploring Providers
Get-PsProvider
#endregion

#region Slide 13 - Navigating between provider and Paths
Set-Location C:\Windows
Set-Location HKLM:\Software
Set-Location Cert:\LocalMachine
Set-Location Env:\
#endregion

#region Slide 15 - Creating New Drives (mounting to new root)
New-PSDrive -Name MyDocs -PSProvider FileSystem -Root $Home
#endregion

#region Slide 15 - Demonstration: Creating and using a new drive
New-PSDrive -Name MyDocs -PSProvider FileSystem -Root $Home
Set-Location MyDocs:
Get-Location
Set-Location C:\
Remove-PSDrive -Name MyDocs
#endregion

#region Slide 16 - Non-Hierarchical Providers
# $<DriveName>:<ItemName>
$Env:COMPUTERNAME
$Alias:Dir
#endregion

#region Slide 16 - Demonstration: Reading non-hierarchical providers
$Env:COMPUTERNAME
(Get-Item -Path Env:\COMPUTERNAME).Value
[System.Environment]::GetEnvironmentVariable('ComputerName')
dir env:
$env:Windir
$env:ProgramData
$env:APPDATA
[enum]::GetNames([System.EnvironmentVariableTarget])
$Variable:false
Get-ChildItem -Path Variable:
$Alias:Dir
${Function:C:}
Get-Command -Name C:
#endregion

#region Slide 19 - Demonstration: Registry values (HKCU test key)
if (-not (Test-Path HKCU:\Software\WorkshopDemo)) { New-Item -Path HKCU:\Software\WorkshopDemo | Out-Null }
Set-Location HKCU:\Software\WorkshopDemo
New-ItemProperty -Path . -Name 'DemoSetting' -Value 'Enabled' -PropertyType String
Get-ItemProperty -Path .
Get-ItemPropertyValue -Path . -Name DemoSetting
Set-ItemProperty -Path . -Name 'DemoSetting' -Value 'Disabled'
Get-ItemPropertyValue -Path . -Name DemoSetting
Remove-ItemProperty -Path . -Name 'DemoSetting'
Set-Location C:\
Remove-Item -Path HKCU:\Software\WorkshopDemo -Recurse
# Reading HKLM works as a standard user
(Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion).ProgramFilesDir
#endregion

#region Slide 20 - Demonstration: Creating and removing items
if (-not (Test-Path HKCU:\Software\WorkshopDemo)) { New-Item -Path HKCU:\Software\WorkshopDemo | Out-Null }
New-Item -Path HKCU:\Software\WorkshopDemo\Child
New-Item -Path $env:TEMP -Name demo.txt -ItemType File -Value 'hi'
Get-Item -Path HKCU:\Software\WorkshopDemo
Set-Item -Path Env:\WORKSHOP -Value 'hello'
$Env:WORKSHOP
Remove-Item -Path Env:\WORKSHOP
Remove-Item -Path HKCU:\Software\WorkshopDemo -Recurse -WhatIf
Remove-Item -Path HKCU:\Software\WorkshopDemo -Recurse
Remove-Item -Path $env:TEMP\demo.txt
#endregion

#region Slide 21 - Demonstration: PowerShell providers and drives
Get-PSProvider
Get-PSDrive
Set-Location HKLM:\Software
dir
Set-Location Cert:\LocalMachine\My
dir
Set-Location Env:
dir
Get-ChildItem -Path Cert:\LocalMachine\Root -ExpiringInDays 30
Set-Location HKLM:\Software
# Fails on purpose: -File exists only in the FileSystem provider
Get-ChildItem -File
Set-Location C:\Windows
Get-ChildItem -File
New-PSDrive -Name MyDocs -PSProvider FileSystem -Root $Home
Set-Location MyDocs:
Set-Location C:\
Remove-PSDrive -Name MyDocs
$Env:COMPUTERNAME
$Alias:dir
${Function:C:}
if (-not (Test-Path HKCU:\Software\WorkshopDemo)) { New-Item -Path HKCU:\Software\WorkshopDemo | Out-Null }
Set-Location HKCU:\Software\WorkshopDemo
New-ItemProperty -Path . -Name 'DemoSetting' -Value 'Enabled' -PropertyType String
Get-ItemPropertyValue -Path . -Name DemoSetting
Set-ItemProperty -Path . -Name 'DemoSetting' -Value 'Disabled'
Get-ItemPropertyValue -Path . -Name DemoSetting
Set-Location C:\
Remove-Item -Path HKCU:\Software\WorkshopDemo -Recurse
#endregion
