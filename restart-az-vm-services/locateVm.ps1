Import-Module "$pwd\src\restart-az-vm-services.psm1" -Force

$vmName = 'demoinnov2'
$vmIpAddress = ''

Get-MatchingVmIds -vmName $vmName -vmIpAddress $vmIpAddress