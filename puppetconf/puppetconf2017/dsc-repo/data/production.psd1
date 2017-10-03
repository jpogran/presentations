@{
  AllNodes = @(
    @{
      NodeName              = '*'
      RegistrationKey       = '72f0556d-fa48-446c-aa8c-d02d50d6546b'
      CertificateThumbPrint = 'AC978DBE2C712059AB6CFD1AA6BA4A6B6FB79F6C'
      PullServerUrl         = 'https://PULLSERVER:8080/PSDSCPullServer.svc'
    },
    @{
      NodeName            = 'pullserver'
      Roles               = @('pullserver')
      PullServer          = @{
        Ensure                   = 'Present'
        State                    = 'Started'
        EndpointName             = 'PSDSCPullServer'
        Port                     = 8080
        PhysicalPath             = "$env:SystemDrive\inetpub\PSDSCPullServer"
        ModulePath               = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Modules"
        ConfigurationPath        = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
        UseSecurityBestPractices = $false
      }
      RegistrationKeyFile = @{
        DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
      }
    },
    @{
      NodeName       = 'dsc-agent'
      Roles          = @('webserver')
      WebSiteFolder  = 'C:\testsite'
      IndexFile      = 'C:\testsite\index.html'
      WebSiteName    = 'TestSite'
      WebContentText = '<h1>Hello World</h1>'
      WebProtocol    = 'HTTP'
      Port           = '80'
    }

  )
}
