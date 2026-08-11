<?php

namespace Database\Seeders;

use App\Models\SocialChannel;
use App\Models\User;
use App\Models\Workspace;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        $owner = User::updateOrCreate(['email' => 'owner@marketing.test'], ['name' => 'Marketing Pro', 'password' => Hash::make('password')]);
        $workspace = Workspace::updateOrCreate(['slug' => 'brand-agency'], ['name' => 'Brand Agency', 'plan' => 'growth']);
        $workspace->users()->syncWithoutDetaching([$owner->id => ['role' => 'owner']]);
        
        $channels = [
            ['platform' => 'facebook', 'platform_id' => 'fb_123', 'name' => 'Official Facebook Page'],
            ['platform' => 'instagram', 'platform_id' => 'ig_456', 'name' => 'Official Instagram'],
        ];
        foreach ($channels as $c) SocialChannel::updateOrCreate(['workspace_id' => $workspace->id, 'platform_id' => $c['platform_id']], $c + ['workspace_id' => $workspace->id]);
        
        $workspace->posts()->create(['author_id' => $owner->id, 'content' => 'Launching our new summer collection! 🚀', 'status' => 'scheduled', 'scheduled_at' => now()->addDays(2)]);
    }
}
