# Utility define to copy to a specified instance lib folder the zk library
# jars.
#
# Copies the zk libraries to the lib directory of the specified instance.
#
# Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the libraries have to be copied.
#
# @param instance_name Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# @example Declaring in manifest:
#
#  jboss::instance::lib::zk::install {'agri1':
#  }
#
# @author Dario Sestero
define jboss::instance_5::lib::zk::install ($instance_name = $title,) {
  $require = Class['jboss']

  $libfolder = "/opt/jboss/server/${instance_name}/lib"

  Download_uncompress {
    dest_folder => $libfolder,
    user        => jboss,
    group       => jboss,
  }

  download_uncompress { "${libfolder}/bsh-2.0b4.jar":
    distribution_name => 'lib/bsh-2.0b4.jar',
    creates           => "${libfolder}/bsh-2.0b4.jar",
  }

  download_uncompress { "${libfolder}/commons-fileupload-1.2.1.jar":
    distribution_name => 'lib/commons-fileupload-1.2.1.jar',
    creates           => "${libfolder}/commons-fileupload-1.2.1.jar",
  }

  download_uncompress { "${libfolder}/commons-io-1.3.2.jar":
    distribution_name => 'lib/commons-io-1.3.2.jar',
    creates           => "${libfolder}/commons-io-1.3.2.jar",
  }

  download_uncompress { "${libfolder}/zcommon-3.6.3.jar":
    distribution_name => 'lib/zcommon-3.6.3.jar',
    creates           => "${libfolder}/zcommon-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zcommons-el-1.0.2.jar":
    distribution_name => 'lib/zcommons-el-1.0.2.jar',
    creates           => "${libfolder}/zcommons-el-1.0.2.jar",
  }

  download_uncompress { "${libfolder}/zhtml-3.6.3.jar":
    distribution_name => 'lib/zhtml-3.6.3.jar',
    creates           => "${libfolder}/zhtml-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zk-3.6.3.jar":
    distribution_name => 'lib/zk-3.6.3.jar',
    creates           => "${libfolder}/zk-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zkjsp-1.4.0.jar":
    distribution_name => 'lib/zkjsp-1.4.0.jar',
    creates           => "${libfolder}/zkjsp-1.4.0.jar",
  }

  download_uncompress { "${libfolder}/zkplus-3.6.3.jar":
    distribution_name => 'lib/zkplus-3.6.3.jar',
    creates           => "${libfolder}/zkplus-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zul-3.6.3.jar":
    distribution_name => 'lib/zul-3.6.3.jar',
    creates           => "${libfolder}/zul-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zweb-3.6.3.jar":
    distribution_name => 'lib/zweb-3.6.3.jar',
    creates           => "${libfolder}/zweb-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zkex-3.6.3.jar":
    distribution_name => 'lib/zkex-3.6.3.jar',
    creates           => "${libfolder}/zkex-3.6.3.jar",
  }

  download_uncompress { "${libfolder}/zkmax-3.6.3.jar":
    distribution_name => 'lib/zkmax-3.6.3.jar',
    creates           => "${libfolder}/zkmax-3.6.3.jar",
  }
}