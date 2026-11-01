<#
    M06 - Working with Types
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 5 - Types
$Salary = '100'
$Bonus = 0
$NewSalary = $Salary + $Bonus
$NewSalary
$Salary = '100'
$Bonus = 0
$NewSalary = $Bonus + $Salary
$NewSalary
#endregion

#region Slide 6 - Type Casting
$Salary = '1000'
$Bonus = 100
$NewSalary = [int]$Salary + $Bonus
$Salary.GetType().FullName
$NewSalary
$NewSalary.GetType().FullName
#endregion

#region Slide 7 - Demonstration: Type conversions
$Salary = '1000'
$Bonus = 100
$NewSalary = $Salary + $Bonus
$NewSalary
$NewSalary = $Bonus + $Salary
$NewSalary
$NewSalary = [int]$Salary + $Bonus
$Salary.GetType().FullName
$NewSalary
$NewSalary.GetType().FullName
$Number = "5"
$Number
$Number.GetType()
$Number = [int]"5"
$Number
$Number.GetType()
# Read-Host prompts in the terminal: click there before typing
$r = Read-Host "Give me a number"
$r.GetType().FullName
# Try a number, then a word
$r = [int](Read-Host "Give me a number")
$r.GetType().FullName
# Windows PowerShell 5.1 needs Get-Service once before the next line
Get-Service | Out-Null
([System.ServiceProcess.ServiceControllerStatus]"running").GetType().FullName
[system.int32]$Salary + $Bonus
[int32]$Salary + $Bonus
[int]$Salary + $Bonus
# Fails on purpose
[int]'One'
#endregion

#region Slide 9 - Strong Typing
[Int]$Number = 123
$Number.GetType().FullName
$Number = '123'
$Number.GetType().FullName
$Number = 'OneTwoThree'
#endregion

#region Slide 10 - Strong Typing Function Parameters
Function Test-Params
{
    param ($Anything,
           [Int]$Number,
           [String]$Text)
}
Get-Command Test-Params -Syntax
#endregion

#region Slide 12 - Demonstration: Strong Typing
[string]$MyVar1 = "String"
$MyVar1.GetType().FullName
$MyVar1 = 5
$MyVar1.GetType().FullName
[int]$MyVar2 = 3
$MyVar2.GetType().FullName
# Fails on purpose
[int]$MyVar3 = "Green"
$Salary = '1000'
$Salary.GetType().FullName
[int]$Salary + 100
$Salary.GetType().FullName
[datetime]"2025-12-31 23:59"
([datetime]"2025-12-31").GetType().FullName
[System.Int32]$Var2 = 123
$Var2.GetType().FullName
# Windows PowerShell 5.1 needs Get-Service once before the next line
Get-Service | Out-Null
[System.ServiceProcess.ServiceControllerStatus]$Status = "running"
# Fails on purpose: the error lists the valid names
$Status = "fake"
function Test-ParamsTypes {
    param (
        [int]$Number,
        [string]$Text
    )
    Write-Host "Number value: $Number" -ForegroundColor Yellow
    Write-Host "Number type : $($Number.GetType().FullName)" -ForegroundColor Yellow
    Write-Host "Text value  : $Text" -ForegroundColor Cyan
    Write-Host "Text type   : $($Text.GetType().FullName)" -ForegroundColor Cyan
}
Test-ParamsTypes -Number "123" -Text "123"
Test-ParamsTypes -Number 123 -Text 123
# Fails on purpose
Test-ParamsTypes -Number "One" -Text "Two"
Get-Command Test-ParamsTypes -Syntax
# Cleanup
Remove-Variable MyVar1, MyVar2, Var2, Status -ErrorAction SilentlyContinue
Remove-Item Function:\Test-ParamsTypes -ErrorAction SilentlyContinue
#endregion

#region Slide 15 - Static Members
[math] | Get-Member -Static
#endregion

#region Slide 16 - Static Members - Example
[math]::PI
[math]::Round(3.14159265358979, 3)
[math]::Round([math]::PI, 3)
[datetime]::now.Month
[datetime]::DaysInMonth(2024, 2)
[datetime]::DaysInMonth([datetime]::Now.Year, [datetime]::now.Month)
#endregion

#region Slide 17 - Enums
[ConsoleColor]
#endregion

#region Slide 19 - Demonstration: Static Members
[math] | Get-Member -Static
[math]::PI
[math]::Round(3.14159265358979, 3)
[math]::Round([math]::PI, 3)
[datetime] | Get-Member -Static
[datetime]::DaysInMonth(2024, 2)
[datetime]::DaysInMonth(2025, 2)
[datetime]::DaysInMonth([datetime]::Now.Year, [datetime]::Now.Month)
[ConsoleColor]::Black
[DayOfWeek]::Friday
[System.DayOfWeek]
[enum]::GetNames([ConsoleColor])
#endregion

#region Slide 21 - Type Comparison
$Num = 123
$Str = 'ABC'
$Num -is [int]
$Num -is $Str.GetType()
$Num -is [String]
$Num = 123
$Str = 'ABC'
$Num -isnot [int]
$Num -isnot $Str.GetType()
$Num -isnot [String]
#endregion

#region Slide 22 - Escape character
Write-Host "`$Home is $Home"
Write-Host "Hello World" `
-ForegroundColor Green
Write-Host "Hello`nWorld" -ForegroundColor Yellow
Write-Host "Hello`tWorld" -ForegroundColor Cyan
#endregion

#region Slide 24 - Parsing Modes - Example
#Expression mode does the expected work
2+2
#Argument mode, treats everything as strings
Write-Host 2+2 -ForegroundColor Green
#Expression mode forced on 2+2
Write-Host (2+2) -ForegroundColor Green
#Expression mode as a command will be interpreted and attempted to be invoked
Test
#Expression mode as expandable strings as the content must be interpreted first
"Test"
#endregion

#region Slide 25 - Demonstration: Type comparison, escape character, parsing modes
$Num = 123
$Str = 'ABC'
$Num -is [int]
$Num -is $Str.GetType()
$Num -isnot [int]
$Num -isnot $Str.GetType()
Write-Host "`$Home is $Home"
Write-Host "Hello `nWorld!"
Write-Host "Hello`n`tWorld!"
# Run the next two lines together
Write-Host "Hello`tWorld" `
-ForegroundColor Green
Write-Host "Hello$("`t"*2)World" -ForegroundColor Yellow
# Run the next two lines together (use -Name Spooler if there is no WinDefend service)
Get-Service -Name WinDefend | Format-Table `
Name,Status,CanStop
2+2
Write-Host 2+2 -ForegroundColor Green
Write-Host (2+2) -ForegroundColor Green
# Fails on purpose: Test is read as a command name
Test
"Test"
#endregion
