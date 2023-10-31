import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tencent_cloud_chat_demo/src/chat.dart';
import 'package:tencent_cloud_chat_demo/src/provider/chat/ChatDataProvider.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'model/message.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final fontColorBlue = Color(int.parse('0xFF2A89FF'));
  final fontColorBlack = Color(int.parse('0xFF000000'));
  final double chatPaddingAll = 10;
  final double chatMarginAll = 10;
  final double chatMarginTop = 10;
  final double chatListMarginAll = 10;
  final double chatListRightIconWidthHeight = 30;
  final double chatListSmallIconHeight = 30;
  final double chatListSmallIconWidth = 20;

  late V2TimConversation selectedConversation;
  late List<Message> messages = [];

  @override
  void initState() {
    getConversation();
    getConversationList();
  }

  getConversation() async {
    //获取指定会话
    V2TimValueCallback<V2TimConversation> getConversationtRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversation(
                conversationID:
                    "c2c_2"); //会话唯一 ID，如果是 C2C 单聊，组成方式为 c2c_userID，如果是群聊，组成方式为 group_groupID
    if (getConversationtRes.code == 0) {
      //拉取成功
      selectedConversation = getConversationtRes.data!;
    }
    setState(() {});
  }

  getConversationList() async {
    //获取会话列表
    V2TimValueCallback<V2TimConversationResult> getConversationListRes =
        await TencentImSDKPlugin.v2TIMManager
            .getConversationManager()
            .getConversationList(
                count: 100, //分页拉取的个数，一次分页拉取不宜太多，会影响拉取的速度，建议每次拉取 100 个会话
                nextSeq: "0" //分页拉取的游标，第一次默认取传 0，后续分页拉传上一次分页拉取成功回调里的 nextSeq
                );
    if (getConversationListRes.code == 0) {
      //拉取成功
      bool? isFinished = getConversationListRes.data?.isFinished; //是否拉取完
      String? nextSeq = getConversationListRes.data?.nextSeq; //后续分页拉取的游标
      List<V2TimConversation?>? conversationList =
          getConversationListRes.data?.conversationList; //此次拉取到的消息列表
      //如果没有拉取完，使用返回的nextSeq继续拉取直到isFinished为true
      if (!isFinished!) {
        V2TimValueCallback<V2TimConversationResult> nextConversationListRes =
            await TencentImSDKPlugin.v2TIMManager
                .getConversationManager()
                .getConversationList(
                    count: 100,
                    nextSeq: nextSeq = "0"); //使用返回的nextSeq继续拉取直到isFinished为true
      }

      getConversationListRes.data?.conversationList?.forEach((element) {
        if (element != null) {
          Message message = Message(v2timConversation: element);
          message.lastMessageTime = '10/23';
          message.iconsPath = ['assets/chat/靓.png', 'assets/chat/奖杯.png'];
          message.id = element.userID!;
          message.userProfilePath = element.faceUrl!;
          message.lastMessage = element.lastMessage!;
          messages.add(message);
        }
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ChatDataProvider chatDataProvider =
        Provider.of<ChatDataProvider>(context, listen: false);
    chatDataProvider.addMessages(messages);
    chatDataProvider.addListener(() {
      setState(() {});
    });
    if (messages.isNotEmpty) {
      return Container(
        margin: EdgeInsets.all(chatMarginAll),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: chatDataProvider.messages.length,
              itemBuilder: (context, index) {
                Message message = chatDataProvider.messages[index];
                return Slidable(
                  child: ChatItem(
                    selectedConversation: selectedConversation,
                    message: message,
                  ),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (BuildContext context) => print('关闭通知被点击'),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.notifications_off,
                        label: '关闭通知',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) => print('置顶被点击'),
                        backgroundColor: const Color(0xFF6991C7),
                        foregroundColor: Colors.white,
                        icon: Icons.push_pin,
                        label: '置顶',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) => print('删除被点击'),
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: '删除',
                      ),
                      SlidableAction(
                        onPressed: (BuildContext context) => print('归档被点击'),
                        backgroundColor: const Color(0xFF5F7161),
                        foregroundColor: Colors.white,
                        icon: Icons.archive,
                        label: '归档',
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
    return Container();
  }
}

class ChatListSlidable extends StatefulWidget {
  const ChatListSlidable({super.key});

  @override
  State<ChatListSlidable> createState() => _ChatListSlidableState();
}

class _ChatListSlidableState extends State<ChatListSlidable> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ChatListLine extends StatelessWidget {
  const ChatListLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      height: 0.5,
      margin: const EdgeInsets.fromLTRB(120, 0, 0, 0),
    );
  }
}

class ChatItem extends StatefulWidget {
  const ChatItem(
      {super.key, required this.selectedConversation, required this.message});

  final V2TimConversation selectedConversation;
  final Message message;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  final fontColorBlue = Color(int.parse('0xFF2A89FF'));
  final fontColorBlack = Color(int.parse('0xFF000000'));
  final double chatPaddingAll = 10;
  final double chatMarginAll = 10;
  final double chatMarginTop = 10;
  final double chatListMarginAll = 10;
  final double chatListRightIconWidthHeight = 30;
  final double chatListSmallIconHeight = 30;
  final double chatListSmallIconWidth = 20;

  @override
  Widget build(BuildContext context) {
    ChatDataProvider chatDataProvider =
        Provider.of<ChatDataProvider>(context, listen: false);
    chatDataProvider.addListener(() {
      setState(() {});
    });

    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Chat(
                            selectedConversation: widget.selectedConversation,
                          )));
            },
            title: Column(
              children: [
                Row(
                  children: [
                    // 选中图标
                    if (chatDataProvider.isShowSelectIcon())
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // widget.message.isSelected
                            //     ? chatDataProvider.selectedMessageIds
                            //         .remove(widget.message.id)
                            //     : chatDataProvider.selectedMessageIds
                            //         .add(widget.message.id);
                            widget.message.isSelected =
                                !widget.message.isSelected;
                          });
                        },
                        icon: widget.message.isSelected
                            ? Image.asset('assets/chat/svip1.png')
                            : Image.asset('assets/chat/奖杯.png'),
                      ),
                    // 头像
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.xiaohongshu.com/d384c57c-1e61-4155-b33d-bf486247db59'),
                    ),
                    // 用户名和内容
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(chatPaddingAll),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.message.v2timConversation!.showName
                                      .toString(),
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(width: 8),
                                ...widget.message.iconsPath.map((iconPath) {
                                  return Image.asset(iconPath,
                                      height: chatListSmallIconHeight,
                                      width: chatListSmallIconWidth);
                                }),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                if (widget.message.lastMessage?.elemType == 1)
                                  Text(
                                    widget.message.lastMessage!.textElem!.text
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // 中间图标栏
                    Column(
                      children: [
                        Row(
                          children: [
                            if (widget.message.rightIconPath1.isNotEmpty)
                              Image.asset(
                                widget.message.rightIconPath1,
                                width: chatListRightIconWidthHeight,
                                height: chatListRightIconWidthHeight,
                              ),
                            if (widget.message.rightIconPath2.isNotEmpty)
                              Image.asset(
                                widget.message.rightIconPath2,
                                width: chatListRightIconWidthHeight,
                                height: chatListRightIconWidthHeight,
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            if (widget.message.rightIconPath3.isNotEmpty)
                              Image.asset(
                                widget.message.rightIconPath3,
                                width: chatListRightIconWidthHeight,
                                height: chatListRightIconWidthHeight,
                              ),
                            if (widget.message.rightIconPath4.isNotEmpty)
                              Image.asset(
                                widget.message.rightIconPath4,
                                width: chatListRightIconWidthHeight,
                                height: chatListRightIconWidthHeight,
                              ),
                          ],
                        ),
                      ],
                    ),
                    // 右侧时间和未读消息条数
                    Column(
                      children: [
                        Row(
                          children: [
                            if (widget.message.lastMessageTime.isNotEmpty)
                              Text(widget.message.lastMessageTime),
                          ],
                        ),
                        if (widget.message.unreadMessages != 0)
                          Row(
                            children: [
                              Chip(
                                label: Text(
                                  '${widget.message.unreadMessages.toString()}k',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                backgroundColor: Colors.blue,
                              )
                            ],
                          )
                      ],
                    )
                  ],
                ),
                const ChatListLine(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({super.key, required this.iconPath, required this.text});

  final String iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(iconPath),
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 18),
        )
      ],
    );
  }
}
