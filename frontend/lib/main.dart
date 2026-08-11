import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/marketing_provider.dart';
import 'views/marketing_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SocialFlowApp());
}

class SocialFlowApp extends StatelessWidget {
  const SocialFlowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarketingProvider(),
      child: MaterialApp(
        title: 'SocialFlow Orchestrator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
          scaffoldBackgroundColor: const Color(0xFFF0F2F5),
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
        ),
        home: const MarketingDashboard(),
      ),
    );
  }
}
