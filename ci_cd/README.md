# Развертывание CI/CD проекта

Для обеспечения функционирования инструментов CI/CD проекта (используется Jenkins).
В данном проекте реализовано создание Jenkins сервера по средствам Jenkins Configuration as Code (JCAC).

## Обзор

По результатам выполнения скриптов и команд будет создано:

- EC2 instance в дефолтной VPC в AWS с предустановленным докером, скопированы на instance все необходимые файлы с credentials
- 2 Docker контейнера
  - jenkins-server на котором развернут Jenkins Configuration as Code
  - jenkins-docker, используемый jenkins-server для работы на нем с Docker

## Требования

- Выполнение требований указанных при создании кластера K8s
- Docker-compose version 1.29.2 или новее

## Как использовать

- Если Вы хотите использовать свои images для jenkins-server и jenkins-docker:
  - перейдите в директорию `create_images`
  - отредактируйте Dockerfiles в директориях `jenkins` и `docker_dind` в соответствии с Вашими запросами
  - создайте 2 images для jenkins-server и jenkins-docker (например):

  ```commandline
  docker build -t YOUR_IMAGE_NAME -f jenkins/Dockerfile .
  docker build -t YOUR_IMAGE_NAME -f docker_dind/Dockerfile .
  ```

  - сохраните свой личный токен доступа на GitHub как переменную среды:

  ```commandline
  export CR_PAT=YOUR_TOKEN
  ```

  - используя интерфейс командной строки для вашего типа контейнера, войдите в службу реестра контейнеров по адресу `ghcr.io`:

  ```commandline
  echo $CR_PAT | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin
  ```

  - отправьте созданные images в GitHub Packages:

  ```commandline
  docker push ghcr.io/NAMESPACE/IMAGE_NAME:TAG
  ```

  где `NAMESPACE` - имя личной учетной записи или организации, `IMAGE_NAME` - название Вашего image, `TAG` - версия которую Вы ему присвоите

  - проверьте после загрузки images, что они находятся в публичном доступе в GitHub Packages

- Если Вы хотите использовать custom images для данного проекта, сразу переходите к следующему шагу

- Перейдите в директорию `docker-machine`:
  - переименуйте директории `ghcr_cred_example` , `mail_cred_example` , `ssh_key_example` удалив в названиях этих директорий `_example`
  - в указанных выше директориях в файлах `github_pat` , `mail_pat` , `id_rsa` введите Ваши данные GitHub токена, пароль доступа к почтовому ящику (на который Вы будите получать сообщения от Jenkins), и приватный ключ для доступа к GitHub по ssh соответсвенно
  - переименнуйте файл `env.sh.example` удалив в названии файла `.example`
  - внесите свои данные в полученный файл `env.sh`:

  ```commandline
  export AWS_ACCESS_KEY_ID="Your AWS_ACCESS_KEY_ID"
  export AWS_SECRET_ACCESS_KEY="Your AWS_SECRET_ACCESS_KEY"
  export AWS_DEFAULT_REGION="Your AWS_DEFAULT_REGION"
  export DOCKER_MACHINE_NAME="Your DOCKER_MACHINE_NAME"
  export SYNC_FOLDER="jenkins"
  export MACHINE_USER="ubuntu"
  export ROOT_DIR="Your path for ROOT_DIR (For example '/mnt/d/diplom/project/ci_cd')"
  ```
  
- Перейдите в директорию `jenkins`:
  - переименнуйте файл `.env.example` удалив в названии файла `.example`
  - внесите свои данные в полученный файл `.env`:

  ```commandline
  JENKINS_ADMIN_ID="Your login"
  JENKINS_ADMIN_PASSWORD="Your password"
  JENKINS_URL="http://'Your IP machine':8080/"
  JENKINS_ADMIN_ADDRESS="Your JENKINS admin e-mail"
  MAIL_USERNAME="Your e-mail username"
  JENKINS_MAILER_SMTP_HOST="Your mail service in the format 'smtp.mail.ru'"
  ```

  - переменную JENKINS_URL оставьте с текущим default значением, она автоматически изменяется после запуска скрипта на выполнение

- Проверьте файл `docker-compose.yaml`
  - если Вы планируете использовать собственные image для контейнеров `jenkins-server` и `jenkins-docker`, то в значении `image` введите полное название Ваших image:

  Пример:

  ```commandline
  image: ghcr.io/lodisav-devops/myjenkins:casc

  image: ghcr.io/lodisav-devops/docker:kubectl
  ```
  - если Вы будете использовать custom images оставьте значения без изменений

- Запустите на выполнение скрипт `docker_machine_create.sh` в директории `docker-machine`

  Пример:

  ```commandline
  cd docker-machine/
  ./docker_machine_create.sh
  ```

  - после выполнения скрипта обязательно выполните следующую команду:

  ```commandline
  eval $(docker-machine env $DOCKER_MACHINE_NAME)
  ```

- Выполните команду `docker-compose up -d`

  Пример:

  ```commandline
  docker-compose up -d
  ```

- После развертывания EC2 instance и Jenkins на нем, зайдите на Jenkins сервер по средствам Web-браузера и проверьте применение Глобальных настроек, создание Credentials и др. Продолжайте работу с приложением. Инфраструктура развернута!
