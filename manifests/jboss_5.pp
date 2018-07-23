# Installs JBoss-5.1.0.GA.
#
# == Actions:
#
# * Unzip the distribution under <tt>/opt</tt>, and creates JBoss user and
# group;
# * creates a link <tt>/opt/jboss</tt> pointing to the JBoss-5.1.0.GA
#   installation folder;
# * furthermore, copies a zip of the files needed to deploy jbossws web service
#   under <tt>/opt</tt>
# * and unzip it.
# == Requires:
# see Modulefile
#
# == Sample usage:
#
#  class {'jboss_5': }
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