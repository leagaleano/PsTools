$filePath='c:\temp\test.docx'
 
function removeFileLocks($filePath){
    function isFileLocked ($filePath){
        $fileName=Split-Path $filePath -leaf
        $file=New-Object System.IO.FileInfo $filePath
         
        function includeHandle{
            try{
                if (!(Get-Command handle.exe -ErrorAction SilentlyContinue)) {
                    if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
                    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
                    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))    
                    }
                    try{
                        choco install handle -y -force --ignore-checksums
                    }catch{
                        choco install systernals -y -force --ignore-checksums
                    }
                }
                if ((Get-Command handle.exe -ErrorAction SilentlyContinue)) {
                    return $true
                }else{
                    return $false
                }
            }catch{
                write-warning $_
                return $false
            }
        }
 
        if ((Test-Path -Path $filePath) -eq $false) {
            write-host "'$filePath' is unreachable."
            return $false
        }
         
        try {
            $exclusiveLock=$file.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
            if ($exclusiveLock) {
                $exclusiveLock.Close()
                write-host "No locks found."
            }
            return $true
        }catch{
            if(includeHandle){
                $handles=handle $fileName
                $pidRegex='pid: (\d+)'
                $pids=$handles|%{try{[regex]::Match($_,$pidRegex).captures.groups[1].value}catch{}}|Select-Object -Unique
                write-warning "$filePath is currently locked by process ID(s): $pids"
                return $pids
            }else{
                write-warning "$filePath is currently locked by a process, but handles.exe isn't available."
                return $true
            }
        }
    }
    try{
        $lockingPids=isFileLocked $filePath
        if($lockingPids -eq $true){
            write-host "No actions required."
            return $true
        }elseif($lockingPids){
            $lockingpids|ForEach-Object{stop-process -id $_ -force}
            write-host "Program has removed $filePath locking PIDs: $lockingPids" -ForegroundColor Green
            return $true
        }else{
            write-host "$filePath has no locks." -ForegroundColor Green
            return $false
        }
    }catch{
        write-warning $_
        return $false
    }
}
 
removeFileLocks $filePath
