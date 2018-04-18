resource "aws_elastic_beanstalk_application" "twilreapi" {
  name = "somleng-twilreapi"
  description = "Somleng Twilio REST API instance"
}

module "twilreapi_eb_app_env" {
  source = "../modules/eb_app_env"

  app_name            = "${aws_elastic_beanstalk_application.twilreapi.name}"
  solution_stack_name = "${module.twilreapi_eb_solution_stack.ruby_name}"
  env_identifier      = "${local.twilreapi_identifier}"
  default_url_host    = "${local.twilreapi_url_host}"

  vpc_id            = "${module.pin_vpc.vpc_id}"
  private_subnets   = "${module.pin_vpc.private_subnets}"
  public_subnets    = "${module.pin_vpc.public_subnets}"
  security_groups   = ["${module.twilreapi_db.security_group}"]
  service_role      = "${module.eb_iam.eb_service_role}"
  ec2_instance_role = "${module.eb_iam.eb_ec2_instance_role}"

  database_url     = "postgres://${module.twilreapi_db.db_username}:${module.twilreapi_db.db_password}@${module.twilreapi_db.db_instance_endpoint}/${module.twilreapi_db.db_instance_name}"
  rails_master_key = "${data.aws_kms_secret.this.twilreapi_rails_master_key}"
  aws_region       = "${var.aws_region}"
  db_pool          = "32"

  s3_access_key_id     = "${module.s3_iam.s3_access_key_id}"
  s3_secret_access_key = "${module.s3_iam.s3_secret_access_key}"
  uploads_bucket       = "${aws_s3_bucket.uploads.id}"
  ssl_certificate_id   = "${data.aws_acm_certificate.ews1294.arn}"
  outbound_call_drb_uri = "${local.twilreapi_outbound_call_drb_uri}"
  outbound_call_job_queue_url = "${module.twilreapi_eb_outbound_call_worker_env.aws_sqs_queue_url}"
}

module "twilreapi_eb_outbound_call_worker_env" {
  source = "../modules/eb_env"

  app_name            = "${aws_elastic_beanstalk_application.twilreapi.name}"
  tier                = "Worker"
  instance_type       = "t2.nano"
  solution_stack_name = "${module.twilreapi_eb_solution_stack.ruby_name}"
  env_identifier      = "${local.twilreapi_identifier}-caller"
  default_url_host    = "${local.twilreapi_url_host}"

  vpc_id            = "${module.pin_vpc.vpc_id}"
  private_subnets   = "${module.pin_vpc.private_subnets}"
  public_subnets    = "${module.pin_vpc.public_subnets}"
  security_groups   = ["${module.twilreapi_db.security_group}"]
  service_role      = "${module.eb_iam.eb_service_role}"
  ec2_instance_role = "${module.eb_iam.eb_ec2_instance_role}"

  database_url     = "postgres://${module.twilreapi_db.db_username}:${module.twilreapi_db.db_password}@${module.twilreapi_db.db_instance_endpoint}/${module.twilreapi_db.db_instance_name}"
  rails_master_key = "${data.aws_kms_secret.this.twilreapi_rails_master_key}"
  aws_region       = "${var.aws_region}"
  db_pool          = "32"

  s3_access_key_id     = "${module.s3_iam.s3_access_key_id}"
  s3_secret_access_key = "${module.s3_iam.s3_secret_access_key}"
  uploads_bucket       = "${aws_s3_bucket.uploads.id}"
  ssl_certificate_id   = "${data.aws_acm_certificate.ews1294.arn}"
  outbound_call_drb_uri = "${local.twilreapi_outbound_call_drb_uri}"
}