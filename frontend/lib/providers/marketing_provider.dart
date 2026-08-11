import 'package:flutter/foundation.dart';
import '../models/marketing_models.dart';
import '../services/marketing_api.dart';

class MarketingProvider extends ChangeNotifier {
  MarketingProvider({MarketingApi? api}) : _api = api ?? MarketingApi();
  final MarketingApi _api;
  final List<MarketingPost> _posts = [];
  final List<SocialChannel> _channels = [];
  MarketingWorkspace? _workspace;
  bool _loading = false;
  String? _error;

  List<MarketingPost> get posts => List.unmodifiable(_posts);
  List<SocialChannel> get channels => List.unmodifiable(_channels);
  MarketingWorkspace? get workspace => _workspace;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> connectDemo() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final workspaceId = await _api.login();
      await refresh(workspaceId);
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh(int workspaceId) async {
    final data = await _api.fetchDashboard(workspaceId);
    _workspace = MarketingWorkspace.fromJson(data['workspace'] as Map<String, dynamic>);
    _channels..clear()..addAll((data['channels'] as List<dynamic>).map((c) => SocialChannel.fromJson(c as Map<String, dynamic>)));
    _posts..clear()..addAll((data['recent_posts'] as List<dynamic>).map((p) => MarketingPost.fromJson(p as Map<String, dynamic>)));
    notifyListeners();
  }

  Future<void> approve(MarketingPost post) async {
    if (_workspace == null) return;
    await _api.approvePost(_workspace!.id, post.id);
    await refresh(_workspace!.id);
  }
}
