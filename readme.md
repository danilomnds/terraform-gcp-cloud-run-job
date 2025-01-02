# Module - Cloud Run Job V2
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![GCP](https://img.shields.io/badge/provider-GCP-green)](https://registry.terraform.io/providers/hashicorp/google/latest)

Module developed to standardize the creation of Cloud Run Jobs.

## Compatibility Matrix

| Module Version | Terraform Version | Google Version     |
|----------------|-------------------| ------------------ |
| v1.0.0         | v1.10.2           | 6.14.1             |

## Specifying a version

To avoid that your code get the latest module version, you can define the `?ref=***` in the URL to point to a specific version.
Note: The `?ref=***` refers a tag on the git module repo.

## Default use case
```hcl
module "cloudrunjobA" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-cloud-run-job?ref=v1.0.0"
  project = "project_id"
  name = "cloudrunjobA"
  location = "<southamerica-east1>"
  template = {
    template = {
      containers = {
        image = "us-docker.pkg.dev/cloudrun/container/job"
      }
      resources = {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
      }
      vpc_access = {
        network_interfaces = {
          network = "default"
          subnetwork = "default"
          tags = ["tag1", "tag2", "tag3"]
        }
      }
    }
  }
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.cloudrunjobA.id
}
```

## Default use case plus RBAC
```hcl
module "cloudrunjobA" {    
  source = "git::https://github.com/danilomnds/terraform-gcp-cloud-run-job?ref=v1.0.0"
  project = "project_id"
  name = "cloudrunjobA"
  location = "<southamerica-east1>"
  members = ["group:GRP_GCP-SYSTEM-PRD@timbrasil.com.br"]
  template = {
    template = {
      containers = {
        image = "us-docker.pkg.dev/cloudrun/container/job"
      }
      resources = {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
      }
      vpc_access = {
        network_interfaces = {
          network = "default"
          subnetwork = "default"
          tags = ["tag1", "tag2", "tag3"]
        }
      }
    }
  }
  labels = {
    diretoria   = "ctio"
    area        = "area"
    system      = "system"    
    environment = "fqa"
    projinfra   = "0001"
    dm          = "00000000"
    provider    = "gcp"
    region      = "southamerica-east1"
  }
}
output "id" {
  value = module.cloudrunjobA.id
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the Job | `string` | n/a | `Yes` |
| template | The template used to create executions for this Job. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job) | `object({})` | n/a | `Yes` |
| location | The name of the location this repository is located in | `string` | n/a | `Yes` |
| labels | Labels with user-defined metadata | `map(string)` | n/a | No |
| annotations | Unstructured key value map that may be set by external tools to store and arbitrary metadata | `map(string)` | n/a | No |
| client | Arbitrary identifier for the API client | `string` | n/a | No |
| client_version | Arbitrary version identifier for the API client | `string` | n/a | No |
| launch_stage | The launch stage as defined by Google Cloud Platform Launch Stages. Cloud Run supports ALPHA, BETA, and GA | `string` | n/a | No |
| binary_authorization | Settings for the Binary Authorization feature. See the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job) | `object({})` | n/a | No |
| start_execution_token | A unique string used as a suffix creating a new execution upon job create or update | `string` | n/a | No |
| run_execution_token |  A unique string used as a suffix creating a new execution upon job create or update | `string` | n/a | No |
| project | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `string` | n/a | No |
| deletion_protection | Whether Terraform will be prevented from destroying the job | `bool` | `true` | No |
| members | list of azure AD groups that will use the resource | `list(string)` | n/a | No |
| scheduler_jobs_admin | Should Cloud Scheduler Admin be granted?  | `bool` | `false` | No |

# Object variables for blocks

Please check the documentation [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job)

## Output variables

| Name | Description |
|------|-------------|
| id | cloud run job id|

## Documentation
Cloud Run Job: <br>
[https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_v2_job)