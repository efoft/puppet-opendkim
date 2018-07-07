# == Class opendkim::service
#
class opendkim::service inherits opendkim {

  service { $service_name:
    ensure     => $ensure ? { 'present' => 'running', default => undef },
    enable     => $ensure ? { 'present' => true, default      => undef },
    hasstatus  => true,
    hasrestart => true,
  }
}
