# @api private
# Configures a running JBoss-8 instance via jboss-cli.
# It is intended to be called by jboss::instance_8.
#
# @author Dario Sestero
define jboss::instance_8::postconfig (
  $ip,
  $iface,
  $environment,
  $jbossdirname,
  $mgmt_user,
  $mgmt_passwd,
  $instance_name = $title,) {

  $jboss_inst_folder = "/opt/jboss-8-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"
  $auth_string = $mgmt_user ? {
    undef   => '',
    default => "--user=${mgmt_user} --password=${mgmt_passwd}",
  }
  $hot_deploy_status = $environment ? {
    'prep'  => absent,
    'prod'  => absent,
    default => present,
  }
  $file_ownership = {
    'owner' => 'jboss',
    'group' => 'jboss',
  }

  # log configuration
  file { "${jboss_inst_folder}/bin/script-logger-prestazioni.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-logger-prestazioni.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_logger_prestazioni_${instance_name}":
    command => "${jboss_inst_folder}/bin/myjboss-cli.sh --controller=${ip_alias} --file=script-logger-prestazioni.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep prestazioni ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }

  # ajp configuration
  file { "${jboss_inst_folder}/bin/script-ajp.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-ajp8.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_ajp_${instance_name}":
    command => "${jboss_inst_folder}/bin/myjboss-cli.sh --controller=${ip_alias} --file=script-ajp.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep defaultAJPListener ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }

  # jmx configuration
  file { "${jboss_inst_folder}/bin/script-jmx.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-jmx8.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_jmx_${instance_name}":
    command => "${jboss_inst_folder}/bin/myjboss-cli.sh --controller=${ip_alias} --file=script-jmx.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep org.apache.tomcat.util.ENABLE_MODELER ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }

  # Workaround to prevent memory leak bug when using JMX
  file { "${jboss_inst_folder}/bin/script-jmx-memleak-wkaround.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-jmx-memleak-wkaround.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_jmx_memleak-wkaround${instance_name}":
    command => "${jboss_inst_folder}/bin/myjboss-cli.sh --controller=${ip_alias} --file=script-jmx-memleak-wkaround.txt",
    cwd     => "${jboss_inst_folder}/bin",
    user    => jboss,
    group   => jboss,
    unless  => "grep jboss.remoting.pooled-buffers ${jboss_inst_folder}/standalone/configuration/standalone.xml",
  }
}