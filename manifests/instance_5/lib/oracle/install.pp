# Utility define to copy to a specified instance lib folder the Oracle driver
# jar.
#
# Copies the Oracle driver to the lib directory of the specified instance.
#
# Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
#
# @param instance_name Name of the JBoss profile and associated service
# corresponding to this instance.
#                   Defaults to the resource title.
#
# @example Declaring in manifest:
#  jboss::instance::lib::oracle::install {'agri1':
#  }
#
# @author Dario Sestero
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