<#
    M09 - Flow Control
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 9 - If Statement Syntax
$File = Get-Item .\MyFile.txt
if($File.Length -lt 1kb)
{
  Write-Host 'Less than 1kb!'
}
#endregion

#region Slide 10 - Else Statement Syntax
$File = Get-Item .\MyFile.txt
if($File.Length -lt 1kb)
{
  Write-Host 'Less than 1kb!'
}
else
{
  Write-Host 'Larger than 1kb!'
}
#endregion

#region Slide 11 - ElseIf Statement Syntax
$File = Get-Item .\MyFile.txt
if($File.Length -lt 1kb)
{
  Write-Host 'Less than 1kb!'
}
elseif($File.Length -lt 100kb)
{
  Write-Host 'Less than 100kb!'
}
elseif($File.Length -lt 1mb)
{
  Write-Host 'Less than 1mb!'
}
#endregion

#region Slide 12 - Full Statement Syntax
$File = Get-Item .\MyFile.txt
if($File.Length -lt 1kb)
{
  Write-Host 'Less than 1kb!'
}
elseif($File.Length -lt 100kb)
{
  Write-Host 'Less than 100kb!'
}
elseif($File.Length -lt 1mb)
{
  Write-Host 'Less than 1mb!'
}
else
{
  Write-Host 'Bigger than 1mb!'
}
#endregion

#region Slide 13 - Demonstration: If Statements
# Ask the class to predict each result before you run it
if ($True) { Write-Host -ForegroundColor Green 'SUCCESS!' }
if ($False) { Write-Host -ForegroundColor Green 'SUCCESS!' }
if ($Null) { Write-Host -ForegroundColor Green 'SUCCESS!' }
if (0) { Write-Host -ForegroundColor Green 'SUCCESS!' }
if (5) { Write-Host -ForegroundColor Green 'SUCCESS!' }
if ([void]5) { Write-Host -ForegroundColor Green 'SUCCESS!' }
if (Get-Service) { Write-Host -ForegroundColor Green 'SUCCESS!' }

# A set of if / elseif statements. Test another day with: $date = (Get-Date).AddDays(1)
$date = Get-Date
if (($date.DayOfWeek -eq 'Sunday') -or ($date.DayOfWeek -eq 'Saturday'))
{
    Write-Host -ForegroundColor Green "It's the WEEKEND!"
}
elseif ($date.DayOfWeek -eq 'Monday')
{
    Write-Host -ForegroundColor Red 'Oh No! Not Monday Again!'
}
elseif ($date.DayOfWeek -eq 'Tuesday')
{
    Write-Host -ForegroundColor Yellow "Tuesday: At least it's not MONDAY!"
}
elseif ($date.DayOfWeek -eq 'Wednesday')
{
    Write-Host -ForegroundColor Magenta 'Halfway There!'
}
elseif ($date.DayOfWeek -eq 'Thursday')
{
    Write-Host -ForegroundColor Cyan 'One more Day!'
}
elseif ($date.DayOfWeek -eq 'Friday')
{
    Write-Host -ForegroundColor Green 'FRIDAY!'
}

# If inside the pipeline
Get-Service | Select-Object -First 15 | ForEach-Object {
    if ($_.StartType -eq 'Automatic')
    {
        Write-Host -ForegroundColor Green "$($_.DisplayName) Starts Automatically"
    }
    elseif ($_.StartType -eq 'Manual')
    {
        Write-Host -ForegroundColor Yellow "$($_.DisplayName) is Manually Started"
    }
    elseif ($_.StartType -eq 'Disabled')
    {
        Write-Host -ForegroundColor Gray "$($_.DisplayName) is Disabled"
    }
}

# Nested if statements
if ((Get-Date).Year -ge 2017)
{
    if ((Get-Date).DayOfWeek.ToString() -ne 'Sunday')
    {
        if ((Get-Date).TimeOfDay -gt 0)
        {
            Write-Host 'Hooray!'
        }
    }
}
#endregion

#region Slide 16 - Switch Syntax
$File = Get-Item .\MyFile.txt
Switch($File)
{
  {$File.Length -lt 1kb}
    {Write-host 'less than 1kb!'}
  {$File.Length -lt 100kb}
    {Write-host 'less than 100kb!'}
  {$File.Length -lt 1mb}
    {Write-host 'less than 1mb!'}
  default
    {Write-host 'bigger than 1mb!'}
}
#endregion

#region Slide 17 - Switch With Pipeline Variable
$Files = Get-ChildItem -File
Switch($Files)
{
  {$_.Length -lt 1kb}
    {Write-host 'less than 1kb!'}
  {$_.Length -lt 100kb}
    {Write-host 'less than 100kb!'}
  {$_.Length -lt 1mb}
    {Write-host 'less than 1mb!'}
}
#endregion

