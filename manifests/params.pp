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
    'Ubuntu' : {
      case $::operatingsystemrelease {
        '12.04' : {
          case $::architecture {
            'amd64' : {
              $java7_home = '/usr/lib/jvm/java-7-openjdk-amd64'
            }
            default : {
              fail("The ${module_name} module is not supported on ${::operatingsystem} release ${::operatingsystemrelease} ${::architecture}"
              )
            }
          }
        }
        default : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} release ${::operatingsystemrelease}"
          )
        }
      }
    }
    default  : {
      fail("The ${module_name} module is not supported on an ${::operatingsystem} distribution."
      )
    }
  }
}