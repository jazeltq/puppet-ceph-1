# ===class sunfire::ceph::mon
# install and config ceph osds

#
# example for device

class kalimdor::osd (
  $ensure                 = present,
  $cluster                = 'ceph',
  $osd_device_dict        = {},
  $osd_journal_size       = 10240
  ){

  $osd_device_list = keys($osd_device_dict)

  $osd_device_list.each |$key| {
    $osd_data_wwn_name = $key
    #notify{"$osd_data_wwn_name": }

    $osd_data_name = $::wwn_dev_name_hash["$osd_data_wwn_name"]
    #notify{"$osd_data_name": }

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
