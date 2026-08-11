<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\SocialChannel;
use App\Models\Workspace;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MarketingController extends Controller
{
    public function dashboard(Request $request, int $workspaceId): JsonResponse
    {
        $this->ensureMember($request, $workspaceId);
        $posts = Post::where('workspace_id', $workspaceId)->with('channels')->latest()->get();
        return response()->json(['workspace' => Workspace::findOrFail($workspaceId), 'channels' => SocialChannel::where('workspace_id', $workspaceId)->get(), 'scheduled_count' => $posts->where('status', 'scheduled')->count(), 'pending_approval' => $posts->where('status', 'pending_approval')->count(), 'recent_posts' => $posts->take(10)]);
    }

    public function storePost(Request $request, int $workspaceId): JsonResponse
    {
        $this->ensureMember($request, $workspaceId);
        $data = $request->validate(['content' => ['required', 'string'], 'media_urls' => ['nullable', 'array'], 'scheduled_at' => ['nullable', 'date', 'after:now'], 'channel_ids' => ['required', 'array', 'exists:social_channels,id']]);
        $post = Post::create($data + ['workspace_id' => $workspaceId, 'author_id' => $request->user()->id, 'status' => 'draft']);
        $post->channels()->attach($data['channel_ids']);
        return response()->json($post->load('channels'), 201);
    }

    public function approvePost(Request $request, int $workspaceId, Post $post): JsonResponse
    {
        $this->ensureMember($request, $workspaceId);
        abort_unless($post->workspace_id === $workspaceId, 404);
        $post->update(['status' => $post->scheduled_at ? 'scheduled' : 'pending_approval']);
        return response()->json($post);
    }

    public function channels(Request $request, int $workspaceId): JsonResponse
    {
        $this->ensureMember($request, $workspaceId);
        return response()->json(SocialChannel::where('workspace_id', $workspaceId)->get());
    }

    private function ensureMember(Request $request, int $workspaceId): void { abort_unless($request->user()->workspaces()->whereKey($workspaceId)->exists(), 403, 'Workspace access denied.'); }
}
