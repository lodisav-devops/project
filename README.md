# В данном репозитории указанны файлы настроек и инструкции инфраструктуры дипломного проекта Лодиса Артема (выпускника курса DevOps школы TeachMeSkills)

## Обзор

- Инфраструктура разворачивается с помощью применения технологий Amazon Web Services и Kubernetes
- K8s cluster разворачивается с помощью инструмента kind (инструмент для запуска локальных кластеров Kubernetes с использованием «nodes» как контейнеров Docker) на EC2 instance поднятом через docker-machine, кроме этого в cluster производится установка Ingress-NGINX-controller, Metrics-server, Calico CNI
- За основу в качестве используемого приложения взят проект Web-calculator написанный на python (ссылка на проект - `https://github.com/FelixEnescu/calculator`)
- Сделан image (`test:v1`) указанного приложения и помещен в Packages GitHub (ссылка - `https://github.com/lodisav-devops?tab=packages`)
- В K8s cluster разворачивается Web-calculator как объект `deployment`, а также добавлены объекты для `autoscaling` и `ingress`
- В целях обеспечения мониторинга инфраструктуры K8s cluster и приложения Web-calculator с применением helm разворачивается система мониторинга на основе такого ПО как `Prometheus` и `Grafana` с custom dashboard, а также создаются объекты K8s cluster `blackbox exporter` для снятия метрик с приложения
- Для обеспечения работы разработчиков с данным приложением и применения методологии DevOps (`DevOps Life Cycle`) в качестве инструментов CI/CD применяется ПО `Jenkins`, Jenkins server разворачивается на EC2 instance поднятом через docker-machine c применением docker-compose и по принципам IaC (Jenkins Configuration as Code)
- В качестве проекта, в который вносятся изменения и которой сопровождается разработчиками является проект Web-calculator (ссылка - `https://github.com/lodisav-devops/calculator`), в этом проекте добавлен `Jenkinsfile` для обеспечения работы с приложением по жизненному циклу DevOps
- В ближайшее время планируется завершить добавление к проекту системы логирования ELK, по средствам развертывания EFK (Elasticsearch + Fluentd + Kibana) в K8s cluster

## Требования

- ОС Linux или Ubuntu WSL
- Docker version 23.0.0 или новее
- Docker-machine version 0.16.0 или новее
- Kind version 0.17.0 или новее
- Kubectl (Client Version: v1.26.1) или новее
- доступ к Вашему аккаунту AWS через AWS CLI
- Helm version v3.11.1 или новее
- Docker-compose version 1.29.2 или новее

## Как использовать

- Для развертывания K8s cluster перейдите в директорию `create_cluster` и следуйте указаниям, которые описаны в `README.md` данной директории
- После развертывания K8s cluster предлагается развернуть приложение в кластере, перейдите в директорию `app` и следуйте указаниям, которые описаны в `README.md` данной директории
- Далее разверните систему мониторинга с применением `Prometheus` и `Grafana` с custom dashboard, а также `blackbox exporter` для снятия метрик с приложения, для этого перейдите в директорию `monitoring` и следуйте указаниям, которые описаны в `README.md` данной директории
- В целях обеспечения функционирования приложения по жизненному циклу DevOps разверните `Jenkins`, для этого перейдите в директорию `ci_cd` и следуйте указаниям, которые описаны в `README.md` данной директории
- Для обеспечения работы `multibranch_Pipeline` необходимо создать на GitHub `Webhook` (App reposit example - `https://github.com/lodisav-devops/calculator` -> Settings -> Webhooks -> Add webhook), с указанием IP-адреса сервера `Jenkins`, при этом активировать следующие события реагирования `Pushes` и `Pull requests`
- В дальнейшей работе следить за выполнением multibranch_Pipeline на Jenkins сервере при изменении кода приложения example - `https://github.com/lodisav-devops/calculator`

## Планируется модернизировать

- Добавление к проекту системы логирования ELK, по средствам развертывания EFK (Elasticsearch + Fluentd + Kibana) в K8s cluster
- Реализация развертывания всех объектов K8s cluster по средствам `helm-charts`
- Для обеспечения высокой доступности (High Availability) и высокой производительности (High Performance) рассматривается вопрос о развертывании инфраструктуры по средствам `kubespray`
