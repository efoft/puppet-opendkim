# == define opendkim::domain
#
# Generates key pair for a given domain and puts records about it into KeyTable and SigningTable
#
define opendkim::domain (
  $domain        = $name,
  $selector      = 'email',
  ) {
    # $pathconf and $pathkeys must be without trailing '/'.
    # For example, '/etc/opendkim/keys'
    $pathkeys      = "${opendkim::pathconf}/keys"

    Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

    # Create directory for domain
    file { "${pathkeys}/${domain}":
        ensure  => directory,
        owner   => 'opendkim',
        group   => 'opendkim',
        mode    => '0750',
        notify  => Service[$opendkim::service_name],
        require => Package[$opendkim::package_name],
    }

    # Generate dkim-keys
    exec { "opendkim-genkey -D ${pathkeys}/${domain}/ -d ${domain} -s ${selector}":
        unless  => "/usr/bin/test -f ${pathkeys}/${domain}/${selector}.private && /usr/bin/test -f ${pathkeys}/${domain}/${selector}.txt",
        user    => 'opendkim',
        group   => 'opendkim',
        notify  => Service[$opendkim::service_name],
        require => [ Package[$opendkim::package_name], File["${pathkeys}/${domain}"], ],
    }

    # Add line into KeyTable
    file_line { "${opendkim::keytable}_${domain}":
        path    => $opendkim::keytable,
        line    => "${selector}._domainkey.${domain} ${domain}:${selector}:${pathkeys}/${domain}/${selector}.private",
        notify  => Service[$opendkim::service_name],
        require => Package[$opendkim::package_name],
    }

    # Add line into SigningTable
    file_line { "${opendkim::signing_table}_${domain}":
        path    => $opendkim::signing_table,
        line    => "*@${domain} ${selector}._domainkey.${domain}",
        notify  => Service[$opendkim::service_name],
        require => Package[$opendkim::package_name],
    }
}
