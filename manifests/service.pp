# == Class opendkim::service
#
# This class is meant to be called from module
# It ensure the service is running
#
class opendkim::service {

  if $opendkim::install::ensure == 'present' {
    $_service_enable = $opendkim::service_ensure ? {
      'running'  => true,
      'stopped'  => false,
      default    => $opendkim::service_ensure # false, true
    }

    service { $opendkim::service_name:
      ensure     => $opendkim::service_ensure,
      enable     => $_service_ensure,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
