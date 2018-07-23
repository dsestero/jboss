# = Define: jboss::instance_7::lib::postgresql::install
#
# Utility define to copy to a specified JBoss-7.1.1 instance the postgresql
# driver jar module.
#
# == Parameters:
#
# @param instance_name Name of the JBoss profile and associated service
# corresponding to this instance.
#                   Defaults to the resource title.
#
# @param environment Abbreviation identifying the environment: valid values are
# +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#
# == Actions:
#
# Creates the postgresql module into the specified instance.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
# * The specified instance has to be up and running.
#
# == Sample usage:
#
#  jboss::instance_7::lib::postgresql::install {'agri1':
#  }
define jboss::instance_7::lib::postgresql::install (
  $instance_name = $title,
  $environment   = 'dev') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = 'jboss-as-7.1.1.Final'
  $jbossInstFolder = "/opt/jboss-7-${instance_name}/${jbossVersion}"
  $binFolder = "${jbossInstFolder}/bin"
  $modulesFolder = "${jbossInstFolder}/modules"
  $postgresqlModulePath = "${modulesFolder}/org/postgresql/main"

  exec { "create_postgresql_module_folders_${instance_name}":
    command => "mkdir -p ${postgresqlModulePath}",
    creates => $postgresqlModulePath,
    user    => jboss,
    group   => jboss,
  } ->
  file { "${postgresqlModulePath}/module.xml":
    source => "puppet:///modules/${module_name}/lib/postgresql/module.xml",
    owner  => jboss,
    group  => jboss,
  } ->
  download_uncompress { "${postgresqlModulePath}/postgresql-9.1-903.jdbc4.jar":
    distribution_name => 'lib/postgresql-9.1-903.jdbc4.jar',
    dest_folder       => $postgresqlModulePath,
    creates           => "${postgresqlModulePath}/postgresql-9.1-903.jdbc4.jar",
    user              => jboss,
    group             => jboss,
  } ->
  # Configurazione driver
  file { "${binFolder}/script-driver-postgresql.txt":
    ensure => present,
    source => "puppet:///modules/${module_name}/bin/script-driver-postgresql.txt",
  } ->
  exec { "configure_driver_postgresql_${instance_name}":
    command => "${binFolder}/jboss-cli.sh --controller=${ip_alias} --file=script-driver-postgresql.txt",
    cwd     => $binFolder,
    user    => jboss,
    group   => jboss,
    unless  => "grep org.postgresql ${jbossInstFolder}/standalone/configuration/standalone.xml",
  }

}
