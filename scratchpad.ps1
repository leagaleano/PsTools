$diff = Compare-Object (Get-Content "C:\file1.txt") (Get-Content "C:\file2.txt")
$diff | Where-Object {$_.SideIndicator -eq "<="}
$diff | Where-Object {$_.SideIndicator -eq "<="} | Format-List
