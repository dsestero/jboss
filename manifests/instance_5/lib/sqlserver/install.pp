# = Define: jboss::instance_5::lib::sqlserver::install
#
# Utility define to copy to a specified instance lib folder the SqlServer driver jar.
#
# == Parameters:
#
# $instance_name::  Name of the JBoss profile and associated service corresponding to this instance.
#                   Defaults to the resource title.
#
# == Actions:
#
# Copies the SqlServer driver to the lib directory of the specified instance.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
#
# == Sample usage:
#
#  jboss::instance::lib::sqlserver::install {'cultura':
#  }
define jboss::instance_5::lib::sqlserver::install ($instance_name = $title,) {
  $require = Class['jboss']

  $libfolder = "/opt/jboss/server/${instance_name}/lib"

  download_uncompress { "${libfolder}/sqljdbc4.jar":
    distribution_name => 'lib/sqljdbc4.jar',
    dest_folder       => "${libfolder}",
    creates           => "${libfolder}/sqljdbc4.jar",
    user              => jboss,
    group             => jboss,
  }
}