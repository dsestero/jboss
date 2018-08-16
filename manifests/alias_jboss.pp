# Adds all jboss instances ip and alias in the hosts file.
#
# @example Declaring in manifest:
#  class {'jboss::alias_jboss': }
#
# @author Dario Sestero
class jboss::alias_jboss {
  Host <<| tag == 'jboss-instance' |>>
}