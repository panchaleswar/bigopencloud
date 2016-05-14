class mymodule ( $page_name, $message ) {
  class { 'apache': }
  $doc_root = '/var/www/html/'

  file { "${doc_root}${page_name}.html":
  ensure => present,
  content => "<em>${message}</em>",
  }
  service { 'firewalld':
    ensure => 'stopped',
  }

}