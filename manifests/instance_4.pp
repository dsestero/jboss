# Creates, configures and set up the service for a JBoss-4.0.5.GA instance,
# i.e. a server profile with all the
# configurations needed to use it as an independent service.
#
# @param instance_name name of the JBoss profile and associated service
#                   corresponding to this instance.
#
# @param version JBoss version. It has to be a three number string denoting a
#                   specific version in the JBoss-4 family.
#
# @param profile name of the standard JBoss profile from which this one is
#                   derived.
#                   As of JBoss-4.0.5.GA different profiles are provided with a
#                   different level of services made available; they
#                   are:
#                   +minimal+, +web+, +default+, +all+.
#
# @param ip dedicated IP on which this instance will be listening.
#
# @param iface name of the secondary network interface dedicated to this
#                   instance.
#                   When the value is +undef+, a secondary network
#                   interface to bind the jboss instance is not created.
#
# @param environment abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   *Note:* hot code deployment is disabled in the environments
#                   +prep+ and +prod+, enabled on +dev+ and +test+.
#
# @param jmxport JMX port to use to monitor this instance.
#                   When the value is +no_port+, no JMX monitoring is activated.
#
# @param xms JVM OPT for initial heap size.
#
# @param xmx JVM OPT for maximum heap size.
#
# @param max_perm_size JVM OPT for max permanent generations size.
#
# @param stack_size JVM OPT for stack size.
#
# @param mgmt_user management user username.
#                   When the value is +undef+, no security is enforced on the JBoss console.
#
# @param mgmt_passwd management user password.
#
# @param jmx_user JMX user username.
#
# @param jmx_passwd JMX user password.
#
# @param backup_conf_target full pathname of the backup configuration file where the
#                       instance paths to backup are added.
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
# @example Declaring jboss 4 instance
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