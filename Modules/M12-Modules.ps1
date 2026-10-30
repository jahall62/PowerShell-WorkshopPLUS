<#
    M12 - Modules
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 6 - Using Modules
Get-Module
(Get-module -ListAvailable).count
#endregion

#region Slide 7 - Module Autoloading - Example
Get-Module
(Get-Command -Module BitLocker).Name
Get-Module
#endregion

#region Slide 8 - Browsing Module Commands
Get-Command -Module BitLocker | Select-Object CommandType, Name
#endregion

#region Slide 9 - Explicitly Importing Modules
Get-Module Pester -ListAvailable
Import-Module Pester -Version 4.8.0
#endregion

#region Slide 15 - Creating Custom Modules
Import-Module -Name C:\MyModule\MyModule.psm1
Get-Module
Get-CustomHello
#endregion
