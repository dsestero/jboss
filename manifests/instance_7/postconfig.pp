# = Define: jboss::instance_7::postconfig
#
# Configures a running JBoss-7 instance via jboss-cli.
# It is intended to be called by jboss::instance_7.
define jboss::instance_7::postconfig (
  $ip,
  $iface,
  $environment,
  $jbossdirname,
  $mgmt_user,
  $mgmt_passwd,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss-7-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"
  $auth_string = $mgmt_user ? {
    undef   => '',
    default => "--user=${mgmt_user} --password=${mgmt_passwd}",
  }
  $shutdown_cmd = "jboss-cli.sh --connect --controller=${ip_alias}:9999 ${auth_string} command=:shutdown"

  $hot_deploy_status = $environment ? {
    'prep'  => absent,
    'prod'  => absent,
    default => present,
  }

  File {
    owner => jboss,
    group => jboss,
  }

  # Configurazione log
  file { "${jboss_inst_folder}/bin/script-logger-prestazioni.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-logger-prestazioni.txt",
  } ->
  exec { "configure_logger_prestazioni_${instance_name}":
    command => "${jboss_inst_folder}/bin/jboss-cli.sh --controller=${ip_alias} --file=script-logger-prestazioni.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep prestazioni ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }

  # Configurazione ajp
  file { "${jboss_inst_folder}/bin/script-ajp.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-ajp.txt",
  } ->
  exec { "configure_ajp_${instance_name}":
    command => "${jboss_inst_folder}/bin/jboss-cli.sh --controller=${ip_alias} --file=script-ajp.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep AJP/1.3 ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }

  # Configurazione JMX
  file { "${jboss_inst_folder}/bin/script-jmx.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-jmx.txt",
  } ->
  exec { "configure_jmx_${instance_name}":
    command => "${jboss_inst_folder}/bin/jboss-cli.sh --controller=${ip_alias} --file=script-jmx.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep 7777 ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }
}