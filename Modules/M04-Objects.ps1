<#
    M04 - Objects
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

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

#region Slide 20 - Variables Overview
$Date = Get-Date
$Date
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

#region Slide 37 - Overload Definitions of a Method
$BITS = Get-Service -Name BITS
$BITS.Start
#endregion
