# = Define: jboss::instance_4::config
#
# Configures a JBoss-4.0.5.GA instance,
# i.e. a server profile. It is intended to be called by jboss::instance_4.
define jboss::instance_4::config (
  $version,
  $profile,
  $ip,
  $iface,
  $environment,
  $jmxport,
  $xms,
  $xmx,
  $max_perm_size,
  $stack_size,
  $mgmt_user,
  $mgmt_passwd,
  $jmx_user,
  $jmx_passwd,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss-${version}.GA"
  $shutdown_cmd = 'shutdown.sh -s ${IF} -S'

  $ip_alias = "${instance_name}-${environment}"
  $hot_deploy_status = $environment ? {
    'prep'  => absent,
    'prod'  => absent,
    default => present,
  }

  File {
    owner => jboss,
    group => jboss,
  }

  jboss::instance::config { $instance_name:
    environment => $environment,
    iface       => $iface,
    ip          => $ip,
  }

  # Script di avvio
  file { "${jboss_inst_folder}/bin/run-${instance_name}.sh":
    ensure  => present,
    content => template("${module_name}/run-profile4.sh.erb"),
    mode    => '0755',
  }

  # Init script
  file { "/etc/init.d/jboss-${instance_name}":
    ensure  => present,
    content => template("${module_name}/jboss-init.erb"),
    owner   => root,
    group   => root,
    mode    => '0755',
  }

  # Link a directory log
  file { "${jboss_inst_folder}/server/${instance_name}/log":
    ensure => link,
    target => "/var/log/jboss/server/${instance_name}",
  }

  unless $jmxport == 'no_port' {
    # Sicurezza accesso JMX
    file { "${jboss_inst_folder}/server/${instance_name}/conf/jmxremote.access":
      ensure  => present,
      content => template("${module_name}/conf/jmxremote.access.erb"),
      mode    => '0400',
    }

    file { "${jboss_inst_folder}/server/${instance_name}/conf/jmxremote.password"
    :
      ensure  => present,
      content => template("${module_name}/conf/jmxremote.password.erb"),
      mode    => '0400',
    }
  }

  unless $mgmt_user == undef {
    # Sicurezza console
    file { "${jboss_inst_folder}/server/${instance_name}/conf/props/jmx-console-roles.properties"
    :
      ensure  => present,
      content => template("${module_name}/conf/props/jmx-console-roles.properties.erb"
      ),
      mode    => '0644',
    }

    file { "${jboss_inst_folder}/server/${instance_name}/conf/props/jmx-console-users.properties"
    :
      ensure  => present,
      content => template("${module_name}/conf/props/jmx-console-users.properties.erb"
      ),
      mode    => '0600',
    }

    file { "${jboss_inst_folder}/server/${instance_name}/deploy/jmx-console.war/WEB-INF/jboss-web.xml"
    :
      ensure => present,
      source => "puppet:///modules/${module_name}/deploy/jmx-console.war/WEB-INF/jboss-web.xml",
    }

    file { "${jboss_inst_folder}/server/${instance_name}/deploy/jmx-console.war/WEB-INF/web.xml"
    :
      ensure => present,
      source => "puppet:///modules/${module_name}/deploy/jmx-console.war/WEB-INF/web.xml",
    }
  }
}