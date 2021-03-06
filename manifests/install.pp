# Sets up the system for installing JBoss/WildFly AS.
#
# It is intended to be called by jboss::jboss in order to:
#
# * create JBoss user and group;
# * make <tt>/opt</tt> folder group owned by jboss and group writable;
# * create /home/jboss/bin folder to host some management scripts;
# * according to the parameter <tt>jboss_instance_list</tt> create in /usr/local/bin a text file with all
#     the instance names on the node, one per line.
#
# @param jboss_instance_list [Boolean] should a text file with all instance names on the node, one per line,
#   be created in <tt>/usr/local/bin</tt>?
#
# @author Dario Sestero
class jboss::install (Boolean $jboss_instance_list = false) {

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

  file {
    default:
      owner => 'jboss',
      group => 'jboss',
      ;
    '/opt':
      ensure => present,
      mode   => 'g+w',
      ;
    '/home/jboss/bin':
      ensure  => directory,
      ;
  }

  if $jboss_instance_list {
    Concat::Fragment <<| target == '/usr/local/bin/jboss-instance-list.conf'
    and tag == $facts['networking']['fqdn'] |>> {
    }

    concat { '/usr/local/bin/jboss-instance-list.conf':
      ensure => present,
    }
  }
}