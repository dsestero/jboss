# Install a JBoss-5.1.0.GA instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
#
# @author Dario Sestero
define jboss::instance_5::install (
  $profile,
  $environment,
  $backup_conf_target,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss/server/${instance_name}"
  $ip_alias = "${instance_name}-${environment}"

  File {
    owner => jboss,
    group => jboss,
  }

  include java::java_6

  $require = [Class['jboss'], Class['jboss::jboss_5']]

  jboss::instance::install { $instance_name:
  } ->
  exec { "copy_profile_${instance_name}":
    command => "cp -a /opt/jboss/server/${profile} ${jboss_inst_folder} && rm ${jboss_inst_folder}/conf/jboss-log4j.xml",
    creates => "/opt/jboss/server/${instance_name}",
    require => Class[jboss::config],
  }

  # Righe nel file di configurazione del backup
  @@concat::fragment { "${ip_alias}-configuration":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/conf\n",
    tag     => [$::environment, $::fqdn],
  }

  @@concat::fragment { "${ip_alias}-deployments":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/deploy\n",
    tag     => [$::environment, $::fqdn],
  }

}
