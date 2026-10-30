<#
    M13 - Remoting Basics
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 10 - Types of Remoting
Get-Command -ParameterName ComputerName -Module Microsoft.PowerShell.Management
#endregion

#region Slide 11 - Native OS Remoting
Get-Service -Computername DC
#endregion

#region Slide 14 - Enter-PSSession
$env:COMPUTERNAME
Enter-PSSession -ComputerName MS
$env:COMPUTERNAME
Exit-PSSession
$env:COMPUTERNAME
#endregion

#region Slide 15 - Invoke-Command
Invoke-Command -ComputerName MS,DC,Win10 -ScriptBlock {Get-Culture}
#endregion

#region Slide 16 - Using Alternate Credentials
Invoke-Command -ComputerName MS -ScriptBlock {$env:USERNAME} -Credential CONTOSO\Administrator
$Creds = Get-Credential
Invoke-Command -ComputerName MS -ScriptBlock {$env:USERNAME} -Credential $Creds
#endregion

#region Slide 17 - Invoke-Command with Script Files
Invoke-Command -ComputerName MS, DC -FilePath C:\MyScript.ps1
#endregion

#region Slide 18 - Data Serialization
Invoke-Command -ComputerName MS -ScriptBlock {Get-Service} | GM
#endregion

#region Slide 21 - Using Persistent Sessions
$Session = New-PSSession -ComputerName MS
Invoke-Command -Session $Session -ScriptBlock {$Var = 123}
Invoke-Command -Session $Session -ScriptBlock {$Var}
#endregion
