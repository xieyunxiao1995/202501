import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/screens/login/invitation_screen.dart';
import 'package:zhenyu_flutter/screens/main_frame.dart';
import 'package:zhenyu_flutter/screens/user/personal_data_screen.dart';
import 'package:zhenyu_flutter/utils/common.dart';

Future<void> handleRegistrationSuccess(
  State state,
  LoginRespData loginData, {
  bool redirectToPersonalData = false,
}) async {
  if (!state.mounted) return;

  // Use UserProvider to save user data and initialize
  final userProvider = Provider.of<UserProvider>(state.context, listen: false);
  await userProvider.saveUser(loginData);

  // Show loading dialog
  if (!state.mounted) return;
  showDialog(
    context: state.context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );

  // Fetch user details, config, and setup IM (same as login flow)
  await userProvider.fetchUserMeInfo();
  await userProvider.fetchInitConfig();
  await userProvider.setupImAfterAuth(); // Setup IM after getting config

  // Close loading dialog
  if (!state.mounted) return;
  Navigator.of(state.context).pop();

  if (!state.mounted) return;
  showMsg(state.context, '注册成功！');

  Future.delayed(const Duration(milliseconds: 800), () {
    if (!state.mounted) return;

    final hasReview =
        loginData.reviewParam != null &&
        loginData.reviewParam!.isNotEmpty &&
        loginData.reviewStatus != null;

    final route = MaterialPageRoute(
      builder: (context) {
        if (hasReview) {
          return InvitationScreen(
            reviewParam: loginData.reviewParam,
            reviewStatus: loginData.reviewStatus,
          );
        }
        if (redirectToPersonalData) {
          return const PersonalDataScreen();
        }
        return const MainFrame();
      },
    );

    Navigator.of(
      state.context,
    ).pushAndRemoveUntil(route, (Route<dynamic> _) => false);
  });
}
