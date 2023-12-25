*Студент: Дмитрий Багрянский*

# Дипломный практикум в Yandex.Cloud

*Задание доступно по [ссылке](https://github.com/netology-code/devops-diplom-yandexcloud/blob/main/README.md)*

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:

### Структура проекта

<details>
<summary>tree</summary>

```bash
tree
.
├── Makefile
├── README.md
├── ansible
│   ├── ansible.cfg
│   ├── ansible.mk
│   ├── gitlab_set_settings.yml
│   ├── group_vars
│   │   └── all
│   │       └── variable.yml
│   ├── k8s_delete_app.yml
│   ├── monitoring.yml
│   ├── provision.yml
│   └── roles
│       ├── add_user
│       │   └── tasks
│       │       └── main.yml
│       ├── check_dns
│       │   └── tasks
│       │       └── main.yml
│       ├── copy_kubeconf
│       │   └── tasks
│       │       └── main.yml
│       ├── docker
│       │   └── tasks
│       │       └── main.yml
│       ├── docker_compose
│       │   └── tasks
│       │       └── main.yml
│       ├── get_pwd
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_cicd_vars
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_project_access_token
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_project_branches
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_project_files
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_project_hook
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_protect_repo_branches
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_add_user
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_allow_local_webhook
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_create_personal_access_token
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_create_project
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_get_project_id
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_get_user_id
│       │   └── tasks
│       │       └── main.yml
│       ├── gitlab_prepare_project_files
│       │   └── tasks
│       │       └── main.yml
│       ├── health_check
│       │   └── tasks
│       │       └── main.yml
│       ├── k8s
│       │   └── tasks
│       │       └── main.yml
│       ├── k8s_apply
│       │   └── tasks
│       │       └── main.yml
│       ├── k8s_atlantis
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── templates
│       │       └── atlantis.j2
│       ├── k8s_atlantis_deployment_template
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── templates
│       │       └── atlantis-deployment.j2
│       ├── k8s_delete
│       │   └── tasks
│       │       └── main.yml
│       ├── k8s_get_node_ip
│       │   └── tasks
│       │       └── main.yml
│       ├── k8s_gitlab_credentials
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── templates
│       │       └── registry-credentials.j2
│       ├── k8s_monitoring
│       │   └── tasks
│       │       └── main.yml
│       ├── ssh-keys
│       │   └── tasks
│       │       └── main.yml
│       ├── sync
│       │   ├── files
│       │   │   └── stack
│       │   │       ├── etc
│       │   │       │   └── hosts
│       │   │       └── opt
│       │   │           ├── caddy
│       │   │           │   ├── config
│       │   │           │   └── docker-compose.yml
│       │   │           └── gitlab
│       │   │               ├── config
│       │   │               │   └── ssl
│       │   │               └── runner
│       │   │                   ├── Dockerfile
│       │   │                   ├── config
│       │   │                   │   └── config.toml
│       │   │                   └── config.json
│       │   └── tasks
│       │       └── main.yml
│       ├── templates
│       │   ├── tasks
│       │   │   └── main.yml
│       │   └── templates
│       │       ├── Caddyfile.j2
│       │       ├── gitlab.j2
│       │       ├── hosts.j2
│       │       └── runner.j2
│       ├── tools
│       │   └── tasks
│       │       └── main.yml
│       ├── wait_hosts
│       │   └── tasks
│       │       └── main.yml
│       └── wait_url
│           └── tasks
│               └── main.yml
├── app
│   └── demo-project
│       ├── README.md
│       ├── changelog
│       │   └── 1.0.0.md
│       ├── k8s.yml
│       ├── src
│       │   ├── Dockerfile
│       │   ├── index.html
│       │   └── water.jpg
│       └── version.json
├── k8s
│   ├── k8s.mk
│   ├── monitoring
│   │   ├── grafana.yaml
│   │   └── trickster.yaml
│   └── sa.yml
└── tf
    ├── cloud-dns.tf
    ├── container-registry.tf
    ├── instance.tf
    ├── main.tf
    ├── modules
    │   ├── k8s-yc
    │   │   ├── main.tf
    │   │   ├── output.tf
    │   │   └── variables.tf
    │   └── vm
    │       ├── main.tf
    │       ├── output.tf
    │       └── variables.tf
    ├── network.tf
    ├── output.tf
    ├── service-acc.tf
    ├── terraform.mk
    └── variables.tf
```

</details>

Проект состоит из следующих модулей:

- [`ansible`](#ansible) - каталог с манифестами для внутренней настройки инстансов облачной инфраструктуры;
- [`app`](#app) - каталог с демонстрационным приложением вывода статической HTML страницы;
- [`k8s`](#k8s) - каталог с манифестами для деплоя сервисов мониторинга в K8s кластер;
- [`tf`](#tf) - каталог с облачной инфраструктурой в Yandex.Cloud;
- [`.env`](#env) - файл с переменными окружения
- [`Makefile`](#makefile) - основной файл сборки проекта

### Остановимся подробнее на каждом модуле:
---

#### `ansible`

В каталоге Ansible, находятся 4 плейбука для настройки инстансов облачной инфраструктуры Yandex.Cloud:

<details>
<summary>provision.yml - основной плейбук, запускается после создания облачной инфрастуктуры</summary>

```yaml
---
  - hosts: localhost
    become: false
    gather_facts: false
    roles:
      - { role: k8s }

  - hosts: infra
    become: yes
    become_user: root
    gather_facts: false
    roles:
      - { role: wait_hosts }
      - { role: check_dns }
      - { role: ssh-keys }
      - { role: tools, vars: { tools_packages: ["python3",
                                                "python3-pip",
                                                "python3-setuptools",
                                                "openssl",
                                                "curl",
                                                "git",
                                                "software-properties-common",
                                                "sshpass",
                                                "wget",
                                                "curl",
                                                "unzip",
                                                "gnupg",
                                                "ansible",
                                                "ansible-lint",
                                                "mc",
                                                "net-tools",
                                                "jq",
                                                "snapd"
                                                ] } }
      - { role: docker }
      - { role: templates, vars: { target: "/etc/hosts", tmpl: "hosts.j2"} }
      - { role: copy_kubeconf }

  - hosts: vm-bastion
    become: yes
    become_user: root
    gather_facts: false
    roles:
      - { role: sync, vars: { target: "caddy" }}
      - { role: k8s_get_node_ip }
      - { role: templates, vars: { target: "/opt/caddy/config/Caddyfile", tmpl: "Caddyfile.j2"} }
      - { role: docker_compose, vars: { description: "Install caddy", folder: "caddy", command: "pull"} }
      - { role: docker_compose, vars: { description: "Install caddy", folder: "caddy", command: "down --remove-orphans"} }
      - { role: docker_compose, vars: { description: "Install caddy", folder: "caddy", command: "up -d --remove-orphans"} }

  - hosts: vm-gitlab
    become: yes
    become_user: root
    gather_facts: false
    roles:
      - { role: sync, vars: { target: "gitlab" } }
      - { role: templates, vars: { target: "/opt/gitlab/docker-compose.yml", tmpl: "gitlab.j2"} }
      - { role: templates, vars: { target: "/opt/gitlab/runner/docker-compose.yml", tmpl: "runner.j2"} }
      - { role: add_user, vars: { user: "gitlab-runner", group: "docker" } }
      - { role: docker_compose, vars: { description: "Install Gitlab", folder: "gitlab", command: "pull"}, tags: "" }
      - { role: docker_compose, vars: { description: "Install gitlab-runner", folder: "gitlab/runner", command: "pull" }, tags: "" }
      - { role: docker_compose, vars: { description: "Install gitlab-runner", folder: "gitlab/runner", command: "down --remove-orphans" }, tags: "" }
      - { role: docker_compose, vars: { description: "Install Gitlab", folder: "gitlab", command: "down --remove-orphans"} }
      - { role: docker_compose, vars: { description: "Install Gitlab", folder: "gitlab", command: "up -d --remove-orphans"} }
      - { role: health_check, vars: { container: "gitlab", status: "healthy" } }
      - { role: get_pwd, tags: "" }  
      - { role: docker_compose, vars: { description: "Install gitlab-runner", folder: "gitlab/runner", command: "build" }, tags: "" }
      - { role: docker_compose, vars: { description: "Install gitlab-runner", folder: "gitlab/runner", command: "up -d --remove-orphans" }, tags: "" }
```

</details>

<details>
<summary>gitlab_set_settings.yml - плейбук настройки Gitlab через REST API</summary>

```yaml
---
  - hosts: vm-gitlab
    become: yes
    become_user: root
    gather_facts: true
    roles:      
      - { role: k8s_gitlab_credentials, vars: { target: "../k8s/{{ tf_workspace }}/registry-credentials.yml", tmpl: "registry-credentials.j2"} }
      - { role: gitlab_allow_local_webhook }
      - { role: gitlab_add_user }
      - { role: gitlab_get_user_id, vars: { target: "bdvme" } }
      - { role: gitlab_create_personal_access_token, vars: { target: 'bdvme' } }
# Create all projects    
      - { role: gitlab_create_project, vars: { target: 'bdvme' }  } #Create all projects
# Set settings for project: demo-project
      - { role: gitlab_get_project_id, vars: { user_name: 'bdvme', target: "demo-project" } }
      - { role: gitlab_add_project_access_token, vars: { user_name: 'bdvme', target: "demo-project" } }
      - { role: gitlab_add_cicd_vars, vars: { user_name: 'bdvme', target: "demo-project" } }
      - { role: gitlab_add_project_branches, vars: { user_name: 'bdvme', target: "demo-project" } }
      - { role: gitlab_add_protect_repo_branches, vars: { user_name: 'bdvme', target: "demo-project" } }
      - { role: gitlab_add_project_files, vars: { user_name: 'bdvme', path: '../app', target: "demo-project" } }
# Set settings for project: tf-infra-project
      - { role: gitlab_get_project_id, vars: { user_name: 'bdvme', target: "tf-infra" } }
      - { role: gitlab_add_project_access_token, vars: { user_name: 'bdvme', target: "tf-infra" } }
      - { role: gitlab_add_cicd_vars, vars: { user_name: 'bdvme', target: "tf-infra" } }
      - { role: gitlab_add_project_branches, vars: { user_name: 'bdvme', target: "tf-infra" } }
      - { role: gitlab_add_protect_repo_branches, vars: { user_name: 'bdvme', target: "tf-infra" } }
      - { role: k8s_atlantis, vars: { user_name: 'bdvme', target: "../tf-infra/atlantis.yaml", tmpl: "atlantis.j2"}}
      - { role: gitlab_prepare_project_files, vars: { source: 'tf', path: '../', target: "tf-infra" }}
      - { role: gitlab_prepare_project_files, vars: { source: 'ssh_key', path: '../', target: "tf-infra" }}
      - { role: gitlab_add_project_files, vars: { user_name: 'bdvme', path: '../', target: "tf-infra" } }
# Add webhook for atlantis      
      - { role: gitlab_add_project_hook, vars: { user_name: 'bdvme', target: "tf-infra" } }
# K8S create atlantis-deployment.yaml from template file
      - { role: k8s_atlantis_deployment_template, vars: { user_name: 'bdvme', target: "../k8s/atlantis/{{ tf_workspace }}/atlantis-deployment.yaml", tmpl: "atlantis-deployment.j2"} }
      - { role: k8s_apply, vars: { manifest: "atlantis/{{ tf_workspace }}/atlantis-deployment.yaml" } }
      - { role: wait_url, vars: { url: "{{ app_server_url }}"} }
      - { role: wait_url, vars: { url: "{{ atlantis_url }}"} }
```

</details>

<details>
<summary>monitoring.yml - плейбук деплоя сервиса мониторинга в кластер K8s</summary>

```yaml
---
  - hosts: localhost
    become: no
    gather_facts: true
    roles:
      - { role: k8s_monitoring }
```

</details>

<details>
<summary>k8s_delete_app.yml - плейбук для удаления установленных приложений в кластер K8s</summary>

```yaml
---
  - hosts: localhost
    become: no
    gather_facts: true
    roles:
      - { role: k8s_delete, vars: { namespaces: "atlantis-ns" } }
      - { role: k8s_delete, vars: { namespaces: "monitoring" } }
      - { role: k8s_delete, vars: { namespaces: "demo-app" } }
```

</details>
<br>

Так же в корне каталога Ansible, создается, средствами Terraform, файл `inventory` с IP адресами инстансов облачной инфраструктуры, идентификатором реестра контейнеров и т.д.

Шаблон создания: [output.tf](./tf/output.tf)

<details>
<summary>output.tf</summary>

```bash
output "external_ip" {
  value = "${try(module.vm-bastion.external_ip, null)}"
}
# Создание файла inventory для Ansible средствами Terraform
resource "local_file" "inventory" {
  content = <<-DOC
# Ansible inventory containing variable values from Terraform.
# Generated by Terraform.

---
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ansible_playbook_python}}"
    vm-bastion:
      ansible_host: "${element(module.vm-bastion.external_ip,0)}"
      ansible_port: "22"
      ansible_user: "${var.vm_bastion_user_name}"
      ansible_ssh_private_key_file: "${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_bastion_key}"
      ansible_ssh_common_args: ""
    vm-gitlab:
      ansible_host: "${element(module.vm-gitlab.internal_ip,0)}"
      ansible_port: 22
      ansible_user: "${var.vm_gitlab_user_name}"
    k8s-cluster:
      external_v4_endpoint: "${module.k8s.external_v4_endpoint}"
      internal_v4_endpoint: "${module.k8s.internal_v4_endpoint}"
      cluster_id: "${module.k8s.cluster_id}"
      service_account_id: "${module.k8s.service_account_id}"
      node_service_account_id: "${module.k8s.node_service_account_id}"
      container_registry_id: "${yandex_container_registry.my-registry.id}"
  vars:
    ansible_ssh_private_key_file: "${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_key}"
    ansible_ssh_common_args: >-
      -o ProxyCommand="ssh -p 22 -W %h:%p -q
      -i ${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_bastion_key} ${var.vm_bastion_user_name}@${element(module.vm-bastion.external_ip,0)}"
  children:
    infra:
      hosts:
        vm-bastion:
        vm-gitlab:
    gitlab:
      hosts:
        vm-gitlab:
    bastion:
      hosts:
        vm-bastion:
    DOC
  filename = join("", [var.ansible_inventory_path, "/", terraform.workspace, "-", var.ansible_inventory_filename])
  depends_on = [
    module.vm-bastion,
    module.vm-gitlab,
    module.k8s
  ]
}
```

</details>
<br>

Так же в корне каталога Ansible находятся два каталога:

- `group_vars` - с файлом переменных проекта;
- `roles` - с ролями, которые используют плейбуки.

В файле переменных [variable.yml](./ansible/group_vars/all/variable.yml), помимо переменных содержащих названия серверов, имен пользователей и т.п., содержится структура `gitlab_config`, некоторое содержимое которой (токены доступа), формируется динамически, а статические данные используются при настройке Gitlab сервера.

<details>
<summary>variable.yml</summary>


```yaml
gitlab_server: "gitlab.{{ tf_workspace }}.bdvsun.ru"
registry_server: "cr.yandex" # "registry.bdvsun.ru"

grafana_server: "grafana.{{ tf_workspace }}.bdvsun.ru"
app_server: "app.{{ tf_workspace }}.bdvsun.ru"
atlantis_server: "atlantis.{{ tf_workspace }}.bdvsun.ru"

gitlab_registry: "registry.{{ tf_workspace }}.bdvsun.ru"
gitlab_registry_http: "http://{{ gitlab_registry }}"
gitlab_url: "{{ gitlab_server }}"
atlantis_url: "http://{{ atlantis_server }}"
atlantis_webhook_secret: "atlantis-webhook-secret"
app_server_url: "http://{{ app_server }}"
gitlab_url_http: "http://{{ gitlab_server }}"
gitlab_runner_token: "GR1348941fTT5LwMxtsydjJQ5KBJY"
gitlab_extra_hosts: "192.168.1.11"

cluster_id: ""
sa_token: ""
user_id: ""
project_id: ""
api_token: ""
user_api_token: ""
master_endpoint_int: ""
master_endpoint_ext: ""
project_access_token: ""
dockerconfigjson: ""

k8s_internal_ip_node_1: ""
k8s_internal_ip_node_2: ""
k8s_internal_ip_node_3: ""

#Variables for GitLab REST API
gitlab_config:
  api_url: "http://{{ gitlab_server }}:4433/api/v4"
  api_token: "{{ api_token }}"
  allow_local_requests_from_web_hooks_and_services: "true"
  ## users
  users:
    - name: "Dmitry Bagryanskiy"
      username: "bdvme"
      password: "1Q2W3E_qazwsxedc"
      reset_password: "False"
      email: "bdvsun@bdvsun.ru"
      skip_confirmation: "True"
      user_id: "{{ user_id }}"
      user_api_token: "{{ user_api_token }}"
      personal_token:
        - name: "ACCESS_TOKEN"
          scopes: ["api", "read_api", "read_user", "write_repository"]
          expires_at: ""
  projects:
    - name: "demo-project"
      description: "Demo project"  
      initialize_with_readme: "False"
      project_id: "{{ project_id }}"
      cicd:
        - key: "CI_REGISTRY"
          value: "{{ registry_server }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "False"
          raw: "True"
          description: "null"
        - key: "CI_REGISTRY_ID"
          value: "{{ hostvars['k8s-cluster'].container_registry_id }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "False"
          raw: "True"
          description: "null"
        - key: "KEY_JSON"
          value: "\n{{lookup('ansible.builtin.file', '../k8s/{{ tf_workspace }}/key.json')}}\n"
          environments: "*"
          type: "file"
          protected: "True"
          masked: "False"
          raw: "False"
          description: "null"
        - key: "CA_PEM"
          value: "{{lookup('ansible.builtin.file', '../k8s/{{ tf_workspace }}/ca.pem')}}"
          environments: "*"
          type: "file"
          protected: "True"
          masked: "False"
          raw: "False"
          description: "null"
        - key: "KUBE_INT_URL"
          value: "{{ hostvars['k8s-cluster'].internal_v4_endpoint }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "False"
          raw: "False"
          description: "null"
        - key: "KUBE_TOKEN"
          value: "{{ sa_token }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "True"
          raw: "False"
          description: "null"
        - key: "ACCESS_TOKEN"
          value: "{{ project_access_token }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "True"
          raw: "False"
          description: "null"
      branches_protect:
        - name: "develop/*"
          push_access_level: "30"
          merge_access_level: "30"
          unprotect_access_level: "40"
          allow_force_push: "False"
        - name: "feature/*"
          push_access_level: "40"
          merge_access_level: "40"
          unprotect_access_level: "40"
          allow_force_push: "False"
      branches_project:
        - branch: "feature/build"
          ref: "main"
        - branch: "feature/deploy"
          ref: "main"
        - branch: "feature/release"
          ref: "main"
      project_token:
        - name: "ACCESS_TOKEN"
          scopes: ["api", "write_repository"]
          expires_at: ""
          access_level: 40
      hooks:
        - id: "{{ project_id }}"
          url: ""
          push_events: "true"
          merge_requests_events: "true"
          enable_ssl_verification: "false"
          note_events: "true"
          token: ""
    - name: "tf-infra"
      description: "Terraform infrastructure for atlantis"  
      initialize_with_readme: "False"
      project_id: "{{ project_id }}"
      branches_protect:
        - name: "develop/*"
          push_access_level: "30"
          merge_access_level: "30"
          unprotect_access_level: "40"
          allow_force_push: "False"
        - name: "feature/*"
          push_access_level: "40"
          merge_access_level: "40"
          unprotect_access_level: "40"
          allow_force_push: "False"
      branches_project:
        - branch: "feature/build"
          ref: "main"
        - branch: "feature/deploy"
          ref: "main"
        - branch: "feature/release"
          ref: "main"
      project_token:
        - name: "ACCESS_TOKEN"
          scopes: ["api", "write_repository"]
          expires_at: ""
          access_level: 40
      cicd:
        - key: "CI_REGISTRY"
          value: "{{ registry_server }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "False"
          raw: "True"
          description: "null"
        - key: "CI_REGISTRY_ID"
          value: "{{ hostvars['k8s-cluster'].container_registry_id }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "False"
          raw: "True"
          description: "null"
        - key: "KEY_JSON"
          value: "\n{{lookup('ansible.builtin.file', '../k8s/{{ tf_workspace }}/key.json')}}\n"
          environments: "*"
          type: "file"
          protected: "True"
          masked: "False"
          raw: "False"
          description: "null"
        - key: "CA_PEM"
          value: "{{lookup('ansible.builtin.file', '../k8s/{{ tf_workspace }}/ca.pem')}}"
          environments: "*"
          type: "file"
          protected: "True"
          masked: "False"
          raw: "False"
          description: "null"
        - key: "KUBE_INT_URL"
          value: "{{ hostvars['k8s-cluster'].internal_v4_endpoint }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "False"
          raw: "False"
          description: "null"
        - key: "KUBE_TOKEN"
          value: "{{ sa_token }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "True"
          raw: "False"
          description: "null"
        - key: "ACCESS_TOKEN"
          value: "{{ project_access_token }}"
          environments: "*"
          type: "env_var"
          protected: "True"
          masked: "True"
          raw: "False"
          description: "null"
      hooks:
        - id: "{{ project_id }}"
          url: "{{ atlantis_url }}/events"
          push_events: "true"
          merge_requests_events: "true"
          enable_ssl_verification: "false"
          note_events: "true"
          token: "{{ atlantis_webhook_secret }}"
```

</details>
<br>

Плейбуки `Ansible` написаны с использованием ролей, описанных в каталоге `roles`.

##### `roles`

<details>
<summary>add_user - роль для добавления пользователя</summary>

```yaml
---
  - name: Add user {{ user }} and make access to {{ group }} group
    user:
      name: "{{ user }}"
      shell: /bin/bash
      groups: "{{ group }}"
      append: yes
```

</details>

<details>
<summary>check_dns - роль проверки работы DNS</summary>

```yaml
---
  - name: Checking DNS
    command: host -t A google.com
```

</details>



<details>
<summary>copy_kubeconf - роль копирования конфигурационного файла k8s - kubeconf на хосты</summary>

```yaml
---
  - name: Create k8s directory
    file:
      path: /opt/k8s
      state: directory

  - name: Create workspace directory
    file:
      path: "/opt/k8s/{{ tf_workspace }}"
      state: directory

  - name: Copy static kubeconfig
    copy:
      src: "../k8s/{{ tf_workspace }}/kubeconfig-int"
      dest: "/opt/k8s/{{ tf_workspace }}/kubeconfig-int"
      owner: root
      group: root
      mode: 0644

  - name: Copy token ca.pem
    copy:
      src: "../k8s/{{ tf_workspace }}/ca.pem"
      dest: "/opt/k8s/{{ tf_workspace }}/ca.pem"
      owner: root
      group: root
      mode: 0644

  - name: Install kubectl
    shell: >
      cd /opt/k8s &&
      curl -LO https://dl.k8s.io/release/`curl -LS https://dl.k8s.io/release/stable.txt`/bin/linux/amd64/kubectl &&
      chmod +x ./kubectl &&
      mv ./kubectl /usr/local/bin/kubectl &&
      kubectl config use-context default --kubeconfig=/opt/k8s/{{ tf_workspace }}/kubeconfig-int &&
      kubectl version --client      
    register: reg

  - debug: var=reg.stdout

  - name: Get cluster info
    shell:
      kubectl cluster-info --kubeconfig=/opt/k8s/{{ tf_workspace }}/kubeconfig-int
    register: reg

  - debug: var=reg.stdout
```

</details>



<details>
<summary>docker - роль для настройки docker</summary>

```yaml
---
  - block:
      - name: Installing docker
        shell: |
          curl -fsSL get.docker.com -o get-docker.sh
          chmod +x get-docker.sh
          ./get-docker.sh
    rescue:
      - name: Installing docker
        apt:
          package: "docker"
          state: present
          update_cache: yes

  - name: Add the current user to docker group
    user: name=vagrant append=yes groups=docker

  - name: Install docker-compose
    apt:
      package: "docker-compose"
      state: present
      update_cache: yes

  - name: Install docker.py
    pip:
      name: docker
      state: present

  - name: Start docker service
    service:
      name: docker
      state: restarted
      enabled: yes
```

</details>



<details>
<summary>docker_compose - роль запуска docker-compose.yml файла</summary>

```yaml
---
  - name: "{{ description }}: Run docker-compose command {{ command }}"
    command: docker-compose -f /opt/{{ folder }}/docker-compose.yml {{ command }}
    timeout: 3600
```

</details>



<details>
<summary>get_pwd - роль выводящаяя в терминальное окно `root` пароль от Gitlab</summary>

```yaml
---
  - name: Get gitlab root password
    shell: "cat /opt/gitlab/config/initial_root_password | grep Password:"
    register: pwd
    ignore_errors: true
    changed_when: false

  - name: Print root password
    debug:
      msg: "{{ pwd.stdout }}"
    when: pwd.rc == 0
```

</details>



<details>
<summary>gitlab_add_cicd_vars - роль добавляющая в Gitlab переменные использующиеся в CI/CD</summary>

```yaml
---
  - name: Install yq tools
    shell:
      snap install yq

  - name: Get service account token from file_get_contents
    shell: |
      cat /opt/k8s/{{ tf_workspace }}/kubeconfig-int | yq e '.users[] | select(.name == "admin-user").user["token"]'
    register: reg

  - name: Set service account token to variable
    set_fact:
      sa_token: "{{ reg.stdout }}"

  - name: Create Gitlab CI/CD variables
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/projects/{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='project_id') | join(' ') }}/variables"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}"
        Content-Type: application/json
      body:
        key: "{{ item.key }}"
        variable_type: "{{ item.type }}"
        value: "{{ item.value }}"
        protected: "{{ item.protected }}"
        masked: "{{ item.masked }}"
        raw: "{{ item.raw }}"
        environment_scope: "{{ item.environments }}"
        description: "{{ item.description }}"
    with_items: "{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='cicd') }}"
    no_log: false
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_add_project_access_token - роль добавляющая токен доступа Gitlab для проекта</summary>

```yaml
---
  - name: Create Gitlab project access token
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/projects/{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='project_id') | join(' ') }}/access_tokens"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}"
        Content-Type: application/json
      body:
        name: "{{ item.name }}"
        scopes: "{{ item.scopes }}"
        expires_at: "{{ item.expires_at }}"
        access_level: "{{ item.access_level }}"   
    with_items: "{{ gitlab_config.projects | selectattr('name','equalto', target) | map(attribute='project_token') }}"
    no_log: false
    ignore_errors: true
    changed_when: false
    register: reg

  - name: Set Gitlab project access token to variable
    set_fact:
      project_access_token: "{{ reg.results[0]['json']['token'] }}"
```

</details>



<details>
<summary>gitlab_add_project_branches - роль добавляющая в проект ветви</summary>

```yaml
---
  - name: Create Gitlab project repository branches
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/projects/{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='project_id') | join(' ') }}/repository/branches"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}"
        Content-Type: application/json
      body:
        branch: "{{ item.branch }}"
        ref: "{{ item.ref }}"
    with_items: "{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='branches_project') }}"
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_add_project_files - роль для закачивания на сервер Gitlab файлов проекта</summary>

```yaml
---  
  - name: Move project directory to tmp directory
    become: false
    shell:
      cmd:
        "mv ./{{ target }} ./tmp"
      chdir: "{{ path }}"
    delegate_to: localhost

  - name: Del .git
    become: false
    shell:
        rm -rf ./.git
    args:
      chdir: "{{ path }}/tmp"
    delegate_to: localhost  

  - name: Pull gitlab repository
    become: false
    git:
      repo: "http://gitlab-ci-token:{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}@{{ gitlab_server }}:4433/{{ user_name }}/{{ target }}.git"
      dest: "{{ path }}/{{ target }}"
    delegate_to: localhost

  - name: Copy tmp directory to project directory
    become: false
    shell: |
      cp -R ../tmp/ ./
    args:
      chdir: "{{ path }}/{{ target }}"
    delegate_to: localhost

  - name: Del tmp directory
    become: false
    shell: |
      rm -rf ./tmp
    args:
      chdir: "{{ path }}"
    delegate_to: localhost

  - name: Add project to GitLab server
    become: false
    shell: |
      git config --local user.name "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='name') | join(' ') }}"
      git config --local user.email "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='email') | join(' ') }}"
      git add .
      git commit -m "Initial commit"
      git branch -m main
      git push --set-upstream origin main
    args:
      chdir: "{{ path }}/{{ target }}"
    delegate_to: localhost
    ignore_errors: true
```

</details>



<details>
<summary>gitlab_add_project_hook - роль для добавления webhook в проект</summary>

```yaml
---
  - name: Add Gitlab project hook
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/projects/{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='project_id') | join(' ') }}/hooks"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}"
        Content-Type: application/json
      body:
          id: "{{ item.id }}"
          url: "{{ item.url }}"
          push_events: "{{ item.push_events }}"
          merge_requests_events: "{{ item.merge_requests_events }}"
          enable_ssl_verification: "{{ item.enable_ssl_verification }}"
          note_events: "{{ item.note_events }}"
          token: "{{ item.token }}"
    with_items: "{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='hooks') }}"
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_add_protect_repo_branches - роль делает некоторые ветви проекта защищенными</summary>

```yaml
---
  - name: Create Gitlab protect repository branches
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/projects/{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='project_id') | join(' ') }}/protected_branches"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}"
        Content-Type: application/json
      body:
        name: "{{ item.name }}"
        push_access_level: "{{ item.push_access_level }}"
        merge_access_level: "{{ item.merge_access_level }}"
        unprotect_access_level: "{{ item.unprotect_access_level }}"
        allow_force_push: "{{ item.allow_force_push }}"
    with_items: "{{ gitlab_config.projects | selectattr('name','equalto', target ) | map(attribute='branches_protect') }}"
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_add_user - роль добавления нового пользователя</summary>

```yaml
---
  - name: Create Gitlab User
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/users"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.api_token }}"
        Content-Type: application/json
      body:
        email: "{{ item.email }}"
        name: "{{ item.name }}"
        reset_password: "{{ item.reset_password }}"
        username: "{{ item.username }}"
        password: "{{ item.password }}"
        skip_confirmation: "{{ item.skip_confirmation }}"
    with_items: "{{ gitlab_config.users }}"
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_allow_local_weebhook - роль настройки Giltab, разрешающая доступ к локальной сети</summary>

```yaml
---
  - name: Allow local requests from webhooks and services
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/application/settings"
      method: PUT
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.api_token }}"
        Content-Type: application/json
      body:
        allow_local_requests_from_web_hooks_and_services: "{{ gitlab_config.allow_local_requests_from_web_hooks_and_services }}"
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_create_personal_access_token - роль создания персонального токена доступа к Gilab</summary>

```yaml
---
  - name: Create Gitlab personal access token
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/users/{{ gitlab_config.users | selectattr('username','equalto', target ) | map(attribute='user_id') | join(' ') }}/personal_access_tokens"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.api_token }}"
        Content-Type: application/json
      body:
        name: "{{ item.name }}"
        scopes: "{{ item.scopes }}"
        expires_at: "{{ item.expires_at }}"
    with_items: "{{ gitlab_config.users | selectattr('username','equalto', target ) | map(attribute='personal_token') }}"

    no_log: false
    ignore_errors: true
    changed_when: false
    register: reg

  - name: Set Gitlab project access token to variable
    set_fact:
      user_api_token: "{{ reg.results[0]['json']['token'] }}"

  - debug: msg="{{ user_api_token }}"
```

</details>



<details>
<summary>gitlab_create_project - роль создания проекта на сервере Gilab</summary>

```yaml
---
  - debug: >
      var=item
    with_items: "{{ gitlab_config.projects | selectattr('name', 'equalto', 'demo-project' ) }}"

  - name: Create Gitlab project
    ansible.builtin.uri:
      url: "{{ gitlab_config.api_url }}/projects/user/{{ gitlab_config.users | selectattr('username','equalto', target ) | map(attribute='user_id') | join(' ') }}"
      method: POST
      body_format: json
      status_code: [200, 201, 202]
      return_content: true
      headers:
        PRIVATE-TOKEN: "{{ gitlab_config.api_token }}"
        Content-Type: application/json
      body:
        name: "{{ item.name }}"
        description: "{{ item.description }}"
        initialize_with_readme: "{{ item.initialize_with_readme }}"
    with_items: "{{ gitlab_config.projects }}"
    ignore_errors: true
    changed_when: false
```

</details>



<details>
<summary>gitlab_get_project_id - роль для получения ID проекта</summary>

```yaml
---
  - name: Get Gitlab user project id
    shell: |
      curl --header "PRIVATE-TOKEN: {{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}" "{{ gitlab_config.api_url }}/users/{{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_id') | join(' ') }}/projects" | jq '.[] | select(.name == "{{ target }}").id'
    no_log: false
    ignore_errors: true
    changed_when: false
    register: reg

  - name: Set Gitlab project id to variable
    set_fact:
      project_id: "{{ reg.stdout }}"
```

</details>



<details>
<summary>gitlab_get_user_id - роль получения ID пользователя</summary>

```yaml
---
  - name: Get Gitlab user id
    shell: |
      curl --header "PRIVATE-TOKEN: {{ gitlab_config.api_token }}" "{{ gitlab_config.api_url }}/users" | jq '.[] | select(.username == "{{ target }}").id'
    no_log: false
    ignore_errors: true
    changed_when: false
    register: reg

  - name: Set Gitlab user id to variable
    set_fact:
      user_id: "{{ reg.stdout }}"
```

</details>

<details>
<summary>gitlab_prepare_project_files - роль для подготовки файлов проекта к копированию на сервер Gitlab</summary>

```yaml
---
  - name: Copy directory to tf-infra project directory
    become: false
    shell: |
      cp -R ../{{ source }} ./
    args:
      chdir: "{{ path }}/{{ target }}"
    delegate_to: localhost
```

</details>

<details>
<summary>health_check - роль для проверки статуса контейнера Gitlab-сервера после создания</summary>

```yaml
---
  - name: "Wait for {{ container }} container is {{ status }} status."
    docker_container_info:
      name: "{{ container }}"
    register: result
    until: result.container.State.Health.Status == status
    retries: 100
    delay: 25
```

</details>


<details>
<summary>k8s - роль для настройки доступа к k8s с использованием статического файла доступа</summary>

```yaml
---
  - name: Get cluster id
    become: false
    shell: |
      yc managed-kubernetes cluster list --folder-name={{ tf_workspace }} --format json | jq -r '.[0].id'
    register: reg
  - name: Set cluster id to variable
    become: false
    set_fact:
      cluster_id: "{{ reg.stdout }}"

  - name: Get credential
    become: false
    shell: >
      yc managed-kubernetes cluster get-credentials {{ cluster_id }}
      --external
      --force
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig

  - name: Create ca.pem
    become: false
    shell: >
      yc managed-kubernetes cluster get --id {{ cluster_id }}  
      --format json |
      jq -r .master.master_auth.cluster_ca_certificate |
      awk '{gsub(/\\n/,"\n")}1' > ../k8s/{{ tf_workspace }}/ca.pem

  - name: Create service account
    become: false
    shell: >
      kubectl delete -f ../k8s/sa.yml
      --ignore-not-found=true
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig &&
      kubectl create -f ../k8s/sa.yml
      --allow-missing-template-keys=true
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig

  - name: Get service account token
    become: false
    shell: >
      kubectl -n kube-system get secret $(kubectl -n kube-system get secret --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig |
      grep admin-user-token | awk '{print $1}') -o json --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig | jq -r .data.token | base64 --d
    register: reg

  - name: Set service account token to variable
    become: false
    set_fact:
      sa_token: "{{ reg.stdout }}"

  - name: Get k8s master internal endpoint
    become: false
    shell: >
      yc managed-kubernetes cluster get --id {{ cluster_id }} --format json |
      jq -r .master.endpoints.internal_v4_endpoint
    register: reg

  - name: Set k8s master internal endpoint to variable
    become: false
    set_fact:
      master_endpoint_int: "{{ reg.stdout }}"

  - name: Get k8s master external endpoint
    become: false
    shell: >
      yc managed-kubernetes cluster get --id {{ cluster_id }} --format json |
      jq -r .master.endpoints.external_v4_endpoint
    register: reg

  - name: Set k8s master external endpoint to variable
    become: false
    set_fact:
      master_endpoint_ext: "{{ reg.stdout }}"

  - name: Create static kubeconfig for internal connection
    become: false
    shell: >
      kubectl config set-cluster k8s
      --certificate-authority=../k8s/{{ tf_workspace }}/ca.pem
      --server={{ master_endpoint_int }}
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig-int &&

      kubectl config set-credentials admin-user
      --token={{ sa_token }}
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig-int &&

      kubectl config set-context default
      --cluster=k8s
      --user=admin-user
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig-int

  - name: Create static kubeconfig for external connection
    become: false
    shell: >
      kubectl config set-cluster k8s
      --certificate-authority=../k8s/{{ tf_workspace }}/ca.pem
      --server={{ master_endpoint_ext }}
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig-ext &&

      kubectl config set-credentials admin-user
      --token={{ sa_token }}
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig-ext &&

      kubectl config set-context default
      --cluster=k8s
      --user=admin-user
      --kubeconfig=../k8s/{{ tf_workspace }}/kubeconfig-ext
```

</details>



<details>
<summary>k8s_apply - роль для применения манифеста деплоя приложения в кластер k8s</summary>

```yaml
---
  - name: Apply yaml chart
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl delete -f ./{{ manifest }} --ignore-not-found
        kubectl apply -f ./{{ manifest }}
      chdir: "../k8s"
    delegate_to: localhost
```

</details>



<details>
<summary>k8s_atlantis - роль для деплоя Atlantis в кластер k8s</summary>

```yaml
---
# stage
  - name: Get access_key to backet access stage workspace
    become: false
    shell:
      cmd: |
        cat sa-key.json | jq -r .access_key.key_id
      chdir: ../tf/key/stage
    delegate_to: localhost
    register: reg

  - debug: msg={{ reg.stdout }}

  - name: Set backend stage access_key to variable
    set_fact:
      backend_stage_access_key: "{{ reg.stdout }}"

  - name: Get secret to backet access stage workspace
    become: false
    shell:
      cmd: |
        cat sa-key.json | jq -r .secret
      chdir: ../tf/key/stage
    delegate_to: localhost
    register: reg

  - debug: msg={{ reg.stdout }}

  - name: Set backend stage secret to variable
    set_fact:
      backend_stage_secret_key: "{{ reg.stdout }}"

  - name: Get yandex_folder_id stage workspace
    become: false
    shell:
      cmd: |
        yc resource-manager folder get stage --format=json | jq -r .id
      chdir: ../tf
    delegate_to: localhost
    register: reg

  - debug: msg={{ reg.stdout }}

  - name: Set yandex_folder_id to variable
    set_fact:
      stage_yandex_folder_id: "{{ reg.stdout }}"

# prod  
  - name: Get access_key to backet access prod workspace
    become: false
    shell:
      cmd: |
        cat sa-key.json | jq -r .access_key.key_id
      chdir: ../tf/key/prod
    delegate_to: localhost
    register: reg

  - debug: msg={{ reg.stdout }}

  - name: Set backend prod access_key to variable
    set_fact:
      backend_prod_access_key: "{{ reg.stdout }}"

  - name: Get secret to backet access prod workspace
    become: false
    shell:
      cmd: |
        cat sa-key.json | jq -r .secret
      chdir: ../tf/key/prod
    delegate_to: localhost
    register: reg

  - debug: msg={{ reg.stdout }}

  - name: Set backend prod secret to variable
    set_fact:
      backend_prod_secret_key: "{{ reg.stdout }}"

  - name: Get yandex_folder_id prod workspace
    become: false
    shell:
      cmd: |
        yc resource-manager folder get prod --format=json | jq -r .id
      chdir: ../tf
    delegate_to: localhost
    register: reg

  - debug: msg={{ reg.stdout }}

  - name: Set yandex_folder_id to variable
    set_fact:
      prod_yandex_folder_id: "{{ reg.stdout }}"

# Create from template
  - name: Create "{{ target }}" file from template
    become: false
    template:
      src: "{{ tmpl }}"
      dest: "{{ target }}"
    delegate_to: localhost
```


<details>
<summary>Шаблон `atlantis.j2`</summary>

```bash
version: 3
automerge: true
delete_source_branch_on_merge: true
parallel_plan: true
parallel_apply: true
abort_on_execution_order_fail: true
projects:
- name: tf-infra-stage
  dir: tf
  workspace: stage    
  repo_locking: true
  custom_policy_check: false
  autoplan:
    when_modified: ["*.tf", "./modules/**/*.tf", ".terraform.lock.hcl"]
    enabled: true
  execution_order_group: 1
  workflow: stage
- name: tf-infra-prod
  dir: tf
  workspace: prod    
  repo_locking: true
  custom_policy_check: false
  autoplan:
    when_modified: ["*.tf", "./modules/**/*.tf", ".terraform.lock.hcl"]
    enabled: true
  execution_order_group: 1
  workflow: prod
workflows:
  stage:
    plan:
      steps:
        - run: rm -rf .terraform
        - run: rm -rf .terraform.lock.hcl
        - run: >-
            terraform init -lock=false -input=false -no-color -reconfigure -backend-config="bucket=backend01" -backend-config="access_key={{ backend_stage_access_key }}" -backend-config="secret_key={{ backend_stage_secret_key }}"
        - plan:
            extra_args: ["-lock=false", "-var-file=.tfvars", "-var 'yandex_folder_id={{ stage_yandex_folder_id }}'"]
    apply:
      steps:
        - apply:
            extra_args: ["-lock=false"]
  prod:
    plan:
      steps:
        - run: rm -rf .terraform
        - run: rm -rf .terraform.lock.hcl
        - run: >-
            terraform init -lock=false -input=false -no-color -reconfigure -backend-config="bucket=backend01" -backend-config="access_key={{ backend_prod_access_key }}" -backend-config="secret_key={{ backend_prod_secret_key }}"
        - plan:
            extra_args: ["-lock=false", "-var-file=.tfvars", "-var 'yandex_folder_id={{ prod_yandex_folder_id }}'"]
    apply:
      steps:
        - apply:
            extra_args: ["-lock=false"]
allowed_regexp_prefixes:
- dev/
- staging/
- feature/

```

</details>

</details>

<details>
<summary>k8s_atlantis_deployment_template - роль для создания YAML манифеста Atlantis из шаблона</summary>

```yaml
---
  - name: Create "{{ target }}" file from template
    become: false
    template:
      src: "{{ tmpl }}"
      dest: "{{ target }}"
    delegate_to: localhost
```

<details>
<summary>Шаблон `atlantis-deployment.j2`</summary>

```bash
apiVersion: v1
kind: Namespace
metadata:
  name: atlantis-ns
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: atlantis-config
  namespace: atlantis-ns
  labels:
    app: atlantis
data:
  config.yaml: |
    automerge: true
    write-git-creds: true
    enable-diff-markdown-format: true
    hide-unchanged-plan-comments: true
    hide-prev-plan-comments: true
    parallel-plan: true
    repo-allowlist: '*'
    log-level: info
    gitlab-hostname: {{ gitlab_url_http }}:4433
    gitlab-user: {{ user_name }}
    gitlab-token: {{ gitlab_config.users | selectattr('username','equalto', user_name ) | map(attribute='user_api_token') | join(' ') }}
    gitlab-webhook-secret: {{ atlantis_webhook_secret }}
  repos.yaml: |
    ---
    repos:
    - id: /.*/
      allow_custom_workflows: true
      allowed_overrides: [custom_policy_check, workflow, repo_locking, apply_requirements, plan_requirements, import_requirements, delete_source_branch_on_merge]
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: tf-config
  namespace: atlantis-ns
  labels:
    app: atlantis
data:
  terraformrc: |
    provider_installation {
      network_mirror {
        url = "https://terraform-mirror.yandexcloud.net/"
        include = ["registry.terraform.io/*/*"]
      }
      direct {
        exclude = ["registry.terraform.io/*/*"]
      }
    }
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: atlantis
  namespace: atlantis-ns
spec:
  serviceName: atlantis
  replicas: 1
  updateStrategy:
    type: RollingUpdate
    rollingUpdate:
      partition: 0
  selector:
    matchLabels:
      name: atlantis
  template:
    metadata:
      namespace: atlantis-ns
      labels:
        name: atlantis
    spec:
      securityContext:
        fsGroup: 1000
      containers:
      - name: atlantis
        image: ghcr.io/runatlantis/atlantis:v0.26.0
        env:
          - name: ATLANTIS_CONFIG
            value: /configs/config.yaml
          - name: ATLANTIS_REPO_CONFIG
            value: /configs/repos.yaml
          - name: ATLANTIS_DATA_DIR
            value: /atlantis
          - name: ATLANTIS_ATLANTIS_URL
            value: {{ atlantis_url }}
          - name: ATLANTIS_PORT
            value: "4141"
        volumeMounts:
        - name: atlantis-data
          mountPath: /atlantis
        - name: atlantis-configs
          mountPath: /configs
          readOnly: true
        - name: tf-configs
          mountPath: /home/atlantis/.terraformrc
          subPath: .terraformrc
          readOnly: true
        ports:
        - name: atlantis
          containerPort: 4141
        resources:
          requests:
            memory: 256Mi
            cpu: 100m
          limits:
            memory: 256Mi
            cpu: 100m
        livenessProbe:
          periodSeconds: 60
          httpGet:
            path: /healthz
            port: 4141
            scheme: HTTP
        readinessProbe:
          periodSeconds: 60
          httpGet:
            path: /healthz
            port: 4141
            scheme: HTTP
      volumes:
      - name: atlantis-configs
        configMap:
          name: atlantis-config
          items:
          - key: config.yaml
            path: config.yaml
          - key: repos.yaml
            path: repos.yaml
      - name: tf-configs
        configMap:
          name: tf-config
          items:
          - key: terraformrc
            path: .terraformrc
  volumeClaimTemplates:
  - metadata:
      name: atlantis-data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 5Gi
---
apiVersion: v1
kind: Service
metadata:
  name: atlantis
  namespace: atlantis-ns
spec:
  selector:
    name: atlantis
  ports:
    - protocol: TCP
      port: 4141
      targetPort: 4141
      nodePort: 30090
  type: NodePort              
```

</details>

</details>

<details>
<summary>k8s_delete - роль для удаления пространства имен</summary>

```yaml
---
  - name: Delete namespaces
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl config use-context default
        kubectl delete namespace {{ namespaces }} --ignore-not-found
      chdir: "../k8s"
    timeout: 60
    delegate_to: localhost
    ignore_errors: true
```

</details>

<details>
<summary>k8s_get_node_ip - роль для получения внутреннего IP адреса узлов кластера k8s</summary>

```yaml
---
  - name: K8S Use context default
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl config use-context default
      chdir: ../k8s
    delegate_to: localhost

  - name: Get k8s-node-internal-ip-1
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}'
      chdir: ../k8s
    register: ip1
    delegate_to: localhost

  - name: Get k8s-node-internal-ip-2
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl get nodes -o jsonpath='{.items[1].status.addresses[0].address}'
      chdir: ../k8s
    register: ip2
    delegate_to: localhost

  - name: Get k8s-node-internal-ip-3
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl get nodes -o jsonpath='{.items[2].status.addresses[0].address}'
      chdir: ../k8s
    register: ip3
    delegate_to: localhost

  - name: Set k8s node 1 internal endpoint to variable
    become: false
    set_fact:
      k8s_internal_ip_node_1: "{{ ip1.stdout }}"
    delegate_to: localhost

  - name: Set k8s node 2 internal endpoint to variable
    become: false
    set_fact:
      k8s_internal_ip_node_2: "{{ ip2.stdout }}"
    delegate_to: localhost

  - name: Set k8s node 3 internal endpoint to variable
    become: false
    set_fact:
      k8s_internal_ip_node_3: "{{ ip3.stdout }}"
    delegate_to: localhost
```

</details>



<details>
<summary>k8s_gitlab_credentials - роль для создания секрета для доступа к реестру контейнеров Yandex.Cloud</summary>

```yaml
---
  - name: Create Docker registry secret
    become: false
    shell:
      cmd: |
        kubectl create secret docker-registry regcred --docker-server=cr.yandex --docker-username=json_key --docker-password="$(cat ${PWD}/{{ tf_workspace }}/key.json)" --dry-run=client --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode | jq 'del(.auths."cr.yandex".auth)' | base64
      chdir: ../k8s
    register: reg
    delegate_to: localhost

  - name: Set dockerconfigjson base64 encode to variable
    set_fact:
      dockerconfigjson: "{{ reg.stdout }}"

  - name: Create "{{ target }}" file from template
    become: false
    template:
      src: "{{ tmpl }}"
      dest: "{{ target }}"
    delegate_to: localhost

  - name: Apply yaml chart
    become: false
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        kubectl delete -f ./{{ tf_workspace }}/registry-credentials.yml  --ignore-not-found
        kubectl apply -f ./{{ tf_workspace }}/registry-credentials.yml
      chdir: "../k8s"
    delegate_to: localhost
```

<details>
<summary>Шаблон `registry-credentials.j2`</summary>

```bash
apiVersion: v1
kind: Secret
metadata:
  name: regcred
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: {{ dockerconfigjson }}
```

</details>

</details>



<details>
<summary>k8s_monitoring - роль для деплоя в кластер k8s сервисов для мониторинга</summary>

```yaml
---
  - name: Create monitoring pods Prometheus and Grafana
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell:
      cmd: |
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo add tricksterproxy https://helm.tricksterproxy.io
        helm repo update
        kubectl delete namespace monitoring --ignore-not-found
        helm install monitoring-app prometheus-community/prometheus --create-namespace --namespace monitoring
        helm install trickster tricksterproxy/trickster --namespace monitoring -f ./monitoring/trickster.yaml
        kubectl create configmap k8s-dashboard --from-file=./monitoring/dashboard.json --namespace=monitoring
        kubectl apply -f ./monitoring/grafana.yaml --namespace=monitoring
      chdir: ../k8s

  - name: Wait for grafana pods become ready
    environment:
      KUBECONFIG: "{{ tf_workspace }}/kubeconfig-ext"
    shell: "kubectl wait --namespace=monitoring --for=condition=Ready pods --selector app=grafana --timeout=600s"
    args:
      chdir: ../k8s
    register: grafana_pods_ready

  - debug: var=grafana_pods_ready.stdout_lines
```

</details>



<details>
<summary>ssh-keys - роль для создания ssh ключей</summary>

```yaml
---
  - name: Create directory for ssh-keys
    file:
      state: directory
      mode: 0700
      dest: /root/.ssh/

  - name: Adding rsa-key in /root/.ssh/authorized_keys
    copy:
      src: "../ssh_key/{{ tf_workspace }}/id_rsa_vm-bastion.pub"
      dest: "/root/.ssh/authorized_keys"
      owner: root
      mode: 0600
    ignore_errors: yes

  - name: Adding rsa-key in /root/.ssh
    command: "{{ item }}"
    with_items:
      - "rm -rf /root/.ssh"
      - "ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa"
    ignore_errors: yes
```

</details>



<details>
<summary>sync - роль для копирования стека программ на хосты</summary>

```yaml
---
  - name: Synchronization {{ target }}
    copy:
      src: stack/opt/{{ target }}
      dest: "/opt"
      owner: root
      group: root
      mode: 0644
    become: true
```

</details>



<details>
<summary>templates - роль для создания конечного файла из файла шаблона</summary>

```yaml
---
  - name: Create "{{ target }}" file from template
    template:
      src: "{{ tmpl }}"
      dest: "{{ target }}"
```

<details>
<summary>Шаблон `Caddyfile.j2`</summary>

```bash
:4433 {
    gzip
    proxy / {{ gitlab_server }}:4433 {
        transparent
       insecure_skip_verify
    }
    proxy /ws {{ gitlab_server }}:3001 {
		websocket
	}
    errors stderr
#    tls off
}

{{ app_server }}:80 {
    proxy / {{ k8s_internal_ip_node_1 }}:30080 {
            transparent
            insecure_skip_verify
        }
    proxy / {{ k8s_internal_ip_node_2 }}:30080 {
            transparent
            insecure_skip_verify
        }
    proxy / {{ k8s_internal_ip_node_3 }}:30080 {
            transparent
            insecure_skip_verify
        }
    errors stderr
    tls off
}

{{ atlantis_server }}:80 {
    proxy / {{ k8s_internal_ip_node_1 }}:30090 {
            transparent
            insecure_skip_verify
        }
    proxy / {{ k8s_internal_ip_node_2 }}:30090 {
            transparent
            insecure_skip_verify
        }
    proxy / {{ k8s_internal_ip_node_3 }}:30090 {
            transparent
            insecure_skip_verify
        }
    errors stderr
    tls off
}

{{ grafana_server }}:80 {
    proxy / {{ k8s_internal_ip_node_1 }}:30100 {
            transparent
            insecure_skip_verify
        }
    proxy / {{ k8s_internal_ip_node_2 }}:30100 {
            transparent
            insecure_skip_verify
        }
    proxy / {{ k8s_internal_ip_node_3 }}:30100 {
            transparent
            insecure_skip_verify
        }
    errors stderr
    tls off
}
```

</details>

<details>
<summary>Шаблон `gitlab.j2`</summary>

```bash
version: '3.3'
services:
  web:
    image: 'gitlab/gitlab-ce:16.5.0-ce.0'
    container_name: gitlab
    restart: always
    hostname: '{{ gitlab_url }}'
    extra_hosts:
      - "{{ gitlab_url }}:{{ gitlab_extra_hosts }}"
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        ### Add any gitlab.rb configuration here, each on its own line
        external_url "{{ gitlab_url_http }}:4433"
        gitlab_rails['time_zone'] = "Europe/Moscow"
        gitlab_rails['initial_shared_runners_registration_token'] = "{{ gitlab_runner_token }}"
        # explicitly disable Geo module
        gitlab_rails['geo_registry_replication_enabled'] = false
        geo_secondary['auto_migrate'] = false

        ### Default project feature settings
        gitlab_rails['gitlab_default_projects_features_container_registry'] = true
        gitlab_rails['gitlab_default_projects_features_builds'] = true

        ### gitlab container registry
        registry_external_url "{{ gitlab_registry_http }}:5555"
        gitlab_rails['registry_enabled'] = true
        gitlab_rails['registry_host'] = "{{ registry_server }}"
        gitlab_rails['registry_port'] = "5555"
        registry['registry_http_addr'] = "0.0.0.0:5000"
        registry_nginx['enable'] = false

        ### gitlab package registry
        gitlab_rails['packages_enabled'] = true
        gitlab_rails['dependency_proxy_enabled'] = true

        ### puma worker
        puma['enable'] = true
        puma['worker_processes'] = 3

        ### disable internal nginx
        nginx['enable'] = false
        gitlab_rails['trusted_proxies'] = ["0.0.0.0"]
        gitlab_workhorse['listen_network'] = "tcp"
        gitlab_workhorse['listen_addr'] = "0.0.0.0:4433"
        # Add whatever user runs under to the following setting unless root
    ports:
      - '5555:5000'
      - '4433:4433'
      - '2022:2022'
    volumes:
      - './config:/etc/gitlab'
      - './config/ssl:/etc/gitlab/ssl/'
      - './logs:/var/log/gitlab'
      - './data:/var/opt/gitlab'
    shm_size: '256m'
    networks:
      - gitlab_net
    labels:
      org.label-schema.group: "gitlab"
networks:
  gitlab_net:
```

</details>

<details>
<summary>Шаблон `hosts.j2`</summary>

```bash
{{ hostvars['vm-gitlab'].ansible_host}} {{ gitlab_server }}
```

</details>

<details>
<summary>Шаблон `runner.j2`</summary>

```bash
version: "3.5"
services:
  gitlab_runner:
    build:
      context: .

      dockerfile: Dockerfile
    image: gitlab_runner:latest
  runner:
    restart: always
    image: gitlab_runner:latest
    depends_on:
      - gitlab_runner
      #  condition: service_completed_successfully
    environment:
      - GIT_SSL_NO_VERIFY=true
    extra_hosts:
      - "{{ gitlab_url }}:{{ gitlab_extra_hosts }}"
      - "{{ gitlab_registry }}:{{ gitlab_extra_hosts }}"
    ports:
      - '8093:8093'
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./config:/etc/gitlab-runner:z
      - ./config.json:/root/.docker/config.json
    networks:
      - gitlab_gitlab_net

  register_runner:
    restart: 'no'
    image: gitlab_runner:latest
    environment:
      - CI_SERVER_URL={{ gitlab_url_http }}:4433
      - REGISTRATION_TOKEN={{ gitlab_runner_token }}
      - GIT_SSL_NO_VERIFY=true
    depends_on:
      - runner
    extra_hosts:
      - "{{ gitlab_url }}:{{ gitlab_extra_hosts }}"
      - "{{ gitlab_registry }}:{{ gitlab_extra_hosts }}"
    command:
      - register
      - --non-interactive
      - --locked=false
      - --name=docker gitlab-runner
      - --executor=docker
      - --docker-tlsverify=false
      - --docker-image=docker:20.10.16
      - --docker-privileged=true
      - --docker-volumes=/cache
      - --tag-list=ansible, docker
      - --run-untagged=true
      - --docker-network-mode=gitlab_gitlab_net
      - --docker-extra-hosts={{ gitlab_url }}:{{ gitlab_extra_hosts }}
      - --docker-extra-hosts={{ gitlab_registry }}:{{ gitlab_extra_hosts }}
      - --env=GIT_SSL_NO_VERIFY=true
      - --clone-url={{ gitlab_url_http }}:4433
    volumes:
      - ./config:/etc/gitlab-runner:z
    networks:
      - gitlab_gitlab_net
networks:
  gitlab_gitlab_net:
    external: true
```

</details>

</details>



<details>
<summary>tools - роль для установки приложений из списка на хост</summary>

```yaml
---
  - name: Installing tools
    apt: >
      package={{ item }}
      state=present
      update_cache=yes
    with_items:
      "{{ tools_packages }}"
```

</details>



<details>
<summary>wait_hosts - роль ожидания запуска хоста</summary>

```yaml
---
  - name: Wait until vm is up
    wait_for_connection:
      delay: 10
      timeout: 900
```

</details>



<details>
<summary>wait_url - роль для ожидания ответа от адреса с определенным кодом статуса</summary>

```yaml
---
  - name: Wait until {{ url }} HTTP status is 200
    uri:
      url: "{{ url }}"
      return_content: yes
      validate_certs: no
      status_code:
        - 200
    until: uri_output.status == 200
    retries: 500
    delay: 5
    register: uri_output
```

</details>


#### `app`

В каталоге `app` содержится папка с демонстрационным приложением. Приложение выводит статическую страницу с картинкой.

Приложение создается с помощью [Dockerfile](./app/demo-project/src/Dockerfile)

<details>
<summary>Dockerfile</summary>

```dockerfile
FROM nginx:1.24.0
COPY index.html /usr/share/nginx/html/index.html
COPY water.jpg /usr/share/nginx/html/water.jpg
EXPOSE 80
```

</details>
<br>

Так же в каталоге содержится файл для конвейера CI/CD [.gitlab-ci.yml](./app/demo-project/.gitlab-ci.yml) и манифест для деплоя в кластер K8s [k8s.yml](./app/demo-project/k8s.yml).

<details>
<summary>.gitlab-ci.yml</summary>

```yaml
stages:
  - build
  - deploy
  - release
image: docker:20.10.16
variables:
  DOCKER_TLS_CERTDIR: ""
services:
  - docker:20.10.16-dind
builder:
  stage: build
  tags:
    - docker
  script:
    - docker build -t $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:$CI_COMMIT_SHORT_SHA -t $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:latest --cache-from $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:$CI_COMMIT_SHORT_SHA ./src
  only:
    - feature/build
    - main
    - master
deployer:
  stage: deploy
  tags:
    - docker
  script:
    - cat $KEY_JSON | docker login --username json_key --password-stdin $CI_REGISTRY
    - docker image pull $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:latest || true
    - docker build -t $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:$CI_COMMIT_SHORT_SHA -t $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:latest --cache-from $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH:$CI_COMMIT_SHORT_SHA ./src
    - docker push --all-tags $CI_REGISTRY/$CI_REGISTRY_ID/$CI_PROJECT_PATH
  only:
    - feature/release
    - feature/deploy
    - main
    - master
deploy_to_k8s:
  stage: deploy
  tags:
    - docker
  image:
    name: bitnami/kubectl:latest
    entrypoint: [""]
  script:
    - kubectl config set-cluster k8s --certificate-authority=$CA_PEM --server=$KUBE_INT_URL --kubeconfig=kubeconfig
    - kubectl config set-credentials admin-user --token=$KUBE_TOKEN --kubeconfig=kubeconfig
    - kubectl config set-context default --cluster=k8s --user=admin-user --kubeconfig=kubeconfig
    - kubectl config use-context default --kubeconfig=kubeconfig
    - cat kubeconfig
    - kubectl get pods --all-namespaces --kubeconfig=kubeconfig
    - kubectl cluster-info --kubeconfig=kubeconfig
    - sed -i "s,__VERSION__,${CI_REGISTRY}/${CI_REGISTRY_ID}/${CI_PROJECT_PATH}:$CI_COMMIT_SHORT_SHA," k8s.yml
    - kubectl delete -f k8s.yml --ignore-not-found --kubeconfig=kubeconfig
    - kubectl apply -f k8s.yml --kubeconfig=kubeconfig
  only:
    - feature/release
    - feature/deploy
    - main
    - master
release:
  stage: release
  tags:
    - docker
  image: registry.gitlab.com/gitlab-org/release-cli:latest
  variables:
    GIT_STRATEGY: clone
  needs:
    - job: deployer
  before_script:
    - apk update
    - apk add curl jq git
    - git config --global user.name "${GITLAB_USER_NAME}"
    - git config --global user.email "${GITLAB_USER_EMAIL}"
  script:
    - export VERSION=$(jq -r .version version.json)
    - export NAME=$(jq -r .name version.json)
    - export MESSAGE=$(cat ./changelog/$VERSION.md)
    - CURRENTDATE="$(date)"
    - echo "$CURRENTDATE added a line" | tee -a timelog.log
    - git add timelog.log
    - git commit -m "[ci skip] updated timelog.log at $CURRENTDATE"
    - git remote set-url origin "http://gitlab-ci-token:$ACCESS_TOKEN@$CI_SERVER_HOST:4433/$CI_PROJECT_PATH.git"
    - git push -o ci-skip origin HEAD:$CI_COMMIT_REF_NAME
    - git tag
    - |
        if [ $(git tag -l "$VERSION") ]; then
          echo "Version $VERSION already exists"
        else
          echo "Release version $NAME $VERSION"
          git tag -a $VERSION -m "Version $VERSION"
          git push -o ci-skip --tags origin HEAD:$CI_COMMIT_REF_NAME
          release-cli --insecure-https=true create --name "Release version $NAME $VERSION" \
          --description "$MESSAGE" --tag-name $VERSION --ref $CI_COMMIT_SHA
        fi
  only:
    - main
    - master
```

</details>

<details>
<summary>k8s.yml</summary>

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demo-app
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubernetes-nginx-static-html-demo
  namespace: demo-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kubernetes-nginx-static-html-demo
  template:
    metadata:
      namespace: demo-app
      labels:
        app: kubernetes-nginx-static-html-demo
    spec:
      containers:
        - name: static-html
          image: __VERSION__
          imagePullPolicy: Always
          ports:
            - containerPort: 80
              name: http-app
              protocol: TCP
      imagePullSecrets:
      - name: regcred
---
apiVersion: v1
kind: Service
metadata:
  name: kubernetes-nginx-static-html-demo
  namespace: demo-app
spec:
  selector:
    app: kubernetes-nginx-static-html-demo
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 80
      nodePort: 30080
  type: NodePort
```

</details>

#### `k8s`

В каталоге `k8s` содержится папка `monitoring` с манифестами для деплоя в кластер K8s приложения для мониторинга [`Grafana`](./k8s/monitoring/grafana.yaml) и кеширующим прокси [`trickster`](./k8s/monitoring/trickster.yaml), для ускорения чтения из БД `Prometheus`.  

Так же в каталоге содержится файл [sa.yml](./k8s/sa.yml) с помощью которого создается объект `ServiceAccount` для взаимодействия с API K8s внутри кластера Managed Service for Kubernetes.

<details>
<summary>grafana.yaml</summary>

```yaml
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-grafana-datasources
data:
  sources.yaml: |
    apiVersion: 1
    deleteDatasources:
    - name: Prometheus
      orgId: 1
    datasources:
    - name: Prometheus
      type: prometheus
      orgId: 1
      url: http://trickster:8480
      access: proxy
      isDefault: true
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: grafana
  name: grafana
spec:
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      securityContext:
        fsGroup: 472
        supplementalGroups:
          - 0
      containers:
        - name: grafana
          image: grafana/grafana:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: GF_DASHBOARDS_DEFAULT_HOME_DASHBOARD_PATH
              value: "/var/lib/grafana/dashboards/dashboard.json"
          ports:
            - containerPort: 3000
              name: http-grafana
              protocol: TCP
          readinessProbe:
            failureThreshold: 3
            httpGet:
              path: /robots.txt
              port: 3000
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 30
            successThreshold: 1
            timeoutSeconds: 2
          livenessProbe:
            failureThreshold: 3
            initialDelaySeconds: 30
            periodSeconds: 10
            successThreshold: 1
            tcpSocket:
              port: 3000
            timeoutSeconds: 1
          resources:
            requests:
              cpu: 250m
              memory: 750Mi
          volumeMounts:
            - mountPath: /var/lib/grafana
              name: grafana-pv
            - mountPath: /etc/grafana/provisioning/datasources
              name: grafana-datasources
              readOnly: false
            - name: my-k8s-dashboard
              mountPath: /var/lib/grafana/dashboards/dashboard.json
              subPath: dashboard.json
      volumes:
        - name: grafana-pv
          persistentVolumeClaim:
            claimName: grafana-pvc
        - name: grafana-datasources
          configMap:
            defaultMode: 420
            name: my-grafana-datasources
        - name: my-k8s-dashboard
          configMap:
            name: k8s-dashboard
            items:
              - key: dashboard.json
                path: dashboard.json
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  selector:
    app: grafana
  ports:
    - protocol: TCP
      port: 8100
      targetPort: http-grafana
      nodePort: 30100
  type: NodePort     
```

</details>

<details>
<summary>trickster.yaml</summary>

```yaml
frontend:
  listenAddress: ""
  tlsListenAddress: ""
  tlsListenPort: ""
  connectionsLimit: "0"
origins:
  - name: default
    originType: prometheus
    originURL: http://monitoring-app-prometheus-server:80
profiler:
  enabled: false
  port: 6060
prometheusScrape: false
prometheus:
  serviceMonitor:
    enabled: false
    interval: 30s
    labels: {}
replicaCount: 1
image:
  repository: tricksterproxy/trickster
  tag: "1.1"
  pullPolicy: IfNotPresent
service:
  annotations: {}
  labels: {}
  clusterIP: ""
  externalIPs: []
  loadBalancerIP: ""
  loadBalancerSourceRanges: []
  metricsPort: 8481
  servicePort: 8480
  type: ClusterIP
ingress:
  enabled: false
  annotations: {}
  extraLabels: {}
  hosts: []
  tls: []
volumes:
  persistent:
    type: "persistentVolume"
    enabled: false
    mountPath: "/tmp/trickster"
    accessModes:
      - ReadWriteOnce
    annotations: {}
    existingClaim: ""
    size: 15Gi
  generic:
    type: "generic"
    enabled: true
    mountPath: "/tmp/trickster"
podAnnotations: {}
resources: {}
securityContext: {}
```

</details>

<details>
<summary>sa.yml</summary>

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
---
apiVersion: v1
kind: Secret
type: kubernetes.io/service-account-token
metadata:
  name: admin-user-token
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: "admin-user"
```

</details>

#### `tf`

В каталоге `tf` содержатся манифесты для создания облачной инфрастуктуры в облаке Yandex.Cloud.

Каталог так же содержит папку `modules`, с подкаталогами:

- `k8s-yc` - каталог модуля для создания кластера K8s с использованием Yandex Managed Service for Kubernetes.
- `vm` - каталог модуля для создания типового инстанса виртуальной машины.

<details>
<summary>Файл переменных .tfvars</summary>

```bash
yandex_zone                 = "ru-central1-a"
yandex_cloud_id             = "b1gagk****************"

yandex_nat_image_id         = "fd80mrhj8fl2oe87o4e1" //NAT image
yandex_image_id             = "fd8q5m87s3v0hmp06i5c" //Ubuntu 20.04 LTS

vm_bastion_user_name        = "bastion_user"
vm_gitlab_user_name         = "gitlab_user"
vm_k8s_user_name            = "k8s_user"

vm_bastion_internal_ip      = "192.168.1.254"
vm_gitlab_internal_ip       = "192.168.1.11"

ssh_vm_bastion_key          = "id_rsa_vm-bastion"
ssh_vm_key                  = "id_rsa_vm"
ssh_vm_k8s_key              = "id_rsa_k8s"
ssh_path                    = "../ssh_key"

picture                     = "./img/water.jpg"
index_html                  = "./html/index.html"
dns_domain                  = "bdvsun.ru"

ansible_inventory_path      = "../ansible"
ansible_inventory_filename  = "inventory"

yandex_s3_bucket            = "backend01"
```

</details>

<details>
<summary>Файл настроек зеркала terraform .terraformrc</summary>

```bash
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```

</details>
<br>

Манифесты:

<details>
<summary>cloud-dns.tf - в файле описывается создание ресурсов yandex_dns_zone и yandex_dns_recordset описывающие домен третьего уровня и wildcard dns запись</summary>

```bash
resource "yandex_dns_zone" "zone1" {
  name   = replace(var.dns_domain, ".", "-")
  zone   = join("", [terraform.workspace, "." , var.dns_domain, "."])
  public = true
}
# Wildcard DNS запись
resource "yandex_dns_recordset" "rs-aname-1" {
  zone_id = "${yandex_dns_zone.zone1.id}"
  name    = "*"
  type    = "A"
  ttl     = 200
  data    = ["${element(module.vm-bastion.external_ip,0)}"]
}
```
</details>


<details>
<summary>container-registry.tf - в файле описывается создание ресурса yandex_container_registry</summary>

```bash
# Реестр контейнеров
resource "yandex_container_registry" "my-registry" {
  name      = "${terraform.workspace}-registry"
  folder_id = var.yandex_folder_id

  labels = {
    my-label = "${terraform.workspace}-my-registry"
  }
}
```
</details>


<details>
<summary>instance.tf - в файле описывается создание ресурсов инстансов из модулей описаных в каталоге ./modules</summary>

```bash
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
```
</details>


<details>
<summary>main.tf - в файле дается описание для провайдера Yandex.Cloud, а так же описание для backend</summary>

```bash
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
}
```
</details>


<details>
<summary>network.tf - в файле описывается создание ресурсов для сетей, подсетей, шлюза и групп безопасности</summary>

```bash
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
```
</details>


<details>
<summary>output.tf - в файле описывается динамическое создание inventory файла для Ansible</summary>

```bash
output "external_ip" {
  value = "${try(module.vm-bastion.external_ip, null)}"
}
# Создание файла inventory для Ansible средствами Terraform
resource "local_file" "inventory" {
  content = <<-DOC
# Ansible inventory containing variable values from Terraform.
# Generated by Terraform.

---
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ansible_playbook_python}}"
    vm-bastion:
      ansible_host: "${element(module.vm-bastion.external_ip,0)}"
      ansible_port: "22"
      ansible_user: "${var.vm_bastion_user_name}"
      ansible_ssh_private_key_file: "${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_bastion_key}"
      ansible_ssh_common_args: ""
    vm-gitlab:
      ansible_host: "${element(module.vm-gitlab.internal_ip,0)}"
      ansible_port: 22
      ansible_user: "${var.vm_gitlab_user_name}"
    k8s-cluster:
      external_v4_endpoint: "${module.k8s.external_v4_endpoint}"
      internal_v4_endpoint: "${module.k8s.internal_v4_endpoint}"
      cluster_id: "${module.k8s.cluster_id}"
      service_account_id: "${module.k8s.service_account_id}"
      node_service_account_id: "${module.k8s.node_service_account_id}"
      container_registry_id: "${yandex_container_registry.my-registry.id}"
  vars:
    ansible_ssh_private_key_file: "${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_key}"
    ansible_ssh_common_args: >-
      -o ProxyCommand="ssh -p 22 -W %h:%p -q
      -i ${var.ssh_path}/${terraform.workspace}/${var.ssh_vm_bastion_key} ${var.vm_bastion_user_name}@${element(module.vm-bastion.external_ip,0)}"
  children:
    infra:
      hosts:
        vm-bastion:
        vm-gitlab:
    gitlab:
      hosts:
        vm-gitlab:
    bastion:
      hosts:
        vm-bastion:
    DOC
  filename = join("", [var.ansible_inventory_path, "/", terraform.workspace, "-", var.ansible_inventory_filename])
  depends_on = [
    module.vm-bastion,
    module.vm-gitlab,
    module.k8s
  ]
}
```
</details>


<details>
<summary>service-acc.tf - в файле описывается создание ресурсов для сервисных аккаунтов</summary>

```bash
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
```
</details>


<details>
<summary>variables.tf - в файле описываются используемые переменные</summary>

```bash
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
```
</details>


#### `.env`

В файле `.env` содержатся переменные окружения для успешной сборки проекта.

<details>
<summary>Файл .env</summary>

```bash
# Токен Yandex.Cloud
yandex_token=y0_AgAAAAALm**********************************
# Используемая зона по умолчанию
yandex_zone=ru-central1-a
# Идентификатор облака в Yandex.Cloud
yandex_cloud_id=b1gagk****************
# Название сервисного аккаунта с ролью Editor
yandex_service_acc=service-acc01
# Название сервисного аккаунта с ролью Admin
yandex_service_admin_acc=service-admin-acc01
# Название для профайла
yandex_profile=profile01
# Название для backend
yandex_s3_bucket=backend01
```

</details>

#### `Makefile`

Основной файл сборки проекта - [Makefile](./Makefile)

<details>
<summary>Листинг файла Makefile, с комментариями</summary>

```bash
# Makefile для автоматизации сборки
.PHONY: all yc ssh_key_create terraform tf_apply tf_destroy k8s ansible clean

