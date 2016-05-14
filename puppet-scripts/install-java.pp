#install java8

class bocjava8 {
  file { "/tmp/bocjava8.rpm": source => 'puppet:///modules/bocjava8/jdk-8u60-linux-x64.rpm', }
  package {'bocjava8':
    provider => 'rpm',
    source => "/tmp/bocjava8.rpm",
    require => File["/tmp/bocjava8.rpm"],
  }
}