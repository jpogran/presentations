PS C:\Users\Administrator> Get-DscConfigurationStatus | select JobID,NumberOfResources,RebootRequested,ResourcesInDesiredState,Resour
cesNotInDesiredState,Status,StartDate,DurationInSeconds


JobID                      : {7A726AA3-A865-11E7-9662-080027CA4D91}
NumberOfResources          : 6
RebootRequested            : False
ResourcesInDesiredState    : {[WindowsFeature]IIS, [WindowsFeature]AspNet45, [xWebsite]DefaultSite, [File]WebContentDir...}
ResourcesNotInDesiredState :
Status                     : Success
StartDate                  : 10/3/2017 6:05:46 PM
DurationInSeconds          : 2

PS C:\Users\Administrator> $reportsByStartTime[0].StatusData | ConvertFrom-Json

StartDate               : 2017-10-03T15:10:58.6970000+00:00
IPV6Addresses           : {fe80::4d7f:81f:8dbe:ca28%2, ::2000:0:0:0, fe80::40f5:be5:9f8e:5b42%4, ::2000:0:0:0...}
DurationInSeconds       : 132
JobID                   : {0A54BB9B-A84D-11E7-9662-080027CA4D91}
CurrentChecksum         : 062B0A8752649A26BC42DFFB42C25C301FE6A1D7BF9F74AB997C4534A11A7D3A
MetaData                : Author: Administrator; Name: SetupTheSite; Version: 2.0.0; GenerationDate: 10/03/2017 15:00:07;
                          GenerationHost: PULLSERVER;
RebootRequested         : False
Status                  : Success
IPV4Addresses           : {10.0.2.15, 10.20.1.3, 127.0.0.1}
LCMVersion              : 2.0
NumberOfResources       : 6
Type                    : Initial
HostName                : DSC-AGENT
ResourcesInDesiredState : {@{SourceInfo=C:\vagrant\example_configuration.ps1::23::5::WindowsFeature;
                          ModuleName=PSDesiredStateConfiguration; DurationInSeconds=39.527; InstanceName=IIS;
                          StartDate=2017-10-03T15:11:03.3020000+00:00; ResourceName=WindowsFeature; ModuleVersion=1.1;
                          RebootRequested=False; ResourceId=[WindowsFeature]IIS; ConfigurationName=SetupTheSite;
                          InDesiredState=True}, @{SourceInfo=C:\vagrant\example_configuration.ps1::29::5::WindowsFeature;
                          ModuleName=PSDesiredStateConfiguration; DurationInSeconds=48.302; InstanceName=AspNet45;
                          StartDate=2017-10-03T15:11:42.8290000+00:00; ResourceName=WindowsFeature; ModuleVersion=1.1;
                          RebootRequested=False; ResourceId=[WindowsFeature]AspNet45; ConfigurationName=SetupTheSite;
                          InDesiredState=True}, @{SourceInfo=C:\vagrant\example_configuration.ps1::35::5::xWebsite;
                          ModuleName=xWebAdministration; DurationInSeconds=39.058; InstanceName=DefaultSite;
                          StartDate=2017-10-03T15:12:31.1310000+00:00; ResourceName=xWebsite; ResourceId=[xWebsite]DefaultSite;
                          ModuleVersion=1.18.0.0; RebootRequested=False; DependsOn=System.Object[];
                          ConfigurationName=SetupTheSite; InDesiredState=True},
                          @{SourceInfo=C:\vagrant\example_configuration.ps1::44::5::File; ModuleName=PSDesiredStateConfiguration;
                          DurationInSeconds=0.094; InstanceName=WebContentDir; StartDate=2017-10-03T15:13:10.1890000+00:00;
                          ResourceName=File; ResourceId=[File]WebContentDir; ModuleVersion=1.1; RebootRequested=False;
                          DependsOn=System.Object[]; ConfigurationName=SetupTheSite; InDesiredState=True}...}
MACAddresses            : {08-00-27-5B-B7-7B, 08-00-27-CA-4D-91, 00-00-00-00-00-00-00-E0, 00-00-00-00-00-00-00-E0}
MetaConfiguration       : @{AgentId=3CD9962C-A84A-11E7-9662-080027CA4D91; ConfigurationDownloadManagers=System.Object[];
                          ActionAfterReboot=ContinueConfiguration; LCMCompatibleVersions=System.Object[]; LCMState=Idle;
                          ResourceModuleManagers=System.Object[]; ReportManagers=System.Object[]; StatusRetentionTimeInDays=10;
                          LCMVersion=2.0; MaximumDownloadSizeMB=500; ConfigurationMode=ApplyAndMonitor; RefreshFrequencyMins=30;
                          RebootNodeIfNeeded=True; SignatureValidationPolicy=NONE; RefreshMode=Pull; DebugMode=System.Object[];
                          LCMStateDetail=; AllowModuleOverwrite=False; ConfigurationModeFrequencyMins=15;
                          SignatureValidations=System.Object[]}
Locale                  : en-US
Mode                    : Pull

PS C:\Users\Administrator> $reportsByStartTime[0].StatusData | ConvertFrom-Json | select -expand ResourcesInDesiredState

SourceInfo        : C:\vagrant\example_configuration.ps1::23::5::WindowsFeature
ModuleName        : PSDesiredStateConfiguration
DurationInSeconds : 39.527
InstanceName      : IIS
StartDate         : 2017-10-03T15:11:03.3020000+00:00
ResourceName      : WindowsFeature
ModuleVersion     : 1.1
RebootRequested   : False
ResourceId        : [WindowsFeature]IIS
ConfigurationName : SetupTheSite
InDesiredState    : False

SourceInfo        : C:\vagrant\example_configuration.ps1::29::5::WindowsFeature
ModuleName        : PSDesiredStateConfiguration
DurationInSeconds : 48.302
InstanceName      : AspNet45
StartDate         : 2017-10-03T15:11:42.8290000+00:00
ResourceName      : WindowsFeature
ModuleVersion     : 1.1
RebootRequested   : False
ResourceId        : [WindowsFeature]AspNet45
ConfigurationName : SetupTheSite
InDesiredState    : True


$reports = . C:\vagrant\getreport.ps1
$reportsByStartTime = $reports | Sort-Object {$_."StartTime" -as [DateTime] } -Descending
$reportsByStartTime[0].StatusData | ConvertFrom-Json | select -expand ResourcesInDesiredState
