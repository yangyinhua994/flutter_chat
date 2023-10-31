import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/src/pages/cross_platform/wide_screen/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/home_page.dart';
import 'package:tencent_cloud_chat_demo/src/pages/login.dart';
import 'package:tencent_cloud_chat_demo/src/pages/loginAuto.dart';
import 'package:tencent_cloud_chat_demo/src/provider/custom_sticker_package.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:tencent_cloud_chat_demo/utils/constant.dart';
import 'package:tencent_cloud_chat_demo/utils/theme.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/utils/toast.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

import '../src/config.dart';
import '../src/routes.dart';
import 'GenerateUserSig.dart';

class InitStep {
  static setTheme(String themeTypeString, BuildContext context) {
    final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();
    ThemeType themeType = DefTheme.themeTypeFromString(themeTypeString);
    Provider.of<DefaultThemeData>(context, listen: false).currentThemeType =
        themeType;
    Provider.of<DefaultThemeData>(context, listen: false).theme =
    DefTheme.defaultTheme[themeType]!;
    _coreInstance.setTheme(theme: DefTheme.defaultTheme[themeType]!);
  }

  static setCustomSticker(BuildContext context) async {
    // 添加自定义表情包
    List<CustomStickerPackage> customStickerPackageList = [];

    customStickerPackageList.addAll(Const.emojiList.map((customEmojiPackage) {
      return CustomStickerPackage(
          name: customEmojiPackage.name,
          baseUrl: "assets/custom_face_resource/${customEmojiPackage.name}",
          isEmoji: customEmojiPackage.isEmoji,
          stickerList: customEmojiPackage.list
              .asMap()
              .keys
              .map((idx) =>
              CustomSticker(index: idx, name: customEmojiPackage.list[idx]))
              .toList(),
          menuItem: CustomSticker(
            index: 0,
            name: customEmojiPackage.icon,
          ));
    }).toList());

    Provider.of<CustomStickerPackageData>(context, listen: false)
        .customStickerPackageList = customStickerPackageList;
  }

  static void removeLocalSetting() async {
  }

  static directToLogin(BuildContext context, [Function? initIMSDKAndAddIMListeners]) {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            // child: LoginPage(initIMSDK: initIMSDKAndAddIMListeners),
            child: LoginAuto(initIMSDK: initIMSDKAndAddIMListeners),
          );
        },
      ),
      ModalRoute.withName('/'),
    );
  }

  userLogin() async {

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

  static directToHomePage(BuildContext context) {
    final isWideScreen =
        TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: isWideScreen
                  ? const HomePageWideScreen()
                  : const HomePage(),
            );
          },
          settings: const RouteSettings(name: '/homePage')),
      ModalRoute.withName('/'),
    );
  }

  static void checkLogin(BuildContext context, initIMSDKAndAddIMListeners) async {
    // 初始化IM SDK
    initIMSDKAndAddIMListeners();

    Future.delayed(const Duration(seconds: 1), () {
      directToLogin(context);
      // 修改自定义表情的执行时机
      setCustomSticker(context);
    });
  }
}