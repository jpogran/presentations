Get-DscConfigurationStatus | ft -auto
Get-DscConfigurationStatus | select JobID,NumberOfResources,RebootRequested,ResourcesInDesiredState,ResourcesNotInDesiredState,Status,StartDate,DurationInSeconds
$reports = . C:\vagrant\dsc-repo\getreport.ps1
$reports
$reportsByStartTime = $reports | Sort-Object {$_."StartTime" -as [DateTime] } -Descending
$reportsByStartTime | select JobID,Status,RebootRequested,StatusData | ft -auto
$reportsByStartTime[0] | select JobID, Status, RebootRequested, StatusData | fl *
$reportsByStartTime[0].StatusData | ConvertFrom-Json | select -expand ResourcesInDesiredState
