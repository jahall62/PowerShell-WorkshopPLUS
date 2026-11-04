<#
    M13 - Remoting Basics
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
    Run on the lab machine WIN10, with MS and DC reachable. Nothing here runs on a standalone laptop.
    Run the entire Setup region with F8 first, then the slides, then the entire Cleanup region.
    Use the same Windows PowerShell 5.1 session for all three; cleanup state is held in memory.
    Setup checks WinRM on MS and DC and creates C:\MyScript.ps1 for slide 17.
    Cleanup closes the sessions the demo opened and deletes C:\MyScript.ps1.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Setup - Run this entire region first
& {
    $ErrorActionPreference = 'Stop'
    if ($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.PSVersion -lt [version]'5.1') {
        throw 'Use Windows PowerShell 5.1 (powershell.exe), preferably the ISE, for this demo.'
    }
    if (Test-Path -LiteralPath Variable:\M13DemoState) {
        throw 'Demo state already exists. Run the entire Cleanup region before running Setup again.'
    }
    if ($env:COMPUTERNAME -ne 'WIN10') {
        Write-Warning "This is $env:COMPUTERNAME. The demos expect the lab machine WIN10."
    }
    foreach ($target in 'MS', 'DC') {
        try {
            Test-WSMan -ComputerName $target | Out-Null
            Write-Host "$target answers on WinRM (port 5985)" -ForegroundColor Cyan
        }
        catch {
            Write-Warning "$target does not answer on WinRM: the slides that target it will fail."
        }
    }
    $admin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole('Administrators')
    if (-not $admin) {
        Write-Warning 'Not elevated: on slide 15 the Win10 target (this machine) errors; MS and DC still answer.'
    }
    $global:M13DemoState = @{
        ScriptCreated = -not (Test-Path -LiteralPath C:\MyScript.ps1)
        SessionIds = @(Get-PSSession | ForEach-Object Id)
        Variables = 'Session', 'Creds', 'localSvc', 'remoteSvc'
    }
    if ($M13DemoState.ScriptCreated) {
        try {
            Set-Content -LiteralPath C:\MyScript.ps1 -Value 'Get-Culture'
        }
        catch {
            $M13DemoState.ScriptCreated = $false
            Write-Warning 'Could not create C:\MyScript.ps1 (writing to C:\ needs an elevated session). Slide 17 will fail.'
        }
    }
    else {
        Write-Warning 'C:\MyScript.ps1 already exists: slide 17 runs whatever it contains. Setup left it unchanged.'
    }
    Write-Host 'Setup complete. Run the slides, then Cleanup in this same session.' -ForegroundColor Green
}
#endregion

#region Slide 10 - Types of Remoting
Get-Command -ParameterName ComputerName -Module Microsoft.PowerShell.Management
#endregion

#region Slide 11 - Native OS Remoting
# Windows PowerShell 5.1 only: uses RPC, not WinRM. PowerShell 7 removed -ComputerName from Get-Service
Get-Service -Computername DC
#endregion

#region Slide 14 - Enter-PSSession
# Run one line at a time: in a multi-line F8 selection, the lines after Enter-PSSession still run locally
$env:COMPUTERNAME
Enter-PSSession -ComputerName MS
$env:COMPUTERNAME
Exit-PSSession
$env:COMPUTERNAME
#endregion

#region Slide 15 - Invoke-Command
# Win10 is this machine (loopback): it needs remoting enabled and an elevated session, or that one target errors
Invoke-Command -ComputerName MS,DC,Win10 -ScriptBlock {Get-Culture}
#endregion

#region Slide 16 - Using Alternate Credentials
# Prompts for the CONTOSO\Administrator password
Invoke-Command -ComputerName MS -ScriptBlock {$env:USERNAME} -Credential CONTOSO\Administrator
# Opens a credential dialog; the credential is kept in $Creds for the next line
$Creds = Get-Credential
Invoke-Command -ComputerName MS -ScriptBlock {$env:USERNAME} -Credential $Creds
#endregion

#region Slide 17 - Invoke-Command with Script Files
# C:\MyScript.ps1 is read here on WIN10 (Setup created it); its contents run on MS and DC
Invoke-Command -ComputerName MS, DC -FilePath C:\MyScript.ps1
#endregion

#region Slide 18 - Data Serialization
Invoke-Command -ComputerName MS -ScriptBlock {Get-Service} | GM
#endregion

#region Slide 19 - Demonstration: Enter-PSSession and Invoke-Command
# Lab only: run on WIN10 with remoting to MS (and DC). Run the Enter-PSSession lines one at a time
$env:COMPUTERNAME
$env:USERNAME
Enter-PSSession -ComputerName MS
$env:COMPUTERNAME
$env:USERNAME
Get-Date
Get-Service | Select-Object -First 5
Exit-PSSession
$env:COMPUTERNAME

Invoke-Command -ComputerName MS -ScriptBlock { $env:COMPUTERNAME }
Invoke-Command -ComputerName MS,DC -ScriptBlock { $env:COMPUTERNAME }
Invoke-Command -ComputerName MS,DC -ScriptBlock { Get-Culture } | Select-Object PSComputerName, Name, DisplayName

$localSvc = Get-Service | Select-Object -First 1
$localSvc | Get-Member
$remoteSvc = Invoke-Command -ComputerName MS -ScriptBlock { Get-Service | Select-Object -First 1 }
$remoteSvc | Get-Member
$localSvc.PSObject.TypeNames | Select-Object -First 1
$remoteSvc.PSObject.TypeNames | Select-Object -First 1

Invoke-Command -ComputerName MS -ScriptBlock {
    $svc = Get-Service -Name 'Spooler'
    $svc.Status
    Stop-Service -Name 'Spooler' -WhatIf
}
#endregion

#region Slide 21 - Using Persistent Sessions
$Session = New-PSSession -ComputerName MS
Invoke-Command -Session $Session -ScriptBlock {$Var = 123}
Invoke-Command -Session $Session -ScriptBlock {$Var}
#endregion

#region Slide 22 - Demonstration: Using Persistent Sessions
# Lab only: run on WIN10 with remoting to MS. Run the Enter-PSSession lines one at a time
# $session is the same variable as slide 21's $Session (names aren't case-sensitive); Cleanup closes both sessions
$session = New-PSSession -ComputerName MS
$session | Format-List Id, ComputerName, State, Availability
Enter-PSSession -Session $session
$env:COMPUTERNAME
$env:USERNAME
$service = Get-Service -Name BITS
$service.Name
$service.Status
Exit-PSSession

Enter-PSSession -Session $session
$service
$service.Status
Exit-PSSession

Get-PSSession
Remove-PSSession -Session $session
Get-PSSession
#endregion

#region Cleanup - Run this entire region after the demo, even if a slide failed
& {
    if (-not (Test-Path -LiteralPath Variable:\M13DemoState)) {
        Write-Warning 'No demo state found. If the prompt starts with [MS], run Exit-PSSession first; otherwise run Setup first.'
        return
    }
    Get-PSSession | Where-Object { $_.Id -notin $M13DemoState.SessionIds } | Remove-PSSession
    if ($M13DemoState.ScriptCreated -and (Test-Path -LiteralPath C:\MyScript.ps1)) {
        Remove-Item -LiteralPath C:\MyScript.ps1
    }
    Remove-Variable -Name $M13DemoState.Variables -Scope Global -ErrorAction SilentlyContinue
    Remove-Variable -Name M13DemoState -Scope Global
    Write-Host 'Cleanup complete. Demo sessions closed and C:\MyScript.ps1 removed.' -ForegroundColor Green
}
#endregion
