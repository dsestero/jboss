# = Define: jboss::instance_7::config
#
# Configures a JBoss-7 instance,
# i.e. a server profile. It is intended to be called by jboss::instance_7.
define jboss::instance_7::config (
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
  $jmx_user,
  $jmx_passwd,
  $java_home,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss-7-${instance_name}/${jbossdirname}"
  $ip_alias = "${instance_name}-${environment}"
  $auth_string = $mgmt_user ? {
    undef   => '',
    default => "--user=${mgmt_user} --password=${mgmt_passwd}",
  }
  $shutdown_cmd = "jboss-cli.sh --connect --controller=${ip_alias}:9999 ${auth_string} command=:shutdown"

  $hot_deploy_status = $environment ? {
    'prep'  => absent,
    'prod'  => absent,
    default => present,
  }

  File {
    owner => jboss,
    group => jboss,
  }

  jboss::instance::config { $instance_name:
    environment => $environment,
    iface       => $iface,
    ip          => $ip,
  }

  # Link alla prima istanza jboss-7, per avere a disposizione jbosscli su un
  # path prestabilito, ad esempio dallo strumento di
  # monitoraggio
  exec { "/opt/jboss-7-${instance_name}":
    command => "ln -s ${jboss_inst_folder} /opt/jboss-7",
    user    => root,
    group   => root,
    unless  => 'test -e /opt/jboss-7',
  }

  # Script di avvio
  file { "${jboss_inst_folder}/bin/run-${instance_name}.sh":
    ensure  => present,
    content => template("${module_name}/standalone-launcher.sh.erb"),
    mode    => '0755',
  }

  # Init script
  file { "/etc/init.d/jboss-${instance_name}":
    ensure  => present,
    content => template("${module_name}/jboss-init.erb"),
    owner   => root,
    group   => root,
    mode    => '0755',
  }

  # Link a directory log
  file { "${jboss_inst_folder}/standalone/log":
    ensure => link,
    target => "/var/log/jboss/server/${instance_name}",
  }

  # Directory deploy property applicative, recuperate via hiera
  $customConfigurationsModule = hiera('inva::custom_configurations_module',
  undef)

  if $customConfigurationsModule != undef {
    $modulesFolder = "${jboss_inst_folder}/modules/"
    $customConfigurationsDirs = prefix($customConfigurationsModule,
    $modulesFolder)
    $confDir = $customConfigurationsDirs[-1]

    file { $customConfigurationsDirs:
      ensure => directory,
    }

    file { "${confDir}/module.xml":
      ensure => present,
      source => "puppet:///modules/${module_name}/conf/module.xml",
    }
  }

  #  Sicurezza accesso JMX
  unless $jmx_user == undef {
    file { "${jboss_inst_folder}/bin/create_jmx_user.ex":
      ensure  => present,
      content => template("${module_name}/create_jmx_user.exp.erb"),
      mode    => '0700',
    } ->
    exec { "${jboss_inst_folder}/execute_jmx_user":
      command => "${jboss_inst_folder}/bin/create_jmx_user.ex",
      cwd     => "${jboss_inst_folder}/bin",
      user    => jboss,
      group   => jboss,
      unless  => "grep ^${jmx_user} ${jboss_inst_folder}/standalone/configuration/application-users.properties",
    }
  }

  #  Sicurezza console
  unless $mgmt_user == undef {
    file { "${jboss_inst_folder}/bin/create_mgmt_user.ex":
      ensure  => present,
      content => template("${module_name}/create_mgmt_user.exp.erb"),
      mode    => '0700',
    } ->
    exec { "${jboss_inst_folder}/execute_mgmt_user":
      command => "${jboss_inst_folder}/bin/create_mgmt_user.ex",
      cwd     => "${jboss_inst_folder}/bin",
      user    => jboss,
      group   => jboss,
      unless  => "grep ^${mgmt_user} ${jboss_inst_folder}/standalone/configuration/mgmt-users.properties",
    }
  }
}