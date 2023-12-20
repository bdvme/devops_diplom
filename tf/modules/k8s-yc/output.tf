output "external_v4_endpoint" {
  value = yandex_kubernetes_cluster.cluster.master[0].external_v4_endpoint
}

output "internal_v4_endpoint" {
  value = yandex_kubernetes_cluster.cluster.master[0].internal_v4_endpoint
}

output "cluster_ca_certificate" {
  value = yandex_kubernetes_cluster.cluster.master[0].cluster_ca_certificate
}

output "cluster_id" {
  value = yandex_kubernetes_cluster.cluster.id
}

output "node_groups" {
  value = yandex_kubernetes_node_group.node_groups
}

output "service_account_id" {
  value = var.service_account_id
}

output "node_service_account_id" {
  value = var.node_service_account_id
}