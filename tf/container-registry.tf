# Реестр контейнеров
resource "yandex_container_registry" "my-registry" {
  name      = "${terraform.workspace}-registry"
  folder_id = var.yandex_folder_id

  labels = {
    my-label = "${terraform.workspace}-my-registry"
  }
}
