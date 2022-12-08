import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wisatabumnag/app/router/app_router.dart';
import 'package:wisatabumnag/core/utils/colors.dart';

class AccountSettingPage extends StatelessWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                context.pushNamed(AppRouter.profileForm);
              },
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                leading: const Icon(
                  Icons.person_rounded,
                  color: AppColor.darkGrey,
                ),
                title: const Text(
                  'Ubah Profil',
                  style: TextStyle(
                    color: AppColor.secondBlack,
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 2.h,
              color: AppColor.grey,
            ),
            InkWell(
              onTap: () {
                context.pushNamed(AppRouter.passwordForm);
              },
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                leading: const Icon(
                  Icons.lock_open_rounded,
                  color: AppColor.darkGrey,
                ),
                title: const Text(
                  'Ganti Password',
                  style: TextStyle(
                    color: AppColor.secondBlack,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
