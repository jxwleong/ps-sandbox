# Ref
# requires -Version 2
function Show-Process($Process, [Switch]$Maximize)
{
  $sig = '
    [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hwnd);
  '
  
  if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
  $type = Add-Type -MemberDefinition $sig -Name WindowAPI -PassThru
  $hwnd = $process.MainWindowHandle
  $null = $type::ShowWindowAsync($hwnd, $Mode)
  $null = $type::SetForegroundWindow($hwnd) 
}

Show-Process -Process (Get-Process -Id $PID) -Maximize

$notepad = Start-Process -FilePath  notepad.exe -PassThru
Write-Output "`$p.MainWindowHandle: $($notepad.MainWindowHandle)"
Start-Sleep 5
#$fw =  (Get-Process powershell).MainWindowHandle
#[SFW]::SetForegroundWindow($fw)
Show-Process -Process $notepad

# Info about the parameter for SendKeys
# https://docs.microsoft.com/en-us/previous-versions/office/developer/office-xp/aa202943(v=office.10)?redirectedfrom=MSDN
$wshell = New-Object -ComObject wscript.shell;
$wshell.SendKeys('%h')
$wshell.SendKeys('{UP}')
$wshell.SendKeys('{ENTER}')
Start-Sleep 1
$wshell.SendKeys('{ENTER}')

