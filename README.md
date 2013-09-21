puppet-devstack-brocade
=======================

puppet module to deploy openstack grizzly with the brocade vcs plugin for neutron.  Currently tested on Ubuntu Precise


Setup
-----

Ensure that puppet is installed on the host.  The installation assumes two configured IP addresses on the host, one for management and one connected to a VCS fabric for tenant networks. The later should be in promisc mode.

	# apt-get install puppet


You can deploy in a masterless configuration by specifying parameters on the command line.  For example, to deploy devstack and set the VCS management IP:

	# puppet apply  --modulepath modules  -e "class {'puppet_brcd_devstack': vcs_ipaddr => '10.17.87.158' }" 


The following parameters can be passed to the module:

	$ctrl_ip      = ''
	$mgmt_ip      = $::ipaddress_eth0
	$tenant_int   = 'eth1
	$vcs_username = 'admin'
	$vcs_password = 'password'
	$vcs_ipaddr


Once installed, switch to stack user and verify that the localrc is correctly updated.  You can stack.sh to deploy OpenStack.  It will take some time to download and install the software.

	# su - stack
	# cd devstack
	# ./stack.sh
	

