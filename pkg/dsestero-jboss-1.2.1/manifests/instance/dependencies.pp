# Class: jboss::instance::dependencies
#
# Install dependencies needed for the module.
#
# == Actions:
#
# Install the package +expect+.
#
# == Requires:
# none
#
# == Sample usage:
#
# include jboss::instance::dependencies
#
class jboss::instance::dependencies {
  $enhancers = ['expect']

  package { $enhancers:
    ensure => installed,
  }
}
