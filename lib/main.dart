import 'package:flutter/material.dart';
import 'package:school_management/screens/auth/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import 'constants/platform.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bdzgizoethysncevinzg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJkemdpem9ldGh5c25jZXZpbnpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDM1OTk0NTksImV4cCI6MjAxOTE3NTQ1OX0.KXXytnd6IxU54dREsihH6NUMrOulUVRLI5XSgAvO1mk',
    authFlowType: AuthFlowType.pkce,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SignIn(),
    );
  }
}
