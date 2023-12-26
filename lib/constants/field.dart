import 'package:animated_text_field/animated_text_field.dart';
import 'package:flutter/material.dart';

Widget myButton({required formKey, required String label, required Function function, required Icon icon}) {
  return TextButton.icon(
    onPressed: () {
      if (formKey.currentState!.validate()) {
        function;
      }
    },
    icon: icon,
    label: Text(label),
    style: const ButtonStyle(
      iconColor: MaterialStatePropertyAll(Colors.amber),
      backgroundColor: MaterialStatePropertyAll(Colors.black),
      elevation: MaterialStatePropertyAll(20),
      textStyle: MaterialStatePropertyAll(
        TextStyle(color: Colors.black),
      ),
    ),
  );
}

Widget myTextField({
  textController,
  TextInputType? keyboardType,
  Icon? preFixIcon,
  String? hintText,
  errorKey,
  bool? enabled,
  bool? obscure,
  context,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.height / 2,
    // height: 20,
    child: CustomTextField(
      errorKey: errorKey,
      controller: textController,
      keyboardType: keyboardType,
      enabled: enabled,
      obscureText: obscure,
      decoration: CustomTextInputDecoration(
        fillColor: Colors.white,
        prefixIcon: preFixIcon,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
      validator: (String? value) {
        print(value.runtimeType);
        if (value != '') {
          if (hintText == 'Password' || hintText == 'Confirm Password') {
            if (!value!.hasPasswordLength(
                //using TextErrorService to validate password
                length: 6)) {
              return "Password must be at least 6 characters";
            }
          } else if (hintText == 'Email') {
            if (!value!.isEmail()) {
              return "Invalid email";
            }
          } else {
            return null;
          }
        } else {
          return 'This Field Cannot be Empty!';
        }
        // return null;
      },
    ),
  );
}
