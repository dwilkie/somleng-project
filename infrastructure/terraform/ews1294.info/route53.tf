resource "aws_route53_zone" "ews1294_info" {
  name = "ews1294.info."
}

module "route53_record_somleng_twilreapi" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.ews1294_info.zone_id}"
  record_name          = "${local.twilreapi_route53_record_name}"
  alias_dns_name       = "${module.twilreapi_eb_app_env.web_cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}