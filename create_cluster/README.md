# Развертывание инфраструктуры для проекта

## Обзор

Этот скрипт создаст:

- EC2 instance в дефолтной VPC в AWS с предустановленным докером
- K8s кластер на развернутом EC2 instance с предустановленным:
  - Calico
  - Ingress NGINX контроллером
  - Metrics-server

## Требования

- ОС Linux или Ubuntu WSL
- Docker version 23.0.0 или новее
- Docker-machine version 0.16.0 или новее
- Kind version 0.17.0 или новее
- Kubectl (Client Version: v1.26.1) или новее
- доступ к Вашему аккаунту AWS через AWS CLI

## Как использовать

- Экспортируйте переменные для ваших учетных данных AWS или отредактируйте `env.sh.example`, который находится в директории `./docker-machine`:
  - удалите `.example` и оставьте файл с названием `env.sh`
  - внесите свои данные в переменные:

  ```commandline
  export AWS_ACCESS_KEY_ID="Your KEY_ID"
  export AWS_SECRET_ACCESS_KEY="Your SECRET_ACCESS_KEY"
  export AWS_DEFAULT_REGION="Your REGION"
  export DOCKER_MACHINE_NAME="Your DOCKER_MACHINE_NAME"
  ```

- Отредактируйте файл `env.sh`, который находится в директории `./kind`:
  - переменные `DOCKER_HOST_IP` и `DOCKER_HOST_EXTERNAL_IP` оставьте с дефолтными значениями
  - в переменные `POD_SUBNET` и `SERVICE_SUBNET` внесите желаемые значения, по дефолту останутся `10.88.0.0/16` и `10.33.0.0/16` соответсвенно

  ```commandline
  export DOCKER_HOST_IP="PRIVATE_IP"
  export DOCKER_HOST_EXTERNAL_IP="PUBLIC_IP"
  export POD_SUBNET="Your data"
  export SERVICE_SUBNET="Your data"
  ```

- Запустите на выполнение скрипт `create-cluster.sh`

Пример:

```commandline
./create-cluster.sh
```

- После создания инфраструктуры (docker machine) и развертывания K8s кластера, Вы можете перейти к созданию объектов в кластере и развертыванию своего приложения

## Подключение к K8s

Скрипт при выполнении автоматически вносит необходимые данные в `~/.kube/config` , однако подключение к кластеру будет осуществляться с помощью команды `kubectl --insecure-skip-tls-verify` , если Вы хотите в дальнейшем при работе в консоли исключить `--insecure-skip-tls-verify` в строке подключения, выполните следующию команду:

```commandline
alias kubectl='kubectl --insecure-skip-tls-verify'
```
