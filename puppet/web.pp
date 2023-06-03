$packages = [ 'php', 'php-mysqlnd', 'apache2', 'git' ]

package { $packages: 
  ensure => installed,
}

vcsrepo { '/code':
  ensure => present,
  provider => git,
  source => 'https://github.com/shekeriev/do2-app-pack.git',
  }

file_line { 'hosts-web':
    ensure => present,
    path   => '/etc/hosts',
    line   => '192.168.89.182  web.do2.prep  web',
    match  => '^192.168.89.182',
}

file_line { 'hosts-db':
    ensure => present,
    path   => '/etc/hosts',
    line   => '192.168.89.183  db.do2.prep  db',
    match  => '^192.168.89.183',
}

file { '/etc/apache2/sites-available/vhost-app1.conf':
    ensure => present,
    content => 'Listen 8081
<VirtualHost *:8081>
  DocumentRoot "/var/www/app1"
</VirtualHost>',
}

file { '/etc/apache2/sites-available/vhost-app2.conf':
    ensure => present,
    content => 'Listen 8082
<VirtualHost *:8082>
  DocumentRoot "/var/www/app2"
</VirtualHost>',
}

file { '/var/www/app1':
  ensure  => 'directory',
  recurse => true,
  source  => '/code/app1/web',
}

file { '/var/www/app2':
  ensure  => 'directory',
  recurse => true,
  source  => '/code/app2/web',
}

exec { 'enable the 1st vhost':
  command     => '/usr/sbin/a2ensite vhost-app1',
  require     => File['/etc/apache2/sites-available/vhost-app1.conf'],
  notify      => Service['apache2'],
}

exec { 'enable the 2nd vhost':
  command     => '/usr/sbin/a2ensite vhost-app2',
  require     => File['/etc/apache2/sites-available/vhost-app2.conf'],
  notify      => Service['apache2'],
}

service { apache2:
  ensure => running,
  enable => true,
}
