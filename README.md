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

### Creating our Task model and migration

Laravel provides several commands through Artisan Laravel’s command line tool that help us by generating files and putting them in the correct folders.

To create the Task model, we can run:

```
$ php artisan make:model Task -m
```

The `-m` flag will create the corresponding migration file for the model.

Open the migration file generated for the Task model and update the `up()` method as below:

```
// database/migrations/TIMESTAMP_create_tasks_table.php

    public function up()
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->increments('id');
            $table->unsignedInteger('user_id');
            $table->string('title');
            $table->timestamps();
        });
    }
```

We define the fields for the tasks table which are an auto increment ID, the ID of the user that added the task and the title of the title.

Run the the command below to run the migrations:

```
$ php artisan migrate
```

## Define relationships between models

A user can add as many tasks as they wish, but a task can only belong to one user. So, the relationship between the User model and Task model is a `one-to-many` relationship. Add the code below inside the User model:

```
// app/User.php

public function tasks()
{
    return $this->hasMany(Task::class);
}
```

Define the inverse relationship on the Task model:

```
// app/Task.php

public function user()
{
    return $this->belongsTo(User::class);
}
```
