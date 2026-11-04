<#
    M11 - Functions
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
    Run the entire Setup region with F8 first, then the slides, then the entire Cleanup region.
    Use the same Windows PowerShell 5.1 session for all three; cleanup state is held in memory.
    Setup works in C:\PSDemo (slide 8 writes Log.txt there); cleanup removes the demo functions,
    the ScriptBlock variable and Log.txt, and returns to the original location.
    The slide 10 region needs PowerShell 7.3 or later: in 5.1 it shows parse errors. F8 on any other region still works.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Setup - Run this entire region first
& {
    $ErrorActionPreference = 'Stop'
    if ($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.PSVersion -lt [version]'5.1') {
        throw 'Use Windows PowerShell 5.1 (powershell.exe), preferably the ISE, for this demo.'
    }
    if (Test-Path -LiteralPath Variable:\M11DemoState) {
        throw 'Demo state already exists. Run the entire Cleanup region before running Setup again.'
    }
    $functions = 'Write-Statement', 'Write-ServiceStatus', 'My-Function', 'Write-Green', 'Get-SomeService'
    foreach ($name in $functions) {
        if (Test-Path -LiteralPath "Function:\$name") {
            Remove-Item -LiteralPath "Function:\$name"
            Write-Host "Removed $name left over from an earlier run" -ForegroundColor Yellow
        }
    }
    $global:M11DemoState = @{
        Directory = 'C:\PSDemo'
        DirectoryCreated = -not (Test-Path -LiteralPath C:\PSDemo)
        LogCreated = -not (Test-Path -LiteralPath C:\PSDemo\Log.txt)
        OriginalLocation = Get-Location
        Functions = $functions
    }
    New-Item -Path $M11DemoState.Directory -ItemType Directory -Force | Out-Null
    # Slide 8's Begin block deletes Log.txt, so give it one to delete on the first run
    if ($M11DemoState.LogCreated) {
        New-Item -Path C:\PSDemo\Log.txt -ItemType File | Out-Null
    }
    Set-Location -LiteralPath $M11DemoState.Directory
    $svc = Get-Service -Name WinRM
    Write-Host "WinRM is $($svc.Status) here; the slides show Stopped" -ForegroundColor Cyan
    Write-Host 'Setup complete. Run the slides, then Cleanup in this same session.' -ForegroundColor Green
}
#endregion

#region Slide 6 - What Does a Function Look Like?
Function Write-Statement
{
  Write-Host "Hello world!" -ForegroundColor Green
}
Write-Statement
#endregion

#region Slide 7 - Creating a Function
Function Write-ServiceStatus
{
  $SVC = Get-Service -Name WinRM
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is currently $Status" -ForegroundColor Green
}
Write-ServiceStatus
#endregion

#region Slide 8 - Named Blocks in Functions
# The slide shows the call first; here the function is defined first so the region runs top to bottom
# Notepad opens with the five event messages; close it before the next run
Function My-Function
{
  Begin
  {
    Remove-Item .\Log.txt
    Write-Host "Start" -ForegroundColor Green
  }
  Process
  {
    $_.Message | Out-File -Filepath Log.txt -Append
  }
  End
  {
    Write-Host "End" -ForegroundColor Red
    notepad.exe Log.txt
  }
}
Get-EventLog -LogName Application -Newest 5 | My-Function
#endregion

#region Slide 9 - Clean block - before
# Shown, not run: Connect-ExchangeOnline needs the ExchangeOnlineManagement module and a tenant
Function My-Function
{
  Begin
  {
    Connect-ExchangeOnline
  }
  Process
  {
    Get-mailbox -ResultSize Unlimited |
    Out-File -Filepath Log.txt
  }
  End
  {
    Write-Host "End" -ForegroundColor Green
    notepad.exe Log.txt
    Disconnect-ExchangeOnline
  }
}
#endregion

#region Slide 10 - Clean block - better
# Shown, not run: the clean block needs PowerShell 7.3 or later. Windows PowerShell 5.1 can't parse this region
Function My-Function
{
  Begin
  {
    Connect-ExchangeOnline
  }
  Process
  {
    Get-mailbox -ResultSize Unlimited |
    Out-File -Filepath Log.txt
  }
  End
  {
    Write-Host "End" -ForegroundColor Green
    notepad.exe Log.txt
  }
  clean
    {
    Disconnect-ExchangeOnline
  }
}
#endregion

#region Slide 11 - Demonstration: Simple Function
Function Write-Statement
{
  Write-Host "Hello world!" -ForegroundColor Green
}
Write-Statement

Function Write-ServiceStatus
{
  $SVC = Get-Service -Name WinRM
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is currently $Status" -ForegroundColor Green
}
Write-ServiceStatus

