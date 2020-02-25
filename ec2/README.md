## Prerequisites
1. Create own domain
2. Move domain to aws control
3. Generate aws cert and insert challenge

## Before call start.sh script
Add envs with data to profile/<profile_name:test>/cred.txt:

#### THIS FILE MARKED AS IGNORED FOR GIT

```
AWS_ACCESS_KEY_ID="<YOUR_ACCESS_KEY>"
AWS_SECRET_ACCESS_KEY="<YOUR_SECRET_ACCESS_KEY>"
```
     
In profile/<profile_name:test>/tf_vars.tfvars defined task required vars.

## infra-deploy

For start infrastructure deploy use `make`

## infra-cleanup

For start infrastructure cleanup use `make`

## certs

Currently in developing. SSL cert created on manually request by aws.

## Test the whole setup

For start tests `make`

## Note

Not make pull requests. Fork/Clone the repo instead and work on it. Master branches only.

There is no need to deploy infrastructure to AWS. Just make sure it fully valid terraform infrastructure-as-code setup.