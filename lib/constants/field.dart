import 'package:animated_text_field/animated_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:vph_web_date_picker/vph_web_date_picker.dart';

toast({msg, context}) {
  showToast(
    msg,
    context: context,
    animation: StyledToastAnimation.scale,
    reverseAnimation: StyledToastAnimation.fade,
    position: StyledToastPosition.center,
    animDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 4),
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

Widget datefield({
  key,
  dateController,
  selectedDate,
  context,
  hintText,
  preFixIcon,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.height / 2,
    child: TextFormField(
      key: key,
      controller: dateController,
      keyboardType: TextInputType.datetime,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        // LengthLimitingTextInputFormatter(8), // Limit to 8 digits (YYYYMMDD)
        // Custom formatter for date
      ],
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
          return null;
        }
        return 'This Field Cannot be Empty!';
      },
      onTap: () async {
        final pickedDate = await showWebDatePicker(
          context: key.currentContext!,
          initialDate: selectedDate,

          // firstDate: DateTime.now().subtract(const Duration(days: 7)),
          // lastDate: DateTime.now().add(const Duration(days: 14000)),
          //width: 300,
          //withoutActionButtons: true,
          //weekendDaysColor: Colors.red,
        );
        if (pickedDate != null) {
          selectedDate = pickedDate.toString().split(' ')[0];
          dateController.text = pickedDate.toString().split(' ')[0];
        }
      },
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
  required Function ontap,
  Key? key,
  inputformat,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.height / 2,
    // height: 20,
    child: TextFormField(
      // errorKey: errorKey,
      inputFormatters: inputformat,
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
      onTap: ontap(),
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
