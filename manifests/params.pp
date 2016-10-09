class kalimdor::params {

  $exec_timeout                 = 600
  # install
  $package_name                 = 'ceph'
  $release                      = 'hammer'
  $package_ensure               = 'present'
  $ceph_yum_repo_enable         = false
  $path                         = '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
  $timeout                      = 3

  # cluster config
  $fsid                         = '27d39faa-48ae-4356-a8e3-19d5b81e179e'
  $debug_enable                 = true
  $perf                         = true
  $mutex_perf_counter           = false
  $syslog_enable                = false

  # auth config
  $auth_enable                  = true
  $common_key                   = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='
  $mon_key                      = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='
  $admin_key                    = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='
  $mds_key                      = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='
  $bootstrap_osd_key            = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='
  $openstack_key                = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='
  $radosgw_key                  = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='

  # ratio
  $mon_osd_full_ratio           = '0.95'
  $mon_osd_nearfull_ratio       = '0.85'

  # osd pool
  $osd_pool_default_pg_num      = 2048
  $osd_pool_default_pgp_num     = 2048
  $osd_pool_default_min_size    = 1
  $osd_pool_default_size        = 2
  $osd_pool_default_crush_rule  = 'rbd'
  $osd_crush_chooseleaf_type    = 'host'

  # osd xfs options
  $osd_xfs_mount_options_xfs         = 'rw,noexec,nodev,noatime,nodiratime,inode64,logbsize=256k,delaylog'     # FIXME: whether use discard option
  $osd_xfs_mkfs_options_xfs          = "-f -n size=64k -i size=2048 -d agcount=${::processorcount} -l size=1024m"

  # osd start option
  $osd_crush_update_on_start     = false # because we need our crush map and policy, we don't need auto update crush map on start

  # mon osd interaction
  $mon_osd_adjust_heartbeat_grace    = false # we don't need mon to adjust heartbeat grace, it will lose control
  $mon_osd_adjust_down_out_interval  = false # we don't need mon to adjust down out interval
  $mon_osd_down_out_interval         = 43200 # the defaut is 300 , our first setting is 20 mins, second setting is 12 hours

  # crush tuning
  $mon_warn_on_legacy_crush_tunables = false

  # rbd
  $rbd_op_threads                      = 1
  $rbd_op_thread_timeout               = 60
  $rbd_non_blocking_aio                = true
  $rbd_cache                           = false
  $rbd_cache_size                      = 134217728
  $rbd_cache_max_dirty                 = 100663296
  $rbd_cache_target_dirty              = 67108864
  $rbd_cache_max_dirty_age             = 30
  $rbd_cache_writethrough_until_flush  = true
  $rbd_cache_block_writes_upfront      = false
  $rbd_concurrent_management_ops       = 10
  $rbd_balance_snap_reads              = false
  $rbd_localize_snap_reads             = false
  $rbd_balance_parent_reads            = false
  $rbd_localize_parent_reads           = true
  $rbd_readahead_trigger_requests      = 10
  $rbd_readahead_max_bytes             = 524288
  $rbd_readahead_disable_after_bytes   = 52428800
  $rbd_clone_copy_on_read              = false
  $rbd_request_timed_out_seconds       = 30
  $rbd_default_format                  = 2
  $rbd_default_order                   = 22
  $rbd_default_stripe_count            = 0
  $rbd_default_stripe_unit             = 0
  $rbd_default_features                = 3

  # rgw
  $rgw_max_chunk_size                       = 524288
  $rgw_override_bucket_index_max_shards     = 0
  $rgw_bucket_index_max_aio                 = 8
  $rgw_enable_quota_threads                 = true
  $rgw_enable_gc_threads                    = true
  $rgw_cache_enabled                        = true
  $rgw_cache_lru_size                       = 10000
  $rgw_op_thread_timeout                    = 600
  $rgw_op_thread_suicide_timeout            = 0
  $rgw_usage_max_shards                     = 32
  $rgw_usage_max_user_shards                = 1
  $rgw_enable_ops_log                       = false
  $rgw_enable_usage_log                     = false
  $rgw_ops_log_rados                        = true
  $rgw_ops_log_data_backlog                 = 5242880
  $rgw_usage_log_flush_threshold            = 1024
  $rgw_usage_log_tick_interval              = 30
  $rgw_init_timeout                         = 300
  $rgw_gc_max_objs                          = 32
  $rgw_gc_obj_min_wait                      = 7200
  $rgw_gc_processor_max_time                = 3600
  $rgw_gc_processor_period                  = 3600
  $rgw_s3_success_create_obj_status         = 0
  $rgw_resolve_cname                        = false
  $rgw_obj_stripe_size                      = 4194304
  $rgw_exit_timeout_secs                    = 120
  $rgw_get_obj_window_size                  = 16777216
  $rgw_get_obj_max_req_size                 = 4194304
  $rgw_relaxed_s3_bucket_names              = false
  $rgw_list_buckets_max_chunk               = 1000
  $rgw_md_log_max_shards                    = 64
  $rgw_num_zone_opstate_shards              = 128
  $rgw_opstate_ratelimit_sec                = 30
  $rgw_curl_wait_timeout_ms                 = 1000
  $rgw_copy_obj_progress                    = true
  $rgw_copy_obj_progress_every_bytes        = 1048576
  $rgw_data_log_window                      = 30
  $rgw_data_log_changes_size                = 1000
  $rgw_data_log_num_shards                  = 128
  $rgw_bucket_quota_ttl                     = 600
  $rgw_bucket_quota_soft_threshold          = 0.95
  $rgw_bucket_quota_cache_size              = 10000
  $rgw_expose_bucket                        = false
  $rgw_user_quota_bucket_sync_interval      = 180
  $rgw_user_quota_sync_interval             = 86400
  $rgw_user_quota_sync_idle_users           = false
  $rgw_user_quota_sync_wait_time            = 86400
  $rgw_multipart_min_part_size              = 5242880
  $rgw_olh_pending_timeout_sec              = 3600
  $rgw_user_max_buckets                     = 1000
  $rgw_keystone_accepted_roles              = "admin,  _member_"
  $rgw_frontends                            = "civetweb port=7480"
  $rgw_enable_apis                          = "s3, admin"
  $rgw_keystone_token_cache_size            = 10000
  $rgw_keystone_revocation_interval         = 9000
  $nss_db_path                              = '/var/ceph/nss'
  $rgw_print_continue                       = false
  $rgw_swift_token_expiration               = 86400
  $rgw_thread_pool_size                     = 200

}
