# https://collectd.org/wiki/index.php/Plugin:Network
class collectd::plugin::network (
  $ensure        = present,
  $timetolive    = undef,
  $maxpacketsize = undef,
  $forward       = undef,
  $interval      = undef,
  $reportstats   = undef,
  $listeners     = { },
  $servers       = { },
) {

  include collectd::params
  
  $confdir = $collectd::params::plugin_conf_dir
  
  if $timetolive {
    validate_re($timetolive, '[0-9]+')
  }
  if $maxpacketsize {
    validate_re($maxpacketsize, '[0-9]+')
  }

  collectd::plugin {'network':
    ensure   => $ensure,
    content  => template('collectd/plugin/network.conf.erb'),
    interval => $interval,
  }
  $defaults = {
    'ensure' => $ensure
  }
  
  concat { [
        "${confdir}/network-servers.conf",
        "${confdir}/network-listeners.conf",
        ]:
		mode    => '0640',
		owner   => 'root',
		group   => $collectd::params::root_group,
        require => Package['collectd'],
        notify  => Service['collectd'],
    }

    concat::fragment { 'collectd-network-servers-header':
        order   => '00',
        target  => "${confdir}/network-servers.conf",
        content => "# This file is managed by puppet - changes will be lost\n",
    }

    concat::fragment { 'collectd-network-listeners-header':
        order   => '00',
        target  => "${confdir}/network-listeners.conf",
        content => "# This file is managed by puppet - changes will be lost\n",
    }	
	
  create_resources(collectd::plugin::network::listener, $listeners, $defaults)
  create_resources(collectd::plugin::network::server, $servers, $defaults)
}
