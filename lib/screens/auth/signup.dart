import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:gap/gap.dart';
import 'package:school_management/screens/auth/authService.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/field.dart';
import '../../models/adduserModel.dart';
import 'checklogin.dart';
import 'databaseService.dart';

class SignUp extends StatefulWidget {
  final String roll;
  const SignUp({super.key, required this.roll});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static List<String> schools = <String>[' '];
  String dropdownValue = schools.first;
  final formKey = GlobalKey<FormState>();
  final _formKeyHead = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emisCodeController = TextEditingController();
  final TextEditingController staffIDController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController admissionNumberController = TextEditingController();
  AddUserData data = AddUserData();
  bool loading = false;
  supaDatabaseService databaseService = supaDatabaseService();
  bool enabled = false;
  int i = 0;

  void submitData() {
    setState(() {
      loading = true;
    });
    if (passwordController.text == confirmPasswordController.text) {
      data.email = emailController.text;
      data.emisCode = emisCodeController.text;
      data.name = nameController.text;
      data.password = passwordController.text;
      data.school = dropdownValue;
      data.staffID = staffIDController.text;
      data.admissionNumber = admissionNumberController.text;

      var res = AuthService().signupUser(widget.roll, data);
      res.then((e) {
        setState(() {
          loading = false;
        });
        if (e.toString() == '') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const CheckLogin()),
          );
          toast(msg: 'Successful!', context: context);
        } else {
          toast(msg: e.toString(), context: context);
        }
      });
      // toast(context: context, msg: res.);
    } else {
      toast(msg: 'Passwords do not match!', context: context);
    }
  }

  @override
  void initState() {
    databaseService.schools.forEach((e) {
      i = e.length;
      for (int k = 0; k <= i - 1; k++) {
        schools.add(e[k]['institution']);
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('${widget.roll} Sign Up'),
        centerTitle: true,
        // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back))],
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
      ),
      body: loading == false
          ? Center(
              child: widget.roll == 'headteacher'
                  ? Form(
                      key: _formKeyHead,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const Gap(30),
                            DropdownMenu(
                              menuStyle: MenuStyle(
                                elevation: MaterialStateProperty.all(10),
                              ),
                              width: 250,
                              trailingIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              initialSelection: schools.first,
                              label: const Text(
                                'Select Your School',
                                style: TextStyle(color: Colors.black),
                              ),
                              enableSearch: true,
                              enableFilter: true,
                              menuHeight: 250,
                              onSelected: (String? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  dropdownValue = value!;
                                  if (value != ' ') {
                                    enabled = true;
                                  } else {
                                    enabled = false;
                                  }
                                  passwordController.text = '';
                                  emailController.text = '';
                                  nameController.text = '';
                                  confirmPasswordController.text = '';
                                  staffIDController.text = '';
                                  emisCodeController.text = '';
                                  admissionNumberController.text = '';
                                });
                              },
                              dropdownMenuEntries: schools.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(value: value, label: value);
                              }).toList(),
                            ),
                            const Gap(20),
                            myTextField(
                              context: context,
                              enabled: enabled,
                              errorKey: 'emis_code',
                              hintText: 'Emis Code',
                              keyboardType: TextInputType.number,
                              obscure: false,
                              preFixIcon: const Icon(Icons.code),
                              textController: emisCodeController,
                            ),
                            const Gap(2),
                            myTextField(
                              context: context,
                              enabled: enabled,
                              errorKey: 'email',
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              obscure: false,
                              preFixIcon: const Icon(Icons.email),
                              textController: emailController,
                            ),
                            const Gap(2),
                            myTextField(
                              context: context,
                              enabled: enabled,
                              errorKey: 'Password',
                              hintText: 'Password',
                              keyboardType: TextInputType.text,
                              obscure: true,
                              preFixIcon: const Icon(Icons.lock),
                              textController: passwordController,
                            ),
                            const Gap(2),
                            myTextField(
                              context: context,
                              enabled: enabled,
                              errorKey: 'Passworda',
                              hintText: 'Confirm Password',
                              keyboardType: TextInputType.text,
                              obscure: true,
                              preFixIcon: const Icon(Icons.lock),
                              textController: confirmPasswordController,
                            ),
                            const Gap(15),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: myButton(
                                formKey: _formKeyHead,
                                label: 'SIGN UP',
                                icon: const Icon(Icons.join_full),
                                function: () {
                                  if (dropdownValue.isNotEmpty || dropdownValue != ' ') {
                                    submitData();
                                  } else {
                                    toast(context: context, msg: 'Please Select Your School');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )

                  // Teacher **********************************************//
                  : widget.roll == 'teacher'
                      ? Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const Gap(30),
                              DropdownMenu(
                                menuStyle: MenuStyle(
                                  elevation: MaterialStateProperty.all(10),
                                ),
                                width: 250,
                                trailingIcon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                initialSelection: schools.first,
                                label: const Text(
                                  'Select Your School',
                                  style: TextStyle(color: Colors.black),
                                ),
                                enableSearch: true,
                                enableFilter: true,
                                menuHeight: 250,
                                onSelected: (String? value) {
                                  // This is called when the user selects an item.
                                  setState(() {
                                    dropdownValue = value!;
                                    if (value != ' ') {
                                      enabled = true;
                                    } else {
                                      enabled = false;
                                    }
                                    passwordController.text = '';
                                    emailController.text = '';
                                    nameController.text = '';
                                    confirmPasswordController.text = '';
                                    staffIDController.text = '';
                                    emisCodeController.text = '';
                                    admissionNumberController.text = '';
                                  });
                                },
                                dropdownMenuEntries: schools.map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(value: value, label: value);
                                }).toList(),
                              ),
                              const Gap(20),
                              myTextField(
                                context: context,
                                enabled: enabled,
                                errorKey: 'staffid',
                                hintText: 'Staff ID',
                                keyboardType: TextInputType.number,
                                obscure: false,
                                preFixIcon: const Icon(Icons.code),
                                textController: staffIDController,
                              ),
                              const Gap(2),
                              myTextField(
                                context: context,
                                enabled: enabled,
                                errorKey: 'name',
                                hintText: 'Name',
                                keyboardType: TextInputType.emailAddress,
                                obscure: false,
                                preFixIcon: const Icon(Icons.person),
                                textController: nameController,
                              ),
                              const Gap(2),
                              myTextField(
                                context: context,
                                enabled: enabled,
                                errorKey: 'email',
                                hintText: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                obscure: false,
                                preFixIcon: const Icon(Icons.email),
                                textController: emailController,
                              ),
                              const Gap(2),
                              myTextField(
                                context: context,
                                enabled: enabled,
                                errorKey: 'Password',
                                hintText: 'Password',
                                keyboardType: TextInputType.text,
                                obscure: true,
                                preFixIcon: const Icon(Icons.lock),
                                textController: passwordController,
                              ),
                              const Gap(2),
                              myTextField(
                                context: context,
                                enabled: enabled,
                                errorKey: 'Password',
                                hintText: 'Confirm Password',
                                keyboardType: TextInputType.text,
                                obscure: true,
                                preFixIcon: const Icon(Icons.lock),
                                textController: confirmPasswordController,
                              ),
                              const Gap(15),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: myButton(
                                  formKey: formKey,
                                  label: 'SIGN UP',
                                  icon: const Icon(Icons.join_full),
                                  function: () {
                                    if (dropdownValue.isNotEmpty || dropdownValue != ' ') {
                                      submitData();
                                    } else {
                                      toast(context: context, msg: 'Please Select Your School');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      // Admin*****************************
                      : widget.roll == 'admin'
                          ? Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  const Gap(20),
                                  myTextField(
                                    context: context,
                                    enabled: true,
                                    errorKey: 'staffid',
                                    hintText: 'Staff ID',
                                    keyboardType: TextInputType.number,
                                    obscure: false,
                                    preFixIcon: const Icon(Icons.code),

                                    // textController: emailController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: true,
                                    errorKey: 'name',
                                    hintText: 'Name',
                                    keyboardType: TextInputType.emailAddress,
                                    obscure: false,
                                    preFixIcon: const Icon(Icons.person),
                                    textController: nameController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: true,
                                    errorKey: 'email',
                                    hintText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    obscure: false,
                                    preFixIcon: const Icon(Icons.email),
                                    textController: emailController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: true,
                                    errorKey: 'Password',
                                    hintText: 'Password',
                                    keyboardType: TextInputType.text,
                                    obscure: true,
                                    preFixIcon: const Icon(Icons.lock),
                                    textController: passwordController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: true,
                                    errorKey: 'Password',
                                    hintText: 'Confirm Password',
                                    keyboardType: TextInputType.text,
                                    obscure: true,
                                    preFixIcon: const Icon(Icons.lock),
                                    textController: confirmPasswordController,
                                  ),
                                  const Gap(15),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: myButton(
                                      formKey: formKey,
                                      label: 'SIGN UP',
                                      icon: const Icon(Icons.join_full),
                                      function: () {
                                        if (dropdownValue.isNotEmpty || dropdownValue != ' ') {
                                          submitData();
                                        } else {
                                          toast(context: context, msg: 'Please Select Your School');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )

                          // Pupils*****************************************
                          : Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  const Gap(30),
                                  DropdownMenu(
                                    menuStyle: MenuStyle(
                                      elevation: MaterialStateProperty.all(10),
                                    ),
                                    width: 250,
                                    trailingIcon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black,
                                    ),
                                    initialSelection: schools.first,
                                    label: const Text(
                                      'Select Your School',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    enableSearch: true,
                                    enableFilter: true,
                                    menuHeight: 250,
                                    onSelected: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        dropdownValue = value!;
                                        if (value.isNotEmpty) {
                                          enabled = true;
                                        } else {
                                          enabled = false;
                                        }
                                        passwordController.text = '';
                                        emailController.text = '';
                                        nameController.text = '';
                                        confirmPasswordController.text = '';
                                        staffIDController.text = '';
                                        emisCodeController.text = '';
                                        admissionNumberController.text = '';
                                      });
                                    },
                                    dropdownMenuEntries: schools.map<DropdownMenuEntry<String>>((String value) {
                                      return DropdownMenuEntry<String>(value: value, label: value);
                                    }).toList(),
                                  ),
                                  const Gap(20),
                                  myTextField(
                                    context: context,
                                    enabled: enabled,
                                    errorKey: 'admissionNumber',
                                    hintText: 'Admission Number',
                                    keyboardType: TextInputType.number,
                                    obscure: false,
                                    preFixIcon: const Icon(Icons.code),
                                    textController: admissionNumberController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: enabled,
                                    errorKey: 'name',
                                    hintText: 'Name',
                                    keyboardType: TextInputType.emailAddress,
                                    obscure: false,
                                    preFixIcon: const Icon(Icons.person),
                                    textController: nameController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: enabled,
                                    errorKey: 'email',
                                    hintText: 'Email',
                                    keyboardType: TextInputType.emailAddress,
                                    obscure: false,
                                    preFixIcon: const Icon(Icons.email),
                                    textController: emailController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: enabled,
                                    errorKey: 'Password',
                                    hintText: 'Password',
                                    keyboardType: TextInputType.text,
                                    obscure: true,
                                    preFixIcon: const Icon(Icons.lock),
                                    textController: passwordController,
                                  ),
                                  const Gap(2),
                                  myTextField(
                                    context: context,
                                    enabled: enabled,
                                    errorKey: 'Password',
                                    hintText: 'Confirm Password',
                                    keyboardType: TextInputType.text,
                                    obscure: true,
                                    preFixIcon: const Icon(Icons.lock),
                                    textController: confirmPasswordController,
                                  ),
                                  const Gap(15),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: myButton(
                                      formKey: formKey,
                                      label: 'SIGN UP',
                                      icon: const Icon(Icons.join_full),
                                      function: () {
                                        if (dropdownValue.isNotEmpty || dropdownValue != ' ') {
                                          submitData();
                                        } else {
                                          toast(context: context, msg: 'Please Select Your School');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
            )
          : loadingScreen(),
    );
  }
}
