user { 'gonzo':
  ensure => 'absent',
  groups => ['wakka']
}
user { 'Administrator':
  ensure  => 'present',
  comment => 'Built-in account for administering the computer/domain',
  uid     => 'S-1-5-21-3369523099-18051581-356067000-500',
}

user { 'Guest':
  ensure  => 'present',
  comment => 'Built-in account for guest access to the computer/domain',
  groups  => ['BUILTIN\Guests'],
  uid     => 'S-1-5-21-3369523099-18051581-356067000-501',
}

user { 'WDAGUtilityAccount':
  ensure  => 'present',
  comment => 'A user account managed and used by the system for Windows Defender Application Guard scenarios.',
  uid     => 'S-1-5-21-3369523099-18051581-356067000-504',
}

user { 'defaultuser0':
  ensure => 'present',
  groups => ['BUILTIN\Users'],
  uid    => 'S-1-5-21-3369523099-18051581-356067000-1000',
}

user { 'ethan':
  ensure => 'present',
  groups => ['BUILTIN\Users'],
  uid    => 'S-1-5-21-3369523099-18051581-356067000-1004',
}

user { 'jpogr':
  ensure => 'present',
  groups => ['BUILTIN\Administrators', 'BUILTIN\Users'],
  uid    => 'S-1-5-21-3369523099-18051581-356067000-1001',
}

user { 'jpogran':
  ensure => 'present',
  groups => ['LAPTOP-P08LVEGT\docker-users', 'BUILTIN\Administrators', 'BUILTIN\Users'],
  uid    => 'S-1-5-21-3369523099-18051581-356067000-1002',
}

user { 'jrpog':
  ensure => 'present',
  groups => ['BUILTIN\Users'],
  uid    => 'S-1-5-21-3369523099-18051581-356067000-1005',
}
