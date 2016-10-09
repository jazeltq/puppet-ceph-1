class kalimdor::mds (
  $enable_mds            = true,
  $mds_activate          = true,
  $cluster               = 'ceph',
  $mds_data              = '/var/lib/ceph/mds/$cluster-$id',
  $keyring               = '/var/lib/ceph/mds/$cluster-$id/keyring',
  $mds_name              = $::hostname,
  $host                  = $::hostname,
  ) {
    #include kalimdor::params

    if $enable_mds {
      class { "::ceph::mds":
        mds_activate          => $mds_activate,
        mds_data              => $mds_data,
        keyring               => $keyring,
      } ->
      # here, you can insert other items
      ceph_config {
        "mds.${mds_name}/host":         value => $host;
        "mds.${mds_name}/mds_data":     value => "/var/lib/ceph/mds/ceph-${mds_name}";
        "mds.${mds_name}/keyring":      value => "/var/lib/ceph/mds/ceph-${mds_name}/keyring";
      } -> 
      service { "mds.${mds_name}":
        ensure => running,
        start => "systemctl start ceph-mds@${mds_name}",
        stop => "systemctl stop ceph-mds@${mds_name}",
        status => "systemctl status ceph-mds@${mds_name}",
     }
   }
  }
