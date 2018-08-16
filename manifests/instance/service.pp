# @api private
# Sets up a service for a JBoss/WildFly instance.
#
# It is intended to be called by jboss::instance.
#
# @author Dario Sestero
define jboss::instance::service ($environment, $instance_name = $title,) {
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
