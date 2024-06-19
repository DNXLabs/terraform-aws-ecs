#! /bin/bash

set -eux

echo "### HARDENING DOCKER"
sed -i "s/1024:4096/65535:65535/g" "/etc/sysconfig/docker"

echo "### HARDENING EC2 INSTACE"
echo "ulimit -u unlimited" >> /etc/rc.local
echo "ulimit -n 1048576" >> /etc/rc.local
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
/sbin/sysctl -p /etc/sysctl.conf

function checkECSregistration {
    logger -s "ecs Check if there are any running Docker containers"
    # Check if there are any running Docker containers
    sleep 1200
    docker_container_count=$(docker ps -q | wc -l)
    ecs_registration=$(curl -s http://localhost:51678/v1/metadata | grep ${tf_cluster_name} | wc -l)
    # If there are no running Docker containers and ECS agent is still not registered, terminate the instance
    if [ "$docker_container_count" -le "1" ] && [ $ecs_registration -eq "0" ]; then
        logger -s "No running Docker containers found and ECS agent is not registered. Terminating the instance..."
        shutdown -h now
    fi
}

checkECSregistration &

echo "### INSTALL PACKAGES"
yum update -y
yum install -y amazon-efs-utils aws-cli


echo "### SETUP EFS"
EFS_DIR=/mnt/efs
EFS_ID=${tf_efs_id}

mkdir -p $${EFS_DIR}
echo "$${EFS_ID}:/ $${EFS_DIR} efs tls,_netdev" >> /etc/fstab

for i in $(seq 1 20); do mount -a -t efs defaults && break || sleep 60; done

echo "### SETUP AGENT"

echo "ECS_CLUSTER=${tf_cluster_name}" >> /etc/ecs/ecs.config
echo "ECS_ENABLE_SPOT_INSTANCE_DRAINING=true" >> /etc/ecs/ecs.config


echo "### EXTRA USERDATA"
${userdata_extra}
