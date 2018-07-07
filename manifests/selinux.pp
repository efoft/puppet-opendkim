# == class opendkim::selinux
#
# Adjusts SELinux settings in order for opendkim to run
#
class opendkim::selinux inherits opendkim {

  if $::selinux == 'true' {
    selboolean { 'allow_ypbind':
      persistent => true,
      value      => $ensure ? { 'present' => 'on', default => 'off' },
    }
  }
}
