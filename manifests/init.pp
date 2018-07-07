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
  Enum['present','absent'] $ensure = 'present',
  Stdlib::Unixpath $tempdir        = $opendkim::params::tempdir,
  Enum['s','v','sv'] $mode         = $opendkim::params::mode,

  Enum['Yes','No'] $syslog         = $opendkim::params::syslog,
  Enum['Yes','No'] $syslog_success = $opendkim::params::syslog_success,
  Enum['Yes','No'] $log_why        = $opendkim::params::log_why,
  Enum['Yes','No'] $send_reports   = $opendkim::params::send_reports,

  Stdlib::Unixpath $pathconf       = $opendkim::params::pathconf,
  Stdlib::Unixpath $keytable       = $opendkim::params::keytable,
  Stdlib::Unixpath $signing_table  = $opendkim::params::signing_table,
  Stdlib::Unixpath $trusted_hosts  = $opendkim::params::trusted_hosts,

  String[1] $owner                 = $opendkim::params::owner,
  String[1] $group                 = $opendkim::params::group,
  Array[String] $domains           = []
  ) inherits opendkim::params {

  class { 'opendkim::install': } ->
  class { 'opendkim::selinux': } ->
  class { 'opendkim::config' : } ~>
  class { 'opendkim::service': }

  if $domains and $ensure == 'present' {
    opendkim::domain { $domains: }
  }
}
