#Required SysInternal's Handle utility

$Processes = Get-Process

$results = $Processes | Foreach-Object {
    $handles = (handle64 -p $_.ID -NoBanner) | Where-Object { $_ -Match " File " } | Foreach-Object {
            [PSCustomObject]@{
        "Hex"  = ((($_ -Split " ").Where({ $_ -NE "" })[0]).Split(":")[0]).Trim()
        "File" = (($_ -Split " ")[-1]).Trim()
        }
    }

    If ( $handles ) {
        [PSCustomObject]@{
            "Name"    = $_.Name
            "PID"     = $_.ID
            "Handles" = $handles
        }
    }
}

$results | Where-Object Name -EQ 'Notepad' | Where-Object { $_.Handles.File -Match "test.txt" }
