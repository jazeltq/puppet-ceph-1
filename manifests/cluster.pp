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
  $osd_journal_size             = 10240,

  $enable_rgw                   = false,
  $rgw_ensure                   = 'running',
  $user                         = root,
  $frontend_type                = 'civetweb',
  $rgw_frontends                = "civetweb port=7480",
  $rgw_enable_apis              = "s3, admin",
  $rgw_s3_auth_use_keystone     = false,
  $rgw_keystone_url             = "http://keyston.com:35357/",
  $rgw_keystone_admin_token     = "admin",
  $rgw_keystone_accepted_roles  = "_member_, admin",
  $rgw_dns_name                 = undef,

  $enable_mds                   = false,
  $mds_ensure                   = 'running',

  $admin_key                    = 'AQCTg71RsNIHORAAW+O6FCMZWBjmVfMIPk3MhQ==',
  $rgw_key                      = 'AQCTg71RsNIHORAAW+O6FCMZWBjmVfMIPk3MhQ==',
  $mon_key                      = 'AQDesGZSsC7KJBAAw+W/Z4eGSQGAIbxWjxjvfw==',
  $mds_key                      = 'AQABsWZSgEDmJhAAkAGSOOAJwrMHrM5Pz5On1A==',

  $bootstrap_osd_key            = 'AQAj2zpXuKuSDhAA3lJI2A3IAd72Ze9Q4M58jg==',
  $bootstrap_rgw_key            = 'AQAj2zpXuKuSDhAA3lJI2A3IAd72Ze9Q4M58jg==',

  $mon_osd_full_ratio           = '0.95',
  $mon_osd_nearfull_ratio       = '0.85',
# you can specify by inpuet paramerters
# It will overwrite the original set by default
  $ceph_common_conf_sata_args   = undef,
# same as $ceph_common_conf_sata_args
  $ceph_common_conf_ssd_args    = undef,

  $debug_enable                 = false,
  $after_jewel                  = false
  ){

  #notify{"$name":
  #   message => "ceph cluster begin......."
  #}

  #enable ceph monitor
  if $enable_mon {
    # install and configure ceph
    class { 'ceph':
      fsid                   => $fsid,
      mon_host               => $mon_hosts,
      mon_initial_members    => $mon_initial_members,
      authentication_type    => $authentication_type,
      osd_journal_size       => $osd_journa_size,
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
    Ceph::Key {
      inject         => true,
      inject_as_id   => 'mon.',
      inject_keyring => "/var/lib/ceph/mon/${cluster}-${host}/keyring",
    }
    ceph::key { 'client.admin':
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
      osd_journal_size       => $osd_journa_size,
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

  } # TODO delete mon

  # initializing osd
  if $enable_osd {

     # we assume client.admin is there
     if $after_jewel == false {
       ceph::key { 'client.bootstrap-osd':
         secret  => $bootstrap_osd_key,
         cap_mon => 'allow profile bootstrap-osd',
         keyring_path => "/var/lib/ceph/bootstrap-osd/ceph.keyring",
         inject => true,
       }
     } else {
        $cmd="ceph auth get client.bootstrap-osd > /var/lib/ceph/bootstrap-osd/ceph.keyring"
        exec{ "get-or-create-bootstrap-osd":
           path    => "/usr/bin/",
           command => $cmd,
        }
        exec{"change own for bootstrap osd keyring":
           path    => "/usr/bin",
           command => "chown ceph:ceph /var/lib/ceph/bootstrap-osd/ceph.keyring"
        }
     }

     class {"kalimdor::osd_options":
        disk_type => $disk_type
      }

      #provie ceph special configuration
      if $disk_type == 'ssd' {

        # second we use the options send in
        if $ceph_common_conf_ssd_args {
          class { 'ceph::conf':
            args  => $ceph_common_conf_ssd_args
          }
       }
      } else {
        if $ceph_common_conf_sata_args {
          class { 'ceph::conf':
            args   => $ceph_common_conf_sata_args
          }
        }
    }

    class {'kalimdor::osd':
      ensure                     => present,
      cluster                   => $cluster,
      osd_device_dict           => $osd_device_dict,
      osd_journal_size          => $osd_journal_size,
    }
  } # TODO delete osd

  if $enable_rgw  {
    #firewall { '102 allow rgw access':
    #  port   => [7480],
    #  proto  => tcp,
    #  action => accept,
    #}

    #ceph::key { 'client.bootstrap-rgw':
    #  secret  => $bootstrap_rgw_key,
    #  cap_mon => 'allow profile bootstrap-rgw',
    #  keyring_path => "/var/lib/ceph/bootstrap-rgw/ceph.keyring",
    #  inject => true,
    #}

    class { 'kalimdor::rgw':
      rgw_ensure                   => $rgw_ensure,
      user                         => $user,
      frontend_type                => $frontend_type,
      rgw_frontends                => $rgw_frontends,
      rgw_enable_apis              => $rgw_enable_apis,
      rgw_s3_auth_use_keystone     => $rgw_s3_auth_use_keystone,
      rgw_keystone_url             => $rgw_keystone_url,
      rgw_keystone_admin_token     => $rgw_keystone_admin_token,
      rgw_keystone_accepted_roles  => $rgw_keystone_accepted_roles,
      rgw_dns_name                 => $rgw_dns_name,
      rgw_name                     => $host,
    }
    ceph::key { "client.radosgw.${host}":
      secret       => $rgw_key,
      cap_mon      => 'allow *',
      cap_osd      => 'allow *',
      inject       => true
    }
  } # TODO delete rgw

#install mds
  if $enable_mds {
    $mds_keyring = "/var/lib/ceph/mds/$cluster-${host}"
    file { $mds_keyring:
        ensure => 'directory',
    }

    ceph::key { "mds.${host}":
        secret       => $mds_key,
        cap_mon      => 'allow *',
        cap_osd      => 'allow *',
        cap_mds      => 'allow *',
        keyring_path => "/var/lib/ceph/mds/$cluster-${host}/keyring",
        inject       => true
    }

    class { "kalimdor::mds":
        enable_mds           => $enable_mds,
        mds_activate         => $enable_mds,
        mds_name             => $host,
    }
  
  } # TODO delete mds
}
