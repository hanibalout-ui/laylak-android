import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LaylakApp());
}

class LaylakApp extends StatelessWidget {
  const LaylakApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Laylak Restaurant',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFF4EBDD)),
        home: const LaylakScreen(),
      );
}

class LaylakScreen extends StatefulWidget {
  const LaylakScreen({super.key});
  @override
  State<LaylakScreen> createState() => _LaylakScreenState();
}

class _LaylakScreenState extends State<LaylakScreen> {
  late final WebViewController controller;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF4EBDD))
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) { if (mounted) setState(() => loading = false); },
        onWebResourceError: (e) {
          if (e.isForMainFrame == true && mounted) {
            setState(() { loading = false; error = e.description; });
          }
        },
      ))
      ..loadFlutterAsset('assets/index.html');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(children: [
            WebViewWidget(controller: controller),
            if (loading) const Center(child: CircularProgressIndicator()),
            if (error != null) Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Fehler beim Laden: $error'),
            )),
          ]),
        ),
      );
}
