# Utility define to copy to a specified WildFly-8.2.0 instance the sqlserver
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
# @param driver Name of the driver file to use.
#                   Defaults to sqljdbc4.jar, JDBC 4.0 compliant.
#
# @example Declaring in manifest:
#  jboss::instance_8::lib::sqlserver::install {'agri1':
#  }
#
# @author Dario Sestero
define jboss::instance_8::lib::sqlserver::install (
  $instance_name = $title,
  $environment   = 'dev',
  $driver        = 'sqljdbc4.jar') {

  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'wildfly-8.2.0.Final'
  $jbossInstFolder = "/opt/jboss-8-${instance_name}/${jbossVersion}"
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
    content => template("${module_name}/lib/sqlserver/module.xml.erb"),
    *      => $file_ownership,
  } ->
  download_uncompress { "${sqlserverModulePath}/${driver}":
    distribution_name => "lib/${driver}",
    dest_folder       => $sqlserverModulePath,
    creates           => "${sqlserverModulePath}/${driver}",
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
