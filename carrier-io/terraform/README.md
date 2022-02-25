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
