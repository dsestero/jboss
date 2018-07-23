# = Define: jboss::instance_12::lib::oracle::install
#
# Utility define to copy to a specified WildFly-12.0.0 instance the Oracle driver
# jar module.
#
# @param instance_name Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# @param environment Abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#
# == Actions:
#
# Creates the Oracle module into the specified instance.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
# * The specified instance has to be up and running.
#
# == Sample usage:
#
#  jboss::instance_12::lib::oracle::install {'agri1':
#  }
define jboss::instance_12::lib::oracle::install (
  $instance_name = $title,
  $environment   = 'dev') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'wildfly-12.0.0.Final'
  $jbossInstFolder = "/opt/wildfly-12-${instance_name}/${jbossVersion}"
  $binFolder = "${jbossInstFolder}/bin"
  $modulesFolder = "${jbossInstFolder}/modules/system/layers/base"
  $oracleModulePath = "${modulesFolder}/com/oracle/ojdbc6/main"

  $file_ownership = {
    'owner' => 'jboss',
    'group' => 'jboss',
  }
  $exec_permission = {
    'user'  => 'jboss',
    'group' => 'jboss',
  }

  # module definition
  exec { "create_oracle_module_folders_${instance_name}":
    command => "mkdir -p ${oracleModulePath}",
    creates => $oracleModulePath,
    *       => $exec_permission,
  } ->
  file { "${oracleModulePath}/module.xml":
    source => "puppet:///modules/${module_name}/lib/oracle/module.xml",
    *      => $file_ownership,
  } ->
  download_uncompress { "${oracleModulePath}/ojdbc6.jar":
    distribution_name => 'lib/ojdbc6.jar',
    dest_folder       => $oracleModulePath,
    creates           => "${oracleModulePath}/ojdbc6.jar",
    *                 => $exec_permission,
  } ->
  # driver configuration
  file { "${binFolder}/script-driver-oracle.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-driver-oracle.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_driver_oracle_${instance_name}":
    command => "${binFolder}/myjboss-cli.sh --controller=${ip_alias} --file=script-driver-oracle.txt",
    cwd     => $binFolder,
    unless  => "grep com.oracle.ojdbc6 ${jbossInstFolder}/standalone/configuration/standalone.xml",
    *       => $exec_permission,
  }

}
