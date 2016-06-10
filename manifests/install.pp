# = Class: jboss::install
#
# Sets up the system for installing JBoss AS.
# It is intended to be called by jboss::jboss.
#
# == Actions:
#
# * Creates JBoss user and group;
# * makes <tt>/opt</tt> folder group owned by jboss and group writable;
# * creates /home/jboss/bin folder to host some management scripts;
# * creates in /home/jboss/bin a text file with all the instance names on the
# node, one per line.
class jboss::install (){
  user { 'jboss':
    ensure     => present,
    comment    => 'JBoss user',
    gid        => 'jboss',
    shell      => '/bin/bash',
    managehome => true,
  }

  group { 'jboss':
    ensure => present,
  }

  file { '/opt':
    ensure => present,
    group  => jboss,
    mode   => 'g+w',
  }

  file { '/home/jboss/bin':
    ensure  => directory,
    require => User['jboss'],
  }

  Concat::Fragment <<| target == '/home/jboss/bin/jboss-instance-list.conf' and
  tag == $::fqdn |>> {
  }

  concat { '/home/jboss/bin/jboss-instance-list.conf':
    ensure => present,
  }

}