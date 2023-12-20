# Основная сеть
resource "yandex_vpc_network" "net-master" {
  name = "${terraform.workspace}-network"
}

# Виртуальный роутер
resource "yandex_vpc_route_table" "net-router" {
  name       = "${terraform.workspace}-router"
  network_id = yandex_vpc_network.net-master.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}
# Шлюз для интернета
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "gateway"
  shared_egress_gateway {}
}

# Подсеть основных инстансов: vm-bastion, vm-gitlab
resource "yandex_vpc_subnet" "subnet-main" {
  name           = "${terraform.workspace}-subnet-main"
  v4_cidr_blocks = ["192.168.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.net-master.id
  route_table_id = yandex_vpc_route_table.net-router.id
}
# Подсеть K8S доступная в 3 регионах
resource "yandex_vpc_subnet" "subnet-k8s" {
  for_each = {
    "a" = "192.168.10.0/24"
    "b" = "192.168.20.0/24"
    "c" = "192.168.30.0/24"
  }

  name       = "${terraform.workspace}-subnet-k8s-${each.key}"
  network_id = yandex_vpc_network.net-master.id
  route_table_id = yandex_vpc_route_table.net-router.id

  zone           = "ru-central1-${each.key}"
  v4_cidr_blocks = [each.value]
}
# Группа безопасности основных инстансов
resource "yandex_vpc_security_group" "net-router-sg" {
  name       = "${terraform.workspace}-net-router-sg"
  network_id = yandex_vpc_network.net-master.id

  egress {
    protocol       = "ANY"
    description    = "Доступны все исходящие запросы"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    protocol       = "TCP"
    description    = "22 порт доступен для SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "22"
  }

  ingress {
    protocol       = "UDP"
    description    = "53 порт доступен для DNS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "53"
  }

  ingress {
    protocol       = "TCP"
    description    = "80 порт доступен для HTTP трафика"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "80"
  }

  ingress {
    protocol       = "TCP"
    description    = "443 порт доступен для HTTPS трафика"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "443"
  }

    ingress {
    description    = "GitLab на 4433 порту"
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "4433"
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = "8080"
  }

  ingress {
    protocol       = "ICMP"
    description    = "Разрешены отладочные ICMP-пакеты"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
# Группа безопасности K8S
resource "yandex_vpc_security_group" "k8s-main-sg" {
  name       = "${terraform.workspace}-k8s-main-sg"
  network_id = yandex_vpc_network.net-master.id

   egress {
    protocol       = "ANY"
    description    = "Разрешен весь исходящий трафик."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "TCP"
    description       = "Проверка доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "ANY"
    description    = "Разрешено взаимодействие под-под и сервис-сервис."
    v4_cidr_blocks = ["10.96.0.0/16", "10.112.0.0/16", "192.168.0.0/16"]
    from_port      = 0
    to_port        = 65535
  }
  ingress {
    protocol          = "ANY"
    description       = "Разрешено взаимодействие мастер-узел и узел-узел внутри группы безопасности."
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  
  ingress {
    protocol       = "ICMP"
    description    = "Разрешены отладочные ICMP-пакеты из внутренних подсетей."
    v4_cidr_blocks = ["192.168.0.0/16", "172.16.0.0/12", "10.0.0.0/8"]
  }
}
# Группа безопасности для публичного доступа к сервисам K8S
resource "yandex_vpc_security_group" "k8s-public-services" {
  name       = "${terraform.workspace}-k8s-public-services"
  network_id = yandex_vpc_network.net-master.id

  ingress {
    protocol       = "TCP"
    description    = "Разрешен входящий трафик из интернета на диапазон портов NodePort."
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 30000
    to_port        = 32767
  }
}

# Группа безопасности для публичного доступа к API K8S
resource "yandex_vpc_security_group" "k8s-master-whitelist" {
  name        = "${terraform.workspace}-k8s-master-whitelist"
  description = "Разрешен доступ к API Kubernetes из интернета."
  network_id = yandex_vpc_network.net-master.id

  ingress {
    protocol       = "TCP"
    description    = "Разрешено подключение к API Kubernetes через порт 443."
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
  ingress {
    protocol       = "TCP"
    description    = "Разрешено подключение к API Kubernetes через порт 6443."
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 6443
  }

  
}

