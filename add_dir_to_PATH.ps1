# https://stackoverflow.com/a/38519670
function Log-Message
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$LogMessage
    )

    Write-Output ("{0} - {1}" -f (Get-Date), $LogMessage)
}



function Udf-GetDir
{
    # Get directory of current file 
    # [CmdletBinding()]
    # https://stackoverflow.com/a/53134449
    if ($MyInvocation.MyCommand.CommandType -eq "ExternalScript")
    { 
        $ScriptPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition 
        Log-Message $ScriptPath
        Log-Message "External"
    }
    else
    { 
        $ScriptPath = Split-Path -Parent -Path ([Environment]::GetCommandLineArgs()[0]) 
        if (!$ScriptPath){ $ScriptPath =  $(Get-Location)} 
    }
    return $ScriptPath
}

function Udf-AddDirToPath{
    # Add to system variable
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path
    )
    $PathArray = $env:Path.Split(";")
    $RegexStr = [Regex]::Escape($Path)
    $RegexStr = -join("$RegexStr", "\\?$")
    if ($PathArray -Match $RegexStr)
    {
        Log-Message "'$Path' found in `$env:Path."
        return
    }
    else 
    {
        Log-Message "'$Path' NOT found in `$env:Path."
        # https://stackoverflow.com/a/2571200
        # "Machine" => "User" to set User variables
        Log-Message "Adding $Path to `$env:Path."
        $NewPath = -join($env:Path, ";$(Udf-GetDir)")
        #Log-Message $NewPath
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "Machine")
        [Environment]::SetEnvironmentVariable("Path", $NewPath, "Process")
        #Log-Message "NEW Path: $env:Path"
        Log-Message "Reboot is required to update PATH."
    }

}

function Udf-RemoveDirFromPath
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Path
    )
    $PathArray = $env:Path.Split(";")
    $RegexStr = [Regex]::Escape($Path)
    $RegexStr = -join("$RegexStr", "\\?$")
    if ($PathArray -Match $RegexStr)
    {
        Log-Message "'$Path' found in `$env:Path."
        Log-Message "Removing $Path from `$env:Path."
        $Remove = $Path
        $newPath = ($env:Path.Split(';') | Where-Object -FilterScript {$_ -ne $Remove}) -join ';'
        Log-Message $newPath
        [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
        [Environment]::SetEnvironmentVariable("Path", $newPath, "Process")
        Log-Message "Reboot is required to update PATH."
    }
    else
    {
        Log-Message "'$Path' NOT found in `$env:Path."
        return

    }

}


# This file is intended to add the current directory 
# to the system variables (PATH).
# So must run in directory where the PATh need to be appeneded.
if ($(Udf-GetDir) -eq $pwd)
{
    Log-Message "Current File Directory MUST be same as Current Working Directory."
    Log-Message "Make sure to run this file in the corrrect directory."
    Log-Message "Current File Directory: $(Udf-GetDir)"
    Log-Message "Current Working Directory: $pwd"
    Exit 1
}


Udf-AddDirToPath($(Udf-GetDir))
#Udf-RemoveDirFromPath($(Udf-GetDir))
#Udf-RemoveDirFromPath("C:\Progr")
Log-Message "Delay for 5 seconds before exit."
Start-Sleep -s 5