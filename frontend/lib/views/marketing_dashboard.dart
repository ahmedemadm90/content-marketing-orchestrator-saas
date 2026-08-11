import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/marketing_provider.dart';

class MarketingDashboard extends StatefulWidget {
  const MarketingDashboard({super.key});
  @override
  State<MarketingDashboard> createState() => _MarketingDashboardState();
}

class _MarketingDashboardState extends State<MarketingDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<MarketingProvider>().connectDemo());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MarketingProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white,
        title: const Row(children: [Icon(Icons.rocket_launch_rounded, color: Color(0xFF6366F1)), SizedBox(width: 10), Text('SocialFlow', style: TextStyle(fontWeight: FontWeight.w800))]),
        actions: [IconButton(onPressed: provider.workspace == null ? null : () => provider.refresh(provider.workspace!.id), icon: const Icon(Icons.refresh_rounded))],
      ),
      body: provider.loading && provider.workspace == null ? const Center(child: CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(16), children: [
        if (provider.error != null) _ErrorBanner(provider.error!),
        _WorkspaceCard(workspace: provider.workspace),
        const SizedBox(height: 24),
        const Text('Upcoming Campaign Posts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        ...provider.posts.map((post) => _PostCard(post: post, onApprove: () => provider.approve(post))),
        if (provider.posts.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No posts scheduled.', style: TextStyle(color: Colors.black38)))),
      ]),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {}, icon: const Icon(Icons.add_rounded), label: const Text('New Post')),
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  const _WorkspaceCard({required this.workspace});
  final dynamic workspace;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]), borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(workspace?.name ?? 'Agency', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
    const SizedBox(height: 8),
    const Text('Manage your multi-channel campaigns', style: TextStyle(color: Colors.white70, fontSize: 14)),
  ]));
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.onApprove});
  final dynamic post; final VoidCallback onApprove;
  @override
  Widget build(BuildContext context) => Card(elevation: 0, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.black12)), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: post.status == 'scheduled' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)), child: Text(post.status.toUpperCase(), style: TextStyle(color: post.status == 'scheduled' ? Colors.green : Colors.orange, fontWeight: FontWeight.w800, fontSize: 10))),
      const Spacer(),
      if (post.scheduledAt != null) Text(post.scheduledAt.toString().substring(0, 16), style: const TextStyle(fontSize: 12, color: Colors.black45)),
    ]),
    const SizedBox(height: 12),
    Text(post.content, style: const TextStyle(fontSize: 16, height: 1.4)),
    const SizedBox(height: 16),
    Row(children: [
      ...post.channels.map((c) => Padding(padding: const EdgeInsets.only(right: 6), child: Chip(label: Text(c.platform, style: const TextStyle(fontSize: 10)), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact))),
      const Spacer(),
      if (post.status == 'draft' || post.status == 'pending_approval') TextButton.icon(onPressed: onApprove, icon: const Icon(Icons.check_circle_outline, size: 18), label: const Text('Approve')),
    ]),
  ])));
}

class _ErrorBanner extends StatelessWidget { const _ErrorBanner(this.message); final String message; @override Widget build(BuildContext context) => Container(width: double.infinity, color: const Color(0xFFFFE9E9), padding: const EdgeInsets.all(10), margin: const EdgeInsets.only(bottom: 16), child: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF9D2828)))); }
