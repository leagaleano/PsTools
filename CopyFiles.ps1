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
