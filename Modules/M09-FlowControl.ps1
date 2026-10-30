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
