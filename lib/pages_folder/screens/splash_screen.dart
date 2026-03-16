// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:zedbee_bms/widgets_folder/widgets/loading_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // loading time
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/splash1.png", fit: BoxFit.cover),
          Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Image.asset(
                  "assets/logo.png",
                  height: 40,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                Spacer(),
                AppLoader(),
                Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
