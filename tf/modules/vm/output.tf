output "internal_ip" {
  value = "${try(yandex_compute_instance.vm.*.network_interface.0.ip_address, null)}"
}

output "external_ip" {
  value = "${try(yandex_compute_instance.vm.*.network_interface.0.nat_ip_address, null)}"
}