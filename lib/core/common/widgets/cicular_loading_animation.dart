import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CircularLoadingScreen extends StatefulWidget {
  const CircularLoadingScreen({super.key});

  @override
  State<CircularLoadingScreen> createState() => _CircularLoadingScreenState();
}

class _CircularLoadingScreenState extends State<CircularLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Lottie.asset("assets/animations/loading_circular.lottie"),
        ),
      ),
    );
  }
}
