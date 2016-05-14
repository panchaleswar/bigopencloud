class tmobilejava8 {
  file { "/tmp/tmobilejava8": source => 'puppet:///modules/tmobilejava8/jdk-8u65-linux-x64.rpm
', }
  package {'bocjava8':
    provider => 'rpm',
    source => "/tmp/tmobilejava8.rpm",
    require => File["/tmp/tmobilejava8.rpm"],
  }
}