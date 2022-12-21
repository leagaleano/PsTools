# Set the file paths for the two files you want to compare
$file1 = 'C:\path\to\file1.txt'
$file2 = 'C:\path\to\file2.txt'

# Read the contents of the two files into variables
$contents1 = Get-Content $file1
$contents2 = Get-Content $file2

# Compare the contents of the two files
$diff = Compare-Object $contents1 $contents2

# Output the differences between the two files
$diff | ForEach-Object {
    if ($_.SideIndicator -eq '=>') {
        Write-Host "$($_.InputObject) was added to $file2"
    } elseif ($_.SideIndicator -eq '<=') {
        Write-Host "$($_.InputObject) was removed from $file2"
    } else {
        Write-Host "$($_.InputObject) was changed in $file2"
    }
}