#region Slide 18 - Demonstration: Switch
# Switch compared with if. The comments show the matching if test
$color = 'Green'
switch ($color)
{
    <# if ($color -eq 'Cyan') #>  'Cyan'  { Write-Host 'Cyan!' -ForegroundColor Cyan }
    <# if ($color -eq 'Green') #> 'Green' { Write-Host 'Green' -ForegroundColor Green }
    # Default is the else: it runs only when every other case is false
    default { Write-Host 'This will run instead' -ForegroundColor Green }
}

# The exact equivalent using if statements
$runcatch = $false
$runcatch2 = $false
if ($color -eq 'Cyan')
{
    Write-Host 'Cyan!' -ForegroundColor Cyan
}
else
{
    $runcatch = $true
}
if ($color -eq 'Green')
{
    Write-Host 'Green' -ForegroundColor Green
}
else
{
    $runcatch2 = $true
}
if ($runcatch -eq $true -and $runcatch2 -eq $true)
{
    Write-Host 'This will run instead' -ForegroundColor Green
}

# A switch runs every block whose test passes
$value = 'One'
switch ($value)
{
    'One'   { Write-Host $_ }
    'One'   { Write-Host $_ }
    'Two'   { Write-Host $_ }
    'Three' { Write-Host $_ }
    'One'   { Write-Host $_ }
}
#endregion

#region Slide 20 - Switch - Simple Syntax
Switch('hello')
{
  'hello' {'lowercase'}
  'HELLO' {'uppercase'}}

Switch('hello')
{
  {$_ -eq 'hello'} {'lowercase'}
  {$_ -eq 'HELLO'} {'uppercase'}
}
#endregion

#region Slide 21 - Example - Case Sensitive Switch
switch -CaseSensitive ('HELLO')
{
  'hello' {'Lowercase'}
  'HELLO' {'Uppercase'}
}
#endregion

#region Slide 22 - Example - Wildcard Switch
switch -Wildcard (Get-ChildItem -Path c:\)
{
  'program*' {Write-Host $_ -F Green}
  'p*s*'     {Write-Host $_ -F Yellow}
  'windows'  {Write-Host $_ -F Cyan}
}
#endregion

#region Slide 23 - Example - Switch File Parameter
switch -File C:\Temp\InputFile.txt
{
  'Server1' {Write-Host "$_ in file" -F Gray}
  'Server2' {Write-Host "$_ in file" -F Red}
  'Server10' {Write-Host "$_ in file" -F Cyan}
}
#endregion

#region Slide 24 - Demonstration: Switch Parameters
# Read-Host waits for input in the terminal
switch -Wildcard (Read-Host "What's your favorite Season?")
{
    'Fall'   { Write-Host -ForegroundColor DarkYellow $_ }
    'Winter' { Write-Host -ForegroundColor White $_ }
    'Summer' { Write-Host -ForegroundColor Yellow $_ }
    'Spring' { Write-Host -ForegroundColor Green $_ }
    '*r*'    { Write-Host -ForegroundColor Magenta "There is an R in the season: $_" }
    default  { Write-Error "The Season ($_) does not exist!" }
}

# The same switch without -Wildcard: '*r*' is now literal text
switch (Read-Host "What's your favorite Season?")
{
    'Fall'   { Write-Host -ForegroundColor DarkYellow $_ }
    'Winter' { Write-Host -ForegroundColor White $_ }
    'Summer' { Write-Host -ForegroundColor Yellow $_ }
    'Spring' { Write-Host -ForegroundColor Green $_ }
    '*r*'    { Write-Host -ForegroundColor Magenta "There is an R in the season: $_" }
    default  { Write-Error "The Season ($_) does not exist!" }
}

# Expression cases: one item can match several of them
$files = Get-ChildItem -Path C:\Windows\System32 -Recurse -ErrorAction SilentlyContinue | Select-Object -First 500
switch ($files)
{
    { $_.Length -gt 1MB }       { Write-Host -ForegroundColor DarkCyan "$($_.FullName) is greater than 1MB" }
    { $_.Extension -eq '.exe' } { Write-Host -ForegroundColor Red "$($_.FullName) is an executable" }
    { $_.LastAccessTime -lt (Get-Date).AddMonths(-2) } { Write-Host -ForegroundColor Yellow "$($_.FullName) hasn't been accessed in two months" }
    { $_.Attributes -match 'Directory' } { Write-Host -ForegroundColor Green "$($_.FullName) is a Directory" }
}
#endregion

#region Slide 27 - While Loop
# While (Condition)
# {
#     PowerShell Code
# }
$i = 0
While ($i -lt 3)
{
   Write-Host "User $i"
   $i++
}
#endregion

