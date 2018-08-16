# Installs JBoss-4.2.3.GA.
#
# @example Declaring in manifest:
#  include jboss_4_2_3
#
# @author Dario Sestero
class jboss::jboss_4_2_3 {
  
  jboss::jboss_4 {'4.2.3':
    jdksuffix => '-jdk6',
  }
}