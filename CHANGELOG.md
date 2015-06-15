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
