# = Define: jboss::instance_4
#
# Creates, configures and set up the service for a JBoss-4.0.5.GA instance,
# i.e. a server profile with all the
# configurations needed to use it as an independent service.
#
# == Parameters:
#
# $instance_name::  Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# $version::        JBoss version. It has to be a three number string denoting a
#                   specific version in the JBoss-4 family.
#
# $profile::        Name of the standard JBoss profile from which this one is
#                   derived.
#                   As of JBoss-4.0.5.GA different profiles are provided with a
#                   different level of services made available; they
#                   are:
#                   +minimal+, +web+, +default+, +all+.
#                   Defaults to +default+.
#
# $ip::             Dedicated IP on which this instance will be listening.
#                   Defaults to <tt>127.0.0.1</tt> i.e. localhost.
#
# $iface::          Name of the secondary network interface dedicated to this
#                   instance.
#                   Defaults to +undef+, in which case a secondary network
#                   interface to bind the jboss instance is not created.
#
# $environment::    Abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#                   *Note:* hot code deployment is disabled in the environments
#                   +prep+ and +prod+, enabled on +dev+ and +test+.
#
# $jmxport::        JMX port to use to monitor this instance.
#                   Defaults to +'no_port'+, in which case no JMX monitoring is
#                   activated.
#
# $xms::            JVM OPT for initial heap size.
#                   Defaults to +128m+.
#
# $xmx::            JVM OPT for maximum heap size.
#                   Defaults to +512m+.
#
# $max_perm_size::  JVM OPT for max permanent generations size.
#                   Defaults to +256m+.
#
# $stack_size::     JVM OPT for stack size.
#                   Defaults to +2048k+.
#
# $mgmt_user::      Management user username.
#                   Defaults to +undef+, in which case no security is enforced
#                   on the JBoss console.
#
# $mgmt_passwd::    Management user password.
#                   Defaults to +undef+.
#
# $jmx_user::       JMX user username.
#                   Defaults to +undef+.
#
# $jmx_passwd::     JMX user password.
#                   Defaults to +undef+.
#
# $backup_conf_target:: Full pathname of the backup configuration file where the
#                       instance paths
#                       to backup are added.
#                       Defaults to <tt>/usr/local/bin/backupall.sh.conf</tt>.
#
# == Actions:
#
# Declares all other classes in the jboss module needed for installing a jboss
# server profile.
# Currently, these consists of jboss::instance::install,
# jboss::instance::config, and jboss::instance::service.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Class['java::java_6'] for installing and setting up java6-jdk.
#
# == Sample usage:
#
#  jboss::instance_4 { 'fina':
#    profile     => 'all',
#    environment => 'preprod',
#    ip          => '172.16.12.11',
#    iface       => 'eth0:2',
#    jmxport     => '12345',
#  }
define jboss::instance_4 (
  $version,
  $instance_name      = $title,
  $profile            = 'default',
  $ip                 = '127.0.0.1',
  $iface              = undef,
  $environment        = 'dev',
  $jmxport            = 'no_port',
  $ws_enabled         = false,
  $xms                = '128m',
  $xmx                = '512m',
  $max_perm_size      = '256m',
  $stack_size         = '1024k',
  $mgmt_user          = undef,
  $mgmt_passwd        = undef,
  $jmx_user           = undef,
  $jmx_passwd         = undef,
  $backup_conf_target = '/usr/local/bin/backupall.sh.conf',) {
  jboss::instance_4::install { $instance_name:
    version            => $version,
    profile            => $profile,
    environment        => $environment,
    backup_conf_target => $backup_conf_target,
  } ->
  jboss::instance_4::config { $instance_name:
    ip            => $ip,
    version       => $version,
    profile       => $profile,
    iface         => $iface,
    environment   => $environment,
    jmxport       => $jmxport,
    xms           => $xms,
    xmx           => $xmx,
    max_perm_size => $max_perm_size,
    stack_size    => $stack_size,
    mgmt_user     => $mgmt_user,
    mgmt_passwd   => $mgmt_passwd,
    jmx_user      => $jmx_user,
    jmx_passwd    => $jmx_passwd,
  } ~>
  jboss::instance::service { $instance_name:
    environment => $environment,
  }
}