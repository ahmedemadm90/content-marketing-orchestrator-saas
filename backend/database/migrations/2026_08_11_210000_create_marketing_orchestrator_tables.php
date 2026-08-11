<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('workspaces', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('plan')->default('starter');
            $table->timestamps();
        });

        Schema::create('user_workspace', function (Blueprint $table) {
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('workspace_id')->constrained()->cascadeOnDelete();
            $table->string('role')->default('member'); // owner, editor, client
            $table->timestamps();
            $table->primary(['user_id', 'workspace_id']);
        });

        Schema::create('social_channels', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workspace_id')->constrained()->cascadeOnDelete();
            $table->string('platform'); // facebook, instagram, twitter, linkedin
            $table->string('platform_id');
            $table->string('name');
            $table->text('access_token')->nullable();
            $table->timestamps();
        });

        Schema::create('posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workspace_id')->constrained()->cascadeOnDelete();
            $table->foreignId('author_id')->constrained('users')->cascadeOnDelete();
            $table->text('content');
            $table->json('media_urls')->nullable();
            $table->timestamp('scheduled_at')->nullable();
            $table->string('status')->default('draft'); // draft, pending_approval, scheduled, published, failed
            $table->timestamp('published_at')->nullable();
            $table->timestamps();
        });

        Schema::create('post_social_channel', function (Blueprint $table) {
            $table->foreignId('post_id')->constrained()->cascadeOnDelete();
            $table->foreignId('social_channel_id')->constrained()->cascadeOnDelete();
            $table->string('external_post_id')->nullable();
            $table->timestamps();
            $table->primary(['post_id', 'social_channel_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('post_social_channel');
        Schema::dropIfExists('posts');
        Schema::dropIfExists('social_channels');
        Schema::dropIfExists('user_workspace');
        Schema::dropIfExists('workspaces');
    }
};
