# Виртуальная машина Бастион
module "vm-bastion" {
  source          = "./modules/vm" # Расположение исходных кодов модуля 

  name            = "${terraform.workspace}-bastion" # Имя инстанса
  description     = "Bastion" # Описание инстанса
  
  # Метаданные для авторизации
  user            = "${var.vm_bastion_user_name}" # Имя пользователя
  user_key        = "${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_bastion_key}.pub" # SSH-ключ доступа
  
  cpu_core        = 2 # 2 ядра
  ram             = 2 # 2Гб RAM
  cpu_load        = 5 # Производительность установим в 5% для каждого ядра
  
  internet        = true # Внешний IP
  interruptible   = false # Не прерываемая
  update          = true # Автоматическое обновление

  ip              = "${var.vm_bastion_internal_ip}" # Установка внутреннего IP-адреса
  subnet          = yandex_vpc_subnet.subnet-main # Установка идентификатора подсети
  security_group  = [yandex_vpc_security_group.net-router-sg.id] # Установка идентификатора группы безопасности

  disk_image      = "${var.yandex_nat_image_id}" # Установка идентификатора дискового образа
  disk_size       = 8 # Размер диска в Гб
}

# Виртуальная машина GitLab + GitLab-Runner
module "vm-gitlab" {
  source          = "./modules/vm" # Расположение исходных кодов модуля 

  name            = "${terraform.workspace}-vm-gitlab" # Имя инстанса
  description     = "GitLab + GitLab-Runner" # Описание инстанса
  
  # Метаданные для авторизации
  user            = "${var.vm_gitlab_user_name}" # Имя пользователя
  user_key        = "${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_key}.pub" # SSH-ключ доступа
  
  cpu_core        = 4 # 4 ядра
  ram             = 8 # 8Гб RAM
  cpu_load        = 20 # Производительность установим в 20% для каждого ядра

  update          = true # Автоматическое обновление
  interruptible   = false # Не прерываемая

  ip              = "${var.vm_gitlab_internal_ip}" # Установка внутреннего IP-адреса
  subnet          = yandex_vpc_subnet.subnet-main  #Установка идентификатора подсети

  disk_image      = "${var.yandex_image_id}" # Установка идентификатора дискового образа
  disk_size       = 64 # Размер диска в Гб
}
# Кластер Kubernetes
module "k8s" {
  source = "./modules/k8s-yc" # Расположение исходных кодов модуля 

  name       = "${terraform.workspace}-regional-cluster" # Имя инстанса
  folder_id  = "${var.yandex_folder_id}" # Идентификатор папки yandex.cloud
  network_id = yandex_vpc_network.net-master.id #Идентификатор сети кластера
  cluster_ipv4_range = "10.96.0.0/16" #Диапазон IP-адресов для подов
  service_ipv4_range = "10.112.0.0/16" #Диапазон IP-адресов для сервисов
  master_public_ip = true # Устанавливаем публичный IP
  master_version = local.k8s_version # Версия K8S
  master_region = "ru-central1" # Имя региона
  master_security_group_ids = [ # Список групп безопасности
    yandex_vpc_security_group.k8s-main-sg.id,
    yandex_vpc_security_group.k8s-master-whitelist.id
  ]
  # Зона доступности кластера
  master_locations = [for subnet in yandex_vpc_subnet.subnet-k8s : { 
    subnet_id = subnet.id
    zone      = subnet.zone
  }]
  # Установка зависимостей
  depends_on = [ 
    yandex_resourcemanager_folder_iam_member.k8s-clusters-agent,
    yandex_resourcemanager_folder_iam_member.vpc-public-admin,
    yandex_resourcemanager_folder_iam_member.images-puller,
    yandex_resourcemanager_folder_iam_member.images-pusher,
    yandex_resourcemanager_folder_iam_member.editor,
    yandex_resourcemanager_folder_iam_member.viewer,
    yandex_resourcemanager_folder_iam_member.compute-viewer,
    yandex_resourcemanager_folder_iam_member.alb-editor
  ]

  kms_provider_key_id = yandex_kms_symmetric_key.kms-key.id # Идентификатор KMS ключа
  service_account_id = yandex_iam_service_account.sa-k8s.id # Идентификатор сервисного аккаунта
  node_service_account_id = yandex_iam_service_account.sa-k8s.id # Идентификатор сервисного аккаунта для групп узлов
  # параметры для группы узлов
  node_groups = {
    k8s-node = {
      # определяем группу узлов фиксированного размера
      fixed_scale = {
        size = 3
      }
      platform_id     = "standard-v2" # устанавливаем платформу для узла
      
      cores           = 2 # 2 ядра процессора
      core_fraction   = 20 # Производительность для каждого ядра 20%
      memory          = 2 # 2Гб RAM
      boot_disk_type  = "network-hdd" # Тип диска
      boot_disk_size  = 30 # Размер диска в Гб
      security_group_ids = [ # Список групп безопасности
        yandex_vpc_security_group.k8s-main-sg.id,
        yandex_vpc_security_group.k8s-public-services.id
      ]
      # Метаданные для авторизации
      metadata = {
        user-data = "#cloud-config\nusers:\n  - name: ${var.vm_k8s_user_name}\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh-authorized-keys:\n      - ${file("${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_k8s_key}.pub")}"
      }
    }
  }
}
