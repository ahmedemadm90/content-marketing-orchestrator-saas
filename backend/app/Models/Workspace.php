<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Workspace extends Model
{
    use HasFactory;
    protected $fillable = ['name', 'slug', 'plan'];
    public function users() { return $this->belongsToMany(User::class)->withPivot('role')->withTimestamps(); }
    public function socialChannels() { return $this->hasMany(SocialChannel::class); }
    public function posts() { return $this->hasMany(Post::class); }
}
