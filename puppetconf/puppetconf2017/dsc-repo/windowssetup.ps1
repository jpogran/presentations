Set-NetFirewallProfile -All -Enabled false
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value * -Force

$mypwd = ConvertTo-SecureString -String "1234" -Force -AsPlainText
Import-PfxCertificate -FilePath 'C:\vagrant\dsc-repo\keys\dscpfx.pfx' `
                    -CertStoreLocation Cert:\LocalMachine\My `
                    -Password $mypwd

choco install -y visualstudiocode

mkdir "$($env:APPDATA)\Code\User"
cp 'c:\vagrant\vagrantconfig\vscode.json' `
  "$($env:APPDATA)\Code\User\settings.json"
