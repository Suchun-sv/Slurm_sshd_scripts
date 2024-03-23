#!/usr/bin/env python
import os
from posixpath import expanduser

os.system("squeue -u $USER | grep apply_ | awk '{print $1}' > ${HOME}/sshd/running_job")

with open(os.path.expanduser("~")+'/sshd/running_job', 'r') as f:
    running_job = f.readlines()

with open(os.path.expanduser("~")+'/sshd/gpu_ports.conf', 'r') as f:
    configs = f.readlines()

if len(running_job) == 0:
    print("no running hosts, exit..")
elif len(configs) == 0:
    print("no configs, exit...")
else:
    print(f"there are {len(running_job)} jobs running...")

    running_hosts = []
    for config in configs:
        config = config.strip()
        for job in running_job:
            job = job.strip()
            if job in config:
                _, user, host, port = config.split(" ")
                running_hosts.append({"host": host, "user": user, "port": port})

    with open(os.path.expanduser("~")+"/sshd/gpu_ssh.conf", "w") as f:
        for i, host_config in enumerate(running_hosts):
            config_str = f"Host slurm_gpu_{i}" + "\n" + \
                "\t" + f"HostName {host_config['host']}" + "\n" + \
                "\t" + f"User {host_config['user']}" + "\n" + \
                "\t" + f"Port {host_config['port']}" + "\n" + \
                "\t" + "IdentityFile ~/.ssh/id_rsa" + "\n"
            f.write(config_str)
    print("saved to ~/sshd/gpu_ssh.conf, try connect by you own.")

    with open(os.path.expanduser("~")+"/sshd/running_ports.conf", "w") as f:
        for i, host_config in enumerate(running_hosts):
            f.write(f"export user={host_config['user']} && export host={host_config['host']} && export port={host_config['port']}\n")
    print("saved to ~/sshd/running_ports.conf")

                
                