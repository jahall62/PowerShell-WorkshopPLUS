<#
    M07 - Collections
    Windows PowerShell Foundation Skills - WorkshopPLUS
    Commands shown in the module slides. Select a line or block and press F8 to run it.
#>
return  # Prevents F5 from running the whole file. Use F8 on a selection.

#region Slide 7 - Creating arrays
$Array = 1, 5, 8, 'alpha', 'beta'
$Array
$Array = Get-ChildItem
$Array
#endregion

#region Slide 8 - Accessing Array Objects (Elements)
$Array = 1, 5, 8, 'alpha', 'beta'
$Array[0]
$Array[3]
$Array[0,3]
$Array[-1]
$Array[-3]
#endregion

#region Slide 9 - Working With Array Elements
$Array = Get-Service
$Array[1].Name
$i = 1
$Array[$i]
$Array[1].Name = 'NotAJRouter'
$Array[1].Name
$Array[$i].name
#endregion

#region Slide 11 - Array Members
$Array = 1, 2, 'Alpha', 'Beta'
$Array | Get-Member
$Array = 1, 2, 'Alpha', 'Beta'
Get-Member -InputObject $Array
#endregion

#region Slide 12 - Length and Count
$Array = 1, 2, 'Alpha', 'Beta'
$Array.Length
$Array.Count
#endregion

#region Slide 13 - 'Adding' Objects to an Array
$Array = 5, 8
$Array = $Array + 'Alpha'
$Array
$Array += 'Beta'
$Array
$Array.Add('Delta')
#endregion

#region Slide 14 - Sorting an array
$Array = 8, 1,'Beta', 5, 'Alpha'
$Array | Sort-Object
$Array = 3, 1, 5, 8, 2
[Array]::sort($Array)
$Array
#endregion

#region Slide 18 - Array Operators - 1
1..5
2..-2
$Array = 1,2,3,4,5,6
$Array[1..4]
#endregion

#region Slide 19 - Array Operators - 2
$Array = 'Doe','John',.35, 1234567.89123,(Get-Date)
"{1} {0}'s Salary: {3:C}" -f $Array
'{2:P} ; {3:N} ; {3:C} ; {4:dddd dd MM yyyy} ' -f $Array
#endregion

#region Slide 20 - Array Operators - 3
$Array = 2, 4, 6, 8, 10
$Array -contains 4
$Array -contains 3
$Array = 2, 4, 6, 8, 10
4 -in $Array
3 -in $Array
#endregion

#region Slide 21 - Array Operators - 4
'1-2-3-4-5' -split '-'
$Array = 2, 4, 6, 8, 10
$Array -join ':'
#endregion

#region Slide 26 - ArrayLists
$ArrayList = New-Object -TypeName [System.COllections.ArrayList]
[System.COllections.ArrayList]$ArrayList = @()
$ArrayList = [System.COllections.ArrayList](Get-Service)
$ArrayList[0]
$ArrayList.Add(100) # will return an Index
$ArrayList.Insert(2,'New String Object at Index 2')
#endregion

#region Slide 33 - Creating a Hash Table
$Hash = @{}
$Server = @{
      'HV-SRV-1' = '192.168.1.1'
      Memory = 64GB
      Serial = 'THX1138'
    }
$Server
#endregion

#region Slide 34 - Creating a Hash Table - Alternate methods
# Read in content of file as One String (-Raw)
$KeyValuePairs = Get-Content -Path .\EnglishGerman.txt -Raw
$KeyValuePairs
ConvertFrom-StringData -StringData $KeyValuePairs
# Get a collection of all Services registerd on current machine
$Services = Get-Service -Name *
# Group-Object only works with Pipeline input. Groups all Services based on their
# current Status Property and create a Key of type String
$Services | Group-Object -Property Status -AsHashTable -AsString
# Look at the content of the the PSD1 file
Get-Content -Path .\EnglishSpanish.psd1
# Read a PowerShell data file (.psd1) containing hashtable syntax
Import-PowerShellDataFile -Path .\EnglishSpanish.psd1
#endregion

#region Slide 37 - Access Hash Table Items
$Server
$Server['Serial']
$Server.Serial
$Server.'HV-SRV-1'
#endregion

#region Slide 38 - Access Hash Table Item's Properties - Examples
$ComputerInfo = @{
    Name = 'MyComputer'
    Drives = 'A','B','C'
    Services = Get-Service
}
# Length of the String
$ComputerInfo['Name'].length
# 2nd Object in the Drives Array
$ComputerInfo['Drives'][1]
# 3rd Object in Service Array's Name
$ComputerInfo['Services'][2].Name
$ComputerInfo = @{
    Name = 'MyComputer'
    Drives = 'A','B','C'
    Services = Get-Service
}
# Length of the String
$ComputerInfo.Name.length
# 2nd Object in the Drives Array
$ComputerInfo.Drives[1]
# 3rd Object in Service Array's Name
$ComputerInfo.Services[2].Name
#endregion

#region Slide 39 - Adding Items To a Hash Table
# Add or set key-value pair
$Server['CPUCores'] = 4
# This will either add OR replace
$Server.Drives = 'C', 'D', 'E'
# Add String Key and Numeric Value
$Server.Add('HotFixCount', 4)
# Remove a key-value pair
$Server.Remove('HotFixCount')
# Clear all key-values
$Server.Clear()
#endregion

#region Slide 40 - Common Hash Table Members
$Server.Keys
$Server.ContainsKey('Serial')
$Server.Count
$Server.Values
$Server.ContainsValue('THX1138')
$Server.ContainsValue('FAKE')
#endregion

#region Slide 41 - Sorting HashTable - GetEnumerator
$Server = @{
      'HV-SRV-1' = '192.168.1.1'
      Memory = 64GB
      Serial = 'THX1138'
    }
$Server.GetEnumerator() | ConvertTo-CSV
#endregion

#region Slide 44 - Calculated Properties
$Process = Get-Process -ID $PID
# Special HashTable with Keys: Name and Expression
$PropertyNameValueHastTable = @{
    # Value is the 'Name' of the new property
    Name = 'ThreadNumber'
    # Value is the Expression result, which is assigned to new property 'ThreadNumber'
    Expression = {$Process.threads.Count}
}
# Add New Property to Object by passing in this special HashTable containing Name and Value
Format-Table -InputObject $Process -Property Name,$PropertyNameValueHastTable,ID
#endregion

#region Slide 45 - Custom Object Creation
$CompInfo = [PSCustomObject]@{
    ComputerName   = $env:Computername
    Domain         = $env:USERDNSDOMAIN
    WiFiMacAddress = (Get-NetAdapter -name 'Wi-Fi').MacAddress
    DiskSizeGB     = (Get-Disk).size
    DateChecked    = Get-Date
}
$CompInfo
#endregion

#region Slide 46 - Splatting
Send-MailMessage -To Admin@Contoso.com -From Alerts@Contoso.com -SmtpServer smtp.contoso.com -Subject 'Warning'
# HashTable: Each Key represents a ParameterName and Value an Argument
$Email = @{
    To = 'Admin@contoso.com'
    From = 'Alerts@Contoso.com'
    SmtpServer = 'Smtp.contoso.com'
}
Send-MailMessage @Email -Subject 'Warning'
#endregion
