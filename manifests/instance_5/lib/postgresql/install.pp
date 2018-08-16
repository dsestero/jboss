# Utility define to copy to a specified instance lib folder the Postgresql driver
# jar.
#
# Copies the Postgresql driver to the lib directory of the specified instance.
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
#  jboss::instance::lib::postgresql::install {'agri2':
#  }
#
# @author Dario Sestero
define jboss::instance_5::lib::postgresql::install ($instance_name = $title,) {
  $require = Class['jboss']

  $libfolder = "/opt/jboss/server/${instance_name}/lib"

  download_uncompress { "${libfolder}/postgresql-42.1.1.jre6.jar":
    distribution_name => 'lib/postgresql-42.1.1.jre6.jar',
    dest_folder       => $libfolder,
    creates           => "${libfolder}/postgresql-42.1.1.jre6.jar",
    user              => jboss,
    group             => jboss,
  }
}