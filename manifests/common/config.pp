# Private class
class slurm::common::config {

  create_resources('slurm::spank', $slurm::spank_plugins)

  if $slurm::manage_slurm_conf {

    if $slurm::manage_slurm_conf_nfs_mount {

      if !$slurm::controller {
        file { 'SlurmConfNFSMountPoint':
          ensure  => 'directory',
          path    => $slurm::slurm_conf_nfs_location,
        }

        mount { 'SlurmConfNFSMount':
          ensure  => 'mounted',
          name    => $slurm::slurm_conf_nfs_location,
          atboot  => true,
          device  => $slurm::slurm_conf_nfs_device,
          fstype  => 'nfs',
          options => $slurm::slurm_conf_nfs_options,
          require => File['SlurmConfNFSMountPoint'],
        }

        file { 'slurm.conf':
          ensure  => 'link',
          path    => $slurm::slurm_conf_path,
          target  => "${slurm::slurm_conf_nfs_location}/slurm.conf",
          require => Mount['SlurmConfNFSMount'],
        }

        file { 'slurm-partitions.conf':
          ensure  => 'link',
          path    => $slurm::partition_conf_path,
          target  => "${slurm::slurm_conf_nfs_location}/partitions.conf",
          require => Mount['SlurmConfNFSMount'],
        }

        file { 'Link slurm-nodes.conf':
          ensure => 'link',
          path   => $slurm::node_conf_path,
          target => "${slurm::slurm_conf_nfs_location}/nodes.conf",
          require => Mount['SlurmConfNFSMount'],
        }
      }
    } else {
      file { 'NFS slurm.conf':
        ensure  => 'present',
        path    => "${slurm::slurm_conf_nfs_location}/slurm.conf",
        content => $slurm::slurm_conf_content,
        source  => $slurm::slurm_conf_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['SlurmConfNFSLocation'],
      }

      file { 'NFS slurm-partitions.conf':
        ensure  => 'present',
        path    => "${slurm::slurm_conf_nfs_location}/partitions.conf",
        content => $slurm::partitionlist_content,
        source  => $slurm::partitionlist_source,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => File['SlurmConfNFSLocation'],
      }

      if $slurm::node_source {
        file { 'slurm-nodes.conf':
          ensure => 'present',
          path   => "${slurm::slurm_conf_nfs_location}/nodes.conf",
          source => $slurm::node_source,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          require => File['SlurmConfNFSLocation'],
        }
      } else {
        datacat { 'slurm-nodes.conf':
          ensure   => 'present',
          path     => "${slurm::slurm_conf_nfs_location}/nodes.conf",
          template => 'slurm/slurm.conf/nodes.conf.erb',
          owner    => 'root',
          group    => 'root',
          mode     => '0644',
          require => File['SlurmConfNFSLocation'],
        }

        Datacat_fragment <<| tag == $slurm::slurm_nodelist_tag |>>
      }

      file { 'Link slurm.conf':
        ensure  => 'link',
        path    => $slurm::slurm_conf_path,
        target  => "${slurm::slurm_conf_nfs_location}/slurm.conf",
        require => File['NFS slurm.conf'],
      }

      file { 'Link slurm-partitions.conf':
        ensure  => 'link',
        path    => $slurm::partition_conf_path,
        target  => "${slurm::slurm_conf_nfs_location}/partitions.conf",
        require => File['NFS slurm-partitions.conf'],
      }

      file { 'Controller Link slurm-nodes.conf':
        ensure => 'link',
        path   => $slurm::node_conf_path,
        target => "${slurm::slurm_conf_nfs_location}/nodes.conf",
        require => File['slurm-nodes.conf'],
      }

    }

    file { 'plugstack.conf.d':
      ensure  => 'directory',
      path    => $slurm::plugstack_conf_d_path,
      recurse => true,
      purge   => $slurm::purge_plugstack_conf_d,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }

    file { 'plugstack.conf':
      ensure  => 'file',
      path    => $slurm::plugstack_conf_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('slurm/spank/plugstack.conf.erb'),
    }

    file { 'slurm-cgroup.conf':
      ensure  => 'file',
      path    => $slurm::cgroup_conf_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $slurm::cgroup_conf_content,
      source  => $slurm::cgroup_conf_source,
    }

    file { 'cgroup_allowed_devices_file.conf':
      ensure  => 'file',
      path    => $slurm::cgroup_allowed_devices_file_real,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($slurm::cgroup_allowed_devices_template),
    }
  }

  sysctl { 'net.core.somaxconn':
    ensure => present,
    val    => '1024',
  }

}
