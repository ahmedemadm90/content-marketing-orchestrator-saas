<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SocialChannel extends Model
{
    use HasFactory;
    protected $fillable = ['workspace_id', 'platform', 'platform_id', 'name', 'access_token'];
    public function workspace() { return $this->belongsTo(Workspace::class); }
    public function posts() { return $this->belongsToMany(Post::class)->withPivot('external_post_id')->withTimestamps(); }
}
