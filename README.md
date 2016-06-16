# puppet-slurm

Puppet module for SLURM client and server

## Usage

To use this module simply include `slurm` class for the hosts on which you wish to install slurm.  By default the host will be considered a compute node. There are a series of control parameters which will override the default behavior, those are defined below.  In order to keep hiera from getting bloated it is recommended that you use puppet groups to define the cluster you wish to set up, and then simply include the group along with any host specific settings you have.

###Parameters

This is not exhaustive but will cover most of the parameters you can set for this class.

####General

* `slurm::controller`: Boolean that decides if this host you are on will act as the slurm master, namely run the slurmctld process. Default is false.
* `slurm::node`: Boolean that decides if this host will be a slurm client, namely run the slurmd process and accept jobs.  Default is true.
* `slurm::version`: String that dictates what version of slurm this host will get.  Default is present.
* `slurm::release`: String that dictates if further configuration parameters are allowed depending on major version as new features are added in slurm all the time.  Default is 14.03.  Currently up to 15.08 is defined.
* `slurm::slurm_user`: String that dictates the name for the slurm user. By default slurm does not make it's own user but assumes that a service account is going to be used to manage slurm. This sets up a local user to take this role and makes it uniform across the cluster. Default is slurm.
* `slurm::slurm_user_uid`: Integer that dictates the uid for `slurm_user`. slurm requires that the uid is consistent across all hosts in the cluster.  Default is undefined.
* `slurm::slurm_user_group`: String that dictates the name of the `slurm_user` group.  Similar to `slurm_user` but now for that user's group. It needs to be consistent across all hosts in a cluster. Default is slurm.
* `slurm::slurm_group_gid`: Integer that dictates the gid for the local slurm user group.  Similar to the `slurm_user_uid` but now for that user's group.  It needs to be consistent across all hosts in a cluster. Default is undefined.
* `slurm::install_lua`: Boolean that decides if we are using the slurm lua bindings.  Default is false.
* `slurm::install_torque_wrapper`: Boolean that decides if we are installing the torque wrappers.  Default is true.
* `slurm::install_blcr`: Boolean that decides if we are installing bindings for the Berkley Lab Checkpoint/Restart (BLCR) library. Default is false.
* `slurm::install_pam`: Boolean that decides if we are installing PAM access binding for slurm.  Default is false.
* `slurm::slurm_sh_template`: String that dictates where the slurm template for launching bash shells.  Default is `slurm/profile.d/slurm.sh.erb`.
* `slurm::slurm_csh_template`: String that dictates where the slurm template for launching c shells.  Default is `slurm/profile.d/slurm.csh.erb`.
* `slurm::pid_dir`: String that dictates where slurm will put its pids.  Default is `/var/run/slurm`.
* `slurm::conf_dir`: String that dictates where slurm will put its confs. Default is `/etc/slurm`.
* `slurm::log_dir`: String that dictates where slurm will put its logs. Default is `/var/log/slurm`.
* `slurm::shared_state_dir`: String that dictates where slurm will put all its dynamic information. Default is `/var/lib/slurm`.
* `slurm::cluster_name`: String that defines the name of the slurm cluster.  Default is `linux`.
* `slurm::control_machine`: String that defines the name of the slurm master. Default is `slurm`.
* `slurm::slurmd_port`: String that sets SlurmdPort in slurm.conf.  This defines the port over which slurmd will listen. Default is `6818`.
* `slurm::slurmctld_port`: String that sets SlurmctldPort in slurm.conf.  This defines the port over which slurmctld will listen.  Default is `6817`.
* `slurm::slurmdbd_port`: String that sets AccountingStoragePort and DefaultStoragePort in slurm.conf and DbdPort in slurmdbd.conf.  This defines the port over which slurmdbd will listen. Default is `6819`.
* `slurm::manage_prolog`: Boolean that tells puppet whether this module will manage the slurm prolog.  Default is true.
* `slurm::prolog`: String that sets the location of the prolog on a slurm client.  Default is undefined.
* `slurm::prolog_source`: String that sets where puppet will get the source for the prolog from.  Default is undefined.
* `slurm::manage_epilog`: Boolean that tells puppet whether this module will manage the slurm epilog.  Default is true.
* `slurm::epilog`: String that sets the location of the epilog on a slurm client.  Default is undefined.
* `slurm::epilog_source`: String that sets where puppet will get the source for the epilog from.  Default is undefined.
* `slurm::manage_task_prolog`: Boolean that tells puppet whether this module will manage the slurm task prolog.  Default is true.
* `slurm::task_prolog`: String that sets the location of the task prolog on a slurm client.  Default is undefined.
* `slurm::task_prolog_source`: String that sets where puppet will get the source for the task prolog from.  Default is undefined.
* `slurm::manage_task_epilog`: Boolean that tells puppet whether this module will manage the slurm task epilog.  Default is true.
* `slurm::task_epilog`: String that sets the location of the task epilog on a slurm client.  Default is undefined.
* `slurm::task_epilog_source`: String that sets where puppet will get the source for the task epilog from.  Default is undefined.
* `slurm::manage_slurmctld_prolog`: Boolean that tells puppet whether this module will manage the slurmctld prolog.  Default is true.
* `slurm::slurmctld_prolog`: String that sets the location of the slurmctld prolog on the slurm master.  Default is undefined.
* `slurm::slurmctld_prolog_source`: String that sets where puppet will get the source for the slurmctld prolog from.  Default is undefined.
* `slurm::manage_job_submit_plugin`: Boolean that tells puppet whether this module will manage the slurm job submit plugin.  Default is true.
* `slurm::job_submit_plugin`: String that sets the location of the job submit plugin on the slurm master.  Default is undefined.
* `slurm::job_submit_plugin_lua_source`: String that sets where puppet will get the source for the job submit plugin from.  Default is undefined.
* `slurm::manage_job_comp`: Boolean that tells puppet whether this module will manage the slurm job completion script.  Default is true.
* `slurm::job_comp`: String that sets the location of the job completion script on a slurmctld.  Default is undefined.
* `slurm::job_comp_source`: String that sets where puppet will get the source for the job completion script from.  Default is undefined.
* `slurm::manage_health_check`: Boolean that tells puppet whether this module will manage the health checking program.  Default is true.
* `slurm::health_check_program`: String that sets the location of the health check program on a slurm client.  Default is undefined.
* `slurm::health_check_program_source`: String that sets where puppet will get the source for the health check program from.  Default is undefined.


