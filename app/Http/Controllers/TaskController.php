<?php

namespace App\Http\Controllers;

use App\Task;
use Illuminate\Http\Request;
use App\Http\Resources\TaskResource;

class TaskController extends Controller
{
    public function __construct()
    {
        $this->middleware('auth:api')->except(['index', 'show']);
    }
    
    /**
     * Display a listing of tasks.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        /*
         * Adding a where clause to limit the data brought back by the user_id
         * 
         * Using whereHas() method to set an addition to the query
         * Getting user_id from the auth()->user()
         * Setting where clause to only get records that match user_id
         */
        $tasks = Task::select('id', 'title', 'created_at', 'updated_at', 'isComplete')->whereHas('user', function($query) {
            $userID = auth()->user()->id;
            $query->where('id', '=', $userID);
        })->paginate(25);

        return TaskResource::collection($tasks);
    }

    /**
     * Store a newly created task in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $task = Task::create([
            'user_id' => auth()->user()->id,
            'title' => $request->title,
            'isComplete' => $request->isComplete,
        ]);

        return new TaskResource($task);
    }

    /**
     * Display the specified task.
     *
     * @param  \App\Task  $task
     * @return \Illuminate\Http\Response
     */
    public function show(Task $task)
    {
        return new TaskResource($task);
    }

    /**
     * Update the specified task in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \App\Task  $task
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, Task $task)
    {
        // check if currently authenticated user is the owner of the task
        if (auth()->user()->id !== $task->user_id) {
            return response()->json(['error' => 'You can only edit your own tasks.'], 403);
        }

        $task->update($request->only(['title', 'isComplete']));

        return new TaskResource($task);
    }

    /**
     * Remove the specified task from storage.
     *
     * @param App\Task  $task
     * @return \Illuminate\Http\Response
     */
    public function destroy(Task $task)
    {
        $task->delete();

        return response()->json(null, 204);
    }
}
