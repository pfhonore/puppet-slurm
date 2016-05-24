# puppet-slurm

Puppet module for SLURM client and server

## Usage

To use this module simply include `slurm` class for the hosts on which you wish to install slurm.  By default the host will be considered a compute node. There are a series of control parameters which will override the default behavior, those are defined below.  In order to keep hiera from getting bloated it is recommended that you use puppet groups to define the cluster you wish to set up, and then simply include the group along with any host specific settings you have.

###Parameters

This is not exhaustive but will cover most of the parameters you can set for this class.

* `slurm::controller`: Boolean that decides if this host you are on will act as the slurm master, namely run the slurmctld process. Default is false.
* `slurm::node`: Boolean that decides if this host will be a slurm client, namely run the slurmd process and accept jobs.  Default is true.
* `slurm::slurmdbd`: Boolean that decides if this host will host the database, namely run slurmdbd. Default is false.
* `slurm::version`: String that dictates what version of slurm this host will get.  Default is present.
* `slurm::release`: String that dictates if further configuration parameters are allowed depending on major version as new features are added in slurm all the time.  Default is 14.03.  Currently up to 15.08 is defined.
* `slurm::slurm_user`: String that dictates the name for the slurm user. By default slurm does not make it's own user but assumes that a service account is going to be used to manage slurm. This sets up a local user to take this role and makes it uniform across the cluster. Default is slurm.
* `slurm::slurm_user_uid`: Integer that dictates the uid for `slurm_user`. slurm requires that the uid is consistent across all hosts in the cluster.  Default is undefined.
* `slurm::slurm_user_group`: String that dictates the name of the `slurm_user` group.  Similar to `slurm_user` but now for that user's group. It needs to be consistent across all hosts in a cluster. Default is slurm.
* `slurm::slurm_group_gid`: Integer that dictates the gid for the local slurm user group.  Similar to the `slurm_user_uid` but now for that user's group.  It needs to be consistent across all hosts in a cluster. Default is undefined.

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
