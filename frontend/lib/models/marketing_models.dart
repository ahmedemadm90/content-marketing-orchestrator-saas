class SocialChannel {
  const SocialChannel({required this.id, required this.platform, required this.name});
  final int id;
  final String platform;
  final String name;

  factory SocialChannel.fromJson(Map<String, dynamic> json) => SocialChannel(
        id: int.tryParse(json['id'].toString()) ?? 0,
        platform: json['platform'] as String? ?? 'facebook',
        name: json['name'] as String? ?? 'Channel',
      );
}

class MarketingPost {
  const MarketingPost({required this.id, required this.content, required this.status, this.scheduledAt, required this.channels});
  final int id;
  final String content;
  final String status;
  final DateTime? scheduledAt;
  final List<SocialChannel> channels;

  factory MarketingPost.fromJson(Map<String, dynamic> json) => MarketingPost(
        id: int.tryParse(json['id'].toString()) ?? 0,
        content: json['content'] as String? ?? '',
        status: json['status'] as String? ?? 'draft',
        scheduledAt: DateTime.tryParse(json['scheduled_at']?.toString() ?? ''),
        channels: (json['channels'] as List<dynamic>? ?? []).map((c) => SocialChannel.fromJson(c as Map<String, dynamic>)).toList(),
      );
}

class MarketingWorkspace {
  const MarketingWorkspace({required this.id, required this.name, required this.slug});
  final int id;
  final String name;
  final String slug;

  factory MarketingWorkspace.fromJson(Map<String, dynamic> json) => MarketingWorkspace(
        id: int.tryParse(json['id'].toString()) ?? 0,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
      );
}
