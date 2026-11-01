<#
    M02 - Commands
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 5 - External Commands VS Native PowerShell
Ping Loopback -a -n 1
Test-Connection -count 1
Shutdown /m \\MS
Restart-Computer -ComputerName 'MS'
Netsh interface ipv4 show addresses
Get-NetIPAddress
#endregion

#region Slide 6 - Demonstration: External Command vs. Native Commands
$p = ping.exe localhost -n 2
$t = Test-Connection -ComputerName localhost -Count 2
$p[0].GetType()
$t[0].GetType()
$p
$t
$t | Get-Member
$p | Select-String -Pattern 'time[=<](\d+)ms' | ForEach-Object { $_.Matches.Groups[1].Value }
$t.ResponseTime    # Windows PowerShell 5.1 name; PowerShell 7 calls it Latency
ipconfig.exe
Get-NetIPConfiguration
# Needs DNS
nslookup.exe microsoft.com
Resolve-DnsName -Name microsoft.com -Type A
Get-Command -Name ping
Get-Command -Name Get-Process
#endregion

#region Slide 8 - Native Commands Standardization
Remove-Item -Path C:\Temp\TestFolder -Force
#endregion

#region Slide 9 - Native Command Examples
Get-Process
Restart-Service -Name Spooler
Test-Connection -ComputerName 2012R2-MS -Count 1 -Quiet
Get-Service -Name Bits
#endregion

#region Slide 11 - Get-Command - Example
Get-Command
Get-Command -Name *User*
#endregion

#region Slide 12 - Get-Command Verb & Noun - Example
Get-Command -Verb Get
Get-Command -Noun Service
#endregion

#region Slide 13 - Get-Command by Command Type - Example
Get-Command -CommandType Cmdlet
Get-Command -Name Get-Service
#endregion

#region Slide 14 - Searching for External Commands - Example
Get-Command -CommandType Application
#endregion

#region Slide 15 - Demonstration: Get-Command
Get-Command -Verb Invoke
Get-Command -Noun Service
Get-Command -Name *et*net*
Get-Command -ParameterName ComputerName
Get-Command -ParameterType PSCredential
Get-Command -Module Microsoft.PowerShell.Management
# Opens a window; close it to get the prompt back
Show-Command
Show-Command -Name Get-Command
#endregion

#region Slide 20 - Native Command Syntax Legend
# Verb-Noun
# [-Name <string[]>]
# -ComputerName <string[]>
# [-DisplayName] <string[]>
# <ArgumentType [ ] >
# [-SwitchParameters]
#endregion

#region Slide 21 - Command Name
# <Command-Name> -RequiredParameterName <Required Argument>
# [-OptionalParameterName> <Optional Argument>]
# [-SwitchParameters]
# [-OptionalParameterName>] <Required Argument>
Get-Command -Name Get-Content -Syntax
#endregion

#region Slide 22 - Required Parameters
# <Command-Name> -RequiredParameterName <Required Argument>
# [-OptionalParameterName> <Optional Argument>]
# [-SwitchParameters]
# [-OptionalParameterName>] <Required Argument>
Get-Command -Name Get-Content -Syntax
#endregion

#region Slide 23 - Optional Parameters
# <Command-Name> -RequiredParameterName <Required Argument>
# [-OptionalParameterName <Optional Argument>]
# [-SwitchParameters]
# [-OptionalParameterName] <Required Argument>
Get-Command -Name Get-Content -Syntax
#endregion

#region Slide 24 - Switch Parameters
# <Command-Name> -RequiredParameterName <Required Arguement>
# [-OptionalParameterName> <Optional Argument>]
# [-SwitchParameters]
# [-OptionalParameterName>] <Required Argument>
Get-Command -Name Get-Content -Syntax
#endregion

#region Slide 25 - Positional Parameters
# <Command-Name> -RequiredParameterName <Required Argument>
# [-OptionalParameterName> <Optional Argument>]
# [-SwitchParameters]
# [-OptionalParameterName>] <Required Argument>
Get-Command -Name Get-Content -Syntax
#endregion

#region Slide 26 - Demonstration: Native Command Syntax
Get-Command -Name Get-ChildItem -Syntax
Get-ChildItem
Get-ChildItem -Path C:\Windows -Filter *.exe
# Slow: press Ctrl+C after a few seconds
Get-ChildItem -Path C:\Windows -Filter *.exe -Recurse -ErrorAction SilentlyContinue
Get-ChildItem C:\Windows *.exe
#endregion

#region Slide 29 - Parameter Sets
Get-Command -Name Stop-Process -Syntax
#endregion

#region Slide 30 - Positional Parameters
Get-Command -Name Stop-Process -Syntax
Stop-Process -Id 8660
Stop-Process 8660
#endregion

