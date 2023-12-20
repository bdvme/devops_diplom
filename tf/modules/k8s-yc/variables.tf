variable "name" {
  description = "Имя конкретного кластера Kubernetes."

  type = string

  default = null
}

variable "description" {
  description = "Описание кластера Kubernetes."

  type = string

  default = null
}

variable "folder_id" {
  description = "Идентификатор папки, к которой принадлежит кластер Kubernetes.."

  type = string
}

variable "labels" {
  description = "Набор пар меток ключ/значение для назначения кластеру Kubernetes.."

  type = map(string)

  default = {}
}

variable "network_id" {
  description = "Идентификатор сети кластера."

  type = string
}

variable "cluster_ipv4_range" {
  description = "Диапазон IP-адресов, из которого будут выделяться IP-адреса для подов для протокола IPv4"

  type = string

  default = null
}

variable "cluster_ipv6_range" {
  description = "Диапазон IP-адресов, из которого будут выделяться IP-адреса для подов для протокола IPv6."

  type = string

  default = null
}

variable "node_ipv4_cidr_mask_size" {
  description = "Размер масок, назначенных каждому узлу в кластере"

  type = number

  default = null
}

variable "service_ipv4_range" {
  description = "Диапазон IP-адресов, из которого будут выделяться IP-адреса для сервисов для протокола IPv4"

  type = string

  default = null
}

variable "service_account_id" {
  description = "Уникальный идентификатор сервисного аккаунта для ресурсов. От его имени будут создаваться ресурсы, необходимые кластеру Managed Service for Kubernetes"

  type = string

  default = null
}

variable "service_account_name" {
  description = "Имя сервисного аккаунта сервисного аккаунта для ресурсов"

  type = string

  default = null
}

variable "node_service_account_id" {
  description = "Уникальный идентификатор сервисного аккаунта для узлов. От его имени узлы будут скачивать из реестра необходимые Docker-образы"

  type = string

  default = null
}

variable "node_service_account_name" {
  description = "Имя сервисного аккаунта для узлов"

  type = string

  default = null
}

variable "release_channel" {
  description = "Релизный канал."

  type = string

  default = "STABLE"
}

variable "network_policy_provider" {
  description = "Контроллер сетевых политик Calico"

  type = string

  default = null
}

variable "kms_provider_key_id" {
  description = "Идентификатор ключа шифрования."

  default = null
}

variable "master_version" {
  description = "Версия Kubernetes."

  type = string

  default = null
}

variable "master_public_ip" {
  description = "Флаг, который указывает, если кластеру Managed Service for Kubernetes требуется публичный IP-адрес."

  type = bool

  default = true
}

variable "master_security_group_ids" {
  description = "Список идентификаторов групп безопасности кластера Kubernetes"

  type = set(string)

  default = null
}

variable "master_region" {
  description = "Имя региона, в котором будет создан кластер."

  type = string

  default = null
}

variable "master_locations" {
  description = "Зоны доступности кластера"

  type = list(object({
    zone      = string
    subnet_id = string
  }))
}

variable "master_auto_upgrade" {
  description = "Флаг установки автоматического обновления, устанавливается без участия пользователя в заданный промежуток времени"

  type = bool

  default = true
}

variable "master_maintenance_windows" {
  description = "Список структур, определяющих окна обслуживания, когда разрешено автоматическое обновление для мастера"

  type = list(map(string))

  default = []
}

variable "node_groups" {
  description = "Параметры групп узлов Kubernetes."

  default = {}
}

variable "node_groups_default_ssh_keys" {
  description = "SSH ключи для установки на всех узлах Kubernetes по умолчанию."

  type = map(list(string))

  default = {}
}

variable "node_groups_default_locations" {
  description = "Зона для размещения группы узлов по умолчанию."

  type = list(object({
    subnet_id = string
    zone      = string
  }))

  default = null
}

variable "node_groups_locations" {
  description = "Зоны для размещения группы узлов, переопределяет зону по умолчанию"

  type = map(list(object({
    subnet_id = string
    zone      = string
  })))

  default = {}
}