####Slurmdbd

* `slurm::slurmdbd`: Boolean that decides if this host will host the database, namely run slurmdbd. Default is false.
* `slurm::slurmdbd_storage_loc`: String that sets StorageLoc in slurmdbd.conf. This is the name of the database that slurmdbd will store the data too.  Default is `slurmdbd`.
* `slurm::slurmdbd_storage_pass`: String that sets StoragePass in slurmdbd.conf.  This is the password for the database that the slurmdbd will use. Default is `slurmdbd`.
* `slurm::slurmdbd_storage_user`: String that sets StorageUser in slurmdbd.conf.  This is the user name of the user that slurm will use to update the database.  Default is `slurmdbd`.
* `slurm::slurmdbd_conf_override`: This is a hash that sets specific variables in the slurmdbd.conf.  Default is set to `$slurm::params::slurmdbd_conf_override`.


## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

The following environment variables can be used to modify the behavior of the beaker tests:

* *BEAKER_destroy* - Values are "yes" or "no" to prevent VMs from being destroyed after tests.  Defaults to **yes**.
* *SLURM\_BEAKER\_yumrepo\_baseurl* - **Required** URL to Yum repository containing SLURM RPMs.
* *SLURM\_BEAKER\_package\_version* - Version of SLURM to install.  Defaults to **14.03.6-1.el6**
* *PUPPET\_BEAKER\_package\_version* - Version of Puppet to install.  Defaults to **3.6.2-1**

Example of running beaker tests using an internal repository, and leaving VMs running after the tests.

    export BEAKER_destroy=no
    export SLURM_BEAKER_yumrepo_baseurl="http://yum.example.com/slurm/el/6/x86_64"
    bundle exec rake beaker

## TODO

* Manage slurm.conf JobComp* config options
* master - require NFS or somehow ensure NFS present before applying mount resource
* Update documentation
