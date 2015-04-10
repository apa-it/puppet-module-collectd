#
define collectd::plugin::network::server (
  $ensure        = 'present',
  $username      = undef,
  $password      = undef,
  $port          = undef,
  $securitylevel = undef,
  $interface     = undef,
  $forward       = undef,
) {
  include collectd::params
  include collectd::plugin::network

  $conf_dir = $collectd::params::plugin_conf_dir

  validate_string($name)

  concat::fragment { "collectd-network-server-${name}":
     order   => '10',
     target  => "${confdir}/network-servers.conf",
     content => template('collectd/plugin/network/server.conf.erb'),
  }
}
