# Utility define to copy to a specified WildFly-12.0.0 instance the sqlserver
# driver jar module.
#
# Creates the sqlserver module into the specified instance.
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
# +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#
# @example Declaring in manifest:
#  jboss::instance_12::lib::sqlserver::install {'agri1':
#  }
#
# @author Dario Sestero
define jboss::instance_12::lib::sqlserver::install (
  $instance_name = $title,
  $environment   = 'dev') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'wildfly-12.0.0.Final'
  $jbossInstFolder = "/opt/wildfly-12-${instance_name}/${jbossVersion}"
  $binFolder = "${jbossInstFolder}/bin"
  $modulesFolder = "${jbossInstFolder}/modules/system/layers/base"
  $sqlserverModulePath = "${modulesFolder}/com/microsoft/sqljdbc4/main"

  $file_ownership = {
    'owner' => 'jboss',
    'group' => 'jboss',
  }
  $exec_permission = {
    'user'  => 'jboss',
    'group' => 'jboss',
  }

  # module definition
  exec { "create_sqlserver_module_folders_${instance_name}":
    command => "mkdir -p ${sqlserverModulePath}",
    creates => $sqlserverModulePath,
    *       => $exec_permission,
  } ->
  file { "${sqlserverModulePath}/module.xml":
    source => "puppet:///modules/${module_name}/lib/sqlserver/module.xml",
    *      => $file_ownership,
  } ->
  download_uncompress { "${sqlserverModulePath}/sqljdbc4.jar":
    distribution_name => 'lib/sqljdbc4.jar',
    dest_folder       => $sqlserverModulePath,
    creates           => "${sqlserverModulePath}/sqljdbc4.jar",
    *                 => $exec_permission,
  } ->
  # driver configuration
  file { "${binFolder}/script-driver-sqlserver.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-driver-sqlserver.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_driver_sqlserver_${instance_name}":
    command => "${binFolder}/myjboss-cli.sh --controller=${ip_alias} --file=script-driver-sqlserver.txt",
    cwd     => $binFolder,
    unless  => "grep com.microsoft.sqljdbc4 ${jbossInstFolder}/standalone/configuration/standalone.xml",
    *       => $exec_permission,
  }

}
