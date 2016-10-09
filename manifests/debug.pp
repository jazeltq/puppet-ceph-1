class kalimdor::debug (
  $debug_enable          = true,

  # undef is 0\/0, default is in comment below
  $debug_none            = undef, # "0\/5"
  $debug_lockdep         = undef, # "0\/1"
  $debug_context         = undef, # "0\/1"
  $debug_crush           = undef, # "1\/1"
  $debug_mds             = undef, # "1\/5"
  $debug_mds_balancer    = undef, # "1\/5"
  $debug_mds_locker      = undef, # "1\/5"
  $debug_mds_log         = undef, # "1\/5"
  $debug_mds_log_expire  = undef, # "1\/5"
  $debug_mds_migrator    = undef, # "1\/5"
  $debug_buffer          = undef, # "0\/1"
  $debug_timer           = undef, # "0\/1"
  $debug_filer           = undef, # "0\/1"
  $debug_striper         = undef, # "0\/1"
  $debug_objecter        = undef, # "0\/1"
  $debug_rados           = undef, # "0\/5"
  $debug_rbd             = undef, # "0\/5"
  $debug_rbd_replay      = undef, # "0\/5"
  $debug_journaler       = undef, # "0\/5"
  $debug_objectcacher    = undef, # "0\/5"
  $debug_client          = undef, # "0\/5"
  $debug_osd             = undef, # "0\/5"
  $debug_optracker       = undef, # "0\/5"
  $debug_objclass        = undef, # "0\/5"
  $debug_filestore       = undef, # "1\/3"
  $debug_keyvaluestore   = undef, # "1\/3"
  $debug_journal         = undef, # "1\/3"
  $debug_ms              = undef, # "0\/5"
  $debug_mon             = undef, # "1\/5"
  $debug_monc            = undef, # "0\/10"
  $debug_paxos           = undef, # "1\/5"
  $debug_tp              = undef, # "0\/5"
  $debug_auth            = undef, # "1\/5"
  $debug_crypto          = undef, # "1\/5"
  $debug_finisher        = undef, # "1\/1"
  $debug_heartbeatmap    = undef, # "1\/5"
  $debug_perfcounter     = undef, # "1\/5"
  $debug_rgw             = undef, # "1\/5"
  $debug_civetweb        = undef, # "1\/10"
  $debug_javaclient      = undef, # "1\/5"
  $debug_asok            = undef, # "1\/5"
  $debug_throttle        = undef, # "1\/1"
  $debug_refs            = undef, # "0\/0"
  $debug_xio             = undef, # "1\/5"
) {

  $debug_options = [
    'debug_none',
    'debug_lockdep',
    'debug_context',
    'debug_crush',
    'debug_mds',
    'debug_mds_balancer',
    'debug_mds_locker',
    'debug_mds_log',
    'debug_mds_log_expire',
    'debug_mds_migrator',
    'debug_buffer',
    'debug_timer',
    'debug_filer',
    'debug_striper',
    'debug_objecter',
    'debug_rados',
    'debug_rbd',
    'debug_rbd_replay',
    'debug_journaler',
    'debug_objectcacher',
    'debug_client',
    'debug_osd',
    'debug_optracker',
    'debug_objclass',
    'debug_filestore',
    'debug_keyvaluestore',
    'debug_journal',
    'debug_ms',
    'debug_mon',
    'debug_monc',
    'debug_paxos',
    'debug_tp',
    'debug_auth',
    'debug_crypto',
    'debug_finisher',
    'debug_heartbeatmap',
    'debug_perfcounter',
    'debug_rgw',
    'debug_civetweb',
    'debug_javaclient',
    'debug_asok',
    'debug_throttle',
    'debug_refs',
    'debug_xio']

  #notify { "debug is $debug_enable": }

  $default_val = $debug_enable ? {
    'false' => '0/0',
    false   => '0/0',
    default => 'default',
  }

  $debug_options.each |$key| {
    #$set_val = inline_template("<%= scope.lookupvar('ceph::$key') %>")
    $set_val = getvar("kalimdor::debug::$key")
    $really_val = $set_val ? {
      undef   => $default_val,
      'undef' => $default_val,
      default => $set_val,
    }

    ceph_config {
      "global/${key}":   value => $really_val;
    }
  }
}

