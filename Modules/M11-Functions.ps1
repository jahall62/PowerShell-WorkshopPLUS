<#
    M11 - Functions
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 6 - What Does a Function Look Like?
Function Write-Statement
{
  Write-Host "Hello world!" -ForegroundColor Green
}
Write-Statement
#endregion

#region Slide 7 - Creating a Function
Function Write-ServiceStatus
{
  $SVC = Get-Service -Name WinRM
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is currently $Status" -ForegroundColor Green
}
Write-ServiceStatus
#endregion

#region Slide 8 - Named Blocks in Functions
Get-EventLog -LogName Application -Newest 5 | My-Function
Function My-Function
{
  Begin
  {
    Remove-Item .\Log.txt
    Write-Host "Start" -ForegroundColor Green
  }
  Process
  {
    $_.Message | Out-File -Filepath Log.txt -Append
  }
  End
  {
    Write-Host "End" -ForegroundColor Red
    notepad.exe Log.txt
  }
}
#endregion

#region Slide 9 - Clean block - before
Function My-Function
{
  Begin
  {
    Connect-ExchangeOnline
  }
  Process
  {
    Get-mailbox -ResultSize Unlimited |
    Out-File -Filepath Log.txt
  }
  End
  {
    Write-Host "End" -ForegroundColor Green
    notepad.exe Log.txt
    Disconnect-ExchangeOnline
  }
}
#endregion

#region Slide 10 - Clean block - better
Function My-Function
{
  Begin
  {
    Connect-ExchangeOnline
  }
  Process
  {
    Get-mailbox -ResultSize Unlimited |
    Out-File -Filepath Log.txt
  }
  End
  {
    Write-Host "End" -ForegroundColor Green
    notepad.exe Log.txt
  }
  clean
    {
    Disconnect-ExchangeOnline
  }
}
#endregion

#region Slide 14 - Add Parameters to a Function
Function Write-Statement
{
  Param($Statement)
  Write-Host $Statement -ForegroundColor Green
}
Write-Statement -Statement 'Hello World!'
#endregion

#region Slide 15 - Default Parameter Values
Function Write-Green
{
  Param($Statement = 'Good morning!')
  Write-Host $Statement -ForegroundColor Green
}
Write-Green
Write-Statement -Statement 'Hello World!'
#endregion

#region Slide 16 - Adding Multiple Parameters
Function Write-ServiceStatus
{
  Param ($ServiceName,
         $OutputColor = 'Green')
  $SVC = Get-Service -Name $ServiceName
  $Name = $SVC.DisplayName
  $Status = $SVC.Status
  Write-Host "The Service $Name is '$Status'" -ForegroundColor $OutputColor
}
Write-ServiceStatus  -Service WinRM -Color Yellow
#endregion

#region Slide 22 - Script Blocks
$ScriptBlock = {Get-Service -Name WinRM}
$ScriptBlock
#endregion

#region Slide 23 - Invoking Script Blocks
$ScriptBlock = { Get-Service -Name WinRM }
Invoke-Command -ScriptBlock $ScriptBlock
$ScriptBlock.Invoke()
#endregion

#region Slide 24 - Using Script Blocks
Measure-Command -Expression {Get-Process}
#endregion
