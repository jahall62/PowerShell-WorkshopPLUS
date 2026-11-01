<#
    M03 - Help
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 6 - Using Get-Help
Get-Help Get-ChildItem
#or
Get-ChildItem -?
#endregion

#region Slide 8 - Help for a specific parameter
Get-Help Get-Counter -Parameter Counter
#endregion

#region Slide 11 - Demonstration: Get Help
Get-Help Get-ChildItem
Get-Help Get-Counter -Parameter Counter
Get-Command Get-Counter -Syntax
Get-Help Get-ChildItem -Examples
# Pages the output: Space = next page, Enter = next line, Q = quit
help Get-ChildItem
#endregion

#region Slide 17 - Concept Help in the Console
Get-Help about_
#endregion

#region Slide 19 - Demonstration: Help About General Topics
Get-Help about_*
Get-Help about_Variables
# Opens a separate window
Get-Help about_Objects -ShowWindow
Get-Help about_*array*
#endregion

#region Slide 23 - Update-Help Diagram (Internet Connected)
Update-Help
#endregion

#region Slide 26 - Update-Help Diagram (No internet)
Save-Help -DestinationPath \Share
Update-Help -SourcePath \Share
#endregion
