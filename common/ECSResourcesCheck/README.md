#Automatic check and comparison of ECS cluster
**How to use**

1. Add appropriate default credentials to .aws folder.
    
    `aws_access_key_id`, `aws_secret_access_key`, `region`, `output`
    
2. Add input parameters 


______Input Parameters______

Cluster name _for example_ 

`gptf-pub`

Input Json in format
```
 [{
    "mod-xyz-storage-b": {
      "SoftLimit": 1952,
      "XMX": 1440,
      "Revision": 3,
      "Version": "579891902283.dkr.ecr.us-east-1.amazonaws.com/folio/mod-inventory-storage:25.0.3",
      "desiredCount": 2,
      "CPUUnits": 1024,
      "RWSplitEnabled": false,
      "HardLimit": 2208,
      "Metaspace": 384,
      "MaxMetaspaceSize": 512
    },
    "mod-tags-b": {
      "SoftLimit": 896,
      "XMX": 768,
      "Revision": 2,
      "Version": "579891902283.dkr.ecr.us-east-1.amazonaws.com/folio/mod-tags:1.3.1",
      "desiredCount": 1,
      "CPUUnits": 128,
      "RWSplitEnabled": false,
      "HardLimit": 1024,
      "Metaspace": 88,
      "MaxMetaspaceSize": 128
    }}]

```   

**Output format**

json with marked differences between input json and actual cluster state
```
 [
   {
     "mod-inventory-storage-b": {
       "desiredCount-input": 13,
       "Version-input": "57989190228com/folio/mstorage:25.0.3",
       "Metaspace-cluster-ncp2-pvt": 384,
       "CPUUnits-input": 14,
       "XMX-input": 1,
       "CPUUnits-cluster-ncp2-pvt": 1024,
       "MaxMetaspaceSize-cluster-ncp2-pvt": 512,
       "Version-cluster-ncp2-pvt": "579891902283.dkr.ecr.us-east-1.amazonaws.com/folio/mod-inventory-storage:25.0.1",
       "SoftLimit-input": 1,
       "desiredCount-cluster-ncp2-pvt": 2,
       "HardLimit-input": 28,
       "MaxMetaspaceSize-input": 52,
       "Metaspace-input": 34,
       "HardLimit-cluster-ncp2-pvt": 2208,
       "SoftLimit-cluster-ncp2-pvt": 1952,
       "XMX-cluster-ncp2-pvt": 1440
     }
   }
 ]

```   
   
  