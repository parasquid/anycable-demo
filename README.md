# README

## Setup

We'll use `docker-compose.yml` because I don't want to install unnecessary daemons on my machine; only run these services when I'm working on this project.

Also see the docker extension for VS Code (very useful if you don't want to memorize all those docker commands).

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

## Rails with ActionCable in development

Generate empty Gemfile with rails:

``` ruby
source 'https://rubygems.org'
gem 'rails'
```

Generate a rails app (allow `Gemfile` to be overwritten):

``` sh
bundle && bundle exec rails new . -d postgresql -M --skip-coffee --skip-turbolinks -T
```

* Use postgres as the db
* no action mailer
* no coffeescript
* no turbolinks
* no tests (for now)

Then:

* create the models `User -< Post -< Comment`
* add seeds
* quick views (with bootstrap cdn)
* add simple authentication (identification via name + cookie)
* add comments submission and streaming through action cable

## Deploying to "production"

* install and configure Vagrant

``` text
[~/parasquid/anycable-demo] (master) tristan$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Box 'ubuntu/bionic64' could not be found. Attempting to find and install...
    default: Box Provider: virtualbox
    default: Box Version: >= 0
==> default: Loading metadata for box 'ubuntu/bionic64'
    default: URL: https://vagrantcloud.com/ubuntu/bionic64
==> default: Adding box 'ubuntu/bionic64' (v20181105.1.0) for provider: virtualbox
    default: Downloading: https://vagrantcloud.com/ubuntu/boxes/bionic64/versions/20181105.1.0/providers/virtualbox.box
    default: Download redirected to host: cloud-images.ubuntu.com
    default: Progress: 11% (Rate: 150k/s, Estimated time remaining: 0:26:12)
```

`vagrant ssh-config`

``` sh
[~/parasquid/anycable-demo] (master) tristan$ vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/tristan/parasquid/anycable-demo/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  ForwardAgent yes

```

* configure Capistrano (using the `vagrant` environment)

``` ruby
set :stage, :vagrant
set :rails_env, "vagrant"

vagrant_ssh_config = `vagrant ssh-config`
  .split("\n")
  .map(&:strip)
  .reduce({}) do |memo, string|
  key, value = string
    .split(/\s/, 2)
    .map(&:strip)
  memo[key] = value
  memo
end

server vagrant_ssh_config["HostName"],
  roles: %w{web app db},
  primary: true,
  user: vagrant_ssh_config["User"],
  port: vagrant_ssh_config["Port"],
  ssh_options: {
    keys: [vagrant_ssh_config["IdentityFile"]],
    forward_agent: vagrant_ssh_config["ForwardAgent"] == "yes",
  }
```

* "deploy" to local vagrant VM (and tweak deployment recipes and formulas as necessary)

### Summary:

* `vagrant up`
* `cap vagrant deploy`
* `cap vagrant db:seed`
* open localhost:8080 and test it out
