import 'package:animated_text_field/animated_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

toast({msg, context}) {
  showToast(
    msg,
    context: context,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    position: StyledToastPosition.center,
    animDuration: Duration(seconds: 1),
    duration: Duration(seconds: 4),
    curve: Curves.elasticOut,
    reverseCurve: Curves.linear,
  );
}

Widget loadingScreen() {
  return Center(
    child: LoadingAnimationWidget.inkDrop(
      color: Colors.white,
      size: 50,
    ),
  );
}

Widget myButton({required formKey, required String label, required Function function, required Icon icon}) {
  return TextButton.icon(
    onPressed: () {
      if (formKey.currentState!.validate()) {
        function();
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
  required bool obscure,
  context,
  initialValue,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.height / 2,
    // height: 20,
    child: TextFormField(
      // errorKey: errorKey,
      controller: textController,
      keyboardType: keyboardType,
      enabled: enabled,
      // obscureText: ,
      obscureText: obscure,
      initialValue: initialValue,
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
        if (value!.isNotEmpty) {
          if (hintText == 'Password' || hintText == 'Confirm Password') {
            if (!value.hasPasswordLength(length: 6)) {
              return "Password must be at least 6 characters";
            }
          } else if (hintText == 'Email') {
            if (!value.isEmail()) {
              return "Invalid email";
            }
          }
        } else if (value.isEmpty) {
          return 'This Field Cannot be Empty!';
        }
        return null;
      },
    ),
  );
}
