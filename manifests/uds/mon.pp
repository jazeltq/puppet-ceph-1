# ===class sunfire::ceph::mon
# install and config ceph monitor
# ===Authors
# Author Name liyankun
# Copyright 2016 liyankun


class ceph::uds::mon (
  $ensure                     = present,
  $authentication_type        = 'cephx',
  $cluster                    = 'ceph',
  $mon_addr                   = $::ipaddress_eth0,
  $host                       = $::hostname,
  $mon_key                    = 'AQDesGZSsC7KJBAAw+W/Z4eGSQGAIbxWjxjvfw==',
  ) {

    $mon_id = $host

    $mon_data =  "/var/lib/ceph/mon/${cluster}-${mon_id}"

    # Install and configure ceph monitors
    if $ensure == present {
      ceph_config {
        "mon.${mon_id}/host":                         value => $host;
        "mon.${mon_id}/mon_data":                     value => $mon_data;
        "mon.${mon_id}/mon_addr":                     value => "${mon_addr}:6789";
      }

      ::ceph::mon { $mon_id:
        ensure                 => present,
        key                    => $mon_key,
        authentication_type    => $authentication_type,
      }
#
    } else {
      ceph::mon { $mon_id:
        ensure => absent,
      }
    }
  }
