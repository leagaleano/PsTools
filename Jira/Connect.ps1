$user = 'username'
$pass = 'password'

$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
 Authorization = $basicAuthValue
}
Invoke-WebRequest -Uri 'https://<jira_base_url>/rest/api/2/search?jql=project = CIT AND issuetype = "JIRA Request" AND (created >= startOfDay(-30d) OR updated >= startOfDay(-30d))' `
-Headers $Headers
