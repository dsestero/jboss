# Creates, configures and set up the service for a JBoss-5.1.0.GA instance,
# i.e. a server profile with all the
# configurations needed to use it as an independent service.
#
# @param instance_name Name of the JBoss profile and associated service
#                   corresponding to this instance.
#                   Defaults to the resource title.
#
# @param profile Name of the standard JBoss profile from which this one is
#                   derived.
#                   As of JBoss-5.1.0.GA different profiles are provided with a
#                   different level of services made available; they
#                   are:
#                   +minimal+, +web+, +default+, +all+.
#                   Defaults to +default+.
#
# @param ip Dedicated IP on which this instance will be listening.
#                   Defaults to <tt>127.0.0.1</tt> i.e. localhost.
#
# @param iface Name of the secondary network interface dedicated to this
#                   instance.
#                   Defaults to +undef+, in which case a secondary network
#                   interface to bind the jboss instance is not created.
#
# @param environment Abbreviation identifying the environment: valid values are
#                   +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#                   *Note:* hot code deployment is disabled in the environments
#                   +prep+ and +prod+, enabled on +dev+ and +test+.
#
# @param jmxport JMX port to use to monitor this instance.
#                   Defaults to +no_port+, in which case no JMX monitoring is
#                   activated.
#
# @param ws_enabled enable web services on the profile
#
#                   ``true`` deploy a web profile enabled for jbossws.
#                   ``false`` (Default) do not deploy web services infrastructure.
#
# @param xms JVM OPT for initial heap size.
#                   Defaults to +128m+.
#
# @param xmx JVM OPT for maximum heap size.
#                   Defaults to +512m+.
#
# @param max_perm_size JVM OPT for max permanent generations size.
#                   Defaults to +256m+.
#
# @param stack_size JVM OPT for stack size.
#                   Defaults to +2048k+.
#
# @param extra_jvm_pars extra JVM OPTS.
#                   Defaults to ''.
#
# @param mgmt_user Management user username.
#                   Defaults to +undef+, in which case no security is enforced
#                   on the JBoss console.
#
# @param mgmt_passwd Management user password.
#                   Defaults to +undef+.
#
# @param jmx_user JMX user username.
#                   Defaults to +undef+.
#
# @param jmx_passwd JMX user password.
#                   Defaults to +undef+.
#
# @param smtp_ip IP of the smtp server used by the JBoss mail service.
#                   Defaults to +undef+, in which case the mail service is not
#                   configured.
#
# @param smtp_port Port of the smtp server used by the JBoss mail service.
#                   Defaults to +25+.
#
# @param smtp_domain What will appear as default sender domain of the emails sent
#                   by the JBoss mail service.
#                   Defaults to <tt>nosuchhost.nosuchdomain.com<tt>.
#
# @param backup_conf_target Full pathname of the backup configuration file where the
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
# @example Declaring jboss 5 instance
#  jboss::instance { 'fina':
#    profile     => 'all',
#    environment => 'preprod',
#    ip          => '172.16.12.11',
#    iface       => 'eth0:2',
#    jmxport     => '12345',
#  }
define jboss::instance_5 (
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
  $stack_size         = '2048k',
  $extra_jvm_pars     = '',
  $mgmt_user          = undef,
  $mgmt_passwd        = undef,
  $jmx_user           = undef,
  $jmx_passwd         = undef,
  $smtp_ip            = undef,
  $smtp_port          = '25',
  $smtp_domain        = 'nosuchhost.nosuchdomain.com',
  $backup_conf_target = '/usr/local/bin/backupall.sh.conf',) {
  $smtp_sender = "jboss-${title}-${environment}@${smtp_domain}"

  jboss::instance_5::install { $instance_name:
    profile            => $profile,
    environment        => $environment,
    backup_conf_target => $backup_conf_target,
  } ->
  jboss::instance_5::config { $instance_name:
    ip             => $ip,
    version        => '5.1.0',
    profile        => $profile,
    iface          => $iface,
    environment    => $environment,
    ws_enabled     => $ws_enabled,
    jmxport        => $jmxport,
    xms            => $xms,
    xmx            => $xmx,
    max_perm_size  => $max_perm_size,
    stack_size     => $stack_size,
    extra_jvm_pars => $extra_jvm_pars,
    mgmt_user      => $mgmt_user,
    mgmt_passwd    => $mgmt_passwd,
    jmx_user       => $jmx_user,
    jmx_passwd     => $jmx_passwd,
    smtp_ip        => $smtp_ip,
    smtp_port      => $smtp_port,
    smtp_sender    => $smtp_sender,
  } ~>
  jboss::instance::service { $instance_name:
    environment => $environment,
  }
}