node default {
  class { '::profiles::base::system':
    icinga_repo => lookup('icinga::repo::type')
  }
  ->
  class { '::profiles::base::mysql': }
  ->
  class { '::profiles::base::apache': }
  ->
  class { '::profiles::base::java': }
  ->
  class { '::profiles::icinga::icinga2':
    node_name => lookup('icinga::icinga2::node_name'),
    features => {
      "gelf" => {
        "listen_ip"   => lookup('graylog::gelf::listen_ip'),
        "listen_port" => lookup('graylog::gelf::listen_port')
      }
    }
  }
  ->
  class { '::profiles::icinga::icingaweb2':
    node_name => lookup('icinga::icinga2::node_name'),
    modules => {
#      "graylog" => {
#        "listen_ip"   => lookup('graylog::web::listen_ip'),
#        "listen_port" => lookup('graylog::web::listen_port')
#      },
      "director" => {
        "git_revision" => lookup('icinga::director::version')
      },
      "businessprocess" => {},
      "cube" => {},
      "map" => {}
    }
  }
  ->
  class { '::profiles::graylog::elasticsearch':
    repo_version => lookup('graylog::elasticsearch::repo_version'),
    elasticsearch_revision => lookup('graylog::elasticsearch::version')
  }
  ->
  class { '::profiles::graylog::mongodb': }
  ->
  class { '::profiles::graylog::server':
    repo_version => lookup('graylog::repo::version'),
    listen_ip => lookup('graylog::web::listen_ip'),
    listen_port => lookup('graylog::web::listen_port')
  }
  ->
  class { '::profiles::graylog::plugin': }
}
