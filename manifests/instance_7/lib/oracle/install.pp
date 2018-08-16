# Utility define to copy to a specified WildFly-7.1.1 instance the Oracle driver
# jar module.
#
# Creates the Oracle module into the specified instance.
#
# Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
# * The specified instance has to be up and running.
#
# @param instance_name Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# @param environment Abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#
# @example Declaring in manifest:
#  jboss::instance_7::lib::oracle::install {'agri1':
#  }
#
# @author Dario Sestero
define jboss::instance_7::lib::oracle::install (
  $instance_name = $title,
  $environment   = 'dev') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'jboss-as-7.1.1.Final'
  $jbossInstFolder = "/opt/jboss-7-${instance_name}/${jbossVersion}"
  $binFolder = "${jbossInstFolder}/bin"
  $modulesFolder = "${jbossInstFolder}/modules"
  $oracleModulePath = "${modulesFolder}/com/oracle/ojdbc6/main"

  exec { "create_oracle_module_folders_${instance_name}":
    command => "mkdir -p ${oracleModulePath}",
    creates => $oracleModulePath,
    user    => jboss,
    group   => jboss,
  } ->
  file { "${oracleModulePath}/module.xml":
    source => "puppet:///modules/${module_name}/lib/oracle/module.xml",
    owner  => jboss,
    group  => jboss,
  } ->
  download_uncompress { "${oracleModulePath}/ojdbc6.jar":
    distribution_name => 'lib/ojdbc6.jar',
    dest_folder       => $oracleModulePath,
    creates           => "${oracleModulePath}/ojdbc6.jar",
    user              => jboss,
    group             => jboss,
  } ->
  # Configurazione driver
  file { "${binFolder}/script-driver-oracle.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-driver-oracle.txt",
  } ->
  exec { "configure_driver_oracle_${instance_name}":
    command => "${binFolder}/myjboss-cli.sh --controller=${ip_alias} --file=script-driver-oracle.txt",
    cwd     => $binFolder,
    user    => jboss,
    group   => jboss,
    unless  => "grep com.oracle.ojdbc6 ${jbossInstFolder}/standalone/configuration/standalone.xml",
  }

}
