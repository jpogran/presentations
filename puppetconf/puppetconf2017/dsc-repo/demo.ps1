Get-DscConfigurationStatus
Get-DscConfigurationStatus | select JobID,NumberOfResources,RebootRequested,ResourcesInDesiredState,ResourcesNotInDesiredState,Status,StartDate,DurationInSeconds
$reports = . C:\vagrant\dsc-repo\getreport.ps1
$reports
$reportsByStartTime = $reports | Sort-Object {$_."StartTime" -as [DateTime] } -Descending
$reportsByStartTime
$reportsByStartTime | select JobID,Status,RebootRequested,StatusData
$reportsByStartTime[0]
$reportsByStartTime[0].StatusData | ConvertFrom-Json | select -expand ResourcesInDesiredState
