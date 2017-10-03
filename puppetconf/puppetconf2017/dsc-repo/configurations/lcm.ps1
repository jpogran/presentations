[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'mofs', 'PullClientConfig'))
)

[DSCLocalConfigurationManager()]
configuration PullClientConfig
{
  Node $AllNodes.NodeName
  {
    Settings
    {
      RefreshMode          = 'Pull'
      RefreshFrequencyMins = 30
      RebootNodeIfNeeded   = $true
    }

    ConfigurationRepositoryWeb PULLSERVER
    {
      ServerURL       = $Node.PullServerUrl
      RegistrationKey = $Node.RegistrationKey
      ConfigurationNames = @('ExampleConfiguration')
    }

    ReportServerWeb ReportSrv
    {
      ServerURL = $Node.PullServerUrl
    }
  }
}

PullClientConfig  -ConfigurationData $configData -OutputPath $outputPath
