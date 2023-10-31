import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/chat_list.dart';
import 'package:tencent_cloud_chat_demo/src/provider/local_setting.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitConversation/tim_uikit_conversation_item.dart';

import '../utils/user_guide.dart';
import 'multi_platform_widget/search_entry/search_entry.dart';
import 'multi_platform_widget/search_entry/search_entry_wide.dart';

GlobalKey<_ConversationState> conversationKey = GlobalKey();

class Conversation extends StatefulWidget {
  final TIMUIKitConversationController conversationController;
  final ValueChanged<V2TimConversation?>? onConversationChanged;
  final VoidCallback? onClickSearch;
  final ValueChanged<Offset?>? onClickPlus;

  /// Used for specify the current conversation, usually used for showing the conversation indicator background color on wide screen.
  final V2TimConversation? selectedConversation;

  const Conversation(
      {Key? key,
      required this.conversationController,
      this.onConversationChanged,
      this.onClickSearch,
      this.onClickPlus,
      this.selectedConversation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  late TIMUIKitConversationController _controller;
  List<String> jumpedConversations = [];
  V2TimConversation? selectedConversation;

  @override
  void initState() {
    super.initState();
    _controller = widget.conversationController;
  }

  @override
  void didUpdateWidget(Conversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedConversation != oldWidget.selectedConversation) {
      Future.delayed(const Duration(milliseconds: 1), () {
        _controller.selectedConversation = widget.selectedConversation;
      });
    }
  }

  scrollToNextUnreadConversation() {
    final conversationList = _controller.conversationList;
    for (var element in conversationList) {
      if ((element?.unreadCount ?? 0) > 0 &&
          !jumpedConversations.contains(element!.conversationID)) {
        _controller.scrollToConversation(element.conversationID);
        jumpedConversations.add(element.conversationID);
        return;
      }
    }
    jumpedConversations.clear();
    try {
      _controller.scrollToConversation(conversationList[0]!.conversationID);
    } catch (e) {}
  }

  void _handleOnConvItemTaped(V2TimConversation? selectedConv) async {
    if (widget.onConversationChanged != null) {
      widget.onConversationChanged!(selectedConv);
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              selectedConversation: selectedConv!,
            ),
          ));
    }
  }

  _clearHistory(V2TimConversation conversationItem) {
    _controller.clearHistoryMessage(conversation: conversationItem);
  }

  _pinConversation(V2TimConversation conversation) {
    _controller.pinConversation(
        conversationID: conversation.conversationID,
        isPinned: !conversation.isPinned!);
  }

  _deleteConversation(V2TimConversation conversation) {
    _controller.deleteConversation(conversationID: conversation.conversationID);
  }

  Widget _itemBuilder(V2TimConversation conversationItem,
      [V2TimUserStatus? onlineStatus]) {
    return Row(children: [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.add),
      ),
      Expanded(
          child: InkWell(
        child: TIMUIKitConversationItem(
          faceUrl: conversationItem.faceUrl ?? "",
          nickName: conversationItem.showName ?? "",
          isDisturb: conversationItem.recvOpt != 0,
          lastMsg: conversationItem.lastMessage,
          isPined: conversationItem.isPinned ?? false,
          groupAtInfoList: conversationItem.groupAtInfoList ?? [],
          unreadCount: conversationItem.unreadCount ?? 0,
          draftText: conversationItem.draftText,
          onlineStatus: (true &&
                  conversationItem.userID != null &&
                  conversationItem.userID!.isNotEmpty)
              ? onlineStatus
              : null,
          draftTimestamp: conversationItem.draftTimestamp,
          convType: conversationItem.type,
          isShowDraft: false,
        ),
        onTap: () => _handleOnConvItemTaped(conversationItem),
      ))
    ]);
  }

  List<ConversationItemSlidePanel> _defaultSlideBuilder(
    V2TimConversation conversationItem,
  ) {
    final TUIThemeViewModel themeViewModel =
        serviceLocator<TUIThemeViewModel>();
    final theme = themeViewModel.theme;
    return [
      if (!PlatformUtils().isWeb)
        ConversationItemSlidePanel(
          onPressed: (context) {},
          backgroundColor:
              theme.conversationItemSliderDeleteBgColor ?? Colors.red,
          foregroundColor: theme.conversationItemSliderTextColor,
          label: TIM_t("关知"),
          spacing: 0,
          autoClose: true,
        ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _pinConversation(conversationItem);
        },
        backgroundColor:
            theme.conversationItemSliderPinBgColor ?? CommonColor.infoColor,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
      ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _deleteConversation(conversationItem);
        },
        backgroundColor:
            theme.conversationItemSliderDeleteBgColor ?? Colors.red,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: TIM_t("删除"),
      ),
      ConversationItemSlidePanel(
        onPressed: (context) {},
        backgroundColor: theme.conversationItemSliderClearBgColor ??
            CommonColor.primaryColor,
        foregroundColor: theme.conversationItemSliderTextColor,
        label: TIM_t("归档"),
        spacing: 0,
        autoClose: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    judgeGuide('conversation', context);
    return Column(
      children: [
        SearchEntry(
          conversationController: widget.conversationController,
          plusType: PlusType.create,
          onClickSearch: widget.onClickSearch,
          directToChat: (conversation) {
            Future.delayed(const Duration(milliseconds: 1), () {
              _handleOnConvItemTaped(conversation);
              _controller.selectedConversation = widget.selectedConversation;
            });
          },
        ),
        // Expanded(
        //   child: TIMUIKitConversation(
        //     itemSlideBuilder: _defaultSlideBuilder,
        //     itemBuilder: _itemBuilder,
        //     onTapItem: _handleOnConvItemTaped,
        //     isShowOnlineStatus: localSetting.isShowOnlineStatus,
        //     lastMessageBuilder: (lastMsg, groupAtInfoList) {
        //       if (lastMsg != null &&
        //           lastMsg.elemType == MessageElemType.V2TIM_ELEM_TYPE_CUSTOM) {
        //         return renderCustomMessage(lastMsg, context);
        //       }
        //       return null;
        //     },
        //     controller: _controller,
        //     emptyBuilder: () {
        //       return Container(
        //         padding: const EdgeInsets.only(top: 100),
        //         child: Center(
        //           child: Text(TIM_t("暂无会话")),
        //         ),
        //       );
        //     },
        //   ),
        // )
        Expanded(
            child: Container(
          child: const ChatList(),
        ))
      ],
    );
  }
}
