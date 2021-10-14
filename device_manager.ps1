#For formatting:
$result = @{Expression = {$_.Name}; Label = "Device Name"},
@{Expression = {$_.ConfigManagerErrorCode} ; Label = "Status Code" }

#Checks for devices whose ConfigManagerErrorCode value is greater than 0, i.e has a problem device.
$a = Get-WmiObject -Class Win32_PnpEntity -ComputerName localhost -Namespace Root\CIMV2 | Where-Object {$_.ConfigManagerErrorCode -gt 0 } | Format-Table $result -AutoSize
echo $a