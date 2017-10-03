# intro

puppetConf

# title

Using Puppet and DSC to Report on Environment Change

# agenda

Importance of Change reporting
How DSC does change reporting
How Puppet improves change reporting

# bio

## whoami - puppet info
## whoami - dsc credibility

# change reporting

## why is it important
## it needs to be automatic
## it needs to be recorded

# dsc change reporting

## with dsc, you have to do most of the work
## change event types
## ways to get change events locally
### Get-DscConfigurationStatus
### EventLog
#### Microsoft-Windows-Dsc/Operational
#### Microsoft-Windows-Dsc/Analytic
#### Microsoft-Windows-Dsc/Debug
### xDscDiagnostics PowerShell Module
#### Get-xDscOperation
#### Get-xDscOperation
## ways to get change events on dsc pull server
## create the single pane of glass yourself
### Rest API Query

## demo of script to pull events from dsc pull server

# puppet change reporting

## puppet enterprise does the work for you
## single pane of glass
## change event types
## ways to get change events on puppet master
### events summary page
### event detail view
## analyzing changes and failures view

## demo

# summary

# end


45 minute talk
10 questions

35 minutes talk
10 minutes demos

25 minutes talk
30 seconds a slide

50 slides needed
