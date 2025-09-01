variable "name" {
  type = string
}

variable "template" {
  type = object({
    labels      = optional(map(string))
    annotations = optional(map(string))
    parallelism = optional(number)
    task_count  = optional(number)
    template = object({
      containers = optional(object({
        name    = optional(string)
        image   = string
        command = optional(list(string))
        args    = optional(list(string))
        env = optional(object({
          name  = string
          value = optional(string)
          value_source = optional(object({
            secret_key_ref = optional(object({
              secret  = string
              version = string
            }))
          }))
        }))
        resources = optional(object({
          limits = optional(map(string))
        }))
        ports = optional(object({
          name           = optional(string)
          container_port = optional(number)
        }))
        volume_mounts = optional(object({
          name       = string
          mount_path = string
        }))
        working_dir = optional(string)        
        depends_on = optional(list(string))        
        startup_probe = optional(object({
          initial_delay_seconds = optional(number)
          timeout_seconds = optional(number)
          period_seconds = optional(number)
          failure_threshold = optional(number)
          tcp_socket = optional(object({
            port = optional(number)
          }))
          http_get = optional(object({
            path = optional(string)
            port = optional(number)
            http_headers = optional(object({
              name = string
              value = optional(string)
            }))
          }))
          grpc = optional(object({
            port = optional(string)
            service = optional(string)
          }))
        }))
      }))
      volumes = optional(object({
        name = string
        secret = optional(object({
          secret       = string
          default_mode = optional(string)
          items = optional(object({
            path    = string
            version = string
            mode    = string
          }))
        }))
        cloud_sql_instance = optional(object({
          instances = optional(list(string))
        }))
        # beta option
        empty_dir = optional(object({
          medium     = optional(string)
          size_limit = optional(string)
          # beta
          #mount_options = optional(list(string))
        }))
        gcs = optional(object({
          bucket    = string
          read_only = optional(bool)
        }))
        nfs = optional(object({
          server    = string
          path      = optional(string)
          read_only = optional(bool)
        }))
      }))
      timeout               = optional(string)
      service_account       = optional(string)
      execution_environment = optional(string)
      encryption_key        = optional(string)
      vpc_access = optional(object({
        connector = optional(string)
        egress    = optional(string)
        network_interfaces = optional(object({
          network    = optional(string)
          subnetwork = optional(string)
          tags       = list(string)
        }))
      }))
      max_retries = optional(number)
      node_selector = optional(object({
        accelerator = string
      }))
      gpu_zonal_redundancy_disabled = optional(bool)
    })
  })
}

variable "location" {
  type = string
}

variable "labels" {
  type    = map(string)
  default = null
}

variable "annotations" {
  type    = map(string)
  default = null
}

variable "client" {
  type    = string
  default = null
}

variable "client_version" {
  type    = string
  default = null
}

variable "launch_stage" {
  type    = string
  default = null
}

variable "binary_authorization" {
  type = object({
    breakglass_justification = optional(string)
    use_default              = optional(bool)
    policy                   = optional(string)
  })
  default = null
}

variable "start_execution_token" {
  type    = string
  default = null
}

variable "run_execution_token" {
  type    = string
  default = null
}

variable "project" {
  type    = string
  default = null
}

variable "deletion_protection" {
  type    = bool
  default = true
}

variable "members" {
  type    = list(string)
  default = []
}

variable "scheduler_jobs_admin" {
  type    = bool
  default = false
}