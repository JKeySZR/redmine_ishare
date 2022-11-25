# Redmine iShare

Plugin for redmine.
Allows you to open access to a specific task in read mode for an anonymous user

Redmine.org plugin page: https://www.redmine.org/plugins/redmine_ishare
Github: https://github.com/JKeySZR/redmine_ishare

## Features

* No need to create any user accounts for anonymous user
* Creating different passwords for the same issue
* Specify access expiration time

![iShare redmine plugin concept.](doc/screenshots/idea_sxem.png "Idea of plugin redmine iShare") 

## Screenshot

How does it look from the side of an anonymous user who does not have a password or is incorrect
and which has the correct password.

With an easter egg in the form of a change of Ava with each download. Refresh the page.

![iShare просмотр issue по паролю.](doc/screenshots/password_igi_action.gif "Просмотр задачи, по паролю, с пасхалкой")

Как это выглядит внутри Redmine  

![iShare создание достпу по паролю.](doc/screenshots/issue_create_password_access.gif "Как разрешить доступ к задаче по паролю.")

## Getting the plugin

A copy of the plugin can be downloaded from [GitHub](https://github.com/JKeySZR/redmine_ishare)

## Installation

To install the plugin clone the repo from github and migrate the database:

```
$ cd $REDMINE_ROOT
$ git clone -b stable https://github.com/JKeySZR/redmine_ishare.git plugins/redmine_ishare
$ bundle config set --local without 'development test'
$ bundle install
$ bundle exec rake redmine:plugins:migrate NAME=redmine_ishare
```

To uninstall the plugin migrate the database back and remove the plugin:

```
$ cd $REDMINE_ROOT
$ bundle exec rake redmine:plugins:migrate NAME=redmine_ishare VERSION=0 RAILS_ENV=production
$ rm -rf plugins/redmine_ishare public/plugin_assets/redmine_ishare
```

Further information about plugin installation can be found at: https://www.redmine.org/wiki/redmine/Plugins

## Usage

To use the iShare functionality you need to

* add the custom field 'owner-email' to a project in the project configuration

## Compatibility

The latest version of this plugin tested on Redmine 4.2.x.

Tests in different environments were not conducted.
The plugin was written for such an environment:

Environment:
Redmine version                4.2.8.stable
Ruby version                   2.7.6-p219 (2022-04-12) [x86_64-linux]
Rails version                  5.2.8.1
Database adapter               Mysql2

Should work, but not the fact =)

| `Redmine` version  | >= 4.2.0 |
| `Ruby`_ version  | >= 2.7  |
| Database version  | MySQL >= 5.7 or PostgreSQL >= 9.6  |


## License

This plugin is licensed under the GPL license. See LICENSE-file for details.

## Copyright

Copyright (c) 2022 Bocharov-MS 