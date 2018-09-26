sudo #jboss

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with jboss](#setup)
    * [What jboss affects](#what-jboss-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with jboss](#beginning-with-jboss)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This is the jboss module. It provides classes and defines to install, configure, and create services for jboss instances for the versions 4, 5, 7 of JBoss-GA, WildFly-8 and WildFly-12.

##Module Description

Creates, configures and sets up the service, i.e. a server profile with all the configurations needed to use it as an independent service, for JBoss instances for the community versions:

* JBoss-4.x.y.GA
* JBoss-5.1.0.GA
* JBoss-7.1.1.Final
* WildFly-8.2.0.Final
* WildFly-12.0.0.Final

*Note*: at this time WildFly instances are created as standalone standard profiles.

The module takes care to set up a secondary network interface on which the instance will be listening.

The module incorporates sensible defaults so the only required parameter is the resource title that will be used as instance name.

##Setup

###What jboss affects

The module impact in various ways on the node:

* JBoss distribution and profiles are installed in `/opt` folder;
* logs go in `/var/jboss/server/[instance_name]` folder;
* applications specific files go in `/var/lib/jboss/apps/[appname]` folder;
* a service is created in `/etc/init.d` with the name `jboss-[instance_name]` and configured to start at boot;
* users belonging to jboss group gain specific sudoers permissions in order to start and stop jboss services, to su to jboss user, to use basic network debug tools like netstat and nmap, and to enable/disable/launch a single run of puppet agent;
* if an IP address is specified to make the instance listening then a secondary network interface with the specified IP is configured and activated;
* an alias for the specified IP is created in the /etc/hosts file as [instance_name]-[environment];
* a script to zip and delete old logs in `/var/jboss/server/[instance_name]` folder is installed in `/home/jboss/bin` and scheduled as a cron job of the jboss user;
* a script to ease the management of JBoss services is installed in `/usr/local/bin`;
* JBoss-4 and JBoss-5 instances will include the installation of Java-6 while Jboss-7 and WildFly-8 instances will include the installation of Java-7.
* if WildFly-8 instances are installed on a node then a symbolic link `/opt/jboss-8` is created to one of them in order to have the possibility to access the scripts in the WildFly `bin` directory on a standard path (e.g. to access jboss-cli.sh in postconfig manifests).CHECK

If PuppetDB is installed the module exports two kind of resources:
* the paths to backup the configurations of the specific instances created on a given node in a given environment. (The node fqdn and the environment tag concat::fragment resources).

The module provides a class `jboss::alias_jboss` that use the first above mentioned exported resource to define a utility class to add all jboss instances hostnames in the hosts file of a node.

For JBoss instances 5, 7, 8 and 12 JBoss logs will be configured with a special category 'LoggerPrestazioni' that appends to a DailyRollingFileAppender named `prestazioni.log`. We use such category to log timings of the different servlets, in order to evaluate overall performances of the webapps.

In order to prevent Puppet to alter specific instance configuration files the general rule followed is to create required JBoss-instance specific configurations (like the above affecting logs) only when they are absent and leaving the files untouched if the configurations already exist.

###Setup Requirements

This modules requires the following other modules to be installed:

* dsestero/download_uncompress

    to provide the basic capability to download and unzip the JBoss distributions
    
* dsestero/java

    to install a suitable java development environment
    
* puppetlabs/concat

    to create the lines needed to configure backup 

* puppetlabs/concat

    to collect informations about the instances installed on a node.

* puppetlabs/stdlib

    to use various functions and the `file_line` resource.

To make use of the exported resources mentioned in [reference](#reference) PuppetDB has to be installed.
	
###Beginning with jboss	

To get a jboss instance up and running one has to install a specific version of the JBoss Community distribution and then to declare the specific instance. This is done, for example, by declarations as the following:

```
include jboss::jboss_8
jboss::instance_8 { 'instanceName': }
```

In the above example a WildFly-8 standalone instance is configured to listen on localhost (127.0.0.1) as a development (`dev`) environment without creating management or jmx users.

##Usage

The basic usage is as in the following example:

```
include jboss::jboss_8
jboss::instance_8 { 'instanceName':
    environment => 'prod',
    ip          => '172.16.13.15',
    iface       => 'eth0:8',
    mgmt_user   => $mgmt_user,
    mgmt_passwd => $mgmt_passwd,
}
```

If `ip` is provided but no `iface` then the instance will listen on the specified `ip` but no specific secondary interface will be created.

It is possible to specify additional attributes like the Xms and Xmx (start and maximum heap memory used by the instance) or the smtp configurations for the JBoss mail service:

```
  jboss::instance_5 { 'instanceName':
    profile     => 'web',
    ws_enabled  => true,
    environment => 'prod',
    ip          => '172.16.12.165',
    iface       => 'eth0:1',
    jmxport     => '12345',
    xmx         => '1024m',
    mgmt_user   => 'admin_user',
    mgmt_passwd => 'suitable_password',
    jmx_user    => 'jmx_user_eg_zabbixmon',
    jmx_passwd  => 'suitable_jmx_password',
    smtp_ip     => '172.16.10.10',
    smtp_domain => 'regione.vda.it',
  } ->
  jboss::instance_5::lib::oracle::install { 'agri1':
  } ->
  jboss::instance_5::lib::zk::install { 'agri1':
  }
```

It is possible to concatenate the declarations for specific libraries as in, for example:

```
  jboss::instance_8 { 'transito8':
    environment => 'test',
    mgmt_user   => 'mgmt_user',
    mgmt_passwd => 'mgmt_passwd',
  } ->
  jboss::instance_8::lib::oracle::install { 'transito8':
    environment => 'test',
  } ->
  jboss::instance_8::lib::postgresql::install { 'transito8':
    environment => 'test',
  } ->
  jboss::instance_8::lib::springframework::install { 'transito8':
    environment => 'test',
  }
```

For WildFly-8 instances it is possible to configure the JVM so that in case of an OutOfMemory Error a heap dump be generated in a specified location.
We suggest to use a dedicated partition with enough memory to hold the dump.

###Exported resources

The exported paths to backup for a given node can be collected, for instance to configure a backup, script with a declaration like the following:

```
  Concat::Fragment <<| target == '/usr/local/bin/backupall.sh.conf' and tag == $facts['networking']['fqdn'] |>> {
  }

  concat { '/usr/local/bin/backupall.sh.conf':
    ensure => present,
  }
```

The names of all instances defined on a node, one per line, are exported and the following code, that is actually part of class jboss::install can be used in case one needs such a file:

```
  Concat::Fragment <<| target == '/usr/local/bin/jboss-instance-list.conf' and tag == $facts['networking']['fqdn'] |>> {
  }

  concat { '/usr/local/bin/jboss-instance-list.conf':
    ensure => present,
  }

``` 

Furthermore, the module provides a class `jboss::alias_jboss` that uses the exported hostname alias to define a utility class that can be exploited to add all jboss instances hostnames in the hosts file of a node.


##Limitations

The module targets Debian and RedHat distributions, including Ubuntu and CentOS. Specifically, it is tested on Ubuntu 12.04 and CentOS 6.6 with 64 bit architecture, although probably it will work also on different versions and on 32 bit architecture.

Furthermore JBoss-7, WildFly-8 and WildFly-12 instances are created in standalone mode.

Due to the fact that JBoss-7, WildFly-8 and WildFly-12 instances need a `postconfig` phase implemented by calling the `jboss-cli.sh` script, it is necessary that the instance be up and running at that time. When Puppet just creates the instance in most cases it is not yet ready to accept connections from jboss-cli because the services are still starting. That's no problem because Puppet will complete the configuration (specified in the postconfig phase) at the subsequent run.

##Development

If you need some feature please send me a (pull) request or send me an email at: dsestero 'at' gmail 'dot' com.