YC_PROFILE = $(shell yc config profile list | awk '/$(yandex_profile)/{print $$1}')
YC_SERVICE_ACC ?= $(shell yc iam service-account list --folder-name=$(WORKSPACE) | awk '/$(yandex_service_acc)/{print $$4}')
YC_SERVICE_ACC_ADM ?= $(shell yc iam service-account list --folder-name=$(WORKSPACE) | awk '/$(yandex_service_admin_acc)/{print $$4}')
YC_STORAGE_BUCKET ?= $(shell yc storage bucket list --folder-name=$(WORKSPACE_BACKET) | awk '/$(yandex_s3_bucket)/{print $$2}')
YC_FOLDER_ID ?= $(shell yc resource-manager folder get $(WORKSPACE) --format=json | jq -r .id)
YC_SERVICE_ACC_ID ?= $(shell yc iam service-account get $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE) --format=json | jq -r .id)
YC_SERVICE_ACC_ADM_ID ?= $(shell yc iam service-account get $(WORKSPACE)-$(yandex_service_admin_acc) --folder-name=$(WORKSPACE) --format=json | jq -r .id)
# Путь до папки c Ansible
ANSIBLE_PATH = ./ansible
# Путь до папки c Terraform
TF_PATH = ./tf
# Путь до папки c ключами доступа к Yandex.Cloud
TF_PATH_KEY = ./tf/key
# Путь до папки c демо приложением
APP_PATH = ./app/demo-project
# Путь до папки c Terraform для размещения в репозитории
TF-INFRA_PATH = ./tf-infra
# Путь до папки c настройками для k8s
K8S_PATH = ./k8s
# Путь до папки c SSH-ключами
SSH_PATH = ./ssh_key
# Путь до папки c манифестом для деплоя Atlantis
ATLANTIS_PATH = $(K8S_PATH)/atlantis
# Рабочее пространство по умолчанию, а так же
# папка в Yandex.Cloud для размещения инфраструктуры "stage"
WORKSPACE = stage
# Папка в Yandex.Cloud для размещения бэкенда
WORKSPACE_BACKET = backet
# API token для работы с REST API GitLab
API_TOKEN = api_token

