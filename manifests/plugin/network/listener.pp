#
define collectd::plugin::network::listener (
  $ensure        = 'present',
  $authfile      = undef,
  $port          = undef,
  $securitylevel = undef,
  $interface     = undef,
) {
  include collectd::params
  include collectd::plugin::network

  $conf_dir = $collectd::params::plugin_conf_dir

  validate_string($name)
  
  concat::fragment { "collectd-network-listener-${name}":
     order   => '10',
     target  => "${confdir}/network-listeners.conf",
     content => template('collectd/plugin/network/listener.conf.erb'),
  }

}
