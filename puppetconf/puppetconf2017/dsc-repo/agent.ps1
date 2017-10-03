## initial setup config data
$dscRepoPath = 'c:\vagrant\dsc-repo'

# Your Production DSC Configuration Data (can seperate environments this way)
$configData = ([IO.Path]::Combine($dscRepoPath, 'data', 'production.psd1'))

# Compile DSC LCM Settings and deploy to pullserver and dsc-agent
$outputPath = ([IO.Path]::Combine($dscRepoPath, 'mofs', 'PullClientConfig'))
c:\vagrant\dsc-repo\configurations\lcm.ps1 `
  -ConfigData $configData `
  -OutputPath $outputPath
Set-DscLocalConfigurationManager -Path $outputPath -Verbose
