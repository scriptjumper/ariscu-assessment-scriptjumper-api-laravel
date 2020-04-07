<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\User;

class AuthController extends Controller
{
    /**
     * Register a new user.
     *
     * @param Request $request
     * @return \Illuminate\Http\JsonResponse
     */
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

    /**
     * Get a JWT via given credentials.
     *
     * @param Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        $credentials = $request->only(['email', 'password']);

        if (!$token = auth()->attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        return $this->respondWithToken($token);
    }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function respondWithToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->factory()->getTTL() * 60000
        ]);
    }

    //find current user
    public function getAuthUser(Request $request)
    {
        return response()->json(auth()->user());
    }

    /**
     * Update the current user.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function updateUser(Request $request)
    {
        // check if currently authenticated
        if (auth()->user()->id !== $request->id) {
            return response()->json(['error' => 'You can only edit your own account.'], 403);
        }

        try {
            $user = auth()->user();

            $data = $this->validate($request, [
                'id' => 'required',
                'firstName' => 'required',
                'lastName' => 'required',
            ]);

            $user->firstName = $data['firstName'];
            $user->lastName = $data['lastName'];

            $user->save();

            return response()->json(['success' => 'User updated successfully.'], 200);
        } catch (Exception $e) {
            return response()->json(['error' => 'Sorry we could not update your account.'], 403);
        }
    }

    /**
     * Changes the current users avatar.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function changeAvatar(Request $request)
    {
        // check if currently authenticated
        if (auth()->user()->id !== $request->id) {
            return response()->json(['error' => 'You can only edit your own account.'], 403);
        }

        try {
            $user = auth()->user();

            // Get the file from the request
            $data = $this->validate($request, [
                'avatar' => 'required',
            ]);

            // Store the contents to the database
            $user->avatar = $data['avatar'];
            $user->save();

            return response()->json(['success' => 'Your avatar was uploaded successfully.'], 200);
        } catch (Exception $e) {
            return response()->json(['error' => 'Sorry we could not upload your avatar.'], 403);
        }
    }
}
