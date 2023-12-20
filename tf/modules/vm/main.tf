terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
resource "yandex_compute_instance" "vm" {
  description = var.description
  name        = var.name
  platform_id = var.platform
  allow_stopping_for_update = var.update

  resources {
    cores         = var.cpu_core
    core_fraction = var.cpu_load
    memory        = var.ram
  }

  boot_disk {
    device_name = var.user
    initialize_params {
      image_id  = var.disk_image
      size      = var.disk_size
      type      = "network-hdd"
    }
  }

  zone = var.subnet.zone
  network_interface {
    ip_address = var.ip
    subnet_id  = var.subnet.id
    nat        = var.internet
    security_group_ids = var.security_group
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.user_key}")}"
  }

  scheduling_policy {
    preemptible = var.interruptible
  }
}