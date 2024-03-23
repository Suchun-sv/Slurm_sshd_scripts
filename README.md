# Slurm_sshd_scripts
sshd scripts for slurm

# Function
This repository is used to apply for the GPU and start a sshd service to connect to the GPU.

You can DIRECTLY use the `ssh` to connect to the GPU without any other operations.

you can use the sshd service to connect to the GPU in the following situations:
1. Debugging in the vscode
2. Check the GPU status in the terminal
3. Run the code in the terminal

# Usage
1. logging into the slurm sontrol node and `sbatch sshd_jobs.sh`
![apply](./figs/apply.png)
2. view the job log and get the ip & port
![job_log](./figs/job_log.png)
3. connecting to the computing node with the standard SSH



# Install
## login to the cluster control node

## clone the repository
```bash
git clone XX XX
cd Slurm_sshd_scripts
```

## Automatic installation
```
source ./install.sh
```

## Manual installation

### generate the ssh key (must in the control code e.g. dell-mgt-01)
```bash
ssh-keygen -t rsa -f ~/.ssh/vcg_cluster_user_sshd
```

### modify the important things
1. in the `sshd/sshd_job.sh` file, you should modify the YOUR_ENVIRONMENT to your own environment. (you can use the following command to do this)
```bash
export ENV="YOUR_OWN_ENVIRONMENT" # change this to your own environment
cp ./sshd/sshd_job.sh ./sshd/sshd_job.sh.bak
sed "s/YOUR_OWN_ENVIRONMENT/$ENV/g" ./sshd/sshd_job.sh.bak > ./sshd/sshd_job.sh
```
2. in the `sshd/sshd_config` file, you should modify the YOUR_USER_NAME to your own user name. (you can use the following command to do this)
```bash
cp ./sshd/sshd_config ./sshd/sshd_config.bak
sed "s/YOUR_USER_NAME/$USER/g" ./sshd/sshd_config.bak > ./sshd/sshd_config
```

### move to your home directory
```bash
# mv sshd/ ~/
ln -s $(pwd)/sshd/ ~/
```

## apply for the GPU
```
sbatch ~/sshd/sshd_job.sh
```

## check the ip_port of the sshd service
```
squeue -u $USER | grep apply_gpu
cat Slurm-XXX.out
```


IMPORTANT: This script preserves ONE GPU for 24 hours by default

If you have any questions, please feel free to contact me.

If you find this repository useful, please give me a star, thank you very much! 

