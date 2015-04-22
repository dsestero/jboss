# = Define: jboss::instance_5::lib::oracle::install
#
# Utility define to copy to a spoecified instance lib folder the Oracle driver
# jar.
#
# == Parameters:
#
# $instance_name::  Name of the JBoss profile and associated service
# corresponding to this instance.
#                   Defaults to the resource title.
#
# == Actions:
#
# Copies the Oracle driver to the lib directory of the specified instance.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
#
# == Sample usage:
#
#  jboss::instance::lib::oracle::install {'agri1':
#  }
define jboss::instance_5::lib::oracle::install ($instance_name = $title,) {
  $require = Class['jboss']

  $libfolder = "/opt/jboss/server/${instance_name}/lib"

  download_uncompress { "${libfolder}/ojdbc14.jar":
    distribution_name => 'lib/ojdbc14.jar',
    dest_folder       => $libfolder,
    creates           => "${libfolder}/ojdbc14.jar",
    user              => jboss,
    group             => jboss,
  }
}