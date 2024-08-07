import 'package:flutter/material.dart';
import 'package:view/generated/assets.gen.dart';
import 'package:view/types_def.dart';

class SplashPage extends StatefulWidget {
  final OpenRoute? goHome;

  const SplashPage({this.goHome, super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || !context.mounted) return;
      widget.goHome?.call(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Assets.logoArchitecture.image(
          width: 180,
          height: 180,
        ),
      ),
    );
  }
}
