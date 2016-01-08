# Class: openvpn
#
# Install OpenVPN and configure the service to start
#
class openvpn(
  $openvpn_dir    = $openvpn::params::openvpn_dir,
  $package_name   = $openvpn::params::package_name,
  $manage_service = $openvpn::params::manage_service,
  $autostart_all  = $openvpn::params::autostart_all
) inherits openvpn::params {

  package { $package_name:
    ensure => installed,
  }->

  file { $openvpn_dir:
    ensure => directory,
  }

  @file { "${openvpn_dir}/ccd":
    ensure => directory,
  }

  if $manage_service {
    service { 'openvpn':
      ensure  => running,
      enable  => true,
      require => File[$openvpn_dir],
    }

    if $::osfamily == 'Debian' {
      concat { '/etc/default/openvpn':
        owner => 'root',
        group => 'root',
        mode  => '0644',
        warn  => true,
      }
      
      concat::fragment { 'openvpn.default.header':
        content => template('openvpn/etc-default-openvpn.erb'),
        target  => '/etc/default/openvpn',
        order   => '01',
      }
    }
  }
}
