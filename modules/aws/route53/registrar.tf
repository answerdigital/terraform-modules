resource "aws_route53domains_registered_domain" "this" {
  for_each    = toset(try(var.registrar_contacts.registrant.email, var.registrar_contacts.default.email, "") != "" ? [var.domain] : [])
  domain_name = each.key

  admin_contact {
    email             = try(var.registrar_contacts.admin.email, var.registrar_contacts.default.email, "")
    first_name        = try(var.registrar_contacts.admin.first_name, var.registrar_contacts.default.first_name, "")
    last_name         = try(var.registrar_contacts.admin.last_name, var.registrar_contacts.default.last_name, "")
    contact_type      = try(var.registrar_contacts.admin.contact_type, var.registrar_contacts.default.contact_type, "")
    phone_number      = try(var.registrar_contacts.admin.phone_number, var.registrar_contacts.default.phone_number, "")
    fax               = try(var.registrar_contacts.admin.fax, var.registrar_contacts.default.fax, "")
    organization_name = try(var.registrar_contacts.admin.organization_name, var.registrar_contacts.default.organization_name, "")
    address_line_1    = try(var.registrar_contacts.admin.address_line_1, var.registrar_contacts.default.address_line_1, "")
    address_line_2    = try(var.registrar_contacts.admin.address_line_2, var.registrar_contacts.default.address_line_2, "")
    city              = try(var.registrar_contacts.admin.city, var.registrar_contacts.default.city, "")
    state             = try(var.registrar_contacts.admin.state, var.registrar_contacts.default.state, "")
    zip_code          = try(var.registrar_contacts.admin.zip_code, var.registrar_contacts.default.zip_code, "")
    country_code      = try(var.registrar_contacts.admin.country_code, var.registrar_contacts.default.country_code, "")
    extra_params      = try(var.registrar_contacts.admin.extra_params, var.registrar_contacts.default.extra_params, {})
  }

  billing_contact {
    email             = try(var.registrar_contacts.billing.email, var.registrar_contacts.default.email, "")
    first_name        = try(var.registrar_contacts.billing.first_name, var.registrar_contacts.default.first_name, "")
    last_name         = try(var.registrar_contacts.billing.last_name, var.registrar_contacts.default.last_name, "")
    contact_type      = try(var.registrar_contacts.billing.contact_type, var.registrar_contacts.default.contact_type, "")
    phone_number      = try(var.registrar_contacts.billing.phone_number, var.registrar_contacts.default.phone_number, "")
    fax               = try(var.registrar_contacts.billing.fax, var.registrar_contacts.default.fax, "")
    organization_name = try(var.registrar_contacts.billing.organization_name, var.registrar_contacts.default.organization_name, "")
    address_line_1    = try(var.registrar_contacts.billing.address_line_1, var.registrar_contacts.default.address_line_1, "")
    address_line_2    = try(var.registrar_contacts.billing.address_line_2, var.registrar_contacts.default.address_line_2, "")
    city              = try(var.registrar_contacts.billing.city, var.registrar_contacts.default.city, "")
    state             = try(var.registrar_contacts.billing.state, var.registrar_contacts.default.state, "")
    zip_code          = try(var.registrar_contacts.billing.zip_code, var.registrar_contacts.default.zip_code, "")
    country_code      = try(var.registrar_contacts.billing.country_code, var.registrar_contacts.default.country_code, "")
    extra_params      = try(var.registrar_contacts.billing.extra_params, var.registrar_contacts.default.extra_params, {})
  }

  registrant_contact {
    email             = try(var.registrar_contacts.registrant.email, var.registrar_contacts.default.email, "")
    first_name        = try(var.registrar_contacts.registrant.first_name, var.registrar_contacts.default.first_name, "")
    last_name         = try(var.registrar_contacts.registrant.last_name, var.registrar_contacts.default.last_name, "")
    contact_type      = try(var.registrar_contacts.registrant.contact_type, var.registrar_contacts.default.contact_type, "")
    phone_number      = try(var.registrar_contacts.registrant.phone_number, var.registrar_contacts.default.phone_number, "")
    fax               = try(var.registrar_contacts.registrant.fax, var.registrar_contacts.default.fax, "")
    organization_name = try(var.registrar_contacts.registrant.organization_name, var.registrar_contacts.default.organization_name, "")
    address_line_1    = try(var.registrar_contacts.registrant.address_line_1, var.registrar_contacts.default.address_line_1, "")
    address_line_2    = try(var.registrar_contacts.registrant.address_line_2, var.registrar_contacts.default.address_line_2, "")
    city              = try(var.registrar_contacts.registrant.city, var.registrar_contacts.default.city, "")
    state             = try(var.registrar_contacts.registrant.state, var.registrar_contacts.default.state, "")
    zip_code          = try(var.registrar_contacts.registrant.zip_code, var.registrar_contacts.default.zip_code, "")
    country_code      = try(var.registrar_contacts.registrant.country_code, var.registrar_contacts.default.country_code, "")
    extra_params      = try(var.registrar_contacts.registrant.extra_params, var.registrar_contacts.default.extra_params, {})
  }

  tech_contact {
    email             = try(var.registrar_contacts.tech.email, var.registrar_contacts.default.email, "")
    first_name        = try(var.registrar_contacts.tech.first_name, var.registrar_contacts.default.first_name, "")
    last_name         = try(var.registrar_contacts.tech.last_name, var.registrar_contacts.default.last_name, "")
    contact_type      = try(var.registrar_contacts.tech.contact_type, var.registrar_contacts.default.contact_type, "")
    phone_number      = try(var.registrar_contacts.tech.phone_number, var.registrar_contacts.default.phone_number, "")
    fax               = try(var.registrar_contacts.tech.fax, var.registrar_contacts.default.fax, "")
    organization_name = try(var.registrar_contacts.tech.organization_name, var.registrar_contacts.default.organization_name, "")
    address_line_1    = try(var.registrar_contacts.tech.address_line_1, var.registrar_contacts.default.address_line_1, "")
    address_line_2    = try(var.registrar_contacts.tech.address_line_2, var.registrar_contacts.default.address_line_2, "")
    city              = try(var.registrar_contacts.tech.city, var.registrar_contacts.default.city, "")
    state             = try(var.registrar_contacts.tech.state, var.registrar_contacts.default.state, "")
    zip_code          = try(var.registrar_contacts.tech.zip_code, var.registrar_contacts.default.zip_code, "")
    country_code      = try(var.registrar_contacts.tech.country_code, var.registrar_contacts.default.country_code, "")
    extra_params      = try(var.registrar_contacts.tech.extra_params, var.registrar_contacts.default.extra_params, {})
  }
}
