# = Class: jboss::params
#
# Defines the parameters needed for installing JBoss/WildFly instances.
#
# == Parameters:
#
# no parameters.
#
class jboss::params () {
  case $::operatingsystem {
    'Ubuntu'           : {
      $init_template = 'jboss-init.erb'
      case $::operatingsystemrelease {
        '10.04' : {
          $java7_home = '/usr/lib/jvm/java-7-openjdk'
        }
        '12.04' : {
          $java7_home = "/usr/lib/jvm/java-7-openjdk-${::architecture}"
        }
        default : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} release ${::operatingsystemrelease}")
        }
      }
    }
    'CentOS', 'RedHat' : {
      $init_template = 'wildfly-init-redhat.sh.erb'
      $java7_home = "/usr/lib/jvm/jre-1.7.0-openjdk.${::architecture}"
    }
    default            : {
      fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution.")
    }
  }
}