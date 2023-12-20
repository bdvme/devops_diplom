# Доступные провайдеры
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
# Установки для бэкенда
  
  backend "s3" {
    endpoint    = "storage.yandexcloud.net"
    bucket      = "${var.yandex_s3_bucket}"
    region      = "ru-central1"
    key         = "tf/state.tfstate"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}
# Данные провайдера
provider "yandex" {
  service_account_key_file = "./key/${terraform.workspace}/key_admin.json" # Ключ для авторизации
  cloud_id  = "${var.yandex_cloud_id}" # Идентификатор Yandex.Cloud
  folder_id = "${var.yandex_folder_id}" # Идентификатор папки
}