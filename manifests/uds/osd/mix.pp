class ceph::uds::osd::mix inherits
 ceph::uds::osd::base {
  $osd_options = {
    #You can set some options for mix (ssd journal + sata)
    osd_client_message_cap            =>  3000,
    osd_client_message_size_cap       =>  524288000,
    ms_dispatch_throttle_bytes        =>  104857600,

    osd_pg_object_context_cache_count =>  128,
    osd_min_pg_log_entries            =>  1000,
    osd_max_pg_log_entries            =>  3000,
    osd_op_complaint_time             =>  5,

    osd_heartbeat_interval            =>  3,
    osd_heartbeat_grace               =>  10,
    osd_mon_report_interval_min       =>  2,

    filestore_queue_max_ops           =>  5000,
    filestore_queue_max_bytes         =>  104857600,
    filestore_fd_cache_size           =>  4096,
    filestore_fd_cache_shards         =>  64,

    osd_recovery_max_chunk            => 33554432,
  }
}
