<#
    M12 - Modules
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 6 - Using Modules
Get-Module
(Get-module -ListAvailable).count
#endregion

#region Slide 7 - Module Autoloading - Example
Get-Module
(Get-Command -Module BitLocker).Name
Get-Module
#endregion

#region Slide 8 - Browsing Module Commands
Get-Command -Module BitLocker | Select-Object CommandType, Name
#endregion

#region Slide 9 - Explicitly Importing Modules
Get-Module Pester -ListAvailable
Import-Module Pester -Version 4.8.0
#endregion

#region Slide 10 - Demonstration: Module auto-loading and explicitly importing modules
# Windows PowerShell 5.1 only: PSScheduledJob is blocked in PowerShell 7
$env:PSModulePath -split ';'
Get-Module -ListAvailable
# Loads the core modules first, so 'None' doesn't break basic commands
Get-ChildItem | Out-Null
$PSModuleAutoLoadingPreference = 'None'
# Fails on purpose: autoloading is off
Get-ScheduledTask
$PSModuleAutoLoadingPreference = 'All'
Get-ScheduledTask
$PSModuleAutoLoadingPreference = 'None'
# Fails on purpose
New-JobTrigger -Once -At '2026-12-01 08:00'
Import-Module PSScheduledJob
New-JobTrigger -Once -At '2026-12-01 08:00'
$PSModuleAutoLoadingPreference = 'All'
#endregion

#region Slide 15 - Creating Custom Modules
Import-Module -Name C:\MyModule\MyModule.psm1
Get-Module
Get-CustomHello
#endregion

#region Slide 16 - Demonstration: Installing modules manually and via the PowerShell Gallery
# Manual install. Needs an elevated session. First download the zip from https://github.com/IISResetMe/PSProfiler,
# create C:\Program Files\WindowsPowerShell\Modules\PSProfiler and copy the contents of the zip's src folder into it
Get-ChildItem 'C:\Program Files\WindowsPowerShell\Modules\PSProfiler' -Recurse | ForEach-Object { Unblock-File $_.FullName }
Import-Module PSProfiler
Get-Command -Module PSProfiler
Remove-Module PSProfiler
# Needs an elevated session
Remove-Item -Path 'C:\Program Files\WindowsPowerShell\Modules\PSProfiler' -Recurse -Force

# PowerShell Gallery. Needs internet access
Find-Module PSProfiler
Install-Module PSProfiler -Scope CurrentUser
Import-Module PSProfiler
Get-Command -Module PSProfiler
Remove-Module PSProfiler
Uninstall-Module PSProfiler

# Custom module (psm1 + psd1) in the first folder on $env:PSModulePath
$Folder = Join-Path -Path ($env:PSModulePath -split ';')[0] -ChildPath 'MyDemoModule'
New-Item -Path $Folder -ItemType Directory -Force | Out-Null
Set-Content -Path "$Folder\MyDemoModule.psm1" -Value "function Get-DemoMessage { 'Hello from my custom module!' }"
New-ModuleManifest -Path "$Folder\MyDemoModule.psd1" -RootModule 'MyDemoModule.psm1' -ModuleVersion '1.0.0' -Description 'Demo module created during workshop' -Author 'Workshop Demo' -FunctionsToExport 'Get-DemoMessage'
Import-Module MyDemoModule
Get-Module MyDemoModule
Get-DemoMessage
Remove-Module MyDemoModule
Remove-Item -Path $Folder -Recurse
#endregion
