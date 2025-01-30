import 'package:flutter/material.dart';

import '../theme/theme.dart';

class CustomTextFeild extends StatelessWidget {
  final String hintText;
  final bool enabled;
  final TextEditingController? controller;
  final bool isNumber;
  final FormFieldValidator<String>? validator;
  final String? initialText;
  final Icon prefixicon;
  final bool obsecuretext;
  final IconButton? suffix;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChange;

  const CustomTextFeild({
    Key? key,
    required this.hintText,
    this.controller,
    this.enabled = true,
    required this.isNumber,
    this.validator,
    this.initialText,
    this.onSaved,
    required this.prefixicon,
    required this.obsecuretext,
    this.suffix,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
          child: Theme(
            data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                    selectionHandleColor:
                    AppColors.theme['deepPurpleColor'],
                    cursorColor: AppColors.theme['deepPurpleColor'],
                    selectionColor:
                    AppColors.theme['deepPurpleColor'].withOpacity(0.3))),
            child: TextFormField(
              enabled: enabled,
              cursorColor: AppColors.theme['deepPurpleColor'],
              onSaved: onSaved,
              onChanged: onChange,
              obscureText: obsecuretext,
              initialValue: initialText,
              keyboardType:
              isNumber ? TextInputType.number : TextInputType.emailAddress,
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.theme['ghostWhiteColor'],
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.theme['backgroundColor']),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.theme['backgroundColor']),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.theme['backgroundColor']!),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: hintText,
                hintStyle: TextStyle(
                    color: AppColors.theme['secondaryColor'].withOpacity(0.5)),
                prefixIcon: prefixicon,
                prefixIconColor: AppColors.theme['secondaryColor'],
                suffixIcon: suffix,
                suffixIconColor: AppColors.theme['secondaryColor'],
              ),
              validator: validator,
            ),
          )),
    );
  }
}