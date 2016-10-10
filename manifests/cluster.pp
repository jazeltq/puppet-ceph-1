# copyright @unitedstack.com

class kalimdor::cluster(
  $ensure                       = present,
  $fsid                         = '066F558C-6789-4A93-AAF1-5AF1BA01A3AD',
  $cluster                      = 'ceph',
  $authentication_type          = 'cephx',
  $mon_initial_members          = undef,
  $mon_hosts                    = '127.0.0.1',
  $public_network               = undef,
  $cluster_network              = undef,

  $enable_mon                   = false,
  $host                         = $::hostname,
  $mon_addr                     = $::ipaddress_eth0,

  $enable_osd                   = false,

  $enable_rgw                   = false,
  $rgw_ensure                   = 'running',
  
  $enable_mds                   = false,
  $mds_ensure                   = 'running',

  $enable_client                = false,

  $debug_enable                 = false,
  ){

  class { 'ceph':
      fsid                   => $fsid,
      mon_host               => $mon_hosts,
      mon_initial_members    => $mon_initial_members,
      authentication_type    => $authentication_type,
      public_network         => $public_network,
      cluster_network        => $cluster_network,
  }

  if $enable_mon {

      class {'kalimdor::mon':
          ensure                   => present,
          authentication_type      => $authentication_type,
          cluster                  => $cluster,
          mon_addr                 => $mon_addr,
          mon_key                  => $mon_key,
          host                     => $host,
      }
  }

  if $enable_client{

      class {"kalimdor::client":
          cluster => $cluster
      }
  } 

  if $enable_osd {

      class {'kalimdor::osd':
	  ensure               => present,
	  cluster              => $cluster,
      }
  }

  if $enable_rgw  {

      class { 'kalimdor::rgw':
          rgw_ensure           => $rgw_ensure,
     }
  }

  if $enable_mds {
  
      class { "kalimdor::mds":
          mds_activate         => $enable_mds,
          mds_name             => $host
      }
  }
}
