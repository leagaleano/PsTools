 $DestinationFolder = "D:\test\upload"
 If (-not (Test-Path $DestinationFolder) ) {
     New-Item -ItemType Directory -Force -Path $DestinationFolder
 }
 $EarliestModifiedTime = (Get-Date).AddDays(-1).Date     # 12AM yesterday
 $LatestModifiedTime = (Get-Date).Date                   # 12AM today
 Get-ChildItem "D:\test\*.*" -File |
     ForEach-Object {
         if ( ($_.CreationTime -ge $EarliestModifiedTime) -and ($_.CreationTime -lt $LatestModifiedTime) ){   # i.e., all day yesterday
             Copy-Item $_ -Destination $DestinationFolder
             Write-Host "Copied $_"
         }
         else {
             Write-Host "Not copying $_"
         }
     }


$ScriptBlock = {
   Param ($ComputerName)
   Write-Output $ComputerName
   #your processing here...
}

$runspacePool = [RunspaceFactory]::CreateRunspacePool(1, $MaxThreads)
$runspacePool.Open()
$jobs = @()

#queue up jobs:
$computers = (Get-ADDomainController -Filter *).Name
$computers | % {
    $job = [Powershell]::Create().AddScript($ScriptBlock).AddParameter("ComputerName",$_)
    $job.RunspacePool = $runspacePool
    $jobs += New-Object PSObject -Property @{
        Computer = $_
        Pipe = $job
        Result = $job.BeginInvoke()
    }
}

# wait for jobs to finish:
While ((Get-Job -State Running).Count -gt 0) {
    Get-Job | Wait-Job -Any | Out-Null
}

# get output of jobs
$jobs | % {
    $_.Pipe.EndInvoke($_.Result)
}
