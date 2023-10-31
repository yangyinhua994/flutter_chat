// ignore_for_file: unused_import, avoid_print

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tencent_chat_push_for_china/tencent_chat_push_for_china.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

import 'package:tencent_cloud_chat_demo/src/config.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/privacy/privacy_webview.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/src/routes.dart';
import 'package:tencent_cloud_chat_demo/utils/GenerateUserSig.dart';
import 'package:tencent_cloud_chat_demo/utils/commonUtils.dart';
import 'package:tencent_cloud_chat_demo/utils/push/channel/channel_push.dart';
import 'package:tencent_cloud_chat_demo/utils/push/push_constant.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

class LoginAuto extends StatelessWidget {
  final Function? initIMSDK;
  const LoginAuto({Key? key, this.initIMSDK}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    userLogin();
    return Container();
  }

  userLogin() async {

    // 杨银华 用户id
    String userID = '1';

    final CoreServicesImpl coreInstance = TIMUIKitCore.getInstance();
    String key = IMDemoConfig.key;
    int sdkAppId = IMDemoConfig.sdkappid;
    if (key == "") {
      ToastUtils.toast(TIM_t("请在环境变量中写入key"));
      return;
    }
    GenerateTestUserSig generateTestUserSig = GenerateTestUserSig(
      sdkappid: sdkAppId,
      key: key,
    );

    String userSig =
    generateTestUserSig.genSig(identifier: userID, expire: 99999);

    var data = await coreInstance.login(
      userID: userID,
      userSig: userSig,
    );
    if (data.code != 0) {
      final option1 = data.desc;
      ToastUtils.toast(
          TIM_t_para("登录失败{{option1}}", "登录失败$option1")(option1: option1));
      return;
    }

    // Initialize the poll plug-in
    TencentCloudChatVotePlugin.initPlugin();

    Routes().directToHomePage();
  }

}



