class jenkins {
  package { 'wget':
          ensure => latest,
   }
  exec { 'download_jenkins_package_repo':
       command => 'wget -O /etc/yum.repos.d/jenkins.repo http://nectar-downloads.cloudbees.com/nectar/rpm/jenkins.repo',
       path    => '/usr/bin',
  }


  exec { 'download_jenkins_package_key':
       command => '/usr/bin/wget -q -O /tmp/jenkins-ci.org.key  http://nectar-downloads.cloudbees.com/nectar/rpm/jenkins-ci.org.key',
       path    => '/usr/bin',
  }

  exec { 'install_jenkins_package_keys':
    command => '/usr/bin/rpm --import /tmp/jenkins-ci.org.key',
    path   => '/usr/bin',
  }

  package { 'jenkins':
      ensure => latest,
    require  => [ Exec['download_jenkins_package_repo'],
                  Exec['download_jenkins_package_key'],
                  Exec['install_jenkins_package_keys'], ],
  }

  service { 'jenkins':
    ensure => running,
  }

  service { 'firewalld':
    ensure => stopped,
  }

}
