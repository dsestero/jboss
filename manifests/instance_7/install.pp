# = Define: jboss::instance_7::install
#
# Install a JBoss-7 instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance_7::install ($instance_name = $title, $environment, $jbossdirname, $distribution_name, $backup_conf_target,) {
  $jboss_inst_folder = "/opt/jboss-8-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"

  File {
    owner => jboss,
    group => jboss,
  }

  include java::java_7, jboss::instance::dependencies

  $require = [Class['jboss'], Class['jboss::jboss_7']]

  jboss::instance::install { "${instance_name}":
  }

  download_uncompress { "install_jboss_7_${instance_name}":
    distribution_name => $distribution_name,
    dest_folder       => "/opt/jboss-7-${instance_name}",
    creates           => "/opt/jboss-7-${instance_name}",
    uncompress        => 'zip',
    user              => jboss,
    group             => jboss,
  }

  # Righe nel file di configurazione del backup
  @@concat::fragment { "${ip_alias}-modules":
    target  => "${backup_conf_target}",
    content => "${jboss_inst_folder}/modules\n",
    tag     => ["${::environment}", "${::fqdn}"],
  }

  @@concat::fragment { "${ip_alias}-standalone-configuration":
    target  => "${backup_conf_target}",
    content => "${jboss_inst_folder}/standalone/configuration\n",
    tag     => ["${::environment}", "${::fqdn}"],
  }

  @@concat::fragment { "${ip_alias}-standalone-deployments":
    target  => "${backup_conf_target}",
    content => "${jboss_inst_folder}/standalone/deployments\n",
    tag     => ["${::environment}", "${::fqdn}"],
  }

}