<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    use HasFactory;
    protected $fillable = ['workspace_id', 'author_id', 'content', 'media_urls', 'scheduled_at', 'status', 'published_at'];
    protected $casts = ['media_urls' => 'array', 'scheduled_at' => 'datetime', 'published_at' => 'datetime'];
    public function workspace() { return $this->belongsTo(Workspace::class); }
    public function author() { return $this->belongsTo(User::class, 'author_id'); }
    public function channels() { return $this->belongsToMany(SocialChannel::class)->withPivot('external_post_id')->withTimestamps(); }
}
