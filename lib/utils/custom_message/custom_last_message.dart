import 'package:flutter/cupertino.dart';
import 'package:tencent_cloud_chat_demo/utils/custom_message/calling_message/calling_message.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_demo/src/provider/theme.dart';
import 'package:provider/provider.dart';
// import 'package:tencent_cloud_chat_vote_plugin/tencent_cloud_chat_vote_plugin.dart';

String handleCustomMessage(V2TimMessage message) {
  final customElem = message.customElem;
  String customLastMsgShow = TIM_t("[自定义]");

  if (customElem?.data == "group_create") {
    customLastMsgShow = TIM_t("群聊创建成功！");
  }
  // if (TencentCloudChatVotePlugin.isVoteMessage(message)) {
  //   customLastMsgShow =
  //       TencentCloudChatVotePlugin.getConversationLastMessageInfo(message);
  // }
  final callingMessage = CallingMessage.getCallMessage(customElem);
  if (callingMessage != null) {
    // 如果是结束消息
    final isCallEnd = CallingMessage.isCallEndExist(callingMessage);
    final isVoiceCall = callingMessage.callType == 1;

    String? callTime = "";

    if (isCallEnd) {
      callTime = CallingMessage.getShowTime(callingMessage.callEnd!);
    }

    final option3 = callTime;
    customLastMsgShow = isCallEnd
        ? TIM_t_para("通话时间：{{option3}}", "通话时间：$option3")(option3: option3)
        : CallingMessage.getActionType(callingMessage);

    final option1 = customLastMsgShow;
    final option2 = customLastMsgShow;
    customLastMsgShow = isVoiceCall
        ? TIM_t_para("[语音通话]：{{option1}}", "[语音通话]：$option1")(option1: option1)
        : TIM_t_para("[视频通话]：{{option2}}", "[视频通话]：$option2")(option2: option2);
  }
  return customLastMsgShow;
}

Widget renderCustomMessage(V2TimMessage message, BuildContext context) {
  final theme = Provider.of<DefaultThemeData>(context).theme;
  final isWideScreen =
      TUIKitScreenUtils.getFormFactor(context) == DeviceType.Desktop;
  return Row(children: [
    Expanded(
        child: Text(
      handleCustomMessage(message),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          height: 1,
          color: theme.weakTextColor,
          fontSize: isWideScreen ? 12 : 14),
    )),
  ]);
}
