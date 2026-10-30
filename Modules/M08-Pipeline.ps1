<#
    M08 - Pipeline
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 8 - Determining Parameter Pipeline Input
'Spooler' | Stop-Service
Get-Help -Name Stop-Service -Parameter Name
#endregion

#region Slide 9 - Pipeline Input ByValue
'Spooler' | Stop-Service
Get-Help -Name Stop-Service -Parameter Name
#endregion

#region Slide 10 - Pipeline Input ByPropertyName
$Object = [PSCustomObject]@{Name='Spooler'}
$Object | Stop-Service
Get-Member -InputObject $Object
Get-Help -Name Stop-Service -Parameter Name
#endregion

#region Slide 11 - Pipeline Input ByPropertyName
Get-Help Get-Service -Parameter Name
Get-Help Get-Service -Parameter ComputerName
# Import Objects with Properties Name and ComputerName
Import-Csv C:\temp\Services.csv |
       Get-Service | # Service Objects have a Property MachineName
       Get-Select -Property Name,MachineName,Status
#endregion

#region Slide 12 - Pipeline Input ByPropertyName
Get-Help New-Alias -Parameter Name
Get-Help New-Alias -Parameter Value
Import-Csv C:\temp\aliases.csv | Get-Member
#endregion

#region Slide 14 - Generic Pipeline Commands
Get-Command -ParameterName InputObject -ParameterType PSObject
#endregion

#region Slide 18 - Sort-Object and Select-Object - Example
Get-Process | Sort-Object -Property Handles | Select-Object -last 2
#endregion

#region Slide 19 - Group-Object - Example
Get-WinEvent -LogName Security | Group-Object -Property EntryType
#endregion

#region Slide 20 - Measure-Object - Example
Get-ChildItem C:\Scripts | Measure-Object -Property Length -Sum
#endregion

#region Slide 23 - Formatting - Example
Get-Service net* | Format-Table -Property DisplayName, Status, StartType
#endregion

#region Slide 24 - Formatting - Example
Get-Service net* | Format-List -Property DisplayName, Status, StartType
#endregion

#region Slide 27 - Get-Content - Example
(Get-Service).DisplayName | Set-Content .\Content.txt
Get-Content .\Content.txt
#endregion

#region Slide 28 - Import and Export Cmdlets
Get-Service | Export-Csv -Path .\Services.csv
$UPNs = Import-Csv -Path .\Usernames.csv -Delimiter ";"
#endregion

#region Slide 29 - Import-Csv - Example
Import-Csv .\Users.csv
Import-Csv .\Users.csv | Get-Member
#endregion

#region Slide 30 - Export-CSV - Example
Get-Service | Export-Csv c:\temp\services.csv
notepad.exe C:\temp\services.csv
#endregion

#region Slide 31 - Import-CliXml - Data Serializaion
Import-CliXML .\Services.xml | Get-Member
#endregion

#region Slide 34 - Out-GridView - Example
Get-Process | Out-GridView
#endregion

#region Slide 35 - Out-GridView with PassThru - Example
$Procs = Get-Process
$Procs | Out-GridView -PassThru | Export-Csv c:\temp\File.csv -NoTypeInformation
#endregion

#region Slide 38 - ConvertTo-Json
Get-Service | ConvertTo-Json | Out-File c:\temp\services.json
notepad.exe C:\temp\services.json
code . C:\temp\services.json
#endregion

#region Slide 44 - Basic Comparison - Example
"This" -eq "That"
"This" -eq "This"
"This" -eq "Th*"
#Wildcard must be on right
"This" -like "Th*"
"This" -like "That"
"This" -notlike "That"
5 -gt 3
5 -gt 5
5 -ge 5
#Case Insensitive
"This" -eq "this"
#Case Sensitive
"This" -ceq "this"
#endregion

#region Slide 45 - Where-Object Using Comparisons
Get-Service | Where-Object {$_.StartType -eq "Disabled"}
#endregion

#region Slide 46 - Where-Object Using Logical Operators - Example
Get-Service | Where-Object {$_.StartType -eq "Disabled"}
Get-Service |
    Where-Object {$_.StartType -eq "Disabled" -and $_.Name -like "r*"}
