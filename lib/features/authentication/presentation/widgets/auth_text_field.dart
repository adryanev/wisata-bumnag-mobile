import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wisatabumnag/core/utils/colors.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    this.hint,
    this.isPassword = false,
    required this.label,
    required this.controller,
    required this.validator,
    this.textInputAction,
  });
  final String? hint;
  final bool isPassword;
  final String label;
  final TextEditingController controller;
  final String? validator;
  final TextInputAction? textInputAction;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool isObscure = false;

  @override
  void initState() {
    if (widget.isPassword) {
      isObscure = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColor.secondBlack,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        TextFormField(
          key: widget.key,
          controller: widget.controller,
          obscureText: isObscure,
          validator: (_) => widget.validator,
          style: TextStyle(fontSize: 12.sp),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: widget.textInputAction ?? TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10.r),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColor.borderStroke,
              ),
              borderRadius: BorderRadius.circular(
                12.r,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColor.borderStroke,
              ),
              borderRadius: BorderRadius.circular(
                12.r,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColor.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(
                color: AppColor.red,
              ),
            ),
            hintText: widget.hint,
            hintStyle: const TextStyle(
              color: AppColor.hint,
            ),
            suffixIcon: widget.isPassword
                ? InkWell(
                    onTap: () {
                      if (widget.isPassword) {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      }
                    },
                    child: Icon(
                      !isObscure
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
