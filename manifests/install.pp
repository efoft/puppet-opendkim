# == Class dkim::install
#
# Private class. Do not call directly.
class opendkim::install inherits opendkim {

  $package_ensure = $ensure ? {
    'absent' => 'purged',
    default  => $ensure
  }

  ensure_packages( $package_name, { 'ensure' => $package_ensure } )
}
