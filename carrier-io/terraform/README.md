### Installation

Create variable file with secrets *secrets.auto.tfvars*
```bash
key_pair_name   = "<KEY_NAME>"
redis_password  = "<PASSWORD>"
influx_password = "<PASSWORD>"
rabbit_password = "<PASSWORD>"
```

Initialize project

```terraform init```

Plan infrastructure provisioning and check

```terraform plan -input=false -out tfplan```

Apply infrastructure with tfplan configuration 

```terraform apply -input=false tfplan```

### Uninstall

Initialize project

```terraform init```

Destroy infrastructure

```terraform destroy --auto-approve```

### For installing on EBSCO side used next value of vars:
deploy_load_balancer=true 
resource_name=carrier 
aws_region=us-east-1
root_domain=int.folio.ebsco.com 
vpc_name=VpcA-Platform-AWSNVirginia-FolioIntegration
root_domain=int.folio.ebsco.com
subnet_type_tag_key=aws:cloudformation:logical-id
subnet_type_tag_value=VpcASubnetPubA*

