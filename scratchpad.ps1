$file1 = Get-Content "C:\path\to\file1.txt"
$file2 = Get-Content "C:\path\to\file2.txt"

# Create a two-row table to display the differences
$table = @()
$table += New-Object psobject -Property @{ File1 = $file1 }
$table += New-Object psobject -Property @{ File2 = $file2 }

# Display the table
$table | Format-Table
