## initial setup config data
$dscRepoPath = 'c:\vagrant\dsc-repo'

# Your Production DSC Configuration Data (can seperate environments this way)
$configData = ([IO.Path]::Combine($dscRepoPath, 'data', 'production.psd1'))

# Install required DSC Resources to Pull Server for distribution
$modules = @('xWebAdministration', 'xPSDesiredStateConfiguration')
$modules | ForEach-Object {
  if (!(Get-Module -Name $_ -List)) {
    Install-Package -Name $_ -Force -ForceBootStrap
  }
}
# Compile DSC Pull Server DSC Configuration script, then install
$outputPath = ([IO.Path]::Combine($dscRepoPath, 'mofs', 'PullServer'))
c:\vagrant\dsc-repo\configurations\pullserver.ps1 `
      -ConfigData $configData `
      -OutputPath $outputPath
Start-DscConfiguration -Path $outputPath -Wait -Verbose -Force

# Compile DSC LCM Settings and deploy to pullserver and dsc-agent
$outputPath = ([IO.Path]::Combine($dscRepoPath, 'mofs', 'PullClientConfig'))
c:\vagrant\dsc-repo\configurations\lcm.ps1 `
      -ConfigData $configData `
      -OutputPath $outputPath
Set-DscLocalConfigurationManager -Path $outputPath -Verbose

# Compile Example DSC Configuration that will be deployed to target nodes
$outputPath = ([IO.Path]::Combine($dscRepoPath, 'mofs', 'SetupTheSite'))
c:\vagrant\dsc-repo\configurations\example_configuration.ps1 `
      -ConfigData $configData `
      -OutputPath $outputPath

# We're using Named Configurations in our DSC PullServer, so rename the MOF
$outputPath = [IO.Path]::Combine($dscRepoPath, 'mofs', 'SetupTheSite')
if (Test-Path (Join-Path $($outputPath) 'ExampleConfiguration.mof')) {
  rm (Join-Path $($outputPath) 'ExampleConfiguration.mof')
}
Rename-Item -Path (Join-Path $($outputPath) 'dsc-agent.mof') -NewName 'ExampleConfiguration.mof'

# Import the PublishModulesAndMofsToPullServer module so we can package the
# DSC Resources and compiled MOFs, then deploy to the Pull Server
Import-Module -Name "$($env:ProgramFiles)\WindowsPowerShell\Modules\xPSDesiredStateConfiguration\7.0.0.0\DSCPullServerSetup\PublishModulesAndMofsToPullServer.psm1"
$moduleList = @("xWebAdministration", "xPSDesiredStateConfiguration")
Publish-DSCModuleAndMOF -Source $outputPath -ModuleNameList $moduleList

# Show completed deployment
ls "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
ls "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