#Makefile для автоматизации сборки
ANSIBLE_MK = ansible.mk
TF_MK = terraform.mk
K8S_MK = k8s.mk

# Добавляем в сборку переменные окружения из файла .env
# Структура файла:
# yandex_token=y0_AgAAAAA********************
# yandex_zone=ru-central1-a
# yandex_cloud_id=b1g*************
# yandex_service_acc=service-acc01
# yandex_service_admin_acc=service-admin-acc01
# yandex_profile=profile01
# yandex_s3_bucket=backend01

include .env

all:
# Выполняем предварительные настройки Yandex.Cloud для рабочего пространства stage
	$(MAKE) yc_prepare WORKSPACE=stage
# Выполняем предварительные настройки Yandex.Cloud для рабочего пространства prod
	$(MAKE) yc_prepare WORKSPACE=prod
# Передаем на выполнение создание инфраструктуры для рабочего пространства stage
	$(MAKE) terraform WORKSPACE=$(WORKSPACE)
# Передаем на выполнение создание инфраструктуры для рабочего пространства
# stage без применения
#	$(MAKE) terraform-dry WORKSPACE=$(WORKSPACE)
# Передаем на выполнение применение плейбука ansible для рабочего
# пространства stage
	$(MAKE) ansible WORKSPACE=$(WORKSPACE)

