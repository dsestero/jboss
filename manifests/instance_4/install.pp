# Installs a JBoss-4-family instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
#
# @author Dario Sestero
define jboss::instance_4::install (
  $version,
  $profile,
  $environment,
  $backup_conf_target,
  $instance_name = $title,) {
  File {
    owner => jboss,
    group => jboss,
  }

  include java::java_6

  $require = [Class['jboss'], Class['jboss::jboss_4']]

  $jboss_inst_folder = "/opt/jboss-${version}.GA"
  $ip_alias = "${instance_name}-${environment}"

  jboss::instance::install { $instance_name:
  } ->
  exec { "copy_profile_${instance_name}":
    command => "cp -a ${jboss_inst_folder}/server/${profile} ${jboss_inst_folder}/server/${instance_name}",
    creates => "${jboss_inst_folder}/server/${instance_name}",
    require => Class[jboss::config],
  }

  # Righe nel file di configurazione del backup
  @@concat::fragment { "${ip_alias}-configuration":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/server/${instance_name}/conf\n",
    tag     => [$::environment, $::fqdn],
  }

  @@concat::fragment { "${ip_alias}-deployments":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/server/${instance_name}/deploy\n",
    tag     => [$::environment, $::fqdn],
  }

}
