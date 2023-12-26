import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

import '../../constants/field.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emisCodeController = TextEditingController();
  final TextEditingController staffIDController = TextEditingController();

  supaDatabaseService databaseService = supaDatabaseService();
  bool enabled = false;
  int i = 0;

  @override
  void initState() {
    databaseService.schools.forEach((e) {
      i = e.length;
      for (int k = 0; k <= i - 1; k++) {
        // print('$k. ' + e[k]['institution']);
        schools.add(e[k]['institution']);
      }
    });

    // databaseService.schools.forEach((e) {
    //   print(e[1]['institution']);
    // });

    // for (int i = 0; i <= databaseService.schools.length - 1; i++){

    // }
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
      body: Center(
        child: Form(
            key: formKey,
            // headteacher*********************************************//
            child: widget.roll == 'Headteacher'
                ? Column(
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
                      const Gap(15),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: myButton(
                          formKey: formKey,
                          label: 'SIGN UP',
                          icon: const Icon(Icons.join_full),
                          function: () {},
                        ),
                      ),
                    ],
                  )

                // Teacher **********************************************//
                : widget.roll == 'Teacher'
                    ? Column(
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
                            // textController: emailController,
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
                            // textController: emailController,
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
                            // textController: emailController,
                          ),
                          const Gap(15),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: myButton(
                              formKey: formKey,
                              label: 'SIGN UP',
                              icon: const Icon(Icons.join_full),
                              function: () {},
                            ),
                          ),
                        ],
                      )
                    // Admin*****************************
                    : widget.roll == 'Admin'
                        ? Column(
                            children: [
                              const Gap(20),
                              myTextField(
                                context: context,
                                enabled: enabled,
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
                                // textController: emailController,
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
                                // textController: emailController,
                              ),
                              const Gap(15),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: myButton(
                                  formKey: formKey,
                                  label: 'SIGN UP',
                                  icon: const Icon(Icons.join_full),
                                  function: () {},
                                ),
                              ),
                            ],
                          )

                        // Pupils*****************************************
                        : Column(
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
                                // textController: emailController,
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
                                // textController: emailController,
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
                                // textController: emailController,
                              ),
                              const Gap(15),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: myButton(
                                  formKey: formKey,
                                  label: 'SIGN UP',
                                  icon: const Icon(Icons.join_full),
                                  function: () {},
                                ),
                              ),
                            ],
                          )),
      ),
    );
  }
}
