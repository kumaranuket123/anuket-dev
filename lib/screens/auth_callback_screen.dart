import 'package:flutter/material.dart';

class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  String message = "Verifying...";

  @override
  void initState() {
    super.initState();
    // Use WidgetsBinding to call handleAuth after initial frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleAuth();
    });
  }

  Future<void> handleAuth() async {
    final uri = Uri.base;
    final type = uri.queryParameters['type'];

    // Provide a small delay for smoother user experience
    await Future.delayed(const Duration(seconds: 1));

    if (type == 'signup') {
      setState(() {
        message = "✅ Your email is confirmed successfully!";
      });
    } else {
      setState(() {
        message = "Something went wrong ❌";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            message,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
