class python {
    package { "python": ensure => installed }

    file { "/usr/bin/easy_install": ensure => present }

    exec { "easy_install installer":
        creates => "/usr/bin/easy_install",
        before => File["/usr/bin/easy_install"],
        require => File["/root/ez_setup.py"],
        cwd => "/root",
        command => "/bin/env python /root/ez_setup.py",
        user => "root",
        logoutput => on_failure,
    }

    file { "/root/ez_setup.py":
        path => "/root/ez_setup.py",
        source => "puppet:///python/ez_setup.py",
        owner => "root",
        group => "root",
        mode => 0500,
    }

    file { "/var/puppet_pymod":
        ensure => "directory",
        owner => "root",
        group => "root",
        mode => 0755,
    }
}

define pymod($name) {
    $pymod_record = "/var/puppet_pymod/$name.files"
    exec { "easy_install $name":
        cwd => "/root",
        creates => "$pymod_record",
        require => File["/usr/bin/easy_install"],
        command => "/usr/bin/easy_install --record $pymod_record $name",
        user => "root",
        logoutput => on_failure,
    }
}
