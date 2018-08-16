# Installs and set up standard directories and permissions for JBoss/WildFly AS.
#
# @example Declaring in manifest:
#  include jboss
#
# @author Dario Sestero
class jboss () {

  class { 'jboss::install':
    jboss_instance_list => true,
  }
  class { 'jboss::config':
  }
}
