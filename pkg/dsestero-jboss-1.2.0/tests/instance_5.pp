class { 'jboss': }

class { 'java::java_6': }

jboss::instance_5 { 'agri': }

jboss::instance_5 { 'lab':
  profile     => 'web',
  environment => 'test',
}

jboss::instance_5 { 'atti':
  profile     => 'web',
  environment => 'test',
  ws_enabled  => true,
}

jboss::instance_5 { 'fina':
  profile     => 'default',
  environment => 'preprod',
  ip          => '172.16.12.11',
  iface       => 'eth0:2',
  xms         => '256m',
  xmx         => '1024m',
}
