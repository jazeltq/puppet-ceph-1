# ===class sunfire::ceph::mon
# install and config ceph monitor
# ===Authors
# Author Name tianqing@unitedstack.com
# Copyright 2016 tianqing@unitedstack.com

class kalimdor::mon (
  $ensure               = present,
  $authentication_type  = 'cephx',
  $cluster              = 'ceph',
  $user                 = 'ceph',
  $group                = 'ceph',
  $mon_addr             = $::ipaddress_eth0,
  $host                 = $::hostname,
  $mon_key              = 'AQDesGZSsC7KJBAAw+W/Z4eGSQGAIbxWjxjvfw==',
) {

    $mon_id = $host
    $mon_data =  "/var/lib/ceph/mon/${cluster}-${mon_id}"

    if $ensure == present {

        ceph_config {
            "mon.${mon_id}/host":          value => $host;
            "mon.${mon_id}/mon_data":      value => $mon_data;
            "mon.${mon_id}/mon_addr":      value => "${mon_addr}:6789";
        }

        include ::kalimdor::params
        ::ceph::mon { $mon_id:
            ensure                 => present,
            key                    => $mon_key,
            authentication_type    => $authentication_type,
        } -> 
        ceph::key { 'client.admin':
            inject         => true,
            inject_as_id   => 'mon.',
            inject_keyring => "/var/lib/ceph/mon/${cluster}-${mon_id}/keyring",
            secret  => $::kalimdor::params::admin_key,
            cap_mon => 'allow *',
            cap_osd => 'allow *',
            cap_mds => 'allow rw',
            user    => $user,
            group   => $group,
        }
    }
}
