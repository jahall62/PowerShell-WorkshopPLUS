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

#region Slide 8 - Native Commands Standardization
Remove-Item -Path C:\Temp -Force
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

#region Slide 29 - Parameter Sets
Get-Command -Name Stop-Process -Syntax
#endregion

#region Slide 30 - Positional Parameters
Get-Command -Name Stop-Process -Syntax
Stop-Process -Id 8660
Stop-Process 8660
#endregion

#region Slide 36 - Frequently Used Common Parameters
Restart-Service -Name Netlogon
Restart-Service -Name Netlogon -Verbose
#endregion

#region Slide 37 - Common Parameters - ErrorAction
Get-Process Netlogon
Get-Process Netlogon -ErrorAction SilentlyContinue
#endregion

#region Slide 41 - WhatIf and Confirm Parameters - Example
Stop-Process -Name * -WhatIf
Start-Service -name xb* -Confirm
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
