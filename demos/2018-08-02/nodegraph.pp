# Updates on save
include default_users
include default_groups
include hyperv_guest
class hyperv_guest {
  $osname = $::operatingsystem
  computer { $osname:
    ensure => 'present',
  }
  ['pkg1','pkg2'].each |$package| {
    package { $package:
      ensure  => present,
      require => Computer[$osname],
    }
  }
  ['pkg3','pkg4'].each |$package| {
    package { $package:
      ensure  => present,
      require => Package['pkg1'],
    }
  }
  ['pkg5'].each |$package| {
    package { $package:
      ensure  => present,
      require => Package['pkg2','pkg4'],
    }
  }
}

base_dsc

dsc

class default_users {
  user { 'Alice':
    ensure => present,
    gid    => 'admin',
  }
  user { 'Bob':
    ensure => present,
    gid    => 'developers',
  }
}
class default_groups {
  group { 'admin':
    ensure => present,
  }
  group { 'developers':
    ensure => present,
  }
}
