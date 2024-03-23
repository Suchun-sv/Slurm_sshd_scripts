#!/bin/bash
# Function to ask the user for the environment name and confirm it
confirm_environment() {
    local env_name

    # Ask the user for the environment name without a new line
    echo -n "Please enter the name of your environment (include torch): "
    read env_name

    # Ask the user to confirm the environment name
    echo -n "Please confirm the environment name 【$env_name】[y/n]: "
    read confirm

    # Check the user's confirmation
    if [[ $confirm == [yY]* ]]; then
        echo # Print a new line
        echo "The environment name 【$env_name】 is confirmed."
        export ENV=$env_name
    else
        echo # Print a new line
        echo "Environment name confirmation failed."
        confirm_environment # Ask again
    fi
}

# Call the function to confirm the environment name
confirm_environment



# Check if the ENV variable is set and print the result
if [[ -v ENV ]]; then
    echo "The environment name you entered is: $ENV"
    YOUR_PYTHON=$(export PYTHONNOUSERSITE=1 && conda activate $ENV && which python)
    echo "The python path is changed to: $YOUR_PYTHON"
else
    echo "Environment name was not confirmed."
fi

cp ./sshd/sshd_job.sh ./sshd/sshd_job.sh.bak
sed "s/YOUR_OWN_ENVIRONMENT/$ENV/g" ./sshd/sshd_job.sh.bak > ./sshd/sshd_job.sh

cp ./sshd/sshd_job.sh ./sshd/sshd_job.sh.bak
sed "s/YOUR_PYTHON=python/YOUR_PYTHON=$YOUR_PYTHON/g" ./sshd/sshd_job.sh.bak > ./sshd/sshd_job.sh

cp ./sshd/sshd_config ./sshd/sshd_config.bak
sed "s/YOUR_USER_NAME/$USER/g" ./sshd/sshd_config.bak > ./sshd/sshd_config

# check if ./ssh/vcg_cluster_user_sshd exists
if [ ! -f ~/.ssh/vcg_cluster_user_sshd ]; then
    echo "Generating ssh key for vcg_cluster_user_sshd"
    ssh-keygen -t rsa -f ~/.ssh/vcg_cluster_user_sshd
fi

if [ ! -d ~/sshd ]; then
    ln -s $(pwd)/sshd ~/sshd
else 
    echo -n "The sshd directory already exists. Do you want to reset the settings? [y/n]"
    read confirm
    if [[ $confirm == [yY]* ]]; then
        rm -r ~/sshd
        ln -s $(pwd)/sshd ~/sshd
    fi
fi

alias_to_add="alias apply_gpu='sbatch ~/sshd/sshd_job.sh'"

bashrc_file=~/.bashrc

if ! grep -qF "$alias_to_add" "$bashrc_file"; then
    echo "$alias_to_add" >> "$bashrc_file"
    echo "Alias added to ~/.bashrc."
else
    echo "Alias already exists in ~/.bashrc."
fi


echo "The sshd script is all set up. You can now run the following command to apply for the sshd service:"
echo "===================================================================================================="
echo "sbatch ~/sshd/sshd_job.sh"
echo "or you can use the alias: apply_gpu"
echo "===================================================================================================="


echo "You can reset the settings by re-running this script."