# Задание для предварительных настроек Yandex.Cloud
yc_prepare: yc ssh_key_create

# Задание для предварительных настроек Yandex.Cloud
yc: yc_create_folder yc_set_profile yc_service_acc yc_service_adm_acc yc_create_s3 yc_make_key

# Задание для создания SSH-ключей для инстансов в каждом рабочем пространстве
ssh_key_create:
	mkdir -p $(SSH_PATH)
	mkdir -p $(SSH_PATH)/$(WORKSPACE)
	ssh-keygen -t rsa -q -f "$(SSH_PATH)/$(WORKSPACE)/id_rsa_vm" -N ""
	ssh-keygen -t rsa -q -f "$(SSH_PATH)/$(WORKSPACE)/id_rsa_vm-bastion" -N ""
	ssh-keygen -t rsa -q -f "$(SSH_PATH)/$(WORKSPACE)/id_rsa_k8s" -N ""

# Задание для создания папок prod, stage, backet в Yandex.Cloud
yc_create_folder:
ifneq ($(shell yc resource-manager folder list --format=json | jq -r '.[] | select(.name=="$(WORKSPACE)")' | jq -r '.name'), $(WORKSPACE))
	yc resource-manager folder create --name $(WORKSPACE)
endif

ifneq ($(shell yc resource-manager folder list --format=json | jq -r '.[] | select(.name=="$(WORKSPACE_BACKET)")' | jq -r '.name'), $(WORKSPACE_BACKET))
	yc resource-manager folder create --name $(WORKSPACE_BACKET)
