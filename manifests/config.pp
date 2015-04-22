# = Class: jboss::config
#
# Configures JBoss AS.
# It is intended to be called by jboss::jboss.
#
# == Actions:
#
# * sets the JBoss directories with correct ownership
# * modify <tt>/etc/sudoers</tt> file so to allow jboss user the right to start
#   and stop jboss instances and soffice.bin services
#   and to query open ports with <tt>netstat</tt> and <tt>nmap</tt>
# * schedule a jboss user's cron job for zipping and deleting old log files
# * deploys in the +/usr/local/bin+ directory a script for restarting jboss
#   instances
# * creates standard directories for logging and storing application's specific
#   data under
#   <tt>/var/log/jboss/server</tt> and <tt>/var/lib/jboss/apps</tt>
#   respectively.
# * modify sudoers file as to allow users belonging to the jboss group to
#   start and stop jboss services, start and stop soffice.bin service, make
#   <tt>su jboss</tt>.
class jboss::config () {
  File {
    owner => jboss,
    group => jboss,
  }

  file { '/home/jboss/bin/zip-delete-jboss-server-log':
    ensure => present,
    mode   => '0755',
    source => "puppet:///modules/${module_name}/bin/zip-delete-jboss-server-log",
  }

  file { '/usr/local/bin/manage-jboss-instance':
    ensure => present,
    mode   => '0755',
    source => "puppet:///modules/${module_name}/bin/manage-jboss-instance",
  }

  cron { 'logzipdelete':
    command => 'test -x /home/jboss/bin/zip-delete-jboss-server-log && /home/jboss/bin/zip-delete-jboss-server-log',
    user    => jboss,
    hour    => 5,
    minute  => 0,
  }

  file { '/var/lib/jboss':
    ensure => directory,
  }

  file { '/var/lib/jboss/apps':
    ensure => directory,
  }

  file { '/var/log/jboss':
    ensure => directory,
  }

  file { '/var/log/jboss/server':
    ensure => directory,
  }

  file_line { 'jboss_sudoer':
    path => '/etc/sudoers',
    line => '%jboss ALL=/usr/bin/sudo /bin/su jboss, /bin/su jboss, /usr/bin/sudo /bin/su - jboss, /bin/su - jboss, /bin/su -c * jboss, /usr/sbin/service jboss-* *, /usr/sbin/service soffice.bin *, /bin/netstat *, /usr/bin/nmap *, /usr/bin/puppet agent --enable, /usr/bin/puppet agent --disable, /usr/bin/puppet agent --test',
  }
}