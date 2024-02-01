import 'package:animated_text_field/animated_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school_management/constants/field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/colors.dart';
import 'checklogin.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static const List<String> userRolls = <String>['', 'Pupil', 'Teacher', 'Headteacher', 'Admin'];
  String dropdownValue = userRolls.first;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  // bool enabled = false;
  final client = Supabase.instance.client;
  bool loading = false;

  showAlertDialog() {
    // set up the buttons
    Widget pupilButton = TextButton(
      child: const Text("Pupil"),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SignUp(roll: 'pupil'),
          ),
        );
      },
    );
    Widget teacherButton = TextButton(
      child: const Text("Teacher"),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SignUp(roll: 'teacher'),
        ));
      },
    );

    Widget headTeacherButton = TextButton(
      child: const Text("Headteacher"),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SignUp(roll: 'headteacher'),
        ));
      },
    );

    Widget adminButton = TextButton(
      child: const Text("Admin"),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const SignUp(roll: 'admin'),
        ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Selcet Your Roll"),
      elevation: 20,
      scrollable: true,
      // content: Text("Are you sure you want to delete $name from your Staff List?"),
      actions: [pupilButton, teacherButton, headTeacherButton, adminButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: generalColor,
        body: Center(
          child: !loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 6,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage('assets/imgs/logo.png'), fit: BoxFit.contain),
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Welcome To Tema Metro Schools Management System',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          decorationThickness: 20,
                          // fontSize: 20,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: GoogleFonts.lato(
                                  textStyle: Theme.of(context).textTheme.headlineLarge, decorationThickness: 20, fontSize: 20, color: Colors.black),
                            ),
                            const Gap(10),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.height / 3.5,
                            //   child: DropdownMenu(
                            //     menuStyle: MenuStyle(
                            //       elevation: MaterialStateProperty.all(10),
                            //     ),
                            //     trailingIcon: const Icon(
                            //       Icons.arrow_drop_down,
                            //       color: Colors.black,
                            //     ),
                            //     initialSelection: userRolls.first,
                            //     label: const Text(
                            //       'Select Roll',
                            //       style: TextStyle(color: Colors.black),
                            //     ),
                            //     textStyle: const TextStyle(color: Colors.black),
                            //     // inputDecorationTheme: const InputDecorationTheme(fillColor: Colors.white),
                            //     enableSearch: true,
                            //     enableFilter: false,

                            //     onSelected: (String? value) {
                            //       // This is called when the user selects an item.
                            //       setState(() {
                            //         dropdownValue = value!;
                            //         if (value != '') {
                            //           enabled = true;
                            //         } else {
                            //           enabled = false;
                            //         }
                            //         passwordController.text = '';
                            //         emailController.text = '';
                            //       });
                            //     },
                            //     dropdownMenuEntries: userRolls.map<DropdownMenuEntry<String>>((String value) {
                            //       return DropdownMenuEntry<String>(value: value, label: value);
                            //     }).toList(),
                            //   ),
                            // ),
                            // const Gap(10),
                            myTextField(
                              hintText: 'Email',
                              context: context,
                              keyboardType: TextInputType.emailAddress,
                              preFixIcon: const Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              textController: emailController,
                              enabled: true,
                              errorKey: 'email',
                              obscure: false,
                            ),
                            const Gap(10),
                            myTextField(
                              hintText: 'Password',
                              context: context,
                              keyboardType: TextInputType.emailAddress,
                              preFixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              textController: passwordController,
                              enabled: true,
                              errorKey: 'password',
                              obscure: true,
                            ),
                            const Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Gap(40),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: myButton(
                                    formKey: _formKey,
                                    label: 'SIGN IN',
                                    icon: const Icon(Icons.login),
                                    function: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      try {
                                        var results = await client.auth.signInWithPassword(
                                          password: passwordController.text,
                                          email: emailController.text,
                                        );

                                        if (results.user!.id.isNotEmpty) {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(builder: (context) => const CheckLogin()),
                                          );
                                        }

                                        setState(() {
                                          loading = false;
                                        });
                                      } catch (e) {
                                        setState(() {
                                          loading = false;
                                        });
                                        toast(context: context, msg: e.toString());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Forgot Password?',
                                        style: TextStyle(color: Colors.black, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                        onPressed: () {
                                          showAlertDialog();
                                        },
                                        child: const Text(
                                          'SignUp',
                                          style: TextStyle(color: Colors.black, fontSize: 20),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : loadingScreen(),
        ),
      ),
    );
  }
}