#region Slide 28 - Do While Loop
# Do
# {
#     PowerShell Code
# }
# While (Condition)
$i = 5
Do
{
   Write-Host "User $i"
   $i++
}
While ($i -lt 3)

$i = 0
Do
{
   Write-Host "User $i"
   $i++
}
While ($i -lt 3)
#endregion

#region Slide 29 - Do Until Loop
# Do
# {
#     PowerShell Code
# }
# Until (Condition)
$i = 0
Do
{
   Write-Host "User $i"
   $i++
}
Until ($i -lt 3)

$i = 0
Do
{
   Write-Host "User $i"
   $i++
}
Until ($i -gt 3)
#endregion

#region Slide 30 - Demonstration: While, Do While and Do Until Loops
# While checks first: this never runs
while ($false)
{
    Write-Host -ForegroundColor Yellow "You won't have to Ctrl+C this because it won't run."
}

# This runs forever: press Ctrl+C in the terminal to stop it
while ($true)
{
    Write-Host -ForegroundColor Yellow 'You do need to Ctrl+C this because it will run.'
}

# Do While: the code runs at least once, even though the condition is false
do
{
    Write-Host -ForegroundColor White 'Your code will always run AT LEAST once.'
} while ($false)

# Do Until: the same, it runs once before the condition is checked
do
{
    Write-Host -ForegroundColor Yellow "You won't have to Ctrl+C this because it will only run once."
} until ($true)
#endregion

#region Slide 31 - For Loop
# For (Initialization; Condition; Repeat)
# {
#     PowerShell Code
# }
For ($i = 0; $i -lt 3; $i++)
{
    Write-Host "User $i"
}
#endregion

#region Slide 32 - Foreach Loop
# Foreach ($item in $collection)
# {
#     PowerShell Code
# }
$vars = 1, 2, 3
Foreach ($var in $vars)
{
    Write-Host "User $var"
}
#endregion

#region Slide 33 - Demonstration: For and Foreach Loops
# $i is the initialization, the test and the repeat
for ($i = 0; $i -lt 10; $i++)
{
    $i
}

# Get all services and loop through them
foreach ($service in Get-Service)
{
    Write-Output -InputObject $service.Name
}
#endregion

#region Slide 37 - Flow Control - Break
$user = 0
While ($user -lt 2)
{
   Write-Host "user$user"
   $user++
   If ($user -eq 1)
   {
      Break
   }
}
#endregion

#region Slide 38 - Flow Control - Continue
$user = 0
While ($user -lt 2)
{
   Write-Host "user $user"
   $user++
   If ($user -eq 1)
   {
      Continue
   }
   "processed user $user"
}
#endregion

#region Slide 39 - Flow Control - Return (repeated in functions)
Function AddFive
{
    param([int]$num)
    if($num -lt 0)
    {
        Return 0
    }
    $num + 5
}
AddFive 1
AddFive 5
AddFive -5
#endregion

#region Slide 40 - Exit
# Runs exit in a separate powershell.exe, so your session stays open
Set-Content -Path C:\Temp\ExitDemo.ps1 -Value 'exit 100'
powershell.exe -NoProfile -File C:\Temp\ExitDemo.ps1
$LASTEXITCODE
Remove-Item -Path C:\Temp\ExitDemo.ps1
#endregion

#region Slide 41 - Demonstration: Flow Control Keywords
# Break stops the whole switch, including the remaining items
$array = 'One', 'Two', 'Three'
switch ($array)
{
    'One'   { Write-Host $_; break }
    'Two'   { Write-Host $_; break }
    'Three' { Write-Host $_; break }
}

# Continue stops checking cases for this item and moves to the next item
$array = 'One', 'Two', 'Three'
switch ($array)
{
    'One'   { Write-Host $_; continue }
    'One'   { Write-Host $_; continue }
    'Two'   { Write-Host $_; continue }
    'Three' { Write-Host $_; continue }
}

# Return outputs everything, not just the value after it
function a
{
    'a'
    return 'b'
}
$result = a
$result

# A practical example of the same problem
function Get-FileContent
{
    param([String]$Path)
    $Content = [System.IO.File]::ReadAllLines($Path)
    "Done reading the content of length : $([System.Text.Encoding]::ASCII.GetBytes($Content).Length)"
    return $Content
}
$TestFile = New-Item -Path C:\Temp\M09-Test.txt -ItemType File -Force -Value 'This is the content of the file.'

# Run it and see the results
Get-FileContent -Path $TestFile.FullName

# What type of object is $Result?
$Result = Get-FileContent -Path $TestFile.FullName
$Result.GetType().FullName

# Clean up
Remove-Item -Path $TestFile.FullName
#endregion
