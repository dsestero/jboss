# = Define: jboss::instance::install
#
# Installs a JBoss instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance::install ($instance_name = $title,) {

  $require = Class['jboss']

  # Directory log del server
  file { "/var/log/jboss/server/${instance_name}":
    ensure => directory,
    owner => jboss,
    group => jboss,
  }

  # Righe nel file di configurazione usato dagli script zip-delete-jboss-server-log e manage-jboss-instance:
  # elenco di tutte le istanze JBoss/WildFly
  @@concat::fragment { "${instance_name}-${facts[networking][fqdn]}-instance-list":
    target  => '/usr/local/bin/jboss-instance-list.conf',
    content => "${instance_name}\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }
}
