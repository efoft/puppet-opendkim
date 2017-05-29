# == Class dkim::params
#
# This class is meant to be called from module
# It sets variables according to platform
#
class opendkim::params {

  case $::osfamily {
    'RedHat': {
      $package_name  = 'opendkim'
      $service_name  = 'opendkim'
      $pathconf      = '/etc/opendkim'
      $keytable      = "${pathconf}/KeyTable"
      $signing_table = "${pathconf}/SigningTable"
      $trusted_hosts = "${pathconf}/TrustedHosts"
    }

    default: {
      fail('Your operation system is not supported.')
    }
  }
  $package_ensure     = 'present'
  $service_ensure     = 'running'

  $owner              = 'root'
  $group              = 'opendkim'

  # By default TemporaryDirectory directive is /tmp. But for SELinux policy inconsistancy (selinux-policy-3.7.19-307)
  # dkim_milter_t is not allowed to write to tmp_t dir. https://bugzilla.redhat.com/show_bug.cgi?id=1293635
  # The workarount is to use /var/run/opendkim with correct selinux context to be written to.
  $tempdir            = '/var/run/opendkim'
  $mode               = 'sv'

  $syslog             = 'Yes'
  $syslog_success     = 'Yes'
  $log_why            = 'Yes'

  $send_reports       = 'Yes'
}
