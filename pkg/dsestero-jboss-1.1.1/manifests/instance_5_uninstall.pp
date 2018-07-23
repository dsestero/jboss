class jboss::instance_5_uninstall (
  $instance_name = $::instance_to_remove_name,
  $ip            = $::instance_to_remove_ip,
  $environment   = $::environment,) {
  $ip_alias = "${instance_name}-${environment}"

  # Servizio
  service { "jboss-${instance_name}":
    ensure    => stopped,
    enable    => false,
    hasstatus => false,
    pattern   => "-c ${instance_name}",
    stop      => "/usr/local/bin/manage-jboss-instance ${instance_name} stop",
    path      => '/etc/init.d',
  } ->
  # Profilo
  file { "/opt/jboss/server/${instance_name}":
    ensure => absent,
    force  => true,
  } ->
  # Script di avvio
  file { "/opt/jboss/bin/run-${instance_name}.sh":
    ensure => absent,
  } ->
  # Directory log del server
  file { "/var/log/jboss/server/${instance_name}":
    ensure => absent,
    force  => true,
  } ->
  # Nome logico istanza in /etc/hosts
  host { $ip_alias:
    ensure => absent,
    ip     => $ip,
  }
}