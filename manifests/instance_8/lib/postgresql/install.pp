# Utility define to copy to a specified WildFly-8.2.0 instance the postgresql
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
# @param driver Name of the driver file to use.
#                   Defaults to postgresql-42.2.5.jre7.jar that is JDBC 4.1 compliant (recommended for jre7).
#
# @example Declaring in manifest:
#  jboss::instance_8::lib::postgresql::install {'agri1':
#  }
#
# @author Dario Sestero
define jboss::instance_8::lib::postgresql::install (
  $instance_name = $title,
  $environment   = 'dev',
  $driver        = 'postgresql-42.2.5.jre7.jar') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'wildfly-8.2.0.Final'
  $jbossInstFolder = "/opt/jboss-8-${instance_name}/${jbossVersion}"
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
    content => template("${module_name}/lib/postgresql/module.xml.erb"),
    *       => $file_ownership,
  } ->
  download_uncompress { "${postgresqlModulePath}/${driver}":
    distribution_name => "lib/${driver}",
    dest_folder       => $postgresqlModulePath,
    creates           => "${postgresqlModulePath}/${driver}",
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
