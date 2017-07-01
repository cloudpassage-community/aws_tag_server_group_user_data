#!/bin/bash

sudo pip install --upgrade pip
sudo yum -y install python-pip

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
tag_value=$(grep -Po 'Name \K\S+' <<< $tag_value)
