
# TODO To be completed and verified
class jboss::jboss_5_uninstall {
  file { '/opt/jboss-5.1.0.GA-jdk6.zip':
    ensure => absent,
  }

  file { '/opt/jboss-5.1.0.GA':
    ensure => absent,
    force  => true,
  }

  file { '/opt/jboss':
    ensure => absent,
  }

  file { '/var/log/jboss':
    ensure => absent,
    force  => true,
  }

  file { '/var/lib/jboss':
    ensure => absent,
    force  => true,
  }

  user { 'jboss':
    ensure => absent,
  }

  group { 'jboss':
    ensure => absent,
  }

  file { '/home/jboss':
    ensure => absent,
    force  => true,
  }

}
