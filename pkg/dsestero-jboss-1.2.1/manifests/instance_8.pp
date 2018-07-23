# = Define: jboss::instance_8
#
# Creates, configures and set up the service for a WildFly-8.2.0.Final instance,
# i.e. a server profile with all the
# configurations needed to use it as an independent service.
# *Note*: at this time the instance is created as a standalone standard profile.
#
# == Parameters:
#
# $instance_name::  Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# $ip::             Dedicated IP on which this instance will be listening.
#                   Defaults to <tt>127.0.0.1</tt> i.e. localhost.
#
# $iface::          Name of the secondary network interface dedicated to this
# instance.
#                   Defaults to +undef+, in which case a secondary network
#                   interface to bind the jboss instance is not created.
#
# $environment::    Abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#                   *Note:* hot code deployment is disabled in the environments
#                   +prep+ and +prod+, enabled on +dev+ and +test+.
#
# $distribution_name:: Name of the distribution bundle to download, used for
#                      installing customed distributions.
#                      Defaults to <tt> wildfly-8.2.0.Final.tar.gz</tt>
#
# $jbossdirname::   Name of the jboss installation folder.
#                   Defaults to +wildfly-8.2.0.Final+
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
#                   Defaults to +undef+, in which case a management user is not
#                   created.
#
# $mgmt_passwd::    Management user password.
#                   Defaults to +undef+.
#
# $backup_conf_target:: Full pathname of the backup configuration file where the
#                       instance paths to backup are added.
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
# * Class['java::java_7'] for installing and setting up java7-jdk.
#
# == Sample usage:
#
#  jboss::instance_8 { 'fina':
#    environment => 'preprod',
#    ip          => '172.16.12.11',
#    iface       => 'eth0:2',
#    jmxport     => '12345',
#  }
define jboss::instance_8 (
  $instance_name      = $title,
  $ip                 = '127.0.0.1',
  $iface              = undef,
  $environment        = 'dev',
  $distribution_name  = 'wildfly-8.2.0.Final.tar.gz',
  $jbossdirname       = 'wildfly-8.2.0.Final',
  $xms                = '128m',
  $xmx                = '512m',
  $max_perm_size      = '256m',
  $stack_size         = '2048k',
  $mgmt_user          = undef,
  $mgmt_passwd        = undef,
  $backup_conf_target = '/usr/local/bin/backupall.sh.conf',) {
  require jboss::params

  jboss::instance_8::install { $instance_name:
    distribution_name  => $distribution_name,
    environment        => $environment,
    jbossdirname       => $jbossdirname,
    backup_conf_target => $backup_conf_target,
  } ->
  jboss::instance_8::config { $instance_name:
    ip            => $ip,
    iface         => $iface,
    environment   => $environment,
    jbossdirname  => $jbossdirname,
    xms           => $xms,
    xmx           => $xmx,
    max_perm_size => $max_perm_size,
    stack_size    => $stack_size,
    mgmt_user     => $mgmt_user,
    mgmt_passwd   => $mgmt_passwd,
    java_home     => $jboss::params::java7_home,
  } ~>
  jboss::instance::service { $instance_name:
    environment => $environment,
  } ->
  jboss::instance_8::postconfig { $instance_name:
    ip           => $ip,
    iface        => $iface,
    environment  => $environment,
    jbossdirname => $jbossdirname,
    mgmt_user    => $mgmt_user,
    mgmt_passwd  => $mgmt_passwd,
  }
}