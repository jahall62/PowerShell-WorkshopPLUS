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
