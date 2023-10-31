import 'package:tencent_cloud_av_chat_room/tencent_cloud_chat_sdk_type.dart';

class Message implements Comparable<Message> {
  String id;
  String userProfilePath;
  String username;
  String lastMessageStr;
  V2TimMessage? lastMessage;
  String lastMessageTime;

  int unreadMessages;

  //是否为好友
  bool friend;
  //置顶消息
  String topMsg;

  //类型， 1单人 2群聊
  int style;

  //是否是归档栏
  bool isArchive;

  List<String> iconsPath;

  //右侧图标1
  String rightIconPath1;
  String rightIconPath2;
  String rightIconPath3;
  String rightIconPath4;

  //是否免打扰
  bool isDoNotDisturb;

  //是否选中
  bool isSelected;

  //是否选中
  bool showSelectIcon;

  //置顶
  bool isTopping;

  V2TimConversation? v2timConversation;

  DateTime toppingTime = DateTime.utc(0);

  Message({
    this.id = '-1',
    this.userProfilePath = '',
    this.username = 'chat',
    this.lastMessageStr = '没有消息记录',
    this.lastMessageTime = '',
    this.unreadMessages = 5,
    this.style = 1,
    this.isArchive = false,
    this.iconsPath = const [],
    this.rightIconPath1 = '',
    this.rightIconPath2 = '',
    this.rightIconPath3 = '',
    this.rightIconPath4 = '',
    this.isDoNotDisturb = false,
    this.isTopping = false,
    this.isSelected = false,
    this.v2timConversation,
    this.lastMessage,
    this.showSelectIcon = false,
    this.friend = true,
    this.topMsg = '',
  });

  void setToppingTimeNow() {
    toppingTime = DateTime.now();
  }

  void setToppingTime(DateTime dateTime) {
    toppingTime = dateTime;
  }

  @override
  int compareTo(Message other) {
    return toppingTime.compareTo(other.toppingTime);
  }
}
