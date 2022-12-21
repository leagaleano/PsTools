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
    # Determine the line number for the difference
    if ($_.SideIndicator -eq '=>') {
        $lineNumber = $contents2.IndexOf($_.InputObject) + 1
        Write-Host "Line $lineNumber: [extra line in file2] $($_.InputObject)"
    } elseif ($_.SideIndicator -eq '<=') {
        $lineNumber = $contents1.IndexOf($_.InputObject) + 1
        Write-Host "Line $lineNumber: [missing line in file2] $($_.InputObject)"
    } else {
        $lineNumber1 = $contents1.IndexOf($_.InputObject) + 1
        $lineNumber2 = $contents2.IndexOf($_.InputObject) + 1
        Write-Host "Line $lineNumber1: [missing line in file2] $($_.InputObject)"
        Write-Host "Line $lineNumber2: [extra line in file2] $($_.InputObject)"
    }
}

