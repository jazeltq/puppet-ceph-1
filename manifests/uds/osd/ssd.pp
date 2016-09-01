class ceph::uds::osd::ssd inherits
 ceph::uds::osd::base {
  $osd_options = {
    # osd op,
    osd_client_message_cap            => 20000,
    osd_client_message_size_cap       => 524288000,
    osd_op_complaint_time             => 1,

    # osd filestore,
    filestore_op_threads              => 4,
    filestore_queue_max_ops           => 10000,
    filestore_queue_max_bytes         => 1073741824,
    filestore_fd_cache_size           => 10240,
    filestore_fd_cache_shards         => 160,
    filestore_omap_header_cache_size  => 10240,

    # osd heartbeat
    osd_heartbeat_interval              => 3,
    osd_heartbeat_grace                 => 5,
    osd_mon_report_interval_min         => 2,

    # osd filestore wbthrottle,
    filestore_wbthrottle_xfs_ios_start_flusher     => 500,
    filestore_wbthrottle_xfs_bytes_start_flusher   => 41943040,
    filestore_wbthrottle_xfs_inodes_start_flusher  => 200,
    filestore_wbthrottle_enable                    => true,

    # osd recovery,
    osd_recovery_threads          => 2,
    osd_recovery_max_active       => 5,
    osd_recovery_max_single_start => 1,
    osd_recovery_max_chunk        => 33554432,
    osd_recovery_op_priority      => 10,
  }
}
