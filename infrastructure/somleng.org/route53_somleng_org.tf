resource "aws_route53_zone" "somleng_org" {
  name = "${local.route53_domain_name}."
}

resource "aws_route53_zone" "internal" {
  name = "${local.internal_route53_domain_name}."

  vpc {
    vpc_id = "${module.vpc.vpc_id}"
  }
}

module "route53_record_somleng_twilreapi" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.somleng_org.zone_id}"
  record_name          = "${local.twilreapi_route53_record_name}"
  alias_dns_name       = "${module.twilreapi_eb_app_env.web_cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

module "route53_record_somleng_adhearsion" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.internal.zone_id}"
  record_name          = "${local.somleng_adhearsion_route53_record_name}"
  alias_dns_name       = "${module.somleng_adhearsion_webserver.cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

module "route53_record_somleng_freeswitch" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.internal.zone_id}"
  record_name          = "${local.somleng_freeswitch_route53_record_name}"
  alias_dns_name       = "${module.freeswitch_main.cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

module "route53_record_scfm" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.somleng_org.zone_id}"
  record_name          = "${local.scfm_route53_record_name}"
  alias_dns_name       = "${module.scfm_eb_app_env.web_cname}"
  alias_hosted_zone_id = "${local.eb_zone_id}"
}

# For GSuite
resource "aws_route53_record" "somleng_org_mx" {
  zone_id = "${aws_route53_zone.somleng_org.zone_id}"
  name    = ""
  type    = "MX"
  ttl     = "3600"

  records = [
    "1 ASPMX.L.GOOGLE.COM",
    "5 ALT1.ASPMX.L.GOOGLE.COM",
    "5 ALT2.ASPMX.L.GOOGLE.COM",
    "10 ALT3.ASPMX.L.GOOGLE.COM",
    "10 ALT4.ASPMX.L.GOOGLE.COM",
  ]
}

# For GSuite
resource "aws_route53_record" "somleng_org_txt" {
  zone_id = "${aws_route53_zone.somleng_org.zone_id}"
  name    = ""
  type    = "TXT"
  ttl     = "3600"

  records = [
    "google-site-verification=rTfaXAmUN4J7FWHKFGg--fFAv3_Gj9nyGrdA2MsOqbU",
  ]
}

# naked redirection bucket
resource "aws_s3_bucket" "somleng_org_redirection" {
  bucket = "somleng.org"
  acl    = "private"

  website {
    redirect_all_requests_to = "https://www.somleng.org"
  }
}

module "route53_record_somleng_org" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.somleng_org.zone_id}"
  record_name          = ""
  alias_dns_name       = "${module.somleng_naked_redirect.domain_name}"
  alias_hosted_zone_id = "${module.somleng_naked_redirect.hosted_zone_id}"
}

module "route53_record_somleng_org_www" {
  source = "../modules/route53_alias_record"

  hosted_zone_id       = "${aws_route53_zone.somleng_org.zone_id}"
  record_name          = "www"
  alias_dns_name       = "${module.somleng_website.domain_name}"
  alias_hosted_zone_id = "${module.somleng_website.hosted_zone_id}"
}

# rtd CNAME
resource "aws_route53_record" "somleng_org_rtd" {
  zone_id = "${aws_route53_zone.somleng_org.zone_id}"
  name    = "rtd"
  type    = "CNAME"
  ttl     = "3600"

  records = [
    "somleng-rtd.herokuapp.com",
  ]
}
