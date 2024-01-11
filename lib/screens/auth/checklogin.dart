// import 'package:flutter/material.dart';
// import 'package:school_management/screens/auth/signin.dart';
// import 'package:school_management/screens/home/adminHome.dart';
// import 'package:school_management/screens/home/headTeacherHome.dart';
// import 'package:school_management/screens/home/pupilHome.dart';
// import 'package:school_management/screens/home/teacherHome.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class CheckLogin extends StatefulWidget {
//   const CheckLogin({super.key});

//   @override
//   _CheckLoginState createState() => _CheckLoginState();
// }

// class _CheckLoginState extends State<CheckLogin> {
//   final client = Supabase.instance.client;
//   List status = [];

//   @override
//   void initState() {
//     super.initState();

//     _redirect(context);
//   }

//   Future<List> getUserStatus(id) async {
//     final userStatus = await client.from('user_status').select('status, password').match({'id': id});
//     return userStatus;
//   }

//   Future<void> _redirect(BuildContext context) async {
//     await Future.delayed(Duration.zero);

//     if (!mounted) {
//       return;
//     }

//     final session = client.auth.currentSession;
//     // final session = Supabase.instance.client.auth.currentSession;

//     // print(session);
//     if (session != null) {
//       final usreStatus = getUserStatus(session.user.id);

//       await usreStatus.then((value) {
//         status = value;
//       });

//       if (status[0] == 'admin') {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const AdminHome(),
//         ));
//       } else if (status[0] == 'headteacher') {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const HeadTeacherHome(),
//         ));
//       } else if (status[0] == 'teacher') {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const TeacherHome(),
//         ));
//       } else if (status[0] == 'pupil') {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const PupilHome(),
//         ));
//       }
//     } else {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const SignIn(),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:school_management/screens/auth/signin.dart';
import 'package:school_management/screens/home/adminHome.dart';
import 'package:school_management/screens/home/headTeacherHome.dart';
import 'package:school_management/screens/home/pupilHome.dart';
import 'package:school_management/screens/home/teacherHome.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckLogin extends StatefulWidget {
  const CheckLogin({super.key});

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  final client = Supabase.instance.client;
  List status = [];

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<List> getUserStatus(id) async {
    final userStatus = await client.from('user_status').select('status').match({'id': id});
    return userStatus;
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);

    if (!mounted) {
      return;
    }

    final session = client.auth.currentSession;
    // final session = Supabase.instance.client.auth.currentSession;
    // print(session);
    if (session != null) {
      final userStatus = await getUserStatus(session.user.id);
      setState(() {
        status = userStatus;
      });
      _navigateBasedOnStatus(context);
    } else {
      _navigateToSignIn(context);
    }
  }

  void _navigateBasedOnStatus(BuildContext context) {
    if (status.isNotEmpty) {
      if (status[0]['status'] == 'admin') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminHome()),
        );
      } else if (status[0]['status'] == 'headteacher') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HeadTeacherHome()),
        );
      } else if (status[0]['status'] == 'teacher') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TeacherHome()),
        );
      } else if (status[0]['status'] == 'pupil') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PupilHome()),
        );
      }
    } else {
      _redirect();
    }
  }

  void _navigateToSignIn(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