endif

# Задание для конфигурирования профайла и его активации
yc_set_profile:
ifneq ($(YC_PROFILE), $(yandex_profile))
	@echo yc config profile create
	@yc config profile create $(yandex_profile)
endif
	@echo yc config set folder-id
	@yc config set folder-id $(YC_FOLDER_ID)

	@echo yc config set cloud-id
	@yc config set cloud-id $(yandex_cloud_id)

	@echo yc config set token
	@yc config set token $(yandex_token)
	@echo yc config set compute-default-zone
	@yc config set compute-default-zone $(yandex_zone)
# Создается сервисный аккаунт $(yandex_service_acc)
ifneq ($(shell yc iam service-account list --folder-name=$(WORKSPACE) --format=json | jq -r '.[] | select(.name=="$(WORKSPACE)-$(yandex_service_acc)")' | jq -r '.name'), $(WORKSPACE)-$(yandex_service_acc))
	yc iam service-account create --folder-name=$(WORKSPACE) --name $(WORKSPACE)-$(yandex_service_acc)
endif
# Создается сервисный аккаунт $(yandex_service_admin_acc)
ifneq ($(shell yc iam service-account list --folder-name=$(WORKSPACE) --format=json | jq -r '.[] | select(.name=="$(WORKSPACE)-$(yandex_service_admin_acc)")' | jq -r '.name'), $(WORKSPACE)-$(yandex_service_admin_acc))
	yc iam service-account create --folder-name=$(WORKSPACE) --name $(WORKSPACE)-$(yandex_service_admin_acc)
endif
	@echo yc config profile activate
	@yc config profile activate $(yandex_profile)

# Задание для добавления роли editor и доступа к папкам $(YC_FOLDER_ID),
# $(WORKSPACE_BACKET) для сервисного аккаунта $(yandex_service_acc)
yc_service_acc:
	yc resource-manager folder add-access-binding $(YC_FOLDER_ID) --role editor --subject serviceAccount:$(YC_SERVICE_ACC_ID)
	yc resource-manager folder add-access-binding $(WORKSPACE_BACKET) --role editor --subject serviceAccount:$(YC_SERVICE_ACC_ID)
