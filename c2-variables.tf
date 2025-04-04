variable "rabbitmq_name" {
  type        = string
  description = " (Required) Name of the broker."
}

variable "engine_type" {
  type        = string
  description = "(Optional) Type of broker engine."
  default     = "RabbitMQ"
}

variable "engine_version" {
  type        = string
  description = "The version of the broker engine. Valid values: [3.10.20, 3.10.10, 3.9.27, 3.9.24, 3.9.16, 3.9.13, 3.8.34, 3.8.30, 3.8.27, 3.8.26, 3.8.23, 3.8.22, 3.8.11, 3.8.6]. See https://docs.aws.amazon.com/amazon-mq/latest/developer-guide/broker-engine.html for more details"
  default     = "3.8.6"
}

variable "apply_immediately" {
  type        = bool
  description = "(Optional) Specifies whether any broker modifications are applied immediately, or during the next maintenance window. Default is false"
  default     = false
}

variable "host_instance_type" {
  type        = string
  description = "The broker's instance type. e.g. mq.t2.micro or mq.m4.large"
  default     = "mq.t3.micro"
}

variable "deployment_mode" {
  type        = string
  description = "(Optional) Deployment mode of the broker. Valid values are `SINGLE_INSTANCE`, `ACTIVE_STANDBY_MULTI_AZ`, and `CLUSTER_MULTI_AZ`"
  default     = "SINGLE_INSTANCE"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Enables automatic upgrades to new minor versions for brokers, as Apache releases the versions"
  default     = false
}

variable "publicly_accessible" {
  type        = bool
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
  default     = false
}

variable "subnet_ids" {
  type        = list(string)
  description = <<EOF
    (Required) List of VPC subnet IDs.
    If you install Rabbitmq with Deployment mode: "SINGLE_INSTANCE", you will have to declare single subnet. Example: ["subnet-0088935e564caec68"]
  EOF
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "mq_application_user" {
  type        = string
  description = "Application username"
  default     = ""
}

variable "mq_application_password" {
  type        = string
  description = "Application password"
  default     = ""
  sensitive   = true
}

variable "enable_cloudwatch_logs" {
  type    = bool
  default = true
}

variable "enable_maintenance_window" {
  description = "Set to true to enable the maintenance window for the MQ broker"
  type        = bool
  default     = false // Or true, depending on your desired default behavior
}

variable "maintenance_window_start_time" {
  type = object({
    mw_day_of_week = string
    mw_time_of_day = string
    mw_time_zone   = string
  })
  default = {
    mw_day_of_week = "SUNDAY"
    mw_time_of_day = "03:00"
    mw_time_zone   = "UTC"
  }
}

variable "security_groups" {
  type    = list(string)
  default = []
}
