# Installs JBoss-4.0.5.GA.
#
# @example Declaring in manifest:
#  include jboss_4_0_5
#
# @author Dario Sestero
class jboss::jboss_4_0_5 {
  
  jboss::jboss_4 {'4.0.5':
  }
}