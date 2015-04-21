# = Define: jboss::instance_4::install
#
# Install a JBoss-4-family instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance_4::install ($instance_name = $title, $version, $profile, $environment, $backup_conf_target,) {
  File {
    owner => jboss,
    group => jboss,
  }

  include java::java_6

  $require = [Class['jboss'], Class['jboss::jboss_4']]

  $jboss_inst_folder = "jboss-${version}.GA"
  $ip_alias = "${instance_name}-${environment}"

  jboss::instance::install { "${instance_name}":
  } ->
  exec { "copy_profile_${instance_name}":
    #    command => "cp -a /opt/${jboss_inst_folder}/server/${profile} /opt/${jboss_inst_folder}/server/${instance_name} && rm
    #    /opt/${jboss_inst_folder}/server/${instance_name}/conf/jboss-log4j.xml",
    command => "cp -a /opt/${jboss_inst_folder}/server/${profile} /opt/${jboss_inst_folder}/server/${instance_name}",
    creates => "/opt/${jboss_inst_folder}/server/${instance_name}",
    require => Class[jboss::config],
  }

  # Righe nel file di configurazione del backup
  @@concat::fragment { "${ip_alias}-configuration":
    target  => "${backup_conf_target}",
    content => "${jboss_inst_folder}/server/${instance_name}/conf\n",
    tag     => ["${::environment}", "${::fqdn}"],
  }

  @@concat::fragment { "${ip_alias}-deployments":
    target  => "${backup_conf_target}",
    content => "${jboss_inst_folder}/server/${instance_name}/deploy\n",
    tag     => ["${::environment}", "${::fqdn}"],
  }

}
