# Utility define to copy to a specified WildFly-12.0.0 instance the postgresql
# driver jar module.
#
# Creates the postgresql module into the specified instance.
#
# Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
# * The specified instance has to be up and running.
#
# @param instance_name Name of the JBoss profile and associated service
# corresponding to this instance.
#                   Defaults to the resource title.
#
# @param environment Abbreviation identifying the environment: valid values are
# +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#
# @example Declaring in manifest:
#  jboss::instance_12::lib::postgresqlxa::install {'agri1':
#  }
#
# @author Dario Sestero
define jboss::instance_12::lib::postgresqlxa::install (
  $instance_name = $title,
  $environment   = 'dev') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'wildfly-12.0.0.Final'
  $jbossInstFolder = "/opt/wildfly-12-${instance_name}/${jbossVersion}"
  $binFolder = "${jbossInstFolder}/bin"
  $modulesFolder = "${jbossInstFolder}/modules/system/layers/base"
  $postgresqlModulePath = "${modulesFolder}/org/postgresql/main"

  $file_ownership = {
    'owner' => 'jboss',
    'group' => 'jboss',
  }
  $exec_permission = {
    'user'  => 'jboss',
    'group' => 'jboss',
  }

  # module definition
  exec { "create_postgresql_module_folders_${instance_name}":
    command => "mkdir -p ${postgresqlModulePath}",
    creates => $postgresqlModulePath,
    *       => $exec_permission,
  } ->
  file { "${postgresqlModulePath}/module.xml":
    source => "puppet:///modules/${module_name}/lib/postgresqlxa/module.xml",
    *      => $file_ownership,
  } ->
  download_uncompress { "${postgresqlModulePath}/postgresql-9.1-903.jdbc4.jar":
    distribution_name => 'lib/postgresql-9.1-903.jdbc4.jar',
    dest_folder       => $postgresqlModulePath,
    creates           => "${postgresqlModulePath}/postgresql-9.1-903.jdbc4.jar",
    *                 => $exec_permission,
  } ->
  # driver configuration
  file { "${binFolder}/script-driver-postgresql.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-driver-postgresql.txt",
    *      => $file_ownership,
  } ->
  exec { "configure_driver_postgresql_${instance_name}":
    command => "${binFolder}/myjboss-cli.sh --controller=${ip_alias} --file=script-driver-postgresql.txt",
    cwd     => $binFolder,
    unless  => "grep org.postgresql ${jbossInstFolder}/standalone/configuration/standalone.xml",
    *       => $exec_permission,
  }

}
