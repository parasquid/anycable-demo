# README

## Setup

docker-compose.yml

``` yaml
version: '3.1'

services:

  redis_db:
    image: redis
    restart: always
    ports:
      - "6379:6379"

  db:
    image: postgres
    restart: always
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: postgres
```

## Rails with normal ActionCable

Generate empty Gemfile with rails:

``` ruby
source 'https://rubygems.org'
gem 'rails'
```

Generate a rails app (allow `Gemfile` to be overwritten):

``` sh
bundle exec rails new . -d postgresql -M --skip-coffee --skip-turbolinks -T
```

Then:

* create the models User -< Post -< Comment
* add seeds
* quick views (with bootstrap cdn)
* add simple authentication (identification via name + cookie)
* add comments submission and streaming through action cable
