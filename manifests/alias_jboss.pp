# = Class: jboss::alias_jboss
#
# Defines a utility class to add all jboss instances hostname in the hosts file.
#
# == Actions:
#
# Adds all jboss instances ip and alias in the agent's hosts file.
#
# == Requires:
# none
#
# == Sample usage:
#
#  class {'jboss::alias_jboss': }
class jboss::alias_jboss {
  Host <<| tag == 'jboss-instance' |>>
}