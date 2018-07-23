# = Define: jboss::instance::config
#
# Configures a JBoss/WildFly instance.
# It is intended to be called by jboss::instance.
define jboss::instance::config (
  $ip,
  $iface,
  $environment,
  $instance_name = $title,) {
  tag 'jboss-instance'
  $ip_alias = "${instance_name}-${environment}"

  $file_ownership = {
    'owner' => 'root',
    'group' => 'root',
  }

  # dedicated network interface
  unless $iface == undef {
    if !has_interface_with('ipaddress', $ip) and !has_interface_with($iface) {
      case $facts['os']['family'] {
        'Debian': {
          file { "/etc/network/interface-${instance_name}":
            ensure  => present,
            content => template("${module_name}/interfaces.erb"),
            *       => $file_ownership,
          } ->
          exec { "addIface-${instance_name}":
            command => "cat /etc/network/interface-${instance_name} >> /etc/network/interfaces",
            unless  => "grep '^iface ${iface} inet' /etc/network/interfaces",
          } ~>
          exec { "ifup-${instance_name}":
            command => "ifup ${iface}",
          }
        }
        'RedHat': {
          file { "/etc/sysconfig/network-scripts/ifcfg-${iface}":
            ensure  => present,
            content => template("${module_name}/ifcfg.erb"),
            *       => $file_ownership,
          } ~>
          exec { "ifup-${iface}":
            command => "ifup ${iface}",
          }
        }
        default: {
          fail("The ${module_name} module is not supported on an ${facts['os']['family']} distribution.")
        }
      }
    }
  }

  # logic name for the instance /etc/hosts
  @@host { $ip_alias:
    ensure => present,
    ip     => $ip,
  }

  Host <<| title == $ip_alias and tag == 'jboss-instance' |>>

}