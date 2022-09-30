If you'd like to retrieve your certificate along with its private key, then you can export it to a PFX file (with an empty password) on your disk via:

$vaultName = "my-vault-name"
$certificateName = "my-cert-name"
$pfxPath = [Environment]::GetFolderPath("Desktop") + "\$certificateName.pfx"

$pfxSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $certificateName
$pfxUnprotectedBytes = [Convert]::FromBase64String($pfxSecret.SecretValueText)
[IO.File]::WriteAllBytes($pfxPath, $pfxUnprotectedBytes)
If you'd like to view just the private key itself in-memory without writing to disk, then try:

$vaultName = "my-vault-name"
$certificateName = "my-cert-name"
$pfxPath = [Environment]::GetFolderPath("Desktop") + "\$certificateName.pfx"

$pfxSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $certificateName
$pfxUnprotectedBytes = [Convert]::FromBase64String($pfxSecret.SecretValueText)
$pfx = New-Object Security.Cryptography.X509Certificates.X509Certificate2
$pfx.Import($pfxUnprotectedBytes, $null, [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$pfx.PrivateKey.ExportParameters($true)
which will show the private parameters in addition to the exponent and modulus.

If you'd like to protect the PFX file on disk with your own password (as per the "Retrieve pfx file & add password back" instructions in this blog post), then try:

$vaultName = "my-vault-name"
$certificateName = "my-cert-name"
$pfxPath = [Environment]::GetFolderPath("Desktop") + "\$certificateName.pfx"
$password = "my-password"

$pfxSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $certificateName
$pfxUnprotectedBytes = [Convert]::FromBase64String($pfxSecret.SecretValueText)
$pfx = New-Object Security.Cryptography.X509Certificates.X509Certificate2
$pfx.Import($pfxUnprotectedBytes, $null, [Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$pfxProtectedBytes = $pfx.Export([Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $password)
[IO.File]::WriteAllBytes($pfxPath, $pfxProtectedBytes)
