# == Class: mssqlagcluster
#
# Full description of class mssqlagcluster here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'mssqlagcluster':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Mike Byrns <Michael.Byrns@dell.com>
#
# === Copyright
#
# Copyright 2016-2017 Kaiser Permanente
# The following modifications by Benjo Sevilla, CSG, IMG, KP-IT
# Version 1.1 Modified for SQL 2016 SAO 10/12/17
# Version 1.2 installs ssms & BMC for 2016
# Version 1.3 Added cleanup for ssms & BMC. Added BMC copy of log to c:\log\BMC
# Version 1.4 Added BMC to SAO 2014 on Windows 2012, modified the commandline options.
# Version 1.5 Added path to .net install since it was changed in xmws 3.3 
# Version 1.6 Moved reboot after SSMS to common section.
class mssqlagcluster (
  $inst_name,
  $is_primary_node,
  $cluster_name,
  $cluster_ip_addresses,
  $cluster_node_list,
  $cluster_wait,
  $mssql_version = $profile::mssqlagcluster::mssql_version,
  $cluster_retries) inherits mssqlagcluster::params {
  $dir = 'c:/temp/sql'
  # $args = "-auto y -mediadir $dir -localdir $dir -accountchoice c -itype ao -InstName $inst_name"
  $url = hiera(repo_windows)
  $user = hiera(win_repo_user)
  $pwd = hiera(win_repo_passwd)
  $cred_user = $user
  $cred_pwd = $pwd
  
  #notify {"SQL version -  $mssql_version":}

  if $mssql_version == '2016Enterprise' {

    $sql_pkg = '2016Enterprise.zip'
    $args = "-auto y -mediadir $dir -localdir $dir -accountchoice c -itype ao -InstName $inst_name -ForceInstall y"
    $dl = "dl2016.ps1"

  } else {

    $sql_pkg = '2014Enterprise.zip'
    $args = "-auto y -mediadir $dir -localdir $dir -accountchoice c -itype ao -InstName $inst_name -ForceInstall y"
    $dl = "dl2014.ps1"
    #notify {"SQL version - $mssql_version":}
  }

  # Windows features required and reboots
  reboot { 'dsc_reboot':
    message => 'Specially named reboot resource that is automatically refreshed by dsc_windowsfeature.',
    apply   => 'immediately',
    timeout => 0,
  }

  if $mssql_version == '2014Enterprise' {
    dsc_windowsfeature { 'NETFrameworkCore':
      dsc_ensure => 'present',
      dsc_name   => 'NET-Framework-Core',
      dsc_source => 'c:\\Install\\.Net_3.5_Source',
     }
  }

  dsc_windowsfeature { 'FailoverClustering':
    dsc_ensure => 'present',
    dsc_name   => 'Failover-Clustering',
  } ->
  dsc_windowsfeature { 'RSATClusteringMgmt':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-Clustering-Mgmt',
  } ->
  dsc_windowsfeature { 'RSATClusteringPowerShell':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-Clustering-PowerShell',
  } ->
  dsc_windowsfeature { 'RSATADTools':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-AD-Tools',
  } ->
  dsc_windowsfeature { 'RSATADPowerShell':
    dsc_ensure => 'present',
    dsc_name   => 'RSAT-AD-PowerShell',
  } ->
  dsc_windowsfeature { 'FSFileServer':
    dsc_ensure => 'present',
    dsc_name   => 'FS-FileServer',
  } ->
  dsc_windowsfeature { 'FSResourceManager':
    dsc_ensure => 'present',
    dsc_name   => 'FS-Resource-Manager',
  }

  # Create or wait for the Windows Failover Cluster
  if $is_primary_node {
    exec { 'newcluster':
      command   => "new-cluster $cluster_name -Node $cluster_node_list -StaticAddress $cluster_ip_addresses -NoStorage -ea stop",
      provider  => powershell,
      try_sleep => "${cluster_wait}",
      tries     => "${cluster_retries}",
      unless    => 'get-cluster -ea stop',
      require   => Dsc_windowsfeature['RSATClusteringPowerShell'],
      before    => File[$dir],
    }
  } else {
    if $::facts['SAO_cluster_defined'] {
      dsc_xwaitforcluster { 'waitcluster':
        dsc_name             => $cluster_name,
        dsc_retryintervalsec => "${cluster_wait}",
        dsc_retrycount       => "${cluster_retries}",
        require              => Dsc_windowsfeature['RSATClusteringPowerShell'],
        before               => File[$dir],
      }
    }
  }

  if $::facts['SAO_cluster_defined'] or $is_primary_node {

  # Sets up for, downloads, unzips, executes and cleans up after install script
  file { $dir:
    ensure => directory,
  } ->
  file { 'cred.ps1':
    ensure => file,
    path   => "$dir/cred.ps1",
    mode   => '0660',
    group  => 'Administrators',
    source => 'puppet:///modules/mssqlagcluster/cred.ps1',
  } ->
  file { 'log':
    ensure => directory,
    path   => 'c:\log\sql',
  } ->
  exec { 'dl':
    command  => template("mssqlagcluster/$dl"),
    provider => powershell,
    creates  => "$dir/$sql_pkg",
  } ->
  exec { 'unzip':
    command  => "Expand-Archive $dir/$mssql_version.zip $dir -ea stop",
    provider => powershell,
    creates  => "$dir/setup.exe",
  } 

  # download, unzip, then install ssms if SQL 2016
  if $mssql_version == '2016Enterprise' {
    exec { 'dlssms':   
      command  => template('mssqlagcluster/dlssms.ps1'),
      provider => powershell,
      creates  => 'c:/temp/ssms.zip',
    } ->
    exec { 'unzipssms':
      command  => "Expand-Archive c:/temp/ssms.zip $dir -ea stop",
      provider => powershell,
      creates  => "$dir/installSSMS.ps1",
    } ->
    exec { 'installssms':
      command  => "$dir/installSSMS.ps1",
      provider => powershell,
      creates  => 'c:/log/ssms/ssms.log',
      timeout  => 8600,
    } ->
    file { 'ssmsflag':
      ensure  => file,
      path    => 'C:\ProgramData\PuppetLabs\puppet\etc\ssms_install_nodelete.txt',
      content => 'SSMS is Installed. Do not delete this file or SSMS may be installed again.',
    } ->
    exec { 'cleanupssms':
      command  => 'Remove-Item -Force c:\temp\ssms.zip',
      provider => powershell,
    } ->
    file { 'postssmsreboot':
      ensure  => file,
      path    => 'C:\ProgramData\PuppetLabs\puppet\etc\reboot_postssms_install.txt',
      content => 'Rebooting after SSMS and before SQL.',
    } 
    #end of SSMS install
    #end of SQL2016 specific area
  }  

  reboot { 'reboot2':
    message => 'reboot before SQL install.',
    apply   => 'immediately',
    timeout => 0,
  } ->
  #Start SQL install
  exec { 'inst':
    command  => "$dir/ps_automatic_install.ps1 $args *>> c:/log/sql/install-out.log",
    provider => powershell,
    creates  => 'c:/log/sql/install-out.log',
    timeout  => 8600,
    require => File['cred.ps1'],      
  } ->

  file { 'sqlflag':
    ensure  => file,
    path    => 'C:\ProgramData\PuppetLabs\puppet\etc\sql_install_nodelete.txt',
    content => 'SQL is Installed and Configured. Do not delete this file or SQL may be installed again at your own peril.',
  }

  #download BMC 
  exec { 'dlbmc':   
    command  => template('mssqlagcluster/dlbmc.ps1'),
    provider => powershell,
    creates  => 'c:/temp/bmc.zip',
  } ->
  exec { 'unzipbmc':
    command  => "Expand-Archive c:/temp/bmc.zip c:/temp/bmc -ea stop",
    provider => powershell,
    creates  => 'c:/temp/bmc/InstallAgent.ps1',
  } ->
  exec { 'installbmc':
    command  => 'c:/temp/bmc/InstallAgent.ps1',
    provider => powershell,
    timeout  => 8600,
    } ->
  file { 'bmcflag':
    ensure  => file,
    path    => 'C:\ProgramData\PuppetLabs\puppet\etc\bmc_install_nodelete.txt',
    content => 'BMC is Installed. Do not delete this file or BMC may be installed again.',
  } ->
  exec { 'copybmclog':
    command  => 'Copy-Item "c:\Program Files (x86)\BMC Software\log\*" c:\log\BMC -recurse',
    creates => 'c:\Log\BMC',
    provider => powershell,
  } -> 
  exec { 'cleanupbmc':
    command  => 'Remove-Item -Force c:\temp\bmc.zip',
    provider => powershell,
  } 
 
  #end BMC install 
  #running cleanup and final reboot for 2014 or 2016.
  exec { 'cleanup':
    command  => "Remove-Item -Recurse -Force $dir",
    provider => powershell,
  } ->
  file { 'finalL3reboot':
    ensure  => file,
    path    => 'C:\ProgramData\PuppetLabs\puppet\etc\finalL3reboot.txt',
    content => 'Final reboot post SQL install.',
  } ->
  reboot { 'reboot3':
    message => 'reboot after SQL install',
    apply   => 'immediately',
    #subscribe => File['finalL3reboot'],
    timeout => 0,
  } 
  }
}
