# /etc/puppet/modules/mongodb/params.pp

class mongodb::params {

	$dbpath = $::hostname ? {
		/arch-mongod.*/		=> "/data/db.1/",
		default				=> "/var/lib/mongodb",
	}	

	$uid = $::hostname ? {
		default 		=> "800",
	}

	$gid = $::hostname ? {
		default			=> "800",
	}

	$journal = $::hostname ? {
		/arch-mongod.*/		=> "true",
		default				=> "true",
	}

	$replSet = $::hostname ? {
		/arch-mongod-s1.*/		=> "set01",
		/arch-mongod-s2.*/		=> "set02",
		default					=> "mongo",
	}

	$install_base = $::hostname ? {
		default				=> "/opt/mongodb",
	}
	$mongodb_version = $::hostname ? {
		/arch-mongod-s1.*/	=> "2.0.4",
		/arch-mongod-s2.*/	=> "1.8.5",
		default				=> "2.0.4",
	}
}
