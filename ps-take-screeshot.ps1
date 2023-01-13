$Path = "C:\PS-Screenshot $(get-date -f 'yyyy-MM-dd-HHmmss').png
Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap -ArgumentList (Get-CimInstance -ClassName Win32_VideoController).CurrentHorizontalResolution, (Get-CimInstance -ClassName Win32_VideoController).CurrentVerticalResolution
$graphics = [System.Drawing.Graphics]::FromImage($bmp)
$graphics.CopyFromScreen((New-Object System.Drawing.Point(0,0)), (New-Object System.Drawing.Point(0,0)), $bmp.Size)
$bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
