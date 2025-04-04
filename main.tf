locals {
  broker_security_groups = var.create_security_group ? [module.security_group[0].security_group_id] : var.security_groups

  
  mq_application_user_needed = var.mq_application_user == ""
  mq_application_user        = local.mq_application_user_needed ? random_pet.mq_application_user[0].id : var.mq_application_user

  mq_application_password_needed = var.mq_application_password == ""
  mq_application_password        = local.mq_application_password_needed ? random_password.mq_application_password[0].result : var.mq_application_password
}

resource "random_pet" "mq_application_user" {
  count     = var.mq_application_user == "" ? 1 : 0
  length    = 2
  separator = "-"
}

resource "random_password" "mq_application_password" {
  count       = var.mq_application_password == "" ? 1 : 0
  length  = 24
  special = false
}

resource "aws_mq_broker" "rabbitmq" {
  broker_name    = var.rabbitmq_name
  engine_type    = var.engine_type
  engine_version = var.engine_version

  apply_immediately = var.apply_immediately

  # the most cheap type is mq.m5.large on multi az deployment mode, mq.t3.micro is available on SINGLE_INSTANCE deployment mode.
  host_instance_type         = var.host_instance_type
  deployment_mode            = var.deployment_mode
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  publicly_accessible        = var.publicly_accessible
  subnet_ids                 = var.subnet_ids

  security_groups = local.broker_security_groups

  logs {
    general = var.enable_cloudwatch_logs
    audit   = false
  }

  dynamic "maintenance_window_start_time" {
    for_each = var.enable_maintenance_window ? [1] : []
    content {
      day_of_week = var.maintenance_window_start_time.mw_day_of_week
      time_of_day = var.maintenance_window_start_time.mw_time_of_day
      time_zone   = var.maintenance_window_start_time.mw_time_zone
    }
  }

  user {
    username = local.mq_application_user
    password = local.mq_application_password
  }

  tags = var.tags

  depends_on = [
    module.security_group
  ]
}
