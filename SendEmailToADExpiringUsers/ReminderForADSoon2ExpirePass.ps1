#Author: Leandro Galeano - leandro.galeano@live.com - https://www.linkedin.com/in/leandro-galeano/
#User running the script must have permissions to read AD. Other users are defined below
#Mail property must be populated into AD, as it's where the account's e-amail address is taken for sending the alert

#Common Section. DO NOT MODIFY
Import-Module ActiveDirectory
$MaxPwdAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
$expiredDate = (Get-Date).addDays(-$MaxPwdAge)
$ExpiredUsers = Get-ADUser -Filter {(PasswordLastSet -gt $expiredDate) -and (PasswordNeverExpires -eq $false) -and (Enabled -eq $true)} -Properties PasswordNeverExpires, PasswordLastSet, Mail | select samaccountname, mail, PasswordLastSet, @{name = "DaysUntilExpired"; Expression = {$_.PasswordLastSet - $ExpiredDate | select -ExpandProperty Days}} | Sort-Object PasswordLastSet

#Variables. Modify before use
$DaysThreshold = 10 #Days before password expiration.
$SmtpServerName = "" #Default for Office 365 users: smtp.office365.com
$SmtpServerPort = 587 #Deafult for Office 365 accounts: 587
$SenderAddress = "" #E-mail address from which remainder will be sent
$SenderAccount = "" #E-mail account Username
$SenderPassword = "" #E-mail account Password
$ReportTo = "" #Who should receive the report on the users
$ReportCC = "" #Who should be CCed in the report
$CompanyName = ""
$HTML_Link2PassReset = "<a href='https://sts.microsoft.com/adfs/portal/updatepassword/'>Self-Service password reset tool</a>" #If your company has SSO, AzureAD Self-Service password reset or any other tool alike, this will be sent for a quick help to the user

#Main section
$SenderAccountPass = ConvertTo-SecureString $SenderPassword -AsPlainText -Force 
$PsCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($SenderAccount, $SenderAccountPass)

Foreach ($ExpiredUser in $ExpiredUsers) {
	If ($ExpiredUser.DaysUntilExpired -le $DaysThreshold) {
		#If ($ExpiredUser.samaccountname -eq "TestAccount") { #Uncomment for testing this script with just a single account, usefull for debugging
			$ExpiredUser
			$Subject = "Your password will expire in " + $ExpiredUser.DaysUntilExpired + " day(s)!"
			$Body = "Dear user, <br> Please consider changing your password as soon as possible to retain access to $CompanyName's systems. You can do so by using the following tool: $HTML_Link2PassReset <br>Thanks in advance. <br> Support Team"
			Send-MailMessage -To $ExpiredUser.mail -From $SenderAddress -Subject $Subject -Body $Body -Credential ($PsCred) -SmtpServer $SmtpServerName -Port $SmtpServerPort -useSSL -BodyAsHtml
		#} #Uncomment for testing this script with just a single account
	}	
}

$HTMLReport = $ExpiredUsers | ConvertTo-HTML | Out-String
Send-MailMessage -To $ReportTo -Cc $ReportCC -From $SenderAddress -Subject "Users with password expiring soon | Only those under $DaysThreshold days get a notification" -Body $HTMLReport -Credential ($PsCred) -SmtpServer $SmtpServerName -Port $SmtpServerPort -useSSL -BodyAsHtml
