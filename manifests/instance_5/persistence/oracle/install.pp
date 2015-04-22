# = Define: jboss::instance_5::persistence::oracle::install
#
# Utility define to add to a specified instance the Oracle persistence service
# for <tt>DefaultDS</tt>.
#
# $instance_name::  Name of the JBoss profile and associated service
# corresponding to this instance.
#                   Defaults to the resource title.
#
# $conn_url_suffix:: Suffix of the connection url string, containing the ip
# address of the rdbms, the port number, and the SID
# separated by colon.
# $conn_url_username:: Username for accessing the rdbms.
# $conn_url_password:: Password for accessing the rdbms.
#
# == Actions:
#
# Copies the Oracle persistence service file to the <tt>deploy/messaging</tt>
# directory of the specified instance.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
#
# == Sample usage:
#
#  jboss::instance::persistence::oracle::install {'sani':
#    conn_url_suffix    => '172.16.4.91:1523:RAVDASVL',
#    conn_url_username  => 'sani',
#    conn_url_password  => 'sani',
#  }
define jboss::instance_5::persistence::oracle::install (
  $conn_url_suffix,
  $conn_url_username,
  $conn_url_password,
  $instance_name = $title,) {
  $require = Class['jboss']

  $deployfolder = "/opt/jboss/server/${instance_name}/deploy"

  file { "${deployfolder}/messaging/oracle-persistence-service.xml":
    ensure => present,
    source => "puppet:///modules/${module_name}/deploy/messaging/oracle-persistence-service.xml",
    owner  => jboss,
    group  => jboss,
  }

  file { "${deployfolder}/messaging/hsqldb-persistence-service.xml":
    ensure => absent,
    owner  => jboss,
    group  => jboss,
  }

  file { "${deployfolder}/${instance_name}-default-ds.xml":
    ensure  => present,
    content => template("${module_name}/oracle-default-ds.xml.erb"),
    owner   => jboss,
    group   => jboss,
  }

  file { "${deployfolder}/hsqldb-ds.xml":
    ensure => absent,
    owner  => jboss,
    group  => jboss,
  }
}