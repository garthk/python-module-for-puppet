class python {
    package { "python": ensure => installed }

    file { "/usr/bin/easy_install": }

    exec { "easy_install installer":
        creates => "/usr/bin/easy_install",
        before => File["/usr/bin/easy_install"],
        require => File["/var/puppet/python/ez_setup.py"],
        cwd => "/root",
        command => "/bin/env python /var/puppet/python/ez_setup.py",
        user => "root",
        logoutput => on_failure,
    }

    file {
        "/var/puppet":
            ensure => "directory",
            owner => "root",
            group => "root",
            mode => 0755;
        "/var/puppet/python":
            ensure => "directory",
            owner => "root",
            group => "root",
            mode => 0755;
        "/var/puppet/python/modules":
            ensure => "directory",
            owner => "root",
            group => "root",
            mode => 0755;
        "/var/puppet/python/ez_setup.py":
            ensure => "present",
            source => "puppet:///python/ez_setup.py",
            owner => "root",
            group => "root",
            mode => 0500;
    }
}

define pymod($name,$version="") {
    $pymod_record = "/var/puppet/python/modules/$name.files"

    $req_or_url = $version ? {
       "" => "$name",
       default => "\"$name==$version\""
    }

    exec { "easy_install $name":
        cwd => "/root",
        creates => "$pymod_record",
        require => File["/usr/bin/easy_install"],
        command => "/usr/bin/easy_install --record $pymod_record $req_or_url",
        user => "root",
        logoutput => on_failure,
    }
}
