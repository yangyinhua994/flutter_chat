/*
 * @discripe: 直播
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class LiveRoomPlayer extends StatefulWidget {
  final String playUrl;

  const LiveRoomPlayer({Key? key, required this.playUrl}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LivePlayState();
}

class _LivePlayState extends State<LiveRoomPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Container(color: Colors.black.withOpacity(0.7));
    }
    return Container(
        color: Colors.black.withOpacity(0.7),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Text(
                    TIM_t("主播暂未开播"),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
