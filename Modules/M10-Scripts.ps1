<#
    M10 - Scripts
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
    Run the entire Setup region with F8 first, then the slides, then the entire Cleanup region.
    Use the same Windows PowerShell 5.1 session for all three; cleanup state is held in memory.
    Setup replaces the named demo files in C:\temp\Files; cleanup deletes those files.
    Unrelated files, certificates, and command customizations are preserved.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Setup - Run this entire region first
& {
    $ErrorActionPreference = 'Stop'
    if ($PSVersionTable.PSEdition -ne 'Desktop' -or $PSVersionTable.PSVersion -lt [version]'5.1') {
        throw 'Use Windows PowerShell 5.1 (powershell.exe), preferably the ISE, for this demo.'
    }
    if (Test-Path -LiteralPath Variable:\M10DemoState) {
        throw 'Demo state already exists. Run the entire Cleanup region before running Setup again.'
    }
    foreach ($scope in 'MachinePolicy', 'UserPolicy') {
        if ((Get-ExecutionPolicy -Scope $scope) -ne 'Undefined') {
            throw "$scope enforces an execution policy. Use an unmanaged lab session for this demo."
        }
    }
    Get-Command powershell.exe, ping.exe -CommandType Application | Out-Null
    Get-Command New-SelfSignedCertificate, Export-Certificate, Import-Certificate | Out-Null

    $bindings = @()
    foreach ($provider in 'Alias', 'Function') {
        foreach ($name in 'ping', 'Get-Process') {
            $path = "${provider}:\$name"
            if (Test-Path -LiteralPath $path) {
                $item = Get-Item -LiteralPath $path
                if ($item.Options -band ([System.Management.Automation.ScopedItemOptions]::ReadOnly -bor
                        [System.Management.Automation.ScopedItemOptions]::Constant)) {
                    throw "$path is read-only or constant. Use a fresh lab session rather than replacing it."
                }
                $restore = $true
                if ($provider -eq 'Alias' -and $name -eq 'ping' -and $item.Definition -eq 'Test-Connection') {
                    $restore = $false
                }
                if ($provider -eq 'Function' -and $name -eq 'Get-Process' -and
                    $item.ScriptBlock.ToString().Trim() -eq '"This isn''t the Get-Process cmdlet"') {
                    $restore = $false
                }
                $bindings += [pscustomobject]@{
                    Provider = $provider
                    Name = $name
                    Definition = if ($provider -eq 'Function') { $item.ScriptBlock } else { $item.Definition }
                    Options = $item.Options
                    Description = $item.Description
                    Restore = $restore
                }
            }
        }
    }

    $global:M10DemoState = @{
        Directory = 'C:\temp\Files'
        DirectoryCreated = -not (Test-Path -LiteralPath C:\temp\Files)
        OriginalLocation = Get-Location
        ProcessPolicy = Get-ExecutionPolicy -Scope Process
        UserPolicy = Get-ExecutionPolicy -Scope CurrentUser
        Bindings = $bindings
        Certificate = $null
        Files = @(
            'Sample.ps1', 'script.ps1', 'my script.ps1', 'ScriptParamExample.ps1',
            'Temp.ps1', 'Downloaded.ps1', 'TestScript.ps1', 'RequiresTest.ps1',
            'PowerShell_Cert.cer'
        )
    }
    foreach ($binding in $bindings) {
        Remove-Item -LiteralPath "$($binding.Provider):\$($binding.Name)"
    }
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Undefined -Force
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
    New-Item -Path $M10DemoState.Directory -ItemType Directory -Force | Out-Null

    $sample = @'
Write-Host 'Start of script' -BackgroundColor Green
Write-Host 'Display the % CPU Time utilization by the ISE' -BackgroundColor Green
Get-Counter '\Process(powershell_ise)\% Processor Time'
'@
    $scripts = @{
        'Sample.ps1' = $sample
        'Temp.ps1' = $sample
        'TestScript.ps1' = $sample
        'RequiresTest.ps1' = "#requires -Version 5.1`r`n$sample"
        'script.ps1' = "Write-Host 'Running script.ps1' -ForegroundColor Green`r`nGet-Date"
        'my script.ps1' = "Write-Host 'Running a script whose filename contains a space' -ForegroundColor Green`r`nGet-Date"
        'Downloaded.ps1' = "Write-Host 'Running the downloaded script' -ForegroundColor Green`r`nGet-Date"
        'ScriptParamExample.ps1' = @'
param (
    [string]$ComputerName = 'localhost'
)
$result = Test-Connection -ComputerName $ComputerName -Quiet -Count 1
Write-Host "Can reach ${ComputerName}: $result" -ForegroundColor Green
'@
    }
    foreach ($name in $scripts.Keys) {
        $path = Join-Path $M10DemoState.Directory $name
        Set-Content -LiteralPath $path -Value $scripts[$name] -Encoding UTF8
        Unblock-File -LiteralPath $path
    }
    foreach ($name in 'PowerShell_Cert.cer') {
        $path = Join-Path $M10DemoState.Directory $name
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path
        }
    }
    Set-Content -LiteralPath C:\temp\Files\Downloaded.ps1 -Stream Zone.Identifier -Value "[ZoneTransfer]`r`nZoneId=3"
    Set-Location -LiteralPath $M10DemoState.Directory
    if (-not (Get-Process -Name powershell_ise -ErrorAction SilentlyContinue)) {
        Write-Warning 'The powershell_ise CPU-counter examples require PowerShell ISE to be running.'
    }
    Get-ExecutionPolicy -List
    Write-Host 'Setup complete. Run the slides, then Cleanup in this same session.' -ForegroundColor Green
}
#endregion

