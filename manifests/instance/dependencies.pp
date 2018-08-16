# @api private
# Install dependencies (extra packages) needed for the module.
#
# At this time it installs the package +expect+.
#
# @example Declaring in manifest:
# include jboss::instance::dependencies
#
# @author Dario Sestero
class jboss::instance::dependencies {
  $enhancers = ['expect']

  $enhancers.each |$enhancer| {
    package { $enhancer:
      ensure => installed,
    }
  }

}
