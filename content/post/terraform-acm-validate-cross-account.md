---
title: "Terraform ACM cert validation Cross Account"
description: "this has a description"
date: 2019-11-03T20:36:51-08:00
draft: false
tags: devops, terraform
---

I wanted to create a cert in ACM with an associated [Subject Alternative Name (SAN)](https://en.wikipedia.org/wiki/Subject_Alternative_Name)
that belonged to a different account.

Here's an example of part of the config I wrote to do that after getting a bunch
of `Access Denied` errors and saying some swear words. 

# example
```
# -- declare provider for dev account
provider "aws" {
  max_retries = "5"

  # create an alias to differentiate between the two
  alias       = "dev"
  region      = "us-west-2"

  profile     = "dev"
  assume_role {
    role_arn = "arn:aws:iam::112233445556:role/DevRole"
  }
}

# --- declare provider for domains account
provider "aws" {
  max_retries = "5"
  alias       = "route53"
  region      = "us-west-2"

  profile     = "route53"
  assume_role {
    role_arn = "arn:aws:iam::22334455667:role/Route53"
  }
}

resource "aws_route53_zone" "zone" {
  name = "${var.hosted_zone_name}"
  private_zone = false
}

resource "aws_route53_zone" "zone_alt" {
  # grab alias to the "domains" account profile
  provider = "aws.route53"

  name = "example.com"
}

# ---- CERTS -----
resource "aws_acm_certificate" "default" {
  # registered in "dev" account
  domain_name       = "dev.example.com"
  validation_method = "DNS"

  # --- Here's the "vanity" domain to be associated with this cert.
  #     This name is registered in "domains" account reached by
  #     an assumed role
  subject_alternative_names = "example.com"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.zone.id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "cert_validation_alt1" {
  name    = "${aws_acm_certificate.default.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.default.domain_validation_options.1.resource_record_type}"
  zone_id = "${aws_route53_zone.zone_alt.zone_id}"
  records = ["${aws_acm_certificate.default.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.default.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.cert_validation.fqdn}",
    "${aws_route53_record.cert_validation_alt1.fqdn}",
  ]
}
```

# expected result
Running a `terraform plan` and `terraform apply` on this config will create a new certificate in the
_dev_ account and validate it with DNS validation. Additionally a CNAME
record will be written into the _domains_ account and that SAN will be
validated, too.

Now we can use a "vanity" CNAME like _my-app.example.com_ to point to a record in
the _dev_ account, _my-app.dev.example.com_. That record is the ALIAS to a load balancer
hostname that has the cert created above. 
