[CmdletBinding()]
param(
  $configData,
  $outputPath = ([IO.Path]::Combine($PSScriptRoot, 'mofs', 'PullServer'))
)

configuration PullServer
{
  Import-DSCResource -ModuleName PSDesiredStateConfiguration
  Import-DSCResource -ModuleName xPSDesiredStateConfiguration

  Node $AllNodes.Where( { $_.Roles -contains 'PullServer'}).NodeName
  {
    WindowsFeature DSCServiceFeature
    {
      Ensure = 'Present'
      Name   = 'DSC-Service'
    }

    xDscWebService PSDSCPullServer
    {
      Ensure                   = 'Present'
      State                    = 'Started'
      EndpointName             = $Node.PullServer.EndpointName
      Port                     = $Node.PullServer.Port
      PhysicalPath             = $Node.PullServer.PhysicalPath
      ModulePath               = $Node.PullServer.ModulePath
      ConfigurationPath        = $Node.PullServer.ConfigurationPath
      CertificateThumbPrint    = $Node.CertificateThumbPrint
      UseSecurityBestPractices = $Node.PullServer.UseSecurityBestPractices
      DependsOn                = '[WindowsFeature]DSCServiceFeature'
    }

    File RegistrationKeyFile
    {
      Ensure          = 'Present'
      Type            = 'File'
      DestinationPath = $Node.RegistrationKeyFile.DestinationPath
      Contents        = $Node.RegistrationKey
    }
  }
}

PullServer -ConfigurationData $configData -OutputPath $outputPath