# Задание для добавления роли editor и доступа к папкам $(YC_FOLDER_ID)
# для сервисного аккаунта $(yandex_service_admin_acc)
yc_service_adm_acc:
	yc resource-manager folder add-access-binding $(YC_FOLDER_ID) --role admin --subject serviceAccount:$(YC_SERVICE_ACC_ADM_ID)
# Задание для создания бакета для бэкенда
yc_create_s3:
ifneq ($(YC_STORAGE_BUCKET), $(yandex_s3_bucket))
	yc storage bucket create --folder-name=$(WORKSPACE_BACKET) --name $(yandex_s3_bucket)
endif
#Задание для создания ключей доступа сервисных аккаунтов
yc_make_key:
	mkdir -p $(TF_PATH_KEY)
	mkdir -p $(TF_PATH_KEY)/$(WORKSPACE)
	mkdir -p $(TF-INFRA_PATH)
	mkdir -p $(ATLANTIS_PATH)
	mkdir -p $(ATLANTIS_PATH)/$(WORKSPACE)
	yc iam key create --service-account-name $(WORKSPACE)-$(yandex_service_admin_acc) --folder-name=$(WORKSPACE) --output $(TF_PATH_KEY)/$(WORKSPACE)/key_admin.json
	yc iam key create --service-account-name $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE) --output $(TF_PATH_KEY)/$(WORKSPACE)/key_editor.json
	yc iam access-key create --service-account-name $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE) --format json > $(TF_PATH_KEY)/$(WORKSPACE)/sa-key.json
	yc config set service-account-key $(TF_PATH_KEY)/$(WORKSPACE)/key_admin.json
	@echo yc config set token
	@yc config set token $(yandex_token)
#Задание для создания ключа доступа сервисного аккаунта для K8s
yc_key_registry:
	mkdir -p $(K8S_PATH)/$(WORKSPACE)
	yc iam key create --service-account-name $(WORKSPACE)-sa-k8s --folder-name=$(WORKSPACE) -o $(K8S_PATH)/$(WORKSPACE)/key.json

# Задание для выполнения создания инфраструктуры для рабочего пространства
# без применения
terraform-dry:	tf_init tf_workspace tf_plan
# Задание для выполнения создания инфраструктуры для рабочего пространства
terraform: tf_init tf_workspace tf_plan tf_apply yc_key_registry

# Задание для выполнения создания инфраструктуры для рабочего пространства
# и применения плейбука ansible
tf_ansible: tf_plan tf_apply yc_key_registry ansible

# Задание для выполнения удаления, создания инфраструктуры для рабочего
# пространства и применения плейбука ansible
tf_destroy_ansible: tf_destroy tf_plan tf_apply yc_key_registry ansible

debug:
	@echo $(yandex_profile)
	@echo $(yandex_token)

# Передаем на выполнение команду Terraform upgrade
tf_upgrade:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) upgrade
# Передаем на выполнение команду Terraform init для текущего рабочего
# пространства
tf_init:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) init WORKSPACE=$(WORKSPACE)
# Задание для выполнения создания нового рабочего пространства и
# его последующий выбор
tf_workspace: tf_workspace_new tf_workspace_select
# Передаем на выполнение создание нового рабочего пространства из
# переменной WORKSPACE
tf_workspace_new:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) workspace_new WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду выбора рабочего пространства из
# переменной WORKSPACE
tf_workspace_select:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) workspace_select WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду Terraform plan для текущего рабочего
# пространства в папке с ID $(YC_FOLDER_ID)
tf_plan:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) plan YC_FOLDER_ID=$(YC_FOLDER_ID)
# Передаем на выполнение команду Terraform apply для текущего рабочего
# пространства в папке с ID $(YC_FOLDER_ID)
tf_apply:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) apply YC_FOLDER_ID=$(YC_FOLDER_ID)
# Задание для выполнения удаления инфраструктуры рабочего пространства
# в папке с ID $(YC_FOLDER_ID)
tf_destroy:
	$(MAKE) tf_workspace_select
	$(MAKE) k8s_delete_app
	$(MAKE) yc_delete_image
	$(MAKE) yc_delete_registry
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) destroy YC_FOLDER_ID=$(YC_FOLDER_ID)

# Передаем на выполнение команду Terraform refresh
tf_refresh:
	$(MAKE) -C $(TF_PATH) -f $(TF_MK) refresh WORKSPACE=$(WORKSPACE) YC_FOLDER_ID=$(YC_FOLDER_ID)
# Передаем на выполнение команду для выполнения основного плейбука
# Ansible для рабочего пространства из переменной WORKSPACE
ansible:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) apply WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду для выполнения плейбука Ansible
# для настройки GitLab для рабочего пространства из переменной WORKSPACE
# с использованием API_TOKEN
gitlab_set_settings:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) gitlab_set_settings WORKSPACE=$(WORKSPACE) API_TOKEN=$(API_TOKEN)
# Задание для выполнения удаления образов из реестра контейнеров
yc_delete_image:
	$(shell yc container image list --folder-name=$(WORKSPACE) --format=json | jq -r .[].id | while read id ; do yc container image delete $$id --folder-name=$(WORKSPACE); done)
# Задание для выполнения удаления реестра контейнеров
yc_delete_registry:
	$(shell yc container registry list --folder-name=$(WORKSPACE) --format=json | jq -r .[].id | while read id ; do yc container registry delete $$id --folder-name=$(WORKSPACE); done)
# Задание для выполнения удаления приложений из кластера
k8s_delete_app:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) k8s_delete_app WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команду выполнения плейбука Ansible для подготовки системы мониторинга
monitoring:
	$(MAKE) -C $(ANSIBLE_PATH) -f $(ANSIBLE_MK) monitoring WORKSPACE=$(WORKSPACE)
# Передаем на выполнение команды последовательного удаления созданой инфраструктуры инфраструктуры
clean:
	$(MAKE) tf_destroy WORKSPACE=stage
	$(MAKE) tf_destroy WORKSPACE=prod
	$(MAKE) del WORKSPACE=stage
	$(MAKE) del WORKSPACE=prod
	$(MAKE) purge

# Задание для выполнения удаления созданой инфраструктуры дефолтного рабочего
# пространства, или переданного через переменную WORKSPACE
clean_wspc: tf_destroy del

# Задача для удаления каталогов и сервисных аккаунтов дефолтного рабочего
# пространства, или переданного через переменную WORKSPACE
del:
	@rm -rf $(SSH_PATH)/$(WORKSPACE)
	@rm -rf $(TF_PATH_KEY)/$(WORKSPACE)
	@rm -rf $(K8S_PATH)/$(WORKSPACE)
	@rm -rf $(K8S_PATH)/atlantis/$(WORKSPACE)

	yc iam service-account delete --name $(WORKSPACE)-$(yandex_service_admin_acc) --folder-name=$(WORKSPACE)
	yc iam service-account delete --name $(WORKSPACE)-$(yandex_service_acc) --folder-name=$(WORKSPACE)

# Задание для окончательной очистки всех созданных файлов
# и удаления бакета хранения настроек бэкенда
purge:
	@rm -rf $(TF_PATH)/.terraform
	@rm -rf $(TF_PATH)/.terraform.lock.hcl
	@rm -rf $(TF-INFRA_PATH)
	@rm -rf $(TF_PATH_KEY)
	@rm -rf $(SSH_PATH)
	@rm -rf $(ATLANTIS_PATH)
```

</details>

Основные варианты запуска:

- `make` - запуск `Makefile` без аргументов, приводит к выполнению всех стадий описанных в цели `all`;
- `make yc_prepare WORKSPACE=<workspace_name>` - выполняет предварительные настройки Yandex.Cloud для рабочего пространства;
- `make terraform WORKSPACE=<workspace_name>` - выполняет создание инфраструктуры для рабочего пространства;
- `make terraform-dry WORKSPACE=<workspace_name>` - выполняет создание инфраструктуры для рабочего пространства, без выполнения команды применнить;
- `make ansible WORKSPACE=<workspace_name>` - выполняет основной плейбук Ansible для рабочего пространства из переменной;
- `make clean` - выполняет удаление инфраструктуры в Yandex.Cloud и созданных локальных файлов;
- `make gitlab_set_settings WORKSPACE=<workspace_name> API_TOKEN=<api_token>` - выполняет настройку сервера GitLab, добавляет пользователя, проекты и т.д.;
- `make monitoring WORKSPACE=<workspace_name>` - выполняет настройку системы мониторинга.

---
### Предварительная настройка Yandex.Cloud

Запуск `Makefile` без аргументов с помощью ввода команды `make` в корне проекта, проходит следующие стадии:

1. Предварительная настройка Yandex.Cloud для рабочего окружения `stage`
1. Предварительная настройка Yandex.Cloud для рабочего окружения `prod`
1. Создание SSH-ключей для доступа к инстансам облачной инфрастуктуры
1. Создание облачной инфрастуктуры в Yandex.Cloud с помощью Terraform для рабочего окружения `stage`
1. Создание ключа доступа для сервисного аккаунта K8s
1. Запуск основного плейбука Ansible - [provision.yml](./ansible/provision.yml)

Остановимся подробнее на предварительных настройках Yandex.Cloud.

В предварительные настройки Yandex.Cloud входят следующие этапы:

- Создание папок `prod`, `stage`, `backet` в Yandex.Cloud
- Конфигурирование профайла `yandex_profile` и его активация
    - Создание профайла `yandex_profile` если его нет
    - Установка идентификатора папки
    - Установка идентификатора облака `yandex_cloud_id`
    - Установка токена доступа `yandex_token`
    - Установка зоны `yandex_zone` по умолчанию
    - Создание сервисного аккаунта `yandex_service_acc`
    - Создание сервисного аккаунта `yandex_service_admin_acc`
- Добавление доступа к созданым папкам для сервисного аккаунта `yandex_service_acc`, назначение роли `editor`
- Добавление доступа к созданым папкам для сервисного аккаунта `yandex_service_admin_acc`, назначение роли `admin`
- Создание бакета для бэкенда `yandex_s3_bucket`
- Создание ключей доступа для сервисных аккаунтов

<details>
<summary>Лог настройки окружения stage</summary>

```bash
❯ make yc_prepare WORKSPACE=stage
yc config set folder-id
yc config set cloud-id
yc config set token
yc config set compute-default-zone
yc iam service-account create --folder-name=stage --name stage-service-acc01
done (2s)
id: ajea4hac2tdeed3td6qo
folder_id: b1g46p68fqnpm8de1po5
created_at: "2023-12-18T10:20:07.181402349Z"
name: stage-service-acc01

yc iam service-account create --folder-name=stage --name stage-service-admin-acc01
done (2s)
id: aje552vk808odn1oqjs5
folder_id: b1g46p68fqnpm8de1po5
created_at: "2023-12-18T10:20:11.702938091Z"
name: stage-service-admin-acc01

yc config profile activate
Profile 'profile01' activated
yc resource-manager folder add-access-binding b1g46p68fqnpm8de1po5 --role editor --subject serviceAccount:ajea4hac2tdeed3td6qo
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: editor
      subject:
        id: ajea4hac2tdeed3td6qo
        type: serviceAccount

