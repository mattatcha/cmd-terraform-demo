# Terraform Demo

### Provisions
* VPC
  * 2 Subnets
* ECS
* (2) Instances running CoreOS
  * cloud-config with ECS Agent
* CloudWatch log group
* EC2 Application Load Balancer

### Usage With Cmd.io

    # Install a Terraform Command:
    ssh <gh_user>@alpha.cmd.io :add <name> mattaitchison/cmd-terraform

    # Set Config:
    ssh <gh_user>@alpha.cmd.io <name>:config set \
        AWS_ACCESS_KEY_ID=xxx \
        AWS_SECRET_ACCESS_KEY=xxx \
        TF_STATE_bucket=<s3_bucket> \
        TF_STATE_key=<example.tfstate> \

    # Plan:
    tar -c . | ssh <gh_user>@alpha.cmd.io <name> plan

    # Apply
    tar -c . | ssh <gh_user>@alpha.cmd.io <name> apply
