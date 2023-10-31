import 'package:flutter/foundation.dart';

import '../../model/message.dart';

class ChatDataProvider extends ChangeNotifier {
  final List<Message> _messages = [];


  late final List<String> _selectedMessageIds = [];

  List<Message> get messages => _messages;

  int _selectedNum = 0;

  bool _showEditBox = false;

  bool _showDelBox = false;

  bool _showSelectIcon = false;

  //index 0好友 1群聊
  List delStyleNum = [0, 0];

  void addSelectedMessageIds(String id){
    _selectedMessageIds.add(id);
    notifyListeners();
  }

  void removeSelectedMessageIds(String id){
    _selectedMessageIds.remove(id);
    notifyListeners();
  }

  //更新存档，自动判断选择的列表并存档
  void updateArchive() {
    for (var i = 0; i < _messages.length; i++) {
      Message newMessage = _messages[i];
      for (var selectedMessageId in _selectedMessageIds) {
        if (newMessage.id == selectedMessageId) {
          newMessage.isArchive = true;
          _messages[i] = newMessage;
          continue;
        }
      }
    }
    notifyListeners();
  }

  void addMessages(List<Message> messages) {
    for (var message in messages) {
      if (!_messages.any((existingMessage) => existingMessage.id == message.id)) {
        // 不存在具有相同id的消息，可以添加它
        _messages.add(message);
      } else {
        // 存在相同id的消息，您可以选择更新旧消息或跳过
        // 例如，更新旧消息：
        int index = _messages.indexWhere((existingMessage) => existingMessage.id == message.id);
        _messages[index] = message; // 替换旧消息
      }
    }
    notifyListeners();
  }


  void selectedNumAdd() {
    _selectedNum++;
    notifyListeners();
  }

  void selectedNumMinus() {
    _selectedNum--;
    notifyListeners();
  }

  int getSelectedNum() {
    return _selectedNum;
  }

  void setShowSelectIcon(bool state) {
    _showSelectIcon = state;
    notifyListeners();
  }

  bool isShowSelectIcon() {
    return _showSelectIcon;
  }

  void setShowEditBox(bool state) {
    _showEditBox = state;
    _showDelBox = !state;
    notifyListeners();
  }

  bool isShowEditBox() {
    return _showEditBox;
  }

  void setShowDelBox(bool state) {
    _showDelBox = state;
    _showEditBox = !state;
    notifyListeners();
  }

  bool isShowDelBox() {
    return _showDelBox;
  }

  void removeSelectedById() {
    int singlePerson = delStyleNum[0];
    int groupChat = delStyleNum[1];
    for (var i = 0; i < _messages.length; i++) {
      Message message = _messages[i];
      for (var value in _selectedMessageIds) {
        if (message.id == value) {
          _messages.removeAt(i);
          if (message.style == 1) {
            singlePerson++;
          } else if (message.style == 2) {
            groupChat++;
          }
          continue;
        }
      }
    }
    // for (var selectedMessageId in _selectedMessageIds) {
    //
    //   _messages.removeWhere((message) => message.id == selectedMessageId);
    // }
    delStyleNum[0] = singlePerson;
    delStyleNum[1] = groupChat;
    _selectedNum = 0;
    _selectedMessageIds.clear();
    notifyListeners();
  }

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  List<Message> getMessageList() {
    return _messages;
  }

  void addSelectedMessageId(String id) {
    _selectedMessageIds.add(id);
    notifyListeners();
  }

  List<String> getSelectedMessageIds() {
    return _selectedMessageIds;
  }

  void loadInitialData() {}

  void clearSelected() {
    for (var value in messages) {
      value.isSelected = false;
    }
  }
}
