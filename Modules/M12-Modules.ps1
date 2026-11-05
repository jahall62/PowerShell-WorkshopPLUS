<#
    M12 - Modules
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
    Run the entire Setup region with F8 first, then the slides, then the entire Cleanup region.
    Use the same Windows PowerShell 5.1 session for all three; cleanup state is held in memory.
    Setup unloads the demo modules (so autoloading is visible) and creates C:\MyModule\MyModule.psm1 for slide 15.
    Cleanup unloads them again, deletes what the demo created, and restores the autoloading preference.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Setup - Run this entire region first
& {
    $ErrorActionPreference = 'Stop'
    if ($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.PSVersion -lt [version]'5.1') {
        throw 'Use Windows PowerShell 5.1 (powershell.exe), preferably the ISE, for this demo.'
    }
    if (Test-Path -LiteralPath Variable:\M12DemoState) {
        throw 'Demo state already exists. Run the entire Cleanup region before running Setup again.'
    }
    $demoFolder = Join-Path -Path ($env:PSModulePath -split ';')[0] -ChildPath 'MyDemoModule'
    if (Test-Path -LiteralPath $demoFolder) {
        throw "$demoFolder already exists. Slide 16 creates and deletes it; move it aside first."
    }
    $psm1 = "function Get-CustomHello {`r`n    'Hello World!'`r`n}"
    if ((Test-Path -LiteralPath C:\MyModule\MyModule.psm1) -and
        (Get-Content -LiteralPath C:\MyModule\MyModule.psm1 -Raw).Trim() -ne $psm1) {
        throw 'C:\MyModule\MyModule.psm1 exists and is not the demo file. Move it aside first.'
    }
    $autoload = Get-Variable -Name PSModuleAutoLoadingPreference -Scope Global -ErrorAction SilentlyContinue
    $global:M12DemoState = @{
        MyModuleCreated = -not (Test-Path -LiteralPath C:\MyModule)
        DemoFolder = $demoFolder
        AutoLoading = if ($autoload) { $autoload.Value } else { $null }
        ProcessPolicy = Get-ExecutionPolicy -Scope Process
        ProfilerInstalled = [bool](Get-Module -Name PSProfiler -ListAvailable)
        Modules = 'BitLocker', 'ScheduledTasks', 'PSScheduledJob', 'Pester', 'MyModule', 'MyDemoModule', 'PSProfiler'
    }
    $global:PSModuleAutoLoadingPreference = 'All'
    $repos = @(Get-PSRepository).Name
    # Get-PSRepository just loaded the PowerShellGet that Install-Module will use on slide 16
    $psget = (Get-Module -Name PowerShellGet).Version
    # Unload so slide 7 shows BitLocker arriving and slide 10's deliberate failures really fail.
    # PowerShellGet and PackageManagement were just loaded by Get-PSRepository; unload them so Get-Module matches the slide
    Remove-Module -Name ($M12DemoState.Modules + 'PowerShellGet', 'PackageManagement') -ErrorAction SilentlyContinue
    New-Item -Path C:\MyModule -ItemType Directory -Force | Out-Null
    Set-Content -LiteralPath C:\MyModule\MyModule.psm1 -Value $psm1 -Encoding UTF8
    # A .psm1 is a script: Import-Module obeys the execution policy
    if ((Get-ExecutionPolicy) -in 'Restricted', 'AllSigned') {
        Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned -Force
        Write-Host 'Execution policy set to RemoteSigned for this session only' -ForegroundColor Cyan
    }
    $pester = (Get-Module -Name Pester -ListAvailable).Version -join ', '
    Write-Host "Pester versions installed: $pester (the slide shows 5.0.3, 4.8.0, 3.4.0)" -ForegroundColor Cyan
    if ($M12DemoState.ProfilerInstalled) {
        Write-Warning 'PSProfiler is already installed. Slide 16 removes and uninstalls it.'
    }
    if ('PSGallery' -notin $repos) {
        Write-Warning "PSGallery isn't registered here. Find-Module and Install-Module will use: $($repos -join ', ')"
    }
    if ($psget -lt [version]'2.0') {
        Write-Warning ("PowerShellGet $psget installs PSProfiler into a 1.0.5 folder, but its manifest says 1.0.5.0, so 5.1 won't import it. " +
            'To fix: run Cleanup, run Install-Module PowerShellGet -Scope CurrentUser -Force, then rerun Setup in a new session.')
    }
    $admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')
    if (-not $admin) {
        Write-Warning 'Not elevated: skip the manual-install lines on slide 16 (Program Files needs admin).'
    }
    Write-Host 'Setup complete. Run the slides, then Cleanup in this same session.' -ForegroundColor Green
}
#endregion

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
# -Version is a minimum: this loads the newest Pester at 4.8.0 or later. Fails if only the built-in 3.4.0 is installed
Import-Module Pester -Version 4.8.0
Get-Module Pester
Remove-Module Pester
# -RequiredVersion loads exactly that version; 3.4.0 ships with Windows
Import-Module Pester -RequiredVersion 3.4.0
Get-Module Pester
Remove-Module Pester
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
# Setup created C:\MyModule\MyModule.psm1 with one function, Get-CustomHello
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
# May prompt to install the NuGet provider, then to trust PSGallery (untrusted by default): answer Y
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

#region Cleanup - Run this entire region after the demo, even if a slide failed
& {
    if (-not (Test-Path -LiteralPath Variable:\M12DemoState)) {
        Write-Warning 'No demo state found. Run Setup first, or this session was already cleaned up.'
        return
    }
    Remove-Module -Name $M12DemoState.Modules -ErrorAction SilentlyContinue
    if ($M12DemoState.MyModuleCreated -and (Test-Path -LiteralPath C:\MyModule)) {
        Remove-Item -LiteralPath C:\MyModule -Recurse
    }
    elseif (Test-Path -LiteralPath C:\MyModule\MyModule.psm1) {
        Remove-Item -LiteralPath C:\MyModule\MyModule.psm1
    }
    if (Test-Path -LiteralPath $M12DemoState.DemoFolder) {
        Remove-Item -LiteralPath $M12DemoState.DemoFolder -Recurse
    }
    if (-not $M12DemoState.ProfilerInstalled) {
        if (Get-InstalledModule -Name PSProfiler -ErrorAction SilentlyContinue) {
            Uninstall-Module -Name PSProfiler -AllVersions
        }
        if (Test-Path -LiteralPath 'C:\Program Files\WindowsPowerShell\Modules\PSProfiler') {
            Write-Warning 'C:\Program Files\WindowsPowerShell\Modules\PSProfiler is still there: delete it from an elevated session.'
        }
    }
    if ($null -eq $M12DemoState.AutoLoading) {
        Remove-Variable -Name PSModuleAutoLoadingPreference -Scope Global -ErrorAction SilentlyContinue
    }
    else {
        $global:PSModuleAutoLoadingPreference = $M12DemoState.AutoLoading
    }
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy $M12DemoState.ProcessPolicy -Force
    Remove-Variable -Name Folder -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable -Name M12DemoState -Scope Global
    Write-Host 'Cleanup complete. Demo modules unloaded and removed, autoloading preference restored.' -ForegroundColor Green
}
#endregion
