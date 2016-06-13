# = Class: jboss
#
# Installs and set up standard directories for JBoss AS.
#
# == Parameters:
#
# None.
# == Actions:
#
# Declares all other classes in the jboss module needed for installing JBoss.
# Currently, these consists of jboss::install, and jboss::config.
#
# == Requires:
# see Modulefile
#
# == Sample usage:
#  include jboss
class jboss () {

  class { 'jboss::install':
    jboss_instance_list => true,
  }
  class { 'jboss::config':
  }
}
