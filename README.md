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

Open the migration file generated for the User model and update the up() method as below:

```
// database/migrations/TIMESTAMP_create_users_table.php

public function up()
{
    Schema::create('users', function (Blueprint $table) {
        $table->id();
        $table->string('firstName');
        $table->string('lastName');
        $table->string('email')->unique();
        $table->timestamp('email_verified_at')->nullable();
        $table->string('password');
        $table->rememberToken();
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

## Allowing mass assignment on some fields

We’ll be using the `create()` method to save new model in a single line. To avoid getting the mass assignment error which Laravel will throw by default, we need to specify the columns we want to be mass assigned. To do this, let’s add the snippet below to our model:

```
// app/Task.php

protected $fillable = ['user_id', 'title'];
```

## Adding user authentication

We’ll be securing our API by adding user authentication with JWT. For this, we’ll make use of a package called `jwt-auth`. Let’s install and set it up:

```
$ composer require tymon/jwt-auth "1.0.*"
```

Once that’s done installing, let’s run the command below to publish the package’s config file:

```
$ php artisan vendor:publish --provider="Tymon\JWTAuth\Providers\LaravelServiceProvider"
```

This will create a `config/jwt.php` file that will allow us to configure the basics of the package.

Next, run the command below to generate a secret key:

```
$ php artisan jwt:secret
```

This will update the `.env` file with something like `JWT_SECRET=some_random_key`. This key will be used to sign our tokens.

Before we can start to use the `jwt-auth` package, we need to update our User model to implement the `Tymon\JWTAuth\Contracts\JWTSubject` contract as below:

```
// app/User.php

use Tymon\JWTAuth\Contracts\JWTSubject;

class User extends Authenticatable implements JWTSubject
{
    ...
}
```

This requires that we implement two methods: `getJWTIdentifier()` and `getJWTCustomClaims()`. Add the code below to the User model:

```
// app/User.php

public function getJWTIdentifier()
{
    return $this->getKey();
}

public function getJWTCustomClaims()
{
    return [];
}
```

The first method gets the identifier that will be stored in the subject claim of the JWT and the second method allow us to add any custom claims we want added to the JWT.

Next, let’s configure the auth guard to make use of the `jwt` guard. Update `config/auth.php` as below:

```
// config/auth.php

'defaults' => [
    'guard' => 'api',
    'passwords' => 'users',
],

...

'guards' => [
    'api' => [
        'driver' => 'jwt',
        'provider' => 'users',
    ],
],
```

Here we are telling the api guard to use the jwt driver, and we are setting the api guard as the default.

Now we can start to make use of the `jwt-auth` package. Create a new `AuthController`:

```
$ php artisan make:controller AuthController
```

Then paste the code below into it:

```
// app/Http/Controllers/AuthController.php

// remember to add this to the top of the file
use App\User;

public function register(Request $request)
{
    $user = User::create([
        'firstName' => $request->firstName,
        'lastName' => $request->lastName,
        'email' => $request->email,
        'password' => bcrypt($request->password),
    ]);

    $token = auth()->login($user);

    return $this->respondWithToken($token);
}

public function login(Request $request)
{
    $credentials = $request->only(['email', 'password']);

    if (!$token = auth()->attempt($credentials)) {
        return response()->json(['error' => 'Unauthorized'], 401);
    }

    return $this->respondWithToken($token);
}

protected function respondWithToken($token)
{
    return response()->json([
        'access_token' => $token,
        'token_type' => 'bearer',
        'expires_in' => auth()->factory()->getTTL() * 60000
    ]);
}
```

We define the methods to register a new user and to log users in respectively. Both methods returns a response with a JWT by calling a `respondWithToken()` method which gets the token array structure.

Next, let’s add the register and login routes. Add the code below inside `routes/api.php`:

```
// routes/api.php

Route::post('register', 'AuthController@register');
Route::post('login', 'AuthController@login');
```

## Defining API routes

Let’s define our routes. Open `routes/api.php` and add the line below to it:

```
// routes/api.php

Route::apiResource('tasks', 'TaskController');
```

Since we are building an API, we make use of `apiResource()` to generate API only routes.

## Creating the Task resource

Before we move on to create the `TasksController`, let’s create a task resource class. We’ll make use of the artisan command make:resource to generate a new task resource class. By default, resources will be placed in the `app/Http/Resources` directory of our application.

```
$ php artisan make:resource TaskResource
```

Once that is created, let’s open it and update the `toArray()` method as below:

```
// app/Http/Resources/TaskResource.php

public function toArray($request)
{
    return [
        'id' => $this->id,
        'title' => $this->title,
        'created_at' => (string) $this->created_at,
        'updated_at' => (string) $this->updated_at,
        'user' => $this->user,
    ];
}
```
