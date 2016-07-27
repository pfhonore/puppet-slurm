# Private class
class slurm::controller::service {

  if $::osfamily == 'RedHat' and $::operatingsystemmajrelease == '7' {
    service { 'slurmctld':
      ensure     => $slurm::slurm_service_ensure,
      enable     => $slurm::slurm_service_enable,
      hasstatus  => false,
      hasrestart => true,
      pattern    => "slurmctld -f ${slurm::slurm_conf_path}",
    }
  } else {
    service { 'slurmctld':
      ensure     => $slurm::slurm_service_ensure,
      enable     => $slurm::slurm_service_enable,
      name       => 'slurm',
      hasstatus  => false,
      hasrestart => true,
      pattern    => "slurmctld -f ${slurm::slurm_conf_path}",
    }
  }

}
