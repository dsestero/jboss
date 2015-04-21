# = Define: jboss::instance_7::lib::springframework::install
#
# Utility define to copy to a specified JBoss-7.1.1 instance the libraries of the Spring framework.
#
# == Parameters:
#
# $instance_name::  Name of the JBoss profile and associated service corresponding to this instance.
#                   Defaults to the resource title.
#
# $environment::    Abbreviation identifying the environment: valid values are +dev+, +test+, +prep+, +prod+.
#                   Defaults to +dev+.
#
# == Actions:
#
# Creates the springframework module into the specified instance.
#
# == Requires:
#
# * Class['jboss'] for installing and setting up basic jboss environment.
# * Some defined instance to which the driver has to be copied.
# * The specified instance has to be up and running.
#
# == Sample usage:
#
#  jboss::instance_7::lib::springframework::install {'agri1':
#  }
define jboss::instance_7::lib::springframework::install ($instance_name = $title, $environment = 'dev') {
  $require = Class['jboss']

  $ip_alias = "${instance_name}-${environment}"
  $jbossVersion = "jboss-as-7.1.1.Final"
  $jbossInstFolder = "/opt/jboss-7-${instance_name}/${jbossVersion}"
  $binFolder = "${jbossInstFolder}/bin"
  $modulesFolder = "${jbossInstFolder}/modules"
  $springModulePath = "${modulesFolder}/org/springframework/spring/main"

  exec { "create_springframework_module_folders_${instance_name}":
    command => "mkdir -p ${springModulePath}",
    creates => "${springModulePath}",
    user    => jboss,
    group   => jboss,
  } ->
  file { "${springModulePath}/module.xml":
    source => "puppet:///modules/${module_name}/lib/springframework/module.xml",
    owner  => jboss,
    group  => jboss,
  } ->
  download_uncompress { "${springModulePath}/aopalliance-1.0.jar":
    distribution_name => 'lib/springframework/aopalliance-1.0.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/aopalliance-1.0.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/cglib-nodep-2.2.2.jar":
    distribution_name => 'lib/springframework/cglib-nodep-2.2.2.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/cglib-nodep-2.2.2.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-aop-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-aop-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-aop-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-asm-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-asm-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-asm-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-beans-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-beans-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-beans-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-context-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-context-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-context-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-context-support-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-context-support-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-context-support-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-core-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-core-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-core-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-expression-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-expression-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-expression-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-jdbc-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-jdbc-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-jdbc-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-orm-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-orm-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-orm-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-oxm-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-oxm-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-oxm-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-tx-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-tx-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-tx-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }

  download_uncompress { "${springModulePath}/spring-web-3.1.1.RELEASE.jar":
    distribution_name => 'lib/springframework/spring-web-3.1.1.RELEASE.jar',
    dest_folder       => "${springModulePath}",
    creates           => "${springModulePath}/spring-web-3.1.1.RELEASE.jar",
    user              => jboss,
    group             => jboss,
  }
}
