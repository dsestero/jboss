# = Define: jboss::instance::service
#
# Sets up a service for a JBoss-5.1.0.GA instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance::service ($instance_name = $title, $environment,) {
  $ip_alias = "${instance_name}-${environment}"

  service { "jboss-${instance_name}":
    ensure    => running,
    enable    => true,
    hasstatus => false,
    pattern   => "-b ${ip_alias}",
    stop      => "/usr/local/bin/manage-jboss-instance ${instance_name} stop",
    path      => '/etc/init.d',
  }

}
