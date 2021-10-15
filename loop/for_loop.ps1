# Reference: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_for?view=powershell-7.1
for($i=1; $i -le 10; $i++)
{
    Write-Host $i
}


# One-liner
Write-Host "`nOne-liner for loop"
for ($i = 0; $i -lt 10; $i++) { Write-Host $i }

# Muitple assingment
Write-Host "`nMultiple assignment"
for (($i = 0), ($j = 0); $i -lt 10 -and $j -lt 10; $i++,$j++)
{
    "`$i:$i"
    "`$j:$j"
}