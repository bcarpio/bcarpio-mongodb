# /etc/puppet/modules/mongodb/manifests/init.pp

class mongodb {

	require mongodb::params

	group { "mongodb":
		ensure => present,
		gid => "$mongodb::params::uid"
	}

	user { "mongodb":
		ensure => present,
		comment => "10gen MongoDB User",
		password => "!!",
		uid => "$mongodb::params::uid",
		gid => "$mongodb::params::gid",
		shell => "/bin/bash",
		home => "/home/mongodb",
		require => Group["mongodb"]
	}

	file { "/etc/mongodb.conf":
		ensure => present,
		owner => "mongodb",
		group => "mongodb",
		mode  => 440,
		alias => "etc-mongodb-conf",
		content => template("mongodb/etc/mongodb.conf.erb")
	}

	file { "/etc/init/mongodb.conf":
		ensure => "present",
		owner => "root",
		group => "root",
		mode  => 644,
		alias => "etc-init-mongodb-conf",
		content => template("mongodb/etc/init/mongodb.conf.erb"),
	}
	
	file { "/etc/init.d/mongodb":
		ensure => "present",
		owner => "root",
		group => "root",
		mode  => 744,
		alias => "etc-initd-mongodb-conf",
		source => "puppet:///modules/mongodb/etc/init.d/mongodb",
	}
	
	file { "$mongodb::params::dbpath":
		ensure => "directory",
		owner => "mongodb",
		group => "mongodb",
		mode => 0644,
		alias => "mongodb-data-dir",
	}
        file {"$mongodb::params::install_base":
		ensure => "directory",
		owner => "root",
		group => "root",
		alias => "install-base"
	}
        
	file { "${mongodb::params::install_base}/mongodb-linux-x86_64-${mongodb::params::mongodb_version}.tgz":
		mode => 0644,
		owner => root,
		group => root,
		source => "puppet:///modules/mongodb/mongodb-linux-x86_64-${mongodb::params::mongodb_version}.tgz",
		alias => "mongodb-source-tgz",
		before => Exec["untar-mongodb"],
		require => File["install-base"]
	}
	
	exec { "untar mongodb-linux-x86_64-${mongodb::params::mongodb_version}.tgz":
		command => "tar -zxf mongodb-linux-x86_64-${mongodb::params::mongodb_version}.tgz",
		cwd => "${mongodb::params::install_base}",
		creates => "${mongodb::params::install_base}/mongodb-linux-x86_64-${mongodb::params::mongodb_version}",
		alias => "untar-mongodb",
		refreshonly => true,
		subscribe => File["mongodb-source-tgz"],
		before => [ File["mongodb-symlink"], File["mongodb-app-dir"]]
	}
	
	file { "${mongodb::params::install_base}/mongodb-linux-x86_64-${mongodb::params::mongodb_version}":
		ensure => "directory",
		mode => 0644,
		owner => "root",
		group => "root",
		alias => "mongodb-app-dir"
	}
	
	file { "${mongodb::params::install_base}/mongodb":
		force => true,
		ensure => "${mongodb::params::install_base}/mongodb-linux-x86_64-${mongodb::params::mongodb_version}",
		alias => "mongodb-symlink",
		owner => "mongodb",
		group => "mongodb",
		require => File["mongodb-source-tgz"],
	}
	
	file { "/var/log/mongodb/":
		ensure => "directory",
		owner => "mongodb",
		group => "mongodb",
		mode => 0644,
		alias => "mongodb-log-dir",
		before => File["/var/log/mongodb/mongodb.log"]
	}
	
	file { "/var/log/mongodb/mongodb.log":
		ensure => "present",
		owner => "mongodb",
		group => "mongodb",
		mode => 644,
	}	
		
}
