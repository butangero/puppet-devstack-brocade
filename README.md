puppet-devstack-brocade
=======================

This is a puppet module to deploy openstack grizzly (using devstack) with the Brocade VCS plugin for neutron.  Currently tested on Ubuntu Precise.

The Brocade VCS plugin for OpenStack Neutron implements the OpenStack networking API to manage L2 networks on  Brocade VDX switches.  Tenants are realized within VCS fabrics as port-profiles.



Setup
-----

Ensure that puppet is installed on the host.  The installation assumes two configured IP addresses on the host, one for management and one connected to a VCS fabric for tenant networks. The later should be in promisc mode.

	# apt-get install puppet


You can deploy in a masterless configuration by specifying parameters on the command line.  For example, to deploy and openstack all-in-one system and set the VCS management IP:

	# git clone https://github.com/jrametta/puppet-devstack-brocade 
	# cd puppet-devstack-brocade
	# puppet apply  --modulepath modules  -e "class {'puppet_brcd_devstack': vcs_ipaddr => '10.17.87.158' }" 

Additional compute nodes can be added to the environment using the same puppet module.  When deploying a compute node, you must specify the controller node's IP address.

	# puppet apply  --modulepath modules  -e "class {'puppet_brcd_devstack': vcs_ipaddr => '10.17.87.158', ctrl_ip => 192.168.1.10 }" 


The module assumes eth0 is the management interface, and eth1 is for tenant networks.  These parameters can be overrided to support alternate configurations.  The following parameters can be passed to the module:

	$ctrl_ip      = ''          		# only define ctrl_ip on compute nodes
	$mgmt_ip      = $::ipaddress_eth0
	$tenant_int   = 'eth1
	$vcs_username = 'admin'
	$vcs_password = 'password'
	$vcs_ipaddr


Once installed, switch to the newly created stack user (password is Brocade101) and verify that the localrc is correctly updated.  You can then run stack.sh to deploy OpenStack.  It will take some time to download and install the software.

	# su - stack
	# cd devstack
	# ./stack.sh
	

Once deployed, source the openrc in the devstack directory to obtain credentials and use the CLI to have a look around.  Alternatively, login the to Horizon dashboard at http://ctrl_ip and use the GUI (user: admin or demo, password: password)

On the VDX, check that new port-profiles are created for every OpenStack tenant network.

Additional information about devstack can be found at http://devstack.org.  See http://www.brocade.com for information about Brocade and VCS fabrics.

