Configuration SetupTheSite {
  Import-DscResource -Module PSDesiredStateConfiguration
  Import-DscResource -Module xWebAdministration

  Node $AllNodes.Where( { $_.Roles -contains 'webserver'}).NodeName
  {
    WindowsFeature IIS
    {
      Ensure = 'Present'
      Name   = 'Web-Server'
    }

    WindowsFeature AspNet45
    {
      Ensure = 'Present'
      Name   = 'Web-Asp-Net45'
    }

    xWebsite DefaultSite
    {
      Ensure       = 'Present'
      Name         = 'Default Web Site'
      State        = 'Stopped'
      PhysicalPath = 'C:\inetpub\wwwroot'
      DependsOn    = '[WindowsFeature]IIS'
    }

    File WebContentDir
    {
      Ensure          = 'Present'
      Type            = 'Directory'
      DestinationPath = $Node.WebSiteFolder
      DependsOn       = '[WindowsFeature]AspNet45'
    }


    File WebContent
    {
      Ensure          = 'Present'
      Type            = 'File'
      DestinationPath = $Node.IndexFile
      Contents        = $Node.WebContentText
      DependsOn       = '[File]WebContentDir'
    }

    xWebsite NewWebsite
    {
      Ensure       = 'Present'
      State        = 'Started'
      Name         = $Node.WebSiteName
      PhysicalPath = $Node.WebSiteFolder
      BindingInfo  = MSFT_xWebBindingInformation {
        Protocol = 'HTTP'
        Port     = '80'
      }
      DependsOn = '[File]WebContent'
    }
  }
}

SetupTheSite -OutputPath $outputPath -ConfigurationData $configData
