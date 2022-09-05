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


Get-Content "ServerList.txt" | %{

  # Define what each job does
  $ScriptBlock = {
    param($pipelinePassIn) 
    Test-Path "\\$pipelinePassIn\c`$\Something"
    Start-Sleep 60
  }

  # Execute the jobs in parallel
  Start-Job $ScriptBlock -ArgumentList $_
}

Get-Job

# Wait for it all to complete
While (Get-Job -State "Running")
{
  Start-Sleep 10
}

# Getting the information back from the jobs
Get-Job | Receive-Job
