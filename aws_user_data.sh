#!/bin/bash

release_file="/etc/*-release"
pip_install_script_url="https://bootstrap.pypa.io/get-pip.py"
pip_install_script="get-pip.py"
is_redhat=0
is_amazon=0

grep "Red Hat" $release_file
if [[ "$?" -eq 0 ]]; then 
  is_redhat=1
fi

if [[ "$is_redhat" -eq 0 ]]; then
  grep "Amazon Linux" $release_file
  if [[ "$?" -eq 0 ]]; then
    is_amazon=1
  fi
fi

if [[ "$is_redhat" -eq "1" ]]; then
  curl -O $pip_install_script_url
  sudo python $pip_install_script
  sudo pip install awscli
  curl -O http://s3.amazonaws.com/ec2metadata/ec2-metadata
  chmod u+x ec2-metadata
  sudo mkdir -p /opt/aws/bin/
  sudo mv ec2-metadata /opt/aws/bin/
elif [[ "$is_amazon" -eq "1" ]]; then 
  sudo pip install --upgrade pip
  sudo yum -y install python-pip
else
  echo "Only tested with Amazon Linux and RHEL... exiting..."
  exit -1
fi

fields=2
SPACE=" "

#get the instance ID
instance_id=$(/opt/aws/bin/ec2-metadata --instance-id | cut --fields=$fields -d "$SPACE")

metadata_url="http://169.254.169.254/latest/dynamic/instance-identity/document"
delimeter="\""

#get the region
region=$(curl -s $metadata_url | grep region | awk -F$delimeter '{print $4}')

# get the tags
tag_value=$(aws --region $region ec2 describe-tags --filters "Name=resource-id,Values=$instance_id" --output=text)

# get the Name: value
if [[ "$is_redhat" -eq "1" ]]; then
  fields=5
  tag_value=$(echo $tag_value | cut --fields=$fields -d "$SPACE")
else
  tag_value=$(grep -Po 'Name \K\S+' <<< $tag_value)
fi
