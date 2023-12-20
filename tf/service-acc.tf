# Сервисный аккаунт для доступа к K8S
resource "yandex_iam_service_account" "sa-k8s" {
  name        = "${terraform.workspace}-sa-k8s"
  description = "service account for access to k8s"
}
# Сервисному аккаунту назначается роль "k8s.clusters.agent".
resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
  folder_id = "${var.yandex_folder_id}"
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Сервисному аккаунту назначается роль "vpc.publicAdmin".
resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
  folder_id = "${var.yandex_folder_id}"
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Сервисному аккаунту назначается роль "container-registry.images.puller".
resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
  folder_id = "${var.yandex_folder_id}"
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Сервисному аккаунту назначается роль "container-registry.images.pusher".
resource "yandex_resourcemanager_folder_iam_member" "images-pusher" {
  folder_id = "${var.yandex_folder_id}"
  role      = "container-registry.images.pusher"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Ключ для шифрования.
resource "yandex_kms_symmetric_key" "kms-key" {
  name              = "${terraform.workspace}-kms-key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" # 1 год.
}
# Сервисному аккаунту назначается роль "viewer"
resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id = "${var.yandex_folder_id}"
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Сервисному аккаунту назначается роль "editor"
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = "${var.yandex_folder_id}"
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Сервисному аккаунту назначается роль "compute.viewer"
resource "yandex_resourcemanager_folder_iam_member" "compute-viewer" {
  folder_id = "${var.yandex_folder_id}"
  role      = "compute.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}
# Сервисному аккаунту назначается роль "alb.editor"
resource "yandex_resourcemanager_folder_iam_member" "alb-editor" {
  folder_id = "${var.yandex_folder_id}"
  role      = "alb.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-k8s.id}"
}