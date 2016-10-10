class kalimdor::osd::options (
  $disk_type = 'ssd'
) {

    include kalimdor::osd::base
    $base_options = $kalimdor::osd::base::osd_options


  # get tune options for the disk type
    case $disk_type {
        ssd: {
            include kalimdor::osd::ssd
            $tune_opts = $kalimdor::osd::ssd::osd_options
        }
        sata: {
            include kalimdor::osd::sata
            $tune_opts = $kalimdor::osd::sata::osd_options
        }
        mix: {
            include kalimdor::osd::mix
            $tune_opts = $kalimdor::osd::mix::osd_options
        }
        default: {
            fail("This module does not support ${disk_type} disk type!")
        }
    }

    # set osd performance options in ceph.conf
    $base_options.each |$key, $val| {
    # the first priority is ceph class
    $set_val = getvar("ceph::$key")

    # the second priority is ceph::osd::{disk_type} class
    $tune_val = $tune_opts[$key]

    # the third priority is ceph::osd::base class
    if $set_val != undef and $set_val != 'undef' {

        $really_val = $set_val
    } elsif $tune_val != undef and $tune_val != 'undef' {

        $really_val = $tune_val
    } else {

        $really_val = $val
    }

    # set options in ceph.conf
    if $set_val != undef and $set_val != 'undef' and $set_val != default and $set_val != 'default' {
        ceph_config {
            "osd/${key}":   value => $really_val;
        }
    } else {
        ceph_config {
            "osd/${key}":   ensure => absent;
        }
    }
  }
}

