resource "yandex_dns_zone" "zone1" {
  name   = replace(var.dns_domain, ".", "-")
  zone   = join("", [terraform.workspace, "." , var.dns_domain, "."])
  public = true
}
# Wildcard DNS запись
resource "yandex_dns_recordset" "rs-aname-1" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "*"
  type    = "A"
  ttl     = 200
  data    = ["${element(module.vm-bastion.external_ip,0)}"]
}