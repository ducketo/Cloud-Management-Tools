# This script needs to be run on the windows VM to apply configuration
#
$DNSName = $env:COMPUTERNAME
# Ensure PS Remoting is enabled
Enable-PSRemoting -Force
#Create Windows firewall rule
New-NetFirewallRule -Name "WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile "Any" -Action "Allow" -Direction "Inbound" -LocalPort 5986 -Protocol "TCP"
#Create self-signed certificate and store thumbprint
$thumbprint = (New-SelfSignedCertificate -DnsName $DNSName -CertStoreLocation Cert:\LocalMachine\My).Thumbprint 
#Run WinRM configuration on command line. DNS name set to computer hostname, you may wish 
$cmd = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$DNSName""; CertificateThumbprint=""$thumbprint""}"
cmd.exe /C $cmd
