# /etc/puppet/modules/mongodb/params.pp

class mongodb::params {

	$dbpath = $::hostname ? {
		default				=> "/var/lib/mongodb",
	}	

	$uid = $::hostname ? {
		default 		=> "800",
	}

	$gid = $::hostname ? {
		default			=> "800",
	}

	$journal = $::hostname ? {
		default				=> "true",
	}

	$replSet = $::hostname ? {
		default					=> "mongo",
	}

	$install_base = $::hostname ? {
		default				=> "/opt/mongodb",
	}
	$mongodb_version = $::hostname ? {
		default				=> "2.0.4",
	}
}
