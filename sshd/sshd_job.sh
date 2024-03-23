#!/bin/bash
 
#SBATCH --job-name=apply_gpu

#SBATCH --gres gpu:1
 
#PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')

# echo following line
echo "This file is a helper script for the sshd service. It is used to start the sshd service in a Slurm job. "
echo "The script is executed by the Slurm job scheduler and is not intended to be run manually. "
echo "The script starts the sshd service and sets the port number to a random value between 8000 and 8100. "
echo "The script also prints the port number to the console so that the user can connect to the sshd service."

echo "Copyright (C) 2024 Beining Yang"

echo "Please do not occupy the GPU for a long time, and release the GPU as soon as possible after use!!!"
echo "Please do not occupy the GPU for a long time, and release the GPU as soon as possible after use!!!"
echo "Please do not occupy the GPU for a long time, and release the GPU as soon as possible after use!!!"

YOUR_ENVIRONMENT=YOUR_OWN_ENVIRONMENT # your conda environment name which includes torch
YOUR_PYTHON=python

START_PORT=8000
END_PORT=8100

find_free_port() {
    for port in $(seq $START_PORT $END_PORT); do
        if ! ss -tuln | grep -q ":$port "; then
            echo $port
            break
        fi
    done
}

PORT=$(find_free_port)
echo "Get Port:" $PORT

host=$(ip a | grep 'inet 192.168' | awk '{print $2}' | cut -d'/' -f1 | grep -v '^$')

echo "********************************************************************" 
echo "Starting sshd in Slurm as user"
echo "Environment information:" 
echo "Date:" $(date)
echo "Allocated node:" $(hostname)
echo "Node IP:" $(ip a | grep 192.168)
echo "Path:" $(pwd)
echo "Listening on:" $PORT
echo "********************************************************************" 

# source /home/LAB/anaconda3/etc/profile.d/conda.sh
# export PYTHONNOUSERSITE=1
# source ~/.bashrc
# conda activate $YOUR_ENVIRONMENT
cd ${HOME}/sshd/


echo "Starting sshd for you...."


echo "********************************************************************"
echo "Copy the following command to connect to the sshd service:"
echo "\n\n"
echo "ssh $USER@$host -p $PORT"
echo "********************************************************************"

echo "Host slurm_gpu
    HostName $host
    User $USER
    Port $PORT
    IdentityFile ~/.ssh/id_rsa" >> ~/sshd/gpu_ssh.conf

/usr/sbin/sshd -D -p ${PORT} -f ${HOME}/sshd/sshd_config -h ${HOME}/.ssh/vcg_cluster_user_sshd &

if [[ -n "$SLURM_JOBID" ]]; then
    echo "This script is running under sbatch."
    $YOUR_PYTHON vgg.py --mem_size 5000 
    echo "This script preserves ONE GPU for 24 hours by default"
else
    echo "You are running in your bash."
fi
