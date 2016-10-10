
class kalimdor::client(
  $cluster      = 'ceph',
  $user         = 'ceph',
  $group        = 'ceph',             
){
    include ::kalimdor::params

    ceph::key { 'client.admin':
        cluster => $cluster,
        user    => $user,
        group   => $group,
        secret  => $::kalimdor::params::admin_key,
        cap_mon => 'allow *',
        cap_osd => 'allow *',
        cap_mds => 'allow rw',
    }
}
