# Askme

Клон известного приложения ASKfm, написанный на rails 6.1.3.

## Демо

https://ask-a-question.herokuapp.com

## Установка и запуск
Склонируйте репозиторий в папку: 
```
git clone git@github.com:Alibek-B/askme.git
```
Затем выполните следующие команды:

* Установка зависимостей

```
bundle install
```

* Миграция БД

```
rails db:migrate
```

* Ключи для recaptcha

  Создайте файл `.env` и занесите в него ключи

```
RECAPTCHA_ASKME_PUBLIC_KEY = 'публичный ключ'
RECAPTCHA_ASKME_PRIVATE_KEY = 'приватный ключ'
```

* Запуск приложения
```
rails s
```

В браузере введите адрес `http://127.0.0.1:3000`
