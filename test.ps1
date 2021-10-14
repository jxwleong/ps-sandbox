Enum VirtualKeyCode
{
    ARROW_UP = 38
    ARROW_DOWN = 40
    ENTER = 13
}

class Menu
{
    [String]$MenuTitle
    [array]$MenuOptions
    [int]$MaxValue = $MenuOptions.count-1
    [int]$Selection = 0
    [bool]$EnterPressed = $False
    [int]$Timeout = 5
}

function Invoke-UdfCountdownWithMessage
{
    [CmdletBinding()]
        param (
              [string]$message = "Countdown: ",
              [int]$seconds = 5
        )
    do {
        Write-Host -NoNewline `r"$message$seconds"
        Sleep 1
        $seconds--
    } while ($seconds -gt 0)
}


function Invoke-UdfDisplayMenu
{
    [CmdletBinding()]
        Param(
            [Parameter(Mandatory=$True)][Menu]$MenuData
        )
    Clear-Host
    # Wrap "$($var)" to prevent it print out the $var as string
    # Just a way to escape it
    Write-Host "$($MenuData.MenuTitle)"

    For ($i=0; $i -le $MenuData.MaxValue; $i++){
        If ($i -eq $MenuData.Selection){
            Write-Host -BackgroundColor Cyan -ForegroundColor Black "[ $($MenuData.MenuOptions[$i]) ]"
        } Else {
            Write-Host "  $($MenuData.MenuOptions[$i])  "
        }
    }
}

# https://community.spiceworks.com/scripts/show/4656-powershell-create-menu-easily-add-arrow-key-driven-menu-to-scripts
function Invoke-UdfCreateMenu 
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions
    )
    $NewMenu = New-Object Menu
    $NewMenu.MenuTitle = $MenuTitle
    $NewMenu.MenuOptions = $MenuOptions
    $NewMenu.EnterPressed = $False

    While($NewMenu.EnterPressed -eq $False`
          -and $NewMenu.Timeout -gt 0){
        Invoke-UdfDisplayMenu -MenuData $NewMenu
        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode
        Write-Host $KeyInput
        If ($NewMenu.Timeout -eq 0){
            Return $NewMenu.Selection
            Clear-Host                   
        }
        Switch($KeyInput){
            $([VirtualKeyCode]::ENTER.value__){
                $NewMenu.EnterPressed = $True
                Return $NewMenu.Selection
                Clear-Host
                break
            }

            $([VirtualKeyCode]::ARROW_UP.value__){
                If ($NewMenu.Selection -eq 0){
                    $NewMenu.Selection = $NewMenu.MaxValue
                } Else {
                    $NewMenu.Selection -= 1
                }
                break
            }

            $([VirtualKeyCode]::ARROW_DOWN.value__){
                If ($NewMenu.Selection -eq $NewMenu.MaxValue){
                    $NewMenu.Selection = 0
                } Else {
                    $NewMenu.Selection +=1
                }
                break
            }
            #Default{
            #    Write-Host "HAHAHAHHA"
            #    Clear-Host
            #    break
            #}
        }
        Write-Host -NoNewline `r"$message$($NewMenu.Timeout)"
        Sleep 1
        $NewMenu.Timeout--
        Clear-Host
    }
}

#Invoke-UdfCountdownWithMessage -seconds 1
$MenuSelection = Invoke-UdfCreateMenu "Bank" "PBE", "OCBC"
if ($MenuSelection -eq 0) 
{
    start https://www.pbebank.com/
    exit
}