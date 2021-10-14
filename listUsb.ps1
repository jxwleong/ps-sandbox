# Reference: https://winaero.com/how-to-find-and-list-connected-usb-devices-in-windows-10/#Find_and_List_Connected_USB_Devices_in_Windows_10
Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }

echo "`nClass = USB"
Get-PnpDevice -PresentOnly | Where-Object { $_.Class -match 'USB' }

echo "`nFriendlyName = USB"
Get-PnpDevice -PresentOnly | Where-Object { $_.Class -match 'USB' }

$USB_List = Get-PnpDevice -PresentOnly | Where-Object { $_.Class -match 'USB' }

echo "`n`n"
#echo $USB_List.GetType()
foreach ($USB in $USB_List)
{
    $USB
}
