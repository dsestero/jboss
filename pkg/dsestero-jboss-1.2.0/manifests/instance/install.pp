# = Define: jboss::instance::install
#
# Installs a JBoss instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance::install ($instance_name = $title,) {
  File {
    owner => jboss,
    group => jboss,
  }

  $require = Class['jboss']

  # Directory log del server
  file { "/var/log/jboss/server/${instance_name}":
    ensure => directory,
  }

  # Righe nel file di configurazione zip-delete-jboss-server-log: elenco di
  # tutte le istanze JBoss/WildFly
  @@concat::fragment { "${instance_name}-${::fqdn}-instance-list":
    target  => '/home/jboss/bin/jboss-instance-list.conf',
    content => "${instance_name}\n",
    tag     => [$::environment, $::fqdn],
  }
}
