locals {
  k8s_version = "1.27"
}

variable "yandex_cloud_id" {
  default = "yandex_cloud_id"
}

variable "yandex_folder_id" {
  default = "yandex_folder_id"
}

variable "yandex_image_id" {
  default = "yandex_image_id"
}

variable "yandex_nat_image_id" {
  default = "yandex_nat_image_id"
}

variable "yandex_zone" {
  default = "yandex_zone"
}

variable "yandex_s3_bucket" {
  default = "yandex_s3_bucket"
}

variable "vm_bastion_user_name" {
  default = "vm_bastion_user_name"
}
variable "vm_gitlab_user_name" {
  default = "vm_gitlab_user_name"
}          
   
variable "vm_k8s_user_name" {
  default = "vm_k8s_user_name"
}            
variable "vm_bastion_internal_ip" {
  default = "vm_bastion_internal_ip"
}      
variable "vm_gitlab_internal_ip" {
  default = "vm_gitlab_internal_ip"
}      
variable "ssh_vm_bastion_key" {
  default = "ssh_vm_bastion_key"
}     
variable "ssh_vm_key" {
  default = "ssh_vm_key"
}             
variable "ssh_vm_k8s_key" {
  default = "ssh_vm_k8s_key"
}         

variable "ssh_path" {
  default = "ssh_path"
}

variable "index_html" {
  default = "index_html"
}

variable "picture" {
  default = "picture"  
}

variable "dns_domain" {
  default = "dns_domain"  
}
variable "ansible_inventory_path" {
  default = "ansible_inventory_path"
}     

variable "ansible_inventory_filename" {
  default = "ansible_inventory_filename"
}