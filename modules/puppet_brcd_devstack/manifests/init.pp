class puppet_brcd_devstack (
  $ctrl_ip      = '',
  $mgmt_ip      = $::ipaddress_eth0,
  $tenant_int   = $::ipaddress_eth1,
  $vcs_username = 'admin',
  $vcs_password = 'password',
  $vcs_ipaddr,
) {

  # if this is a compute node, you must specify the ctrl_ip
  if $ctrl_ip != '' {
    $localrc = 'localrc-compute.erb'
  } else {
    $localrc = 'localrc-controller.erb'
  }

  package {'git':
    ensure => present,
  } ->
  vcsrepo {'/tmp/ncclient':
    ensure   => present,
    owner    => root,
    group    => root,
    provider => git,
    source   => 'https://code.grnet.gr/git/ncclient',
  } ->
  exec {'python /tmp/ncclient/setup.py install':
    path      => '/usr/sbin:/usr/bin:/sbin:/bin',
    creates   => '/usr/local/lib/python2.7/dist-packages/ncclient',
    logoutput => true
  }
  user {'stack':
    ensure     => present,
    shell      => '/bin/bash',
    managehome => true,
    password   => 'Brocade101',
  } ->
  file {'/etc/sudoers.d/devstack':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
    source => 'puppet:///modules/puppet_brcd_devstack/devstack.sudoer'
  } ->
  vcsrepo {'/home/stack/devstack':
    ensure   => present,
    owner    => 'stack',
    group    => 'stack',
    provider => git,
    source   => 'https://github.com/jrametta/devstack-brocade.git',
    # revision => 'stable/grizzly',
  } ->
  file {'/home/stack/devstack/localrc':
    ensure  => file,
    content => template("puppet_brcd_devstack/${localrc}"),
    owner   => 'stack',
    group   => 'stack',
  }
  # i think i would rather just run this myself and watch...
  # exec { "/home/stack/devstack/stack.sh":
  # cwd       => "/home/stack/devstack",
  # group     => 'stack',
  # user      => 'stack',
  # logoutput => on_failure,
  # timeout   => 0,
  # require   => File["/home/stack/devstack/localrc"],
  # }
}