yc resource-manager folder add-access-binding backet --role editor --subject serviceAccount:ajea4hac2tdeed3td6qo
done (4s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: editor
      subject:
        id: ajea4hac2tdeed3td6qo
        type: serviceAccount

yc resource-manager folder add-access-binding b1g46p68fqnpm8de1po5 --role admin --subject serviceAccount:aje552vk808odn1oqjs5
done (3s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: admin
      subject:
        id: aje552vk808odn1oqjs5
        type: serviceAccount

yc storage bucket create --folder-name=backet --name backend01
name: backend01
folder_id: b1geov2lo8i7sc6mo8hl
anonymous_access_flags:
  read: false
  list: false
default_storage_class: STANDARD
versioning: VERSIONING_DISABLED
acl: {}
created_at: "2023-12-18T10:20:41.882732Z"

mkdir -p ./tf/key
mkdir -p ./tf/key/stage
mkdir -p ./tf-infra
mkdir -p ./k8s/atlantis
mkdir -p ./k8s/atlantis/stage
yc iam key create --service-account-name stage-service-admin-acc01 --folder-name=stage --output ./tf/key/stage/key_admin.json
id: aje7h6n9d0s0tu73bsk9
service_account_id: aje552vk808odn1oqjs5
created_at: "2023-12-18T10:20:45.949764794Z"
key_algorithm: RSA_2048

yc iam key create --service-account-name stage-service-acc01 --folder-name=stage --output ./tf/key/stage/key_editor.json
id: aje3pcrp4ae1fdu6b1dk
service_account_id: ajea4hac2tdeed3td6qo
created_at: "2023-12-18T10:20:49.064984813Z"
key_algorithm: RSA_2048

yc iam access-key create --service-account-name stage-service-acc01 --folder-name=stage --format json > ./tf/key/stage/sa-key.json
yc config set service-account-key ./tf/key/stage/key_admin.json
yc config set token
mkdir -p ./ssh_key
mkdir -p ./ssh_key/stage
ssh-keygen -t rsa -q -f "./ssh_key/stage/id_rsa_vm" -N ""
ssh-keygen -t rsa -q -f "./ssh_key/stage/id_rsa_vm-bastion" -N ""
ssh-keygen -t rsa -q -f "./ssh_key/stage/id_rsa_k8s" -N ""
```

</details>

<details>
<summary>Лог настройки окружения prod</summary>

```bash
❯ make yc_prepare WORKSPACE=prod
yc config set folder-id
yc config set cloud-id
yc config set token
yc config set compute-default-zone
yc iam service-account create --folder-name=prod --name prod-service-acc01
done (2s)
id: ajenl2fcffuci2he3a0m
folder_id: b1goqjg5690l79aeo0l7
created_at: "2023-12-18T10:21:25.183869832Z"
name: prod-service-acc01

yc iam service-account create --folder-name=prod --name prod-service-admin-acc01
done (1s)
id: aje7p494jm8bg8h4pq86
folder_id: b1goqjg5690l79aeo0l7
created_at: "2023-12-18T10:21:28.856515359Z"
name: prod-service-admin-acc01

yc config profile activate
Profile 'profile01' activated
yc resource-manager folder add-access-binding b1goqjg5690l79aeo0l7 --role editor --subject serviceAccount:ajenl2fcffuci2he3a0m
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: editor
      subject:
        id: ajenl2fcffuci2he3a0m
        type: serviceAccount

yc resource-manager folder add-access-binding backet --role editor --subject serviceAccount:ajenl2fcffuci2he3a0m
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: editor
      subject:
        id: ajenl2fcffuci2he3a0m
        type: serviceAccount

yc resource-manager folder add-access-binding b1goqjg5690l79aeo0l7 --role admin --subject serviceAccount:aje7p494jm8bg8h4pq86
done (2s)
effective_deltas:
  - action: ADD
    access_binding:
      role_id: admin
      subject:
        id: aje7p494jm8bg8h4pq86
        type: serviceAccount

mkdir -p ./tf/key
mkdir -p ./tf/key/prod
mkdir -p ./tf-infra
mkdir -p ./k8s/atlantis
mkdir -p ./k8s/atlantis/prod
yc iam key create --service-account-name prod-service-admin-acc01 --folder-name=prod --output ./tf/key/prod/key_admin.json
id: ajebbgjm25h2fegiiq4c
service_account_id: aje7p494jm8bg8h4pq86
created_at: "2023-12-18T10:21:53.919478596Z"
key_algorithm: RSA_2048

yc iam key create --service-account-name prod-service-acc01 --folder-name=prod --output ./tf/key/prod/key_editor.json
id: aje7shdagrh9p99ka6vr
service_account_id: ajenl2fcffuci2he3a0m
created_at: "2023-12-18T10:21:57.008918254Z"
key_algorithm: RSA_2048

yc iam access-key create --service-account-name prod-service-acc01 --folder-name=prod --format json > ./tf/key/prod/sa-key.json
yc config set service-account-key ./tf/key/prod/key_admin.json
yc config set token
mkdir -p ./ssh_key
mkdir -p ./ssh_key/prod
ssh-keygen -t rsa -q -f "./ssh_key/prod/id_rsa_vm" -N ""
ssh-keygen -t rsa -q -f "./ssh_key/prod/id_rsa_vm-bastion" -N ""
ssh-keygen -t rsa -q -f "./ssh_key/prod/id_rsa_k8s" -N ""
```

</details>

---
### Создание облачной инфраструктуры

После успешных предварительных настроек Yandex.Cloud, скрипт сборки `Makefile` переходит к созданию облачной инфраструктуры.

- Запускается инициализация Terraform в папке `tf` с аргументами для конфигурирования бэкенда в Yandex.Bucket

```bash
terraform init -reconfigure -backend-config="bucket=$(yandex_s3_bucket)" -backend-config="access_key" -backend-config="secret_key"
```

- Создается рабочее пространство `prod` и `stage`
- Выбирается `stage` как текущее рабочее пространство
- Запускается создание Terraform плана командой ниже

```bash
terraform plan -var-file="$(TF_PATH).tfvars" -var "yandex_folder_id=$(YC_FOLDER_ID)"
```

В качестве аргументов передаются файл `.tfvars` с переменными и переменная с идентификатором папки текущего рабочего пространства `yandex_folder_id`.

<details>
<summary>Лог создания Terraform плана окружения stage</summary>

```bash
/Applications/Xcode.app/Contents/Developer/usr/bin/make terraform WORKSPACE=stage
/Applications/Xcode.app/Contents/Developer/usr/bin/make -C ./tf -f terraform.mk init WORKSPACE=stage

stage
terraform init -reconfigure -backend-config=bucket=backend01 -backend-config=access_key -backend-config=secret_key

Initializing the backend...

Successfully configured the backend "s3"! Terraform will automatically
use this backend unless the backend configuration changes.
Initializing modules...
- k8s in modules/k8s-yc
- vm-bastion in modules/vm
- vm-gitlab in modules/vm

Initializing provider plugins...
- Finding yandex-cloud/yandex versions matching ">= 0.70.0"...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.4.1...
- Installed hashicorp/local v2.4.1 (unauthenticated)
- Installing yandex-cloud/yandex v0.104.0...
- Installed yandex-cloud/yandex v0.104.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

╷
│ Warning: Incomplete lock file information for providers
│
│ Due to your customized provider installation methods, Terraform was forced to calculate lock file checksums locally for the
│ following providers:
│   - hashicorp/local
│   - yandex-cloud/yandex
│
│ The current .terraform.lock.hcl file only includes checksums for darwin_amd64, so Terraform running on another platform will fail
│ to install these providers.
│
│ To calculate additional checksums for another platform, run:
│   terraform providers lock -platform=linux_amd64
│ (where linux_amd64 is the platform to generate)
╵

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=darwin_arm64 yandex-cloud/yandex
- Fetching yandex-cloud/yandex 0.104.0 for darwin_arm64...
- Retrieved yandex-cloud/yandex 0.104.0 for darwin_arm64 (unauthenticated)
- Obtained yandex-cloud/yandex checksums for darwin_arm64; Additional checksums for this platform are now tracked in the lock file

Success! Terraform has updated the lock file.

Review the changes in .terraform.lock.hcl and then commit to your
version control system to retain the new checksums.

/Applications/Xcode.app/Contents/Developer/usr/bin/make -C ./tf -f terraform.mk workspace_new WORKSPACE=stage
terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
/Applications/Xcode.app/Contents/Developer/usr/bin/make -C ./tf -f terraform.mk workspace_select WORKSPACE=stage
terraform workspace select stage
/Applications/Xcode.app/Contents/Developer/usr/bin/make -C ./tf -f terraform.mk plan YC_FOLDER_ID=b1g46p68fqnpm8de1po5
terraform plan -var-file="./.tfvars" -var "yandex_folder_id=b1g46p68fqnpm8de1po5"

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # local_file.inventory will be created
  + resource "local_file" "inventory" {
      + content              = (known after apply)
      + content_base64sha256 = (known after apply)
      + content_base64sha512 = (known after apply)
      + content_md5          = (known after apply)
      + content_sha1         = (known after apply)
      + content_sha256       = (known after apply)
      + content_sha512       = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0777"
      + filename             = "../ansible/stage-inventory"
      + id                   = (known after apply)
    }

  # yandex_container_registry.my-registry will be created
  + resource "yandex_container_registry" "my-registry" {
      + created_at = (known after apply)
      + folder_id  = "b1g46p68fqnpm8de1po5"
      + id         = (known after apply)
      + labels     = {
          + "my-label" = "stage-my-registry"
        }
      + name       = "stage-registry"
      + status     = (known after apply)
    }

  # yandex_dns_recordset.rs-aname-1 will be created
  + resource "yandex_dns_recordset" "rs-aname-1" {
      + data    = (known after apply)
      + id      = (known after apply)
      + name    = "*"
      + ttl     = 200
      + type    = "A"
      + zone_id = (known after apply)
    }

  # yandex_dns_zone.zone1 will be created
  + resource "yandex_dns_zone" "zone1" {
      + created_at       = (known after apply)
      + folder_id        = (known after apply)
      + id               = (known after apply)
      + name             = "bdvsun-ru"
      + private_networks = (known after apply)
      + public           = true
      + zone             = "stage.bdvsun.ru."
    }

  # yandex_iam_service_account.sa-k8s will be created
  + resource "yandex_iam_service_account" "sa-k8s" {
      + created_at  = (known after apply)
      + description = "service account for access to k8s"
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + name        = "stage-sa-k8s"
    }

  # yandex_kms_symmetric_key.kms-key will be created
  + resource "yandex_kms_symmetric_key" "kms-key" {
      + created_at          = (known after apply)
      + default_algorithm   = "AES_128"
      + deletion_protection = false
      + folder_id           = (known after apply)
      + id                  = (known after apply)
      + name                = "stage-kms-key"
      + rotated_at          = (known after apply)
      + rotation_period     = "8760h"
      + status              = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.alb-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "alb-editor" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "alb.editor"
    }

  # yandex_resourcemanager_folder_iam_member.compute-viewer will be created
  + resource "yandex_resourcemanager_folder_iam_member" "compute-viewer" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "compute.viewer"
    }

  # yandex_resourcemanager_folder_iam_member.editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "editor" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "editor"
    }

  # yandex_resourcemanager_folder_iam_member.images-puller will be created
  + resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "container-registry.images.puller"
    }

  # yandex_resourcemanager_folder_iam_member.images-pusher will be created
  + resource "yandex_resourcemanager_folder_iam_member" "images-pusher" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "container-registry.images.pusher"
    }

  # yandex_resourcemanager_folder_iam_member.k8s-clusters-agent will be created
  + resource "yandex_resourcemanager_folder_iam_member" "k8s-clusters-agent" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "k8s.clusters.agent"
    }

  # yandex_resourcemanager_folder_iam_member.viewer will be created
  + resource "yandex_resourcemanager_folder_iam_member" "viewer" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "viewer"
    }

  # yandex_resourcemanager_folder_iam_member.vpc-public-admin will be created
  + resource "yandex_resourcemanager_folder_iam_member" "vpc-public-admin" {
      + folder_id = "b1g46p68fqnpm8de1po5"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "vpc.publicAdmin"
    }

  # yandex_vpc_gateway.nat_gateway will be created
  + resource "yandex_vpc_gateway" "nat_gateway" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "gateway"

      + shared_egress_gateway {}
    }

  # yandex_vpc_network.net-master will be created
  + resource "yandex_vpc_network" "net-master" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "stage-network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.net-router will be created
  + resource "yandex_vpc_route_table" "net-router" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "stage-router"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + gateway_id         = (known after apply)
        }
    }

  # yandex_vpc_security_group.k8s-main-sg will be created
  + resource "yandex_vpc_security_group" "k8s-main-sg" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "stage-k8s-main-sg"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description    = "Разрешен весь исходящий трафик."
          + from_port      = 0
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "ANY"
          + to_port        = 65535
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }

      + ingress {
          + description       = "Проверка доступности с диапазона адресов балансировщика нагрузки. Нужно для работы отказоустойчивого кластера и сервисов балансировщика."
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "loadbalancer_healthchecks"
          + protocol          = "TCP"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
        }
      + ingress {
          + description       = "Разрешено взаимодействие мастер-узел и узел-узел внутри группы безопасности."
          + from_port         = 0
          + id                = (known after apply)
          + labels            = (known after apply)
          + port              = -1
          + predefined_target = "self_security_group"
          + protocol          = "ANY"
          + to_port           = 65535
          + v4_cidr_blocks    = []
          + v6_cidr_blocks    = []
        }
      + ingress {
          + description    = "Разрешено взаимодействие под-под и сервис-сервис."
          + from_port      = 0
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "ANY"
          + to_port        = 65535
          + v4_cidr_blocks = [
              + "10.96.0.0/16",
              + "10.112.0.0/16",
              + "192.168.0.0/16",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "Разрешены отладочные ICMP-пакеты из внутренних подсетей."
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "ICMP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "192.168.0.0/16",
              + "172.16.0.0/12",
              + "10.0.0.0/8",
            ]
          + v6_cidr_blocks = []
        }
    }

  # yandex_vpc_security_group.k8s-master-whitelist will be created
  + resource "yandex_vpc_security_group" "k8s-master-whitelist" {
      + created_at  = (known after apply)
      + description = "Разрешен доступ к API Kubernetes из интернета."
      + folder_id   = (known after apply)
      + id          = (known after apply)
      + labels      = (known after apply)
      + name        = "stage-k8s-master-whitelist"
      + network_id  = (known after apply)
      + status      = (known after apply)

      + ingress {
          + description    = "Разрешено подключение к API Kubernetes через порт 443."
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 443
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "Разрешено подключение к API Kubernetes через порт 6443."
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 6443
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
    }

  # yandex_vpc_security_group.k8s-public-services will be created
  + resource "yandex_vpc_security_group" "k8s-public-services" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "stage-k8s-public-services"
      + network_id = (known after apply)
      + status     = (known after apply)

      + ingress {
          + description    = "Разрешен входящий трафик из интернета на диапазон портов NodePort."
          + from_port      = 30000
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "TCP"
          + to_port        = 32767
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
    }

  # yandex_vpc_security_group.net-router-sg will be created
  + resource "yandex_vpc_security_group" "net-router-sg" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "stage-net-router-sg"
      + network_id = (known after apply)
      + status     = (known after apply)

      + egress {
          + description    = "Доступны все исходящие запросы"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "ANY"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }

      + ingress {
          + description    = "22 порт доступен для SSH"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 22
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "443 порт доступен для HTTPS трафика"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 443
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "53 порт доступен для DNS"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 53
          + protocol       = "UDP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "80 порт доступен для HTTP трафика"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 80
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "GitLab на 4433 порту"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 4433
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "ext-http"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = 8080
          + protocol       = "TCP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
      + ingress {
          + description    = "Разрешены отладочные ICMP-пакеты"
          + from_port      = -1
          + id             = (known after apply)
          + labels         = (known after apply)
          + port           = -1
          + protocol       = "ICMP"
          + to_port        = -1
          + v4_cidr_blocks = [
              + "0.0.0.0/0",
            ]
          + v6_cidr_blocks = []
        }
    }

  # yandex_vpc_subnet.subnet-k8s["a"] will be created
  + resource "yandex_vpc_subnet" "subnet-k8s" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "stage-subnet-k8s-a"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-k8s["b"] will be created
  + resource "yandex_vpc_subnet" "subnet-k8s" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "stage-subnet-k8s-b"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-b"
    }

  # yandex_vpc_subnet.subnet-k8s["c"] will be created
  + resource "yandex_vpc_subnet" "subnet-k8s" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "stage-subnet-k8s-c"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.30.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-c"
    }

  # yandex_vpc_subnet.subnet-main will be created
  + resource "yandex_vpc_subnet" "subnet-main" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "stage-subnet-main"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.1.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # module.k8s.yandex_kubernetes_cluster.cluster will be created
  + resource "yandex_kubernetes_cluster" "cluster" {
      + cluster_ipv4_range       = "10.96.0.0/16"
      + cluster_ipv6_range       = (known after apply)
      + created_at               = (known after apply)
      + description              = (known after apply)
      + folder_id                = "b1g46p68fqnpm8de1po5"
      + health                   = (known after apply)
      + id                       = (known after apply)
      + labels                   = (known after apply)
      + log_group_id             = (known after apply)
      + name                     = "stage-regional-cluster"
      + network_id               = (known after apply)
      + node_ipv4_cidr_mask_size = 24
      + node_service_account_id  = (known after apply)
      + release_channel          = "STABLE"
      + service_account_id       = (known after apply)
      + service_ipv4_range       = "10.112.0.0/16"
      + service_ipv6_range       = (known after apply)
      + status                   = (known after apply)

      + master {
          + cluster_ca_certificate = (known after apply)
          + etcd_cluster_size      = (known after apply)
          + external_v4_address    = (known after apply)
          + external_v4_endpoint   = (known after apply)
          + external_v6_endpoint   = (known after apply)
          + internal_v4_address    = (known after apply)
          + internal_v4_endpoint   = (known after apply)
          + public_ip              = true
          + security_group_ids     = (known after apply)
          + version                = "1.27"
          + version_info           = (known after apply)

          + maintenance_policy {
              + auto_upgrade = true
            }

          + regional {
              + region = "ru-central1"

              + location {
                  + subnet_id = (known after apply)
                  + zone      = "ru-central1-a"
                }
              + location {
                  + subnet_id = (known after apply)
                  + zone      = "ru-central1-b"
                }
              + location {
                  + subnet_id = (known after apply)
                  + zone      = "ru-central1-c"
                }
            }
        }
    }

  # module.k8s.yandex_kubernetes_node_group.node_groups["k8s-node"] will be created
  + resource "yandex_kubernetes_node_group" "node_groups" {
      + cluster_id        = (known after apply)
      + created_at        = (known after apply)
      + description       = (known after apply)
      + id                = (known after apply)
      + instance_group_id = (known after apply)
      + labels            = (known after apply)
      + name              = "k8s-node"
      + status            = (known after apply)
      + version           = "1.27"
      + version_info      = (known after apply)

      + allocation_policy {
          + location {
              + subnet_id = (known after apply)
              + zone      = "ru-central1-a"
            }
          + location {
              + subnet_id = (known after apply)
              + zone      = "ru-central1-b"
            }
          + location {
              + subnet_id = (known after apply)
              + zone      = "ru-central1-c"
            }
        }

      + instance_template {
          + metadata                  = {
              + "user-data" = <<-EOT
                    #cloud-config
                    users:
                      - name: k8s_user
                        groups: sudo
                        shell: /bin/bash
                        sudo: 'ALL=(ALL) NOPASSWD:ALL'
                        ssh-authorized-keys:
                          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyUM1iLOCmFTqhSlquKbXkver70NdjeQ+rfw3/KTXu04ZQdO49NFUID5QYuu0jy3rJIk8k+tK5NFIlU/its1oDxa3gbdqnxsm81YOQtjdM+2moXthK4TwAq/m3QlO8+jxZIEYmSpzEyhrmNowxWezM/5yCBsKFGXbGqcjHKMdYznjdJUwxqZQYGvMtXMLNEdoQmQWntAY4vyNoFrvyD52kS/GpF3vV2+0SoUBOPHYpMTOJQFsBHmOoHC0IsYEzRMQcILM4wJIkKK8v6i4cSmIIgaYF2lMXagjrIY2ACcKEgzhALspk7KCxuxOklWVg91jpVOjI0DpKqXrx4AbMTx8N bdv@BDV.local
                EOT
            }
          + nat                       = (known after apply)
          + network_acceleration_type = (known after apply)
          + platform_id               = "standard-v2"

          + boot_disk {
              + size = 30
              + type = "network-hdd"
            }

          + network_interface {
              + ipv4               = true
              + ipv6               = (known after apply)
              + nat                = (known after apply)
              + security_group_ids = (known after apply)
              + subnet_ids         = (known after apply)
            }

          + resources {
              + core_fraction = 20
              + cores         = 2
              + gpus          = 0
              + memory        = 2
            }

          + scheduling_policy {
              + preemptible = false
            }
        }

      + maintenance_policy {
          + auto_repair  = true
          + auto_upgrade = true
        }

      + scale_policy {
          + fixed_scale {
              + size = 3
            }
        }
    }

  # module.vm-bastion.yandex_compute_instance.vm will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "Bastion"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "user-data" = <<-EOT
                #cloud-config
                users:
                  - name: bastion_user
                    groups: sudo
                    shell: /bin/bash
                    sudo: 'ALL=(ALL) NOPASSWD:ALL'
                    ssh-authorized-keys:
                      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtwvFRZ3FvMvMnSSAirUpnv+9O1yp2Jd5dLJMzxV7WYf3GDsITgclQOlRyimYjf/mVdTj9fdHTVIOrI/pLNSqRNiU7KaeMAzFY9wihgZDiPB4pbiUJAWSwSir0S++cjoLqfK/Z+rPY2ei4to2iLDo4+wYSs963fAPDelIpX4FAnE4oTad1BOS+sOdya7RTpUoHarRyiZ1k0jKPSEWZLbysZuSbfbWF2fsC4jb2llf6rctY1TKd+pBd1o1C1jmhiScSYEq7wWPx25Q14z9UG+6noGNw7Evzn4BUNJZkQnp1Gb4wsf36AyAGkFPMjjaGbmBtXcRvEJVRkDgMPbPAH8QF bdv@BDV.local
            EOT
        }
      + name                      = "stage-bastion"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = "bastion_user"
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80mrhj8fl2oe87o4e1"
              + name        = (known after apply)
              + size        = 8
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.1.254"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 5
          + cores         = 2
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = false
        }
    }

  # module.vm-gitlab.yandex_compute_instance.vm will be created
  + resource "yandex_compute_instance" "vm" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + description               = "GitLab + GitLab-Runner"
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "user-data" = <<-EOT
                #cloud-config
                users:
                  - name: gitlab_user
                    groups: sudo
                    shell: /bin/bash
                    sudo: 'ALL=(ALL) NOPASSWD:ALL'
                    ssh-authorized-keys:
                      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr/Il//oBa/0FU+3oMgNxyH8BXPISmFEaPp7jnmnQpAd5oPm4s8lDAnlUZVTNw6T1802UtM+g+Kt6pC6rr1dvTumIx2n89IA8QlcnqFvEbvdZk9jJNajBp9xpIQpRwplhT4sBTBc+0yOOV/MG7St2yQPc7jCN0pQYnHbWuZPulq3RG0m2gErmdSAfpZEJN+oPxngX8JJIsuQw8y2rdoDhWNE2uP+guBgIJIgUM3KJRB5tM9eqebKKV5Mfk5TCO4U2IUx6lMPg/AizFswzh49Tq91TKIyhBl/MbBOTbMpeup0XnPs/s2+aNmlDDPPrWoXRUnksJB37aknbDPMQN49DL bdv@BDV.local
            EOT
        }
      + name                      = "stage-vm-gitlab"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = "gitlab_user"
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8q5m87s3v0hmp06i5c"
              + name        = (known after apply)
              + size        = 64
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = "192.168.1.11"
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = false
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = false
        }
    }

