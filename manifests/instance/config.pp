# = Define: jboss::instance::config
#
# Configures a JBoss-5.1.0.GA instance,
# i.e. a server profile. It is intended to be called by jboss::instance.
define jboss::instance::config (
  $ip,
  $iface,
  $environment,
  $instance_name = $title,) {
  tag 'jboss-instance'
  $ip_alias = "${instance_name}-${environment}"

  File {
    owner => jboss,
    group => jboss,
  }

  # Interfaccia di rete dedicata
  unless $iface == undef {
    if !has_interface_with('ipaddress', $ip) and !has_interface_with(
    $iface) {
      # Interfaccia di rete dedicata
      file { "/etc/network/interface-${instance_name}":
        ensure  => present,
        content => template("${module_name}/interfaces.erb"),
        owner   => root,
        group   => root,
      } ->
      exec { "addIface-${instance_name}":
        command => "cat /etc/network/interface-${instance_name} >> /etc/network/interfaces",
        unless  => "grep '^iface ${iface} inet' /etc/network/interfaces",
      } ~>
      exec { "ifup-${instance_name}":
        command => "ifup ${iface}",
      }
    }
  }

  # Nome logico istanza in /etc/hosts
  @@host { $ip_alias:
    ensure => present,
    ip     => $ip,
  }

  Host <<| title == $ip_alias and tag == 'jboss-instance' |>>

}