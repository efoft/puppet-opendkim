# === Class: opendkim
#
# The opendkim module allows you to set up mail signing and manage DKIM services.
#
# === Parameters
#
# [*tempdir*]
#   TemporaryDirectory in config file. Due to bug (see params.pp) needs to be redefined.
#
# [*mode*]
#   Selects operating modes. Valid modes are s (sign) and v (verify). Default is sv.
#
# [*syslog*]
#   Log activity to the system log. Valid are Yes and No. Default is Yes.
#
# [*syslog_success*]
#   Log additional entries indicating successful signing or verification of messages.
#   Valid are Yes and No. Default is Yes.
#
# [*log_why*]
#   If logging is enabled, include detailed logging about why or why not a message was
#   signed or verified. Valid are Yes and No. Default is Yes.
#
# [*send_reports*]
#   Specifies whether or not the filter should generate report mail back
#   to senders when verification fails and an address for such a purpose
#   is provided. Valid are Yes and No. Default is Yes.
#
# [*pathconf*]
#   Path to the directory where KetTable, SigningTable, TrustedHosts files and keys
#   subdirectory reside. Must be specified without trailing slash.
#
# [*keytable*]
#   Gives the location of a file mapping key names to signing keys. In simple terms,
#   this tells OpenDKIM where to find your keys.
#
# [*signing_table*]
#   Gives a location of a table file used to select one or more signatures to apply to a message based
#   on the address found in the From: header field. In simple terms, this tells
#   OpenDKIM how to use your keys.
#
# [*trusted_hosts*]
#   Gives the location of a file containg a set of internal and external host that may send
#   mail through the mail server. In the config file used in InternalHosts and
#   ExternalIgnoreList directives.
#
class opendkim(
  $package_name   = $opendkim::params::package_name,
  $package_ensure = $opendkim::params::package_ensure,

  $service_name   = $opendkim::params::service_name,
  $service_ensure = $opendkim::params::service_ensure,

  $tempdir        = $opendkim::params::tempdir,
  $mode           = $opendkim::params::mode,

  $syslog         = $opendkim::params::syslog,
  $syslog_success = $opendkim::params::syslog_success,
  $log_why        = $opendkim::params::log_why,

  $send_reports   = $opendkim::params::send_reports,

  $pathconf       = $opendkim::params::pathconf,
  $keytable       = $opendkim::params::keytable,
  $signing_table  = $opendkim::params::signing_table,
  $trusted_hosts  = $opendkim::params::trusted_hosts,

  $owner          = $opendkim::params::owner,
  $group          = $opendkim::params::group,
  $domains        = []
  ) inherits opendkim::params {

  class { 'opendkim::install': } ->
  class { 'opendkim::selinux': } ->
  class { 'opendkim::config' : } ~>
  class { 'opendkim::service': }

  if $domains and ( $package_ensure == 'present' or $package_ensure == true ) {
    opendkim::domain { $domains: }
  }
}
