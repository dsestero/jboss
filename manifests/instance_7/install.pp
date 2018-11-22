# Install a JBoss-7 instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
#
# According to https://stackoverflow.com/questions/48403832/javax-xml-parsers-factoryconfigurationerror-running-jboss-as-7-1-with-java-7-upd/48561492#48561492
# the +jboss-modules.jar+ in the JBoss installation folder is replaced with a more recent (1.1.5.GA) version.
# The version of jboss-modules which comes with jboss-7.1.1.Final is 1.1.1.GA and it has a few issues with initialisation order and multiple-initialisation.
#
# @author Dario Sestero
define jboss::instance_7::install (
  $environment,
  $jbossdirname,
  $distribution_name,
  $backup_conf_target,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss-7-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"

  include java::java_7, jboss::instance::dependencies

  $require = [Class['jboss'], Class['jboss::jboss_7']]

  jboss::instance::install { $instance_name:
  }

  download_uncompress { "install_jboss_7_${instance_name}":
    distribution_name => $distribution_name,
    dest_folder       => "/opt/jboss-7-${instance_name}",
    creates           => "/opt/jboss-7-${instance_name}",
    uncompress        => 'zip',
    user              => jboss,
    group             => jboss,
  } ~>
  download_uncompress { "install_jboss_7_jbmodules_${instance_name}":
    distribution_name => 'lib/jboss-modules.jar',
    dest_folder       => $jboss_inst_folder,
    wget_options      => '--backups=1',
    refreshonly       => true,
    uncompress        => 'none',
    user              => jboss,
    group             => jboss,
  }

  # backup configuration lines
  @@concat::fragment { "${ip_alias}-modules":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/modules\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }

  @@concat::fragment { "${ip_alias}-standalone-configuration":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/standalone/configuration\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }

  @@concat::fragment { "${ip_alias}-standalone-deployments":
    target  => $backup_conf_target,
    content => "${jboss_inst_folder}/standalone/deployments\n",
    tag     => [$::environment, $facts['networking']['fqdn']],
  }

}