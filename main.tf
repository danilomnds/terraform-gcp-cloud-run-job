resource "google_cloud_run_v2_job" "run_job" {
  name = var.name
  # These two parameters are in beta state. The will be added in a future update. 
  #start_execution_token = var.start_execution_token
  #run_execution_token   = var.start_execution_token
  project             = var.project
  deletion_protection = var.deletion_protection
  template {
    labels      = lookup(var.template, "labels", null)
    annotations = lookup(var.template, "annotations", null)
    parallelism = lookup(var.template, "parallelism", null)
    task_count  = lookup(var.template, "task_count", null)
    template {
      dynamic "containers" {
        for_each = var.template.template.containers != null ? [var.template.template.containers] : []
        content {
          name    = lookup(containers.value, "name", null)
          image   = containers.value.image
          command = lookup(containers.value, "command", null)
          args    = lookup(containers.value, "args", null)
          dynamic "env" {
            for_each = containers.value.env != null ? [containers.value.env] : []
            content {
              name  = env.value.name
              value = lookup(env.value, "value", null)
              dynamic "value_source" {
                for_each = env.value.value_source != null ? [env.value.value_source] : []
                content {
                  dynamic "secret_key_ref" {
                    for_each = value_source.value.secret_key_ref != null ? [value_source.value.secret_key_ref] : []
                    content {
                      secret  = secret_key_ref.value.secret
                      version = secret_key_ref.value.version
                    }
                  }
                }
              }
            }
          }
          dynamic "resources" {
            for_each = containers.value.resources != null ? [containers.value.resources] : []
            content {
              limits = resources.value.limits
            }
          }
          dynamic "ports" {
            for_each = containers.value.ports != null ? [containers.value.ports] : []
            content {
              name           = lookup(ports.value, "name", null)
              container_port = lookup(ports.value, "containercontainer_port", null)
            }
          }
          dynamic "volume_mounts" {
            for_each = containers.value.volume_mounts != null ? [containers.value.volume_mounts] : []
            content {
              name       = volume_mounts.value.name
              mount_path = volume_mounts.value.mount_path
            }
          }
          working_dir = lookup(containers.value, "working_dir", null)
          depends_on = lookup(containers.value, "depends_on", null)
          dynamic "startup_probe" {
            for_each = containers.value.startup_probe != null ? [containers.value.startup_probe] : []
            content {
              initial_delay_seconds       = lookup(startup_probe.value, "initial_delay_seconds", null)
              timeout_seconds       = lookup(startup_probe.value, "timeout_seconds", null)
              period_seconds       = lookup(startup_probe.value, "period_seconds", null)
              failure_threshold       = lookup(startup_probe.value, "failure_threshold", null)
              dynamic "tcp_socket" {
                for_each = startup_probe.value.tcp_socket != null ? [startup_probe.value.tcp_socket] : []
                content {
                   port =  lookup(tcp_socket.value, "port", null)
                }                
              }
              dynamic "http_get" {
                for_each = startup_probe.value.http_get != null ? [startup_probe.value.http_get] : []
                content {
                   path =  lookup(http_get.value, "path", null)
                   port =  lookup(http_get.value, "port", null)
                   dynamic "http_headers" {
                    for_each = http_get.value.http_headers != null ? [http_get.value.http_headers] : []
                    content {
                      name = http_headers.value.name
                      value =  lookup(http_headers.value, "value", null)
                    }                     
                   }
                }                
              }
              dynamic "grpc" {
                for_each = startup_probe.value.grpc != null ? [startup_probe.value.grpc] : []
                content {
                   port =  lookup(grpc.value, "port", null)
                   service =  lookup(grpc.value, "service", null)
                }                
              }
            }
          }
        }
      }
      dynamic "volumes" {
        for_each = var.template.template.volumes != null ? [var.template.template.volumes] : []
        content {
          name = volumes.value.name
          dynamic "secret" {
            for_each = volumes.value.secret != null ? [volumes.value.secret] : []
            content {
              secret       = secret.value.secret
              default_mode = lookup(secret.value, "default_mode", null)
              dynamic "items" {
                for_each = secret.value.items != null ? [secret.value.items] : []
                content {
                  path    = items.value.path
                  version = items.value.version
                  mode    = lookup(items.value, "mode", null)
                }
              }
            }
          }
          dynamic "cloud_sql_instance" {
            for_each = volumes.value.cloud_sql_instance != null ? [volumes.value.cloud_sql_instance] : []
            content {
              instances = cloud_sql_instance.value.instances
            }
          }
          dynamic "empty_dir" {
            for_each = volumes.value.empty_dir != null ? [volumes.value.empty_dir] : []
            content {
              medium     = lookup(empty_dir.value, "medium", null)
              size_limit = lookup(empty_dir.value, "size_limit", null)              
              #mount_options = lookup(empty_dir.value, "mount_options", null)
            }
          }
          dynamic "gcs" {
            for_each = volumes.value.gcs != null ? [volumes.value.gcs] : []
            content {
              bucket    = gcs.value.bucket
              read_only = lookup(gcs.value, "read_only", null)
            }
          }
          dynamic "nfs" {
            for_each = volumes.value.nfs != null ? [volumes.value.nfs] : []
            content {
              server    = nfs.value.server
              path      = lookup(nfs.value, "path", null)
              read_only = lookup(nfs.value, "read_only", null)
            }
          }
        }
      }
      timeout               = lookup(var.template.template, "timeout", null)
      service_account       = lookup(var.template.template, "service_account", null)
      execution_environment = lookup(var.template.template, "execution_environment", null)
      encryption_key        = lookup(var.template.template, "encryption_key", null)
      dynamic "vpc_access" {
        for_each = var.template.template.vpc_access != null ? [var.template.template.vpc_access] : []
        content {
          connector = lookup(vpc_access.value, "connector", null)
          egress    = lookup(vpc_access.value, "egress", null)
          dynamic "network_interfaces" {
            for_each = vpc_access.value.network_interfaces != null ? [vpc_access.value.network_interfaces] : []
            content {
              network    = lookup(network_interfaces.value, "network", null)
              subnetwork = lookup(network_interfaces.value, "subnetwork", null)
              tags       = lookup(network_interfaces.value, "tags", null)
            }
          }
        }
      }
      max_retries = lookup(var.template.template, "max_retries", null)
      dynamic "node_selector" {
        for_each = var.template.template.node_selector != null ? [var.template.template.node_selector] : []
        content {
          accelerator = node_selector.value.accelerator
        }        
      }
      gpu_zonal_redundancy_disabled = lookup(var.template.template, "gpu_zonal_redundancy_disabled", null)      
    }
  }
  location       = var.location
  labels         = var.labels
  annotations    = var.annotations
  client         = var.client
  client_version = var.client_version
  launch_stage   = var.launch_stage
  dynamic "binary_authorization" {
    for_each = var.binary_authorization != null ? [var.binary_authorization] : []
    content {
      breakglass_justification = lookup(binary_authorization.value, "breakglass_justification", null)
      use_default              = lookup(binary_authorization.value, "use_default", null)
      policy                   = lookup(binary_authorization.value, "policy", null)
    }
  }
  lifecycle {
    ignore_changes = [
      template[0].service_account,
      template[0].containers[0].command,
      template[0].containers[0].env,
      template[0].containers[0].name,
      template[0].containers[0].image,
      template[0].containers[0].volume_mounts,
    template[0].volumes]
  }
}

resource "google_project_iam_member" "CustomCloudRunDeveloper" {
  depends_on = [google_cloud_run_v2_job.run_job]
  for_each   = { for member in var.members : member => member }
  project    = var.project
  role       = "organizations/<your org id>/roles/CustomCloudRunDeveloper"
  member     = each.value
}

resource "google_project_iam_member" "CloudSchedulerAdmin" {
  depends_on = [google_cloud_run_v2_job.run_job]
  for_each   = { for member in var.members : member => member }
  project    = var.project
  role       = "roles/cloudscheduler.admin"
  member     = each.value
}