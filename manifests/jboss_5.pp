# Installs JBoss-5.1.0.GA.
#
# @example Declaring in manifest:
#  include jboss_5
#
# @author Dario Sestero
class jboss::jboss_5 {
  include jboss

  file { '/opt/jboss':
    ensure  => link,
    target  => '/opt/jboss-5.1.0.GA',
    owner   => root,
    group   => root,
    require => Class['jboss::install'],
  }

  download_uncompress { 'install_jboss_5':
    distribution_name => 'jboss-5.1.0.GA-jdk6.zip',
    dest_folder       => '/opt',
    creates           => '/opt/jboss-5.1.0.GA',
    uncompress        => 'zip',
    user              => jboss,
    group             => jboss,
  }
}