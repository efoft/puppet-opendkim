# == class opendkim::selinux
#
# Adjusts SELinux settings in order for opendkim to run
#
class opendkim::selinux {

  if $::selinux == 'true' {
    selboolean { 'allow_ypbind':
      persistent    => true,
      value         => $opendkim::install::ensure ? { 'present' => 'on', default => 'off' },
    }
  }
}
