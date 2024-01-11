import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HeadTeacherHome extends StatefulWidget {
  const HeadTeacherHome({super.key});

  @override
  State<HeadTeacherHome> createState() => _HeadTeacherHomeState();
}

class _HeadTeacherHomeState extends State<HeadTeacherHome> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar:  AppBar(title: const Text('Headteacher Dashboard'),),
    );
  }
}