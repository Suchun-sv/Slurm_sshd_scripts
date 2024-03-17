# Slurm_sshd_scripts
sshd scripts for slurm

# Function
This repository is used to apply for the GPU and use the sshd service to connect to the GPU.

You can DIRECTLY use the sshd service to connect to the GPU without any other operations, typically, you can use the sshd service to connect to the GPU in the following situations:
1. Debugging in the vscode
2. Check the GPU status in the terminal
3. Run the code in the terminal

# Install
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


IMPORTANT: This script preserves ONE GPU for 24 hours by default

If you have any questions, please feel free to contact me.

If you find this repository useful, please give me a star, thank you very much! 

