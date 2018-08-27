# Defines the parameters needed for installing JBoss/WildFly instances.
#
# It is intended to be called by jboss::instance_[x] defines.
#
# @author Dario Sestero
class jboss::params () {
  $java7_home = "/opt/jdk/java-7/"
  $java8_home = "/opt/jdk/java-8/"
  $java9_home = "/opt/jdk/java-9/"

  case $facts['os']['family'] {
    'Debian' : {
      $init_template = 'jboss-init.erb'
      $init7_template = 'jboss-init.erb'
    }
    'RedHat' : {
      $init_template = 'jboss-init-redhat.sh.erb'
      $init7_template = 'jboss-init-7-redhat.sh.erb'
    }
    default            : {
      fail("The ${module_name} module is not supported on an ${facts['os']['family']} distribution.")
    }
  }
}