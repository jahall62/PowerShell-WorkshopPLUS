<#
    M05 - PowerShell Providers
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 11 - Exploring Providers
Get-PsProvider
#endregion

#region Slide 13 - Navigating between provider and Paths
Set-Location C:\Windows
Set-Location HKLM:\Software
Set-Location Cert:\LocalMachine
Set-Location Env:\
#endregion

#region Slide 15 - Creating New Drives (mounting to new root)
New-PSDrive -Name MyDocs -PSProvider FileSystem -Root $Home
#endregion

#region Slide 16 - Non-Hierarchical Providers
# $<DriveName>:<ItemName>
$Env:COMPUTERNAME
$Alias:Dir
#endregion
