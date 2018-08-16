# @api private
# Configures a JBoss-8 instance,
# i.e. a server profile. It is intended to be called by jboss::instance_8.
#
# @author Dario Sestero
define jboss::instance_8::config (
  $ip,
  $iface,
  $environment,
  $jbossdirname,
  $xms,
  $xmx,
  $max_perm_size,
  $stack_size,
  $mgmt_user,
  $mgmt_passwd,
  $java_home,
  $instance_name = $title,) {

  $jboss_inst_folder = "/opt/jboss-8-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"
  $auth_string = $mgmt_user ? {
    undef   => '',
    default => "--user=${mgmt_user} --password=${mgmt_passwd}",
  }
  $shutdown_cmd = "myjboss-cli.sh --connect --controller=${ip_alias}:9990 ${auth_string} command=:shutdown"

  $hot_deploy_status = $environment ? {
    'prep'  => absent,
    'prod'  => absent,
    default => present,
  }
  $file_ownership = {
  'owner' => 'jboss',
  'group' => 'jboss',
  }

  jboss::instance::config { $instance_name:
    environment => $environment,
    iface       => $iface,
    ip          => $ip,
  }

  # Link to first jboss-8 instance, in order to have available jbosscli on a predefined path
  exec { "/opt/jboss-8-${instance_name}":
    command => "ln -s ${jboss_inst_folder} /opt/jboss-8",
    user    => root,
    group   => root,
    unless  => 'test -e /opt/jboss-8',
  }

  file {
    default:
      ensure => present,
      *      => $file_ownership,
      ;
    # Startup script
    "${jboss_inst_folder}/bin/run-${instance_name}.sh":
      content => template("${module_name}/standalone-launcher.sh.erb"),
      mode    => '0755',
      ;
    # Init script
    "/etc/init.d/jboss-${instance_name}":
      content => template("${module_name}/${jboss::params::init_template}"),
      owner   => root,
      group   => root,
      mode    => '0755',
      ;
    # Link log directory
    "${jboss_inst_folder}/standalone/log":
      ensure => link,
      target => "/var/log/jboss/server/${instance_name}",
      ;
  }

  # Directory for deployment of applicative properties, retrieved via lookup
  $customConfigurationsModule = lookup('inva::custom_configurations_module', Optional[Tuple[String, 1, 5]], 'first', undef)

  if $customConfigurationsModule != undef {
    $modulesFolder = "${jboss_inst_folder}/modules/system/layers/base/"
    $customConfigurationsDirs = prefix($customConfigurationsModule,
    $modulesFolder)
    $confDir = $customConfigurationsDirs[-1]

    file {
      default:
        * => $file_ownership,
        ;
      $customConfigurationsDirs:
        ensure => directory,
        ;
      "${confDir}/module.xml":
        ensure => file,
        source => "puppet:///modules/${module_name}/conf/module.xml",
        ;
    }
  }

  # Custom jboss-cli.sh that set JAVA_HOME consistently with JBoss-8
  file { "${jboss_inst_folder}/bin/myjboss-cli.sh":
    ensure  => file,
    content => template("${module_name}/myjboss-cli.sh.erb"),
    mode    => '0755',
    *       => $file_ownership,
  }

  # Console security
  unless $mgmt_user == undef {
    file { "${jboss_inst_folder}/bin/create_mgmt_user.ex":
      ensure  => file,
      content => template("${module_name}/create_mgmt_user8.exp.erb"),
      mode    => '0700',
      *       => $file_ownership,
    } ->
    exec { "${jboss_inst_folder}/execute_mgmt_user":
      command => "/bin/sh -c 'JAVA_HOME=${java_home} ${jboss_inst_folder}/bin/create_mgmt_user.ex'",
      cwd     => "${jboss_inst_folder}/bin",
      user    => jboss,
      group   => jboss,
      unless  => "grep ^${mgmt_user} ${jboss_inst_folder}/standalone/configuration/mgmt-users.properties",
    }
  }

}