<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

// Auth
Route::post('register', 'AuthController@register');
Route::post('login', 'AuthController@login');
Route::get('user', 'AuthController@getAuthUser');
Route::put('user/update', 'AuthController@updateUser');
Route::post('user/avatar/new', 'AuthController@changeAvatar');

// Tasks
Route::apiResource('tasks', 'TaskController');