#region Slide 6 - Simple Script Example
Write-Host 'Start of script' -BackgroundColor Green
Write-Host 'Display the % CPU Time utilization by the ISE' -BackgroundColor Green
Get-Counter '\Process(powershell_ise)\% Processor Time'
C:\temp\Files\Sample.ps1
#endregion

#region Slide 7 - Demonstration: PowerShell Scripts
New-Item -Path C:\Temp\Files -ItemType Directory -Force | Out-Null
# Run the next five lines together
Set-Content -Path C:\temp\Files\TestScript.ps1 -Value @'
Write-Host 'Start of script' -BackgroundColor Green
Write-Host 'Display the % CPU Time utilization by the ISE' -BackgroundColor Green
Get-Counter '\Process(powershell_ise)\% Processor Time'
'@
Get-Content -Path C:\Temp\Files\TestScript.ps1
C:\temp\Files\TestScript.ps1
#endregion

#region Slide 8 - Running Powershell Scripts
Set-Location -Path C:\temp\Files
C:\temp\Files\script.ps1
.\script.ps1
& 'C:\temp\Files\my script.ps1'
# Fails on purpose: C:\temp\Files is not in $env:Path
Script.ps1
#endregion

#region Slide 9 - Script Parameters
.\ScriptParamExample.ps1 -ComputerName localhost
.\ScriptParamExample.ps1 -ComputerName DoesNotExist
#endregion

#region Slide 10 - Demonstration: Running Scripts
C:\temp\Files\TestScript.ps1
Set-Location -Path C:\temp\Files
.\TestScript.ps1
# Fails on purpose: no .\ in front of the name
TestScript.ps1
explorer.exe C:\temp\Files
# Use C:\temp\Files for the later slides
Set-Location -Path C:\temp\Files
#endregion

#region Slide 15 - Setting / Determining Execution Policy
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
Get-ExecutionPolicy -List
Get-ExecutionPolicy
# Cleanup restores the execution policies captured by Setup.
#endregion

#region Slide 16 - Demonstration: Execution Policy
# Each line starts a new process with a policy for that process only (no persistent policy changes).
powershell.exe -NoProfile -ExecutionPolicy Restricted -File C:\temp\Files\TestScript.ps1
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File C:\temp\Files\Temp.ps1
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File C:\temp\Files\Downloaded.ps1
powershell.exe -NoProfile -ExecutionPolicy AllSigned -File C:\temp\Files\Temp.ps1
powershell.exe -NoProfile -ExecutionPolicy Restricted -Command 'Get-ExecutionPolicy -List'
powershell.exe -NoProfile -ExecutionPolicy Restricted -Command 'Get-Date'
Unblock-File -Path C:\temp\Files\Downloaded.ps1
powershell.exe -NoProfile -ExecutionPolicy RemoteSigned -File C:\temp\Files\Downloaded.ps1
#endregion

#region Slide 19 - Certificates
# Run this entire region together. Reuse only this demo's certificate when repeating the slide.
if ($null -eq $M10DemoState) { throw 'Run Setup first.' }
if ($null -eq $M10DemoState.Certificate) {
    $M10DemoState.Certificate = New-SelfSignedCertificate -Subject 'CN=M10 WorkshopPLUS Demo Code Signing' -Type CodeSigning -CertStoreLocation Cert:\CurrentUser\My -ErrorAction Stop
}
$M10DemoState.Certificate
Export-Certificate -FilePath C:\temp\Files\PowerShell_Cert.cer -Cert $M10DemoState.Certificate
Import-Certificate -FilePath C:\temp\Files\PowerShell_Cert.cer -CertStoreLocation Cert:\CurrentUser\Root
Import-Certificate -FilePath C:\temp\Files\PowerShell_Cert.cer -CertStoreLocation Cert:\CurrentUser\TrustedPublisher
#endregion

