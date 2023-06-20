### Installation

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

```bash
deploy_load_balancer  = false
resource_name         = "carrier"
aws_region            = "us-east-1"
vpc_name              = "VpcA-Platform-AWSNVirginia-FolioIntegration"
root_domain           = "int.folio.ebsco.com"
subnet_type_tag_key   = "aws:cloudformation:logical-id"
subnet_type_tag_value = "VpcASubnetPubA*"

key_pair_name = "carrier-io-2"
ingress_cidr  = "140.234.0.0/16"
```

