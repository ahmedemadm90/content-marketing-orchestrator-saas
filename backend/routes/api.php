<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\MarketingController;
use Illuminate\Support\Facades\Route;

Route::prefix('v1')->group(function () {
    Route::post('auth/register', [AuthController::class, 'register']);
    Route::post('auth/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('auth/logout', [AuthController::class, 'logout']);
        Route::get('workspaces/{workspace}/dashboard', [MarketingController::class, 'dashboard']);
        Route::get('workspaces/{workspace}/channels', [MarketingController::class, 'channels']);
        Route::post('workspaces/{workspace}/posts', [MarketingController::class, 'storePost']);
        Route::post('workspaces/{workspace}/posts/{post}/approve', [MarketingController::class, 'approvePost']);
    });
});
