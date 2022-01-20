# Learn Terraform Resources

This repo is a workstation showcasing provisioning of resources to AWS with Terraform

# Code walk through and Referencing
- Deploy a subnet to which we can deploy our future EC2 instances. [Reference resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)

- Give our resources a way to the internet by creating an internet gateway. [Reference resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

- Then we're going to create a route table to route traffic from our subnet to our internet gateway. 
    - [route table resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) 
    - [route resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route)

- Next is to bridge the gap between our route table and our subnet by providing a route table association. [Resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) 

- Create the security group, adding all the resources. [Check how](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)

- Deploy the EC2 instance. We are going to utilize userdata in `userdata.tpl` to bootstrap our instance and install the docker engine. [Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)