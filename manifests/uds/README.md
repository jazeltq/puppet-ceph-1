Usage
=====

site.pp
-------

	node /server-69.3.dev3.ustack.in/{
   		class {"ceph::uds::cluster": }
	}


hieradata
---------


	ceph::uds::cluster::public_network: 10.0.19.0/24
	ceph::uds::cluster::cluster_network: 10.0.19.0/24

	ceph::uds::cluster::mon_hosts: 10.0.19.69
	ceph::uds::cluster::mon_initial_members: server-69
	ceph::uds::cluster::debug_enable: true

	ceph::uds::cluster::enable_mon: true

	ceph::uds::cluster::enable_osd: true
	ceph::uds::cluster::disk_type: "ssd"
	ceph::uds::cluster::osd_device_dict:
	  "wwn-0x55cd2e404bcdf711": ""
	  "wwn-0x55cd2e404bcdee9a": ""
	  "wwn-0x55cd2e404bcded26": ""
