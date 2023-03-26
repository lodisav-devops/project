# Развертывание приложения для проекта

Для проверки функционирования проекта, работы CI/CD, сбора метрик необходимо развернуть приложение.
Приложение представляет из себя web-калькулятор со статусом успешного или неудачного выполнения вычисления введенных данных.
Приложение состоит из python-скриптов описывающих приложение calc-сервис.
Предварительно образ для приложения необходимо загрузить в свой github container registry.

## Требования
- Создать secret для скачивания образов из GitHub Container Registry:
  - создать Access Token `https://github.com/settings/tokens`
  - выполнить следующую команду для перевода Ваших данных в вид (base64) для создания объекта `Secret` в Вашем кластере K8s:

    ```commandline
    echo -n "yor_github_username:your_github_token" | base64
    ```

  - в поле `your_github_username` - введите свой username на GitHub, где создан токен и на котором загружен образ приложения в github container registry
  - в поле `your_github_token` - введите созданный Вами токен
  - получить данные, например вида `dXNlcm5hbWU6MTIzMTIzYWRzZmFzZGYxMjMxMjM=`
  - в папке `secrets` создать файл `.dockerconfigjson` с содержанием вида:

    ```commandline
    {
        "auths":
        {
            "ghcr.io":
                {
                    "auth":"your_data"
                }
        }
    }
    ```
  - в поле `"auth":"your_data"` вместо `your_data` необходимо ввести данные полученные при выполнении команды выше `echo -n "yor_github_username:your_github_token" | base64` , например содержание файла может иметь следующий вид:

    ```commandline
    {
        "auths":
        {
            "ghcr.io":
                {
                    "auth":"dXNlcm5hbWU6MTIzMTIzYWRzZmFzZGYxMjMxMjM="
                }
        }
    }
    ```

- Проверить значения в переменных окружения в  файле `env.sh`:
  - `NAMESPACE` - переменная в которой указывается пространство имен в котором будут развернуты объекты K8s кластера приложения
  - `TOPIC` - версия образа в Вашем github container registry
  - `GITHUB_REGISTRY_OWNER` - Ваш username на GitHub
  - `GITHUB_REGISTRY_SECRET` - название создаваемого объекта `Secret` в Вашем кластере K8s
  - `GITHUB_REGISTRY_SECRET_FILE` - место расположения Вашего файла `.dockerconfigjson`

## Установка
Запустить скрипт reddit-app.sh и выбрать installation в меню

## Удаление
Запустить скрипт reddit-app.sh и выбрать uninstallation в меню

## Как использовать
В результате установки создается объект `ingress` с именем и значением `reddit` поля `host` , для того чтобы использовать данное приложение
необходимо внести в /etc/hosts Вашего локального хоста следующие данные:

```commandline
PUBLIC_IP_DOCKER_MACHINE_K8S  reddit
```
- где `PUBLIC_IP_DOCKER_MACHINE_K8S` - публичный IP адрес EC2 instance на котором развернут кластер с помощью docker-machine
- если на Вашей хостовой машине Вы используете OS Windows, то необходимо отредактировать файл `C:\Windows\System32\drivers\etc\hosts`
- если Вы используете OS Linux, то отредактировать файл `/etc/hosts`

После проведения вышеуказанных действий введите в строке браузера `reddit/` в результате вы начнете работу с приложением
