# Set the organization, project, and build ID
$organization = "myorg"
$project = "myproject"
$buildId = "123"

# Set the personal access token
$PAT = "abcdefghijklmnopqrstuvwxyz"

# Set the headers for the REST API call
$headers = @{
    "Authorization" = "Basic $(ConvertTo-Base64 -String "$($PAT):$($PAT)")"
}

# Set the REST API endpoint
$uri = "https://dev.azure.com/$organization/$project/_apis/build/builds/$buildId?api-version=6.0"

# Make the REST API call
$build = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# Get the build agent and agent pool
$buildAgent = $build.queue.name
$agentPool = $build.queue.pool.name

# Print the build agent and agent pool
Write-Output "Build agent: $buildAgent"
Write-Output "Agent pool: $agentPool"


#--------------------------

# Set the organization, project, and agent name
$organization = "myorg"
$project = "myproject"
$agentName = "myagent"

# Set the personal access token
$PAT = "abcdefghijklmnopqrstuvwxyz"

# Set the headers for the REST API call
$headers = @{
    "Authorization" = "Basic $(ConvertTo-Base64 -String "$($PAT):$($PAT)")"
}

# Set the REST API endpoint
$uri = "https://dev.azure.com/$organization/$project/_apis/build/builds?api-version=6.0&`$top=100&definitions=&reasonFilter=manual&resultFilter=succeeded&statusFilter=completed&queueTime=&finishTime=&requestedFor=&minTime=&maxTime=&agentName=$agentName"

# Make the REST API call to get the list of builds
$builds = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get

# Filter the list of builds by status and date
$previousBuilds = $builds.value | Where-Object {$_.status -eq "completed" -and $_.finishTime -lt $build.finishTime}
$followingBuilds = $builds.value | Where-Object {$_.status -eq "completed" -and $_.finishTime -gt $build.finishTime}

# Print the previous and following builds
Write-Output "Previous builds:"
$previousBuilds | Select-Object -Property id,finishTime | Format-Table
Write-Output "Following builds:"
$followingBuilds | Select-Object -Property id,finishTime | Format-Table



$url = "$($organizationUrl)/$($project)/_apis/build/builds?api-version=5.1&agentName=$($agentName)&$($pipelineCount)&resultFilter=succeeded,partiallySucceeded"
$pipelines = Invoke-RestMethod -Uri $url -Method Get -Headers $headers
