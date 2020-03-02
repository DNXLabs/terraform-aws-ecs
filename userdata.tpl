#! /bin/bash

set -eux

echo "### INSTALL PACKAGES"

yum update -y
yum install -y amazon-efs-utils aws-cli

echo "### INSTALL SSM AGENT"

cd /tmp
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
restart amazon-ssm-agent

echo "### SETUP EFS"

EFS_DIR=/mnt/efs
EFS_ID=${tf_efs_id}

mkdir -p $${EFS_DIR}
echo "$${EFS_ID}:/ $${EFS_DIR} efs tls,_netdev" >> /etc/fstab

for i in $(seq 1 20); do mount -a -t efs defaults && break || sleep 60; done

echo "### SETUP AGENT"

echo "ECS_CLUSTER=${tf_cluster_name}" >> /etc/ecs/ecs.config
echo "ECS_ENABLE_SPOT_INSTANCE_DRAINING=true" >> /etc/ecs/ecs.config


echo "### HARDENING DOCKER"
sed -i "s/1024:4096/65535:65535/g" "/etc/sysconfig/docker"

echo "### HARDENING EC2 INSTACE"
echo "ulimit -u unlimited" >> /root/.bashrc
echo "ulimit -n 1048576" >> /root/.bashrc
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
echo "fs.file-max=65536" >> /etc/sysctl.conf
/sbin/sysctl -p /etc/sysctl.conf


echo "### EXTRA USERDATA"
${userdata_extra}