#region Slide 20 - Signing a script
# Fails on purpose, as on the slide: AllSigned and Temp.ps1 is not signed yet
powershell.exe -NoProfile -ExecutionPolicy AllSigned -File C:\temp\Files\Temp.ps1
Set-AuthenticodeSignature -FilePath .\temp.ps1 -Certificate $M10DemoState.Certificate
#endregion

#region Slide 21 - Script After Signing
Write-Host 'Start of script' -BackgroundColor Green
Write-Host 'Display the % CPU Time utilization by the ISE' -BackgroundColor Green
Get-Counter '\Process(powershell_ise)\% Processor Time'
# The signature block Set-AuthenticodeSignature appended
Get-Content -Path C:\temp\Files\Temp.ps1
# Same command that failed on slide 20 now runs: signed by a trusted publisher
powershell.exe -NoProfile -ExecutionPolicy AllSigned -File C:\temp\Files\Temp.ps1
#endregion

#region Slide 23 - Review - Comments
& {
    param ($Computername)
    <#
        This is a block comment
        Testing connectivity to remote computers
        Write Boolean output in Green
    #>
    $result = Test-Connection -ComputerName $Computername -Quiet -Count 1
    # This is a single line comment
    Write-Host $result -ForegroundColor Green # Inline comment
} -Computername localhost
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

#region Slide 26 - Demonstration: Requires Statement
$M10DemoState.Body = Get-Content -Path C:\temp\Files\TestScript.ps1
# Fails in a standard session; runs if the terminal was started as administrator
Set-Content -Path C:\temp\Files\RequiresTest.ps1 -Value (@('#requires -RunAsAdministrator') + $M10DemoState.Body)
C:\temp\Files\RequiresTest.ps1
Set-Content -Path C:\temp\Files\RequiresTest.ps1 -Value (@('#requires -Version 5.1') + $M10DemoState.Body)
C:\temp\Files\RequiresTest.ps1
Set-Content -Path C:\temp\Files\RequiresTest.ps1 -Value (@('#requires -Version 10') + $M10DemoState.Body)
C:\temp\Files\RequiresTest.ps1
# Leave the files in place for inspection; the final Cleanup region removes them.
#endregion

#region Slide 29 - Alias Overriding External Command
ping 127.0.0.1
New-Alias -Name ping -Value Test-Connection
ping 127.0.0.1
# Back to ping.exe (Remove-Alias only exists in PowerShell 6 and later)
Remove-Item -Path Alias:\ping
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
#Remove the function so Get-Process is the cmdlet again
Remove-Item -Path Function:\Get-Process
#endregion

#region Cleanup - Run this entire region after the demo, even if a slide failed
& {
    $ErrorActionPreference = 'Stop'
    if (-not (Test-Path -LiteralPath Variable:\M10DemoState)) {
        Write-Warning 'No demo setup state exists in this session; nothing was changed by cleanup.'
        return
    }

    if ($null -ne $M10DemoState.Certificate) {
        $thumbprint = $M10DemoState.Certificate.Thumbprint
        foreach ($store in 'TrustedPublisher', 'Root') {
            $path = "Cert:\CurrentUser\$store\$thumbprint"
            if (Test-Path -LiteralPath $path) {
                Remove-Item -LiteralPath $path
            }
        }
        $path = "Cert:\CurrentUser\My\$thumbprint"
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -DeleteKey
        }
    }
    foreach ($provider in 'Alias', 'Function') {
        foreach ($name in 'ping', 'Get-Process') {
            $path = "${provider}:\$name"
            if (Test-Path -LiteralPath $path) {
                Remove-Item -LiteralPath $path
            }
        }
    }
    foreach ($binding in $M10DemoState.Bindings) {
        if ($binding.Restore) {
            if ($binding.Provider -eq 'Alias') {
                Set-Alias -Name $binding.Name -Value $binding.Definition -Scope Global -Option $binding.Options -Description $binding.Description
            }
            else {
                Set-Item -LiteralPath "Function:\global:$($binding.Name)" -Value $binding.Definition -Options $binding.Options
            }
        }
    }
    Set-Location -LiteralPath $M10DemoState.OriginalLocation.Path
    foreach ($name in $M10DemoState.Files) {
        $path = Join-Path $M10DemoState.Directory $name
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path
        }
    }
    if ($M10DemoState.DirectoryCreated -and (Test-Path -LiteralPath $M10DemoState.Directory) -and
        @(Get-ChildItem -LiteralPath $M10DemoState.Directory -Force).Count -eq 0) {
        Remove-Item -LiteralPath $M10DemoState.Directory
    }
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Undefined -Force
    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy $M10DemoState.UserPolicy -Force
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy $M10DemoState.ProcessPolicy -Force
    Remove-Variable -Name M10DemoState -Scope Global
    Write-Host 'Cleanup complete. Original policies, command bindings, and location restored.' -ForegroundColor Green
}
#endregion
