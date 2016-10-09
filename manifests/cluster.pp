# the total entry for ceph cluster
# in sunfire

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
  $osd_device_dict              = {},
  $disk_type                    = 'ssd',

  $enable_rgw                   = false,
  $rgw_ensure                   = 'running',
  
  $enable_mds                   = false,
  $mds_ensure                   = 'running',

  $admin_key                    = 'AQCTg71RsNIHORAAW+O6FCMZWBjmVfMIPk3MhQ==',
  $rgw_key                      = 'AQCTg71RsNIHORAAW+O6FCMZWBjmVfMIPk3MhQ==',
  $mon_key                      = 'AQDesGZSsC7KJBAAw+W/Z4eGSQGAIbxWjxjvfw==',
  $mds_key                      = 'AQABsWZSgEDmJhAAkAGSOOAJwrMHrM5Pz5On1A==',

  $bootstrap_osd_key            = 'AQAj2zpXuKuSDhAA3lJI2A3IAd72Ze9Q4M58jg==',
  $bootstrap_rgw_key            = 'AQAj2zpXuKuSDhAA3lJI2A3IAd72Ze9Q4M58jg==',

  $debug_enable                 = false,
  ){

  Ceph::Key {
     user => 'ceph',
     group => 'ceph'
  }
  
  #enable ceph monitor
  if $enable_mon {
    # install and configure ceph
    class { 'ceph':
      fsid                   => $fsid,
      mon_host               => $mon_hosts,
      mon_initial_members    => $mon_initial_members,
      authentication_type    => $authentication_type,
      mon_osd_full_ratio     => $mon_osd_full_ratio,
      mon_osd_nearfull_ratio => $mon_osd_nearfull_ratio,
    }

    if $debug_enable {
       class{ "kalimdor::debug":
           debug_enable => $debug_enable
       }
    }

    class {'kalimdor::mon':
      ensure                   => present,
      authentication_type      => $authentication_type,
      cluster                  => $cluster,
      mon_addr                 => $mon_addr,
      mon_key                  => $mon_key,
      host                     => $host,
    }

#   generate key
    ceph::key { 'client.admin':
      inject         => true,
      inject_as_id   => 'mon.',
      inject_keyring => "/var/lib/ceph/mon/${cluster}-${host}/keyring",
      secret  => $admin_key,
      cap_mon => 'allow *',
      cap_osd => 'allow *',
      cap_mds => 'allow rw',
    }

  } else {
    class { 'ceph':
      fsid                   => $fsid,
      mon_host               => $mon_hosts,
      mon_initial_members    => $mon_initial_members,
      authentication_type    => $authentication_type,
      public_network         => $public_network,
      cluster_network        => $cluster_network,
      mon_osd_full_ratio     => $mon_osd_full_ratio,
      mon_osd_nearfull_ratio => $mon_osd_nearfull_ratio,
    }

    if $debug_enable {
       class{ "kalimdor::debug":
           debug_enable => $debug_enable
       }
    }
    # here, we assume the client.admin key is inject.
    ceph::key { 'client.admin':
      secret  => $admin_key,
      cap_mon => 'allow *',
      cap_osd => 'allow *',
      cap_mds => 'allow rw',
    }
  } 

  # initializing osd
  if $enable_osd {

     # we assume client.admin is there
     ceph::key { 'client.bootstrap-osd':
       secret  => $bootstrap_osd_key,
       cap_mon => 'allow profile bootstrap-osd',
       keyring_path => "/var/lib/ceph/bootstrap-osd/ceph.keyring",
       inject => true,
     }

     class {"kalimdor::osd_options":
        disk_type => $disk_type
      }

    class {'kalimdor::osd':
      ensure                     => present,
      cluster                   => $cluster,
      osd_device_dict           => $osd_device_dict,
    }
  }

  if $enable_rgw  {
    class { 'kalimdor::rgw':
      rgw_ensure                   => $rgw_ensure,
    }
    ceph::key { "client.radosgw.${host}":
      secret       => $rgw_key,
      cap_mon      => 'allow *',
      cap_osd      => 'allow *',
      inject       => true
    }
  }

  if $enable_mds {
    $mds_keyring = "/var/lib/ceph/mds/$cluster-${host}"
    file { $mds_keyring:
        ensure => 'directory',
        owner  => 'ceph',
        group  => 'ceph'
    }

    ceph::key { "mds.${host}":
        secret       => $mds_key,
        cap_mon      => 'allow *',
        cap_osd      => 'allow *',
        cap_mds      => 'allow *',
        user         => 'ceph',
        group        => 'ceph',
        keyring_path => "/var/lib/ceph/mds/$cluster-${host}/keyring",
        inject       => true
    }
    class { "kalimdor::mds":
        enable_mds           => $enable_mds,
        mds_activate         => $enable_mds,
        mds_name             => $host,
    }
  }
}
