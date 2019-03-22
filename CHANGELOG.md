##2019-03-22 - Release - 2.3.3
###Summary
Added possibility to specify java version parameter for instance_8.
Added possibility to specify driver parameter for sqlserver to instance_8.

##2018-12-17 - Release - 2.3.2
###Summary
Added possibility to specify driver parameter for postgresql and postgresqlxa to instance_12.
###Bugfixes
Use of recommended postgresql driver (JDBC 4.2) as default for instance_12.

##2018-12-07 - Release - 2.3.1
###Summary
###Bugfixes
Fixed syntax error affecting postgresqlxa driver on instance_8.

##2018-11-26 - Release - 2.3.0
###Summary
Added possibility to specify driver parameter for postgresql and postgresqlxa to instance_7 and instance_8.

##2018-11-22 - Release - 2.2.2
###Summary
###Bugfixes
Fixed creation of JBoss-7.1.1 instances: now the original library jboss-module.jar in the root of the a.s. is
renamed jboss-module.jar.1 and a newer version, working with the latest jdk-7 updates is put in place.

##2018-11-19 - Release - 2.2.1
###Summary
###Bugfixes
Accepted PR from tealecloud to qualify cp paths during creation of JBoss-4 and JBoss-5 profiles.
Fixed creation of JBoss-7.1.1 instances: now takes into consideration the need of
upgrading jboss-module.jar library in the root of the a.s.

##2018-09-26 - Release - 2.2.0
###Summary
Added possibility to produce heap dump on OOM Error for WildFly-8 instances.

##2018-08-27 - Release - 2.1.2
###Summary
Revised all classes involved in creating JBoss-7.1.1 instances.

##2018-08-16 - Release - 2.1.1
###Summary
All documentation written using Puppet Strings.
Added REFERENCE.md file generated from Puppet Strings.

##2018-07-23 - Release - 2.1.0
###Summary
Added possibility to configure WildFly-12 instances.

##2018-01-09 - Release - 2.0.0
###Summary
Full revision of all WildFly-8 related code to comply with Puppet 4/5 new recommended style.
Some Italian strings left in comments translated to English.
WildFly-8 related code no more compatible with Puppet 3.

####Bugfixes
Some bugs in the grep expressions used to catch the running instance pid in the management script (`manage-jboss-instance`) have been fixed.

##2017-03-30 - Release - 1.2.2
###Summary
Added post-configuration of WildFly 8 instances to work around the memory leak bug when using JMX interface (see https://developer.jboss.org/thread/265837)

##2016-11-22 - Release - 1.2.1
###Summary
Fixed: the script manage-jboss-instance now works also on RedHat distributions. The solution has been to move the file listing all jboss/wildfly instances on a node from /home/jboss/bin to /usr/local/bin; in this way it is accessible to the script manage-jboss-instances on RedHat distributions, without the need to change the default permissions on /home/jboss folder.

##2016-11-10 - Release - 1.2.0
###Summary
Added support for RedHat and CentOS distributions.
Removed support for Ubuntu 10.04.
Removed restriction on specific Ubuntu version.

##2015-07-12 - Release - 1.1.1
###Summary
Fixed puppet version requirement in metadata according to parser validation.

##2015-07-12 - Release - 1.1.0
###Summary
Extended the instance management script (`manage-jboss-instance`) to work not only with JBoss-5 instances but also with WildFly-8 standalone instances.
Added capability to install XA driver for Oracle and PostgreSQL databases on WildFly-8 instances.
Extended to find correct java home location also on 32 bit architectures.
Improved documentation regarding exported resources.
Tested with Puppet 4.
Fixed bug on installation path of JBoss-4 instances.
Fixed bug on installation path of JBoss-7 instances.

##2015-06-15 - Release - 1.0.8
###Summary
Fixed a bug with WildFly-8 instances JMX post configuration.

####Bugfixes
Version 1.0.6 introduced a regression in the JMX postconfiguration phase of WildFly-8 instances where the operation is repeated at every Puppet run and causes an error of duplicated resource to arise.

##2015-05-25 - Release - 1.0.7
###Summary
The script myjboss-cli.sh in the bin folder of WildFly-8 instances is created with 0755 permissions (previously was 0700).

##2015-05-21 - Release - 1.0.6
###Summary
On WildFly-8 the JMX monitoring is done via the http 9990 port, using the management user. So the 7777 port binding is not needed anymore as not needed is the JMX user creation.

####Bugfixes
In the postconfig phase of WildFly-8 instances, the attribute use-management-endpoint of the subsystem jmx/remoting-connector=jmx is no more set to false, allowing JMX connection to the application server.

##2015-05-04 - Release - 1.0.5 - 1.0.4
###Summary
Improved documentation, license changed from CC-BY-SA-4.0 to Apache-2.0.

####Bugfixes
Updated changelog; it was forgotten in version 1.0.4

##2015-04-27 - Release - 1.0.3
###Summary
Links in documentation should now work.

##2015-04-27 - Release - 1.0.2
###Summary
Improved documentation.

####Bugfixes
Corrected SQLServer driver installation on WildFly-8 instances.

##2015-04-22 - Release - 1.0.1
###Summary
Code polishing to be more compliant with puppet-lint suggestions.

####Bugfixes
Remove unused `ws_enabled` parameter from the define instance_4, instance_7, instance_8.

####Known bugs
* No known bugs

##2015-04-21 - Release - 1.0.0
###Summary
Initial release as PuppetForge module of a work consolidated during the last two years.

####Features
See the README.markdown

####Bugfixes

####Known bugs
* No known bugs
