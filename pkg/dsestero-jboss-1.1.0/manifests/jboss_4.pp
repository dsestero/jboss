# = Define: jboss::jboss_4
#
# Installs JBoss-4. The resource title has to be an unique name identifying the
# JBoss installation and it could be used to specify
# the desired version.
# Supported versions are: <tt>4.0.0</tt>, <tt>4.0.2</tt>, <tt>4.0.4</tt>,
# <tt>4.0.5</tt>, <tt>4.2.0</tt>, <tt>4.2.1</tt>,
# <tt>4.2.2</tt>, <tt>4.2.3</tt>.
#
# == Parameters:
#
# $version::   JBoss version. It has to be a three number string denoting a
#              specific version in the JBoss-4 family.
#              Defaults to the resource title.
#
# $jdksuffix:: The string indicating the possible suffix of the filename to
#              specify the jdk used to compile the distribution.
#              Defaults to ''.
#
# == Actions:
#
# * Downloads the distribution from SourceForge and
# * Unzip the distribution under <tt>/opt</tt>.
#
# Note that the download of the distribution takes place only if the
# distribution is not present in <tt>/tmp</tt> and the
# distribution was not yet unzipped.
#
# == Requires:
# see Modulefile
#
# == Sample usage:
#
#  jboss_4 {'4.0.5':}
#
define jboss::jboss_4 ($version = undef, $jdksuffix = '',) {
  include jboss

  if $version == undef {
    $jversion = $title
  }

  $jboss_dist = "${jversion}.GA${jdksuffix}"
  $jboss_inst_folder = "jboss-${jversion}.GA"

  download_uncompress { "install_${jboss_inst_folder}":
    download_base_url => 'http://sourceforge.net/projects/jboss/files/JBoss',
    distribution_name => "JBoss-${jversion}.GA/jboss-${jboss_dist}.zip/download",
    dest_folder       => '/opt',
    creates           => "/opt/${jboss_inst_folder}",
    uncompress        => 'zip',
    user              => jboss,
    group             => jboss,
  }
}