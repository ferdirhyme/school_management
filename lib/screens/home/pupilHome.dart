import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PupilHome extends StatefulWidget {
  const PupilHome({super.key});

  @override
  State<PupilHome> createState() => _PupilHomeState();
}

class _PupilHomeState extends State<PupilHome> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar:  AppBar(title: const Text('Pupil Dashboard'),),
    );
  }
}