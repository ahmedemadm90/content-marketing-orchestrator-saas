<?php

namespace Tests\Feature;

use App\Models\SocialChannel;
use App\Models\Workspace;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class MarketingApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_workspace_member_can_schedule_and_approve_posts(): void
    {
        $user = User::factory()->create();
        $workspace = Workspace::create(['name' => 'Agency', 'slug' => 'agency']);
        $workspace->users()->attach($user->id, ['role' => 'owner']);
        $channel = SocialChannel::create(['workspace_id' => $workspace->id, 'platform' => 'twitter', 'platform_id' => 't1', 'name' => 'Twitter']);

        $post = $this->actingAs($user)->postJson("/api/v1/workspaces/{$workspace->id}/posts", ['content' => 'Hello World', 'channel_ids' => [$channel->id], 'scheduled_at' => now()->addDay()->toDateTimeString()])->assertCreated()->json();
        $this->actingAs($user)->postJson("/api/v1/workspaces/{$workspace->id}/posts/{$post['id']}/approve")->assertOk()->assertJsonPath('status', 'scheduled');
    }
}
