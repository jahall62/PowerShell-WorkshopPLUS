<#
    M04 - Objects
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 10 - Demonstration: PowerShell Objects
Get-Service -Name Spooler
(Get-Service -Name Spooler).Status
(Get-Service -Name Spooler).DisplayName
(Get-Service -Name Spooler).StartType
# Needs an elevated session; really stops and starts the print spooler
(Get-Service -Name Spooler).Stop()
(Get-Service -Name Spooler).Start()
#endregion

#region Slide 14 - Using Get-Member cmdlet
Get-Member -InputObject 'Some String'
# We will discuss pipeline later
'Some String' | Get-Member
#endregion

#region Slide 15 - Get-Member Property Definition
Get-Member -InputObject (Get-Item C:\File.txt) -Name LastWriteTime
(Get-Item C:\File.txt).LastWriteTime = (Get-Date)
Get-Item C:\File.txt
#endregion

#region Slide 16 - Get-Member Method Definition
Get-Member -InputObject (Get-Item C:\File.txt) -Name CopyTo
(Get-Item C:\File.txt).CopyTo("c:\Temp\File.txt", $True)
#endregion

#region Slide 17 - Demonstration: GetType() and Get-Member
# Setup: create the demo file
New-Item -Path C:\Temp -ItemType Directory -Force | Out-Null
Set-Content -Path C:\Temp\Demo.txt -Value 'Demo file for slide 17' -Force
$File = Get-Item C:\Temp\Demo.txt
$File.GetType()
$File | Get-Member
$File | Get-Member -Name IsReadOnly
$File.IsReadOnly
$File.IsReadOnly = $true
(Get-Item C:\Temp\Demo.txt).IsReadOnly
$File.CopyTo("C:\Temp\DemoCopy.txt", $true)
$NewFile = $File.CopyTo("C:\Temp\DemoCopy2.txt", $true)
$NewFile.FullName
$NewFile.LastWriteTime
$NewFile.GetType()
# Cleanup: the files are read-only now, so -Force is needed
Remove-Item -Path C:\Temp\Demo.txt, C:\Temp\DemoCopy*.txt -Force
#endregion

#region Slide 20 - Variables Overview
$Date = Get-Date
$Date
#endregion

#region Slide 22 - Demonstration: Automatic Variables
$Greeting = "Hello PowerShell"
$Greeting
$Date = Get-Date
$Date
$Date | Get-Member
$error
# Run the next two lines together
Get-Item C:\Nope -ErrorAction SilentlyContinue
$?
$null
$pshome
$true
$host
Get-Help about_Automatic_Variables -ShowWindow
#endregion

#region Slide 23 - User-Defined Variables
$Service = Get-Service audiosrv
New-Variable -Name Service -Value (Get-Service audiosrv)
$Service
$Service.DisplayName
#endregion

#region Slide 24 - Variable Cmdlets
New-Variable -Name Pi -Value 3.14 -Option Constant
New-Variable -Name Max -Value 256 -Option ReadOnly
$max
$max = 5
#endregion

#region Slide 25 - Demonstration: User Defined Variables
# Runs once per session; restart the session to repeat
$Number = 1
$Test = "test variable"
$Date = Get-Date
New-Variable -Name Test2 -Value "also works"
New-Variable -Name SpeedOfSound -Value 331.2 -Option Constant
$SpeedOfSound
$SpeedOfSound = 5    # This will fail
Set-Variable -Name SpeedOfSound -Value 5 -Force    # This will fail
New-Variable -Name WriteProtected -Value "haha can't change me" -Option ReadOnly
$WriteProtected
$WriteProtected = 5    # This will fail
Set-Variable -Name WriteProtected -Value 5 -Force    # This will succeed
$WriteProtected
#endregion

#region Slide 29 - Identifying Object Types
("Text").GetType().FullName
(42).GetType().FullName
($True).GetType().FullName
("Text").GetType()
$Proc = Get-Process PowerShell
$Proc.GetType() | FL Name, FullName
#endregion

#region Slide 31 - String Quotes
$var = "test"
$DoubleQuotes = "Var is $var"
$DoubleQuotes
$DoubleQuotes.GetType().FullName
$var = "test"
$SingleQuotes = 'Var is $var'
$SingleQuotes
$SingleQuotes.GetType().FullName
#endregion

#region Slide 32 - Here Strings
$var = 123
@'
As
'easy'
as
$var
'@
$var = 123
@"
As
"easy"
as
$var
"@
#endregion

#region Slide 33 - Variable Subexpression $()
# Properties Not expanded
$Service = Get-Service -Name BITS
Write-Host "$Service.Name is $Service.Status" -ForegroundColor Green
Write-Host "$($Service.Name) is $($Service.Status)" -ForegroundColor Green
Write-Host "Your Lucky Number is $(Get-Random)" -ForegroundColor Green
#endregion

#region Slide 34 - Demonstration: Strings, Here Strings, and Subexpression
$service = Get-Service -Name spooler
Write-Output -InputObject "Found the service $service.name"
Write-Output -InputObject "Found the service $($service.name)"
$Message = 'Hello World'
$html = @"
<html>
<body>
$Message
</body>
</html>
"@
$html
#endregion

#region Slide 37 - Overload Definitions of a Method
$BITS = Get-Service -Name BITS
$BITS.Start
#endregion