Plan: 29 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip = (known after apply)
```

</details>
<br>

- Запускается применение Terraform плана командой `terraform apply -auto-approve -var-file="$(TF_PATH).tfvars" -var "yandex_folder_id=$(YC_FOLDER_ID)"`

---
### Создание Kubernetes кластера

В файле [instance.tf](./tf/instance.tf) содержится описание ресурсов для создания кластера Kubernetes

---
### Созданная инфраструктура в Yandex.Cloud

После создания инфраструктуры, в консоле управления Yandex.Cloud, можно увидеть созданные ресурсы:

<details>
<summary>Бакет backend</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-bucket-backend.jpeg">
</p>
</details>

<details>
<summary>Сервисы рабочего пространства stage</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-all.jpeg">
</p>
</details>

<details>
<summary>CloudDNS (зона и записи)</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-cloud_dns-zone.jpeg">
  <img width="100%", src="./img/yc/yc-stage-cloud_dns-zone-bdvsun-ru.jpeg">
</p>
</details>

<details>
<summary>Виртуальные машины</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-compute_cloud.jpeg">
</p>
</details>

<details>
<summary>Реестр контейнеров</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-container_registry.jpeg">
</p>
</details>

<details>
<summary>Региональный кластер K8s</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-k8s.jpeg">
</p>
</details>

<details>
<summary>Группа рабочих узлов кластера K8s</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-node_group.jpeg">
</p>
</details>

<details>
<summary>Рабочие узлы кластера K8s</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-nodes.jpeg">
</p>
</details>

<details>
<summary>Симметричный ключ</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-kms.jpeg">
</p>
</details>

<details>
<summary>Таблица маршрутизации</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-vpc-route_table.jpeg">
</p>
</details>

<details>
<summary>Группа безопасности</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-vpc-sg.jpeg">
</p>
</details>

<details>
<summary>Облачные сети</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-vpc.jpeg">
</p>
</details>

<details>
<summary>Подсети</summary>
<p align="center">
  <img width="100%", src="./img/yc/yc-stage-vpc-subnet.jpeg">
</p>
</details>

---
### Настройка инстансов

Инстансы созданные в облаке Yandex.Cloud, в текущем проекте, настраиваются с помощью плейбуков Ansible.

Команда `make ansible` сделает основную настройку всех хостов описаных в файле `inventory`.

---
### Создание тестового приложения

Демонстрационное приложение представляет собой статическую html страницу с выводом текста и изображения.

```bash
cd ./app/demo-project
❯ tree
.
├── README.md
├── changelog
│   └── 1.0.0.md
├── k8s.yml
├── src
│   ├── Dockerfile
│   ├── index.html
│   └── water.jpg
└── version.json
```

Основная html страница index.html

```HTML
<!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <title>Test project</title>
        </head>
        <body>
          <h1>Test project</h1>
          <div>
            <img
              src="water.jpg"
              alt="Test picture"
              style="max-height: 600px"
            />
          </div>
         </body>
      </html>
```

---
### Подготовка cистемы мониторинга

Выполнение команды `make monitoring` приведет к деплою сервисов мониторинга в кластер K8s и их настройку для рабочего окружения по умолчанию.

Дашборд деплоится в кластер K8s как объект ConfigMap с помощью команды `kubectl`.

<details>
<summary>Дашборд Grafana</summary>
<p align="center">
  <img width="100%", src="./img/monitoring/monitoring-grafana-dashboard.jpeg">
</p>
</details>

<details>
<summary>ConfigMap в кластере K8s</summary>
<p align="center">
  <img width="100%", src="./img/monitoring/monitoring-k8s-dashboard-configmaps.jpeg">
</p>
</details>

---
### Установка и настройка CI/CD

После настройки инстансов, описаных в `inventory` файле

<details>
<summary>inventory файл окружения stage</summary>

```bash
# Ansible inventory containing variable values from Terraform.
# Generated by Terraform.

---
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ansible_playbook_python}}"
    vm-bastion:
      ansible_host: "51.250.3.140"
      ansible_port: "22"
      ansible_user: "bastion_user"
      ansible_ssh_private_key_file: "../ssh_key/stage/id_rsa_vm-bastion"
      ansible_ssh_common_args: ""
    vm-gitlab:
      ansible_host: "192.168.1.11"
      ansible_port: 22
      ansible_user: "gitlab_user"
    k8s-cluster:
      external_v4_endpoint: "https://158.160.132.93"
      internal_v4_endpoint: "https://192.168.10.8"
      cluster_id: "catsmqq5ahiovng717dp"
      service_account_id: "aje246n01emsao9gt497"
      node_service_account_id: "aje246n01emsao9gt497"
      container_registry_id: "crp98a7o84dub63edg71"
  vars:
    ansible_ssh_private_key_file: "../ssh_key/stage/id_rsa_vm"
    ansible_ssh_common_args: >-
      -o ProxyCommand="ssh -p 22 -W %h:%p -q
      -i ../ssh_key/stage/id_rsa_vm-bastion bastion_user@51.250.3.140"
  children:
    infra:
      hosts:
        vm-bastion:
        vm-gitlab:
    gitlab:
      hosts:
        vm-gitlab:
    bastion:
      hosts:
        vm-bastion:
```

</details>
<br>

необходимо зайти на сервер Gitlab по адресу http://gitlab.stage.bdvsun.ru:4433,
авторизоваться используя логин `root` и пароль полученый после выполнения `ansible` роли `get_pwd`

```bash
TASK [get_pwd : Get gitlab root password] *******************************************************************************************
ok: [vm-gitlab]

TASK [get_pwd : Print root password] ************************************************************************************************
ok: [vm-gitlab] => {
    "msg": "Password: RfymOyhScuOuxqKy8EojflJ3VwYY2E9Hv4D4og1jBGc="
}
```
Перейти на вкладку создания персонального токена доступа, создать токен доступа с правами: `api`, `read_api`, `read_user`.

<details>
<summary>Токен доступа с правами: api, read_api, read_user</summary>

<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-root-api_token.jpeg">
  <img width="100%", src="./img/gitlab/gitlab-root-api_token-create.jpeg">
</p>
</details>
<br>

Использовать созданный токен для следующего шага настройки сервера `GitLab`.
<br>

Запустим `Makefile` командой

```bash
make gitlab_set_settings API_TOKEN=glpat-ZUhQ7sPwyXdNYiGDr5CY
```

Запустится на выполнение `Ansible` плейбук:

```bash
ansible-playbook -i stage-inventory --extra-vars="tf_workspace=stage" --extra-vars="api_token=glpat-ZUhQ7sPwyXdNYiGDr5CY" gitlab_set_settings.yml
```

Который:

- создаст "секрет" в кластере `K8s` для доступа узлов кластера к реестру контейнеров
- настроит сервер `Gitlab` для доступа в локальную сеть
- создаст пользователя на сервере `Giltab`
- создаст два проекта:
    1. `demo-project` - Демонстрационное приложение - статическая `html` страница
    2. `tf-infra` - манифесты `Terraform` текущей инфраструктуры `Yandex.Cloud`
- настроит `CI/CD` для проекта `demo-project`
- настроит `WebHook` для работы с `Atlantis` для проекта `tf-infra`
- создаст токены доступа для проектов и добавит их в переменные `CI/CD`
- добавит необходимые переменные для `CI/CD`
- создаст защищенные ветки проекта
- добавит исходные файлы в проекты на сервере `Gitlab`
- задеплоит в кластер приложение `Atlantis`

После выполнения `Ansible` плейбука необходимо авторизоваться на сервере [Gitlab](http://gitlab.stage.bdvsun.ru:4433) используя следующие данные:

- логин: `bdvsun@bdvsun.ru`
- пароль: `1Q2W3E_qazwsxedc`

<details>
<summary>Список проектов текущего пользователя</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-projects.jpeg">
</p>
</details>

#### Проект `demo-project`

<details>
<summary>Файлы проекта</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project.jpeg">
</p>
</details>

<details>
<summary>Gitlab-Runner</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-runner.jpeg">
</p>
</details>

<details>
<summary>CI/CD переменные</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-cicd-variable.jpeg">
</p>
</details>

<details>
<summary>Защищенные ветки проекта</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-repo-branches.jpeg">
</p>
</details>

<details>
<summary>Пайплайн проекта</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-pipeline.jpeg">
</p>
</details>

<details>
<summary>Рабочие задачи пайплайна</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-jobs.jpeg">
</p>
</details>

<details>
<summary>Задача builder - создание образа приложения из Dockerfile и загрузка в реестр</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-jobs-builder.jpeg">
</p>
</details>

<details>
<summary>Задача deploy_to_k8s - деплой приложения в кластер K8s</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-jobs-deploy_to_k8s.jpeg">
</p>
</details>

<details>
<summary>Задача release - релиз приложения</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-jobs-releases.jpeg">
</p>
</details>

<details>
<summary>Созданый тег</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-tags.jpeg">
</p>
</details>

<details>
<summary>Комментарии</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-demo_project-commits.jpeg">
</p>
</details>

<details>
<summary>Работа демо приложения</summary>
<p align="center">
  <img width="100%", src="./img/app/app-stage.jpeg">
</p>
</details>

#### Проект `tf-infra`

<details>
<summary>Файлы проекта</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra.jpeg">
</p>
</details>

<details>
<summary>Webhook</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra-webhook.jpeg">
</p>
</details>

<details>
<summary>Создание Merge Request</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra-mr-new.jpeg">
</p>
</details>

<details>
<summary>Утверждение запроса на слияние</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra-mr-approve.jpeg">
</p>
</details>

<details>
<summary>Запуск внешнего пайплайна Atlantis</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra-pipelines.jpeg">
</p>
</details>

<details>
<summary>Успешное завершение работы пайплайна</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra-pipelines-ok.jpeg">
</p>
</details>

<details>
<summary>Сообщение от Atlantis об успешном выполнение команды terraform plan</summary>
<p align="center">
  <img width="100%", src="./img/gitlab/gitlab-user-tf_infra-mr-atlantis-ok.jpeg">
</p>
</details>

<details>
<summary>Сервер Atlantis</summary>
<p align="center">
  <img width="100%", src="./img/atlantis/atlantis.jpeg">
</p>
</details>
<br>

### Адреса серверов

- [http://gitlab.stage.bdvsun.ru:4433](http://gitlab.stage.bdvsun.ru:4433) - сервер Gitlab (выключен)
- [http://app.stage.bdvsun.ru](http://app.stage.bdvsun.ru) - демонстрационная страничка приложения (выключен)
- [http://atlantis.stage.bdvsun.ru](http://atlantis.stage.bdvsun.ru) - сервер Atlantis (выключен)
- [http://grafana.stage.bdvsun.ru](http://grafana.stage.bdvsun.ru) - сервер Grafana (выключен)

### Комментарии эксперта Нетологии

#### terraform

- Думаю, стоило вынести список [CIDR](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/tf/network.tf#L32) в переменную, чтобы она была доступна, если понадобится по ней же пройти в другом цикле. Можно, конечно, её забрать из ресурса `yandex_vpc_subnet.subnet-k8s`, но это уже сложнее, чем из переменной.
- Без необходимости не стоит использовать интерполяцию в [строках](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/tf/main.tf#L13). Если в строке помимо ссылки на другой ресурс ничего нет, просто вызовите ссылку на атрибут этого ресурса. Другими словами, вместо `bucket = "${var.yandex_s3_bucket}` лучше написать `bucket = var.yandex_s3_bucket`. Аналогично - в других похожих местах в коде.
- Длинные строки [вроде](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/tf/instance.tf#L108) лучше выносить в файл.
- Возможно, стоило список [ролей](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/tf/service-acc.tf#L9) тоже сделать переменной и ресурсы создать в цикле.

#### ansible

- Раз уж у вас все ресурсы находятся в облаке, то можно вместо статического [inventory](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/tf/output.tf#L5) использовать [динамический](https://docs.ansible.com/ansible/latest/inventory_guide/intro_dynamic_inventory.html)
- Возможно, такое “дробление” [ролей](https://github.com/bdvme/devops_diplom/tree/main/ansible/roles) излишне, становится сложно следовать за последовательностью, логикой настройки. Впрочем, здесь в первую очередь важно, чтобы было удобно вам.
- Для [snap](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/ansible/roles/gitlab_add_cicd_vars/tasks/main.yml#L4), в принципе, есть [модуль](https://docs.ansible.com/ansible/latest/collections/community/general/snap_module.html)
- Конечно, токены и [пароли](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/ansible/group_vars/all/variable.yml#L42) не следует хранить в переменных в git. Но применение специальных инструментов для хранения секретов уже выходит за рамки задания.
- Для [kubectl](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/ansible/roles/k8s_apply/tasks/main.yml#L8) тоже есть [модуль](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html) . На мой взгляд для выполнения kubectl было бы достаточно и просто команды из gitlab-ci. Но, выбор также за вами.

#### application

- Оба [файла](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/app/demo-project/src/Dockerfile#L2) можно было скопировать одной директивой COPY, тем самым сэкономив один слой в образе.

#### CI/CD

- Использование [only](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/app/demo-project/.gitlab-ci.yml#L16) [не рекомендуется](https://docs.gitlab.com/ee/ci/yaml/#only--except). Лучше использовать rules
- Править k8s-манифесты [sed'ом](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/app/demo-project/.gitlab-ci.yml#L49), конечно, не следует в настоящих проектах. Для этого есть, например, helm. Но для дипломной работы подойдёт и такой способ.
- [Получается](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/app/demo-project/.gitlab-ci.yml#L52), что деплой приложения происходит всегда при сборке master/main, а не только при создании релиза (тега).
- Предполагалось, что [процесс](https://github.com/bdvme/devops_diplom/blob/ba80daa4e9dc2104406b0a9e0ab9cb6a44b3a576/app/demo-project/.gitlab-ci.yml#L87) будет обратным: при установке разработчиком тега в git будет происходить сборка релиза, отправка образа в регистр с соответствующим тегом (уже в понятиях docker).
