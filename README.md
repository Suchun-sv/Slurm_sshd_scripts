# Slurm_sshd_scripts
sshd scripts for slurm


## clone the repository
```bash
git clone XX XX
cd Slurm_sshd_scripts
```

## modify the important things
in the `sshd/sshd_job.sh` file, you should modify the YOUR_ENVIRONMENT to your own environment.
In the `sshd_config` file, you should modify the last line and add your own name.

## move to your home directory
```bash
mv sshd/ ~/
```

## apply for the GPU
```
sbatch ~/sshd/sshd_job.sh
```

## check the ip_port of the sshd service
```
squeue -u $USER
cat Slurm-XXX.out
```