#region Slide 31 - Demonstration: Parameter Sets & Positional vs. Named Parameters
Get-Command -Name Get-Command -Syntax
Get-Command -Name Get-Service -Syntax
Get-Service
# Windows PowerShell 5.1 only
Get-Service -ComputerName localhost, localhost
Get-Service -DependentServices
#endregion

#region Slide 36 - Frequently Used Common Parameters
Restart-Service -Name Netlogon
Restart-Service -Name Netlogon -Verbose
#endregion

#region Slide 37 - Common Parameters - ErrorAction
Get-Process Netlogon
Get-Process Netlogon -ErrorAction SilentlyContinue
#endregion

#region Slide 38 - Demonstration: Common Parameters
Get-Service -Name Netlogon, NotAService, WinRM
Get-Service -Name Netlogon, NotAService, WinRM -ErrorAction SilentlyContinue
# Run the next six lines together
try {
    Get-Service -Name Netlogon, NotAService, WinRM -ErrorAction Stop
}
catch {
    "Caught it: $($_.Exception.Message)"
}
Start-Process -FilePath notepad
Stop-Process -Name notepad -Verbose
(Get-Command -Name Get-Service).Parameters.Keys
Get-Help -Name about_CommonParameters
Get-Service -Name Netlogon, NotAService, WinRM -ErrorVariable svcErrors -ErrorAction SilentlyContinue
$svcErrors
#endregion

#region Slide 41 - WhatIf and Confirm Parameters - Example
Stop-Process -Name * -WhatIf
Start-Service -name xb* -Confirm
#endregion

#region Slide 42 - Demonstration: Risk Mitigation Parameters
Stop-Service -Name * -WhatIf
Stop-Service -Name W* -WhatIf
Start-Process -FilePath notepad
Start-Process -FilePath notepad
Start-Process -FilePath notepad
Stop-Process -Name notepad -WhatIf
Get-Process -Name notepad
Stop-Process -Name N* -WhatIf
# Closes every Notepad window, including unsaved ones
Stop-Process -Name notepad -Confirm
(Get-Command -Name Stop-Service).Parameters.Keys -contains 'WhatIf'
(Get-Command -Name Get-Service).Parameters.Keys -contains 'WhatIf'
# Run the next four lines together
Start-Process -FilePath notepad
$WhatIfPreference = $true
Stop-Process -Name notepad
$WhatIfPreference = $false
Stop-Process -Name notepad
#endregion

#region Slide 46 - Termination Character - Example
Get-Service BITS; Get-Process System; Get-service wsearch
#endregion

#region Slide 48 - Line Continuation - Example
"This is a multi-line
text sample that continues on the next
line"
(
Get-Service wsearch
)
#endregion

#region Slide 49 - Demonstration: Command Termination and Line Continuation
Get-Service -Name WinRM ; Get-Process -Name explorer ; Get-ChildItem -Path $env:TEMP
$name = 'PowerShell'
"
Hello from $name
This string spans
several lines
"
'
Nothing expands here:
$name is just text
'
(
Get-NetIPAddress
)
Get-Service | Where-Object {
    $_.Status -eq 'Running'
}
Get-Process |
    Sort-Object -Property CPU -Descending
Get-Process -Name explorer `
    -ErrorAction SilentlyContinue
$params = @{ Name = 'explorer'; ErrorAction = 'SilentlyContinue' }
Get-Process @params
#endregion

#region Slide 51 - Aliases
gci -Path C:\ -Recurse
dir -Path C:\ -Recurse
Get-ChildItem -Path C:\ -Recurse
ls -Path C:\ -Recurse
#endregion

#region Slide 52 - Listing all Aliases - Example
Get-Alias
Get-Command -CommandType Alias
#endregion

#region Slide 53 - Finding Alias Definition - Example
Get-Alias -Name Dir
Get-Command -Name Dir
Get-Alias -Definition Get-ChildItem
#endregion

#region Slide 54 - Creating an Alias
New-Alias -Name list -Value Get-ChildItem
list
#endregion

#region Slide 55 - Demonstration: Built-in Aliases
(Get-Alias).Count
Get-Alias -Name dir, ls, cat, rm, kill
Get-Alias -Name gsv, gps, ft
Get-Alias -Definition Get-Process
Get-Alias -Definition Remove-Item
# These two fail on purpose: the aliases run Get-ChildItem, not cmd or bash
dir /s
ls -la
dir -Recurse
ls -Force
# Windows PowerShell 5.1 only: curl is an alias for Invoke-WebRequest
Get-Alias -Name curl
Get-Command -Name curl.exe
New-Alias -Name ShowTime -Value Get-Date
ShowTime
Remove-Item -Path Alias:\ShowTime
#endregion
