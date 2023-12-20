variable "name" {
  description = "Имя инстанса"
  type    = string
  default = ""
}

variable "description" {
  description = "Описание инстанса"
  type    = string
  default = ""
}

variable "platform" {
  description = "Платформа на которой создается инстанс"
  type    = string
  default = "standard-v2"
}

variable "update" {
  description = "Флаг для автоматического обновления"
  type    = bool
  default = true
}

variable "cpu_core" {
  description = "Количество ядер"
  type    = number
  default = 2
}

variable "ram" {
  description = "Объем памяти"
  type    = number
  default = 1
}

variable "cpu_load" {
  description = "Базовая производительность для каждого ядра в процентах"
  type    = number
  default = 5
}

variable "interruptible" {
  description = "Флагу установки прерываемости виртуальной машины, актуально для кратковременных инстансов"
  type    = bool
  default = true
}

variable "disk_image" {
  description = "Идентификатор дискового образа"
  type    = string
  default = ""
}

variable "disk_size" {
  description = "Размер диска"
  type    = number
  default = 10
}

variable "user" {
  description = "Имя пользователя"
  type    = string
  default = ""
}

variable "user_key" {
  description = "SSH ключ для доступа к инстансу"
  type    = string
  default = ""
}

variable "subnet" { 
  description = "Идентификатор подсети"
  default = null 
}

variable "security_group" { 
  description = "Идентификатор группы безопасности"
  default = null 
}

variable "ip" {
  description = "IP-адрес"
  type    = string
  default = ""
}

variable "internet" {
  description = "Флаг установки внешнего IP-адреса для инстанса"
  type    = bool
  default = false
}