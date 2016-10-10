class kalimdor::params {
  $admin_key                                = 'AQCTg71RsNIHORAAW+O6FCMZWBjmVfMIPk3MhQ=='  

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
