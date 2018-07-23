# Class: jboss::instance::dependencies
#
# Install dependencies needed for the module.
#
# == Actions:
#
# Install extra packages needed. At this time it installs the package +expect+.
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

  $enhancers.each |$enhancer| {
    package { $enhancer:
      ensure => installed,
    }
  }

}