Function Get-SomeService
{
  Get-Service -Name WinRM
}
Get-SomeService
#endregion

#region Slide 14 - Add Parameters to a Function
Function Write-Statement
{
  Param($Statement)
  Write-Host $Statement -ForegroundColor Green
}
Write-Statement -Statement 'Hello World!'
#endregion

#region Slide 15 - Default Parameter Values
Function Write-Green
{
  Param($Statement = 'Good morning!')
  Write-Host $Statement -ForegroundColor Green
}
Write-Green
# Works only because slide 14 already defined Write-Statement in this session
Write-Statement -Statement 'Hello World!'
#endregion

#region Slide 16 - Adding Multiple Parameters
Function Write-ServiceStatus
{
  Param ($ServiceName,
         $OutputColor = 'Green')
  $SVC = Get-Service -Name $ServiceName
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is '$Status'" -ForegroundColor $OutputColor
}
# -Color does not match $OutputColor: it lands in $args, so the text stays green (no error)
Write-ServiceStatus  -Service WinRM -Color Yellow
#endregion

#region Slide 17 - Demonstration: Parameters in Functions
Function Write-Statement
{
  Param($Statement)
  Write-Host $Statement -ForegroundColor Green
}
Write-Statement -Statement 'Hello World!'

Function Write-Green
{
  Param($Statement = 'Good morning!')
  Write-Host $Statement -ForegroundColor Green
}
Write-Green

Function Write-ServiceStatus
{
  Param ($ServiceName,
         $OutputColor = 'Green')
  $SVC = Get-Service -Name $ServiceName
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is '$Status'" -ForegroundColor $OutputColor
}
# -Color does not match $OutputColor, so the text stays green
Write-ServiceStatus -Service WinRM -Color Yellow

Function Write-ServiceStatus
{
  Param ($Service,
         $Color = 'Blue')
  $SVC = Get-Service -Name $Service
  Write-Host "The Service $($SVC.DisplayName) is currently $($SVC.Status)" -ForegroundColor $Color
}
# Same call, different parameter names: both bind this time
Write-ServiceStatus -Service WinRM -Color Green

Function Get-SomeService
{
  Param ($SVC)
  Get-Service -Name $SVC
}
Get-SomeService WinRM
#endregion

#region Slide 22 - Script Blocks
$ScriptBlock = {Get-Service -Name WinRM}
$ScriptBlock
#endregion

#region Slide 23 - Invoking Script Blocks
$ScriptBlock = { Get-Service -Name WinRM }
Invoke-Command -ScriptBlock $ScriptBlock
$ScriptBlock.Invoke()
#endregion

#region Slide 24 - Using Script Blocks
Measure-Command -Expression {Get-Process}
#endregion

#region Slide 25 - Demonstration: Script Blocks
Measure-Command -Expression {Get-Process}
Measure-Command -Expression {Get-Process}
$ScriptBlock = {Get-Service -Name WinRM}
$ScriptBlock
Invoke-Command -ScriptBlock $ScriptBlock
$ScriptBlock.Invoke()
& $ScriptBlock
# Optional: each of the next two can take up to a minute
Measure-Command { Get-ChildItem C:\Windows -Recurse -ErrorAction SilentlyContinue }
Measure-Command { Get-ChildItem C:\Windows -Recurse -Filter *.log -ErrorAction SilentlyContinue }
#endregion

#region Cleanup - Run this entire region after the demo, even if a slide failed
& {
    if (-not (Test-Path -LiteralPath Variable:\M11DemoState)) {
        Write-Warning 'No demo state found. Run Setup first, or this session was already cleaned up.'
        return
    }
    foreach ($name in $M11DemoState.Functions) {
        if (Test-Path -LiteralPath "Function:\$name") {
            Remove-Item -LiteralPath "Function:\$name"
        }
    }
    Remove-Variable -Name ScriptBlock -Scope Global -ErrorAction SilentlyContinue
    Set-Location -LiteralPath $M11DemoState.OriginalLocation.Path
    if ($M11DemoState.LogCreated -and (Test-Path -LiteralPath C:\PSDemo\Log.txt)) {
        Remove-Item -LiteralPath C:\PSDemo\Log.txt
    }
    if ($M11DemoState.DirectoryCreated -and (Test-Path -LiteralPath $M11DemoState.Directory) -and
        @(Get-ChildItem -LiteralPath $M11DemoState.Directory -Force).Count -eq 0) {
        Remove-Item -LiteralPath $M11DemoState.Directory
    }
    Remove-Variable -Name M11DemoState -Scope Global
    Write-Host 'Cleanup complete. Demo functions and Log.txt removed, original location restored.' -ForegroundColor Green
}
#endregion