#endregion

#region Slide 47 - Where-Object Simple Syntax
Get-Service | Where-Object {$_.Status -eq "Running"}
Get-Service | Where Status -eq 'Running'
Get-Service | Where-Object {$_.Status -eq "Running" -and $_.CanStop}
#endregion

#region Slide 48 - Filtering with Parameters vs. Where-Object
Get-Process -Name explorer
Get-Process | Where-Object {$_.Name -eq "explorer"}
#endregion

#region Slide 49 - Piping
Get-ChildItem -Path C:\Windows\System32 |
        Where-Object Length -gt 50mb |
        Sort-Object Length |
            Format-Table Name,Length
#endregion

#region Slide 52 - Logical Operators - AND
("This" -eq "This") -and ("That" -eq "That")
("This" -eq "This") -and ("That" -eq "NO GOOD")
#endregion

#region Slide 53 - Logical Operators - OR
("This" -eq "This") -or ("That" -eq "That")
("This" -eq "This") -or ("That" -eq "NO GOOD")
#endregion

#region Slide 54 - Logical Operators - NOT
-not("This" -eq "This")
!("This" -eq "NO GOOD")
#endregion

#region Slide 56 - Logical Operators - AND
("This" -eq "This") -and ("That" -eq "That")
("This" -eq "This") -and ("That" -eq "NO GOOD")
#endregion

#region Slide 57 - Logical Operators - OR
("This" -eq "This") -or ("That" -eq "That")
("This" -eq "This") -or ("That" -eq "NO GOOD")
#endregion

#region Slide 58 - Logical Operators - XOR
("This" -eq "This") -xor ("That" -eq "That")
("This" -eq "This") -xor ("That" -eq "NO GOOD")
("This" -eq "NO GOOD") -xor ("That" -eq "NO GOOD")
#endregion

#region Slide 59 - Logical Operators - NOT
-not("This" -eq "This")
!("This" -eq "NO GOOD")
#endregion

#region Slide 61 - Where-Object Basics
Get-Service | Where-Object {$_.CanPauseAndContinue}
#endregion

#region Slide 64 - Foreach-Object
Get-Service net* | ForEach-Object {"Hello " + $_.Name}
#endregion

#region Slide 65 - Foreach-Object - Active Directory Example
1..100 | ForEach-Object {
    New-ADUser -Name User$_ `
      -Organization "contoso.com/Accounts" `
      -UserPrincipalName "User$_@contoso.com" `
      -EmailAddress "User$_@contoso.com" `
      -ChangePasswordAtLogon $true
}
#endregion

#region Slide 66 - Foreach-Object Parameters
Get-EventLog -LogName Application -Newest 5 |
ForEach-Object {$_.Message | Out-File Events.txt -Append}
Get-EventLog -LogName Application -Newest 5 |
ForEach-Object -Process {$_.Message | Out-File Events.txt -Append}
#endregion

#region Slide 67 - Foreach-Object Parameters - Begin
Get-EventLog -LogName Application -Newest 5 |
ForEach-Object `
-Begin {Remove-Item .\Log.txt; Write-Host "Start" -ForegroundColor Green} `
-Process {$_.Message | Out-File -Filepath Log.txt -Append} `
-End {Write-Host "End" -ForegroundColor Red; notepad.exe Log.txt}
#endregion

#region Slide 68 - Foreach-Object Parameters - Process
Get-EventLog -LogName Application -Newest 5 |
ForEach-Object `
-Begin {Remove-Item .\Log.txt; Write-Host "Start" -ForegroundColor Green} `
-Process {$_.Message | Out-File -Filepath Log.txt -Append} `
-End {Write-Host "End" -ForegroundColor Red; notepad.exe Log.txt}
#endregion

#region Slide 69 - Foreach-Object Parameters - End
Get-EventLog -LogName Application -Newest 5 |
ForEach-Object `
-Begin {Remove-Item .\Log.txt; Write-Host "Start" -ForegroundColor Green} `
-Process {$_.Message | Out-File -Filepath Log.txt -Append} `
-End {Write-Host "End" -ForegroundColor Red; notepad.exe Log.txt}
#endregion
