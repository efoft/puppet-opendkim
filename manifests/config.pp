# == Class opendkim::config
#
# This class is called from opendkim
#
class opendkim::config inherits opendkim {

  file { '/etc/opendkim.conf':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('opendkim/opendkim.conf.erb'),
  }

  ## Fix config directories & files permissions. 
  # Explanation: By default the package sets opendkim as owner & group for all content of /etc/opendkim, while the permissions
  # prevent from other to access the content.
  # Upon start the daemon runs as root and read configs and only after this it drops root permissions to opendkim permissions.
  # That means that the config files are not accessible for the daemon according to the given ownership. Defenately it can (as root)
  # but via DAC_READ_SEARCH capability which is not allowed by SELinux.
  # This has been registered as bug https://bugzilla.redhat.com/show_bug.cgi?id=891292 and should be remediated in current version
  # of opendkim package but actually the problems is still there. So we need to set correct permissions manually.
  # Same situation is applied to /var/run/opendkim directory so that service can't start correctly because root can't write pid file
  # there on SELinix-enabled systems.

  File {
    ensure       => $ensure ? { 'present' => 'directory', default => 'absent' },
    owner        => $owner,
    group        => $group,
  }

  file { $pathconf:
    recurse      => true,
    recurselimit => 1,
    force        => true,
  }

  file { '/var/run/opendkim':
    mode => '0770',
  }
}
