# == Class dkim::install
#
# Private class. Do not call directly.
class opendkim::install {
  $package_name   = $opendkim::package_name
  $package_ensure = $opendkim::package_ensure

  $ensure = $package_ensure ? {
    false    => 'absent',
    true     => 'present',
    default  => $package_ensure
  }

  ensure_packages($opendkim::package_name, {'ensure' => $ensure})
}
