
class kalimdor::osd (
  $ensure                 = present,
  $cluster                = 'ceph',
  $osd_device_dict        = {},
  $bootstrap_osd_key      = 'AQAj2zpXuKuSDhAA3lJI2A3IAd72Ze9Q4M58jg==',
){

    ceph::key { 'client.bootstrap-osd':
        secret  => $bootstrap_osd_key,
        cap_mon => 'allow profile bootstrap-osd',
        keyring_path => "/var/lib/ceph/bootstrap-osd/${cluster}.keyring",
        inject => true,
    }

    class {"kalimdor::osd_options":
        disk_type => $disk_type
    }

    $osd_device_list = keys($osd_device_dict)
    $osd_device_list.each |$key| {

        $osd_data_wwn_name = $key
        $osd_data_name = $::wwn_dev_name_hash["$osd_data_wwn_name"]

        if $osd_device_dict[$key] == '' {

            ceph::osd { $osd_data_name:
                ensure           => $ensure,
                cluster          => $cluster,
            }
        } else {

          $osd_journal_wwn = $osd_device_dict[$key]
          $osd_journal_name = $::wwn_dev_name_hash[$osd_journal_wwn]

          ceph::osd { $osd_data_name:
            ensure           => $ensure,
            cluster          => $cluster,
            journal          => $osd_journal_name,
          }
      }
    }
}
