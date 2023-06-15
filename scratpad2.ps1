# Define the source and target URLs for redirection
$sourceUrl = "http://localhost:8060"  # Change the URL as per your requirements
$targetUrl = "http://new-server.com"  # Change the URL to the server where you want to redirect the request

# Create a temporary applicationHost.config file
$configPath = [System.IO.Path]::GetTempFileName()
Copy-Item "$env:windir\system32\inetsrv\config\applicationHost.config" $configPath -Force

# Use appcmd to configure the redirection
Start-Process "$env:windir\system32\inetsrv\appcmd.exe" -ArgumentList "set config -section:system.webServer/rewrite/rules /+[name='RedirectRule',stopProcessing='True',patternSyntax='ECMAScript',matchUrl='^$',actionType='Redirect',redirectType='Found',targetUrl='$targetUrl']" -NoNewWindow -Wait
Start-Process "$env:windir\system32\inetsrv\appcmd.exe" -ArgumentList "set config -section:system.webServer/rewrite/allowedServerVariables /+[name='HTTP_X_ORIGINAL_URL',defaultValue='']" -NoNewWindow -Wait
Start-Process "$env:windir\system32\inetsrv\appcmd.exe" -ArgumentList "set config -section:system.webServer/rewrite/allowedServerVariables /+[name='HTTP_X_REWRITE_URL',defaultValue='']" -NoNewWindow -Wait
Start-Process "$env:windir\system32\inetsrv\appcmd.exe" -ArgumentList "set config -section:system.webServer/rewrite/globalRules /+[name='HandleIncomingRequests',patternSyntax='Wildcard',stopProcessing='True']" -NoNewWindow -Wait
Start-Process "$env:windir\system32\inetsrv\appcmd.exe" -ArgumentList "set config -section:system.webServer/rewrite/globalRules /+[name='HandleIncomingRequests',pattern='*']" -NoNewWindow -Wait
Start-Process "$env:windir\system32\inetsrv\appcmd.exe" -ArgumentList "set config -section:system.webServer/rewrite/globalRules /+[name='HandleIncomingRequests',pattern='*'] /commit:apphost" -NoNewWindow -Wait

# Delete the temporary applicationHost.config file
Remove-Item $configPath -Force
