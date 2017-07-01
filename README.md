Add a Linux Server to a Halo Server Group Using an AWS Tag and User Data
-

Notes
-

1) This is sample code and is not supported by CloudPassage.  The purpose is to get a user up and running using an AWS tag value to assign
workloads to Halo server groups.
2) This has only been tested on Amazon Linux
3) This example only shows how to do this using the AWS console

Description
-

The file aws_user_data.sh will grab the value of the AWS tag "Name" key (e.g. Name:value).  This value will be used to
move the server to a Halo server group whose name has the same value.

For example, if the AWS tags are "TAGS Name Pre-Production instance cpd3mo-cicd-pre-prod.com" the server will be moved
into the Pre-Production server group (if it exists).

This will be used alongside the Halo install script.

Usage
-

1) This requires a role an IAM user can use with instance launches that has a describe tags policy attached to it.

A DescribeTags policy looks like:

{  
    &nbsp;&nbsp;&nbsp;&nbsp;"Version": "2012-10-17",  
    &nbsp;&nbsp;&nbsp;&nbsp;"Statement": [  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{  
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Effect": "Allow",  
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Action": "ec2:DescribeTags",  
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"Resource": "*"  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;}  
    &nbsp;&nbsp;&nbsp;&nbsp;]  
}  

2) Launch an instance of Amazon Linux with the AWS console.  In 'Step 3: Configure Instance Details'    
2a) For 'IAM Role', choose the DescribeTags role  
2b) Place the contents of aws_user_data.sh into the 'User Data'.

3) Get the script for an Amazon Linux agent installation from Halo  
3a) Paste it below the text in aws_user_data.sh in 'User Data'  
3b) Note: <agent_key> will be your agent registration key and will already be populated  
3c) Append a tag value (--tag=$tag_value) to the end of the following line in the agent installation script as shown 
below:  

sudo /opt/cloudpassage/bin/configure --agent-key=<agent_key>
--grid=https://grid.cloudpassage.com/grid \\  
--tag=$tag_value  

4) Tag the instance in Add Tags with a key value pair where the key is Name (e.g. Key=Name, Value=Pre-Production)

5) Ensure you have a server group that matches

6) Launch

Have fun!



