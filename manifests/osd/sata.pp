class kalimdor::osd::sata inherits
 kalimdor::osd::base {
  $osd_options = {
    #You can set some options for sata
    osd_min_pg_log_entries  =>  1000,
    osd_max_pg_log_entries  =>  3000,

    filestore_wbthrottle_xfs_ios_start_flusher      => 100,
    filestore_wbthrottle_xfs_inodes_start_flusher   => 50,

    osd_recovery_max_chunk            => 33554432,
  }
}
