# Laravel API

## Setting Up a Laravel Web Service

As with all modern PHP frameworks, we’ll need <a href="https://getcomposer.org/download/" target="_blank">Composer</a> to install and handle our dependencies. After you follow the download instructions (and add to your path environment variable), install Laravel using the command:

```
$ composer global require laravel/installer
```

After the installation finishes, you can scaffold a new application like this:

```
$ laravel new scriptjumper-api-laravel
```

For the above command, you need to have `~/composer/vendor/bin` in your `$PATH`. If you don’t want to deal with that, you can also create a new project using Composer:

```
$ composer create-project --prefer-dist laravel/laravel scriptjumper-api-laravel
```

With Laravel installed, you should be able to start the server and test if everything is working:

```
$ php artisan serve
// In the console you will get an out put:
Laravel development server started: <http://127.0.0.1:8000>
```

## Create models and migrations

### Connection to PostgreSQL

Before actually writing your first migration, make sure you have a database created for this app and add its credentials to the `.env` file located in the root of the project.

First run `$ cp .env.example .env` to create your `.env` file and replace the database credentials below with your own.

```
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=staging
DB_USERNAME=postgres
DB_PASSWORD=root
```
