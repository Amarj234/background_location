

import 'package:flutter/material.dart';

class IosShow extends StatefulWidget {
  const IosShow({super.key});

  @override
  State<IosShow> createState() => _IosShowState();
}

class _IosShowState extends State<IosShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Center(child: Text("Aamarjeet"),)),
    );
  }
}
