# = Define: jboss::instance_5::config
#
# Configures a JBoss-5.1.0.GA instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance_5::config (
  $version,
  $profile,
  $ip,
  $iface,
  $environment,
  $jmxport,
  $xms,
  $xmx,
  $max_perm_size,
  $stack_size,
  $extra_jvm_pars,
  $ws_enabled,
  $mgmt_user,
  $mgmt_passwd,
  $jmx_user,
  $jmx_passwd,
  $smtp_ip,
  $smtp_port,
  $smtp_sender,
  $instance_name = $title,) {
  $jboss_inst_folder = "/opt/jboss-${version}.GA"
  $shutdown_cmd = 'shutdown.sh -s ${IF} -S'

  $ip_alias = "${instance_name}-${environment}"
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

  # Script di avvio
  file { "/opt/jboss/bin/run-${instance_name}.sh":
    ensure  => present,
    content => template("${module_name}/run-profile.sh.erb"),
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
  file { "/opt/jboss/server/${instance_name}/log":
    ensure => link,
    target => "/var/log/jboss/server/${instance_name}",
  }

  # Patch su file conf/bootstrap/profile.xml
  file { "/opt/jboss/server/${instance_name}/conf/bootstrap/profile.xml":
    ensure => present,
    source => "puppet:///modules/${module_name}/conf/bootstrap/profile.xml",
  }

  # Configurazione log
  # Attention please: the content of this file is managed by puppet only when it
  # does not yet exists!
  file { "/opt/jboss/server/${instance_name}/conf/jboss-log4j.xml":
    ensure  => present,
    replace => 'no',
    source  => "puppet:///modules/${module_name}/conf/jboss-log4j.xml",
  }

  unless $jmxport == 'no_port' {
    # Sicurezza accesso JMX
    file { "/opt/jboss/server/${instance_name}/conf/jmxremote.access":
      ensure  => present,
      content => template("${module_name}/conf/jmxremote.access.erb"),
      mode    => '0400',
    }

    file { "/opt/jboss/server/${instance_name}/conf/jmxremote.password":
      ensure  => present,
      content => template("${module_name}/conf/jmxremote.password.erb"),
      mode    => '0400',
    }
  }

  unless $mgmt_user == undef {
    # Sicurezza console
    file { "/opt/jboss/server/${instance_name}/conf/props/jmx-console-roles.properties"
    :
      ensure  => present,
      content => template("${module_name}/conf/props/jmx-console-roles.properties.erb"
      ),
      mode    => '0644',
    }

    file { "/opt/jboss/server/${instance_name}/conf/props/jmx-console-users.properties"
    :
      ensure  => present,
      content => template("${module_name}/conf/props/jmx-console-users.properties.erb"
      ),
      mode    => '0600',
    }

    file { "/opt/jboss/server/${instance_name}/deploy/jmx-console.war/WEB-INF/jboss-web.xml"
    :
      ensure => present,
      source => "puppet:///modules/${module_name}/deploy/jmx-console.war/WEB-INF/jboss-web.xml",
    }

    file { "/opt/jboss/server/${instance_name}/deploy/jmx-console.war/WEB-INF/web.xml"
    :
      ensure => present,
      source => "puppet:///modules/${module_name}/deploy/jmx-console.war/WEB-INF/web.xml",
    }
  }

  # Connettori
  file { "/opt/jboss/server/${instance_name}/deploy/jbossweb.sar/server.xml":
    ensure => present,
    source => "puppet:///modules/${module_name}/deploy/jbossweb.sar/server.xml",
  }

  unless $smtp_ip == undef {
    # Servizio email
    file { "/opt/jboss/server/${instance_name}/deploy/mail-service.xml":
      ensure  => present,
      content => template("${module_name}/deploy/mail-service.xml.erb"),
    }
  }

  # Hot deployment
  file { "/opt/jboss/server/${instance_name}/deploy/hdscanner-jboss-beans.xml":
    ensure => $hot_deploy_status,
    source => "puppet:///modules/${module_name}/deploy/hdscanner-jboss-beans.xml",
  }

  if $profile in ['minimal', 'web'] {
    # Configurazioni necessarie per far aprire porta 1099 necessaria per
    # l'esecuzione dello shutdown sui profili minimal e web
    exec { "copy_jmx_invoker_service_${instance_name}":
      command => "cp -a /opt/jboss/server/default/deploy/jmx-invoker-service.xml /opt/jboss/server/${instance_name}/deploy",
      creates => "/opt/jboss/server/${instance_name}/deploy/jmx-invoker-service.xml",
      require => Class[jboss::config],
    }

    exec { "copy_legacy_invokers_service_${instance_name}":
      command => "cp -a /opt/jboss/server/default/deploy/legacy-invokers-service.xml /opt/jboss/server/${instance_name}/deploy",
      creates => "/opt/jboss/server/${instance_name}/deploy/legacy-invokers-service.xml",
      require => Class[jboss::config],
    }

    file { "/opt/jboss/server/${instance_name}/conf/jboss-service.xml":
      ensure => present,
      source => "puppet:///modules/${module_name}/conf/jboss-service.xml",
    }

    # Configurazione necessaria per far funzionare correttamente esposizione JMX
    # sui profili minimal e web
    exec { "copy_jmx_remoting_service_${instance_name}":
      command => "cp -a /opt/jboss/server/default/deploy/jmx-remoting.sar /opt/jboss/server/${instance_name}/deploy",
      creates => "/opt/jboss/server/${instance_name}/deploy/jmx-remoting.sar",
      require => Class[jboss::config],
    }

  }

  # Configurazioni aggiuntive per deploy servizi web con jbossws
  if $ws_enabled and $profile in ['web'] {
    download_uncompress { "jboss-5-ws-deploy-${instance_name}":
      distribution_name => 'jboss-5-ws-deploy.zip',
      dest_folder       => "/opt/jboss/server/${instance_name}/deploy",
      creates           => "/opt/jboss/server/${instance_name}/deploy/jbossws.sar",
      uncompress        => 'zip',
      user              => jboss,
      group             => jboss,
    }

    download_uncompress { "jboss-5-ws-deployers-${instance_name}":
      distribution_name => 'jboss-5-ws-deployers.zip',
      dest_folder       => "/opt/jboss/server/${instance_name}/deployers",
      creates           => "/opt/jboss/server/${instance_name}/deployers/jbossws.deployer",
      uncompress        => 'zip',
      user              => jboss,
      group             => jboss,
    }
  }
}